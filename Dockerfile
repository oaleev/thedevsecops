FROM openjdk:21-slim-buster
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN groupadd --system pipeline && \
  useradd -no-log-init --system --gid pipeline k8s-pipeline
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
