## @fn void init (void)
## @brief Initialize environment variables for shellm scripts
init() {
  if ! echo "$*" | grep -q 'no-data'; then
    DATADIR="${shellm}/usr/data/${BASH_SOURCE[0]##*/}"
    mkdir -p "${DATADIR}" 2>/dev/null
  fi
}

## @fn void check (file)
## @brief Check if packages/executables in file are installed,
## or in $0 if no file given (then ask to continue or not if some are missing)
## @param [$1] File to check (default $0)
## @return Echo: missing packages/executables, question if $0
check() {
	[ "$shellm_ignore_check" = "yes" ] && return 0
	local s ret=true a=${1:-$0}
	for s in $(get_packages "$a"); do
		have_package "$s" || { err "Package $s not found !"; false; }
		ret=$( ([ $? -eq 0 ] && $ret) && echo true || echo false)
	done
	for s in $(get_depends "$a"); do
		have_command "$s" || { err "Executable $s not found !"; false; }
		ret=$( ([ $? -eq 0 ] && $ret) && echo true || echo false)
	done
	if [ -z "$1" ] && ! $ret; then
		err; err "Some required packages and/or executables were not found..."
		question "Would you like to continue anyway ? (unpredictable behavior) [yN]" || end 0
		line "-"
	fi
}

shellm_activate_check() {
	export shellm_ignore_check=no
}

shellm_deactivate_check() {
	export shellm_ignore_check=yes
}

have_command() {
	command -v "$1" >/dev/null
}

have_package() {
	dpkg-query -W -f '${Package}\n' | /bin/grep -wq "$1"
}