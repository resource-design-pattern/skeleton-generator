#!/bin/bash
# @author Exadra37(Paulo Silva) <exadra37ingmailpointcom>
# @since  2016/05/21
# @link   http://exadra37.com

set -e


#################################################################################################################################################################
# Functions for Sourcing and Cloning Dependencies
#################################################################################################################################################################

    function Git_Clone_Dependency
    {
        local vendor_name="${1}"
        local package_name="${2}"
        local package_version="${3}"
        local domain_name="${4}"

        local vendor_name_path="./../vendor/${vendor_name}"

        [ -z "${domain_name}" ] && domain_name="github.com"

        # https://github.com/exadra37-bash/file-system.git
        local from_github_repo="https://${domain_name}/${vendor_name}/${package_name}.git"

        local to_vendor_path="${vendor_name_path}/${package_name}"

        ( [ -d "${vendor_name_path}" ] || mkdir -p "${vendor_name_path}" ) && git clone -b "${package_version}" --single-branch --depth 1 "${from_github_repo}" "${to_vendor_path}"
    }

    function Source_Dependency
    {
        local vendor_name="${1}"
        local package_name="${2}"
        local package_version="${3}"
        local file_path="${4}"
        local domain_name="${5}"

        local source_path="../vendor/${vendor_name}/${package_name}/${file_path}.sh"

        [ -f "${source_path}" ] && source "${source_path}" || Git_Clone_Dependency "${vendor_name}" "${package_name}" "${package_version}" "${domain_name}"
    }


