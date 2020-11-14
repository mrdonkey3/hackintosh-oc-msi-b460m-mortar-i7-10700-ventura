#!/bin/sh

# A script to read an interpret a disk's boot/partition sectors.
# Copyright (C) 2013-2020 Blackosx <darwindumper@yahoo.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# =======================================================================
#
# This script:
# 1- gathers information about the available disks, partitions,
# volumes, and bootloaders on the system. The information is then saved
# to a temporary file for later processing by the main DarwinDumper script.
#
# 2 - dumps any bootloader user config files it finds in an Extra or EFI
# folder at the same path as a found boot file.
#
# 3 - dumps the volume UUID's and GUID's to a UIDs.txt file.
#
# The idea for identifying boot sector code was taken from the original
# Chameleon package installer script where it checked for the existence of
# LILO. I'd since added further checks for the different stage0 versions
# and the windows disk signature to the later chameleon package installer
# scripts - see for example CheckDiskMicrocode.sh.
#
# It's been tested on 10.5, 10.6, 10.7 & 10.8. I'm aware of one issue
# under 10.5 where the disk size of the first disk has been shown as
# zero size but I've been unable to reproduce this behaviour.
#
# I would like to add detection for more stage 0 loaders, for example
# GRUB and anything else that people use in make the script more concise.
#
# Also note, that the current detection for existing known loaders is
# based on matching against known hex values so it relies on the code
# staying the same. If then, for example, the Chameleon boot0 code
# changes then it could affect identification.
#
# *************************************************************************************
# The script requires 4 arguments passed to it when called.
# 1 - Path    : Directory to save dumps
# 2 - 1 or 0  : Dump bootloader configuration files.
#               Creates a folder named BootloaderConfigFiles and in that, copies the
#               complete folder structure(s) leading to a pre-defined config file.
# 3 - 1 or 0  : Dump diskutil list & identify known bootloader code.
#               This option creates the following .txt files:
#               Hex dump of each disks' boot and partition sectors (1 file per disk).
#               diskutil list result.
#               /tmp/diskutilLoaderInfo.txt (an intermediary file for later processing).
# 4 - 1 or 0  : Dump disk partition table information and disk/volume UUIDs.
#               Creates a .txt file for each disk and a file named UIDs.txt
#
# Note: 1 enables the routine, 0 disables the routine.
# *************************************************************************************
#
# Thanks to STLVNUB, Slice and dmazar for extensive testing, bug fixing & suggestions
#
# ---------------------------------------------------------------------------------------
Initialise()
{
    # get the absolute path of the executable
    SELF_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && SELF_PATH=$SELF_PATH/$(basename -- "$0")
    source "${SELF_PATH%/*}"/shared.sh

    declare -a openCoreEfiFiles

    # String arrays for storing diskutil info.
    declare -a duContent
    declare -a duSize
    declare -a duVolumeName
    declare -a duIdentifier
    declare -a duWholeDisks
    declare -a allDisks

    # String arrays for storing APFS diskutil info.
    declare -a diskUtilApfsPlist
    declare -a diskUtilApfsContainers
    declare -a diskUtilApfsContainerRefs
    declare -a diskUtilApfsPhysicalStores
    declare -a diskUtilApfsVolumes
    declare -a diskUtilApfsVolumeSizes
    declare -a diskUtilApfsDeviceIdentifiers
    declare -a tmpDevIds

    # If running this script locally then set BootSectDir,
    # otherwise get BootSectDir from passed argument.
    if [ "$1" == "" ]; then
        dumpFolderPath="${SELF_PATH}"
    else
        dumpFolderPath="$1"
    fi

    if [ "$2" == "0" ]; then
        gDiskLoaderConfigs=0
    else
        gDiskLoaderConfigs=1
        SendToUI "@DF@S:diskLoaderConfigs@"
    fi
    if [ "$3" == "0" ]; then
        gBootLoaderBootSectors=0
    else
        gBootLoaderBootSectors=1
        SendToUI "@DF@S:bootLoaderBootSectors@"
    fi
    if [ "$4" == "0" ]; then
        gDiskPartitionInfo=0
    else
        gDiskPartitionInfo=1
        SendToUI "@DF@S:diskPartitionInfo@"
    fi

    fdisk440="$TOOLS_DIR/fdisk440"
    bgrep="$TOOLS_DIR/bgrep"

    # Resources - Scripts
    bdisk="$SCRIPTS_DIR/bdisk.sh"
    findOpenCoreVersion="$SCRIPTS_DIR/findOpenCoreVersion.sh"

    gBootloadersTextBuildFile=""
    gXuidBuildFile="Device@Name@Volume UUID@Unique partition GUID"
    gXuidBuildFile="$gXuidBuildFile \n"
    gXuidBuildFile="$gXuidBuildFile"$(printf " @ @(Example Usage: Kernel flag rd=uuid boot-uuid=)@(Example Usage: Clover Hide Volume)\n")
    gXuidBuildFile="$gXuidBuildFile \n"

    gESPMountPrefix="ddTempMp"
    UefiFileMatchList="$DATA_DIR/uefi_loaders.txt"
    gUefiKnownFiles=( $( < "$UefiFileMatchList" ) )
    gRootPriv=0
    gSystemVersion=$(CheckOsVersion)    
}

# ---------------------------------------------------------------------------------------
CheckRoot()
{
    if [ "`whoami`" != "root" ]; then
        #echo "Running this requires you to be root."
        #sudo "$0"
        gRootPriv=0
    else
        gRootPriv=1
    fi
}

