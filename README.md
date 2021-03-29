# Contawords2

[DEPRECATED] ContaWords2 is an alternate version of [Contawords](https://github.com/upf-iula-trl/servitoros_lite) that uses a pipe instead of a workflow. It counts the words of any texts. It can be used in contawords.iula.upf.edu. 

## Installation

* [Ruby](https://www.ruby-lang.org/en/): version 2.5.1

* [Freeling](http://nlp.lsi.upc.edu/freeling/index.php/node/1): version 4.1

* [Corpus WorkBench](http://cwb.sourceforge.net/install.php): version 3.4.14
  * Contawords assumes that all the cwb commands can be found in the directory `/usr/local/cwb-3.4.14/bin/`

All required gems are specified in Gemfile. You just have to type the following command:

`$ bundle install`

## Database creation

In order to create the database, you should type the following commands:

`$ rake db:create:all`
`$ rake db:migrate`

If you need to delete an existing database first, you should need to execute the following command before the previous ones:

`$ rake db:drop:all`

### Check correct paths

A Contawords execution consist of calls to several scripts, stored in `scripts`. Please check that the paths listed here are correct on these files:

* callFreelingGivenURL_text_list.py
  * scripts_dir
  * tempFiles_dir

* corpus_analysis.sh
  * registry_dir
  * queries_dir
  * soaplab_scripts_dir
  * cwb

* cqp_index.sh
  * data_dir
  * registry_dir
  * cwb

* freeling4.sh
  * soaplab_scripts_dir
  * freeling_dir
  * freeling_config
  * freeling_bin
  * tempFiles

* pipa_contawords_URL_list.sh
  * scripts_dir
  * output_dir
  
  ### Dependencies
  
  Contawords uses perl and python scripts. Make sure that they are installed with the following dependencies:
  
  * Bash libraries
    * pdftotxt (sudo apt-get install poppler-utils)
  
  * Python's required libraries (most of them come installed by default)
    * subprocess
    * irllib2
  
  * Perl modules
    * Spreadsheet::WriteExcel
