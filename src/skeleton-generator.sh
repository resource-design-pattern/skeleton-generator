#!/bin/bash
# @author Exadra37(Paulo Silva) <exadra37ingmailpointcom>
# @since  2016/05/21
# @link   http://exadra37.com

set -e


#################################################################################################################################################################
# Declare Variables
#################################################################################################################################################################

    script_path=$( cd "$( dirname "$0" )" && pwd )


##################################################################################################################################################################
# Sourcing Dependencies
#########################################d########################################################################################################################

    source "${script_path}/sourcing/functions.source.sh"
    source "${script_path}/../vendor/exadra37-bash/file-system/src/sourcing/file-system-trait.source.sh"
    source "${script_path}/../vendor/exadra37-bash/git-helpers/src/sourcing/git-helpers-trait.source.sh"
    source "${script_path}/../vendor/exadra37-bash/pretty-print/src/sourcing/pretty-print-trait.source.sh"
    source "${script_path}/../vendor/exadra37-bash/package-signature/src/sourcing/package-signature-trait.source.sh"
    source "${script_path}/../vendor/exadra37-bash/strings-manipulation/src/sourcing/strings-manipulation-trait.source.sh"


#################################################################################################################################################################
# Read Arguments
#################################################################################################################################################################

    Print_Line "Reading Arguments"

    ([ "${1:0:1}" == "-" ] || [ -z "$1" ]) && Print_Fatal_Error "Missing Package Name, eg: package/name" || package_name="$1"
    ([ "${2:0:1}" == "-" ] || [ -z "$2" ]) && Print_Fatal_Error "Missing file extension for the programming language you want to use, eg: php" || file_extension="$2"
    ([ "${3:0:1}" == "-" ] || [ -z "$3" ]) && Print_Fatal_Error "Missing resource(s), eg: Products or eg: Products,Categories,Users" || resources="$3"

    shift 3

    name_separator="_"

    while getopts ':a:c:e:i:s' flag; do
      case "${flag}" in
        a) appends="$OPTARG";;
        c) commons="$OPTARG";;
        e) excludes="$OPTARG";;
        i) includes="$OPTARG";;
        s) name_separator="";;
        \?) Print_Fatal_Error "option -$OPTARG is not supported.";;
        :) Print_Fatal_Error "option -$OPTARG requires a value.";;
      esac
    done


#################################################################################################################################################################
# Declaring and Assigning Variables
#################################################################################################################################################################

    start_time=`date +%s`
    package="Skeleton Generator"
    version="1.0.0"
    source_code="https://github.com/resource-design-pattern/Skeleton-generator/blob/${version}"
    license="${source_code}/LICENSE"
    docs="${source_code}/README.md"


#################################################################################################################################################################
# Start Execution
#################################################################################################################################################################

    Print_Title ">>> START RESOURCES GENERATOR <<<<"

    vendor_path="$( Get_Vendor_Path ${package_name} )"

    # Generating Main Skeleton
    Generate_Config_Skeleton "${vendor_path}"
    Generate_Deploy_Skeleton "${vendor_path}"
    Generate_Docs_Skeleton "${vendor_path}"
    Generate_Public_Skeleton "${vendor_path}"

    # Generating for Tests
    Generate_Tests_Skeleton "${vendor_path}"
    Generate_Adapters_Skeleton "${vendor_path}/tests/PhpSpec"
    Generate_Factories_Skeleton "${vendor_path}/tests/PhpSpec"
    Generate_Commons_Skeleton  "${vendor_path}/tests/PhpSpec" "${commons}"
    Generate_Resource_Skeleton "${vendor_path}/tests/PhpSpec" "${appends}" "${commons}" "${includes}" "${excludes}" "${package_name}" "${file_extension}" "${resources}" "${name_separator}" "${name_suffix}"

    #Generating for src
    Generate_Adapters_Skeleton "${vendor_path}/src"
    Generate_Factories_Skeleton "${vendor_path}/src"
    Generate_Commons_Skeleton  "${vendor_path}/src" "${commons}"
    Generate_Resource_Skeleton "${vendor_path}/src" "${appends}" "${commons}" "${includes}" "${excludes}" "${package_name}" "${file_extension}" "${resources}" "${name_separator}" "${name_suffix}"


#################################################################################################################################################################
# End Execution
#################################################################################################################################################################

    printPackageInfo "$package" "$version" "$license" "$source_code" "$docs"
    exit 0
