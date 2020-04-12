#!/bin/bash

md2pot_walk_dir() {
	shopt -s nullglob dotglob

	for pathname in "$1"/*; do
		if [ -d "$pathname" ]; then
			md2pot_walk_dir "$pathname"
		else
			case "$pathname" in
				*.md)
					echo "$pathname"
					po4a-gettextize -f text -M utf-8 -m "$pathname" -p "${pathname%.*}.pot"
			esac
		fi
	done
}

convert_md2pot() {
	read -e -p "Source Path: " source_dir
	md2pot_walk_dir "$source_dir"
}

case "$1" in
	md2pot)
		convert_md2pot
		;;
	*)
		echo "Usage: $0 {md2pot}"
esac
