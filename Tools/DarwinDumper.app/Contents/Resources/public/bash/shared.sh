#!/bin/bash

# Set out other directory paths based on SELF_PATH
PUBLIC_DIR="${SELF_PATH%/*}"
PUBLIC_DIR="${PUBLIC_DIR%/*}"
ASSETS_DIR="$PUBLIC_DIR"/assets
SCRIPTS_DIR="$PUBLIC_DIR"/bash
DATA_DIR="$PUBLIC_DIR"/data
DRIVERS_DIR="$PUBLIC_DIR"/drivers
FRAMEWORKS_DIR="$PUBLIC_DIR"/frameworks
IMAGES_DIR="$PUBLIC_DIR"/images
JSSCRIPTS_DIR="$PUBLIC_DIR"/scripts
STYLESDIR="$PUBLIC_DIR"/styles
TOOLS_DIR="$PUBLIC_DIR"/Tools
WORKING_PATH="${HOME}/Library/Application Support"
APP_DIR_NAME="DarwinDumper"
TEMPDIR="/tmp/${APP_DIR_NAME}"

gUserPrefsFileName="org.tom.DarwinDumper"
gUserPrefsFile="$HOME/Library/Preferences/$gUserPrefsFileName"

# Set out file paths
logFile="${TEMPDIR}/ ${APP_DIR_NAME}Log.txt"
logJsToBash="${TEMPDIR}/jsToBash" # Note - this is created in AppDelegate.m
logBashToJs="${TEMPDIR}/bashToJs" # Note - this is created in AppDelegate.m
gTmpPreLogFile="$TEMPDIR"/tmplogfile

# Other script paths
DARWINDUMPER="${SCRIPTS_DIR}/DarwinDumper.sh"
SUDOCHANGES="${SCRIPTS_DIR}/uiSudoChangeRequests.sh"

# Web files
JQUERYMIN="${JSSCRIPTS_DIR}/jquery-3.1.0.min.js"
JQUERYUIMIN="${JSSCRIPTS_DIR}/jquery-ui.min.js"
JQUERYUISTRUCTURE="${STYLESDIR}/common/jquery-ui.structure.min.css"
JQUERYUITHEMEREPORT="${STYLESDIR}/report/jquery-ui.theme.min.css"

# Globals
debugIndent="    "
gLogIndent="          "
debugIndentTwo="${debugIndent}${debugIndent}"
gFaceless=0
COMMANDLINE=0
DEBUG=0
gSipStr=""
sicBin=""
gLoadedKextsString=""

# Here we save the current user and group ID's and use them in the
# DarwinDumper script when setting ownership/permissions of the dump
# folder, even if the user opt to run the dumps with root privileges.
DD_BOSS=`id -unr` #export DD_BOSS=`id -unr`
DD_BOSSGROUP=`id -gnr` #export DD_BOSSGROUP=`id -gnr`

# The problem with the above is if the user has invoked sudo with root privileges
# and runs DarwinDumper then the UID will be root and the save folder will be
# created and owned by root.
# Here we check to see if the current user is root and if yes then change it
# using the environment variable $HOME.
if [ "$DD_BOSS" == "root" ]; then
    DD_BOSS=$(echo "${HOME##*/}")
    DD_BOSSGROUP=`id -g -n ${DD_BOSS}`
fi

