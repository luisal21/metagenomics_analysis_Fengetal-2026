#!/bin/bash

KRAKEN="/miniconda3/envs/metagenomics/bin/kraken2"
DB="/data/database/k2_gtdb_genome_reps_20250609/"

INPUT="/data2/nadia/results/kneaddata_31_35"

for SRA in \
SRR32209736 \
SRR32209737 \
SRR32209738 \
SRR32209739 \
SRR32209740
do

    echo "=============================================="
    echo "INICIO KRAKEN2 $SRA: $(date)"
    echo "=============================================="

    OUT="/data2/nadia/results/kraken_36_40"
    mkdir -p "$OUT"

    R1=$(find "$INPUT" -maxdepth 2 -type f \
        -name "${SRA}*kneaddata_paired_1.fastq" -print -quit)

    R2=$(find "$INPUT" -maxdepth 2 -type f \
        -name "${SRA}*kneaddata_paired_2.fastq" -print -quit)

    if [ -z "$R1" ] || [ -z "$R2" ]; then
        echo "ERROR: No se encontraron los FASTQ paired de $SRA"
        exit 1
    fi

    echo "R1: $R1"
    echo "R2: $R2"

    "$KRAKEN" \
        --db "$DB" \
        --memory-mapping \
        --threads 32 \
        --paired \
        "$R1" "$R2" \
        --report "$OUT/${SRA}_GTDB.report" \
        --output /dev/null

    STATUS=$?

    if [ "$STATUS" -eq 0 ]; then
        echo "===== KRAKEN2 $SRA TERMINÓ CORRECTAMENTE: $(date) ====="
        ls -lh "$OUT/${SRA}_GTDB.report"
    else
        echo "===== ERROR KRAKEN2 $SRA código $STATUS: $(date) ====="
        exit "$STATUS"
    fi

    df -h /data2

done

echo "=============================================="
echo "TODAS LAS MUESTRAS TERMINARON KRAKEN2"
echo "$(date)"
echo "=============================================="
