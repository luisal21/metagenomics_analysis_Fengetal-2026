#!/bin/bash

source /miniconda3/etc/profile.d/conda.sh
conda activate trim_galore

mkdir -p /files2/nadia/logs
mkdir -p /files2/nadia/fastqc_trimmed

echo "===== INICIO $(date) ====="

# SRR32209719: solo falta FastQC post-trimming
echo "===== FASTQC SRR32209719 ====="

fastqc \
/files2/nadia/trimming/SRR32209719_1_val_1.fq \
/files2/nadia/trimming/SRR32209719_2_val_2.fq \
-o /files2/nadia/fastqc_trimmed \
-t 2 &

PID19=$!


# SRR32209720: Trim Galore
echo "===== TRIM GALORE SRR32209720 ====="

trim_galore \
--paired \
--quality 20 \
--cores 4 \
--output_dir /files2/nadia/trimming \
/files2/nadia/SRR32209720/SRR32209720_1.fastq \
/files2/nadia/SRR32209720/SRR32209720_2.fastq

# Si Trim Galore terminó correctamente, hacer FastQC
if [ $? -eq 0 ]; then

    echo "===== FASTQC SRR32209720 ====="

    fastqc \
    /files2/nadia/trimming/SRR32209720_1_val_1.fq \
    /files2/nadia/trimming/SRR32209720_2_val_2.fq \
    -o /files2/nadia/fastqc_trimmed \
    -t 2

else
    echo "ERROR: Trim Galore de SRR32209720 falló"
fi


# Esperar a que FastQC de 19 termine
wait $PID19

echo "===== TERMINÓ TODO $(date) ====="

df -h /files2

