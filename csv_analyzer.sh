#!/bin/bash

if [ $# -ne 1 ];
then
	echo "Wrong number of arguments."
	echo -e "Usage: csv_analyzer.sh <filename> \n"
	exit 1
fi

if ! [ -a "$1" ]; then
	echo "File doesn't exist."
	exit 2
fi

if file $1 | grep -q "CSV" || [[ "$1"==*.csv ]]; then
	echo -e "File $1 is type of CSV. \n"
else
	echo -e "File $1 is not type of CSV. \n"
	exit 2
fi

if ! (head -2 $1 | grep -q ","); then
	echo "Comma is not a delimiter of the file."
	exit 3
fi

file_size=$(ls -sh "$1" | awk '{print $1}')
echo -e "Size of the files: $file_size.\n"

all_rows=$(cat $1 | wc -l)
echo -e "File has $((all_rows-1)) rows, excluding header.\n"

echo "Columns:"
i=0
IFS=$','
header=$(head -1 "$1")
for col in $header; do
	echo "$i. $col"
	i=$((i+1))
done
unset IFS

echo -e "\nFirst 5 rows of data:"
tail -n +2 "$1" | head -n 5

blank_lines=$(grep -c "^$" "$1")
if [ $blank_lines -eq 1 ]; then
	echo -e "There is $blank_lines blank line in the file.\n"
else if [ $blank_lines -gt 1 ]; then
	echo -e "There are $blank_lines blank lines in the files.\n"
	fi
fi



echo "Done."