# ---------------------------------------------------------------------------------------
DumpDiskUtilAndLoader()
{
    local checkSystemVersion
    local activeSliceNumber
    local diskPositionInArray
    local mbrBootCode
    local pbrBootCode
    local partitionActive
    local targetFormat
    local mountPointWasCreated
    local efiMountedIsVerified
    local espWasMounted=0
    local gpt=0
    local mounted
    local byteFiveTen=""
    local diskUtilInfoDump=""
    local fileSystemPersonality=""
    local mediaName=""
    local volumeName=""
    local partitionname=""
    local diskSectorDumpFile=""
    local diskUtilLoaderInfoFile="$TEMPDIR"/diskutilLoaderInfo.txt
    local tmpDiskSectorDir="$TEMPDIR"/diskSectors
    local xuidFile="$gDumpFolderDisks"/UIDs.txt

    # ---------------------------------------------------------------------------------------
    ConvertUnitPreSL()
    {
        local passedNumber="$1"
        local numberLength=$( echo "${#passedNumber}")
        local convertedNumber

        if [ $numberLength -le 15 ] && [ $numberLength -ge 13 ]; then # TB
            convertedNumber=$(((((passedNumber/1024)/1024)/1024)/1024))" TB"
        elif [ $numberLength -le 12 ] && [ $numberLength -ge 10 ]; then # GB
            convertedNumber=$((((passedNumber/1024)/1024)/1024))" GB"
        elif [ $numberLength -le 9 ] && [ $numberLength -ge 7 ]; then # MB
            convertedNumber=$(((passedNumber/1024)/1024))" MB"
        elif [ $numberLength -le 6 ] && [ $numberLength -ge 4 ]; then # KB
            convertedNumber=$((passedNumber/1024))" KB"
        fi
        echo "$convertedNumber"
    }

    # ---------------------------------------------------------------------------------------
    ConvertUnit()
    {
        local passedNumber="$1"
        local numberLength=$( echo "${#passedNumber}")
        local convertedNumber

        if [ $numberLength -le 15 ] && [ $numberLength -ge 13 ]; then # TB
            convertedNumber=$((passedNumber/1000000000000))" TB"
        elif [ $numberLength -le 12 ] && [ $numberLength -ge 10 ]; then # GB
            convertedNumber=$((passedNumber/1000000000))" GB"
        elif [ $numberLength -le 9 ] && [ $numberLength -ge 7 ]; then # MB
            convertedNumber=$((passedNumber/1000000))" MB"
        elif [ $numberLength -le 6 ] && [ $numberLength -ge 4 ]; then # KB
            convertedNumber=$((passedNumber/100))" KB"
        fi
        echo "$convertedNumber"
    }

    # ---------------------------------------------------------------------------------------
    # Function to search for key in plist and return all associated strings in an array.
    # Will find multiple matches
    FindMatchInPlist()
    {
        local keyToFind="$1"
        local typeToFind="$2"
        declare -a plistToRead=("${!3}")
        local stopAfterFirstMatch="$4"
        local foundSection=0

        for (( n=0; n<${#plistToRead[@]}; n++ ))
        do
            [[ "${plistToRead[$n]}" == *"<key>$keyToFind</key>"* ]] && foundSection=1
            if [ $foundSection -eq 1 ]; then
                [[ "${plistToRead[$n]}" == *"</array>"* ]] || [[ "${plistToRead[$n]}" == *"</dict>"* ]] && foundSection=0
                if [[ "${plistToRead[$n]}" == *"$typeToFind"* ]]; then
                    tmp=$( echo "${plistToRead[$n]#*>}" )
                    tmp=$( echo "${tmp%<*}" )
                    tmpArray+=("$tmp")
                    [[ $stopAfterFirstMatch -eq 1 ]] && foundSection=0
                fi
            fi
        done
    }

    # ---------------------------------------------------------------------------------------
    # Function to search for key in plist and return all associated strings in an array.
    # Will only find a single match
    FindMatchInSlicePlist()
    {
        local keyToFind="$1"
        local typeToFind="$2"
        declare -a plistToRead=("${!3}")
        local foundSection=0

        for (( n=0; n<${#plistToRead[@]}; n++ ))
        do
            [[ "${plistToRead[$n]}" == *"<key>$keyToFind</key>"* ]] && foundSection=1
            if [ $foundSection -eq 1 ]; then
                [[ "${plistToRead[$n]}" == *"</array>"* ]] || [[ "${plistToRead[$n]}" == *"</dict>"* ]] || [[ ! "${plistToRead[$n]}" == *"<key>$keyToFind</key>"* ]] && foundSection=0
                if [[ "${plistToRead[$n]}" == *"$typeToFind"* ]]; then
                    tmp=$( echo "${plistToRead[$n]#*>}" )
                    tmp=$( echo "${tmp%<*}" )

                    if [ "$tmp" == EF57347C-0000-11AA-AA11-00306543ECAC ]; then
                        tmp="APFS Container Scheme"
                    fi

                    if [ "$tmp" == 41504653-0000-11AA-AA11-00306543ECAC ]; then
                        tmp="APFS Volume"
                    fi

                    tmpArray+=("$tmp")
                    echo "$tmp" # return to caller
                    break
                fi
            fi
        done
    }

    # ---------------------------------------------------------------------------------------
    BuildDiskUtilStringArrays()
    {

        # Six global string arrays are used for holding the disk information
        # that the DumpDiskUtilAndLoader() function walks through and uses.
        # They are declared in function Initialise().

        # Build list of APFS details

        oIFS="$IFS"; IFS=$'\n'
        diskUtilApfsPlist=( $( diskutil APFS list -plist ))
        IFS="$oIFS"

        FindMatchInPlist "APFSContainerUUID" "string" "diskUtilApfsPlist[@]" "1"
        diskUtilApfsContainers=("${tmpArray[@]}")

        unset tmpArray
        FindMatchInPlist "ContainerReference" "string" "diskUtilApfsPlist[@]" "1"
        diskUtilApfsContainerRefs=("${tmpArray[@]}")

        unset tmpArray
        FindMatchInPlist "DesignatedPhysicalStore" "string" "diskUtilApfsPlist[@]" "1"
        diskUtilApfsPhysicalStores=("${tmpArray[@]}")

        unset tmpArray
        FindMatchInPlist "Name" "string" "diskUtilApfsPlist[@]" "1"
        diskUtilApfsVolumes=("${tmpArray[@]}")

        unset tmpArray
        FindMatchInPlist "CapacityInUse" "integer" "diskUtilApfsPlist[@]" "1"
        diskUtilApfsVolumeSizes=("${tmpArray[@]}")

        unset tmpArray
        FindMatchInPlist "DeviceIdentifier" "string" "diskUtilApfsPlist[@]" "1"
        tmpDevIds=("${tmpArray[@]}")

        # Remove any Physical Stores from Device Identifiers array
        for devId in "${tmpDevIds[@]}"
        do
            found=0
            for pStore in "${diskUtilApfsPhysicalStores[@]}"
            do
                [[ $devId == $pStore ]] && found=1 && break
            done
            [[ $found -eq 0 ]] && diskUtilApfsDeviceIdentifiers+=($devId)
        done
        unset tmpDevIds

        # Example array content
        # =====================
        # diskUtilApfsContainers[0] = 76F74C00-330F-4F9B-951F-071C1FA78CCE

        # diskUtilApfsContainerRefs[0] = disk1

        # diskUtilApfsPhysicalStores[0] = disk0s2

        # diskUtilApfsVolumeSizes[0] = 173560754176
        # diskUtilApfsVolumeSizes[1] = 105263104
        # diskUtilApfsVolumeSizes[2] = 1036820480
        # diskUtilApfsVolumeSizes[3] = 2148577280
        # diskUtilApfsVolumeSizes[4] = 1097728
        # diskUtilApfsVolumeSizes[5] = 84482220032
        # diskUtilApfsVolumeSizes[6] = 11146051584

        # diskUtilApfsDeviceIdentifiers[0] = disk1s1
        # diskUtilApfsDeviceIdentifiers[1] = disk1s2
        # diskUtilApfsDeviceIdentifiers[2] = disk1s3
        # diskUtilApfsDeviceIdentifiers[3] = disk1s4
        # diskUtilApfsDeviceIdentifiers[4] = disk1s5
        # diskUtilApfsDeviceIdentifiers[5] = disk1s6
        # diskUtilApfsDeviceIdentifiers[6] = disk1s7

        # Check counts. There should be (num Containers) less (num volumes) than (num device identifiers)
        if [ ${#diskUtilApfsVolumes[@]} -ne ${#diskUtilApfsVolumeSizes[@]} ] && /
           [ ${#diskUtilApfsVolumes[@]} -ne ${#diskUtilApfsDeviceIdentifiers[@]} ] && /
           [ ${#diskUtilApfsVolumes[@]} -ne ${#diskUtilApfsVolumeSizes[@]} ]; then
   
            echo "*Error: Number of volumes inconsistent with number of device identifiers"
            echo "totalVolumes=${#diskUtilApfsVolumes[@]} | totalSizes=${#diskUtilApfsVolumeSizes[@]} | totalDeviceIds=${#diskUtilApfsDeviceIdentifiers[@]} | totalContainers=$totalContainers"
            exit 1
        fi

        # Build list as before

        declare -a tmpArray
        declare -a diskUtilPlist
        declare -a allDisks
        declare -a WholeDisks
        declare -a diskUtilSliceInfo

        local checkSystemVersion
        local recordAdded=0
        local humanSize=0
        local oIFS="$IFS"
        IFS=$'\n'

        # print feedback to command line.
        echo "Reading disk information..."

        # Read Diskutil command in to array rather than write to file.
        diskUtilPlist=( $( diskutil list -plist ))

        unset tmpArray
        FindMatchInPlist "AllDisks" "string" "diskUtilPlist[@]" "0"
        allDisks=("${tmpArray[@]}")

        unset tmpArray
        FindMatchInPlist "WholeDisks" "string" "diskUtilPlist[@]" "0"
        wholeDisks=("${tmpArray[@]}")

        for (( s=0; s<${#allDisks[@]}; s++ ))
        do
            if [[ "${allDisks[$s]}" == *disk* ]]; then
                duIdentifier+=("${allDisks[$s]}")
                unset diskUtilSliceInfo
                diskUtilSliceInfo=( $( diskutil info -plist /dev/${duIdentifier[$s]} ))

                # Read and save Content
                tmp=$( FindMatchInSlicePlist "Content" "string" "diskUtilSliceInfo[@]" )
                duContent+=("$tmp")

                # Read and save VolumeName
                tmp=$( FindMatchInSlicePlist "VolumeName" "string" "diskUtilSliceInfo[@]" )

                if [ ! "${tmp}" == "" ]; then
                    duVolumeName+=( "${tmp}" )
                else
                    if [ ${duContent[$s]} == "Apple_APFS" ]; then
                        # Is this device identifier a physical store?
                        for (( c=0; c<${#diskUtilApfsPhysicalStores[@]}; c++ ))
                        do
                            if [ "${diskUtilApfsPhysicalStores[$c]}" == "${allDisks[$s]}" ]; then
                              duVolumeName+=("Container ${diskUtilApfsContainerRefs[$c]}")
                              break
                            fi
                        done
                    else
                        duVolumeName+=(" ")
                    fi
                fi

                # Read and save TotalSize
                if [ ! ${duContent[$s]} == "APFS Volume" ]; then
                    tmp=$( FindMatchInSlicePlist "TotalSize" "integer" "diskUtilSliceInfo[@]" )
                else
                    for (( c=0; c<${#diskUtilApfsDeviceIdentifiers[@]}; c++ ))
                    do
                        if [ "${diskUtilApfsDeviceIdentifiers[$c]}" == "${allDisks[$s]}" ]; then
                          tmp="${diskUtilApfsVolumeSizes[$c]}"
                          break
                        fi
                    done
                fi

                if [ $gSystemVersion -gt 9 ]; then
                    humanSize=$(ConvertUnit "${tmp}")
                else
                    humanSize=$(ConvertUnitPreSL "${tmp}")
                fi

                duSize+=("$humanSize")

                (( recordAdded++ ))
            fi
        done

        # Add content to duWholeDisks array.. Why do I need this?
        for (( n=0; n<${#wholeDisks[@]}; n++ ))
        do
            if [[ "${wholeDisks[$n]}" == *disk* ]]; then
                duWholeDisks+=("${wholeDisks[$n]#*    }")
            fi
        done

        # Before leaving, check all string array lengths are equal.
        if [ ${#duVolumeName[@]} -ne $recordAdded ] || [ ${#duContent[@]} -ne $recordAdded ] || [ ${#duSize[@]} -ne $recordAdded ] || [ ${#duIdentifier[@]} -ne $recordAdded ]; then
            echo "Error- Disk Utility string arrays are not equal lengths!"
            echo "records=$recordAdded V=${#duVolumeName[@]} C=${#duContent[@]} S=${#duSize[@]} I=${#duIdentifier[@]}"
            exit 1
        fi

        # DEBUG - Dump content of all arrays to file
#         for (( s=0; s<$recordAdded; s++ ))
#         do
#           echo "duContent:${duContent[$s]}" #>> ~/Desktop/list.duContent.txt
#           echo "duVolumeName:${duVolumeName[$s]}" #>> ~/Desktop/list_duVolumeName.txt
#           echo "duSize:${duSize[$s]}" #>> ~/Desktop/list.duSize.txt
#           echo "duIdentifier:${duIdentifier[$s]}" #>> ~/Desktop/list.duIdentifier.txt
#           echo "-----------------------"
#         done
# 
#         exit 1

    }

    # ---------------------------------------------------------------------------------------
    BuildXuidTextFile()
    {
        local passedTextLine="$1"

        if [ ! "$passedTextLine" == "" ]; then
            gXuidBuildFile="$gXuidBuildFile"$(printf "$passedTextLine\n")
            gXuidBuildFile="$gXuidBuildFile \n"
        fi
    }

   # ---------------------------------------------------------------------------------------
    GrabXUIDs()
    {
        local passedIdentifier="$1"
        local passedVolumeName="$2"
        local volumeNameToDisplay=""

        local uuid=$( Diskutil info /dev/$passedIdentifier | grep "Volume UUID:" | awk '{print $3}' )
        local guid=$( ioreg -lxw0 | grep -C 10 $passedIdentifier | sed -ne 's/.*UUID" = //p' | tr -d '"' | head -n1 )

        if [ "$passedVolumeName" == "" ]; then

            # check if device identifier is APFS physical store
            for (( g=0; g<${#diskUtilApfsPhysicalStores[@]}; g++ ))
            do
                if [ "${diskUtilApfsPhysicalStores[$g]}" == "$passedIdentifier" ]; then
                    volumeNameToDisplay="APFS Container ${diskUtilApfsContainerRefs[$g]}"
                    break
                fi
            done

            # check if device identifier is APFS container ref
            for (( g=0; g<${#diskUtilApfsContainerRefs[@]}; g++ ))
            do
                if [ "${diskUtilApfsContainerRefs[$g]}" == "$passedIdentifier" ]; then
                    volumeNameToDisplay="APFS Container Scheme [Physical Store: ${diskUtilApfsPhysicalStores[$g]}]"
                    break
                fi
            done

            # check if device identifier is APFS device
            for (( g=0; g<${#diskUtilApfsDeviceIdentifiers[@]}; g++ ))
            do
                if [ "${diskUtilApfsDeviceIdentifiers[$g]}" == "$passedIdentifier" ]; then
                    volumeNameToDisplay="/Volumes/${diskUtilApfsVolumes[$g]}"
                    break
                fi
            done

        else

            volumeNameToDisplay="/Volumes/${passedVolumeName}"

        fi

        # Check for a blank UUID and replace with spaces so the padding is correct
        # in the UIDs.txt file.
        if [ "${uuid}" == "" ]; then
            uuid="                                    "
        fi
        BuildXuidTextFile "$passedIdentifier@${volumeNameToDisplay}@${uuid}@${guid}"
    }

    # ---------------------------------------------------------------------------------------
    ConvertAsciiToHex()
    {
        # Convert ascii string to hex
        # from http://www.commandlinefu.com/commands/view/6066/convert-ascii-string-to-hex
        echo "$1" | xxd -ps | sed -e ':a' -e 's/\([0-9]\{2\}\|^\)\([0-9]\{2\}\)/\1\\x\2/;ta' | tr '[:lower:]' '[:upper:]'
    }

    # ---------------------------------------------------------------------------------------
    FindStringInExecutable()
    {
        local passedString="$1"
        local passedFile="$2"
        local selection=""

        local hexString=$( ConvertAsciiToHex "$passedString" )
        hexString="${hexString%%0A*}"

        # Find offset(hex) of passedHex in file.
        offsetH=$( "$bgrep" "$hexString" "$passedFile" )
        
        if [ "$offsetH" != "" ]; then

            # Grab 128 hex bytes from offset, removing any line breaks.
            selection=$( tail -c +$((0x${offsetH##*: }+1)) "$passedFile" | head -c 128 | xxd -p | tr -d '\n' )

            # Trim at first occurrence of 0x0A. (Chameleon uses 0x0A as terminator)
            selection="${selection%%0a*}"

            # Trim at first occurrence of 0x00. (Clover uses 0x00 as terminator)
            selection="${selection%00*}"

            # Insert \x every two chars
            selection=$( echo "$selection" | sed 's/\(..\)/\1\\x/g' )

            # Strip ending \x
            selection="${selection%%\\x}"

            # Add preceding \x
            selection="\x$selection"

            # Convert hex to ASCII
            selection=$( printf '%b\n' "$selection" )

        fi

        # Return
        echo "$selection"
    }

    # ---------------------------------------------------------------------------------------
    IsStringPresent()
    {
        local searchString="$1"
        local bootFile="$2"
        local fileContains=$( grep -l "$searchString" "$bootFile" )

        echo "$fileContains" # Return
    }

    # ---------------------------------------------------------------------------------------
    CheckForBootFiles()
    {
        local passedVolumeName="/Volumes/$1"
        local passedDevice="$2"
        local bootFileCount=0
        local bootFiles=()
        local loaderVersion=""
        local firstRead=""
        local versionInfo=""
        local refitString=""
        local oIFS="$IFS"
        local checkMagic=""

        # Start checking for filenames beginning with boot
        # ignoring any boot* files with .extensions.
        bootFileCount=`find 2>/dev/null "${passedVolumeName}"/boot* -depth 0 -type f ! -name "*.*" | wc | awk '{print $1}'`
        if [ $bootFileCount -gt 0 ]; then
            (( bootFileCount-- )) # reduce by one so for loop can run from zero.
            IFS=$'\n'
            bootFiles=( $(find "${passedVolumeName}"/boot* -depth 0 -type f ! -name "*.*" 2>/dev/null) )
            IFS="$oIFS"
            for (( b=0; b<=$bootFileCount; b++ ))
            do
                loaderVersion=""
                currentBootfile="${bootFiles[$b]}"
                if [ -f "$currentBootfile" ]; then

                    # Check file is not a stage 0 or stage 1 file
                    checkMagic=$(dd 2>/dev/null ibs=2 count=1 skip=255 if="$currentBootfile" | xxd -p)
                    if [ ! "$checkMagic" == "55aa" ]; then

                        # Try to match a string inside the boot file.
                        fileContains=$( IsStringPresent "Chameleon" "$currentBootfile" )
                        if [ ! "$fileContains" == "" ]; then
                            revision=$( FindStringInExecutable "Darwin/x86 boot" "$currentBootfile" )
                            loaderVersion="Chameleon${revision##*Chameleon}"
                        fi
                        fileContains=$( IsStringPresent "Clover" "$currentBootfile" )
                        if [ ! "$fileContains" == "" ]; then
                            revision=$( FindStringInExecutable "Clover revision:" "$currentBootfile" )
                            loaderVersion="Clover r${revision##*: }"
                        fi
                        fileContains=$( IsStringPresent "RevoBoot" "$currentBootfile" )
                        if [ ! "$fileContains" == "" ]; then
                            loaderVersion="RevoBoot"
                        fi
                        fileContains=$( IsStringPresent "Windows Boot" "$currentBootfile" )
                        if [ ! "$fileContains" == "" ]; then
                            loaderVersion="Windows Boot Manager"
                        fi
                        fileContains=$( IsStringPresent "EFILDR20" "$currentBootfile" )
                        if [ ! "$fileContains" == "" ]; then
                            loaderVersion="XPC Efildr20 loader"
                        fi
                        BuildBootLoadersTextFile "BF:${currentBootfile##*/}"
                        BuildBootLoadersTextFile "S2:$loaderVersion"
                    fi
                fi
          done
        fi
    }

    # ---------------------------------------------------------------------------------------
    CheckForEfildrFiles()
    {
        local passedVolumeName="/Volumes/$1"
        local passedDevice="$2"
        local efildFileCount=0
        local efildFiles=()
        local loaderVersion
        local oIFS="$IFS"
        local checkMagic=""

        # Start checking for filenames beginning with boot
        #ignoring any boot* files with .extensions.
        efildFileCount="$( find 2>/dev/null "${passedVolumeName}"/Efild* -type f ! -name "*.*"| wc | awk '{print $1}' )"
        if [ $efildFileCount -gt 0 ]; then
            (( efildFileCount-- )) # reduce by one so for loop can run from zero.
            IFS=$'\n'
            efildFiles=( $(find "${passedVolumeName}"/Efild* -type f ! -name "*.*" 2>/dev/null) )
            IFS="$oIFS"
            for (( b=0; b<=$efildFileCount; b++ ))
            do
                loaderVersion=""
                bytesRead=$( dd 2>/dev/null if=${efildFiles[$b]} bs=512 count=1 | perl -ne '@a=split"";for(@a){printf"%02x",ord}'  )
                if [ "${bytesRead:1020:2}" == "55" ]; then
                    case "${bytesRead:0:8}" in
                        "eb589049")
                            case "${bytesRead:286:2}" in
                                "79") loaderVersion="XPC Efildr20" ;;
                                "42") loaderVersion="EBL Efildr20" ;;
                            esac
                            ;;
                        "eb0190bd")
                            case "${bytesRead:286:2}" in
                                "3b") loaderVersion="XPC Efildgpt" ;;
                            esac
                            ;;
                    esac
                fi
                BuildBootLoadersTextFile "BF:${efildFiles[$b]##*/}"
                if [ ! "$loaderVersion" == "" ]; then
                    BuildBootLoadersTextFile "S2:$loaderVersion"
                fi
            done
        fi
    }

    # ---------------------------------------------------------------------------------------
    CheckForOpenCoreBootLog()
    {
        local passedVolumeName="/Volumes/$1"
        local passedDevice="$2"

        # Find most recent opencore-YYYY-MM-DD-HHMMSS.txt file

        local ocLogFile=$( ls -t "/Volumes/$1"/opencore-*.txt 2>/dev/null | head -1 )

        if [ -n "$ocLogFile" ]; then

          ocLogFileName=$(basename "$ocLogFile")
          ocLogFileDate="${ocLogFileName%.*}"
          ocLogFileDate="${ocLogFileDate##*opencore-}"

          if [ "${#ocLogFileDate}" -eq 17 ]; then

            WriteToLog "${gLogIndent}Found OpenCore log file: $ocLogFile"

            ocLogFileYYYY="${ocLogFileDate:0:4}"
            ocLogFileMO="${ocLogFileDate:5:2}"
            ocLogFileDD="${ocLogFileDate:8:2}"
            ocLogFileHH="${ocLogFileDate:11:2}"
            ocLogFileMM="${ocLogFileDate:13:2}"
            ocLogFileSS="${ocLogFileDate:15:2}"

            # Get system boot time
            bt=$(sysctl -n kern.boottime | sed 's/^.*} //')

            # Split in to parts for refactoring
            bTm=$(echo "$bt" | awk '{print $2}')
            bTd=$(echo "$bt" | awk '{print $3}')
            bTd=$(printf %02d $bTd)

            bTt=$(echo "$bt" | awk '{print $4}')
            bTy=$(echo "$bt" | awk '{print $5}')

            bTm=$(awk -v "month=$bTm" 'BEGIN {months = "Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"; print (index(months, month) + 3) / 4}')
            bTm=$(printf %02d $bTm)

            # Note: Current system bios time may differ
            # See if found OpenCore log file date at least matches current year, month and day

            if [ "$ocLogFileYYYY" == "$bTy" ] && [ "$ocLogFileMO" == "$bTm" ] && [ "$ocLogFileDD" == "$bTd" ]; then

                WriteToLog "${gLogIndent}OpenCore log file is same date as system was booted."

                # Try to get a 'rough' match as curent system bios time may differ

                btEp=$(date -jf '%H:%M:%S' $bTt '+%s')
                ocEp=$(date -jf '%H:%M:%S' "$ocLogFileHH":"$ocLogFileMM":"$ocLogFileSS" '+%s')

                [[ $btEp -gt $ocEp ]] && timeDiffEp=$(( btEp-ocEp ))
                [[ $ocEp -gt $btEp ]] && timeDiffEp=$(( ocEp-btEp ))

                timeDiffHours=$(( timeDiffEp/60/60 ))

                if [ $timeDiffHours -eq 0 ]; then
                    WriteToLog "${gLogIndent}OpenCore log file timestamp is is the same hour as system boot time"
                elif [ $timeDiffHours -le 1 ]; then
                    WriteToLog "${gLogIndent}OpenCore log file timestamp differs only $timeDiffHours hours from system boot time"
                else
                    WriteToLog "${gLogIndent}OpenCore log file timestamp differs by $timeDiffHours hours from system boot time"
                fi

                CreateDumpDirs "$gDumpFolderBootLogF"
                cp "$ocLogFile" "$gDumpFolderBootLogF"/"$ocLogFileName"

            else
                WriteToLog "${gLogIndent}OpenCore log file does not match date of current booted system. Ignoring"
            fi

          fi

        fi

    }

    # ---------------------------------------------------------------------------------------
    CheckForUEFIfiles()
    {
        local passedVolumeName="/Volumes/$1"
        local passedDevice="$2"
        local versionInfo=""
        local lineRead=""
        local fileContains=""
        local OpenCoreSignature="0e1fba1000b409cd21b8014ccd210f0b4f70656e436f726520426f6f746c6f61646572202863292041636964616e74686572612052657365617263680d0a2400"
        local verified=""

        # Check for known instances where .efi file is deeper than one directory, for example: /EFI/Clover/Boot/BootX64.efi

        for (( n=0; n<${#gUefiKnownFiles[@]}; n++ ))
        do
            lineRead="${gUefiKnownFiles[$n]}"
            versionInfo=""

            if [ -f "${passedVolumeName}${lineRead}" ]; then

                if [[ "$lineRead" == *Clover* ]]; then
                    fileContains=$( IsStringPresent "Clover" "${passedVolumeName}${lineRead}" )
                    if [ ! "$fileContains" == "" ]; then
                        revision=$( FindStringInExecutable "Clover revision:" "${passedVolumeName}${lineRead}" )
                        versionInfo="Clover r${revision##*: }"
                    fi
                fi

                if [[ "$lineRead" == *Bootstrap* ]]; then
                    local bytesRead=$(dd 2>/dev/null if="${passedVolumeName}${lineRead}" bs=64 count=1 skip=1 | perl -ne '@a=split"";for(@a){printf"%02x",ord}' )
                    if [ "$bytesRead" == "$OpenCoreSignature" ]; then
                      versionInfo="OpenCore (V)"
                    fi
                fi

                BuildBootLoadersTextFile "UF:$lineRead" # Include full path.
                BuildBootLoadersTextFile "U2:$versionInfo"
            fi
        done

        # Check for other UEFI loader files one directory deep, for example: /EFI/OC/OpenCore.efi

        declare -a otherFilesArr
        oIFS="$IFS"; IFS=$'\n'
        otherFilesArr=($( find 2>/dev/null "${passedVolumeName}"/EFI/* -depth 1 -type f -name "*.efi" ! -name ".*" ))
        IFS="$oIFS"

        for (( o=0; o<${#otherFilesArr[@]}; o++ ))
        do

            filePath="${otherFilesArr[$o]}"
            localFilepath="${filePath##$passedVolumeName}"
            justFileName="${filePath##*/}"
            versionInfo=""

            if [ "$justFileName" == "BootX64.efi" ] || [ "$justFileName" == "BOOTx64.efi" ]; then

                # This could be one of many files renamed as BootX64.efi

                # Check for OpenCore file by signature

                local bytesRead=$(dd 2>/dev/null if="$filePath" bs=64 count=1 skip=1 | perl -ne '@a=split"";for(@a){printf"%02x",ord}' )

                if [ "$bytesRead" == "$OpenCoreSignature" ]; then
                  versionInfo="OpenCore (V)"
                fi

                # Still check for older version of OpenCore BootX64.efi

                if [ "$versionInfo" == "" ]; then
                  fileContains=$( IsStringPresent "OpenCore" "$filePath" )
                  if [ ! "$fileContains" == "" ]; then
                      versionInfo="OpenCore"
                  fi
                fi

                if [ "$versionInfo" == "" ]; then
                  fileContains=$( IsStringPresent "Clover" "$filePath" )
                  if [ ! "$fileContains" == "" ]; then
                      revision=$( FindStringInExecutable "Clover revision:" "$filePath" )
                      versionInfo="Clover r${revision##*: }"
                  fi
                fi

                if [ "$versionInfo" == "" ]; then
                  fileContains=$( IsStringPresent "microsoft" "$filePath" )
                  if [ ! "$fileContains" == "" ]; then
                      versionInfo="Windows"
                  fi
                fi

                if [ "$versionInfo" == "" ]; then
                  fileContains=$( IsStringPresent "elilo" "$filePath" )
                  if [ ! "$fileContains" == "" ]; then
                       versionInfo="ELILO"
                  fi
                fi

            # Check for Clover by name

            elif [ "$justFileName" == "CLOVERX64.efi" ] || [[ "$justFileName" == CLOVER* ]] || [[ "$justFileName" == *CLOVER* ]]; then

                fileContains=$( IsStringPresent "Clover" "$filePath" )
                if [ ! "$fileContains" == "" ]; then
                    revision=$( FindStringInExecutable "Clover revision:" "$filePath" )
                    versionInfo="Clover r${revision##*: }"
                fi

            # Check for OpenCore by name, before signature was introduced

            elif [ "$justFileName" == "OpenCore.efi" ] || [[ "$justFileName" == OpenCore* ]]; then

              # Check for signature

              local bytesRead=$(dd 2>/dev/null if="$filePath" bs=64 count=1 skip=1 | perl -ne '@a=split"";for(@a){printf"%02x",ord}' )
              verified=""

              if [ "$bytesRead" == "$OpenCoreSignature" ]; then
                verified=" (V)"
              fi

              # Try to identify version

              versionInfo=$( "$findOpenCoreVersion" "$filePath" )
              versionInfo="${versionInfo}${verified}"

            # Check for OpenCore by signature, if the file has been renamed

            elif [[ "$justFileName" == *.efi ]]; then

              # Check for signature

              local bytesRead=$(dd 2>/dev/null if="$filePath" bs=64 count=1 skip=1 | perl -ne '@a=split"";for(@a){printf"%02x",ord}' )
              verified=""

              if [ "$bytesRead" == "$OpenCoreSignature" ]; then
                verified=" (V)"

                # Try to identify version

                versionInfo=$( "$findOpenCoreVersion" "$filePath" )
                versionInfo="${versionInfo}${verified}"
              fi

            fi

 
            BuildBootLoadersTextFile "UF:$localFilepath"
            BuildBootLoadersTextFile "U2:$versionInfo"

        done

    }

    # ---------------------------------------------------------------------------------------
    FindAndCopyUserPlistFiles()
    {
        local passedVolumeName="/Volumes/$1"
        local passedDevice="$2"
        local searchPlist=""
        local dirToMake=""
        local oIFS="$IFS"

        # ---------------------------------------------------------------------------------------
        SaveFiles()
        {
            local passedFile="$1"
            local passedDevice="$2"
            local passedVolumeName="$3"

            WriteToLog "${gLogIndent}- Found ${passedFile}"
            dirToMake="${passedFile%/*}"
            dirToMake=$( echo "$dirToMake" | sed "s/\/Volumes\//${passedDevice}-/g" )
            mkdir -p "$gDumpFolderBootLoaderConfigs/$dirToMake"
            if [ -d "$gDumpFolderBootLoaderConfigs/$dirToMake" ]; then
                rsync "$passedFile" "$gDumpFolderBootLoaderConfigs/$dirToMake"
                # if nvram.plist then unhide file
                if [[ "$passedFile" == *nvram.plist* ]]; then
                    WriteToLog "${gLogIndent}  Unhiding $gDumpFolderBootLoaderConfigs/$dirToMake/nvram.plist"
                    chflags nohidden "$gDumpFolderBootLoaderConfigs/$dirToMake/nvram.plist"
                fi
            else
                WriteToLog "${gLogIndent}Error: Failed to create directory: $gDumpFolderBootLoaderConfigs/$dirToMake"
            fi
        }

        WriteToLog "${gLogIndent}Searching for Bootloader files on $passedDevice | $1"

        IFS=$'\n'
        if [ -d "${passedVolumeName}/Extra" ]; then
            searchPlist=""
            searchPlist=( $(find "${passedVolumeName}/Extra" -type f -name 'org.chameleon.Boot.plist') )
            if [ ! "$searchPlist" == "" ]; then
                for (( p=0; p<${#searchPlist[@]}; p++ ))
                do
                    SaveFiles "${searchPlist[$p]}" "$passedDevice" "$passedVolumeName"
                    # Copy also a SMBIOS.plist file if it exists.
                    searchPath="${searchPlist[$p]%/*}"
                    if [ -f "$searchPath"/SMBIOS.plist ]; then
                        cp "$searchPath"/SMBIOS.plist "$gDumpFolderBootLoaderConfigs/$dirToMake"
                    fi
                done
            fi
        fi

        if [ -d "${passedVolumeName}/EFI" ]; then
            # Could be with Clover, XPC, Opencore, Ozmosis or Genuine Mac
            # Check for config.plist file (could be either Clover or Opencore)
            searchPlist=""
            searchPlist=( $(find "${passedVolumeName}/EFI" -type f -name 'config.plist' 2>/dev/null) )
            if [ ! "$searchPlist" == "" ]; then
                for (( p=0; p<${#searchPlist[@]}; p++ ))
                do
                    SaveFiles "${searchPlist[$p]}" "$passedDevice" "$passedVolumeName"
                done
                FindAndListCloverDriverFiles "$1" "${passedDevice}"
                FindAndCopyRefitConfFile "$1" "${passedDevice}"
                FindAndListOpencoreDriverFiles "$1" "${passedDevice}"
            fi

            # Check for XPC settings files
            searchPlist=""
            searchPlist=( $(find "${passedVolumeName}/EFI" -type f -name 'settings.plist' -o -name 'xpc_patcher.plist' -o -name 'xpc_smbios.plist' 2>/dev/null) )
            for (( p=0; p<${#searchPlist[@]}; p++ ))
            do
                SaveFiles "${searchPlist[$p]}" "$passedDevice" "$passedVolumeName"
            done

            # Check for Ozmosis Defaults file
            searchPlist=""
            searchPlist=( $(find "${passedVolumeName}/EFI" -type f -name 'Defaults.plist' 2>/dev/null) )
            for (( p=0; p<${#searchPlist[@]}; p++ ))
            do
                SaveFiles "${searchPlist[$p]}" "$passedDevice" "$passedVolumeName"
            done
        fi

        if [ -d "${passedVolumeName}/Library" ]; then
            searchPlist=""
            searchPlist=( $(find "${passedVolumeName}/Library" -type f -name 'com.apple.Boot.plist' 2>/dev/null) )
            for (( p=0; p<${#searchPlist[@]}; p++ ))
            do
                SaveFiles "${searchPlist[$p]}" "$passedDevice" "$passedVolumeName"
            done
        fi

        # Check for nvram.plist file (could be either Clover or Opencore)
        if [ -d "${passedVolumeName}" ]; then
            searchNvramPlist=$(find "${passedVolumeName}/" -maxdepth 1 -type f -name 'nvram.plist' 2>/dev/null)
            if [ ! "$searchNvramPlist" == "" ]; then
                searchNvramPlist=$( echo "${searchNvramPlist}" | sed 's/\/\//\//g' )
                SaveFiles "$searchNvramPlist" "$passedDevice" "$passedVolumeName"
            fi
        fi
        IFS="$oIFS"
    }

    # ---------------------------------------------------------------------------------------
    FindAndListOpencoreDriverFiles()
    {
        local passedVolumeName="/Volumes/$1/EFI"
        local passedDevice="$2"
        local driverFolders=("OC/Drivers")
        local versionInfo=""
        local fileContains=""

        for (( q=0; q<${#driverFolders[@]}; q++ ))
        do
            if [ -d "${passedVolumeName}"/"${driverFolders[$q]}" ]; then

                dirToMake="${passedVolumeName}"/"${driverFolders[$q]}"
                dirToMake=$( echo "$dirToMake" | sed "s/\/Volumes\//${passedDevice}-/g" )

                # Create an Opencore Drivers List.txt file inside a duplicate directory structure.
                #mkdir -p "$gDumpFolderBootLoaderDrivers/$dirToMake"
                #ls -al "${passedVolumeName}"/"${driverFolders[$q]}" > "${gDumpFolderBootLoaderDrivers}/${dirToMake}/Opencore Drivers List.txt"

                # Create a single Opencore Drivers List.txt file without any directory structure.
                [ ! -d "$gDumpFolderBootLoaderDrivers" ] && mkdir -p "$gDumpFolderBootLoaderDrivers/"
                echo "================================================" >> "${gDumpFolderBootLoaderDrivers}/Opencore Drivers List.txt"
                echo "${passedDevice}" >> "${gDumpFolderBootLoaderDrivers}/Opencore Drivers List.txt"
                echo "================================================" >> "${gDumpFolderBootLoaderDrivers}/Opencore Drivers List.txt"
                ls -nAhlTU "${passedVolumeName}"/"${driverFolders[$q]}"/*.efi >> "${gDumpFolderBootLoaderDrivers}/Opencore Drivers List.txt"

                # Get driver revisions.
                searchDrivers=( $(find "${passedVolumeName}"/"${driverFolders[$q]}" -depth 1 -name '*.efi') )
                if [ ${#searchDrivers[@]} -gt 0 ]; then
                    echo "---------" >> "${gDumpFolderBootLoaderDrivers}/Opencore Drivers List.txt"
                    echo "Versions:" >> "${gDumpFolderBootLoaderDrivers}/Opencore Drivers List.txt"
                    for (( ds=0; ds<${#searchDrivers[@]}; ds++ ))
                    do
                        fileContains=$( IsStringPresent "revision" "${searchDrivers[$ds]}" )
                        if [ ! "$fileContains" == "" ]; then
                            versionInfo=$( FindStringInExecutable "Opencore revision" "${searchDrivers[$ds]}" )
                            echo "${searchDrivers[$ds]##*/} (${versionInfo})" >> "${gDumpFolderBootLoaderDrivers}/Opencore Drivers List.txt"
                        else
                            echo "${searchDrivers[$ds]##*/} (Unknown)" >> "${gDumpFolderBootLoaderDrivers}/Opencore Drivers List.txt"
                        fi
                    done
                    echo "" >> "${gDumpFolderBootLoaderDrivers}/Opencore Drivers List.txt"
                fi

            fi
        done
    }

    # ---------------------------------------------------------------------------------------
    FindAndListCloverDriverFiles()
    {
        local passedVolumeName="/Volumes/$1/EFI"
        local passedDevice="$2"
        local driverFolders=(drivers32 drivers64 drivers64UEFI "Clover/drivers32" "Clover/drivers64" "Clover/drivers64UEFI")
        local versionInfo=""
        local fileContains=""

        for (( q=0; q<${#driverFolders[@]}; q++ ))
        do
            if [ -d "${passedVolumeName}"/"${driverFolders[$q]}" ]; then

                dirToMake="${passedVolumeName}"/"${driverFolders[$q]}"
                dirToMake=$( echo "$dirToMake" | sed "s/\/Volumes\//${passedDevice}-/g" )

                # Create a Clover Drivers List.txt file inside a duplicate directory structure.
                #mkdir -p "$gDumpFolderBootLoaderDrivers/$dirToMake"
                #ls -al "${passedVolumeName}"/"${driverFolders[$q]}" > "${gDumpFolderBootLoaderDrivers}/${dirToMake}/Clover Drivers List.txt"

                # Create a single Clover Drivers List.txt file without any directory structure.
                [ ! -d "$gDumpFolderBootLoaderDrivers" ] && mkdir -p "$gDumpFolderBootLoaderDrivers/"
                echo "================================================" >> "${gDumpFolderBootLoaderDrivers}/Clover Drivers List.txt"
                echo "${passedDevice}" >> "${gDumpFolderBootLoaderDrivers}/Clover Drivers List.txt"
                echo "================================================" >> "${gDumpFolderBootLoaderDrivers}/Clover Drivers List.txt"
                ls -nAhlTU "${passedVolumeName}"/"${driverFolders[$q]}"/*.efi >> "${gDumpFolderBootLoaderDrivers}/Clover Drivers List.txt"

                # Get driver revisions.
                searchDrivers=( $(find "${passedVolumeName}"/"${driverFolders[$q]}" -depth 1 -name '*.efi') )
                if [ ${#searchDrivers[@]} -gt 0 ]; then
                    echo "---------" >> "${gDumpFolderBootLoaderDrivers}/Clover Drivers List.txt"
                    echo "Versions:" >> "${gDumpFolderBootLoaderDrivers}/Clover Drivers List.txt"
                    for (( ds=0; ds<${#searchDrivers[@]}; ds++ ))
                    do
                        fileContains=$( IsStringPresent "revision" "${searchDrivers[$ds]}" )
                        if [ ! "$fileContains" == "" ]; then
                            versionInfo=$( FindStringInExecutable "Clover revision" "${searchDrivers[$ds]}" )
                            echo "${searchDrivers[$ds]##*/} (${versionInfo})" >> "${gDumpFolderBootLoaderDrivers}/Clover Drivers List.txt"
                        else
                            echo "${searchDrivers[$ds]##*/} (Unknown)" >> "${gDumpFolderBootLoaderDrivers}/Clover Drivers List.txt"
                        fi
                    done
                    echo "" >> "${gDumpFolderBootLoaderDrivers}/Clover Drivers List.txt"
                fi

            fi
        done
    }

    # ---------------------------------------------------------------------------------------
    FindAndCopyRefitConfFile()
    {
        local passedVolumeName="$1"
        local passedDevice="$2"
        local initialPath="/Volumes/$passedVolumeName"
        local secondaryPaths=("/EFI/BOOT" "/EFI/Clover")

        for (( q=0; q<${#secondaryPaths[@]}; q++ ))
        do
            local pathToSearch="${initialPath}${secondaryPaths[$q]}"
            if [ -f "${pathToSearch}"/refit.conf ]; then
                dirToMake="${pathToSearch}"
                dirToMake=$( echo "$dirToMake" | sed "s/\/Volumes\//${passedDevice}-/g" )
                mkdir -p "$gDumpFolderBootLoaderConfigs/$dirToMake"
                cp "${pathToSearch}"/refit.conf "$gDumpFolderBootLoaderConfigs/$dirToMake"

            fi
        done
    }

    # ---------------------------------------------------------------------------------------
    GetDiskMediaName()
    {
        local passedDevice="$1"
        local diskname=$(diskutil info "$passedDevice" | grep "Media Name")

        diskname="${diskname#*:      }"
        echo "$diskname" # This line acts as a return to the caller.
    }

    # ---------------------------------------------------------------------------------------
    FindMbrBootCode()
    {
        local passedDevice="$1"
        local stage0CodeDetected=""
        local bytesRead=$( dd 2>/dev/null if="/dev/$passedDevice" bs=512 count=1 | perl -ne '@a=split"";for(@a){printf"%02x",ord}' )
        if [ "${bytesRead:1020:2}" == "55" ]; then
            case "${bytesRead:210:6}" in
                "0a803c") stage0CodeDetected="boot0" ;;
                "0b807c") stage0CodeDetected="boot0hfs" ;;
                "742b80") stage0CodeDetected="boot0md" ;;
                "ee7505") stage0CodeDetected="boot0md (dmazar v1)" ;;
                "742b80") stage0CodeDetected="boot0md (dmazar boot0workV2)" ;;
                "a300e4") stage0CodeDetected="boot0 (dmazar timing)" ;;
                "09803c") stage0CodeDetected="boot0xg" ;; # Became boot0 in Chameleon r2507
                "09f604") stage0CodeDetected="boot0 (ExFAT)" ;; # From Chameleon r2507
                "060000") stage0CodeDetected="DUET" ;;
                "75d280") stage0CodeDetected="Windows XP MBR" ;;
                "760868") stage0CodeDetected="Windows Vista,7 MBR" ;;
                "0288c2") stage0CodeDetected="GRUB" ;;
            esac

            # If code is not yet identified then check for renamed boot0 and boot0hfs files.
            # See Clover commit r1560   http://sourceforge.net/p/cloverefiboot/code/1560/
            if [ "$stage0CodeDetected" == "" ]; then
                case "${bytesRead:860:14}" in
                    "626f6f74307373") stage0CodeDetected="boot0ss (Signature Scanning)" ;;
                    "626f6f74306166") stage0CodeDetected="boot0af (Active First) " ;;
                esac
            fi

            # If code is not yet identified then check is it blank?
            if [ "$stage0CodeDetected" == "" ]; then
                if [ "${bytesRead:0:32}" == "00000000000000000000000000000000" ] ; then
                    stage0CodeDetected="None"
                fi
            fi

            # If code is not yet identified then check for known structures
            if [ "$stage0CodeDetected" == "" ]; then
                if [ "${bytesRead:164:16}" == "4641543332202020" ] ; then #FAT32
                    if [ "${bytesRead:6:16}" == "4d53444f53352e30" ]; then
                        stage0CodeDetected="FAT32 MSDOS 5.0 Boot Disk"
                    fi
                    if [ "${bytesRead:262:20}" == "4e6f6e2d73797374656d" ]; then
                        stage0CodeDetected="FAT32 Non-System Disk"
                    fi
                fi
                if [ "${bytesRead:108:16}" == "4641543136202020" ]; then #FAT16
                    if [ "${bytesRead:6:16}" == "4d53444f53352e30" ]; then
                        stage0CodeDetected="FAT16 MSDOS 5.0 Boot Disk"
                    fi
                    if [ "${bytesRead:206:20}" == "4e6f6e2d73797374656d" ]; then
                        stage0CodeDetected="FAT16 Non-System Disk"
                    fi
                fi

            fi

            # If code is not yet identified then mark as Unknown.
            if [ "$stage0CodeDetected" == "" ]; then
                stage0CodeDetected="Unknown (If you know, please report)."
            fi
        fi

        # Check for existence of the string GRUB as it can
        # appear at different offsets depending on version.
        if [[ "${bytesRead}" == *475255422000* ]]; then
            stage0CodeDetected="GRUB"
            # TO DO - How to detect grub version?
        fi

        echo "$stage0CodeDetected" # This line acts as a return to the caller.
    }

    # ---------------------------------------------------------------------------------------
    FindPbrBootCode()
    {
        local passedDevice="$1"
        local stage1CodeDetected=""
        local pbrBytesToGrab=1024
        local bytesRead=$( dd 2>/dev/null if="/dev/$passedDevice" bs=$pbrBytesToGrab count=1 | perl -ne '@a=split"";for(@a){printf"%02x",ord}' )
        local byteFiveTen="${bytesRead:1020:2}"

        if [ "$byteFiveTen" == "55" ]; then
            if [ "${bytesRead:0:16}" == "fa31c08ed0bcf0ff" ]; then
                case "${bytesRead:126:2}" in
                    "a3") stage1CodeDetected="Chameleon boot1h" ;;
                    "a2") stage1CodeDetected="boot1h" ;; # 01/04/15 - Clover and Chameleon now both have same boot1h
                    "66") case "${bytesRead:194:4}" in
                            "d007") stage1CodeDetected="Clover boot1h2" ;;
                            "8813") stage1CodeDetected="Clover boot1altV3" ;;
                          esac
                esac
            fi
            if [ "${bytesRead:180:12}" == "424f4f542020" ]; then
                if [ "${bytesRead:0:4}" == "e962" ] || [ "${bytesRead:0:4}" == "eb63" ]; then
                    case "${bytesRead:290:2}" in
                        "bf") stage1CodeDetected="Chameleon boot1f32" ;;
                        "b9") stage1CodeDetected="Clover boot1f32alt" ;;
                    esac
                fi
            fi
            if [ "${bytesRead:0:4}" == "eb76" ]; then
               case "${bytesRead:398:2}" in
                    "6d") stage1CodeDetected="boot1x" ;;
                    "9f") stage1CodeDetected="Clover boot1xalt" ;;
                esac
            fi
            if [ "${bytesRead:0:4}" == "eb58" ]; then
                case "${bytesRead:180:12}" in
                    "33c98ed1bcf4") stage1CodeDetected="Windows FAT32 NTLDR"
                                    pbrBytesToGrab=512 ;;
                    "8d36e301e8fc") stage1CodeDetected="FAT32 DUET"
                                    pbrBytesToGrab=512 ;;
                    "fa31c08ed0bc")
                    if [ "${bytesRead:142:6}" == "454649" ]; then
                        stage1CodeDetected="Apple EFI"
                    else
                        stage1CodeDetected="FAT32 Non System disk"
                    fi
                    ;;
                esac
            elif [ "${bytesRead:0:4}" == "eb76" ] && [ "${bytesRead:6:16}" == "4558464154202020" ]; then #exFAT
                if [ "${bytesRead:1024:32}" == "00000000000000000000000000000000" ] ; then
                    #stage1CodeDetected="exFAT Blank"
                    stage1CodeDetected="None"
                fi
                if [ "${bytesRead:1028:28}" == "42004f004f0054004d0047005200" ] ; then
                    stage1CodeDetected="Windows exFAT NTLDR"
                fi
            elif [ "${bytesRead:0:4}" == "b800" ] && [ "${bytesRead:180:12}" == "5033c08ec0bf" ]; then
                stage1CodeDetected="GPT DUET"
            elif [ "${bytesRead:0:4}" == "eb3c" ]; then
                if [ "${bytesRead:180:12}" == "1333c08ac6fe" ]; then
                    stage1CodeDetected="FAT16 DUET"
                    pbrBytesToGrab=512
                elif [ "${bytesRead:180:12}" == "0ecd10ebf530" ]; then
                    stage1CodeDetected="FAT16 Non System"
                fi
            elif [ "${bytesRead:0:16}" == "eb52904e54465320" ]; then
                stage1CodeDetected="Windows NTFS NTLDR"
                pbrBytesToGrab=512
            fi
            # Check of existence of the string GRUB as it can
            # appear at a different offsets depending on version.
            if [[ "${bytesRead}" == *475255422000* ]]; then
                stage1CodeDetected="GRUB"
                # TO DO - How to detect grub version?
                pbrBytesToGrab=512
            fi
            # If code is not yet identified then mark as Unknown.
            if [ "$stage1CodeDetected" == "" ]; then
                stage1CodeDetected="Unknown (If you know, please report)."
            fi
        fi
        echo "${stage1CodeDetected}:$byteFiveTen" # This line acts as a return to the caller.
        if [ "$pbrBytesToGrab" == "1024" ]; then # need to pass this back to caller, exporting does not work
          return 0
        else
          return 1
        fi
    }

    # ---------------------------------------------------------------------------------------
    SearchStringArraysdu()
    {
        local arrayToSearch="$1"
        local itemToFind="$2"
        local loopCount=0
        local itemfound=0

        if [ "$arrayToSearch" == "duIdentifier" ]; then
            while [ "$itemfound" -eq 0 ] && [ $loopCount -le "${#duIdentifier[@]}" ]; do
                if [ "${duIdentifier[$loopCount]}" == "$itemToFind" ]; then
                    itemfound=1
                fi
                (( loopCount++ ))
            done
            if [ $itemfound -eq 1 ]; then
                (( loopCount-- ))
                echo $loopCount # This line acts as a return to the caller.
            fi
        fi
    }

    # ---------------------------------------------------------------------------------------
    BuildBootLoadersTextFile()
    {
        local passedTextLine="$1"

        if [ ! "$passedTextLine" == "" ]; then
            gBootloadersTextBuildFile="$gBootloadersTextBuildFile"$(printf "$passedTextLine\n")
            gBootloadersTextBuildFile="$gBootloadersTextBuildFile\n"
        fi
    }

    # ---------------------------------------------------------------------------------------
    BuildPartitionTableInfoTextFile()
    {
        local passedDevice="/dev/$1"
        local outFile="${gDumpFolderDiskPartitionInfo}/${1}-gpt-fdisk.txt"
        local passedName="$2"
        local passedSize="$3"

        if [ ! "$passedDevice" == "" ]; then
            echo "$passedDevice - $passedName - $passedSize" >> "$outFile"
            echo "" >> "$outFile"
            if [ $gRootPriv -eq 1 ]; then
                echo "============================================================================" >> "$outFile"
                echo "gpt -r show" >> "$outFile"
                echo "============================================================================" >> "$outFile"
                gpt -r show "$passedDevice" >> "$outFile"
                echo "" >> "$outFile"
                echo "" >> "$outFile"
                echo "============================================================================" >> "$outFile"
                echo "fdisk" >> "$outFile"
                echo "============================================================================" >> "$outFile"
                "$fdisk440" "$passedDevice" >> "$outFile"
                "$bdisk" "$gDumpFolderDisks" "$1" "html"
            else
                echo "** Root privileges required to read further info." >> "$outFile"
            fi
        fi
    }

    # ---------------------------------------------------------------------------------------
    GetDiskMediaName()
    {
        local passedDevice="$1"
        local diskname=$(diskutil info "$passedDevice" | grep "Media Name")

        diskname="${diskname##*:      }"
        diskname="${diskname% Media}"
        echo "$diskname" # This line acts as a return to the caller.
    }

    #------------------------------------------------
    # Procedure to read the disk physical block size from ioreg (thanks JrCs).
    GetDiskBlockSize()
    {
        local passedDisk="$1"
        local diskPhysicalBlockSize=""

        diskPhysicalBlockSize=$( diskutil info /dev/"$passedDisk" | grep "Device Block Size" | sed 's/|* //g' )
        diskPhysicalBlockSize="${diskPhysicalBlockSize##*:}"
        diskPhysicalBlockSize="${diskPhysicalBlockSize%Bytes*}" 

        if [ "$diskPhysicalBlockSize" == "" ]; then
            diskPhysicalBlockSize="Unknown"
        fi

        echo "(${diskPhysicalBlockSize} byte physical block size)" # This line acts as a return to the caller.
    }

    # ---------------------------------------------------------------------------------------

    # SIP File System Protection
    # 0 means enabled, 1 means disabled. 

    sipFSprotection=1

    if [ $gSystemVersion -ge 15 ]; then
      sipFSprotection="${gSipStr:16:1}"
    fi

    WriteToLog "${gLogIndent}Preparing to read disks..."
    WriteToLog "${gLogIndent}Note: There may be a delay if any disks are sleeping"
    
    if [ $sipFSprotection -eq 1 ]; then
      WriteToLog "${gLogIndent}Note: SIP Filesystem protection is disabled"
    else
      WriteToLog "${gLogIndent}Note: SIP Filesystem protection is enabled so output may be limited"
    fi

    # Create save directories

    if [ $gBootLoaderBootSectors -eq 1 ]; then
        mkdir -p "$gDumpFolderDiskBootSectors"
        mkdir -p "$tmpDiskSectorDir"
    fi

    if [ $gDiskPartitionInfo -eq 1 ]; then
        mkdir -p "$gDumpFolderDiskPartitionInfo"
    fi

    # Always create a disks directory and save diskutil lists

    [[ ! -d "$gDumpFolderDisks" ]] && mkdir -p "$gDumpFolderDisks"

    diskutil list > "$gDumpFolderDisks"/diskutil_list.txt
    diskutil cs list > "$gDumpFolderDisks"/diskutil_cs_list.txt
    diskutil ap list > "$gDumpFolderDisks"/diskutil_ap_list.txt
    diskutil ar list > "$gDumpFolderDisks"/diskutil_ar_list.txt

    # Generate internal arrays of APFS and Non-APFS details

    if [ $gBootLoaderBootSectors -eq 1 ]; then
      SendToUI "@DS@Building Disk Map:bootLoaderBootSectors@"
    fi

    if [ $gDiskLoaderConfigs -eq 1 ]; then
      SendToUI "@DS@Building Disk Map:diskLoaderConfigs@"
    fi

    if [ $gDiskPartitionInfo -eq 1 ]; then
      SendToUI "@DS@Building Disk Map:diskPartitionInfo@"
    fi

    BuildDiskUtilStringArrays

    # print feedback to command line.
    echo "Scanning each disk..."

    # Loop through each whole disk (ie. disk0, disk1, disk2 ... )
    for (( d=0; d<${#duWholeDisks[@]}; d++ ))
    do
        diskPositionInArray=$(SearchStringArraysdu "duIdentifier" "${duWholeDisks[$d]}")

        diskMediaName=$(GetDiskMediaName "/dev/${duWholeDisks[$d]}")
        diskPhysicalSectorSize=$(GetDiskBlockSize "${duWholeDisks[$d]}")
        echo "Scanning disk: ${duWholeDisks[$d]}" # To stdout
        WriteToLog "${gLogIndent}--------------------"
        WriteToLog "${gLogIndent}Scanning disk: ${duWholeDisks[$d]}"

        # Notes after testing on a MacBook Pro and iMac running 10.15.5
        # =============================================================
        # With SIP:0x00000000 (File Protection Enabled)
        #
        # - Testing disk0 (GPT) which contains APFS physical store(s)
        # - fdisk, gpt and xxd fails from command line and UI
        # 
        # - Testing attached USB stick - disk3 - using GPT
        # - fdisk, gpt and xxd works from command line but fails from UI      <-- Why??
        # 
        # 
        # With SIP:0x00000002 (File Protection Disabled)
        #
        # - Testing disk0 (GPT) which contains APFS physical store(s)
        # - fdisk, gpt and xxd works from command line and UI
        # 
        # - Testing attached USB stick - disk3 - using GPT
        # - fdisk, gpt and xxd works from command line and UI

        # Can use fdisk, gpt and xxd as long as whole disk is not an APFS container AND
        # if it's an APFS physical store then only if SIP Filesystem Protection is disabled

        isAPFSContainer=0
        if [[ " ${diskUtilApfsContainerRefs[@]} " =~ " ${duWholeDisks[$d]} " ]]; then
          isAPFSContainer=1
          WriteToLog "${gLogIndent}Note: This is an APFS Container"
        fi

        isAPFSPhysicalStore=0
        if [[ " ${diskUtilApfsPhysicalStores[@]} " =~ "${duWholeDisks[$d]}" ]]; then
          isAPFSPhysicalStore=1
          WriteToLog "${gLogIndent}Note: This is an APFS Physical Store"
        fi

        notAPFScontainerOrReadablePhysicalStore=0

        if [ $isAPFSContainer -eq 0 ] ; then
            if [ $isAPFSPhysicalStore -eq 0 ] || ([ $isAPFSPhysicalStore -eq 1 ] && [ $sipFSprotection -eq 1 ]); then
                notAPFScontainerOrReadablePhysicalStore=1
            fi
        fi

        WriteToLog "${gLogIndent}--------------------"

        activeSliceNumber=""
        if [ $gRootPriv -eq 1 ]; then

            if [ $notAPFScontainerOrReadablePhysicalStore -eq 1 ]; then
                activeSliceNumber=$( fdisk -d "/dev/r${duWholeDisks[$d]}" | grep -n "*" | awk -F: '{print $1}' )
            fi

        fi

        BuildBootLoadersTextFile "WD:${duWholeDisks[$d]}"
        BuildBootLoadersTextFile "DN:${diskMediaName} ${diskPhysicalSectorSize}"
        BuildBootLoadersTextFile "DS:${duSize[$diskPositionInArray]}"
        BuildBootLoadersTextFile "DT:${duContent[$diskPositionInArray]}"

        if [ $gDiskPartitionInfo -eq 1 ]; then
            if [ $notAPFScontainerOrReadablePhysicalStore -eq 1 ]; then
                WriteToLog "${gLogIndent}Reading partition info for: ${duWholeDisks[$d]}"
                BuildPartitionTableInfoTextFile "${duWholeDisks[$d]}" "$diskMediaName" "${duSize[$diskPositionInArray]}" "$notAPFScontainerOrReadablePhysicalStore"
            fi
        fi

        # Check for MBR

        mbrBootCode=""

        if [ $gBootLoaderBootSectors -eq 1 ]; then

            if [ $notAPFScontainerOrReadablePhysicalStore -eq 1 ]; then

                mbrBootCode=$(FindMbrBootCode "${duWholeDisks[$d]}")

                # used for creating files in 'Boot Loaders And Disk Sectors' dump
                mbrFile="${tmpDiskSectorDir}/${duWholeDisks[$d]}.txt"

                # Prepare file dump for disk sectors
                diskSectorDumpFile="$gDumpFolderDiskBootSectors/${duWholeDisks[$d]}-${diskMediaName}-${duSize[$diskPositionInArray]}.txt"

                echo "${duWholeDisks[$d]} - $diskMediaName - ${duSize[$diskPositionInArray]} ${diskPhysicalSectorSize}" >> "$diskSectorDumpFile"
                echo "MBR: First 512 bytes    Code Detected: $mbrBootCode" >> "$diskSectorDumpFile"
                if [ "$mbrBootCode" != "" ] && [ "$mbrBootCode" != "None" ]; then
                    echo "MBR: First 512 bytes    Code Detected: $mbrBootCode" >> "$mbrFile"
                fi

                # Dump MBR to file
                if [ $gRootPriv -eq 1 ]; then

                    tmpData=$( xxd -l512 -g1 "/dev/${duWholeDisks[$d]}" )
                    echo "$tmpData" >> "$diskSectorDumpFile"

                    if [ "$mbrBootCode" != "" ] && [ "$mbrBootCode" != "None" ]; then
                         echo "$tmpData" >> "$mbrFile"
                    fi

                else
                    echo "** Root privileges required to read further info." >> "$diskSectorDumpFile"
                fi
            fi
        fi

        BuildBootLoadersTextFile "S0:$mbrBootCode"

        gpt=0

        # Loop through each volume for current disk, writing details each time
        for (( v=0; v<${#duIdentifier[@]}; v++ ))
        do

            pbrFile="${tmpDiskSectorDir}/${duIdentifier[$v]}.txt" # used for creating files in 'Boot Loaders And Disk Sectors' dump

            if [[ ${duIdentifier[$v]} == ${duWholeDisks[$d]} ]] && [ "${duContent[$v]}" == "GUID_partition_scheme" ]; then
                gpt=1
            fi

            if [[ ${duIdentifier[$v]} == ${duWholeDisks[$d]}* ]] && [[ ! ${duIdentifier[$v]} == ${duWholeDisks[$d]} ]] ; then

                echo "               ${duIdentifier[$v]}" # To stdout

                if [ $gBootLoaderBootSectors -eq 1 ]; then
                  SendToUI "@DS@Scanning ${duIdentifier[$v]}:bootLoaderBootSectors@"
                fi

                if [ $gDiskLoaderConfigs -eq 1 ]; then
                  SendToUI "@DS@Scanning ${duIdentifier[$v]}:diskLoaderConfigs@"
                fi

                if [ $gDiskPartitionInfo -eq 1 ]; then
                  SendToUI "@DS@Scanning ${duIdentifier[$v]}:diskPartitionInfo@"
                fi

                # If this slice is active then add asterisk
                partitionActive=" "
                if [ "${duIdentifier[$v]##*s}" == "$activeSliceNumber" ]; then
                    partitionActive="*"
                fi

                BuildBootLoadersTextFile "VA:$partitionActive"

                # Is the VolumeName empty or contains only whitespace?
                if [ "${duVolumeName[$v]}" == "" ] || [[ "${duVolumeName[$v]}" =~ ^\ +$ ]] ;then
                    diskUtilInfoDump=$(diskutil info "${duIdentifier[$v]}")
                    fileSystemPersonality=$(echo "${diskUtilInfoDump}" | grep -F "File System Personality")
                    fileSystemPersonality=${fileSystemPersonality#*:  }
                    mediaName=$(echo "${diskUtilInfoDump}" | grep "Media Name")
                    mediaName=${mediaName#*:      }
                    volumeName=$(echo "${diskUtilInfoDump}" | grep "Volume Name")
                    volumeName=${volumeName#*:              }
                    if [ ! "$fileSystemPersonality" == "" ]; then
                        if [ "$fileSystemPersonality" == "NTFS" ]; then
                            partitionname=$mediaName
                        else
                            partitionname=$volumeName
                        fi
                    else
                        if [ "$volumeName" == "Apple_HFS" ]; then
                            partitionname=$volumeName
                        else
                            partitionname=$mediaName
                        fi
                    fi
                else
                    partitionname="${duVolumeName[$v]}"
                fi

                BuildBootLoadersTextFile "VD:${duIdentifier[$v]}"
                BuildBootLoadersTextFile "VT:${duContent[$v]}"
                BuildBootLoadersTextFile "VN:${duVolumeName[$v]}"
                BuildBootLoadersTextFile "VS:${duSize[$v]}"

                # Check for PBR

                if [ $gBootLoaderBootSectors -eq 1 ]; then

                    if [ $notAPFScontainerOrReadablePhysicalStore -eq 1 ]; then

                        if [ $gRootPriv -eq 1 ]; then

                          if [ $gSystemVersion -ge 19 ]; then #Catalina. Not sure what Mojave needs.
                              tmpData=$( dd if="/dev/${duIdentifier[$v]}" bs=1024 count=1 | xxd -l1024 -g1 )
                              checkWith="${duIdentifier[$v]}"
                          else
                              tmpData=$( dd if="/dev/r${duIdentifier[$v]}" bs=1024 count=1 | xxd -l1024 -g1 )
                              checkWith="r${duIdentifier[$v]}"
                          fi

                          pbrBootCode=""

                          if [ "$tmpData" != "" ]; then

                              returnValue=$(FindPbrBootCode "$checkWith")  #Note: returns $pbrBootCode:$byteFiveTen
                              pbrBootCode="${returnValue%:*}"
                              byteFiveTen="${returnValue##*:}"

                              if [ $? -eq 0 ];then
                                  pbrBytesToGrab=1024
                              else
                                  pbrBytesToGrab=512
                              fi

                              # Save PBR details to file

                              if [ -f "$diskSectorDumpFile" ]; then
                                  echo "" >> "$diskSectorDumpFile"
                                  echo "${duIdentifier[$v]} - $partitionname - ${duSize[$v]}"  >> "$diskSectorDumpFile"
                                  echo "PBR: First $pbrBytesToGrab bytes    Code Detected: ${pbrBootCode}" >> "$diskSectorDumpFile"
                                  echo "$tmpData" >> "$diskSectorDumpFile"
                              fi

                              # For Boot Loaders And Disk Sectors dump we only want to see any that may have cotent or be bootable

                              if [ "${pbrBootCode}" != "" ] || [ "$byteFiveTen" == "55" ] && [ $gpt -eq 1 ]; then
                                  echo "PBR: First $pbrBytesToGrab bytes    Code Detected: ${pbrBootCode}" >> "$pbrFile"
                                  echo "$tmpData" >> "$pbrFile"
                              fi

                          fi

                        else
                            [[ -f "$diskSectorDumpFile" ]] && echo "** Root privileges required to read further info." >> "$diskSectorDumpFile"
                        fi

                        if [ "${pbrBootCode}" == "None" ]; then
                            pbrBootCode=""
                        fi

                        if [ -f "$diskSectorDumpFile" ]; then
                            echo "" >> "$diskSectorDumpFile"
                        fi
                    fi
                fi

                BuildBootLoadersTextFile "S1:$pbrBootCode"

                # -------------------------------
                # Check for stage 2 loader files.
                # -------------------------------

                # Check if the current volume is mounted as some will be hidden
                # For example, an unmounted ESP or Lion Recovery HD.
                # If not mounted then there's no need to check for stage2 files.
                checkMounted=""
                checkMounted=$( mount | grep "/dev/${duIdentifier[$v]}" )
                checkMounted="${checkMounted% on *}"
                checkMounted="${checkMounted##*/}"
                mountedAs=""
                mountedEFI=0
                mountFail=0

                if [ "$checkMounted" == "${duIdentifier[$v]}" ]; then
                    if [ ! "$checkMounted" == "" ]; then

                        # Are we reading a GPT disk?
                        if [ $gpt -eq 1 ]; then
                          # is the slice of type "EFI"?
                            if [ "${duContent[$v]}" == "EFI" ]; then
                              WriteToLog "${gLogIndent}[ Found ${duIdentifier[$v]} | ${duVolumeName[$v]} (Already mounted) ]"
                            fi
                        fi

                        mountedAs="${duVolumeName[$v]}"
                        # Check for Windows partitions
                        if [ "${duVolumeName[$v]}" == " " ] && [ "${duContent[$v]}" == "Microsoft Basic Data" ]; then
                            mountedAs=$( mount | grep /dev/${duIdentifier[$v]} | awk {'print $3'})
                            mountedAs="${mounted##*/}"
                        fi
                    fi
                else # volume is not mounted.

                    # Are we reading a GPT disk?
                    if [ $gpt -eq 1 ]; then
                       # is the slice of type "EFI"?
                        if [ "${duContent[$v]}" == "EFI" ]; then
                            checkMountSuccess=$( diskutil mount readOnly "/dev/${duIdentifier[$v]}" )
                            WriteToLog "${gLogIndent}* $checkMountSuccess"
                            if [[ "$checkMountSuccess" == *mounted ]]; then
                                mountedEFI=1 && WriteToLog "${gLogIndent}* Mounted ${duIdentifier[$v]}"
                            else
                                mountFail=1 && echo "* Failed to mount ${duIdentifier[$v]}"
                            fi
                        fi
                    fi

                    # find mount point, providing we're checking a slice
                    checkS=$( echo "${duIdentifier[$v]}" | tr -cd 's' | wc -c | tr -d ' ' )
                    if [ $checkS -eq 2 ]; then
                        mountedAs=$( mount | grep /dev/${duIdentifier[$v]})
                        mountedAs="${mountedAs%(*}"
                        mountedAs="$(echo ${mountedAs} | sed -e 's/[[:space:]]*$//')"
                        mountedAs="${mountedAs##*on /Volumes/}"
                    fi

                fi

                if [ ! "${mountedAs}" == "" ] && [ ! "${mountedAs}" == " " ]; then
                    if [ $gBootLoaderBootSectors -eq 1 ]; then
                      CheckForBootFiles "${mountedAs}" "${duIdentifier[$v]}"
                      CheckForEfildrFiles "${mountedAs}" "${duIdentifier[$v]}"
                      CheckForUEFIfiles "${mountedAs}" "${duIdentifier[$v]}"

                      # is the slice of type "EFI"?
                      if [ "${duContent[$v]}" == "EFI" ]; then
                        CheckForOpenCoreBootLog "${mountedAs}" "${duIdentifier[$v]}"
                      fi

                  fi
                  if [ $gDiskLoaderConfigs -eq 1 ]; then
                      FindAndCopyUserPlistFiles "${mountedAs}" "${duIdentifier[$v]}"
                  fi
                else
                    if [ $mountFail -eq 1 ]; then
                        mountedAs="*Failed to mount*"
                    elif [ "${duVolumeName[$v]}" != "" ]; then
                        # May not be mounted, for example a TimeMachine disk
                        mountedAs="${duVolumeName[$v]}"
                    fi
                fi

                if [ $gDiskPartitionInfo -eq 1 ]; then # This now happens without a separate option.
                    # We still want to find the UID's of a Recovery HD, even if it's not mounted,
                    if [ "${duVolumeName[$v]}" == "Recovery HD" ]; then
                        mountedAs="Recovery HD"
                    fi

                    GrabXUIDs "${duIdentifier[$v]}" "${mountedAs}"
                fi

                # If we mounted an EFI system partition earlier then we should un-mount it.
                if [ $mountedEFI -eq 1 ]; then
                    diskutil umount "/dev/${duIdentifier[$v]}" && mountedEFI=0 && WriteToLog "${gLogIndent}* Unmounted ${duIdentifier[$v]}"
                fi
            fi
        done
        BuildBootLoadersTextFile "================================="
    done
    # ----------------------------------------------
    # Write the Bootloaders file to disk.
    # Also write the UID file to disk.
    # Doing it here allows columns to be aligned.
    # ----------------------------------------------
    if [ $gBootLoaderBootSectors -eq 1 ]; then
        printf "${gBootloadersTextBuildFile}" | column -t -s@ >> "${diskUtilLoaderInfoFile}"
    fi
    if [ $gDiskPartitionInfo -eq 1 ]; then
        printf "${gXuidBuildFile}" | column -t -s@ >> "${xuidFile}"
    fi
}

# =======================================================================================
# MAIN
# =======================================================================================
#
Initialise "$1" "$2" "$3" "$4"
WriteToLog "${gLogIndent}RunBCF=$gDiskLoaderConfigs | RunDL=$gBootLoaderBootSectors | RunD=$gDiskPartitionInfo"
if [ $gDiskLoaderConfigs -eq 1 ] || [ $gBootLoaderBootSectors -eq 1 ] || [ $gDiskPartitionInfo -eq 1 ]; then
    CheckRoot
    DumpDiskUtilAndLoader
fi

# Send notification to the UI
if [ $gDiskLoaderConfigs -eq 1 ]; then
    SendToUI "@DF@F:diskLoaderConfigs@"
fi
if [ $gDiskPartitionInfo -eq 1 ]; then
    SendToUI "@DF@F:diskPartitionInfo@"
fi
