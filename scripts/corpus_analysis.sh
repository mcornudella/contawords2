#!/bin/bash

help()
{
  cat <<HELP
----- Corpus analysis  ------------------------------------
Given a corpus ID (corpus indexed with IULA cqp_index WS),
this WS returns an excel file with a corpus Analysis

USAGE:       corpus_analysis.sh CORPUS_ID language_2char_code output_file.xls
-----------------------------------------------------------

HELP
  exit 0
}

if [ "$1" == "" ] ; then
  help;
  echo
fi

registry_dir="/mnt/vmdata/contawords-iulaterm/var/rails/contawords2/storage/registry_directory"
cwb="/usr/local/cwb-3.4.15/bin"
queries_dir="/mnt/vmdata/contawords-iulaterm/var/rails/contawords2/scripts/corpus_analysis_queries"
soaplab_scripts_dir="/mnt/vmdata/contawords-iulaterm/var/rails/contawords2/scripts"
execdir=`dirname $0`

#regexp01="$regexp01"
regexp01="s/  \[.*$//g;"

corpusid="$1"
#corpusid=`#echo "$1" | tr -d " "`
lang="$2"
xlsfile="$3"



#echo "" >&2
#echo "--------------- Corpus Analysis ----------------" >&2
#echo "corpusid       :  |$corpusid|" >&2
#echo "language code  :  $lang" >&2
#echo "" >&2
##echo "execdir        :  $execdir" >&2
##echo "query          :  $query" >&2
##echo "query_file_name:  $query_file_name" >&2
##echo "------------------------------------------------"

if [ "$lang" == "" ] ; then
  echo "using English by default!" >&2
else
  lang=".$lang"
fi

mkdir -p "/mnt/vmdata/contawords-iulaterm/var/rails/contawords2/storage/query_results"

set -e




# Global statistics -----------------------------------------------------------------------------------------------
#echo "STATISTICS" > "query_results/A-summary.txt"

#echo "" >> "storage/query_results/A-summary.txt"

$cwb/cwb-describe-corpus -s -r "$registry_dir" "$corpusid" | grep "p-ATT" | sed -e "s/  \+/\t\t/g" | sed -e "s/p-ATT //"  >> "storage/query_results/A-summary.txt"

#echo "" >> "storage/query_results/A-summary.txt"

cat "$queries_dir/content.txt" >> "storage/query_results/A-summary.txt"

# Frequency Nouns by lemmas ---------------------------------------------------------------------------------------
query="$queries_dir/nouns$lang.txt"
if [ ! -f $query ] ; then
  query="$queries_dir/nouns.txt"
fi
query_file_name=`basename $query | cut -d"." -f1`

#echo "Query          :  Frequency Nouns by lemmas" >&2
#echo "query_path     :  $query" >&2
#echo "query_file_name:  $query_file_name" >&2
#echo "" >&2

$cwb/cqp -r "$registry_dir" -D "$corpusid" -f "$query" | sed -e "$regexp01" > "storage/query_results/B-$query_file_name"

# Frequency Verbs by lemmas ---------------------------------------------------------------------------------------
query="$queries_dir/verbs$lang.txt"
if [ ! -f $query ] ; then
  query="$queries_dir/verbs.txt"
fi
query_file_name=`basename $query | cut -d"." -f1`

#echo "Query          :  Frequency Verbs by lemmas" >&2
#echo "query_path     :  $query" >&2
#echo "query_file_name:  $query_file_name" >&2
#echo "" >&2

$cwb/cqp -r "$registry_dir" -D "$corpusid" -f "$query" | sed -e "$regexp01" > "storage/query_results/B-$query_file_name"


# Frequency Adjectives by lemmas ---------------------------------------------------------------------------------------
query="$queries_dir/adjectives$lang.txt"
if [ ! -f $query ] ; then
  query="$queries_dir/adjectives.txt"
fi
query_file_name=`basename $query | cut -d"." -f1`

#echo "Query          :  Frequency Adjectives by lemmas" >&2
#echo "query_path     :  $query" >&2
#echo "query_file_name:  $query_file_name" >&2
#echo "" >&2

$cwb/cqp -r "$registry_dir" -D "$corpusid" -f "$query" | sed -e "$regexp01" > "storage/query_results/B-$query_file_name"

# Frequency Named Entities by word ---------------------------------------------------------------------------------------
query="$queries_dir/named_entities$lang.txt"
if [ ! -f $query ] ; then
  query="$queries_dir/named_entities.txt"
fi
query_file_name=`basename $query | cut -d"." -f1`

#echo "Query          :  Frequency Named Entities by word" >&2
#echo "query_path     :  $query" >&2
#echo "query_file_name:  $query_file_name" >&2
#echo "" >&2

$cwb/cqp -r "$registry_dir" -D "$corpusid" -f "$query" | sed -e "$regexp01" | sed 's/.*<//' | sed 's/>$//' | sort | uniq -c | sed -e "s/^ *//g" | sed "s/[\/| ]/\t/g;" | sed -e "s/_/ /g" | sed -e "s/NP00SP0/Person/" | sed -e "s/NP00O00/Organization/" | sed -e "s/NP00G00/Geographic/" | sed -e "s/NP00V00/Others/" > "storage/query_results/C-$query_file_name"

# 1-tuple lemma Frequency -----------------------------------------------------------------------------------------------
$cwb/cwb-scan-corpus_3_2 -r "$registry_dir" -C "$corpusid" lemma | sort -nr -k 1 > "storage/query_results/D-freq-lemma.txt"

# 2-tuple lemma pos ---------------------------------------------------------------------------------------------------
$cwb/cwb-scan-corpus_3_2 -r "$registry_dir" -C "$corpusid" word pos | sort -nr -k 1 | awk 'BEGIN{OFS="\t"}{print $1, $2, substr ($3, 0, 1), $3}' > "storage/query_results/E-freq-word.txt"

# 3-tuple lemma lemma
$cwb/cwb-scan-corpus_3_2 -r "$registry_dir" -C "$corpusid" lemma+0 lemma+1 | sort -nr -k 1 > "storage/query_results/F-lemma-bigrams.txt"

# 4-tuple lemma pos(JVNA) lemma pos (JVNA) -----------------------------------------------------------------------------
$cwb/cwb-scan-corpus_3_2 -r "$registry_dir" -C "$corpusid" word+0 pos+0=/[JVNA].*/ word+1 pos+1=/[JVNA].*/ | sort -nr -k 1 | awk 'BEGIN{OFS="\t"}{print $1, $2, substr ($3, 0, 1), $4, substr ($5, 0, 1)}' > "storage/query_results/G-freq-bigrams.txt"



# -------------------------------------------------------------------------------
# Compile xls with all results --------------------------------------------------
#echo "Compiling excel file ..." >&2
#$soaplab_scripts_dir/tab2xls_v2.pl query_results $xlsfile

$soaplab_scripts_dir/tab2xls_v2.pl "/mnt/vmdata/contawords-iulaterm/var/rails/contawords2/storage/query_results" $xlsfile

rm -r "/mnt/vmdata/contawords-iulaterm/var/rails/contawords2/storage/query_results/"
#rm -f query_results/*
