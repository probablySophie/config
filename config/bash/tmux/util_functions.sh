
# Count the number of lines in a given set of sessions/windows/whatever
function count_num
{
	if [[ "$1" == "" ]]; then
		printf "0"
	fi
	# Word count (line) seems to always minus 1 from the actual line count (maybe it only counts newlines?)
	printf $(( $(printf "$1" | wc -l) + 1 ))
}
# $1 - the string
# $2 - the line to cut
function get_line
{
	# And cut starts from 1, so we add 1 :)
	printf "$1" | cut -d'
' -f $(($2 + 1))
}
# $1 the string
# $2 the field number to get
function get_field
{
	printf "$( printf "$1" | cut -d'|' -f $2 )"
}


# $1 = session_index
# $2 = variable name
function session_info {
	printf "$(jq -r ".[$1].$2" $__tmuxx_save_file)";
}
# $1 = session_index
# $2 = window_index
# $3 = variable name
function window_info {
	printf "$(jq -r ".[$1].windows.[$2].$3" $__tmuxx_save_file)";
}
# $1 = session_index
# $2 = window_index
# $3 = pane_index
# $4 = variable name
function pane_info {
	printf "$(jq -r ".[$1].windows.[$2].panes[$3].$4" $__tmuxx_save_file)";
}
