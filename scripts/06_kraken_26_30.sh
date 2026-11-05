#!/bin/bash

#/dev/shm/k2_gtdb_genome_reps_20250609/
KRAKEN="/miniconda3/envs/metagenomics/bin/kraken2"
DB="/dev/shm/k2_gtdb_genome_reps_20250609/"
#DB="/data/database/k2_gtdb_genome_reps_20250609/"

# Carpeta única donde están todos los archivos de KneadData de todas las muestras
INPUT="/data2/nadia/results/kneaddata_41_65"

for SRA in \
SRR32209709 \
SRR32209741 \
SRR32209742 \
SRR32209743 \
SRR32209744 \
SRR32209745 \
SRR32209746 \
SRR32209747 \
SRR32209748 \
SRR32209749 \
SRR32209750 \
SRR32209751 \
SRR32209752 \
SRR32209753 \
SRR32209754 \
SRR32209756 \
SRR32209757 \
SRR32209758 \
SRR32209759 \
SRR32209760 \
SRR32209761 \
SRR32209762 \
SRR32209763 \
SRR32209764 \
SRR32209765 \

do

    echo "============================================"
    echo "INICIO KRAKEN2 $SRA: $(date)"
    echo "============================================"

    OUT="/data2/nadia/results/kraken_41_65"
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
