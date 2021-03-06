#!/bin/bash

help()
{
  cat <<HELP
----- CQP INDEX ------------------------------------
USAGE:         cqp_index.sh -f <corpus file or url list> -s <structure> <-urllist> -c <charset:utf8(default) or latin1>
USAGE EXAMPLE: cqp_index.sh
----------------------------------------------------

HELP
  exit 0
}

if [ "$1" == "" ] ; then
  help;
fi
id=$RANDOM$RANDOM$$
echo "CORPUS$id"

while [ -n "$1" ]; do
case $1 in
    -h) help;shift 1;; # function help is called
    --help) help;shift 1;; # function help is called
    -f) corpus=$2;shift 2;; # -l takes an argument -> shift by 2
    -s) struct=$2;shift 2;; # -l takes an argument -> shift by 2
    -c) charset=$2;shift 2;;
    -urllist) list="Y";shift 1;;
    --) shift;break;; # end of options
    -*) echo "error: no such option $1. -h for help";exit 1;;
    *)  break;;
esac
done

data_dir="/mnt/vmdata/contawords-iulaterm/var/rails/contawords2/storage/data_directory"
registry_dir="/mnt/vmdata/contawords-iulaterm/var/rails/contawords2/storage/registry_directory"
cwb="/usr/local/cwb-3.4.15/bin"
execdir=`dirname $0`
#echo "execdir: $execdir" 1>&2


echo "---Executing cqp_index.sh---"
echo "Variables used: "
echo "data_dir " $data_dir
echo "registry_dir " $registry_dir
echo "cwb " $cwb
echo "Corpus " $corpus
echo "struct " $struct
echo "list " $list
 
if [ ! -f $corpus ] || [ "$corpus" == "" ] ; then
  echo "ERROR: corpus: -f '$corpus' does not exist or it cannot be read!";
  echo "";
  help;
fi

if [ ! -s $struct ] || [ "$struct" == "" ] ; then
  echo "ERROR: structure: -s '$struct' does not exist or it cannot be read!";
  echo "";
  help;
fi

if [ ! "$charset" == "latin1" ] ; then
  charset="utf8"
fi

#id=$RANDOM$RANDOM$$

corpuscmd=""
if [ "$list" == "Y" ]; then
  mkdir download
  wget -q -i $corpus -P download
  cd download
  ls=`ls`
  for f in $ls;
  do mv $f $f.vrt;
  done;
  cd ..
  corpuscmd="-F download"

else
  corpuscmd="-f $corpus"
fi

structcmd=`cat $struct`

mkdir $data_dir/corpus$id

#set -e exits program when one command returns a non 0 status.
echo "$cwb/cwb-encode -xsB -c $charset $corpuscmd -d $data_dir/corpus$id -R $registry_dir/corpus$id $structcmd -v"

set -e
$cwb/cwb-encode -xsB -c $charset $corpuscmd -d $data_dir/corpus$id -R $registry_dir/corpus$id $structcmd


/usr/local/bin/cwb-make -r $registry_dir CORPUS$id

$cwb/cwb-describe-corpus -s -r $registry_dir CORPUS$id 1>&2

echo "CORPUS$id"

## once indexed, remove download directory, since it may ocupy a lot of space
#rm -rf download


