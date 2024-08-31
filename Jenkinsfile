pipeline {
   agent {
        docker { image 'maven:3.9.9-eclipse-temurin-21-alpine' }
    }
  stages {
     stage('Build Artifact - Maven') {
	steps {
         	sh "mvn clean package -DskipTests=true"
         	archive 'target/*.jar'
		}
    	}
	}
}
