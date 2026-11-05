#!/bin/bash

source /miniconda3/etc/profile.d/conda.sh
conda activate trim_galore

SRA="SRR32209720"
R1="/files2/nadia/${SRA}/${SRA}_1.fastq"
R2="/files2/nadia/${SRA}/${SRA}_2.fastq"
TRIM="/files2/nadia/trimming"
QC="/files2/nadia/fastqc_trimmed"

mkdir -p "$TRIM" "$QC"

echo "===== INICIO $SRA: $(date) ====="

trim_galore \
  --paired \
  --quality 20 \
  --cores 4 \
  --output_dir "$TRIM" \
  "$R1" "$R2"

STATUS=$?

if [ "$STATUS" -ne 0 ]; then
    echo "ERROR: Trim Galore falló. No se ejecutará FastQC."
    exit "$STATUS"
fi

echo "===== TRIM GALORE TERMINÓ: $(date) ====="

R1TRIM="$TRIM/${SRA}_1_val_1.fq"
R2TRIM="$TRIM/${SRA}_2_val_2.fq"

if [[ ! -s "$R1TRIM" || ! -s "$R2TRIM" ]]; then
    echo "ERROR: no se encontraron los FASTQ paired finales."
    exit 1
fi

echo "===== INICIANDO FASTQC: $(date) ====="

fastqc \
  "$R1TRIM" "$R2TRIM" \
  -o "$QC" \
  -t 2

echo "===== TODO TERMINÓ: $(date) ====="

df -h /files2
