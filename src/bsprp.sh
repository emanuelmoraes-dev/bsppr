#!/usr/bin/env sh
# vim: noet ci pi sts=0 sw=4 ts=4
# script: bsprp (extends https://github.com/terroo/aptporn)
# describe: Linux Mint, Ubuntu Debian and Arch Linux install bspwm + polybar and more
# author1: Marcos Oliveira <https://terminalroot.com.br/shell>
# author2: Emanuel Moraes <https://github.com/emanuelmoraes-dev>
# version: 3.0
# license: GNU GPLv3

_VERSION="${0##*/} version 3.0"
_SRC="$(dirname "$0")"

# checks if the user is not root
#
# throws:
#     _ERROR_ROOT_NOT_ALLOWED: if the user is root
_root_verify () {
    if [ $(id -u) -eq 0 ]; then
        return $_ERROR_ROOT_NOT_ALLOWED
    fi
}

# include global variables from scripts
#
# exports:
#     __error_args: arguments to be displayed in the error message
#
# warnings:
#     _WARNING_CANNOT_IDENTITY_DISTRO: if the distribution could not be identified automatically
#
# throws:
#     _ERROR_INVALID_DISTRO:         if the distribution is invalid
#     _ERROR_INCLUDE:                if the scripts cannot be included for unexpected error
_include () {
	__error_args=() && # export

	# include colors and themes
    source "$_SRC/colors.sh" &&

	# include code errors
    source "$_SRC/errors.sh" &&

	# initialize state variables
	#
	# exports:
	#     __error_args: arguments to be displayed in the error message
	#
	# warnings:
	#     _WARNING_CANNOT_IDENTITY_DISTRO: if the distribution could not be identified automatically
	#
	# throws:
	#     _ERROR_INVALID_DISTRO:         if the distribution is invalid
    source "$_SRC/state.sh" &&

	# include i18n variables
    source "$_SRC/i18n/export.sh" &&

	# exports:
	#     __error_args:           arguments to be displayed in the error message
	#     _install_dependes:      function for install dependencies
	#         throws:
	#             _ERROR_INSTALL_DEPENDES: if error on install dependencies
	#     _install_make_dependes: function for install dependencies for build
	#         throws:
	#             _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
	#     _install_polybar:       function for install "polybar" package
	#     _updates:               function for update the system
	#         throws:
	#             _ERROR_UPDATES: if there is an error in updating the system
	#     _uninstall:             function for uninstall packages and remove config files
	#
	# throws:
	#     _ERROR_INVALID_DISTRO:  if the distribution is invalid
    source "$_SRC/distros/export.sh" || (
		
		# catch erros

		local err=$? &&

		case "$err" in
			$_ERROR_INVALID_DISTRO) return $err;;
			*)                      return $_ERROR_INCLUDE;;
		esac
	)
}

# activate the extglob
#
# throws:
#     _ERROR_EXTGLOB: if extglob could not be activated
_active_extglob () {
    shopt -s extglob ||
    return $_ERROR_EXTGLOB
}


