#!/bin/bash

#conda activate metagenomics

SRA_ID="SRR32209783"
THREADS=32

INPUT_DIR="/files2/nadia/SRR32209783/trimming/resultados_kneaddata"
GTDB_OUT="/files2/nadia/SRR32209783/kraken2"

mkdir -p "$GTDB_OUT"

# SCRIPT PARA KRAKEN
 kraken2 \
        --db /dev/shm/k2_gtdb_genome_reps_20250609/ \
        --memory-mapping \
        --threads "$THREADS" \
        --paired \
        "$INPUT_DIR/${SRA_ID}_1_val_1_kneaddata_paired_1.fastq" \
        "$INPUT_DIR/${SRA_ID}_1_val_1_kneaddata_paired_2.fastq" \
        --report "$GTDB_OUT/${SRA_ID}_GTDB.report" \
        --output "$GTDB_OUT/${SRA_ID}_GTDB.output" \
        --unclassified-out "$GTDB_OUT/${SRA_ID}_GTDB_unclassified#.fastq"


echo "Termine"
