# Contawords2

ContaWords2 is an alternate version of [Contawords](https://github.com/upf-iula-trl/servitoros_lite) that uses a pipe instead of a workflow. It counts the words of any texts. It can be used in contawords.iula.upf.edu. 

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
