#!/bin/bash
set -euo pipefail

if [ ! "$(id -u)" -eq 0 ]; then
	echo "Only root can execute me. Bye." >&2
	exit 1
fi

# Try to load library file with constants and functions.
readonly HELPERS_LIB="./lib/helpers.sh"
if [ ! -r "$HELPERS_LIB" ]; then
	echo "Unable to load '$HELPERS_LIB'. Quitting." >&2
	exit 1
fi
# Library file exists and is readable. Load it.
source "$HELPERS_LIB"

process_job() {
	# Full path to json job file. Example: /path/to/job/file/mdk3KdAeUd
	local job_file="${1:-}"
	# Job file name only. Example: sjAjda8Ja
	local job_id=$(basename "$job_file")

	if ! is_format_ok "$job_file"; then
		log "err" "Job file badly formatted. Quitting."
		# TODO: Write to the output file so that user with this specific job
		# knows something went wrong.
		return 1
	fi

	if ! are_json_values_ok; then
		log "err" "Invalid provided value(s). Quitting."
		# TODO: Write to the output file...
		return 1
	fi
}

process_job "dummy_input"
