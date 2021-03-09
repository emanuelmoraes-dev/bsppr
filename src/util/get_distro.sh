# writes to standard output the name of the group to which
# the distribution belongs ("apt-based" or "pacman-based")
#
# exports:
#     __error_args: arguments to be displayed in the error message
#
# throws:
#     _ERROR_INVALID_DISTRO:         if the distribution is invalid
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

_get_distro "$@"
