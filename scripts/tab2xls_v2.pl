#!/usr/bin/perl -w

###############################################################################
#
# Example of how to use the WriteExcel module
#
# The following converts a tab separated file into an Excel file
#
# Usage: tab2xls.pl tabfile.txt newfile.xls
#
#
# NOTE: This is only a simple conversion utility for illustrative purposes.
# For converting a CSV or Tab separated or any other type of delimited
# text file to Excel I recommend the more rigorous csv2xls program that is
# part of H.Merijn Brand's Text::CSV_XS module distro.
#
# See the examples/csv2xls link here:
#     L<http://search.cpan.org/~hmbrand/Text-CSV_XS/MANIFEST>
#
# reverse('©'), March 2001, John McNamara, jmcnamara@cpan.org
#


use strict;
use warnings;
use English;
use Spreadsheet::WriteExcel;
use File::Basename;
use open ':encoding(utf8)';

# Check for valid number of arguments
if (($#ARGV < 1) || ($#ARGV > 2)) {
die("Usage: tab2xls folder newfile.xls\n");
};


my $dir = $ARGV[0];

# Create a new Excel workbook
my $workbook  = Spreadsheet::WriteExcel->new($ARGV[1]);
$workbook->set_properties(
title    => 'Corpus analysis Spreadsheet',
author   => 'UPF IULA Web Services',
comments => '',
);

my $text_format  = $workbook->add_format(
                                        bold    => 1,
                                        italic  => 1,
                                        #color   => 'red',
                                        size    => 10,
                                        font    =>'Lucida Calligraphy'
                                    );

foreach my $fp (glob("$dir/*")) {

	#print STDERR "$fp\n";
        (my $fname, my $d,my $ext) = fileparse($fp, qr/\.[^.]*/);
	#print STDERR "fname: $fname\n";
	#print STDERR "dir  : $d\n";
	#print STDERR "ext  : $ext\n";

	# Open the tab delimited file
	#open (TABFILE, $ARGV[0]) or die "$ARGV[0]: $!";
	open my $fh, "<", $fp or die "can't read open '$fp': $OS_ERROR";


	my $worksheet = $workbook->add_worksheet("$fname");
        #my $worksheet = $workbook->add_worksheet();

	# Row and column are zero indexed
	my $row = 0;

	while (<$fh>) {
	chomp;
	# Split on single tab
	my @Fld = split('\t', $_);

	my $col = 0;
	foreach my $token (@Fld) {
            #print STDERR "  : $token\n";
	    if ($token =~ /=/) {
	       $worksheet->write_string($row, $col, $token);
            }else{
               $worksheet->write($row, $col, $token);
            }
	    $col++;
	}
	$row++;
	}

	close $fh or die "can't read close '$fp': $OS_ERROR";
}
