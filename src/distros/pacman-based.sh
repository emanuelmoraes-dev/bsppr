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
	extra/libwebp
	extra/bdf-unifont
	base-devel
	cmake
	# cmake-data
	pkg-config
	extra/cairo
	extra/libxcb
	extra/xcb-util
	extra/xcb-util-cursor
	community/xcb-util-xrm
	extra/libxkbcommon-x11
	# libxcb-randr0-dev
	# libxcb-composite0-dev
	community/python-xcffib
	xcb-proto
	extra/xcb-util-image
	xcb-util-wm
	# libxcb-icccm4-dev
	core/curl
	extra/jsoncpp
	extra/libpulse
	extra/libmpd
	extra/libmpdclient
	extra/alsa-lib
	core/libnl
	community/libnl1
	python
	python-sphinx
	xorg-fonts-misc
	extra/fontconfig
	extra/xorg-mkfontscale
	extra/xorg-xset
	extra/xorg-xfd
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
		sudo pacman -S --noconfirm --needed "${_MAKE_DEPENDES[@]}"
	else
		sudo pacman -S --noconfirm --needed --asdeps "${_MAKE_DEPENDES[@]}"
	fi ||
	return $_ERROR_INSTALL_MAKE_DEPENDES
}

# install AUR packages
#
# params:
#     1: url for git AUR package
#     2: path for temporary folder for build package
_aur_install () {
	local url="$1" &&
	local tmp="$2" &&
	local npath="$(pwd)" &&
	local err &&

	if [ -d "$tmp" ]; then
		sudo rm -rf "$tmp"
	fi &&

	git clone "$url" "$tmp" &&
	cd "$tmp" && # in

	makepkg -srciC --noconfirm &&

	cd "$npath" || ( # out
		err=$?
		cd "$npath" # out
		return $err
	)
}

# install "polybar" package
_install_polybar () {
	gpg --keyserver hkp://keys.gnupg.net --recv-keys 1A09227B1F435A33 &&
	_aur_install "https://aur.archlinux.org/ttf-unifont.git" "$_SRC/../tmp/ttf-unifont-aur" &&
	_aur_install "https://aur.archlinux.org/siji-git.git" "$_SRC/../tmp/siji-git-aur" &&
	_aur_install "https://aur.archlinux.org/polybar.git" "$_SRC/../tmp/polybar-aur"
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
    sudo pacman -Rsu siji-git # aur
    sudo pacman -Rsu ttf-unifont # aur
    sudo pacman -Rsu polybar # aur
    sudo pacman -Rsu $(pacman -Qqtd)
    sudo rm $(which polybar)
    # rm -rf ${HOME}/.fehbg ${HOME}/.wallpaper.jpg
    rm -rf "${HOME}/.local/share/fonts/fonts"
    rm -rf "${HOME}/.config/{bspwm,sxhkd,polybar,rofi,dunst}"
}

