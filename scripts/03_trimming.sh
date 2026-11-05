#!/bin/bash

source /miniconda3/etc/profile.d/conda.sh
conda activate /home/nadia/envs/trimgalore

IN="/data2/nadia/raw_data"
OUT="/data2/nadia/results/trimgalore_81_88"
THREADS=20

mkdir -p "$OUT"

echo "========================================"
echo "INICIO TRIM GALORE: $(date)"
echo "========================================"

find "$IN" -mindepth 2 -maxdepth 2 -type f -name "*_1.fastq" | while read -r R1
do
    SAMPLE_DIR=$(dirname "$R1")
    SRA_ID=$(basename "$SAMPLE_DIR")
    R2="$SAMPLE_DIR/${SRA_ID}_2.fastq"

    echo "----------------------------------------"
    echo "PROCESANDO $SRA_ID: $(date)"
    echo "R1: $R1"
    echo "R2: $R2"
    echo "----------------------------------------"

    if [ ! -s "$R2" ]; then
        echo "ERROR: No se encontró el R2 de $SRA_ID ($R2)"
        continue
    fi

    if [[ -s "$OUT/${SRA_ID}_1_val_1.fq.gz" && -s "$OUT/${SRA_ID}_2_val_2.fq.gz" ]]; then
        echo "Ya existen los resultados de $SRA_ID, se omite."
        continue
    fi

    trim_galore \
        --paired \
        --fastqc \
        --cores "$THREADS" \
        --output_dir "$OUT" \
        "$R1" "$R2"

    STATUS=$?

    if [ "$STATUS" -eq 0 ]; then
        echo "TRIM GALORE $SRA_ID TERMINÓ CORRECTAMENTE: $(date)"
        ls -lh "$OUT/${SRA_ID}"_*val*.fq.gz
    else
        echo "ERROR EN $SRA_ID, código $STATUS"
    fi
done

echo "========================================"
echo "TODAS LAS MUESTRAS TERMINARON: $(date)"
echo "========================================"
