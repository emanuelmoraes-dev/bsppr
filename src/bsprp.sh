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

# include the scripts
#
# exports:
#     __error_args: arguments to be displayed in the error message
#
# throws:
#     _ERROR_SOURCE_NOT_ALLOWED: if the scripts cannot be includeed
_include () {
	__error_args=() && # export

    source "$_SRC/colors.sh" &&
    source "$_SRC/errors.sh" &&
    source "$_SRC/global.sh" &&
    source "$_SRC/i18n/export.sh" ||
    return $_ERROR_SOURCE_NOT_ALLOWED

	# exports:
	#     __error_args: arguments to be displayed in the error message
	#
	# throws:
	#     _ERROR_INVALID_DISTRO:         if the distribution is invalid
	#     _ERROR_CANNOT_IDENTITY_DISTRO: if The distribution could not be identified automatically
    source "$_SRC/distros/export.sh"
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

_start(){
    cat <<EOF
 █████╗ ██████╗ ████████╗██████╗  ██████╗ ██████╗ ███╗   ██╗
██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔═══██╗██╔══██╗████╗  ██║
███████║██████╔╝   ██║   ██████╔╝██║   ██║██████╔╝██╔██╗ ██║
██╔══██║██╔═══╝    ██║   ██╔═══╝ ██║   ██║██╔══██╗██║╚██╗██║
██║  ██║██║        ██║   ██║     ╚██████╔╝██║  ██║██║ ╚████║
╚═╝  ╚═╝╚═╝        ╚═╝   ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝                      


EOF
}

_git_svn_packs () {
	if [[ ! -d "${HOME}/.local/share/fonts" ]]; then
		mkdir -p "${HOME}/.local/share/fonts"
	fi &&
    svn export https://github.com/terroo/fonts/trunk/fonts ${HOME}/.local/share/fonts/fonts &&
    fc-cache -fv
}

_build_polybar () {
	if [ -d "$_SRC/../tmp/polybar" ]; then
		rm -rf "$_SRC/../tmp/polybar"
	fi &&
    git clone --recursive https://github.com/polybar/polybar "$_SRC/../tmp/polybar" &&
    sed -i 's/read /#read /g' "$_SRC/../tmp/polybar/build.sh" &&
    sudo ./build.sh
}

_cfg_all () {
	local netw &&
	local distro &&
    mv "$_SRC/../config/bspwm/" ${HOME}/.config/ &&
    mv "$_SRC/../config/sxhkd/" ${HOME}/.config/ &&
    mv "$_DRC/../config/dunst/" ${HOME}/.config/ &&
    mv "$_SRC/../config/polybar/" ${HOME}/.config/ &&
    mv "$_SRC/../config/rofi/" ${HOME}/.config/ &&
    mv "$_SRC/../img/wallpaper.jpg" ${HOME}/.wallpaper.jpg &&
    feh --bg-scale ${HOME}/.wallpaper.jpg &&
    netw=$(ip addr | awk '/state UP/ {print $2}' | sed 's/://g') &&
    sed -i -r "s/[a-z0-9]+ ;redoo/$NETW/g" ${HOME}/.config/polybar/modules.ini &&
	distro="$($_SRC/util/get_distro_name.sh)" &&
	distro="$($_SRC/util/get_icon_distro.sh)${distro}" &&
    sed -i "s/DISTROOO/$distro/" ${HOME}/.config/polybar/user_modules.ini
    #sed -i "/$_d/s/^#//" ${HOME}/.config/polybar/scripts/menu
}

_ok(){
#    clear
    printf "$_MESSAGE_INSTALLATION_FINISHED"
    # _start
}

_install () {
	# _start &&
	_install_dependes &&
	_install_make_dependes &&
	_git_svn_packs &&
	(_install_polybar || _build_polybar) &&
	_cfg_all
}

# interprets the arguments and performs the proper
# functions for each
#
# exports:
#     __error_args: arguments to be displayed in the error message
#
# throws:
#     _ERROR_INVALID_ARGUMENT: if there is an invalid argument
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
            	_install &&
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

	# include the scripts
	#
	# exports:
	#     __error_args: arguments to be displayed in the error message
	#
	# throws:
	#     _ERROR_SOURCE_NOT_ALLOWED: if the scripts cannot be includeed
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
	# throws:
	#     _ERROR_INVALID_ARGUMENT: if there is an invalid argument
    _params "$@" || (        # interprets the arguments and performs the proper functions for each

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

_updates(){
    sudo apt update
    sudo apt full-upgrade -y
    sudo apt clean
    sudo apt autoremove -y
    sudo apt autoclean
    exit 0
}

_uninstall(){
    sudo apt remove -y bspwm rofi
    sudo rm $(which polybar)
    rm -rf ${HOME}/.fehbg ${HOME}/.wallpaper.jpg
    rm -rf ${HOME}/.local/share/fonts/fonts
    rm -rf ${HOME}/.config/{bspwm,sxhkd,polybar,rofi,dunst}
    exit 0
}

while [[ "$1" ]]; do
    case "$1" in
        "--install"|"-i") _install ;;
        "--uninstall"|"-u") _uninstall ;;
        "--help"|"-h") usage ;;
        "--version"|"-v") printf "%s\n" "$version" && exit 0 ;;
        "--update"|"-U") _updates && exit 0 ;;
        *) echo 'Invalid option.' && usage && exit 1 ;;
    esac
    shift
done
