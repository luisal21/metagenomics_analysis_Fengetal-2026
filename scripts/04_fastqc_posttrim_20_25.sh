#!/bin/bash

# 04_fastqc_posttrim_20_25.sh
# FastQC posterior a Trim Galore para SRR32209720-SRR32209725

INPUT="/data2/nadia/results/trimgalore_14_16_25"
OUTPUT="/data2/nadia/results/fastqc_posttrim_20_25"
LISTA="/data2/nadia/lista_20_25.txt"

FASTQC="/miniconda3/envs/metagenomics/bin/fastqc"

mkdir -p "$OUTPUT"

while read -r line
do

    R1="$INPUT/${line}_1_val_1.fq.gz"
    R2="$INPUT/${line}_2_val_2.fq.gz"

    echo "=========================================="
    echo "FastQC post-trimming: $line"
    echo "R1: $R1"
    echo "R2: $R2"
    echo "=========================================="

    if [[ ! -f "$R1" || ! -f "$R2" ]]
    then
        echo "ERROR: faltan archivos para $line"
        continue
    fi

    "$FASTQC" \
        "$R1" \
        "$R2" \
        --outdir "$OUTPUT" \
        --threads 2

    if [ $? -eq 0 ]
    then
        echo "OK: FastQC terminó para $line"
    else
        echo "ERROR: FastQC falló en $line"
        exit 1
    fi

done < "$LISTA"

echo "=========================================="
echo "FastQC post-trimming terminó SRR20-25"
echo "=========================================="
