_secrets_decrypt() {
	_ENCRYPTION_OUTPUT_FILE=$(printf '%s' "$_SECRETS_TARGET" | sed -e 's/\.asc$//' -e 's/\.gpg$//')
	[ -e "$_ENCRYPTION_OUTPUT_FILE" ] && _error "$_ENCRYPTION_OUTPUT_FILE exists"

	_info "Writing decrypted file to: $_ENCRYPTION_OUTPUT_FILE"
	gpg --decrypt $_SECRETS_TARGET >$_ENCRYPTION_OUTPUT_FILE
}
