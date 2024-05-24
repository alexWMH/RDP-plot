#!/usr/bin/perl -w 
# usage: -s [sample mapping] -g [group] -e [element] -t [top ?] [frequence table] 

use strict;
use Getopt::Long;

my $t = 10;
my $sample_mapping = "";
my $element = "";
my $group = "";
my $help = 0;
my $output = "";
my $width = 80;
my $height = 20;
my $label = "Smpl";

GetOptions (
			"t=i" =>\$t,
			"s=s" =>\$sample_mapping,
			"e=s" =>\$element,
			"g=s" =>\$group,
			"o=s" =>\$output,
			"l=s" =>\$label, 
			"Y=i" =>\$height,
			"W=i" =>\$width,
			"h!"=>\$help
		);
my $msg = "
		======================================== Help instruction ========================================
	Usage:
		Rdp_bar_plot.pl -s [sample_mapping file] -g [group] -t [top ? species] [frequency species table]
	
	Options:

	-s		input file : sample_mapping file. -> make sure the sample mapping file sample column name change to \"Smpl\" 
	-g		select column name you want to distingush group. 
	-e		the group unique element for reorder sepprate by \",\", ex. Con,disease1,disease2,....  default is NULL. 
	-t		top species you want to show. default is 10, max is 30
	-o		output file name
	-Y		plot height default = 20
    -W		plot width; default = 80
	";

($help)? do {print "$msg\n"; exit;} : ();
my %h;
my @sample;

my ($name) = $ARGV[0] =~ /\D+\.(\D+)\.freq$/;
print "$name\n";

open IN,"<$ARGV[0]" or die "can't open file $ARGV[0] $!\n";
my $first = <IN>; chomp $first;
@sample = split "\t", $first;


my $x = shift @sample;

foreach my $xx (1..$t) {
	my $line = <IN>; chomp $line;
	my @a = split "\t", $line;
	if  ($a[0] eq "Unclassified" ) {
		$line = <IN>; chomp $line;
		@a = split "\t", $line;
	}
	foreach my $e (0..$#sample) {
		$h{$sample[$e]}{$a[0]} = $a[$e+1];	
	}
}


while (<IN>) {
	chomp $_;
	my @a = split "\t", $_;
	foreach my $e (0..$#sample) {
		$h{$sample[$e]}{others} += $a[$e+1];
	}
}
close IN;

open (OUT,">r.txt");
print OUT "Smpl\tspecies\tcount\n";
foreach my $e (sort {$a cmp $b} keys %h) {
	foreach my $k ( keys %{$h{$e}}) {
			print OUT "$e\t$k\t$h{$e}{$k}\n";			
	}
}
close OUT;

if ($element eq "") {
	($output)? `RDPbar.r -m $sample_mapping -n $output -g $group -o $output -l $label -H $height -W $width r.txt` : `RDPbar.r -m $sample_mapping -n $name -g $group -l $label -H $height -W $width r.txt`;
	#`rm r.txt`;
} else {
	($output)? `RDPbar.r -m $sample_mapping -n $output -e $element -g $group -o $output -l $label -H $height -W $width r.txt` : `RDPbar.r -m $sample_mapping -n $name -e $element -g $group -l $label -H $height -W $width r.txt`;
	#`rm r.txt`;
}

