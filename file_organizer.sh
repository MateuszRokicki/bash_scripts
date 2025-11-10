#!/bin/bash
#
# Check if source and target directories where provided

if [ $# -ne 1 ]
then
	echo "Wrong number of arguments."
	echo "Usage file_organizer.sh <source_dir>"
	exit 1
fi

echo "Starting organizing files in dir $1"
declare -A dir_files=(["Images"]=".jpg .png .gif" ["Documents"]=".pdf .csv .txt .doc .docx" ["Videos"]=".pm4 .avi .mov" ["Audio"]=".mp3 .wav" ["Archives"]=".zip .gzip .rar .7z .tar .gz" ["Others"]="")

dir_order=("Images" "Documents" "Videos" "Audio" "Archives" "Others")

for dir in ${dir_order[@]}; do
	mkdir -p $1/$dir
	if [[ $dir != "Others" ]]; then
		echo "Creating directory $1/$dir"
		for f_type in ${dir_files[$dir]}; do
			echo "Moving files with extensions $f_type"
			mv -i $1/*$f_type $1/$dir 2>/dev/null
		done
		echo
	else
		echo "Moving remaining files to $1/$dir"
		find "$1" -maxdepth 1 -type f -exec mv -i {} "$1/$dir" \;
		echo
	fi
done

echo -e "All files moved to new directories\n"

for dir in ${dir_order[@]}; do
	val=$(ls $1/$dir | wc -l)
	echo "Number of files in $1/$dir: $val" 	
done
