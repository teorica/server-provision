#!/bin/bash
set -euo pipefail

if [ ! "$(id -u)" -eq 0 ]; then
	echo "Only root can execute me. Bye." >&2
	exit 1
fi

readonly HELPERS_LIB="./lib/helpers.sh"
if [ ! -r "$HELPERS_LIB" ]; then
	echo "Unable to load '$HELPERS_LIB'. Quitting." >&2
	exit 1
fi
# Library file exists and is readable. Load it.
# shellcheck source=lib/helpers.sh
source "$HELPERS_LIB"

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
	log ok "'${job_id}' has exactly ${QTY_ALLOWED_FIELDS} fields."
}

process_job "${JOBS_IN_DIR}/dummy_job"
