pipeline {
	agent none
  	stages {
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
	}
	post {
		always {
			stage('Post Actions'){
				agent {
					docker { 
					image 'maven:3.9-eclipse-temurin-21'
					args '-v /root/.m2:/root/.m2'
					}
				}
			}
			steps{
				success {
					archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: false
				}
				failure {
					echo "Build Failed"
				}
			}
		}
	}
}
