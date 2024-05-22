#!/usr/bin/perl -w
# usgae : OtuFrequency.pl otutab.txt

use strict;
				

# load OTU table

my %is=();
my %in=();

open(IN,"<$ARGV[0]") || die "open $ARGV[0]: $!\n";
$_=<IN>; chomp $_;
my @a=split("\t",$_);
for(my $i=1;$i<@a;$i++) {
    $is{$i}=$a[$i];
}
while(<IN>) {
    chomp $_;
    my @a=split("\t",$_);
    for(my $i=1;$i<@a;$i++) {
	$in{$i}+=$a[$i];
    }
}
seek(IN,0,0);


# calculate frequency and output (sort by mean frequency)

my %of=();
my %omf=();

$_=<IN>; print $_;
while(<IN>) {
    chomp $_;
    my @a=split("\t",$_);
    my $o=$a[0];
    my @f=();
    for(my $i=1;$i<@a;$i++) {
	my $f = $a[$i] == 0 ? 0 : $a[$i]/$in{$i}*100;
	push(@f,$f);
    }
    $of{$o}=join("\t",@f);
    $omf{$o}=Mean(@f);
}
close IN;

foreach my $o (sort{$omf{$b}<=>$omf{$a}}keys %omf) {
    print "$o\t$of{$o}\n";
}



######################################################################


sub Mean {
    my $m=0;
    foreach my $e (@_) { $m+=$e; }
    $m/=scalar(@_);
    return $m;
}
