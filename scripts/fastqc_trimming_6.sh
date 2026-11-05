#!/bin/bash

TRIM="/miniconda3/envs/trim_galore/bin/trim_galore"
FASTQC="/miniconda3/envs/trim_galore/bin/fastqc"

BASE="/files2/nadia"

SAMPLES=(
SRR32209715
SRR32209716
SRR32209717
SRR32209718
SRR32209719
SRR32209720
)

for SRA_ID in "${SAMPLES[@]}"
do

    echo "======================================"
    echo "INICIANDO $SRA_ID"
    echo "======================================"

    R1="$BASE/$SRA_ID/${SRA_ID}_1.fastq"
    R2="$BASE/$SRA_ID/${SRA_ID}_2.fastq"

    # 1. FastQC de los FASTQ crudos
    "$FASTQC" \
        --threads 8 \
        --outdir "$BASE/fastqc_raw" \
        "$R1" "$R2"

    # 2. Trim Galore paired-end, Q20
    "$TRIM" \
        --paired \
        --quality 20 \
        --cores 8 \
        --output_dir "$BASE/trimming" \
        "$R1" "$R2"

    # 3. FastQC después de Trim Galore
    "$FASTQC" \
        --threads 8 \
        --outdir "$BASE/fastqc_trimmed" \
        "$BASE/trimming/${SRA_ID}_1_val_1.fq" \
        "$BASE/trimming/${SRA_ID}_2_val_2.fq"

    echo "TERMINÓ $SRA_ID"

done

echo "======================================"
echo "TERMINARON LAS 6 MUESTRAS"
echo "======================================"
