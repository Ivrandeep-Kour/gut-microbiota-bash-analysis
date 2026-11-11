# Results

## Sequencing and merging

| Metric | DL | PM |
|---|---:|---:|
| Raw R1 reads | 46,506 | 79,187 |
| Raw R2 reads | 46,506 | 79,187 |
| Merged reads | 40,701 | 72,287 |

## Sequence and taxonomic comparison

- Unique PM sequence variants: **7,670**
- Unique DL species: **350**
- Shared unique sequence variants: **549**
- Shared unique species: **168**
- Species detected in PM but not DL: **85**
- Most abundant PM species: ***Segatella copri***
- Reads assigned to *Segatella copri* in PM: **25,634**
- PM query sequences matching a reference at ≤98.7% identity: **9,640**

## Interpretation

The PM and DL samples have different sequencing depths, so raw read counts alone should not be interpreted as directly comparable biological abundance. Relative abundance or another normalization approach is needed.

Taxonomic assignments below a commonly used species-level 16S similarity threshold should be interpreted cautiously because the reference database may not contain a sufficiently close sequence, and the available region may not provide enough resolution for a confident species-level call.

## Technical takeaways

This project demonstrates an end-to-end command-line microbiome workflow using Bash and VSEARCH for FASTQ processing, exact set comparison, taxonomic summarization, abundance ranking, and percent-identity filtering.
