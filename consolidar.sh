#!/bin/bash

EPNRO1="$HOME/EPNro1"

ENTRADA="$EPNRO1/entrada"
SALIDA="$EPNRO1/salida"
PROCESADO="$EPNRO1/procesado"
LOG="$EPNRO1/procesado.log"

# Verificar FILENAME
if [ -z "$FILENAME" ]; then
    echo "ERROR: La variable de ambiente FILENAME no está definida."
    exit 1
fi

# Verificar que exista el entorno
if [ ! -d "$EPNRO1" ]; then
    echo "ERROR: No existe el entorno EPNro1."
    exit 1
fi

while true
do

    for archivo in "$ENTRADA"/*.txt
    do
        if [ -f "$archivo" ]
        then
            cat "$archivo" >> "$SALIDA/${FILENAME}.txt"

            mv "$archivo" "$PROCESADO/"

            echo "$(date '+%d/%m/%Y %H:%M:%S') - Procesado archivo $(basename "$archivo")" >> "$LOG"
        fi
    done

    sleep 5
done