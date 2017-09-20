#!/usr/bin/perl

use strict;
#use warnings;

my %sequences;
my $sequences;
my $lgt;
my $genename;
my %counting;
my $counting;

sub par_num ($$) {
        my ($gauche, $droit) = @_;            
        return $gauche <=> $droit;
} 

open (LISTONE, shift) || die ("Could not open blast file <br> $!");
while(<LISTONE>){
        chomp $_;
        if($_ =~ m/^>/){
                $genename = $_;
        } else {
                if(exists($sequences{$genename})){
                        $sequences{$genename} = "$sequences{$genename}$_";
                } else {
                        $sequences{$genename} = "$_";
                }
        }
}
close (LISTONE);

foreach my $id (keys %sequences){
        my $nt;
        $lgt = length $sequences{$id};
        my $count=0;
        for(my $i=1;$i<=$lgt;$i++){
                $nt = substr($sequences{$id}, $i, 1);
                if(exists($counting{$i}{$nt})){
                        $count = $counting{$i}{$nt};
                        $count++;
                        $counting{$i}{$nt} = $count;
                } else {
                        $counting{$i}{$nt} = 1;
                }
        }
}
print "Pos\tA\tT\tG\tC\tTotal\n";
foreach my $pos (sort par_num(keys %counting)){
        print "$pos";
        my @characters = ("A", "T", "G", "C");
        my $total;
        foreach my $character(@characters){
                if(exists($counting{$pos}{$character})){
                        $total = $total + $counting{$pos}{$character};
                }
        }
        foreach my $character(@characters){
                if(exists($counting{$pos}{$character})){
                        print "\t".$counting{$pos}{$character}/$total;
                } else {
                        print "\t0";
                }
        }
        print "\t$total\n";
}
