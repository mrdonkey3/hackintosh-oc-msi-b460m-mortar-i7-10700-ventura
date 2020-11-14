#!/bin/sh

# Copyright (C) 2020, blackosx. All rights reserved.
#
# Version 0.1   - April 29th 2020        - Initial Design
# Version 0.2   - May 6th 2020           - Rewrite to handle differences seen in 0.5.8

# get the absolute path of the executable
SELF_PATH=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && SELF_PATH=$SELF_PATH/$(basename -- "$0")
source "${SELF_PATH%/*}"/shared.sh

if [ -z "$1" ]; then
  echo "No target specified. Exiting"
  exit 1
fi

bgrep="$TOOLS_DIR/bgrep"
targetfile="$1"

buildTarget=""
versionAndDate=""

declare -a offsetArr
declare -a offsetArrAfter

searchBytesForBuildTarget="2D5858582D595959592D4D4D2D4444"
searchBytesForVersionAndDate052up="554889e5"
searchBytesForNptMessageBefore="4F433A205072656C696E6B20626C6F636B65722025612028256129202D2025720A00"
searchBytesForNptMessageAfter="004F433A204C6F6164656420636F6E66696775726174696F6E206F66202575206279746573"

oIFS="$IFS"
IFS=$'\n'

ByteWalk()
{

  local offset="$1"

  local versionMajor=""
  local versionMinor=""
  local versionYear=""
  local versionMonth=""
  local versionDay=""
  local versionAndDate=""
  local ax=0
  local byteWalkPos=0
  local byteWalkContent=""

  local offsetDecimal=$((16#$offset))

  local selection=$( tail -c +$((0x${offset}+1)) "$targetfile" | head -c 64 | xxd -p | tr -d '\n' )

  local selectionLen=${#selection}

  # Walk $selection, 1 byte at a time.

  for (( byteWalkPos=0; byteWalkPos<$selectionLen; byteWalkPos+=2 ))
  do

    byteWalkContent="${selection:$byteWalkPos:2}"

    # Find Version Major

    if [ "$versionMajor" == "" ]; then
      if [ "$byteWalkContent" == "75" ]; then
        if [ "${selection:$byteWalkPos:8}" == "753366b8" ]; then

          versionMajor="${selection:$((byteWalkPos+8)):4}"
          ax=1
          ((byteWalkPos+8))
          byteWalkContent=""

        fi
      fi

      if [ "$byteWalkContent" == "66" ]; then
        if [ "${selection:$byteWalkPos:6}" == "66c705" ]; then

          versionMajor="${selection:$((byteWalkPos+14)):4}"
          ((byteWalkPos+6))
          byteWalkContent=""

        fi
      fi
    fi

    # Find Version Minor

    if [ "$versionMajor" != "" ] && [ "$versionMinor" == "" ]; then
      if [ "$byteWalkContent" == "c6" ]; then
        if [ "${selection:$byteWalkPos:4}" == "c605" ]; then

          versionMinor="${selection:$((byteWalkPos+12)):2}"
          ((byteWalkPos+12))
          byteWalkContent=""

        fi
      fi
    fi


    # Find Version Year

    if [ "$versionMajor" != "" ] && [ "$versionMinor" != "" ] && [ "$versionYear" == "" ]; then
      if [ "$byteWalkContent" == "c7" ]; then
        if [ "${selection:$byteWalkPos:4}" == "c705" ]; then

          versionYear="${selection:$((byteWalkPos+12)):8}"
          ((byteWalkPos+4))
          byteWalkContent=""

        fi
      fi
    fi

    # Find Version Month

    if [ "$versionMajor" != "" ] && [ "$versionMinor" != "" ] && [ "$versionYear" != "" ] && [ "$versionMonth" == "" ]; then
      if [ $ax -eq 1 ]; then # as seen in 0.5.8

        versionMonth="$versionMajor"

      elif [ "$byteWalkContent" == "66" ]; then
        if [ "${selection:$byteWalkPos:6}" == "66c705" ]; then

          versionMonth="${selection:$((byteWalkPos+14)):4}"
          ((byteWalkPos+14))
          byteWalkContent=""

        fi
      fi
    fi

    # Find Version Day

    if [ "$versionMajor" != "" ] && [ "$versionMinor" != "" ] && [ "$versionYear" != "" ] && [ "$versionMonth" != "" ] && [ "$versionDay" == "" ]; then
      if [ "$byteWalkContent" == "66" ]; then
        if [ "${selection:$byteWalkPos:6}" == "66c705" ]; then

          versionDay="${selection:$((byteWalkPos+14)):4}"

        fi
      fi
    fi

  done

  versionText=$( echo "${versionMajor}${versionMinor}" | xxd -p -r )
  versionYearText=$( echo "${versionYear}" | xxd -p -r )
  versionMonthText=$( echo "${versionMonth}" | xxd -p -r )
  versionDayText=$( echo "${versionDay}" | xxd -p -r )

  [[ ! "$versionText" =~ ^[0-9]+$ ]] && versionText=""
  [[ ! "$versionYearText" =~ ^[0-9]+$ ]] && versionYearText=""
  [[ ! "$versionMonthText" =~ ^[0-9]+$ ]] && versionMonthText=""
  [[ ! "$versionDayText" =~ ^[0-9]+$ ]] && versionDayText=""

  if [ -n "$versionText" ] && [ -n "$versionYearText" ] && [ -n "$versionMonthText" ] && [ -n "$versionDayText" ]; then

    versionAndDate="${versionText}-${versionYearText}-${versionMonthText}-${versionDayText}"

  fi

  echo "$versionAndDate"

}

SearchBytesAndWalk()
{

  local searchBytes="$1"
  local MatchFound=""
  local MaxOffsetsToCheck=30

  local offsetArr=( $( "$bgrep" "$searchBytes" "$targetfile" | sed 's/^.*: //' ) )

  if [ ${#offsetArr[@]} -gt 0 ]; then

    iterations=$((${#offsetArr[@]}-1))

    # Only check the last $MaxOffsetsToCheck offsets, starting with the last first

    if [ $iterations -gt $MaxOffsetsToCheck ]; then
      lessMaxOffsets=$((iterations-MaxOffsetsToCheck))
    else
      lessMaxOffsets=$iterations
    fi

    for (( o=iterations; o>=lessMaxOffsets; o-- ))
    do

      MatchFound=$(ByteWalk "${offsetArr[$o]}")

      [[ ! -z "$MatchFound" ]] && break

    done

  fi

  unset offsetArr

  echo "$MatchFound"
}



# Find build target

offsetArr=( $( "$bgrep" "$searchBytesForBuildTarget" "$targetfile" ) )

for (( o=0; o<${#offsetArr[@]}; o++ ))
do

  offset="${offsetArr[$o]##*: }"

  offsetDecimal=$((16#$offset))

  buildTargetStartByte=$( echo "obase=16; $((offsetDecimal-2))" | bc )

  selection=$( tail -c +$((0x${buildTargetStartByte})) "$targetfile" | head -c 3 | xxd -p )

  buildTarget=$( echo "$selection" | xxd -p -r )

  [[ ! "$buildTarget" =~ ^[A-Z]+$ ]] && buildTarget=""

  [[ $DBG -eq 1 ]] && echo "buildTarget=$buildTarget"

done

unset offsetArr

[[ -z "$buildTarget" ]] && echo "Failed Target" && exit 1



# Find Version and Date

if [ "$buildTarget" == "DBG" ] || [ "$buildTarget" == "REL" ]; then

  versionAndDate=$(SearchBytesAndWalk "$searchBytesForVersionAndDate052up")

  [[ "$versionAndDate" == "" ]] && versionAndDate=$(SearchBytesAndWalk "0f8266ffffff")
  [[ "$versionAndDate" == "" ]] && versionAndDate=$(SearchBytesAndWalk "0f8268ffffff")
  [[ "$versionAndDate" == "" ]] && versionAndDate=$(SearchBytesAndWalk "0f8269ffffff")
  [[ "$versionAndDate" == "" ]] && versionAndDate=$(SearchBytesAndWalk "0f826affffff")
  
  [[ -z "$versionAndDate" ]] && echo "Failed to find version and date. Exiting" && exit 1

elif [ "$buildTarget" == "NPT" ]; then

  # ** this will be totally incorrect if the devs change debug messages **

  offsetArr=( $( "$bgrep" "$searchBytesForNptMessageBefore" "$targetfile" ) )
  offsetArrAfter=( $( "$bgrep" "$searchBytesForNptMessageAfter" "$targetfile" ) )

  if [ ${#offsetArr[@]} -eq 1 ] && [ ${#offsetArrAfter[@]} -eq 1 ]; then

    offset="${offsetArr[0]##*: }"
    offsetAfter="${offsetArrAfter[0]##*: }"

    offsetDecimal=$((16#$offset))
    offsetDecimalAfter=$((16#$offsetAfter))

    strLen=$((${#searchBytesForNptMessageBefore}/2))

    expectedStartPositionOfVersionAndDate=$((offsetDecimal+strLen))

    bytesBetweenOffsets=$((offsetDecimalAfter-expectedStartPositionOfVersionAndDate))

    if [ $bytesBetweenOffsets -eq 17 ]; then

      selection=$( tail -c +$((0x${offset}+strLen+1)) "$targetfile" | head -c 17 | xxd -p | tr -d '\n' )

      [[ $DBG -eq 1 ]] && echo "$selection"

      versionText=$( echo "${selection:0:2}${selection:4:2}${selection:8:2}" | xxd -p -r )
      versionMonthText=$( echo "${selection:12:6}" | xxd -p -r )
      versionMonthText=$( date -jf %B "$versionMonthText" '+%m' )
      versionDayText=$( echo "${selection:20:4}" | xxd -p -r )
      versionYearText=$( echo "${selection:26:8}" | xxd -p -r )

      if [ ${versionDayText:0:1} == " " ]; then
        versionDayText="0${versionDayText:1:1}"
      fi

      [[ $DBG -eq 1 ]] && echo "versionText=$versionText"
      [[ $DBG -eq 1 ]] && echo "versionMonthText=$versionMonthText"
      [[ $DBG -eq 1 ]] && echo "versionDayText=$versionDayText"
      [[ $DBG -eq 1 ]] && echo "versionYearText=$versionYearText"

      [[ ! "$versionText" =~ ^[0-9]+$ ]] && versionText=""
      [[ ! "$versionYearText" =~ ^[0-9]+$ ]] && versionYearText=""
      [[ ! "$versionMonthText" =~ ^[0-9]+$ ]] && versionMonthText=""
      [[ ! "$versionDayText" =~ ^[0-9]+$ ]] && versionDayText=""

      if [ -n "$versionText" ] && [ -n "$versionYearText" ] && [ -n "$versionMonthText" ] && [ -n "$versionDayText" ]; then

        versionAndDate="${versionText}-${versionYearText}-${versionMonthText}-${versionDayText}"

      fi

    fi

  fi

else

  echo "Unknown target: $buildTarget"

fi

IFS="$oIFS"

if [ ! -z "$buildTarget" ] && [ ! -z "$versionAndDate" ]; then

  echo "${buildTarget}-${versionAndDate}"

fi
