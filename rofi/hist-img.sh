#!/bin/sh
# Outputs only unique lines and shows preview for the highlighted non-binary item

case "$1" in
	preview)
		# show preview if non-binary data
		echo "$2" | grep -q '[\[ binary data .* \]\]' || echo "$2" | cliphist decode
		;;
	*)
		exec cliphist list |
			sort -k 2 -u | # sort by 2 field to the end of line and output only unique lines
			sort -nr |     # sort numerically in reverse
			fzf --preview "$(realpath "$0") preview {}" |
			cliphist decode |
			wl-copy
		;;
esac