# Find version of main app.
mainAppInfoFilePath="${SELF_PATH%Resources*}"
DD_VER=$( /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$mainAppInfoFilePath"/Info.plist  )

# Common Functions
# ---------------------------------------------------------------------------------------
WriteToLog() {
    if [ $COMMANDLINE -eq 0 ]; then
        printf "${1}\n" >> "$logFile"
    else
        printf "${1}\n"
    fi
}

# ---------------------------------------------------------------------------------------
WriteLinesToLog() {
    if [ $COMMANDLINE -eq 0 ]; then
        if [ $DEBUG -eq 1 ]; then
            printf "${debugIndent}===================================\n" >> "$logFile"
        else
            printf "===================================\n" >> "$logFile"
        fi
    else
        printf "===================================\n"
    fi
}

# ---------------------------------------------------------------------------------------
SendToUI() {
    if [ $COMMANDLINE -eq 0 ]; then
        [[ DEBUG -eq 1 ]] && echo "**DBG_BASHsent:$1" >> "$logFile"
        echo "$1" >> "$logBashToJs"
    else
        echo "$1" >> "$TEMPDIR"/dd_ui_return
    fi
}

# ---------------------------------------------------------------------------------------
CheckOsVersion()
{
    local osVer=$( uname -r )
    echo ${osVer%%.*}
}

# ---------------------------------------------------------------------------------------
GetOsName()
{
    local osVer=$( uname -r )
    local osVer=${osVer%%.*}
    local osName=""

    if [ "$osVer" == "8" ]; then
	    osName="Tiger"
    elif [ "$osVer" == "9" ]; then
	    osName="Leopard"
    elif [ "$osVer" == "10" ]; then
	    osName="SnowLeopard"
    elif [ "$osVer" == "11" ]; then
	    osName="Lion"
    elif [ "$osVer" == "12" ]; then
	    osName="MountainLion"
    elif [ "$osVer" == "13" ]; then
	    osName="Mavericks"
    elif [ "$osVer" == "14" ]; then
	    osName="Yosemite"
    elif [ "$osVer" == "15" ]; then
	    osName="ElCapitan"
    elif [ "$osVer" == "16" ]; then
	    osName="Sierra"
    elif [ "$osVer" == "17" ]; then
	    osName="High Sierra"
    elif [ "$osVer" == "18" ]; then
	    osName="Mojave"
    elif [ "$osVer" == "19" ]; then
	    osName="Catalina"
    else
	    osName="Unknown"
    fi

    echo "$osName"  # This line acts as a return to the caller.
}

# ---------------------------------------------------------------------------------------
CreateDumpDirs()
{
    local dirToMake="$1"

    for dumpDirs in "$dirToMake";
    do
        if [ ! -d "${dumpDirs}" ]; then
          mkdir -p "${dumpDirs}"
       fi
    done
}

# ---------------------------------------------------------------------------------------
# Get SIP status
# Check os version
osVer=$(CheckOsVersion)
if [ $osVer -ge 14 ]; then # Yosemite and newer

    csrStat="$TOOLS_DIR/csrstat"

    # Check for csr-active-config hex setting
    sicHex=$( "$csrStat" | grep -o '(0x.*' | cut -c10-11 | tr [[:lower:]] [[:upper:]] )

    declare -a csrArr

    csrArr=($( "$csrStat" | grep -o '(.*' | tail -n 10 | tr -d '()' ))
    [[ "${csrArr[0]}" == "enabled" ]] && gCSR_ALLOW_APPLE_INTERNAL=1       || gCSR_ALLOW_APPLE_INTERNAL=0
    [[ "${csrArr[1]}" == "enabled" ]] && gCSR_ALLOW_UNTRUSTED_KEXTS=0      || gCSR_ALLOW_UNTRUSTED_KEXTS=1
    [[ "${csrArr[2]}" == "enabled" ]] && gCSR_ALLOW_TASK_FOR_PID=0         || gCSR_ALLOW_TASK_FOR_PID=1
    [[ "${csrArr[3]}" == "enabled" ]] && gCSR_ALLOW_UNRESTRICTED_FS=0      || gCSR_ALLOW_UNRESTRICTED_FS=1
    [[ "${csrArr[4]}" == "enabled" ]] && gCSR_ALLOW_KERNEL_DEBUGGER=0      || gCSR_ALLOW_KERNEL_DEBUGGER=1
    [[ "${csrArr[5]}" == "enabled" ]] && gCSR_ALLOW_UNRESTRICTED_DTRACE=0  || gCSR_ALLOW_UNRESTRICTED_DTRACE=1
    [[ "${csrArr[6]}" == "enabled" ]] && gCSR_ALLOW_UNRESTRICTED_NVRAM=0   || gCSR_ALLOW_UNRESTRICTED_NVRAM=1
    [[ "${csrArr[7]}" == "enabled" ]] && gCSR_ALLOW_DEVICE_CONFIGURATION=0 || gCSR_ALLOW_DEVICE_CONFIGURATION=1
    [[ "${csrArr[8]}" == "enabled" ]] && gCSR_ALLOW_ANY_RECOVERY_OS=0      || gCSR_ALLOW_ANY_RECOVERY_OS=1
    [[ "${csrArr[9]}" == "enabled" ]] && gCSR_ALLOW_UNAPPROVED_KEXTS=0     || gCSR_ALLOW_UNAPPROVED_KEXTS=1

    # Save info for UI to notify user of what cannot be done.
    # TO CHANGE - This string is created out of order of the above bits. No idea why it was done this way but it would be easier to read through the code with this string in the right order.
    gSipStr="${gCSR_ALLOW_UNAPPROVED_KEXTS},${gCSR_ALLOW_ANY_RECOVERY_OS},${gCSR_ALLOW_DEVICE_CONFIGURATION},${gCSR_ALLOW_UNRESTRICTED_NVRAM},${gCSR_ALLOW_UNRESTRICTED_DTRACE},${gCSR_ALLOW_APPLE_INTERNAL},${gCSR_ALLOW_KERNEL_DEBUGGER},${gCSR_ALLOW_TASK_FOR_PID},${gCSR_ALLOW_UNRESTRICTED_FS},${gCSR_ALLOW_UNTRUSTED_KEXTS}"

    sicBin=$(echo "$gSipStr" | tr -d ',')

    # Check for loaded kexts as they may be in the prelinked kernel already.
    gDrvLoadedD=0 # DirectHW.kext
    gDrvLoadedP=0 # MacPmem.kext
    gDrvLoadedR=0 # RadeonPCI.kext
    gDrvLoadedV=0 # VoodooHDA.kext
    gDrvLoadedA=0 # AppleIntelInfo

    kextstat | grep "DirectHW" &>/dev/null && gDrvLoadedD=1
    kextstat | grep "MacPmem" &>/dev/null && gDrvLoadedP=1
    kextstat | grep "RadeonPCI" &>/dev/null && gDrvLoadedR=1
    kextstat | grep "VoodooHDA" &>/dev/null && gDrvLoadedV=1
    kextstat | grep "com.pikeralpha.driver.AppleIntelInfo" &>/dev/null && gDrvLoadedA=1

    gLoadedKextsString="${gDrvLoadedD},${gDrvLoadedP},${gDrvLoadedR},${gDrvLoadedV},${gDrvLoadedA}"

else

    gCSR_ALLOW_UNTRUSTED_KEXTS=1
    gCSR_ALLOW_UNRESTRICTED_FS=1
    gCSR_ALLOW_TASK_FOR_PID=1
    gCSR_ALLOW_KERNEL_DEBUGGER=1
    gCSR_ALLOW_APPLE_INTERNAL=1
    gCSR_ALLOW_UNRESTRICTED_DTRACE=1
    gCSR_ALLOW_UNRESTRICTED_NVRAM=1
    gCSR_ALLOW_DEVICE_CONFIGURATION=1
    gCSR_ALLOW_ANY_RECOVERY_OS=1
    gCSR_ALLOW_UNAPPROVED_KEXTS=1

fi