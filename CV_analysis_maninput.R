## CV_analysis
##
## an R script to analyze NGS sequencing data (*.fastq) aligned to 
## a genome (*.bam) using CrispRVariants
##
## written by Cody Hasty in RStudio in Ubuntu 16.04 LTS

## download libraries

 #source("https://bioconductor.org/biocLite.R")

 #biocLite("CrispRVariants")
 #biocLite("rtracklayer")
 #biocLite("BSgenome")
 # biocLite("BiocInstaller")
 #biocLite("BSgenome.Mmusculus.UCSC.mm10")
 #biocLite("BSgenome.Hsapiens.UCSC.hg38")
 #biocLite("GenomicFeatures")
 #biocLite("gridExtra")

## load libraries

# consider moving library(*) functions to the code where they are applied

library(CrispRVariants)
library(rtracklayer)
library(BSgenome)
library(BiocInstaller)
library(BSgenome.Mmusculus.UCSC.mm10)
#library(BSgenome.Hsapiens.UCSC.hg38)
library(GenomicFeatures)
library(gridExtra)

## get reference genome from UCSC

# hg38
# available.genomes()
# refGenome <- getBSgenome("BSgenome.Hsapiens.UCSC.hg38")
# supportedUCSCtables("hg38")
# refGenome_txdb <- makeTxDbFromUCSC(genome = "hg38", tablename = "knownGene")

# mm9
refGenome <- getBSgenome("BSgenome.Mmusculus.UCSC.mm9")
supportedUCSCtables("mm9")
refGenome_txdb <- makeTxDbFromUCSC(genome = "mm9", tablename = "knownGene")

## load BED file as GRanges object

bed_fname <- "VHL.bed"
bed <- rtracklayer::import(bed_fname)
bed

# expand the window specified by *.bed to look for variants
bed_expanded <- GenomicRanges::resize(bed, width(bed) + 20, fix = "center")
bed_expanded

## load metadata file

md = read.table("vhl_md.txt", header = TRUE, sep = "\t")


bam_fnames <- as.character(md$bamfile)
all(file.exists(bam_fnames))

## Load reference sequence for coordinates of sgRNA

reference <- getSeq(refGenome, bed_expanded)

##make crisprset

CrisprSet = readsToTarget(bam_fnames, target = bed_expanded, reference = reference, names = md$name, target.loc = 27)
CrisprSet

##plot variants
guide = "33R"
group = md$Group

pdf(paste(guide, "clone_pool.pdf", sep = "_"), width = 11.5, height = 7)
p <- plotVariants(CrisprSet, txdb = refGenome_txdb, gene.text.size = 8,
                    row.ht.ratio = c(1,8), col.wdth.ratio = c(4,2),
                    plotAlignments.args = list(top.n = 5, line.weight = 0.5, ins.size = 2,
                                               legend.symbol.size = 4),
                    plotFreqHeatmap.args = list(top.n = 5, plot.text.size = 1.8, x.size = 8, group = group,
                                                legend.text.size = 8,
                                                legend.key.height = grid::unit(0.5, "lines")))
p

dev.off()
