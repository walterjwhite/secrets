_put_clipboard() {
	printf "$1" | xsel -bi
}
