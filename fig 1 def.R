library(GenomicRanges)
library(rtracklayer)
library(here)
library(dplyr)
library(ggplot2)

TAZ_peaks<- import(here("fastq/TAZ_peak/TAZ_peaks.narrowPeak"))
YAP_peaks<- import(here("fastq/YAP_peak/YAP_peaks.narrowPeak"))
TEAD4_peak<- import(here("fastq/TEAD4_peak/TEAD4_peaks.narrowPeak"))

YAP_overlap_TAZ_peaks<- subsetByOverlaps(YAP_peaks, TAZ_peaks)

YAP_overlap_TAZ_peaks_overlap_TEAD4<- subsetByOverlaps(YAP_overlap_TAZ_peaks, TEAD4_peak)
YAP_overlap_TAZ_peaks_overlap_TEAD4

export(YAP_overlap_TAZ_peaks_overlap_TEAD4, con = here("fastq/YAP_TAZ_TEAD4_common.bed"))

# in bash, I ran this: bedtools multicov -bams YAP.sorted.bam TAZ.sorted.bam TEAD4.sorted.bam -bed YAP_TAZ_TEAD4_common.bed > YAP_TAZ_TEAD4_counts.tsv

