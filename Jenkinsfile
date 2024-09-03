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
					image 'manrala/all_in_one:v1'
				}
			}
			steps {
         			sh "mvn clean package -DskipTests=true"
					archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: false
					stash includes: 'target/*.jar', name: 'buildJar'
			}
    	}
		stage('Unit Test Artifact - Maven') {
			agent {
				docker {
					image 'manrala/all_in_one:v1'
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
		stage('Mutation - Test') {
			agent {
				docker {
					image 'manrala/all_in_one:v1'
				}
			}
			steps {
         			sh "mvn org.pitest:pitest-maven:mutationCoverage"
			}
			post {
				always {
					pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
				}
			}
    	}
		stage('Build the Image and Push to repo...') {
			steps {
				unstash 'buildJar'
         		withDockerRegistry(credentialsId: 'docker', url: 'https://index.docker.io/v1/') {
					sh """
					ls -ls
    				docker build -t ${DOCKER_REPO}:""$GIT_COMMIT"" .
					docker push ${DOCKER_REPO}:""$GIT_COMMIT""
					"""
				}
			}
    	}
		stage ('Clone the Repo'){
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
							cd config-repo
							echo "-------------"
							sed -i 's#image: ${DOCKER_REPO}:.*#image: ${DOCKER_REPO}:${GIT_COMMIT}#g' deployment.yaml
							echo "-------------"
						"""
					}
				}
			}
		stage('Commit and Push') {
			steps {
				withCredentials([gitUsernamePassword(credentialsId: 'github', gitToolName: 'Default')]) {
					script {
						sh """
							echo "Pushing the changes"
							cd config-repo
							git config user.name "oaleev"
							git config user.email "mina@mannamnaveen.com"
							git add deployment.yaml
							git commit -m "Updated the image tag to  ${DOCKER_REPO}:${GIT_COMMIT}"
							git push https://github.com/oaleev/thedevsecops_config.git lab
						"""
					}
				}
			}
		}
	}
	post {
		always {
			cleanWs()
		}
	}
}
