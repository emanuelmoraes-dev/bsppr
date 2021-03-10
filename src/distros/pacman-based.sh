_DEPENDES=(
	bspwm
	sxhkd
	subversion
	rofi
	feh
	numlockx
	compton
	dunst
	neofetch
	imagemagick
	webp
	unifont
	gnome-terminal
	git
)

_MAKE_DEPENDES=(
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
	libcurl4-openssl-dev
	libjsoncpp-dev
	libpulse-dev
	libmpdclient-dev
	libasound2-dev
	libxcb-cursor-dev
	libxcb-xrm-dev
	libxcb-xkb-dev
	libnl-genl-3-dev
)

# function for install dependencies
#
# throws:
#     _ERROR_INSTALL_DEPENDES: if error on install dependencies
_install_dependes () {
	sudo pacman -S "${_DEPENDES[@]}" ||
	return $_ERROR_INSTALL_DEPENDES
}

# function for install dependencies for build
#
# throws:
#     _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
_install_make_dependes () {
	sudo pacman -S "${_MAKE_DEPENDES[@]}" ||
	return $_ERROR_INSTALL_MAKE_DEPENDES
}

# install "polybar" package
_install_polybar () {
	sudo pacman -S polybar
}

# update the system
#
# throws:
#     _ERROR_UPDATES: if there is an error in updating the system
_updates () {
    sudo pacman -Syu ||
	return $_ERROR_UPDATES
}

# uninstall packages and remove config files
_uninstall () {
    sudo pacman -Rsu bspwm rofi
    sudo rm $(which polybar)
    # rm -rf ${HOME}/.fehbg ${HOME}/.wallpaper.jpg
    rm -rf ${HOME}/.local/share/fonts/fonts
    rm -rf ${HOME}/.config/{bspwm,sxhkd,polybar,rofi,dunst}
}

