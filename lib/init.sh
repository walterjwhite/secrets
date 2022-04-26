#!/bin/sh

# initialize secret key
if [ ! -e _APPLICATION_DATA_PATH_/keys/private ]; then
	mkdir -p _APPLICATION_DATA_PATH_/keys

	_warn "Generating private key: _APPLICATION_DATA_PATH_/keys/private"
	openssl genrsa -out _APPLICATION_DATA_PATH_/keys/private 2048

	# extract public key
	openssl rsa -pubout -in _APPLICATION_DATA_PATH_/keys/private -out _APPLICATION_DATA_PATH_/keys/public
fi

# initialize git repository
if [ ! -e _APPLICATION_DATA_PATH_/store ]; then
	git clone $_SECRETS_REPOSITORY _APPLICATION_DATA_PATH_/store
fi

cd _APPLICATION_DATA_PATH_/store
