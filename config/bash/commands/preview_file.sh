#
# A fancy file previewer :)
# Mostly for use with fzf honestly
#

# This would appreciate if you had these commands available/installed:
# 	bat
# 	chafa
# 	exiftool
# 	pdftoppm
# 	w3m

# ARGS: $1 is the file to preview
# 		$2 (optional) is the number of lines we have to work with (height)
#       $3 (optional) is the number of rows we have to work with (width)

function preview_image
{
	# -s, --size=WxH     Set maximum image dimensions in columns and rows.
	# If no chafa, return 1 (false/bad/failure)
	if ! command -v chafa &> /dev/null; then return 1; fi

	if [[ "$2" != "" ]] && [[ "$3" != "" ]]; then
		chafa -f symbols --view-size="$3""x""$2" "$1";
	else
		chafa -f symbols "$1";
	fi
	return 0;
}
function preview_text_file
{
	if ! command -v bat &> /dev/null; then cat "$1"; return; fi;
	bat --color=always "$1";
}
function preview_pdf
{
	# We're going to render the PDF as an image & then display it
	if ! command -v pdftoppm &> /dev/null; then return 1; fi
	if ! command -v chafa &> /dev/null; then return 1; fi

	mkdir -p "$HOME/.cache/fzf";

	pdftoppm -jpeg -f 1 -singlefile "$1" "$HOME/.cache/fzf/image.jpeg"
	if [[ "$2" != "" ]] && [[ "$3" != "" ]]; then
		chafa -f symbols --view-size="$3""x""$2" "$HOME/.cache/fzf/image.jpeg.jpg";
	else
		chafa -f symbols "$HOME/.cache/fzf/image.jpeg.jpg";
	fi

	
	return 0
}

function preview_exif
{
	if ! command -v exiftool &> /dev/null; then return 1; fi
	exiftool "$1";
	return 0
}
function preview_html
{
	if ! command -v w3m -version &> /dev/null; then return 1; fi
	w3m -T text/html -dump "$1" | bat --color=always --terminal-width "$3" --wrap auto --file-name "$1";
	return 0
}

function preview_file
{
	if [[ "$1" == "" ]]; then return -1; fi

	# If we can't check the mime-type then just text please
	if ! command -v file &> /dev/null; then preview_text_file "$1"; fi
	
	local file_name=$(echo "$1");
	local MIME_TYPE="$(file --mime-type -b "$file_name")";

	if [[ "$MIME_TYPE" =~ ^image/ ]] && preview_image "$file_name" $2 $3; then return; fi		
	if [[ "$MIME_TYPE" == "application/pdf" ]] && preview_pdf "$file_name" $2 $3; then return; fi

	if [[ "$MIME_TYPE" == "text/html" ]] && preview_html "$file_name" $2 $3; then return; fi

	# Exif friends?
	if [[ "$MIME_TYPE" == "application/epub+zip" ]] \
	|| [[ "$MIME_TYPE" =~ ^audio/ ]]
	then
		if preview_exif "$file_name" $2 $3; then return; fi
	fi

	# Default Option
	preview_text_file "$1";
}
preview_file "$1" $2 $3;
