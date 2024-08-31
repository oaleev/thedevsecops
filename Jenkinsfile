pipeline {
	agent none
  	stages {
		// stage('Checkout') {
		// 	steps {
        //  			git branch: 'lab', url: 'https://github.com/oaleev/thedevsecops.git'
		// 	}
    	// }
    	stage('Build Artifact - Maven') {
			agent {
				docker { 
				// Using the maven image from Docker Hub
				image 'maven:3.9-eclipse-temurin-21'
				// Mount the host's repository to cache the dependencies
				args '-v /root/.m2:/root/.m2'
				}
			}
			steps {
         			sh "mvn clean package -DskipTests=true"
			}
    	}
		stage('Unit Test Artifact - Maven') {
			agent {
				docker { 
				// Using the maven image from Docker Hub
				image 'maven:3.9-eclipse-temurin-21'
				// Mount the host's repository to cache the dependencies
				args '-v /root/.m2:/root/.m2'
				}
			}
			steps {
         			sh "mvn test"
			}
			post {
				always {
					junit 'target/surefire-reports/*.xml'
					jacoco execPattern: 'target/jacoco.exec'
				}
			}
    	}
		// stage('Build and Push Image') {
		// 	agent any
		// 	steps {
        //  			sh "mvn test"
		// 	}
    	// }
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
