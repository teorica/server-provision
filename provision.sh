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

for job_file in "$JOBS_IN_DIR"/*; do
	[[ -f "$job_file" ]] || continue
	if ! process_job "$job_file"; then
		continue
	fi
done
