_DEPENDES=(
	bspwm
	rofi
)

_MAKE_DEPENDES=(
	git
	subversion
	sxhkd
	feh
	numlockx
	compton
	dunst
	neofetch
	imagemagick
	webp
	unifont
	build-essential
	cmake
	cmake-data
	pkg-config
	libcairo2-dev
	libxcb1-dev
	libxcb-util0-dev
	libxcb-randr0-dev
	libxcb-composite0-dev
	python3-xcbgen
	xcb-proto
	libxcb-image0-dev
	libxcb-ewmh-dev
	libxcb-icccm4-dev
	libxcb-cursor-dev
	libxcb-xrm-dev
	libxcb-xkb-dev
	libcurl4-openssl-dev
	libjsoncpp-dev
	libpulse-dev
	libmpdclient-dev
	libasound2-dev
	libnl-genl-3-dev
)

# function for install dependencies
#
# throws:
#     _ERROR_INSTALL_DEPENDES: if error on install dependencies
_install_dependes () {
	sudo apt-get install -y "${_DEPENDES[@]}" ||
	return $_ERROR_INSTALL_DEPENDES
}

# function for install dependencies for build
#
# throws:
#     _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
_install_make_dependes () {
	sudo apt-get install -y "${_MAKE_DEPENDES[@]}" ||
	return $_ERROR_INSTALL_MAKE_DEPENDES
}

# install "polybar" package
_install_polybar () {
	sudo apt-get -y install polybar
}

# update the system
#
# throws:
#     _ERROR_UPDATES: if there is an error in updating the system
_updates () {
    sudo apt-get update &&
    sudo apt-get full-upgrade -y ||
	return $_ERROR_UPDATES
    # sudo apt-get clean &&
    # sudo apt-get autoclean
}

# uninstall packages and remove config files
_uninstall () {
    sudo apt-get remove bspwm rofi
    sudo apt-get autoremove
    sudo rm $(which polybar)
    # rm -rf ${HOME}/.fehbg ${HOME}/.wallpaper.jpg
    rm -rf ${HOME}/.local/share/fonts/fonts
    rm -rf ${HOME}/.config/{bspwm,sxhkd,polybar,rofi,dunst}
}

