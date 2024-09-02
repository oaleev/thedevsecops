# FROM openjdk:21-slim-buster
# EXPOSE 8080
# ARG JAR_FILE=target/*.jar
# RUN groupadd --system pipeline && \
#   useradd -no-log-init --system --gid pipeline k8s-pipeline
# COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
# USER k8s-pipeline
# ADD ${JAR_FILE} app.jar
# ENTRYPOINT ["java","-jar","/app.jar"]


FROM openjdk:21-slim-buster

# Update the packages
RUN apt-get update && apt-get install -y curl wget git vim --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

# Add the user
RUN groupadd --system pipeline && \
  useradd --no-log-init --system --gid pipeline k8s-pipeline

WORKDIR /app

COPY target/*.jar app.jar

USER k8s-pipeline

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
