if [ -z "$_LANG" ]; then

	_LANG="$(echo "$LANG" | cut -c 1-2)" # _LANG

fi || exit 1

