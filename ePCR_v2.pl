#!/usr/bin/perl -w
use strict;
use warnings;

my $maxamplicon =shift;
my $stringency = shift;



my %contig_length;
my $first="true";
my $onecontig;
my $sequence="";
my $fastafile = shift;

#### Sub degenerate transform degenerate primer into regular expression

sub degenerate {
        my $sequence = $_[0];
        $sequence =~ tr/[a-z]/[A-Z]/;
        $sequence =~ s/R/\(G\|A\)/g;
        $sequence =~ s/Y/\(T\|C\)/g;
        $sequence =~ s/M/\(A\|C\)/g;
        $sequence =~ s/K/\(G\|T\)/g;
        $sequence =~ s/S/\(G\|C\)/g;
        $sequence =~ s/W/\(A\|T\)/g;
        $sequence =~ s/H/\(A\|C\|T\)/g;
        $sequence =~ s/B/\(G\|C\|T\)/g;
        $sequence =~ s/V/\(G\|C\|A\)/g;
        $sequence =~ s/D/\(G\|A\|T\)/g;
        return $sequence;
}

####

open (CONTIGLIST, $fastafile) || die ("Could not open CSV genelist");
while(<CONTIGLIST>){
        chomp $_;
        if ($_ =~ /^\>/){
                if ($first eq "false"){
                        $contig_length{$onecontig} = $sequence;
                        $sequence = "";
                }
                $onecontig = $_;
                $first ="false";
        } else {
                $_ =~ tr/[a-z]/[A-Z]/;
                $sequence = $sequence.$_;
        }
}
$contig_length{$onecontig} = $sequence;

#### Traitement des sequences d'amorces

my %primerseqs;

open (PRIMERS, shift) || die ("Could not open primers fasta");
my @primers = (<PRIMERS>);
close(PRIMERS);

my $name;
foreach my $primer(@primers){
        chomp $primer;
        if($primer =~ /^>/){
                my @temp = split(/\>/, $primer);
                $name = $temp[1];
        } else {
               my $temp = substr $primer, $stringency;
               $primer = $temp;
                $primerseqs{$name} = degenerate $primer;
                my $revcom = reverse degenerate $primer;
                $revcom =~ tr/ACGTacgt\(\)/TGCAtgca\)\(/;
                my $newname = "$name-rev";
                $primerseqs{$newname} = $revcom;
        }
}


print "Target\tFirst primer\tSecond primer\tAmplicon Length\n";

my @keyz = keys %primerseqs;
my @targets = keys %contig_length;

foreach my $target (@targets){
  foreach my $primerone(@keyz){
         foreach my $primertwo(@keyz){
      if($contig_length{$target} =~ /($primerseqs{$primerone}.*$primerseqs{$primertwo})/i){
                                my $amplicon;
                                my $ampliconseq;
                                $amplicon = length($1);
                                $ampliconseq = $1;
                                if ($amplicon < $maxamplicon && $amplicon > 30){
                                        print "$target\t$primerone\t$primertwo\t$amplicon\n";
#                         print "\<tr\>\<td\>$target\<\/td\>\<td\>$primerone\<\/td\>\<td\>$primertwo\<\/td>\<td\>$amplicon\<\/td\>\<\/tr\>";
                    }
                        }
                }
        }
}
