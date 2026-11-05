#!/bin/bash

# 05_kneaddata_31_35.sh
# KneadData para SRR32209720-SRR32209725

source /miniconda3/etc/profile.d/conda.sh
conda activate /data2/nadia/kneaddata_env

INPUT="/data2/nadia/results/trimgalore_81_88"
OUTPUT="/data2/nadia/results/kneaddata_81_88"
LISTA="/data2/nadia/docs/lista_81_88.txt"

# Prefijo de la base Bowtie2 de Bos taurus
DB="/data2/nadia/docs/bos_taurus_ref"

THREADS=16

mkdir -p "$OUTPUT"

while read -r line
do

    R1="$INPUT/${line}_1_val_1.fq"
    R2="$INPUT/${line}_2_val_2.fq"

    echo "=========================================="
    echo "Procesando: $line"
    echo "R1: $R1"
    echo "R2: $R2"
    echo "=========================================="

    # Verificar que existan ambos archivos
    if [[ ! -f "$R1" || ! -f "$R2" ]]
    then
        echo "ERROR: faltan archivos para $line"
        continue
    fi

    # Crear directorio individual
    mkdir -p "$OUTPUT/$line"

    # Ejecutar KneadData
    kneaddata \
        --input1 "$R1" \
        --input2 "$R2" \
        --reference-db "$DB" \
        --output "$OUTPUT/$line" \
        --threads "$THREADS" \
	--bypass-trim \
        --remove-intermediate-output

    if [ $? -eq 0 ]
    then
        echo "OK: $line terminó correctamente"
    else
        echo "ERROR: KneadData falló en $line"
        exit 1
    fi

done < "$LISTA"

echo "=========================================="
echo "KneadData terminó SRR32209781-88"
echo "=========================================="
