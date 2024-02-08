FROM maven:3.5.4-jdk-8-alpine AS build

WORKDIR /code

COPY crud-app/pom.xml /code/pom.xml

# Adding source, compile and package into a fat jar
COPY ["crud-app/src/main", "/code/src/main"]
RUN ["mvn", "clean", "package"]

FROM openjdk:8-jre-alpine3.9

COPY --from=build /code/target/spring-boot-rest-1.0-SNAPSHOT.jar /app.jar
EXPOSE 8080
ENV MYSQL_DATABASE=""
CMD ["java", "-jar", "/app.jar"]

