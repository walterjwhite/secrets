import feature/pass.feature/pass.sh

for _SEARCH_ARG in "$@"; do
	case $_SEARCH_ARG in
	*/*)
		_error "Search arguments cannot contain '/': $_SEARCH_ARG"
		;;
	esac

	if [ -z "$_AWK_PATTERN" ]; then
		_AWK_PATTERN="/$_SEARCH_ARG/"
	else
		_AWK_PATTERN="$_AWK_PATTERN && /$_SEARCH_ARG/"
	fi
done

if [ -z "$_AWK_PATTERN" ]; then
	_AWK_PATTERN="//"
fi

find ~/.password-store -type f ! -path '*/.git/*' -name '*.gpg' | sed -e "s/$_SECRETS_PASS_PATH_SED_SAFE\///" -e 's/\.gpg$//' |
	awk "$_AWK_PATTERN" | sort -u