# displays help message
_usage () {
    cat <<EOF
usage: ${0##*/} [flags]
  Options:
    --install,  -i  Install aptporn
    --unistall, -u  Uninstall aptporn
    --version,  -v  Show version
    --help,     -h  Show this is message
    --update,   -U  Update your system
* Marcos Oliveira - <terminalroot.com.br> - APTPORN 2.0
* Emanuel Moraes - <https://github.com/emanuelmoraes-dev> - bsprp 3.0
EOF
}

# _start(){
#     cat <<EOF
#  █████╗ ██████╗ ████████╗██████╗  ██████╗ ██████╗ ███╗   ██╗
# ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔═══██╗██╔══██╗████╗  ██║
# ███████║██████╔╝   ██║   ██████╔╝██║   ██║██████╔╝██╔██╗ ██║
# ██╔══██║██╔═══╝    ██║   ██╔═══╝ ██║   ██║██╔══██╗██║╚██╗██║
# ██║  ██║██║        ██║   ██║     ╚██████╔╝██║  ██║██║ ╚████║
# ╚═╝  ╚═╝╚═╝        ╚═╝   ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝                      
#
#
# EOF
# }

# install fonts using svn
_git_svn_packs () {
	if [[ ! -d "${HOME}/.local/share/fonts" ]]; then
		mkdir -p "${HOME}/.local/share/fonts"
	fi &&
    svn export https://github.com/terroo/fonts/trunk/fonts ${HOME}/.local/share/fonts/fonts &&
    fc-cache -fv
}

# clone and build polybar
_build_polybar () {
	if [ -d "$_SRC/../tmp/polybar" ]; then
		rm -rf "$_SRC/../tmp/polybar"
	fi &&
    git clone --recursive https://github.com/polybar/polybar "$_SRC/../tmp/polybar" &&
    sed -i 's/read /#read /g' "$_SRC/../tmp/polybar/build.sh" &&
    sudo ./build.sh
}

# config packages
#
# warnings:
#     _WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO: if there is no icon available for distro
_cfg_all () {
	local netw &&
	local distro &&

    cp -rv "$_SRC/../config/bspwm/" ${HOME}/.config/ &&
    cp -rv "$_SRC/../config/sxhkd/" ${HOME}/.config/ &&
    cp -rv "$_DRC/../config/dunst/" ${HOME}/.config/ &&
    cp -rv "$_SRC/../config/polybar/" ${HOME}/.config/ &&
    cp -rv "$_SRC/../config/rofi/" ${HOME}/.config/ &&
    cp "$_SRC/../img/wallpaper.jpg" ${HOME}/.wallpaper.jpg &&

	# set wallpaper
    feh --bg-scale ${HOME}/.wallpaper.jpg &&

    netw=$(ip addr | awk '/state UP/ {print $2}' | sed 's/://g') &&
    sed -i -r "s/[a-z0-9]+ ;redoo/$NETW/g" ${HOME}/.config/polybar/modules.ini &&

	# get the icon and name for distro
	#
	# arguments:
	#     0: distro name
	#
	# warnings:
	#     _WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO: if there is no icon available for distro
	distro="$($_SRC/util/get_icon_distro.sh)${_DISTRO_NAME}" &&

	# config the icon and distro name
    sed -i "s/DISTROOO/$distro/" ${HOME}/.config/polybar/user_modules.ini
    # sed -i "/$_d/s/^#//" ${HOME}/.config/polybar/scripts/menu
}

# write in standard output the final messages
_ok(){
	# clear
    printf "$_MESSAGE_INSTALLATION_FINISHED\n"
    # _start
}

# install and config all packages
#
# warnings:
#     _WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO: if there is no icon available for distro
#
# throws:
#     _ERROR_INSTALL_DEPENDES: if error on install dependencies
#     _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
_install () {
	# _start &&

	# function for install dependencies
	#
	# throws:
	#     _ERROR_INSTALL_DEPENDES: if error on install dependencies
	_install_dependes &&

	# function for install dependencies for build
	#
	# throws:
	#     _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
	_install_make_dependes &&

	# install fonts using svn
	_git_svn_packs &&

	(
		# install "polybar" package
		_install_polybar ||

		# clone and build polybar
		_build_polybar
	) &&

	# config packages
	#
	# warnings:
	#     _WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO: if there is no icon available for distro
	_cfg_all
}

# interprets the arguments and performs the proper
# functions for each
#
# exports:
#     __error_args: arguments to be displayed in the error message
#
# warnings:
#     _WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO: if there is no icon available for distro
#
# throws:
#     _ERROR_INVALID_ARGUMENT: if there is an invalid argument
#     _ERROR_INSTALL_DEPENDES: if error on install dependencies
#     _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
_params () {
    __error_args=() && # export

    if [ ${$#} -eq 0 ]; then
		# displays help message
    	usage &&
        exit 0
    fi &&

    while [ $1 ]; do
        case "$1" in
            '--help'|'-u')
				# displays help message
            	usage &&
            	exit 0;;
            '--version'|'-v')
            	printf '%s\n' "$_VERSION" &&
            	exit 0;;
            '--install'|'-i')
				# install and config all packages
				#
				# warnings:
				#     _WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO: if there is no icon available for distro
				#
				# throws:
				#     _ERROR_INSTALL_DEPENDES: if error on install dependencies
				#     _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
            	_install &&
            	exit 0;;
            '--uninstall'|'-u')
				# uninstall packages and remove config files
				_uninstall &&
				exit 0;;
			'--update'|'-U')
				# update the system
				#
				# throws:
				#     _ERROR_UPDATES: if there is an error in updating the system
				_updates &&
				exit 0;;
            *)
            	__error_args[0]="$1" &&
            	return $_ERROR_INVALID_ARGUMENT;;
        esac
    done
}

# first function to be executed. through this function,
# other functions will be called and errors will be
# handled
_main () {
    local __error_args=() && # arguments to be displayed in the error message

	# checks if the user is not root
	#
	# throws:
	#     _ERROR_ROOT_NOT_ALLOWED: if the user is root
    _root_verify &&          # checks if the user is not root

	# include global variables from scripts
	#
	# exports:
	#     __error_args: arguments to be displayed in the error message
	#
	# warnings:
	#     _WARNING_CANNOT_IDENTITY_DISTRO: if the distribution could not be identified automatically
	#
	# throws:
	#     _ERROR_INVALID_DISTRO:         if the distribution is invalid
	#     _ERROR_INCLUDE:                if the scripts cannot be included for unexpected error
	_include &&

	# activate the extglob
	#
	# throws:
	#     _ERROR_EXTGLOB: if extglob could not be activated
    _active_extglob &&

	# interprets the arguments and performs the proper
	# functions for each
	#
	# exports:
	#     __error_args: arguments to be displayed in the error message
	#
	# warnings:
	#     _WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO: if there is no icon available for distro
	#
	# throws:
	#     _ERROR_INVALID_ARGUMENT: if there is an invalid argument
	#     _ERROR_INSTALL_DEPENDES: if error on install dependencies
	#     _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
    _params "$@" &&

    # write in standard output the final messages
	_ok || (

        # catch errors

        local err="$?" &&
        _show_error $err "${__error_args[@]}" &&

        if [ $err = $_ERROR_INVALID_ARGUMENT ]; then
			# displays help message
            usage
        fi &&

        exit $err
    )
}

_main "$@"

