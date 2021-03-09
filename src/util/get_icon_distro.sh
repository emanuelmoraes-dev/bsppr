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

_get_icon_distro "$@"

