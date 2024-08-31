pipeline {
	agent any
	// agent {docker 'manrala/all_in_one:v1'}
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
					archive 'target/*.jar'
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
		stage('Build the Image and Push') {
			steps {
         		withDockerRegistry(credentialsId: 'DOCKER', url: 'https://index.docker.io/v1/') {
    				sh 'docker build -t manrala/numeric-app:""$GIT_COMMIT"" .'
					sh 'docker push manrala/numeric-app:""$GIT_COMMIT""'
				}
			}
    	}
		stage('Update the image tag') {
			steps {
         		git branch: 'lab', credentialsId: 'GITHUB', url: 'https://github.com/oaleev/thedevsecops_config.git'
				sh "sed -i 's#replace#manrala/numeric-app:${GIT_COMMIT}#g' deployment.yaml"
				git commit -am "Updated the tag with ${GIT_COMMINT}"
				git push -origin lab
			}
    	}
	}
	// post {
	// 	always {
	// 		script {
	// 			docker.image('maven:3.9-eclipse-temurin-21').inside('-v /root/.m2:/root/.m2') {
	// 				sh 'mv target/*.jar .'
	// 				archiveArtifacts artifacts: '*.jar', allowEmptyArchive: false
	// 				echo "Post build actions completed."
	// 			}
	// 		}
	// 	}
	// }
}
