# Find and replace in all (non-hidden) files in the current directory
find * -type f | xargs sed -i 's/CHANGE_FROM/CHANGE_TO/g'
