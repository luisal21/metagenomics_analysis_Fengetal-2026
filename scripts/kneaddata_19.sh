#!/bin/bash

SRA="SRR32209719"

R1="/files2/nadia/trimming/${SRA}_1_val_1.fq"
R2="/files2/nadia/trimming/${SRA}_2_val_2.fq"

OUT="/files2/nadia/${SRA}/trimming/resultados_kneaddata"
REF="/files2/nadia/bos_taurus_ref/bos_taurus"

mkdir -p "$OUT"

echo "===== INICIO KNEADDATA $SRA: $(date) ====="

/files2/nadia/envs/kneaddata/bin/kneaddata \
  -i1 "$R1" \
  -i2 "$R2" \
  -db "$REF" \
  -o "$OUT" \
  -t 16 \
  --bypass-trim \
  --run-fastqc-start \
  --run-fastqc-end \
  --remove-intermediate-output

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
    echo "===== KNEADDATA $SRA TERMINÓ CORRECTAMENTE: $(date) ====="
else
    echo "===== ERROR KNEADDATA $SRA, código $STATUS: $(date) ====="
fi

df -h /files2

exit "$STATUS"
