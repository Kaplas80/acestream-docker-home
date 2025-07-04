# Acestream Dockerizado

[Read documentation in English](README.md)

Este proyecto despliega Acestream dentro de un contenedor Docker usando Ubuntu 22.04 y Python 3.10 para garantizar la
compatibilidad.

Acestream es una plataforma para streaming en vivo a través de redes peer-to-peer. Dockerizar Acestream simplifica su
configuración y proporciona entornos aislados.

## Requisitos Previos

1. **Instalación de Docker**: Asegúrate de que Docker Desktop esté instalado en tu sistema.
   - [Página de productos de Docker](https://www.docker.com/products/docker-desktop)
   - [Documentación Oficial](https://docs.docker.com/get-docker/)

## Instalación Automática y Ejecución con Scripts de Configuración (Windows)

### Selección de Idioma
Elige el script de configuración según tu idioma preferido:

- **🇺🇸 English**: Usa `SetupAcestream.bat`
- **🇪🇸 Español**: Usa `SetupAcestream_es.bat`

Ambos scripts tienen **funcionalidad idéntica** y solo difieren en el idioma de la interfaz.

### Descripción del Script
Los scripts de configuración automatizan las siguientes tareas:

   - Verificación de la instalación y estado operativo de Docker.
   - Descarga de la imagen Docker más reciente de Acestream.
   - Configuración del contenedor con asignación dinámica de puertos (para evitar conflictos).
   - Actualización del archivo `docker-compose.yml` de forma dinámica según los puertos disponibles.
   - Inicio del contenedor Acestream y apertura de la interfaz web.

### Uso
1. **Elige tu idioma**: Descarga `SetupAcestream.bat` (inglés) o `SetupAcestream_es.bat` (español)
2. **Ejecutar como Administrador**: Haz clic derecho en el script elegido y selecciona "Ejecutar como administrador"
3. **Seguir las instrucciones**: El script te guiará a través del proceso de configuración

> **Nota:** El script garantiza que se utilice la imagen Docker más reciente de Acestream y que la gestión del
> contenedor se maneje de manera eficiente.

## Construir la Imagen

Este proyecto utiliza la imagen base **ubuntu:22.04**. Debes clonar el proyecto completo primero. Luego, para construir
la imagen, utiliza:

```bash
docker build --no-cache -t docker-acestream .
```

## Ejecutar el Contenedor

Para iniciar un contenedor y ejecutar Acestream con asignación dinámica de puertos:

```bash
docker run --name docker-acestream -d -p 6878:6878 -e INTERNAL_IP=127.0.0.1 --restart unless-stopped docker-acestream
```

El script `SetupAcestream.bat` maneja la asignación dinámica de puertos para evitar conflictos al ejecutar múltiples
instancias.

## Docker Compose

1. **Iniciar el Contenedor**: Usa `docker-compose` para iniciar el contenedor:

   ```bash
   docker-compose up -d
    ```

2. **Actualizar la Imagen**: Para obtener la última versión de la imagen:

   ```bash
   docker-compose pull && docker-compose up -d
    ```

## Acceder a la Interfaz Web

Accede a Acestream a través de la interfaz web. El script `SetupAcestream.bat` abre automáticamente la URL correcta
basada en el puerto asignado:

```plaintext
http://<INTERNAL_IP>:<PORT>/webui/player/
```

Puedes cargar enlaces de Acestream directamente en el campo de entrada proporcionado.

## Verificar la Salud del Contenedor

Verifica el estado de salud del contenedor de Acestream:

```bash
docker inspect --format='{{json .State.Health}}' docker-acestream
```

Alternativamente, utiliza la interfaz web:

```plaintext
http://<INTERNAL_IP>:<PORT>/webui/api/service?method=get_version
```

## Personalización

### Asignación Dinámica de Puertos

El proyecto incluye la asignación dinámica de puertos tanto para HTTP como para HTTPS para evitar conflictos al ejecutar
múltiples instancias. Esto se maneja en el script `SetupAcestream.bat`.

### Configuración de la Interfaz Web

El archivo `player.html` se actualiza dinámicamente con la dirección IP y el puerto correctos durante el proceso de
inicio del contenedor. Esto asegura que la interfaz web apunte a la instancia correcta del motor de Acestream.

## Variables de Entorno

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| INTERNAL_IP | Dirección IP que usan el reproductor y el motor como endpoint anunciado. | 127.0.0.1 |
| HTTP_PORT | Puerto expuesto para tráfico HTTP dentro del contenedor. | 6878 |
| HTTPS_PORT | Puerto expuesto para tráfico HTTPS dentro del contenedor. | 6879 |

## Características Principales

- Scripts de instalación en Windows de un solo clic con descarga automática de la imagen Docker y asignación dinámica de puertos.
- `acestream.conf` preconfigurado con límites de concurrencia y caché adecuados para producción.
- Script de arranque reforzado (`entrypoint.sh`) que valida variables de entorno y muestra diagnósticos detallados.
- Parche automático de `player.html` para que la interfaz web siempre apunte a la IP y puerto correctos.
- Soporte multi-instancia: puedes lanzar varios contenedores simultáneamente sin conflictos de puertos.
- Construcciones offline gracias al archivo `resources/acestream.tar.gz` incluido (no se requieren descargas externas).
- **Detección automática de conflictos de puertos**: si el puerto por defecto `6878` está ocupado (por ejemplo, por Acestream Player de escritorio), el script de Windows asigna el siguiente puerto par libre.
- Flag opcional `--auto-clean`: tras descargar una nueva imagen, el script puede eliminar de forma segura las imágenes antiguas de Acestream para mantener limpio tu host Docker.

## Solución de Problemas y Consejos

- Asegúrate de que los puertos seleccionados por el script de Windows estén **abiertos en tu firewall**.
- Si aparece el mensaje "puerto ya en uso", el script cambiará automáticamente al siguiente puerto libre — verifica el puerto final mostrado en consola.
- Para uso en Linux/macOS establece `INTERNAL_IP`, `HTTP_PORT` y `HTTPS_PORT` al ejecutar `docker run` o `docker-compose`.
- Utiliza `--auto-clean` con el script para eliminar automáticamente imágenes obsoletas de Acestream tras una actualización (o responde *S* cuando se solicite).
- Visualiza los registros en tiempo real con `docker logs -f <nombre_contenedor>` para diagnosticar problemas del motor.
- El motor escribe información de depuración adicional cuando la opción `--log-debug` está habilitada en `acestream.conf`.

## Aviso Legal

Este repositorio solo distribuye scripts de automatización. El binario de Acestream se proporciona para **uso personal, educativo o de investigación**.
Eres el único responsable de garantizar que tu uso cumpla con todas las leyes y regulaciones aplicables.

## Contribuciones

Agradecemos las contribuciones. Haz un fork, realiza cambios y envía un pull request para revisión.

## Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.
