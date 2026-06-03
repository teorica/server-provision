#####################################
# Constants
#####################################
readonly JOBS_IN_DIR="./jobs_in" 				# Jobs-in dir (written by PHP).
readonly JOBS_OUT_DIR="./jobs_out" 			# Jobs-out dir (written by Bash).
readonly LOGS_DIR="/var/log/provision"
readonly LOGS_FILE="main.log"

log() {
	local level="${1:-info}"
	local msg="${2:-}"
	local datetime=$(date "+%Y-%m-%d %H:%M:%S")
	local prefix

	[ -z "$msg" ] && return 1

	case "$level" in
		err)	prefix="ERROR:" ;;
		ok)		prefix="SUCCESS:" ;;
		*)		prefix="INFO:" ;;
	esac	

	if [ ! -r "$LOGS_DIR/$LOGS_FILE" ]; then
		mkdir -p "$LOGS_DIR"
		chmod 700 "$LOGS_DIR"
		touch "$LOGS_DIR/$LOGS_FILE"
		chmod 600 "$LOGS_DIR/$LOGS_FILE"
	fi
	printf '[ %s ] %s %s\n' "$datetime" "$prefix" "$msg" >> "$LOGS_DIR/$LOGS_FILE"
}

# Make sure the quantity and name of
# keys received from PHP are correct.
# No extra/missing keys.
# Quantity of keys is also checked.
# Not empty/null values also checked.
is_format_ok() {
	local job_file="$1"
	# From bash array to json so jq manages it better.
	local bash2json=$(printf '%s\n' "${JSON_KEYS[@]}" | jq -R. | jq -s -c.)

	jq -e --argjson need "$bash2json" '
		(keys | sort) == ($need | sort) and
		all(.[];.!= null and.!= "")
	' "$job_file" > /dev/null	
}

# ============================================
# Validate input. Bash is the last seatbelt.
# Remember to check the constant holding
# the json keys for naming vars.
# ============================================
are_json_values_ok() {
    [[ $user_email =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]] || return 1
    [[ $user_names =~ ^[A-Za-z0-9\ _-]{1,64}$ ]] || return 1
    [[ $user_subdomain =~ ^[a-z0-9-]{1,63}$ ]] || return 1
}
