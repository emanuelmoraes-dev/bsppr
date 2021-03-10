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
	sudo pacman -S --noconfirm "${_DEPENDES[@]}" ||
	return $_ERROR_INSTALL_DEPENDES
}

# function for install dependencies for build
#
# throws:
#     _ERROR_INSTALL_MAKE_DEPENDES: if error on install dependencies for build
_install_make_dependes () {
	if [ "$(pacman -Qu)" ]; then
		sudo pacman -S --noconfirm "${_MAKE_DEPENDES[@]}"
	else
		sudo pacman -S --noconfirm --asdeps --needed "${_MAKE_DEPENDES[@]}"
	fi ||
	return $_ERROR_INSTALL_MAKE_DEPENDES
}

# install "polybar" package
_install_polybar () {
	sudo pacman -S --noconfirm polybar
}

# update the system
#
# throws:
#     _ERROR_UPDATES: if there is an error in updating the system
_updates () {
    sudo pacman -Syu --noconfirm ||
	return $_ERROR_UPDATES
}

# uninstall packages and remove config files
_uninstall () {
    sudo pacman -Rsu bspwm rofi
    sudo pacman -Rsu $(pacman -Qqtd)
    sudo rm $(which polybar)
    # rm -rf ${HOME}/.fehbg ${HOME}/.wallpaper.jpg
    rm -rf ${HOME}/.local/share/fonts/fonts
    rm -rf ${HOME}/.config/{bspwm,sxhkd,polybar,rofi,dunst}
}

