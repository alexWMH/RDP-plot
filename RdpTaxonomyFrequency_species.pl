#!/usr/bin/perl -w
# usage : RdpTaxonomyFrequency.pl otutab.freq otus.rdp

use strict;
use Getopt::Long;


# set paramter

my $cutoff=0.8;
my $outprefix="method";

GetOptions(
    "cutoff=f" => \$cutoff,
    "outprefix=s" => \$outprefix
    );


# load OTU frequency

my %osf=();

open(IN,"<$ARGV[0]") || die "open $ARGV[0]: $!\n";
$_=<IN>;
my @sample=split("\t",$_); chomp $sample[-1];
while(<IN>) {
    my @a=split("\t",$_); chomp $a[-1];
    for(my $i=1;$i<@a;$i++) {
        $osf{$a[0]}{$sample[$i]}=$a[$i];
    }
}
close IN;

shift(@sample);


# load taxonomy of OTU representative

my %ltq=();
my %to=();

open(IN,"<$ARGV[1]") || die "open $ARGV[1]: $!\n";
while(<IN>) {
    #$_=~s/"//g; $_=~s/ /_/g;
    my @a=split("\t",$_); chomp $a[-1];
    for(my $i=10;$i<@a;$i+=3) {
        if($a[$i]>=$cutoff) {
            $ltq{$a[$i-1]}{$a[$i-2]}=1;
            push(@{$to{"$a[$i-1]_$a[$i-2]"}},$a[0]);
        }
    }
}

my %tsf=();

foreach my $t (keys %to) {
    foreach my $s (@sample) {
	foreach my $o (@{$to{$t}}) {
	    if(!$osf{$o}{$s}) { $osf{$o}{$s}=0; }
	}
		#my ($sp)=$t=~/.+\_(.+)/;
        my @a=map($osf{$_}{$s},@{$to{$t}});
        $tsf{$t}{$s}=Sum(@a);
    }
}

# calculate taxonomy frequency and output

my @level=("phylum","class","order","family","genus","species");

foreach my $l (@level) {
    open(OUT,">$outprefix.$l.freq") || die "open $outprefix.$l.freq: $!\n";
    print OUT "taxonomy\t".join("\t",@sample)."\n";
    my @tax=keys %{$ltq{$l}};
    my %tasf=();
    my %ttsf=();
    foreach my $t (@tax) {
	$tasf{$t}=$t;
        foreach my $s (@sample) {
	    $tasf{$t}.="\t".sprintf("%.4f",$tsf{"$l\_$t"}{$s});     # $tasf{$t}.="\t".sprintf("%.3f",$tsf{"$l\_$t"}{$s});
	    $ttsf{$t}+=$tsf{"$l\_$t"}{$s};
        }
    }
    @tax=sort{$ttsf{$b}<=>$ttsf{$a}}@tax;
    foreach my $t (@tax) {
	print OUT $tasf{$t}."\n";
    }
    close OUT;
}



######################################################################


sub Sum {
    my $s=0;
	foreach my $e (@_) { if($e){$s+=$e};}
    return $s;
}
