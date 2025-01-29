# Declaring an array
my_array=("var1" "var2" 3)

# Adding to an array
my_array+=("var4")

# Looping over array items
for item in "${item_list[@]}"; do
	printf "$item\n"
done

# Looping from i in 0 to array length
for ((i=0; i<${#my_array[@]}; i++)); do
	printf "${my_array[$i]}\n"
done
