#
# A fancy file previewer :)
# Mostly for use with fzf honestly
#

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
	if command -v bat &> /dev/null; then
		bat --color=always "$1";
		return;
	fi
	cat "$1";
}

function preview_file
{
	if [[ "$1" == "" ]]; then return -1; fi
	# If we can check the mime-type then do it
	if command -v file &> /dev/null; then
		local MIME_TYPE="$(file --mime-type -b $1)";

		if [[ "$MIME_TYPE" =~ ^image/ ]] && preview_image "$1" $2 $3; then return; fi		
	fi
	# Default Option
	preview_text_file "$1";
}
preview_file "$1" $2 $3;
