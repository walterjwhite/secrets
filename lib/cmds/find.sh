#!/bin/sh

_FILTER_ARGS=$(echo "$@" | tr ' ' '|')
find . -type f -name value |
	$_CONF_GNU_GREP -P "($_FILTER_ARGS)" |
	sed -e "s/\.\///" |
	sed -e "s/\/value//" |
	$_CONF_GNU_GREP -P "($_FILTER_ARGS)" --color
