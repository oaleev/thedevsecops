pipeline {
	agent {
    	docker { 
			// Using the maven image from Docker Hub
			image 'maven:3.9.9-eclipse-temurin-21-alpine'
	       	// Mount the host's repository to cache the dependencies
			args '-v /root/.m2:/root/.m2'
	    }
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
