#!/bin/bash

BRACKEN="/miniconda3/envs/bracken/bin/bracken"
DB="/data/database/k2_gtdb_genome_reps_20250609"
INPUT="/data2/nadia/results/reports_kraken"
OUT="/data2/nadia/results/bracken_10_30"

mkdir -p "$OUT"

for NUM in $(seq 10 30)
do
    SRA="SRR322097${NUM}"

    REPORT="$INPUT/${SRA}_GTDB.report"
    OUTPUT="$OUT/${SRA}_GTDB.bracken"
    OUTREPORT="$OUT/${SRA}_GTDB.bracken.report"

    echo "========================================"
    echo "Procesando $SRA"
    echo "========================================"

    if [ ! -f "$REPORT" ]; then
        echo "ERROR: no existe $REPORT"
        continue
    fi

    "$BRACKEN" \
        -d "$DB" \
        -i "$REPORT" \
        -o "$OUTPUT" \
        -w "$OUTREPORT" \
        -r 150 \
        -l G \
        -t 0

    if [ $? -eq 0 ]; then
        echo "OK: $SRA"
    else
        echo "ERROR: Bracken falló en $SRA"
    fi
done

echo "========================================"
echo "BRACKEN 10-30 TERMINADO"
echo "========================================"
