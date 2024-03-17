# ----------------------------------
# IW4M Admin Dockerfile
# Environment: Ubuntu 20.04
# Minimum Panel Version: 1.0.0
# ----------------------------------
FROM ubuntu:focal

LABEL maintainer="GaryCraft@SpaceProject <garycraft@our-space.xyz>"

# Instalar dependencias
RUN apt update && apt install -y wget unzip

# Descargar e instalar .NET SDK 6.0
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y apt-transport-https \
    && apt-get update \
    && apt-get install -y dotnet-sdk-6.0

# Verificar la instalación de .NET
RUN dotnet --version

# Descargar IW4M Admin
RUN mkdir /home/container/iw4madmin \
    && cd /home/container/iw4madmin \
    && wget https://github.com/RaidMax/IW4M-Admin/releases/download/v1.5.1/IW4MAdmin.zip \
    && unzip IW4MAdmin.zip \
    && rm IW4MAdmin.zip

# Crear un usuario no privilegiado para ejecutar IW4M Admin
RUN adduser --disabled-password --gecos "" --home /home/container container \
    && chown -R container:container /home/container/iw4madmin

USER container
ENV USER=container HOME=/home/container

# Establecer el directorio de trabajo y copiar el script de inicio
WORKDIR /home/container/iw4madmin
COPY start.sh /home/container/iw4madmin/start.sh

# Establecer permisos para el script de inicio
RUN chmod +x /home/container/iw4madmin/start.sh

# Ejecutar el script de inicio
CMD ["/bin/bash", "/home/container/iw4madmin/start.sh"]
