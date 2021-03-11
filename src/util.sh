# writes to standard output the name of the group to which
# the distro belongs ("apt-based" or "pacman-based")
#
# exports:
#     __error_args: arguments to be displayed in the error message
#
# throws:
#     _ERROR_INVALID_DISTRO: if the distro is invalid
_get_distro () {
	__error_args=() && # export
	local distro='' &&

	if which apt 1> /dev/null 2>&1; then
		distro='apt-based'
	elif which pacman 1> /dev/null 2>&1; then
		distro='pacman-based'
	else
		__error_args[0]="$_DISTRO_NAME" &&
		return $_ERROR_INVALID_DISTRO
	fi

	printf "%s" "$distro"
}

# writes to standard output the name of the distro
# currently running
#
# warnings:
#     _WARNING_CANNOT_IDENTITY_DISTRO: if The distro could not be identified automatically
_get_distro_name () {
	if [ -f /etc/os-release ]; then
    	# freedesktop.org and systemd
    	. /etc/os-release
    	OS=$NAME
    	# VER=$VERSION_ID
	elif which lsb_release 1>/dev/null 2>&1; then
    	# linuxbase.org
    	OS=$(lsb_release -si)
    	# VER=$(lsb_release -sr)
	elif [ -f /etc/lsb-release ]; then
    	# For some versions of Debian/Ubuntu without lsb_release command
    	. /etc/lsb-release
    	OS=$DISTRIB_ID
    	# VER=$DISTRIB_RELEASE
	elif [ -f /etc/debian_version ]; then
    	# Older Debian/Ubuntu/etc.
    	OS=Debian
    	# VER=$(cat /etc/debian_version)
	elif [ -f /etc/SuSe-release ]; then
    	# Older SuSE/etc.
    	OS=SuSe
	elif [ -f /etc/redhat-release ]; then
    	# Older Red Hat, CentOS, etc.
    	OS=RedHat
	else
		>&2 printf "$_WARNING_CANNOT_IDENTITY_DISTRO\n" &&
		OS=Linux
	fi &&

	printf "%s" "$OS"
}

# writes to standard output the icon for distro
#
# arguments:
#     0: distro name
#
# warnings:
#     _WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO: if there is no icon available for distro
_get_icon_distro () {
	local distro="$@" &&
	local distro_lower="$(echo -n "$distro" | tr '[:upper:]' '[:lower:]')" &&
	case "$distro_lower" in
		'linux mint') printf '%s' " ";;
		'ubuntu')     printf '%s' " ";;
		'debian')     printf '%s' " ";;
		*)            >&2 printf "$_WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO\n" "$distro";;
	esac
}

