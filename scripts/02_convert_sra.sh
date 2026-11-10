#!/bin/bash

IN="/data2/nadia/raw_data"
THREADS=20

echo "========================================"
echo "INICIO CONVERSIÓN A FASTQ: $(date)"
echo "========================================"

find "$IN" -mindepth 2 -maxdepth 2 -type f -name "*.sra" | while read -r SRA_FILE
do
    SRA_ID=$(basename "$SRA_FILE" .sra)
    OUT_DIR=$(dirname "$SRA_FILE")

    echo "----------------------------------------"
    echo "CONVIRTIENDO $SRA_ID: $(date)"
    echo "----------------------------------------"

    # Si ya existen los FASTQ, se salta
    if [[ -s "$OUT_DIR/${SRA_ID}_1.fastq" && -s "$OUT_DIR/${SRA_ID}_2.fastq" ]]; then
        echo "Ya existen los FASTQ de $SRA_ID, se omite."
        continue
    fi

    fasterq-dump \
        --split-files \
        --threads "$THREADS" \
        --outdir "$OUT_DIR" \
        "$SRA_FILE"

    STATUS=$?

    if [ "$STATUS" -eq 0 ]; then
        echo "CONVERSIÓN $SRA_ID TERMINÓ CORRECTAMENTE: $(date)"
        ls -lh "$OUT_DIR/${SRA_ID}"_*.fastq
    else
        echo "ERROR EN $SRA_ID, código $STATUS"
    fi
done

echo "========================================"
echo "TODAS LAS CONVERSIONES FINALIZARON: $(date)"
echo "========================================"
