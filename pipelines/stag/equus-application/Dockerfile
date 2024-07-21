
FROM gradle:latest AS build

COPY --chown=gradle:gradle . .


RUN ./gradlew build -x test


FROM openjdk:21-jdk-slim

ENV TZ=Asia/Seoul

COPY --from=build /application-infrastructure/build/libs/application-infrastructure-0.0.1-SNAPSHOT.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]

