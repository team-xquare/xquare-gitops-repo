
FROM gradle:8.8.0 AS build

COPY --chown=gradle:gradle . .


RUN ./gradlew build -x test


FROM openjdk:17-jdk-slim

ENV TZ=Asia/Seoul

COPY --from=build ./build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]

