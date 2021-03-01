# throws:
#     _ERROR_INVALID_DISTRO:         if the distribution is invalid
#     _ERROR_CANNOT_IDENTITY_DISTRO: if The distribution could not be identified automatically
_distros_export () {
	local distro &&
	__error_args=() && # export

	if [ -z "$distro" ]; then
		if which apt 1> /dev/null 2>&1; then
			distro='apt-based'
			
		elif which pacman 1> /dev/null 2>&1; then
			distro='arch-linux'
		else
			# automatically detects the name of the distribution currently running
			#
			# throws:
			#     _ERROR_CANNOT_IDENTITY_DISTRO: if The distribution could not be identified automatically
			distro="$("$_SRC/util/get_distro_name.sh")" &&

			__error_args[0]="$distro" &&
			return $_ERROR_INVALID_DISTRO
		fi
	fi &&

	case "$distro" in
		apt-based)  source "$_SRC/distros/apt-based.sh";;
		arch-linux) source "$_SRC/distros/arch-linux.sh";;
		*) __error_args[0]="$distro" && return $_ERROR_INVALID_DISTRO;;
	esac
}

_distros_export "$@"

