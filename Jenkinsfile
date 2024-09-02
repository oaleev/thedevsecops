pipeline {
	agent any
	environment {
		DOCKER_REPO = 'manrala/numeric-app'
		CONFIG_REPO_URL = 'https://github.com/oaleev/thedevsecops_config.git'
		CONFIG_ORG = 'oaleev/thedevsecops_config.git'
		CONFIG_FOLDER = "${env.WORKSPACE}/config"
	}
  	stages {
    	stage('Build Artifact - Maven') {
			agent {
				docker { 
				// Using the maven image from Docker Hub
				image 'maven:3.9-eclipse-temurin-21'
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
		stage('Build the Image and Push to repo...') {
			steps {
				script {
					def jarfile = sh(script: 'ls target/*.jar', returnStdout: true).trim()
					sh "cp ${jarfile} ."
				}
         		withDockerRegistry(credentialsId: 'docker', url: 'https://index.docker.io/v1/') {
    				sh 'docker build -t ${DOCKER_REPO}:""$GIT_COMMIT"" .'
					sh 'docker push ${DOCKER_REPO}:""$GIT_COMMIT""'
				}
			}
    	}
		stage ('Clone the Repo'){
			// agent {
			// 	docker {
			// 		image 'manrala/all_in_one:v1'
			// 	}
			// }
			steps {
				script {
					sh "rm -rf config-repo"
					sh "git clone ${CONFIG_REPO_URL} config-repo"
					dir('config-repo'){
						sh "git fetch -a"
						sh "git switch lab"
					}
				}
			}
		}
		stage('Update the Deployment file') {
			steps {
				script {
						sh """
							ls -la
							cd config-repo
							ls -la
							cat deployment.yaml
							echo "-------------"
							sed -i 's#image: ${DOCKER_REPO}:.*#image: ${DOCKER_REPO}:${GIT_COMMIT}#g' deployment.yaml
							echo "-------------"
							cat deployment.yaml
						"""
					}
				}
			}
		stage('Commit and Push') {
			steps {
				withCredentials([gitUsernamePassword(credentialsId: 'github', gitToolName: 'Default', variable: 'GIT_TOKEN')]) {
					script {
						sh """
							echo "Pushing the changes"
							cd config-repo
							cat deployment.yaml
							git config user.name "oaleev"
							git config user.email "mina@mannamnaveen.com"
							git add deployment.yaml
							git commit -m "Updated the image tag to  ${DOCKER_REPO}:${GIT_COMMIT}"
							git push https://${GIT_TOKEN}@github.com/${CONFIG_ORG} lab

						"""
					}
				}
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
// }
