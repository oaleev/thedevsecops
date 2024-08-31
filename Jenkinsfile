pipeline {
  agent none

  stages {

     stage('Build Artifact - Maven') {
	agent {
        	docker { image 'maven:3.9.9-eclipse-temurin-21-alpine' }
        }
	steps {
         	sh "mvn clean package -DskipTests=true"
         	archive 'target/*.jar'
	}
    	}
	}
}
