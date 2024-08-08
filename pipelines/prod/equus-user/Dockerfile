
FROM openjdk:17-jdk-slim AS build
COPY . .

RUN chmod +x gradlew


RUN ./gradlew build -x test


FROM openjdk:17-jdk-slim

# Set the time zone
ENV TZ=Asia/Seoul

COPY --from=build build/libs/Equus-User-0.0.0.jar app.jar

ENTRYPOINT ["java", "-jar", "/app.jar"]

