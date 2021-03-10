# include i18n variables

case "$_LANG" in
	pt) source "$_SRC/i18n/lang/pt/export.sh";;
	*)  source "$_SRC/i18n/lang/en/export.sh";;
esac

_show_error () {
	local err="$1" &&
	shift &&

	case "$err" in
		$_ERROR_ROOT_NOT_ALLOWED) printf "$_ERROR_MESSAGE_ROOT_NOT_ALLOWED\n" "$@" "$err";;
		$_ERROR_INCLUDE) printf "$_ERROR_MESSAGE_INCLUDE\n" "$@" "$err";;
		$_ERROR_EXTGLOB) printf "$_ERROR_MESSAGE_EXTGLOB\n" "$@" "$err";;
		$_ERROR_INVALID_ARGUMENT) printf "$_ERROR_MESSAGE_INVALID_ARGUMENT\n" "$@" "$err";;
		$_ERROR_INVALID_DISTRO) printf "$_ERROR_MESSAGE_INVALID_DISTRO\n" "$@" "$err";;
		$_ERROR_INSTALL_DEPENDES) printf "$_ERROR_MESSAGE_INSTALL_DEPENDES\n" "$@" "$err";;
		$_ERROR_INSTALL_MAKE_DEPENDES) printf "$_ERROR_MESSAGE_INSTALL_MAKE_DEPENDES\n" "$@" "$err";;
		$_ERROR_UPDATES) printf "$_ERROR_MESSAGE_UPDATES\n" "$@" "$err";;
		*) printf "$_ERROR_MESSAGE_UNEXPECTED\n" "$@" "$err";;
	esac
}

