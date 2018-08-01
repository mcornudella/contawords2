#!/bin/bash
# -----------------------------------------------------------------------------
# 
# Freeling executor
# -----------------------------------------------------------------------------
set -e

soaplab_scripts_dir="/mnt/vmdata/devel-trl/var/rails/contawords2/scripts"
freeling_dir="/usr/local/share/FreeLing-4.1"
freeling_config="$freeling_dir/data/config"
freeling_bin="/usr/local/bin"
tempFiles="/mnt/vmdata/devel-trl/var/rails/contawords2/storage/temp_files"
inf=$1
infName="$(basename $inf)"
outputFile="$infName.freeling.txt"
outputFileCQP="$infName.FLxmlcqp.txt"
#shift
#shift

lang=$2
#shift
#shift

#echo "---Executing freeling4.sh---"
#echo "Variables used: "
#echo "soaplab_scripts_dir " $soaplab_scripts_dir
#echo "freeling_dir " $freeling_dir
#echo "freeling_config " $freeling_config
#echo "freeling_bin " $freeling_bin
#echo "tempFiles " $tempFiles
#echo "input: $inf" 1>&2
#echo "input name: $infName" 1>&2
#execdir=`dirname $0`
#echo "execdir: $execdir" 1>&2
pwd_dir=`pwd`
#echo "pwd: $pwd_dir" 1>&2
#echo $lang

# ------ Input data cleaner and converter! New from 2013-11-27 -----
"$soaplab_scripts_dir/any2utf8.sh" "$inf" "$tempFiles"
inf="$tempFiles/$infName.utf8.txt"
#inf="$inf.utf8.txt"
#echo "input file in utf: $inf" 1>&2

cfg="en.cfg"

case "$lang" in
  "en"|"EN")
    cfg="en.cfg"
    ;;
  "es"|"ES")
    cfg="es.cfg"
    ;;
  "ca"|"CA")
    cfg="ca.cfg"
    ;;
  "ast"|"AST")
    cfg="as.cfg"
    ;;
  "cy"|"CY")
    cfg="cy.cfg"
    ;;
  "gl"|"gl")
    cfg="gl.cfg"
    ;;
  "it"|"IT")
    cfg="it.cfg"
    ;;
  "pt"|"PT")
    cfg="pt.cfg"
    ;;
esac

#analyze --utf -f $cfg $@ < $inf


#----------------------------------------------------

args="$@"
param1="N"
param2="N"
param3="N"

while [ -n "$1" ]; do
  #echo "-------"
  #echo $@
  #echo $#
  case $1 in
      --keeptags)param1="S"; shift;;
      --outf)param2=$2; shift 2;;
      --bio)param3="S"; shift;;
      --) shift;break;; # end of options
      #-*) echo "error: no such option $1. -h for help";exit 1;;
      *)  shift;;
  esac
done

#echo $@ 1>&2
#cmd=`echo "$args" | sed -r 's/ --keeptags//'` #linux ubuntu
cmd=`echo "$args" | sed 's/ --keeptags//'`
#echo "cmd>$cmd" 1>&2
if [[ "$param3" == "S" && "$lang" == "es" ]] ; then
# "/usr/local/share/Freeling-4.1"
    #cmd=`echo "$cmd" | sed -r 's/ --bio/ -N \/usr\/local\/Freeling\-4\.1\/data\/es\/nerc\/ner\-ab\-rich\.dat/'` #linux ubuntu
    cmd=`echo "$cmd" | sed 's/ --bio/ -N \/usr\/local\/Freeling\-4\.1\/data\/es\/nerc\/ner\-ab\-rich\.dat/'`
  #cmd=`echo "$cmd" | sed -r 's/ --bio/ -N \/usr\/ws\/freeling\/freeling3\.0\-alfa1\/share\/freeling\/es\/ner\/ner\-ab\.dat/'`
else
    cmd=`echo "$cmd" | sed 's/ --bio//'`
#cmd=`echo "$cmd" | sed -r 's/ --bio//'` #linux ubuntu
fi

#echo "cmd>$cmd" 1>&2
#echo "$param1 | $param2" 1>&2 

#echo "Analyzing the file using Freeling..."

if [[ "$param1" == "S" && "$param2" == "tagged" ]] ; then

### keeptags used in PANACEA corpora! -----------------------------------------------------------------
#
#  #echo "$args"
#  #echo $cmd
#  #echo "keeptags call" 1>&2
#
#  execdir=`dirname $0`
#  temp=$RANDOM
#  freelingKeeptags_PreProcess.py -t tags$temp.list < $inf | $freeling_bin/analyze -f $freeling_config/$cfg "$cmd" > $temp.tmp
#  if [ ! -s $temp.tmp ] ; then
#    #if [ -f $temp.tmp ] ; then
#    #  rm -r -f $temp.tmp
#    #fi
#    echo "ERROR: Empty output. Maybe only boilerplate data." 1>&2
#    exit 1;
#  fi
#  cat $temp.tmp | freelingKeeptags_PosProcess.py -t tags$temp.list


#### keep first line and last line!!!! -------------------------------------------------------------------
  head -1 $inf
  cat $inf | sed '1d;$d' | $freeling_bin/analyze -f $cfg $cmd '--flush' > "$tempFiles/$outputFile"
  tail -1 $inf

else
  $freeling_bin/analyze -f $cfg $cmd  '--flush' < $inf > "$tempFiles/$outputFile"
fi

#echo "File analyzed. Converting to xmlcqp format..."

/usr/bin/python $soaplab_scripts_dir/processFLoutputToXMLCQP.py "$tempFiles/$outputFile" "$tempFiles/$outputFileCQP"

#echo "Script executed correctly. Outputfile: "

echo "$tempFiles/$outputFileCQP"
