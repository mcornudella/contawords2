#!/bin/bash
# -----------------------------------------------------------------------------
# 
# Contawords executor
# -----------------------------------------------------------------------------
set -e

scripts_dir="/Users/miquelcornudella/Documents/IULA/tasques/contawords/scripts"
output_dir="/Users/miquelcornudella/Documents/IULA/tasques/contawords/public/system/output_files"

inputFile=$1
lang=$2

#echo "---Executing pipa_contawords.sh given file containing a URL list---"
#echo ""
#echo "Input params"
#echo $inputFile
#echo $lang
#echo ""
#echo "Step 1. Call callFreelingGivenURL_text_list.py"
outputFileFL=$(/usr/bin/python $scripts_dir/callFreelingGivenURL_text_list.py "$inputFile" $lang 2>&1 )


outputFileFL="$(echo $outputFileFL | cut -d' ' -f1)"

#echo "outputFileFL: " $outputFileFL

#echo ""
#echo "Step 2. Call cqp_index.sh"
#$scripts_dir/cqp_index.sh -f $outputFileFL -s "$scripts_dir/cqp_struct.txt"
corpusID=$( $scripts_dir/cqp_index.sh -f $outputFileFL -s "$scripts_dir/cqp_struct.txt" 2>&1 ) 
corpusID="$(echo $corpusID | cut -d' ' -f1)"
#echo $corpusID

#echo ""
#echo "Step 3. Call corpus_analysis.sh"
$scripts_dir/corpus_analysis.sh $corpusID $lang "$output_dir/$corpusID.xls"

#echo ""
#echo "Done"
#echo "Output file: $corpusID.xls created"
#echo "You can find the output file in the output directory: $output_dir"
#echo "Bye"
echo "$output_dir/$corpusID.xls"


