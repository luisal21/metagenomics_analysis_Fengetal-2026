#!/bin/bash

#/dev/shm/k2_gtdb_genome_reps_20250609/
KRAKEN="/miniconda3/envs/metagenomics/bin/kraken2"
DB="/dev/shm/k2_gtdb_genome_reps_20250609/"
#DB="/data/database/k2_gtdb_genome_reps_20250609/"

# Carpeta única donde están todos los archivos de KneadData de todas las muestras
INPUT="/data2/nadia/results/kneaddata_81_88"

for SRA in \
SRR32209781 \
SRR32209782 \
SRR32209783 \
SRR32209784 \
SRR32209785 \
SRR32209786 \
SRR32209787 \
SRR32209788 \

do

    echo "============================================"
    echo "INICIO KRAKEN2 $SRA: $(date)"
    echo "============================================"

    OUT="/data2/nadia/results/kraken_81_88"
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
    --threads 16 \
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

echo "============================================"
echo "TODAS LAS MUESTRAS TERMINARON KRAKEN2"
echo "$(date)"
echo "============================================"
