#!/bin/sh

_cleanup() {
	rm -f $_TEMP_SECRET
}

_FIND_ARGS=""
for _ARG in "$@"; do
	case $_ARG in
	-o)
		_OUT="stdout"
		;;
	*)
		_FIND_ARGS="$_FIND_ARGS $_ARG"
		;;
	esac
done

_KEY=$(secrets -find $_FIND_ARGS)

_require "$_KEY" "_KEY" 1
_TEMP_SECRET=$(mktemp)

openssl rsautl -decrypt -in $_KEY/value -out $_TEMP_SECRET -inkey _APPLICATION_DATA_PATH_/keys/private

if [ -z "$_OUT" ]; then
	cat $_TEMP_SECRET | xsel -ib
else
	cat $_TEMP_SECRET
fi
