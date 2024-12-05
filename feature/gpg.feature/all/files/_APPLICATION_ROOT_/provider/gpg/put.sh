import feature/gpg.feature/gpg.sh

[ "$_CONF_SECRETS_OVERWRITE_EXISTING" ] && [ -e $_SECRET_KEY.gpg ] && rm -f $_SECRET_KEY.gpg
mkdir -p $(dirname $_SECRET_KEY)

_PLAINTEXT=$(_mktemp)
printf '%s\n' "$_SECRET_VALUE" >>$_PLAINTEXT

gpg --output $_SECRET_KEY.gpg --encrypt --recipient $_FEATURE_GPG_USER_EMAIL $_PLAINTEXT
rm -f $_PLAINTEXT
unset _PLAINTEXT

git add $_SECRET_KEY.gpg
git commit $_SECRET_KEY.gpg -m "$_SECRET_KEY"
git push
