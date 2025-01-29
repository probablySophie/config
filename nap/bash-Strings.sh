# Get everything after the FIRST instance of a given char
my_string="XXX-YYY-ZZZ"
printf "${my_string#*-}" # Gives "YYY-ZZZ"

# Get everything after the LAST instance of a given char
printf "${my_string##*-}" # Gives "ZZZ"

# Get everything before the LAST instance of a given char
printf "${my_string%-*}" # Gives "XXX-YYY"

# Do a REGEX compare
[[ "1234" =~ ^[0-9]{4}$ ]] # Check if the string is 4 digits

# Does the string match a given literal (start with, end with, etc...)
[[ "yes" == y* ]] # Results as true
