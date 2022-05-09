# available as examples/lib.inc

myFunc() {
	local msg="${1}"

	local log
	log="[$(date)] ${msg}"
    echo "${log}"
	if [ -n "${LOG_FILE_PATH}" ]; then
        echo "${log}" 2>/dev/null >> "${LOG_FILE_PATH}"
	fi
}
