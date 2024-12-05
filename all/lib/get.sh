import git:transfer/qr.sh

_secrets_get() {
	. $_CONF_INSTALL_APPLICATION_LIBRARY_PATH/provider/$_CONF_SECRETS_PROVIDER/get.sh

	if [ $# -gt 0 ]; then
		case $1 in
		-out=*)
			_SECRETS_OUTPUT_FUNCTION=${1#*=}
			shift
			;;
		esac
	fi

	_secrets_get_get_key "$@"
	_secrets_get_output_function

	if [ "$_SECRETS_OUTPUT_FUNCTION" != "wifi" ]; then
		_secrets_get_$_SECRETS_OUTPUT_FUNCTION "$@"
	else
		_secrets_get_wifi "$@"
	fi
}

_secrets_get_get_key() {
	[ $# -eq 0 ] && _error "key name or search pattern is required"

	if [ $# -eq 1 ]; then
		_SECRET_KEY=$1
	else
		_secrets_get_find "$@"
	fi
}

_secrets_get_output_function() {
	case $_SECRETS_OUTPUT_FUNCTION in
	clipboard | qrcode | wifi) ;;
	stdout)
		_secrets_get_stdout_formatter
		;;
	*)
		_error "Invalid output function: $_SECRETS_OUTPUT_FUNCTION"
		;;
	esac
}

_secrets_get_stdout_formatter() {
	_SECRETS_OUTPUT_FUNCTION=stdout

	[ -n "$_FORCE_INTERACTIVE" ] && return 1

	local type=$(printf '%s' "$_SECRET_KEY" | sed -e 's/^.*\///')

	case $type in
	pin)
		_STDOUT_FORMAT=pin
		;;
	card-number | account-number)
		_STDOUT_FORMAT=account
		;;
	phone-number | phone)
		_STDOUT_FORMAT=phone
		;;
	esac

	if [ -n "$_STDOUT_FORMAT" ]; then
		_SECRETS_OUTPUT_FUNCTION=stdout_format
	fi
}

_secrets_get_stdout_pin() {
	sed -r -e 's/^.{3}/& /'
}

_secrets_get_stdout_phone() {
	sed -r -e 's/^.{3}/& /' -e 's/^.{7}/& /'
}

_secrets_get_stdout_account() {
	sed -r -e 's/^.{4}/& /' -e 's/^.{9}/& /' -e 's/^.{14}/& /' -e 's/^.{19}/& /'
}

_secrets_get_stdout_format() {
	_secrets_get_stdout | _secrets_get_stdout_$_STDOUT_FORMAT
}

_secrets_get_qrcode() {
	[ -z "$secret_value" ] && secret_value=$(_secrets_get_stdout)
	_qr_write
}

_secrets_get_wifi() {
	local ssid=$(_SECRET_KEY=$_SECRET_KEY/ssid _secrets_get_stdout 2>/dev/null)
	local encryption_type=$(_SECRET_KEY=$_SECRET_KEY/encryption-type _secrets_get_stdout 2>/dev/null)
	local key=$(_SECRET_KEY=$_SECRET_KEY/key _secrets_get_stdout 2>/dev/null)

	_require "$ssid" ssid
	_require "$encryption_type" encryption_type
	_require "$key" key

	local is_hidden=$(_SECRET_KEY=$_SECRET_KEY/is-hidden _secrets_get_stdout 2>/dev/null)
	secret_value="WIFI:S:$ssid;T:$encryption_type;P:$key;H:$is_hidden;;" _secrets_get_qrcode
}
