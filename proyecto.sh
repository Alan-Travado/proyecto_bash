#!/bin/bash

# Directorio donde esta el script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Directorio del entorno
EPNRO1="$HOME/EPNro1"

# Archivo donde se guarda el pid del proceso
PIDFILE="$EPNRO1/consolidar.pid"

# Verifica que FILENAME este definica
if [ -z "$FILENAME" ]; then
    echo "ERROR: La variable de ambiente FILENAME no esta definida."
    echo "Ejemplo:"
    echo "export FILENAME=alumnos"
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

    read -p "Ingrese una opciom: " opcion

    case $opcion in

        1)
            mkdir -p "$EPNRO1"/{entrada,salida,procesado}

            touch "$EPNRO1/procesado.log"

            echo "Entorno creado correctamente."
            ;;

         2)
           
            if [ ! -d "$EPNRO1" ]; then
                echo "ERROR: Primero tenes que crear el entorno (Opcion 1)."
                continue
            fi
            
           
            if pgrep -f "consolidar.sh" > /dev/null; then
                echo "El proceso ya se esta ejecutando...."
                continue
            fi

            "$SCRIPT_DIR/consolidar.sh" &
            echo "Proceso ejecutandose en segundo plano con PID: $!"
            ;;

        3)
            ARCHIVO="$EPNRO1/salida/${FILENAME}.txt"

            if [ -f "$ARCHIVO" ]; then
                echo "Listado de alumnos ordenado por numeor de padron:"
                sort -n -k1,1 "$ARCHIVO"
            else
                echo "No existe el archivo ${FILENAME}.txt"
            fi
            ;;

        4)
            ARCHIVO="$EPNRO1/salida/${FILENAME}.txt"

            if [ -f "$ARCHIVO" ]; then
                echo "10 notas mas altas:"
                sort -k5,5nr "$ARCHIVO" | head -10
            else
                echo "No existe el archivo ${FILENAME}.txt"
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
            echo "Buscar alumno"
            ;;

        6)
            echo "Visualizar log"
            ;;

        7)
            echo "Saliendo..."
            ;;

        *)
            echo "Opción invalida."
            ;;

    esac

    echo
done
