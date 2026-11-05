#!/bin/bash

KRAKEN="/miniconda3/envs/metagenomics/bin/kraken2"
DB="/data/database/k2_gtdb_genome_reps_20250609/"
INPUT="/data2/nadia/results/kneaddata_36_40"
OUT="/data2/nadia/results/kraken_36_40"

mkdir -p "$OUT"

for SRA in \
SRR32209736 \
SRR32209737 \
SRR32209738 \
SRR32209739 \
SRR32209740
do

    echo "=========================================="
    echo "Procesando: $SRA"
    echo "=========================================="

    R1=$(find "$INPUT/$SRA" -type f -name "*kneaddata_paired_1.fastq.gz" -print -quit)
    R2=$(find "$INPUT/$SRA" -type f -name "*kneaddata_paired_2.fastq.gz" -print -quit)

    if [[ -z "$R1" || -z "$R2" ]]; then
        echo "ERROR: No se encontraron paired para $SRA"
        continue
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

    if [[ $? -eq 0 ]]; then
        echo "OK: $SRA"
    else
        echo "ERROR: Kraken2 falló en $SRA"
    fi

done

echo "=========================================="
echo "KRaken2 36-40 TERMINADO"
echo "=========================================="o

