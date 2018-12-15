# CV-analysis
A pipeline that uses the CrispRVariants package to analyze Cas9-induced DNA double-stranded break outcomes in next-generation sequencing data (.bam)

The workflow is as follows :

-Next-generation sequencing data files (.fastq) are aligned to a speified reference genome using bammer3.sh, resulting in .bam files

-A metadata file is created from (ls bamDirectory > input.txt) using mdMake.cpp

-A .bed file is created from the coordinates of the sgRNA used to program Cas9 (BLAST or BLAT are used to find the coordinates)

-CV_analysis combines the bamfiles, metadata file, and BED file to generate a .pdf that illustrates the repair outcomes of the Cas9-induced double stranded break
