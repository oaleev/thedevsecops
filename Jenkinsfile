pipeline {
	agent {
    	docker { 
		// Using the maven image from Docker Hub
		image 'maven:3.9-eclipse-temurin-21'
	       	// Mount the host's repository to cache the dependencies
		args '-v /root/.m2:/root/.m2'
	    }
	}
  	stages {
		stage('Checkout') {
			steps {
         			git branch: 'lab', url: 'https://github.com/oaleev/thedevsecops.git'
			}
    	}
    	stage('Build Artifact - Maven') {
			steps {
         			sh "mvn clean package -DskipTests=true"
			}
    	}
	}
	post {
		success {
			archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: false
		}
		failure {
			echo "Build Failed"
		}
	}
}
