# exports:
#     __error_args: arguments to be displayed in the error message
#
# throws:
#     _ERROR_INVALID_DISTRO:         if the distro is invalid
_distros_export () {
	__error_args=() && # export

	case "$_DISTRO" in
		apt-based)  source "$_SRC/distros/apt-based.sh";;
		pacman-based) source "$_SRC/distros/pacman-based.sh";;
		*) __error_args[0]="$_DISTRO" && return $_ERROR_INVALID_DISTRO;;
	esac
}

_distros_export "$@"

