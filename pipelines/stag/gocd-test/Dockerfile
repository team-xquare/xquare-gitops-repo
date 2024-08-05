
FROM openjdk:17-jdk-slim AS build
COPY . .

RUN chmod +x gradlew



FROM openjdk:17-jdk-slim

# Set the time zone
ENV TZ=Asia/Seoul

COPY --from=build /build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]

