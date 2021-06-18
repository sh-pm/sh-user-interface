#!/usr/bin/env bash

# =================================
# Internal Log
# =================================
internal_debug() {
	local ENABLE_DEBUG="false"
	if [[ "$ENABLE_DEBUG" == "true" ]]; then
		echo "$1"
	fi
}

# =================================
# Mandatory Global Variables
# =================================
# -- bootstrap file name ----------
BOOTSTRAP_FILENAME="$(basename "${BASH_SOURCE[0]}")"

# -- dependencies file name ----------
DEPENDENCIES_FILENAME="pom.sh"

# -- "Boolean's" ------------------
TRUE=0
FALSE=1

# -- Main SubPath's ---------------
if [[ -z "$SRC_DIR_SUBPATH" ]]; then
	SRC_DIR_SUBPATH="src/main/sh"
fi

if [[ -z "$LIB_DIR_SUBPATH" ]]; then
	LIB_DIR_SUBPATH="src/lib/sh"
fi

if [[ -z "$TEST_DIR_SUBPATH" ]]; then
	TEST_DIR_SUBPATH="src/test/sh"
fi

# -- Main Path's ------------------
if [[ -z "$ROOT_DIR_PATH" ]]; then
	THIS_SCRIPT_FOLDER_PATH="$( dirname "$(realpath "${BASH_SOURCE[0]}")" )"
	ROOT_DIR_PATH="${THIS_SCRIPT_FOLDER_PATH//$SRC_DIR_SUBPATH/}"		
	internal_debug "ROOT_DIR_PATH: $ROOT_DIR_PATH"
fi

if [[ -z "$SRC_DIR_PATH" ]]; then
	SRC_DIR_PATH="$ROOT_DIR_PATH/$SRC_DIR_SUBPATH"
	internal_debug "SRC_DIR_PATH: $SRC_DIR_PATH"
fi

if [[ -z "$LIB_DIR_PATH" ]]; then
	LIB_DIR_PATH="$ROOT_DIR_PATH/$LIB_DIR_SUBPATH"
	internal_debug "LIB_DIR_PATH: $LIB_DIR_PATH"
fi

if [[ -z "$TEST_DIR_PATH" ]]; then
	TEST_DIR_PATH="$ROOT_DIR_PATH/$TEST_DIR_SUBPATH"
	internal_debug "TEST_DIR_PATH: $TEST_DIR_PATH"
fi

if [[ -z "$TARGET_DIR_PATH" ]]; then
	TARGET_DIR_PATH="$ROOT_DIR_PATH/target"
	internal_debug "TARGET_DIR_PATH: $TARGET_DIR_PATH"
fi

# =================================
# Load dependencies
# =================================
source "$ROOT_DIR_PATH/pom.sh"

# =================================
# Include Management Libs and Files
# =================================

if [[ -z ${DEPS_INCLUDED+x}  ]]; then
	declare -A DEPS_INCLUDED=( \
		
	);
fi

if [[ -z ${FILES_INCLUDED+x}  ]]; then
	declare -A FILES_INCLUDED=( \
		
	);
fi

function include_lib () {
    
    LIB_TO_INCLUDE=$1
    
    # Sanitize param
	if [[ -z "$LIB_TO_INCLUDE" ]]; then
		echo "Could't perform include_lib: function receive empty param."
		exit 1001
	fi
	
	# Validate include
	# Include library only one time
	if [[ ! -z "${DEPS_INCLUDED[$LIB_TO_INCLUDE]}" ]]; then
		internal_debug "include_lib: lib $LIB_TO_INCLUDE already included."
	fi
	
	local DEP_VERSION=$( echo "${DEPENDENCIES[$LIB_TO_INCLUDE]}" | cut -d "@" -f 1 | xargs ) #xargs is to trim string!	
	local DEP_FOLDER_PATH="$LIB_DIR_PATH/$LIB_TO_INCLUDE""-""$DEP_VERSION"
	
	if [[ ! -d "$DEP_FOLDER_PATH" ]]; then
		echo "Could't perform include_lib: $LIB_TO_INCLUDE not exists in local $LIB_DIR_PATH repository"
		exit 1002
	fi
	
	for SH_FILE in "$LIB_DIR_PATH/$LIB_TO_INCLUDE""-""$DEP_VERSION"/*; do
	    if [[ "$(basename "$SH_FILE")" != "$DEPENDENCIES_FILENAME" && "$(basename "$SH_FILE")" != "$BOOTSTRAP_FILENAME" ]]; then
			include_file "$SH_FILE" 
		else
	        internal_debug "$SH_FILE NOT included" 
		fi
	done
	
	DEPS_INCLUDED[$LIB_TO_INCLUDE]=$TRUE
}

function include_file () {
    
    FILEPATH_TO_INCLUDE=$1
    
    # Sanitize param
	if [[ -z "$FILEPATH_TO_INCLUDE" ]]; then
		echo "Could't perform include_file: function receive empty param."
		exit 1003
	fi
	
	# Validate include
	# Include file only one time
	if [[ ! -z "${FILES_INCLUDED[$FILEPATH_TO_INCLUDE]}" ]]; then
		internal_debug "$FILEPATH_TO_INCLUDE already included."
	else 
		source "$FILEPATH_TO_INCLUDE"
		
		FILES_INCLUDED[$FILEPATH_TO_INCLUDE]=$TRUE
		
	    internal_debug "$FILEPATH_TO_INCLUDE included"	
	fi	
}
