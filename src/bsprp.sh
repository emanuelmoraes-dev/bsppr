#!/usr/bin/env sh
# vim: noet ci pi sts=0 sw=4 ts=4
# script: bsprp (extends https://github.com/terroo/aptporn)
# describe: Linux Mint, Ubuntu Debian and Arch Linux install bspwm + polybar and more
# author1: Marcos Oliveira <https://terminalroot.com.br/shell>
# author2: Emanuel Moraes <https://github.com/emanuelmoraes-dev>
# version: 3.0
# license: GNU GPLv3
#
# usage: ${0##*/} [Options|Flags]
#   Options:
#     --install,  -i  Install bsprp
#     --unistall, -u  Uninstall bsprp
#     --version,  -v  Displays version
#     --help,     -h  Displays help message
#     --update,   -U  Update your system
#   Flags:
#     --pt            Defines the language for portuguese. Auto detected by
#                     default
#     --en            Defines the language for english. Auto detected by
#                     default
#     --use-colors    Colorize the messages, errors and warnings. Is set
#                     by default
#     --not-colors    Did not colorize messages, errors and warnings.
#                     Is not set by default
#     --use-wallpaper Set a new wallpaper. Is set by default
#     --not-wallpaper Not set a new wallpaper. Is not set by default
#     --wallpaper     The next parameter defines the path for a new
#                     wallpaper. Default value: bsprp/img/wallpaper.jpg
#     --apt-based     Uses apt-get for install packages. Auto detected by
#                     default
#     --pacman-based  Uses pacman for install packages. Auto detected by
#                     default
#     --linux-mint    Defines the name of distro for "Linux Mint". Auto
#                     detected by default
#     --ubuntu        Defines the name of distro for "Ubuntu". Auto
#                     detected by default
#     --debian        Defines the name of distro for "Debian". Auto
#                     detected by default
#     --arch-linux    Defines the name of distro for "Arch Linux". Auto
#                     detected by default
#     --generic       Defines the name of distro for "Linux". Auto detected
#                     by default
#     --distroname    The next parameter defines the name of distro that
#                     will be graphically visible (it is not identifies
#                     your distro). Default value: the same value defined
#                     by --linux-mint,--ubuntu, --debian, --arch-linux or
#                     --generic
#
# * Marcos Oliveira - <terminalroot.com.br> - APTPORN 2.0
# * Emanuel Moraes - <https://github.com/emanuelmoraes-dev> - bsprp 3.0
#
# PATTERNS:
#     GLOBAL VARIABLES:        '_'VARIABLE
#     GLOBAL FUNCTIONS:        '_'function
#     EXPORT/IMPORT VARIABLE:  '__'variable
#     LOCAL VARIABLE:          variable
#     CODE ERRORS:             '_ERROR_'VARIABLE
#     MESSAGE ERRORS:          '_ERROR_MESSAGE_'VARIABLE
#     WARNINGS:                '_WARNING_'VARIABLE
#     MESSAGES:                '_MESSAGE_'VARIABLE
#     COLORS:                  '_COLOR_'VARIABLE
#     THEMES:                  '_THEME_'VARIABLE

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
#     _WARNING_CANNOT_IDENTITY_DISTRO: if the distro could not be identified automatically
#
# throws:
#     _ERROR_INVALID_DISTRO: if the distro is invalid
#     _ERROR_INCLUDE:        if the scripts cannot be included for unexpected error
_include () {
	__error_args=() && # export

	# include colors and themes
    source "$_SRC/colors.sh" &&

	# include code errors
    source "$_SRC/errors.sh" &&

	# initialize flags variables
	#
	# exports:
	#     __error_args: arguments to be displayed in the error message
	#
	# warnings:
	#     _WARNING_CANNOT_IDENTITY_DISTRO: if The distro could not be identified automatically
	#
	# throws:
	#     _ERROR_INVALID_DISTRO:         if the distro is invalid
    source "$_SRC/flags.sh" &&

	# include i18n variables
	#
	# exports:
	#     _usage: function for displays help message
    source "$_SRC/i18n/export.sh" &&

	# exports:
	#     __error_args:           arguments to be displayed in the error message
	#     _install_dependes:      function for install dependencies
	#         throws:
	#             _ERROR_INSTALL_DEPENDES:      if error on install dependencies
	#     _install_make_dependes: function for install dependencies for build
	#         throws:
	#             _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
	#     _install_polybar:       function for install "polybar" package
	#     _updates:               function for update the system
	#         throws:
	#             _ERROR_UPDATES:               if there is an error in updating the system
	#     _uninstall:             function for uninstall packages and remove config files
	#
	# throws:
	#     _ERROR_INVALID_DISTRO:  if the distro is invalid
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

    cp -rvf "$_SRC/../config/bspwm/" ${HOME}/.config/ &&
    cp -rvf "$_SRC/../config/sxhkd/" ${HOME}/.config/ &&
    cp -rvf "$_DRC/../config/dunst/" ${HOME}/.config/ &&
    cp -rvf "$_SRC/../config/polybar/" ${HOME}/.config/ &&
    cp -rvf "$_SRC/../config/rofi/" ${HOME}/.config/ &&

	if [ "$_WALLPAPER" ]; then
    	# cp -vf "$_WALLPAPER" ${HOME}/.wallpaper.jpg &&

		# set wallpaper
    	feh --bg-scale "$_WALLPAPER" 
    fi &&

    netw=$(ip addr | awk '/state UP/ {print $2}' | sed 's/://g') &&
    sed -i -r "s/[a-z0-9]+ ;redoo/$NETW/g" ${HOME}/.config/polybar/modules.ini &&

	# get the icon and name for distro
	#
	# arguments:
	#     0: distro name
	#
	# warnings:
	#     _WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO: if there is no icon available for distro
	distro="$($_SRC/util/get_icon_distro.sh $_DISTRO_NAME)$_VISIBLE_DISTRO_NAME" &&

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
#     _ERROR_INSTALL_DEPENDES:      if error on install dependencies
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

# interprets the arguments
#
# exports:
#     __error_args: arguments to be displayed in the error message
#     __install:    1 for install bsprp
#     __uninstall:  1 for uninstall bsprp
#     __version:    1 for displays version
#     __help:       1 for displays help message
#     __update:     1 for update your system
_params () {
    __error_args=() && # export 
    __install=0     && # export
    __uninstall=0   && # export
    __version=0     && # export
    __help=0        && # export
    __update=0      && # export

	if [ ${$#} -eq 0 ]; then
    	__help=1
    fi &&

    while [ "$1" ]; do
        case "$1" in
        	# OPTIONS
            '--help'|'-u')      __help=1;;
            '--version'|'-v')   __version=1;;
            '--install'|'-i')   __install=1;;
            '--uninstall'|'-u') __uninstall=1;;
			'--update'|'-U')    __updates=1;;
			# FLAGS
			'--pt')             _LANG='pt';;
			'--en')             _LANG='en';;
			'--use-colors')     _USE_COLORS=1;;
			'--not-colors')     _USE_COLORS=0;;
			'--use-wallpaper')  _SET_WALLPAPER=1;;
			'--not-wallpaper')  _SET_WALLPAPER=0;;
			'--wallpaper')      shift && _WALLPAPER="$1";;
			'--apt-based')      _DISTRO='apt-based';;
			'--pacman-based')   _DISTRO='pacman-based';;
			'--linux-mint')     _DISTRO_NAME='Linux Mint';;
			'--ubuntu')         _DISTRO_NAME='Ubuntu';;
			'--arch-linux')     _DISTRO_NAME='Arch Linux';;
			'--generic')        _DISTRO_NAME='Linux';;
			'--distroname')     shift && _VISIBLE_DISTRO_NAME="$1";;
			# _ERROR_INVALID_ARGUMENT
            *)
            	__error_args[0]="$1" &&
            	return $_ERROR_INVALID_ARGUMENT;;
        esac &&
        shift
    done
}

