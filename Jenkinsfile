pipeline {
	agent any
	// agent {docker 'manrala/all_in_one:v1'}
	environment {
		DOCKER_REPO = 'manrala/numeric-app'
		CONFIG_REPO = 'https://github.com/oaleev/thedevsecops_config.git'
	}
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
				script {
					sh "rm -rf config"
					sh "git clone ${CONFIG_REPO} config"
					sh "pwd"
					sh "cd config"
					sh "ls -l"
					sh "sed -i 's#image: ${DOCKER_REPO}:.*#image: ${DOCKER_REPO}:${GIT_COMMIT}#g' deployment.yaml"
					sh"""
						git config user.email "mina@naveenmannam.com"
						git config user.name "oaleev"
						git add deployment.yaml
						git commit -m "Update the image tag to ${GIT_COMMIT}"
						git push origin lab
					"""
				}
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
