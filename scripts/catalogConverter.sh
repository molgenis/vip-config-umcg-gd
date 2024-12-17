#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
SCRIPT_NAME="$(basename "$0")"
WORK_DIR="${WORK_DIR:-"${SCRIPT_DIR}"}"

usage() {
  echo -e "usage: ${SCRIPT_NAME} [-i <arg> -p <arg> -f]
  -i, --input             <arg>  path to input file
  -p, --postfix           <arg>  postfix for the output file e.g. version
  -f, --force             overwrite existing output files"
}

validate() {
  if [ -z "${1}" ]; then
    >&2 echo -e "error: missing required -i / --input"
    usage
    exit 2
  fi
  if ! [ -f "${1}" ] ; then
    >&2 echo -e "error: input '${1}' does not exist"
    exit 2
  fi

  if [ -z "${2}" ]; then
    >&2 echo -e "error: missing required -p / --postfix"
    usage
    exit 2
  fi
  if [ -f "VIP_catalog_${2}.json" ] && [[ $3 != 1 ]]; then
    >&2 echo -e "error: VIP_catalog_${2}.json exists, use --force to overwrite."
    exit 2
  fi
  if [ -f "VIP_catalog_${2}.bed" ] && [[ $3 != 1 ]]; then
    >&2 echo -e "error: VIP_catalog_${2}.bed exists, use --force to overwrite."
    exit 2
  fi
}

process() {
  if [ -f "VIP_catalog_${2}.json" ] && [[ $3 == 1 ]]; then
    rm "VIP_catalog_${2}.json"
  fi
  if [ -f "VIP_catalog_${2}.bed" ] && [[ $3 == 1 ]]; then
    rm "VIP_catalog_${2}.bed"
  fi

  {
  read #skip header
  echo -e "[" >> "VIP_catalog_${2}.json"
  while IFS=$'\t' read -r -a array
    do
    if [[ "${array[1]}" != "" ]]; then
    echo -e "{
\"LocusId\":\"${array[5]}\",
\"HGNCId\":${array[7]},
\"DisplayRU\":\"${array[9]}\",
\"LocusStructure\":\"${array[10]}\",
\"ReferenceRegion\":\"${array[0]}:${array[1]}-${array[2]}\",
\"VariantType\":\"Repeat\",
\"Disease\":\"${array[6]}\",
\"NormalMax\":${array[11]},
\"PathologicMin\":${array[12]}
}, " >> "VIP_catalog_${2}.json"
    echo -e "${array[0]}\t${array[1]}\t${array[2]}\t${array[3]}\t${array[4]}\t${array[5]}" >> VIP_catalog_${2}.bed
  fi
  done
}< "${1}"
#remove trailing comma
sed -i '$ s/..$//' "VIP_catalog_${2}.json"
echo -e "]" >> "VIP_catalog_${2}.json"
}

main() {
  local postfix=""
  local input=""
  local force=""

  # Parse the command-line arguments
  local args=$(getopt -o i:p:f --long input:,postfix:force -- "$@")
  eval set -- "${args}"

  while :; do
    case "$1" in
    -i | --input )
      input=$(realpath "$2")
      shift 2 ;;
    -p | --postfix)
      postfix="$2"
      shift 2 ;;
	-f | --force)
      force="1"
      shift 1 ;;
    --)
      shift
      break ;;
    *)
      echo "Invalid option : $1"
      exit 1 ;;
    esac
  done

  validate $input $postfix $force
  process $input $postfix $force
}

main "${@}"