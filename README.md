# Spatial Variation in Gut Microbiota Along the Human Colon

A reproducible Bash/VSEARCH workflow for comparing 16S rRNA V4 sequencing data from two regions of the healthy human colon:

- **DL** — distal lumen (`SRR6288926`)
- **PM** — proximal mucosa (`SRR6288933`)

This portfolio project demonstrates command-line bioinformatics skills in Linux, including FASTQ handling, paired-end read merging, taxonomic classification, Unix text processing, set comparisons, and abundance analysis.

> **Portfolio note:** This repository is a cleaned, reproducible version of a university bioinformatics programming exercise. The original assignment handout is not included. Public sequencing data and public NCBI reference data are downloaded directly by the workflow.

## Skills demonstrated

- Bash / Linux command line
- `wget`, `gunzip`, `grep`, `sed`, `cut`, `sort`, `uniq`, `wc`, pipes and redirection
- VSEARCH paired-end read merging
- VSEARCH global sequence search
- FASTQ and TSV processing
- 16S rRNA taxonomic comparison
- Reproducible analysis workflow

## Biological question

Do bacterial communities from the proximal mucosa and distal lumen differ in the species and sequence variants detected from the V4 region of the 16S rRNA gene?

## Data

| Sample | Region | SRA accession |
|---|---|---|
| PM | Proximal mucosa | `SRR6288933` |
| DL | Distal lumen | `SRR6288926` |

Reference database: NCBI RefSeq 16S rRNA Targeted Loci database (`bacteria.16SrRNA.fna`).

## Repository structure

```text
gut-microbiota-bash-analysis/
├── README.md
├── analysis.sh
├── RESULTS.md
└── .gitignore
```

The raw FASTQ files and reference database are intentionally not stored in GitHub because they are large and can be downloaded reproducibly by `analysis.sh`.

## How to run

Requirements:

- Linux / Bash
- VSEARCH
- `wget`
- standard Unix tools (`grep`, `sed`, `cut`, `sort`, `uniq`, `wc`)

Run:

```bash
chmod +x analysis.sh
./analysis.sh
```

The script will download the public data, merge paired reads, classify sequences against NCBI RefSeq 16S, compare sequence/species sets, and summarize abundance and percent-identity results.

## Key results

| Analysis | Result |
|---|---:|
| DL raw reads per mate | 46,506 |
| PM raw reads per mate | 79,187 |
| DL merged reads | 40,701 |
| PM merged reads | 72,287 |
| Unique PM sequences | 7,670 |
| Unique DL species | 350 |
| Shared unique sequences | 549 |
| Shared unique species | 168 |
| Species unique to PM | 85 |
| Most abundant PM species | *Segatella copri* |
| *S. copri* PM reads | 25,634 |
| PM hits with ≤98.7% identity | 9,640 |

See [`RESULTS.md`](RESULTS.md) for interpretation.

## Workflow overview

```text
Paired FASTQ reads
      |
      v
VSEARCH merge pairs
      |
      v
Merged V4 reads
      |
      v
VSEARCH global search against NCBI 16S
      |
      v
BLAST-like TSV results
      |
      +--> sequence-level comparison
      +--> species-level comparison
      +--> abundance analysis
      +--> percent-identity assessment
```

## Resume-friendly project description

**Linux/Bash Bioinformatics Analysis — 16S rRNA Gut Microbiome**

Built a reproducible Linux command-line workflow using Bash and VSEARCH to merge paired-end 16S reads, classify sequences against the NCBI RefSeq 16S database, compare shared and region-specific bacterial taxa, quantify sequence abundance, and assess taxonomic matches by percent identity.
