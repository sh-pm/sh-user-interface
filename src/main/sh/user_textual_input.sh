#!/bin/bash

source ../../../bootstrap.sh

include_lib sh-logger
include_lib sh-commons

ensure_user_confirm_before_proceed() {	 
	declare -A params=( \
		[DESCRIBE_SITUATION_MSG]="$1" \
		[YES_NO_QUESTION]="$2" \
	);
	
	# Check number of params 
	if ! is_number_params_correct 2 "$@"; then
		print_usage_help "$(declare -p params)" "$@" -f
	    exit "$FALSE"
	fi
	 
	if ! is_user_confirm_before_proceed "${params[DESCRIBE_SITUATION_MSG]}" "${params[YES_NO_QUESTION]}" ; then
    	log_warn "Abort operation"
        exit 1;	
	fi
}

is_user_confirm_before_proceed() {	 
	declare -A params=( \
		[DESCRIBE_SITUATION_MSG]="$1" \
		[YES_NO_QUESTION]="$2" \
	);
	
	# Check number of params 
	if ! is_number_params_correct 2 "$@"; then
		print_usage_help "$(declare -p params)" "$@" -f
	    exit "$FALSE"
	fi	 

	echo "${params[DESCRIBE_SITUATION_MSG]}"
	read -r -p "${params[YES_NO_QUESTION]} " response
	echo "SUA RESPOSTA FOI: |$response|"
	case "$response" in
	    [y]|[Y]|[e]|[E]|[s]|[S]|[y]|[Y])	        
	        return "$TRUE";
	        ;;
	    *)
	        return "$FALSE";
	        ;;
	esac
}