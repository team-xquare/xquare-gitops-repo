
FROM openjdk:21-jdk-slim AS build
COPY . .

RUN chmod +x gradlew


RUN gradle build


FROM openjdk:21-jdk-slim

# Set the time zone
ENV TZ=Asia/Seoul

COPY --from=build //application-infrastructure/build/libs/application-infrastructure-0.0.1-SNAPSHOT.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]

