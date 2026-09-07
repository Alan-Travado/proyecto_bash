# Proyecto Bash — Fase 1

Script con menú para crear un entorno, consolidar archivos de alumnos en background y consultar el resultado.

## Antes de empezar

En Linux o macOS (o Git Bash), desde la carpeta del repo:

```bash
chmod +x proyecto.sh consolidar.sh
export FILENAME=alumnos
```

`FILENAME` es una variable de entorno. El archivo consolidado se va a llamar `alumnos.txt`.

## Flujo completo

1. **Arrancar el menú**

   ```bash
   ./proyecto.sh
   ```

2. **Opción 1 — Crear entorno**

   Crea `~/EPNro1` con las carpetas `entrada`, `salida` y `procesado`, el log, y copia `consolidar.sh` adentro.

3. **Poner un archivo de prueba en entrada**

   En **otra terminal** (el menú se queda abierto):

   ```bash
   cat > ~/EPNro1/entrada/alumnos1.txt << 'EOF'
   122332 Juan Lopez jlopez@fi.uba.ar 8
   100998 Pedro Valdez pvaldez@fi.uba.ar 5
   89032 Carla Simone csimone@fi.uba.ar 7
   77542 Franco Lomba flomba@fi.uba.ar 10
   100223 Juana Pola jpola@fi.uba.ar 4
   122435 Lucia Fernandez lfernandez@fi.uba.ar 9
   EOF
   ```

   Formato de cada línea: `padrón  nombre  apellido  email  nota`

4. **Opción 2 — Correr proceso**

   Lanza `consolidar.sh` en background. Cada 5 segundos mira `entrada`.

5. **Qué debería pasar**

   A los pocos segundos:

   - el archivo **desaparece** de `~/EPNro1/entrada`
   - **aparece** en `~/EPNro1/procesado`
   - las líneas quedan pegadas al final de `~/EPNro1/salida/alumnos.txt`
   - se registra en `~/EPNro1/procesado.log`

6. **Consultar datos (con el proceso ya corriendo)**

   | Opción | Qué hace |
   |--------|----------|
   | 3 | Lista alumnos ordenados por padrón |
   | 4 | Muestra las 10 notas más altas |
   | 5 | Busca un alumno por padron , nombre , apellido o email. |
   | 6 | Muestra el log |

7. **Opción 7 — Salir**

   Cierra el menú. **No** mata a `consolidar.sh`; ese sigue en background.

8. **Borrar todo y matar el proceso**

   ```bash
   ./proyecto.sh -d
   ```

   Mata el proceso en background y borra `~/EPNro1`.

## Recordatorios

- `FILENAME` hay que exportarla **en cada terminal nueva** (`export FILENAME=alumnos`).
- Se pueden tirar varios `.txt` a `entrada`; todos se van concatenando al mismo `alumnos.txt`.
- Si el proceso ya está corriendo, la opción 2 no lo lanza de nuevo.
- Opción 7 ≠ `-d`. Salir del menú no limpia el entorno.
