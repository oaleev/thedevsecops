FROM openjdk:21-slim-buster

ARG JAR_FILE="target/*.jar"

RUN groupadd --system pipeline && \
  useradd --no-log-init --system --gid pipeline k8s-pipeline

COPY ${JAR_FILE} /home/k8s-pipeline/app.jar

USER k8s-pipeline

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/home/k8s-pipeline/app.jar"]
