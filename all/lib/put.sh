_secrets_put() {
	_read_ifs "Enter secret value" _SECRET_VALUE && _read_ifs "Enter secret value AGAIN" _SECRET_VALUE2
	if [ "$_SECRET_VALUE" != "$_SECRET_VALUE2" ]; then
		_error "Passwords do not match"
	fi

	. $_CONF_INSTALL_APPLICATION_LIBRARY_PATH/provider/$_CONF_SECRETS_PROVIDER/put.sh
}
