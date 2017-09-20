# PrimerDesignTools
Tools to analyse sequence alignments for primer design

This package includes the two following tools (perl scripts) :

1. conserved_region_finder-percent.pl
Tool to calculate the proportion of each nucleotide at each position of a multiple sequence alignment.

2. ePCR_v2.pl
Tool to test primer sets on a fasta file of reference sequences. Does in silico PCR.

# conserved_region_finder-percent.pl

This script takes as an input a multiple sequence alignment in fasta format. This alignment could be generated using ClustalW or Mega.

Use guide:
perl conserved_region_finder-percent.pl Alignment.fasta

Output example :
'''
Pos     A       T       G       C       Total
1       1       0       0       0       51
2       0       0       1       0       51
3       0       0       1       0       51
4       1       0       0       0       51
5       1       0       0       0       51
6       0.0196078431372549      0       0.980392156862745       0       51
7       1       0       0       0       51
8       0       1       0       0       51
9       0       1       0       0       51
10      1       0       0       0       51
11      0.980392156862745       0.0196078431372549      0       0       51
12      0       1       0       0       51
13      1       0       0       0       51
14      1       0       0       0       51
15      0       1       0       0       51
16      0       0.980392156862745       0       0.0196078431372549      51
'''

# ePCR_v2.pl
This tool does a virtual PCR using a fasta file of primers sequences and a fasta file of sequences to test. User need to provide maximal amplicon length and the number of 5' nucleotides that need to be clipped.

Use guide:
perl ePCR_v2.pl MAXLENGTH CLIP GENOMES PRIMERS
perl ePCR_v2.pl 2000 0 MyGenomes.fasta Primer.fasta 

MAXLENGTH : Maximum length of the putative amplicon. User can give big number if long amplicon is expected.
CLIP : The number of bases that should be clipped in 5' of the primers. This allows to tune specificity of the virtual PCR. Use 0 if you want no clipping.
GENOMES : Name of the genome fasta file.
PRIMERS : Name of the primers fasta file.
