FROM ubuntu:20.04

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Añadir la clave GPG oficial de Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Añadir el repositorio de Docker
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Instalar Docker
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Configurar variables de entorno para MySQL
ENV MYSQL_ROOT_PASSWORD=1234
ENV MYSQL_DATABASE=menucom_dev
ENV MYSQL_USER=menucom
ENV MYSQL_PASSWORD=1234

# Exponer el puerto 3306
EXPOSE 3306

# Comando para iniciar Docker y MySQL
CMD service docker start && \
    docker run -d --name mysqldb -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -p 3306:3306 -v /var/lib/mysql --network default mysql:5.7 && \
    tail -f /dev/null
