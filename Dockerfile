# --------------------- Build Stage ------------------------

FROM maven:3.9.5-eclipse-temurin-8 AS build

WORKDIR /app

COPY pom.xml .

RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests

# --------------------- Runtime Stage --------------------

FROM amazoncorretto:8-alpine3.17-jre

WORKDIR /usr/app

COPY --from=build /app/target/java-maven-app-*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", -"jar", jar.app]