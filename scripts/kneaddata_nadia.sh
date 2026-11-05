#!/bin/bash

source /miniconda3/etc/profile.d/conda.sh
conda activate /data2/nadia/kneaddata_env

REF="/data2/nadia/docs/bos_taurus_ref"

for SRA in SRR32209720 SRR32209721 SRR32209722 SRR32209723 SRR32209724 SRR32209725
do

    echo "=========================================="
    echo "INICIO KNEADDATA $SRA: $(date)"
    echo "=========================================="

    R1="/data2/nadia/results/trimgalore_14_16_25/${SRA}_1_val_1.fq.gz"
    R2="/data2/nadia/results/trimgalore_14_16_25/${SRA}_2_val_2.fq.gz"

    OUT="/data2/nadia/results/resultados_kneaddata_14_16_25"

    mkdir -p "$OUT"

    kneaddata \
        --input1 "$R1" \
        --input2 "$R2" \
        --reference-db "$REF" \
        --output "$OUT" \
        --threads 16 \
        --bypass-trim \
        --run-fastqc-start \
        --run-fastqc-end \
        --remove-intermediate-output

    STATUS=$?

    if [ "$STATUS" -eq 0 ]; then
        echo "===== KNEADDATA $SRA TERMINÓ CORRECTAMENTE: $(date) ====="
    else
        echo "===== ERROR KNEADDATA $SRA código $STATUS: $(date) ====="
        exit "$STATUS"
    fi

    df -h /data2

done

echo "===== TODAS LAS MUESTRAS TERMINARON: $(date) ====="
