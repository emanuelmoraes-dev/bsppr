# displays help message
_usage () {
	cat <<EOF
 usage: ${0##*/} [Options|Flags]
   Options:
     --install,  -i  Install bsprp
     --remove,   -r  Remove bsprp
     --version,  -v  Displays version
     --help,     -h  Displays help message
     --update,   -U  Update your system
   Flags:
     --pt            Defines the language for portuguese. Auto detected by
                     default
     --en            Defines the language for english. Auto detected by
                     default
     --use-colors    Colorize the messages, errors and warnings. Is set
                     by default
     --not-colors    Did not colorize messages, errors and warnings.
                     Is not set by default
     --use-wallpaper Set a new wallpaper. Is set by default
     --not-wallpaper Not set a new wallpaper. Is not set by default
     --wallpaper     The next parameter defines the path for a new
                     wallpaper. Default value: bsprp/img/wallpaper.jpg
     --apt-based     Uses apt-get for install packages. Auto detected by
                     default
     --pacman-based  Uses pacman for install packages. Auto detected by
                     default
     --linux-mint    Defines the name of distro for "Linux Mint". Auto
                     detected by default
     --ubuntu        Defines the name of distro for "Ubuntu". Auto
                     detected by default
     --debian        Defines the name of distro for "Debian". Auto
                     detected by default
     --arch-linux    Defines the name of distro for "Arch Linux". Auto
                     detected by default
     --generic       Defines the name of distro for "Linux". Auto detected
                     by default
     --distroname    The next parameter defines the name of distro that
                     will be graphically visible (it is not identifies
                     your distro). Default value: the same value defined
                     by --linux-mint,--ubuntu, --debian, --arch-linux or
                     --generic

 * Marcos Oliveira - <terminalroot.com.br> - APTPORN 2.0
 * Emanuel Moraes - <https://github.com/emanuelmoraes-dev> - BSPRP 3.0
EOF
}

