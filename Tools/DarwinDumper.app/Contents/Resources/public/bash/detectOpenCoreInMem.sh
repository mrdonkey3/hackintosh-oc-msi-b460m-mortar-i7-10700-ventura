#!/bin/sh

# Copyright (C) 2020, blackosx. All rights reserved.
#
# Version 0.1   - June 15th 2020        - Initial Design
# Version 0.2   - June 15th 2020        - Add check for ioreg boot-log to identify non OC boot
#                                         Add secondary check in RT Data region(s)

VERS="0.2"

# get the absolute path of the executable
SELF_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && SELF_PATH=$SELF_PATH/$(basename -- "$0")
source "${SELF_PATH%/*}"/shared.sh

DRIVER="MacPmem.kext"

declare -a regionStart
declare -a regionLength
declare -a pmemArr

byteCount=2048
driverIsLoaded=0
weLoadedDriver=0
foundPositiveId=0

# Initial checks

checkNonOC=$( ioreg -lw0 -p IODeviceTree | grep boot-log )
if [ ! -z "$checkNonOC" ]; then
  exit 1
fi

if [ ! -d "$DRIVERS_DIR"/"$DRIVER" ]; then
  exit 1
fi

# ================================================================

isDriverLoaded()
{
  checkDriver=$( sudo kextstat | grep com.google.MacPmem )
  if [ ! -z "$checkDriver" ]; then
    echo 1
  fi
}

# ================================================================

if [ $(isDriverLoaded) ]; then

  driverIsLoaded=1

else

  sudo cp -R "$DRIVERS_DIR"/"$DRIVER" /tmp
  sudo chmod -R 755 /tmp/"$DRIVER"
  sudo chown -R root:wheel /tmp/"$DRIVER"
  sudo kextload /tmp/"$DRIVER"

  if [ $(isDriverLoaded) ]; then

    driverIsLoaded=1
    weLoadedDriver=1
    
  fi
fi

if [ $driverIsLoaded -eq 1 ]; then

  hexStringToSearchFor="4f70656e436f7265506b67"

  regionDetails=$( sudo cat /dev/pmem_info | grep -A5 "(EFI) EfiRuntimeServicesCode" )

  if [ -n "$regionDetails" ]; then

    regionStart=$( echo "${regionDetails}" | sed -n 4p )
    regionStart="${regionStart##*: }"
    regionLength=$( echo "${regionDetails}" | sed -n 5p )
    regionLength="${regionLength##*: }"

    blockCount=$(( $regionLength / $byteCount ))
    skipBytes=$(( $regionStart / $byteCount ))

    bytes=$( sudo dd 2>/dev/null if=/dev/pmem bs=$byteCount count=$blockCount skip=$skipBytes | perl -ne '@a=split"";for(@a){printf"%02x",ord}' )

    if [[ "$bytes" == *$hexStringToSearchFor* ]]; then
      echo "OpenCore"
      foundPositiveId=1
    fi
  fi

  if [ $foundPositiveId -eq 0 ]; then

    unset regionStart
    unset regionLength

    hexStringToSearchFor="7363616e2d706f6c696379"

    pmemArr+=( $(sudo cat /dev/pmem_info) )

    for (( a=0; a<${#pmemArr[@]}; a++ )); do
      if [ "${pmemArr[$a]}" == "\"EfiRuntimeServicesData\"" ]; then
        regionStart+=("${pmemArr[$((a+2))]}")
        regionLength+=("${pmemArr[$((a+4))]}")
      fi
    done

    if [ ${#regionStart[@]} -gt 0 ]; then

      for (( a=0; a<${#regionStart[@]}; a++ )); do

        blockCount=$(( ${regionLength[$a]} / $byteCount ))
        skipBytes=$(( ${regionStart[$a]} / $byteCount ))

        bytes=$( sudo dd 2>/dev/null if=/dev/pmem bs=$byteCount count=$blockCount skip=$skipBytes | perl -ne '@a=split"";for(@a){printf"%02x",ord}' )

        if [[ "$bytes" == *$hexStringToSearchFor* ]]; then
          echo "OpenCore"
          break
        fi

      done

    fi
  fi

  if [ $weLoadedDriver -eq 1 ]; then
    sudo kextunload /tmp/"$DRIVER"
    [[ -d /tmp/"$DRIVER" ]] && sudo rm -rf /tmp/"$DRIVER"
  fi

fi

exit 0
