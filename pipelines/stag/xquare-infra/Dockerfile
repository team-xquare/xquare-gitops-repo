
FROM gradle:8.8.0- AS build

COPY --chown=gradle:gradle . .



FROM openjdk:-jdk-slim

ENV TZ=Asia/Seoul

COPY --from=build  app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]

