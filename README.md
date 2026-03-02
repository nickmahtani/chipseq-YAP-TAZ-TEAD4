# ChIP-seq Analysis of YAP/TAZ/TEAD4 Co-binding

Reproducing Figure 1 from [Zanconato et al. 2018](https://pmc.ncbi.nlm.nih.gov/articles/PMC6186417/) using ChIP-seq data for the Hippo pathway effectors YAP, TAZ, and TEAD4. Based on Tommy Tang's [ChIP-seq tutorial](https://www.youtube.com/@crazyhottommy).

## Results

### Paper (Fig 1a–c) vs My Reproduction

| Panel | Paper | My reproduction |
|:---:|:---:|:---:|
| **Fig 1a** — YAP vs TAZ overlap (paper: 7,107) | ![Paper Figure 1](figures/paper_figure1.jpeg) | ![YAP vs TAZ Venn](figures/venn_YAP_TAZ.png) |
| **Fig 1b** — YAP/TAZ vs TEAD4 overlap (paper: 5,522) | | ![YAP/TAZ vs TEAD4 Venn](figures/venn_YAP_TAZ_TEAD4.png) |
| **Fig 1c** — TEAD4 summit distance to TAZ peaks | | ![Summit distance](figures/summit_distance.png) |

My results closely match the paper: 7,164 vs 7,107 shared YAP/TAZ peaks, 5,965 vs 5,522 YAP/TAZ/TEAD4 peaks, and the same sharp summit co-localization at 0 bp.

## Pipeline

**Upstream (bash):**
FASTQ → Bowtie2 alignment → BAM sorting/indexing → BigWig generation → MACS2 peak calling → bedtools multicov

**Downstream (R):**
- Venn diagrams of YAP/TAZ and YAP-TAZ/TEAD4 peak overlaps (`fig1_a_b_c.R`)
- TEAD4 summit distance relative to TAZ peaks — peak density plot
- Common peak identification and read count quantification (`fig 1 def.R`)

## Scripts

| File | Description |
|------|-------------|
| `fig1_a_b_c.R` | Peak overlap Venn diagrams and TEAD4 summit distance analysis |
| `fig 1 def.R` | Common YAP/TAZ/TEAD4 peak export and bedtools multicov |

## Tech Stack

R · GenomicRanges · rtracklayer · ggplot2 · Bowtie2 · MACS2 · bedtools
