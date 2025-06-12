# Stage 1: Build the JAR with Maven
FROM maven:3.8.7-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the Spring Boot app
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/gastrohub-0.0.1-SNAPSHOT.jar app.jar
RUN chmod +x app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
EXPOSE 8080
