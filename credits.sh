#!/bin/sh

# Use this from another project, e.g. `./config/config/credits.sh`.

show_images_as_markdown_link(){
	for type in jpg svg; do
		find images/$1 -type f -name "*.$type" | while read -r image; do
			stated_name="$(basename -s .$type "$image" | tr '_' ' ')"
			echo "![$stated_name]($image)"
			echo '\\newpage\n'
		done
	done
}

make_markdown_output(){
	ls images | while read -r line; do
		if [ -d "images/$line" ]; then
			formatted_name="$(echo $line | tr '_' ' ')"
			title="# $formatted_name"
			echo "\n\n$title"
			show_images_as_markdown_link "$line"
		fi
	done
}

make_pdf_showcase(){
	make_markdown_output | pandoc --pdf-engine=pdflatex -o artist_credits.pdf
}

####################

make_pdf_showcase