# apply interpreted arguments
#
# imports:
#     __error_args: arguments to be displayed in the error message
#     __install:    1 for install bsprp
#     __uninstall:  1 for uninstall bsprp
#     __version:    1 for displays version
#     __help:       1 for displays help message
#     __update:     1 for update your system
#
# warnings:
#     _WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO: if there is no icon available for distro
#
# throws:
#     _ERROR_INVALID_ARGUMENT:      if there is an invalid argument
#     _ERROR_INSTALL_DEPENDES:      if error on install dependencies
#     _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
_apply_params () {
	if [ "$_USE_COLORS" = "0" ]; then
		_THEME_ERROR=''   &&
		_THEME_WARNING='' &&
		_THEME_MESSAGE='' &&

		_THEME_ERROR_END=''   &&
		_THEME_WARNING_END='' &&
		_THEME_MESSAGE_END=''
	fi &&
	
	if [ "$_SET_WALLPAPER" = "0" ]; then
		_WALLPAPER=''
	fi &&

	if [ $__help -eq 1 ]; then
		# displays help message
        usage &&
        exit 0
    fi &&

    if [ $__version -eq 1 ]; then
        printf '%s\n' "$_VERSION" &&
        exit 0
	fi &&

	if [ $__update -eq 1 ]; then
		# update the system
		#
		# throws:
		#     _ERROR_UPDATES: if there is an error in updating the system
		_updates &&
		exit 0
	fi &&

	if [ $__install -eq 1 ]; then
		# install and config all packages
		#
		# warnings:
		#     _WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO: if there is no icon available for distro
		#
		# throws:
		#     _ERROR_INSTALL_DEPENDES:      if error on install dependencies
		#     _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
        _install &&
        exit 0
	fi &&
	
	if [ $__uninstall -eq 1 ]; then
		# uninstall packages and remove config files
		_uninstall &&
		exit 0
	fi
}

