setwd("~/Documents/Courses/Tommy Tang/data")
library(GenomicRanges)
library(rtracklayer)
library(here)
TAZ_peaks<- import(here("fastq/TAZ_peak/TAZ_peaks.narrowPeak"))
YAP_peaks<- import(here("fastq/YAP_peak/YAP_peaks.narrowPeak"))
TAZ_overlap_YAP_peaks<- subsetByOverlaps(TAZ_peaks, YAP_peaks)
YAP_overlap_TAZ_peaks<- subsetByOverlaps(YAP_peaks, TAZ_peaks)
library(Vennerable)
n_YAP <- length(YAP_peaks)  # Total peaks 
n_TAZ <- length(TAZ_peaks)  # Total peaks 

n_overlap <- length(YAP_overlap_TAZ_peaks)

venn_data <- Venn(SetNames = c("YAP", "TAZ"),
                  Weight = c(
                    "10" = n_YAP, # Unique to A
                    "01" = n_TAZ, # Unique to B
                    "11" = n_overlap         # Intersection
                  ))
plot(venn_data)

TEAD4_peaks <- import(here("fastq/TEAD4_peak/TEAD4_peaks.narrowPeak"))
YAP_overlap_TAZ_overlap_TEAD4 <- subsetByOverlaps(YAP_overlap_TAZ_peaks,TEAD4_peaks)

# length of the peaks  
n_TEAD4 <- length(TEAD4_peaks)  # Total peaks 

n_overlap_YTT <- length(YAP_overlap_TAZ_overlap_TEAD4)
venn_data_2 <- Venn(SetNames = c("YAP/TAZ", "TEAD4"),
                  Weight = c(
                    "10" = n_overlap, # Unique to A
                    "01" = n_TEAD4, # Unique to B
                    "11" = n_overlap_YTT         # Intersection
                  ))
plot(venn_data_2)

TAZ_summit <- import(here("fastq/TAZ_peak/TAZ_summits.bed"))
TAZ_summit <- TAZ_summit[TAZ_summit$name %in% TAZ_overlap_YAP_peaks$name]
TEAD4_summit <- import(here("fastq/TEAD4_peak/TEAD4_summits.bed"))
TAZ_500bp_window <- resize(TAZ_summit, width = 500, fix = "center")
hits <- findOverlaps(TEAD4_summit, TAZ_500bp_window)

signed_distance <- function(A,B) {
  dist <- distance(A,B)
  sign <- ifelse (start(A) < start (B), -1,1)
  dist*sign
}

library(dplyr)
library(ggplot2)

summit_distance <- signed_distance(TEAD4_summit[queryHits(hits)], TAZ_summit[subjectHits(hits)])
distance_df <- table(summit_distance) %>%
  tibble::as_tibble()

distance_df %>%
  mutate(summit_distance = as.numeric(summit_distance)) %>%
  arrange(summit_distance) %>%
  ggplot(aes(x=summit_distance, y=n)) +
  geom_line()

df_binned <- distance_df %>%
  mutate(summit_distance = as.numeric(summit_distance)) %>%
  arrange (summit_distance) %>%
  mutate(bin = floor(summit_distance/5)*5) %>%
  group_by(bin) %>%
  summarise(n=mean(n, na.rm = TRUE))

df_binned %>%
  ggplot(aes(x=bin, y = n)) +
  geom_line() +
  scale_x_continuous(breaks = c(-250, 0, 250)) +
  xlab("distance to the summit \nof TAZ peaks (bp)") +
  ylab("peak density") +
  theme_classic(base_size = 14)
                                      
