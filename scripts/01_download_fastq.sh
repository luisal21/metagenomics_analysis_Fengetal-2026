#!/bin/bash

LIST="/data2/nadia/docs/lista_81_88.txt"
OUT="/data2/nadia/raw_data"

mkdir -p "$OUT"

echo "========================================"
echo "INICIO DESCARGA: $(date)"
echo "========================================"

while read -r SRA_ID
do
    [ -z "$SRA_ID" ] && continue

    echo "----------------------------------------"
    echo "DESCARGANDO $SRA_ID: $(date)"
    echo "----------------------------------------"

    /usr/bin/prefetch "$SRA_ID" \
        --output-directory "$OUT"

    STATUS=$?

    if [ "$STATUS" -eq 0 ]; then
        echo "PREFETCH $SRA_ID TERMINÓ CORRECTAMENTE"
    else
        echo "ERROR EN $SRA_ID, código $STATUS"
    fi

done < "$LIST"

echo "========================================"
echo "TODAS LAS DESCARGAS FINALIZARON: $(date)"
echo "========================================"