# first function to be executed. through this function,
# other functions will be called and errors will be
# handled
_main () {
    local __error_args=() && # arguments to be displayed in the error message
    local __install=0     && # 1 for install bsprp
    local __uninstall=0   && # 1 for uninstall bsprp
    local __version=0     && # 1 for displays version
    local __help=0        && # 1 for displays help message
    local __update=0      && # 1 for update your system

	# checks if the user is not root
	#
	# throws:
	#     _ERROR_ROOT_NOT_ALLOWED: if the user is root
    _root_verify &&

	# activate the extglob
	#
	# throws:
	#     _ERROR_EXTGLOB: if extglob could not be activated
    _active_extglob &&

	# interprets the arguments
	#
	# exports:
	#     __error_args: arguments to be displayed in the error message
	#     __install:    1 for install bsprp
	#     __uninstall:  1 for uninstall bsprp
	#     __version:    1 for displays version
	#     __help:       1 for displays help message
	#     __update:     1 for update your system
    _params "$@" &&

	# include global variables from scripts
	#
	# exports:
	#     __error_args: arguments to be displayed in the error message
	#
	# warnings:
	#     _WARNING_CANNOT_IDENTITY_DISTRO: if the distro could not be identified automatically
	#
	# throws:
	#     _ERROR_INVALID_DISTRO: if the distro is invalid
	#     _ERROR_INCLUDE:        if the scripts cannot be included for unexpected error
	_include &&

	# apply interpreted arguments
	#
	# imports:
	#     __error_args: arguments to be displayed in the error message
	#     __install:    1 for install bsprp
	#     __uninstall:  1 for uninstall bsprp
	#     __version:    1 for displays version
	#     __help:       1 for displays help message
	#     __update:     1 for update your system
	#
	# warnings:
	#     _WARNING_ICON_NOT_AVAILABLE_FOR_DISTRO: if there is no icon available for distro
	#
	# throws:
	#     _ERROR_INVALID_ARGUMENT:      if there is an invalid argument
	#     _ERROR_INSTALL_DEPENDES:      if error on install dependencies
	#     _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
	_apply_params &&

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

