#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EPNRO1="$HOME/EPNro1"
PIDFILE="$EPNRO1/consolidar.pid"

# Parametro optativo -d: borra el entorno y mata el proceso en background
if [ "$1" = "-d" ]; then
    if [ -f "$PIDFILE" ]; then
        pid=$(cat "$PIDFILE")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null
            echo "Proceso en background (PID $pid) finalizado."
        fi
    fi

    if [ -d "$EPNRO1" ]; then
        rm -rf "$EPNRO1"
        echo "Entorno EPNro1 eliminado."
    else
        echo "No existe el entorno EPNro1."
    fi

    exit 0
fi

if [ -z "$FILENAME" ]; then
    echo "ERROR: La variable de ambiente FILENAME no está definida."
    echo "Ejemplo:"
    echo "  export FILENAME=alumnos"
    exit 1
fi

opcion=0

until [ "$opcion" = "7" ]
do
    echo "=============================="
    echo "        PROYECTO BASH"
    echo "=============================="
    echo "1) Crear entorno"
    echo "2) Correr proceso"
    echo "3) Listar alumnos"
    echo "4) 10 notas más altas"
    echo "5) Buscar alumno"
    echo "6) Visualizar log"
    echo "7) Salir"
    echo "=============================="

    read -p "Ingrese una opción: " opcion

    case $opcion in
        1)
            mkdir -p "$EPNRO1"/{entrada,salida,procesado}
            touch "$EPNRO1/procesado.log"
            cp "$SCRIPT_DIR/consolidar.sh" "$EPNRO1/consolidar.sh"
            chmod +x "$EPNRO1/consolidar.sh"
            echo "Entorno creado correctamente en $EPNRO1"
            ;;

        2)
            if [ ! -d "$EPNRO1" ]; then
                echo "ERROR: Primero tenés que crear el entorno (opción 1)."
                continue
            fi

            if [ ! -f "$EPNRO1/consolidar.sh" ]; then
                echo "ERROR: No se encontró consolidar.sh en EPNro1. Volvé a crear el entorno (opción 1)."
                continue
            fi

            if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
                echo "El proceso ya se está ejecutando (PID: $(cat "$PIDFILE"))."
                continue
            fi

            "$EPNRO1/consolidar.sh" &
            echo $! > "$PIDFILE"
            echo "Proceso ejecutándose en segundo plano con PID: $(cat "$PIDFILE")"
            ;;

        3)
            ARCHIVO="$EPNRO1/salida/${FILENAME}.txt"

            if [ -f "$ARCHIVO" ]; then
                echo "Listado de alumnos ordenado por número de padrón:"
                sort -n -k1,1 "$ARCHIVO"
            else
                echo "No existe el archivo ${FILENAME}.txt en la carpeta salida."
            fi
            ;;

        4)
            ARCHIVO="$EPNRO1/salida/${FILENAME}.txt"

            if [ -f "$ARCHIVO" ]; then
                echo "10 notas más altas:"
                sort -k5,5nr "$ARCHIVO" | head -10
            else
                echo "No existe el archivo ${FILENAME}.txt en la carpeta salida."
            fi
            ;;

        5)
            ARCHIVO="$EPNRO1/salida/${FILENAME}.txt"

            if [ ! -f "$ARCHIVO" ]; then
                echo "No hay datos todavia. No existe el archivo ${FILENAME}.txt"
                continue
            fi

            read -p "Ingrese el nombre, apellido o padron que quiere buscar: " busqueda

            if [ -z "$busqueda" ]; then
                echo "ERROR: Debe ingresar un valor para buscar."
            else
                echo "Resultados para '$busqueda':"
                echo "--------------------------------"
                
                # igonara mayusculas y minisculas 
                if grep -i "$busqueda" "$ARCHIVO"; then
                    echo "--------------------------------"
                else
                    echo "No se encontró ningún alumno con esos datos."
                fi
            fi
            ;;

        6)
            LOG="$EPNRO1/procesado.log"

            if [ -f "$LOG" ]; then
                echo "===== procesado.log ====="
                cat "$LOG"
            else
                echo "No existe el archivo de log."
            fi
            ;;

        7)
            echo "Saliendo..."
            ;;

        *)
            echo "Opción inválida."
            ;;
    esac

    echo
done
