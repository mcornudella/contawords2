#!/bin/bash

set -e

source "$(dirname $0)/timer.sh"

input="$1"
#echo "$1: " $input
inputName="$(basename $1)"
#echo "inputName: " $inputName
outputdir="$2"
#echo "outputdir: " $outputdir
output="$inputName.out"
#echo "output: " $output
outputClean="$inputName.utf8.txt"
#echo "outputClean: " $outputClean
dir="$(dirname $0)"
#echo "dir: " $dir

if [ ! -f "$input" ] || [ ! -s "$input" ]; then
  echo "ERROR: input file: $input is not a file, does not exist or it is empty!" >&2
  exit 1
fi
#echo "$input" >&2

t_total=$(timer)

iconvlist=`iconv -l | tr ',' '\n' | sed 's/\///g'`
#echo "$iconvlist" >&2

fileResponse=`file -i -b $input` #linux ubuntu
#fileResponse=`file -b $input` #macos
#echo "fileResponse: " $fileResponse
#echo "$msg" >&2

if [[ $fileResponse =~ "pdf" ]]; then
	#echo "$input PDF pdftotext to UTF8" >&2
	pdftotext "$input" "$2/$output"

else
	charset=`echo "$fileResponse" | awk '{print $2}' | sed 's/charset=//' | tr '[:lower:]' '[:upper:]'`
    	#echo "charset: " $charset
	app=`echo "$fileResponse" | awk '{print $1}'`
    	#echo "app: " $app
	#echo "$input $charset" >&2

	if [[ $iconvlist =~ "$charset" ]]; then
        	if [[ $charset =~ "UTF-8" ]]; then #linux ubuntu
        	#if [[ $app =~ "UTF-8" ]]; then #macos
			#echo "$input is UTF8" >&2
			cp "$input" "$2/$output"
		else
			#echo "$input $charset iconv to UTF8" >&2
			iconv -f "$charset" -t UTF-8 "$input" > "$2/$output"
		fi

	else
		echo "ERROR! charset: $charset app: $app These kind of files are not accepted. Use PDF or plain text." >&2
		exit 1
		# echo "$input $app $charset unoconv to txt" >&2
		# cp "$input" "$input.doc"
		# timeout 400 unoconv -d document -f txt --stdout "$input.doc" > "$output.pre"
		# charset=`file -i -b "$output.pre" | awk '{print $2}' | sed 's/charset=//' | tr '[:lower:]' '[:upper:]'`

		# if [[ $iconvlist =~ "$charset" ]]; then

		# 	if [[ $charset =~ "UTF-8" ]]; then
		# 		echo "$output.pre is UTF8" >&2
		# 		cp "$output.pre" "$output"
		# 	else
		# 		echo "$output.pre $charset iconv to UTF8" >&2
		# 		iconv -f "$charset" -t UTF-8 "$output.pre" > "$output"
		# 	fi
		# fi

	fi
fi

if [ ! -f "$2/$output" ] || [ ! -s "$2/$output" ]; then
  echo "ERROR: output file: $output is not a file, does not exist or it is empty!" >&2
  exit 1
fi

cat "$2/$output" | python "$dir/clean_utf8_data.py" > "$2/$outputClean" 2> "$2/$outputClean.log"
#rm "$output"

#printf 'Encoding conversion and cleaning: %s\n' $(timer $t_total) >&2
