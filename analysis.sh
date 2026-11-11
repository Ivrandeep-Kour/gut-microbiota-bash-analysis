#!/usr/bin/env bash
set -euo pipefail

WORKDIR="${HOME}/gut_microbiota_bash_analysis"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "== 1. Download data =="

wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR628/003/SRR6288933/SRR6288933_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR628/003/SRR6288933/SRR6288933_2.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR628/006/SRR6288926/SRR6288926_1.fastq.gz
wget -nc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR628/006/SRR6288926/SRR6288926_2.fastq.gz
wget -nc https://ftp.ncbi.nlm.nih.gov/refseq/TargetedLoci/Bacteria/bacteria.16SrRNA.fna.gz

for f in SRR6288933_1.fastq.gz SRR6288933_2.fastq.gz SRR6288926_1.fastq.gz SRR6288926_2.fastq.gz bacteria.16SrRNA.fna.gz; do
  [ -f "$f" ] && gunzip -f "$f"
done

echo
echo "== 2. Raw read counts =="
echo -n "DL R1: "; grep -c '^@SRR' SRR6288926_1.fastq
echo -n "DL R2: "; grep -c '^@SRR' SRR6288926_2.fastq
echo -n "PM R1: "; grep -c '^@SRR' SRR6288933_1.fastq
echo -n "PM R2: "; grep -c '^@SRR' SRR6288933_2.fastq

echo
echo "== 3. Merge paired-end reads =="

vsearch --fastq_mergepairs SRR6288933_1.fastq \
  --reverse SRR6288933_2.fastq \
  --fastqout SRR6288933_merged.fastq \
  --relabel SRR6288933_

vsearch --fastq_mergepairs SRR6288926_1.fastq \
  --reverse SRR6288926_2.fastq \
  --fastqout SRR6288926_merged.fastq \
  --relabel SRR6288926_

echo -n "DL merged reads: "; grep -c '^@SRR' SRR6288926_merged.fastq
echo -n "PM merged reads: "; grep -c '^@SRR' SRR6288933_merged.fastq

echo
echo "== 4. Taxonomic classification =="

vsearch --usearch_global SRR6288933_merged.fastq \
  --db bacteria.16SrRNA.fna \
  --blast6out SRR6288933_results.tsv \
  --id 0.51 --notrunclabels --maxhits 1

vsearch --usearch_global SRR6288926_merged.fastq \
  --db bacteria.16SrRNA.fna \
  --blast6out SRR6288926_results.tsv \
  --id 0.51 --notrunclabels --maxhits 1

echo
echo "== 5. Sequence-level comparison =="

sed -n '2~4p' SRR6288933_merged.fastq | sort -u > PM_unique_sequences.txt
sed -n '2~4p' SRR6288926_merged.fastq | sort -u > DL_unique_sequences.txt

echo -n "Unique PM sequences: "; wc -l < PM_unique_sequences.txt
echo -n "Shared unique sequences: "
grep -F -x -f DL_unique_sequences.txt PM_unique_sequences.txt | wc -l

echo
echo "== 6. Species-level comparison =="

cut -f2 SRR6288933_results.tsv | cut -d' ' -f2-3 | sort -u > PM_unique_species.txt
cut -f2 SRR6288926_results.tsv | cut -d' ' -f2-3 | sort -u > DL_unique_species.txt

echo -n "Unique DL species: "; wc -l < DL_unique_species.txt
echo -n "Shared unique species: "
grep -F -x -f DL_unique_species.txt PM_unique_species.txt | wc -l
echo -n "Species unique to PM: "
grep -F -x -v -f DL_unique_species.txt PM_unique_species.txt | wc -l

echo
echo "== 7. Most abundant species in PM =="

cut -f2 SRR6288933_results.tsv \
  | cut -d' ' -f2-3 \
  | sort \
  | uniq -c \
  | sort -n \
  | tail -1

echo
echo "== 8. PM hits at or below 98.7% identity =="

cut -f3 SRR6288933_results.tsv \
  | egrep -c '(^[9][8].[0-7]$|^[9][0-7].[0-9]$|^[0-8][0-9].[0-9]$)'

echo
echo "Analysis complete."