#################################################################################################################################################################
# Functions
#################################################################################################################################################################

    function Generate_Config_Skeleton
    {
        local base_path="$1"
        local config_dir="${base_path}/config"

        Print_Title ">>> Generating Config Skeleton"

        Create_Git_Dir "$config_dir"
    }

    function Generate_Docs_Skeleton
    {
        local base_path="$1"
        local docs_dir="${base_path}/docs"

        Print_Title ">>> Generating Docs Skeleton"

        Create_Git_Dir "${docs_dir}"
    }

    function Generate_Deploy_Skeleton
    {
        local base_path="$1"
        local deploy_dir="${base_path}/deploy"

        Print_Title ">>> Generating Deploy Skeleton"

        Create_Git_Dir "${deploy_dir}"
        Create_Git_Dir "${deploy_dir}/initial"
        Create_Git_Dir "${deploy_dir}/always"
    }

    function Generate_Tests_Skeleton
    {
        local base_path="$1"
        local tests_dir="${base_path}/tests"

        local name_suffix="Spec"

        Print_Title ">>> Generating Public Skeleton"

        Create_Git_Dir "${tests_dir}"
        Create_Git_Dir "${tests_dir}/Setup"
        Create_Git_Dir "${tests_dir}/Setup/Helpers"
        Create_Git_Dir "${tests_dir}/Setup/Helpers/Traits"
        Create_Git_Dir "${tests_dir}/Setup/Fixtures"
        Create_Git_Dir "${tests_dir}/Setup/Stubs"
        Create_Git_Dir "${tests_dir}/PhpSpec"
        Create_Git_Dir "${tests_dir}/Behat"
    }

    function Generate_Public_Skeleton
    {
        local base_path="$1"
        local public_dir="${base_path}/public"

        Print_Title ">>> Generating Public Skeleton"

        Create_Git_Dir "${public_dir}"
        Create_Git_Dir "${public_dir}/css"
        Create_Git_Dir "${public_dir}/js"
        Create_Git_Dir "${public_dir}/img"
        Create_Git_Dir "${public_dir}/docs"
    }

    function Generate_Factories_Skeleton
    {
        local base_path="$1"
        local factories_dir="${base_path}/Factories"

        Print_Title ">>> Generating Factories"

        Create_Git_Dir "$factories_dir"
    }

    function Generate_Adapters_Skeleton
    {
        local base_path="$1"
        local adapters_dir="${base_path}/Adapters"

        Print_Title ">>> Generating Adapters"

        Create_Git_Dir "$adapters_dir"
    }

    function Generate_Commons_Skeleton
    {
        local base_path="$1"
        local commons="$2"
        local common_dir="${base_path}/Common"

        [ -z "$commons" ] && local commons="Traits,Validators,Parsers,Formatters,Transformers,Services,Forms,Commands"

        IFS=',' read -r -a commons <<< "$commons"

        Print_Title ">>> Generating Common"
        Create_Git_Dir "$common_dir"

        for common in "${commons[@]}"
            do
                local common_folder="${common_dir}/${common}"

                Print_Bold_Label_With_Text "Common Folder: " "$common_folder" "blue"

                Create_Git_Dir "$common_folder"
        done
    }

    function Generate_Resource_Skeleton
    {
        local base_path="$1"
        local appends="$2"
        local commons="$3"
        local includes="$4"
        local excludes="$5"
        local package_name="$6"
        local file_extension="$7"
        local resources="$8"
        local name_separator="${9}"
        local name_suffix="${10}"

        # eg: vendor/package/name/src/Resources
        local resources_dir="${base_path}/Resources"
        Create_Git_Dir "${resources_dir}"

        declare -a local resources_array
        IFS=',' read -r -a resources_array <<< "$resources"

        Print_Title ">>> Generating Resources"

        # Resources eg: Users, Categories, Products
        for resource in "${resources_array[@]}"
            do
                Print_Title "Creating Resource ${resource}"

                # eg: vendor/package/name/src/Resources/Users
                local resource_folder="${resources_dir}/${resource}"
                Create_Git_Dir "$resource_folder"

                Generate_Resource_Actions "${resource}" "${includes}" "${resource_folder}" "${name_separator}" "${name_suffix}"
        done
    }

    function Generate_Resource_Actions
    {
        local resource="$1"
        local includes="$2"
        local resource_folder="$3"
        local name_separator="$4"
        local name_suffix="$5"

        local resource_actions="Create,Read,Update,Delete"
        IFS=',' read -r -a resource_actions <<< "$resource_actions"

        [ -z "$includes" ] && local includes="Interfaces,Controllers,Commands,Handlers,Business${name_separator}Logic,Services,Repositories,Models,Validators"

        declare -a local includes_array
        IFS=',' read -r -a includes_array <<< "$includes"

        # Resource Actions will match CRUD operations
        for resource_action in "${resource_actions[@]}"
            do
                # eg: vendor/package/name/src/Resources/Users/Create
                local resource_dir_action="${resource_folder}/${resource_action}"
                Create_Git_Dir "$resource_dir_action"

                # Includes eg: Interfaces, Handlers, Business_Logic, ...
                for include in "${includes_array[@]}"
                    do
                        # eg: vendor/package/name/src/Resources/Users/Create/Business_Logic
                        local include_dir="${resource_dir_action}/${include}"
                        Create_Git_Dir "${include_dir}"

                        Generate_Resource_Files "${include_dir}" "${resource}" "${include}" "${resource_action}" "${file_extension}" "${name_separator}" "${name_suffix}"
                done
        done
    }

    function Generate_Resource_Files
    {
        local include_dir="$1"
        local resource="$2"
        local include="$3"
        local resource_action="$4"
        local file_extension="$5"
        local name_separator="$6"

        local name_suffix
        [ -z "$7" ] && name_suffix="" || name_suffix="${name_separator}$7"

        local resource_single=$( Plural_To_Singular "${resource}" )
        local resource_multiple="$resource"
        local include_single=$( Plural_To_Singular "${include}" )

        # eg: vendor/package/name/src/Resources/Users/Create/Business_Logic/Create_User_Business_Logic.php
        local file_single="${include_dir}/${resource_action}${name_separator}${resource_single}${name_separator}${include_single}${name_suffix}.${file_extension}"
        Print_Bold_Label_With_Text "File: " "$file_single" "magenta"
        Create_File "${file_single}"

        # eg: vendor/package/name/src/Resources/Users/Create/Business_Logic/Create_Users_Business_Logic.php
        local file_multiple="${include_dir}/${resource_action}${name_separator}${resource_multiple}${name_separator}${include_single}${name_suffix}.${file_extension}"
        Print_Bold_Label_With_Text "File: " "$file_multiple" "magenta"
        Create_File "${file_multiple}"

        # we want to avoid creating a file like eg:
        #  vendor/package/name/src/Resources/Users/Create/Business_Logic/Create_Users_Interfaces_Interface.php
        if [ "Interfaces" != "${include}" ]
            then

                # eg: vendor/package/name/src/Resources/Users/Create/Business_Logic/Create_User_Business_Logic_Interface.php
                local file_single_interface="${include_dir}/${resource_action}${name_separator}${resource_single}${name_separator}${include_single}${name_suffix}${name_separator}Interface.${file_extension}"
                Print_Bold_Label_With_Text "File: " "$file_single_interface" "magenta"
                Create_File "${file_single_interface}"

                # eg: vendor/package/name/src/Resources/Users/Create/Business_Logic/Create_Users_Business_Logic_Interface.php
                local file_multiple_interface="${include_dir}/${resource_action}${name_separator}${resource_multiple}${name_separator}${include_single}${name_suffix}${name_separator}Interface.${file_extension}"
                Print_Bold_Label_With_Text "File: " "$file_multiple_interface" "magenta"
                Create_File "${file_multiple_interface}"
        fi
    }

    function Get_Vendor_Path
    {
        local package_name="$1"

        local vendor_path

        # vendor/package/name
        [ -d "../../../vendor" ] && vendor_path="." || vendor_path="vendor/${package_name}"

        echo "skeleton/${vendor_path}"
    }
