# initialize state variables
#
# exports:
#     __error_args: arguments to be displayed in the error message
#
# warnings:
#     _WARNING_CANNOT_IDENTITY_DISTRO: if The distribution could not be identified automatically
#
# throws:
#     _ERROR_INVALID_DISTRO:         if the distribution is invalid
_state () {
	if [ -z "$_LANG" ]; then
		# _LANG: "pt" or "en". Otherwise "en" is applied
		_LANG="$(echo "$LANG" | cut -c 1-2)"
	fi&&if [ -z "$_DISTRO_NAME" ]; then
		# _DISTRO_NAME: "Linux Mint", "Ubuntu", "Debian", "Arch Linux" or outhers. Error if The distribution could not be identified automatically
		#
		# automatically detects the name of the distribution currently running
		#
		# warnings:
		#     _WARNING_CANNOT_IDENTITY_DISTRO: if The distribution could not be identified automatically
		_DISTRO_NAME="$("$_SRC/util/get_distro_name.sh")"
	fi&&if [ -z "$_DISTRO" ]; then
		# _DISTRO: "apt-based" or "pacman-based"
		#
		# writes to standard output the name of the group to which
		# the distribution belongs ("apt-based" or "pacman-based")
		#
		# exports:
		#     __error_args: arguments to be displayed in the error message
		#
		# throws:
		#     _ERROR_INVALID_DISTRO:         if the distribution is invalid
		_DISTRO="$("$_SRC/util/get_distro.sh")"
	fi&&if [ -z "$_USE_COLORS" ]; then
		# _USE_COLORS: 0 to not colors
		_USE_COLORS=1
	fi&&if [ -z "$_SET_WALLPAPER" ]; then
		# _SET_WALLPAPER: 0 to not set wallperper
		_SET_WALLPAPER=1
	fi&&if [ -z "$_WALLPAPER" ]; then
		# _WALLPAPER: wallpaper path
		_WALLPAPER="$_SRC/../img/wallpaper.jpg"
	fi
}

_state "$@"
