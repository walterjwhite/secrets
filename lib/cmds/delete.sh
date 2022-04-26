#!/bin/sh

if [ $# -eq 0 ]; then
	_exitWithError "Search criteria is required" 1
fi

for _KEY in $(secrets -find $@); do
	_warn "Deleting $_KEY"

	# add to git, push
	git rm -rf $_KEY

	_KEYS="$_KEYS $_KEY"
done

gc $_KEYS -m "delete - $@"
gpush
