#!/bin/bash
set -euo pipefail

#####################################
# Constants
#####################################
readonly JOBS_IN_DIR="./jobs_in" 				# Jobs-in dir (written by PHP).
readonly JOBS_OUT_DIR="./jobs_out" 			# Jobs-out dir (written by Bash).
readonly LOGS_DIR="/var/log/provision"
readonly LOGS_FILE="main.log"
readonly QTY_ALLOWED_LINES=3

log() {
	local level="${1:-info}"
	local msg="${2:-}"
	local datetime prefix
	datetime=$(date "+%Y-%m-%d %H:%M:%S")

	[ -z "$msg" ] && return 1

	case "$level" in
		err)	prefix="ERROR:" ;;
		ok)		prefix="SUCCESS:" ;;
		*)		prefix="INFO:" ;;
	esac	

	if [ ! -r "${LOGS_DIR}/${LOGS_FILE}" ]; then
		mkdir -p "${LOGS_DIR}"
		chmod 700 "${LOGS_DIR}"
		touch "${LOGS_DIR}/${LOGS_FILE}"
		chmod 600 "${LOGS_DIR}/${LOGS_FILE}"
	fi
	printf '[ %s ] %s %s\n' "$datetime" "$prefix" "$msg" >> "${LOGS_DIR}/${LOGS_FILE}"
}

process_job() {
	local job_id
	local job_file="$1" 						# Example: /full/path/to/job/file/mdk3KdAeUd
	job_id=$(basename "$job_file")	# Example: mdk3KdAeUd

	if ! is_format_ok "$job_file"; then
		log "err" "Job file '$job_id' badly formatted. Quitting."
		# TODO: Write to the output file so that user with this specific job
		# knows something went wrong.
		return 1
	fi
	log ok "'${job_id}' has exactly ${QTY_ALLOWED_LINES} lines."

	return 0
}

is_format_ok() {
	local job_file="$1"
	[ $(wc -l < "$job_file") -eq "$QTY_ALLOWED_LINES" ] || return 1
	return 0
}
