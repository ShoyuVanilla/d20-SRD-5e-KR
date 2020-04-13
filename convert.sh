#!/bin/bash

md2pot_walk_dir() {
	shopt -s nullglob dotglob

	local merged_file=$2/$(basename $1).merged.md
	touch "$merged_file"

	for pathname in "$1"/*; do
		if [[ -d "$pathname" ]]; then
			md2pot_walk_dir "$pathname" "$2"
		else
			case "$pathname" in
				*.md)
					echo "Append $pathname to $merged_file..."
					echo "" >> "$merged_file"
					echo "<!-- $pathname -->" >> "$merged_file"
					echo "" >> "$merged_file"
					cat "$pathname" >> "$merged_file"
					echo "" >> "$merged_file"
			esac
		fi
	done

	po4a-gettextize -f text -M utf-8 -m "$merged_file" -p "${merged_file%.*}.pot"
	cp "${merged_file%.*}.pot" "${merged_file%.*}.ko.po"
}

convert_md2pot() {
	read -e -p "Source Path: " source_dir
	read -e -p "Destination Path: " dest_dir
	find "$dest_dir" -name "*.merged.md" -type f -delete
	md2pot_walk_dir "${source_dir%/}" "${dest_dir%/}"
}

case "$1" in
	md2pot)
		convert_md2pot
		;;
	*)
		echo "Usage: $0 {md2pot}"
esac
