import feature/pass.feature/pass.sh

_SECRET_KEY=$(find ~/.password-store -type f ! -path '*/.git/*' -name '*.gpg' | sed -e "s/$_SECRETS_PASS_PATH_SED_SAFE\///" -e 's/\.gpg$//' | sort -u | head -1)
pass show $_SECRET_KEY >/dev/null 2>&1
