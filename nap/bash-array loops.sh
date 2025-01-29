arr=(1 2 3)
for ((i=0; i<${#arr[@]}; i++)); do
	printf "${arr[$i]}\n"
done
