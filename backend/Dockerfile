# Usar una imagen base oficial de OpenJDK
FROM openjdk:17-jdk-slim

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo JAR específico desde el directorio target al contenedor
COPY target/gastrohub-0.0.1-SNAPSHOT.jar app.jar

# Asegurarse de que el archivo JAR tenga permisos adecuados
RUN chmod +x app.jar

# Especificar el comando para ejecutar el archivo JAR
ENTRYPOINT ["java", "-jar", "app.jar"]

# Exponer el puerto en el que corre la aplicación (por defecto Spring Boot usa 8080)
EXPOSE 8080