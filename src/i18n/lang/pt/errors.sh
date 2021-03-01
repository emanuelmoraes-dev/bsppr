_ERROR_MESSAGE_UNEXPECTED="${_THEME_ERROR}\
${0##*/}: UNEXPECTED: Erro inesperado! [Código: %s]\
${_COLOR_END}"

_ERROR_MESSAGE_ROOT_NOT_ALLOWED="${_THEME_ERROR}\
${0##*/}: ROOT_NOT_ALLOWED: Não use 'sudo' e nem 'root'! [Código: %s]
${_COLOR_END}"

_ERROR_MESSAGE_SOURCE_NOT_ALLOWED="${_THEME_ERROR}\
${0##*/}: SOURCE_NOT_ALLOWED: Importação do script com 'source' não permitida! [Código: %s]
"

_ERROR_MESSAGE_EXTGLOB="${_THEME_ERROR}\
${0##*/}: EXTGLOB: Não foi spossível ativar o 'extglob'! [Código: %s]
${_COLOR_END}"

_ERROR_MESSAGE_INVALID_ARGUMENT="${_THEME_ERROR}\
${0##*/}: INVALID_ARGUMENT: O argumento '%s' é inválido! [Código: %s]
${_COLOR_END}"

_ERROR_MESSAGE_INVALID_DISTRO="${_THEME_ERROR}\
${0##*/}: INVALID_DISTRO: '%s' não é uma distribuição válida! [Código: %s]
${_COLOR_END}"

_ERROR_MESAGE_CANNOT_IDENTITY_DISTRO="${_THEME_ERROR}\
${0##*/}: CANNOT_IDENTITY_DISTRO: Não foi possível identificar a sua distribuição de forma automática! [Código: %s]
${_COLOR_END}"

_ERROR_MESSAGE_INSTALL_DEPENDES="${_THEME_ERROR}\
${0##*/}: INSTALL_DEPENDES: Não foi possível instalar as dependências! [Código: %s]
${_COLOR_END}"

_ERROR_MESSAGE_INSTALL_MAKE_DEPENDES="${_THEME_ERROR}\
${0##*/}: INSTALL_MAKE_DEPENDES: Não foi possível instalar as dependências de construção! [Código: %s]
${_COLOR_END}"

_show_error () {
	local err="$1" &&
	shift &&

	case "$err" in
		$_ERROR_ROOT_NOT_ALLOWED) printf "$_ERROR_MESSAGE_ROOT_NOT_ALLOWED" "$@" "$err";;
		$_ERROR_SOURCE_NOT_ALLOWED) printf "$_ERROR_MESSAGE_SOURCE_NOT_ALLOWED" "$@" "$err";;
		$_ERROR_EXTGLOB) printf "$_ERROR_MESSAGE_EXTGLOB" "$@" "$err";;
		$_ERROR_INVALID_ARGUMENT) printf "$_ERROR_MESSAGE_INVALID_ARGUMENT" "$@" "$err";;
		$_ERROR_INVALID_DISTRO) printf "$_ERROR_MESSAGE_INVALID_DISTRO" "$@" "$err";;
		$_ERROR_CANNOT_IDENTITY_DISTRO) printf "$_ERROR_MESSAGE_CANNOT_IDENTITY_DISTRO" "$@" "$err";;
		$_ERROR_INSTALL_DEPENDES) printf "$_ERROR_MESSAGE_INSTALL_DEPENDES" "$@" "$err";;
		$_ERROR_INSTALL_MAKE_DEPENDES) printf "$_ERROR_MESSAGE_INSTALL_MAKE_DEPENDES" "$@" "$err";;
		*) printf "$_ERROR_MESSAGE_UNEXPECTED" "$@" "$err";;
	esac
}

