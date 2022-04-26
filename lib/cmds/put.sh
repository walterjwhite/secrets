#!/bin/sh

_cleanup() {
	rm -f $_TEMP_SECRET
}

# put secret
for _ARG in "$@"; do
	case $_ARG in
	-k=* | -key=*)
		_KEY="${_ARG#*=}"
		;;
	-m=* | -message=*)
		_MESSAGE="${_ARG#*=}"
		;;
	*) ;;

	esac
done

_require "$_KEY" "_KEY" 1
_require "$_MESSAGE" "_MESSAGE" 1

_TEMP_SECRET=$(mktemp)

$EDITOR $_TEMP_SECRET

# encrypt, base64 encode, && encrypt
mkdir -p $_KEY
openssl rsautl -encrypt -in $_TEMP_SECRET -out $_KEY/value -inkey _APPLICATION_DATA_PATH_/keys/public -pubin

# add to git, push
git add $_KEY
gc $_KEY -m "$_MESSAGE"
gpush
