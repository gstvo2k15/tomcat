pipeline {
    agent any

    options {
        preserveStashes()
    }

    environment {
        WORKSPACE_DIR = "${WORKSPACE}/src"
        TOMCAT_CONTAINER_NAME = "docker-tomcat-standalone-1"
        DEPLOY_PATH = "/usr/local/tomcat/webapps/uvc.war"
        DOCKER_IMAGE = "gstvo2k15/ultimate-cicd:latest"
        SONAR_URL = "https://sonarqubegolmolab.duckdns.org"
        GIT_REPO = "https://github.com/gstvo2k15/tomcat.git"
        WAR_TARGET = "${WORKSPACE}/docker/spring-boot-app/target/"
    }

    triggers {
        githubPush()
    }

    stages {
        
        stage('Checkout') {
            steps {
                echo "Cloning repository..."
                sh '''
                    if [ -d "${WORKSPACE}/.git" ]; then
                        echo "Fetching latest changes..."
                        cd ${WORKSPACE}
                        git reset --hard
                        git clean -fd
                        git checkout fix/deployment
                        git pull origin fix/deployment
                    else
                        echo "Cloning fresh repository..."
                        git clone --branch fix/deployment ${GIT_REPO} ${WORKSPACE}
                    fi
                '''
                sh "ls -l ${WORKSPACE}"
            }
        }

        stage('Build & Test') {
            steps {
                echo "Building the application and generating the WAR file..."
                sh '''
                    cd ${WORKSPACE_DIR}
                    mvn clean package
                    echo "Checking generated files..."
                    ls -l target/
                '''
            }
        }

        stage('Static Code Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
                    sh '''
                        cd ${WORKSPACE_DIR}
                        mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}
                    '''
                }
            }
        }

        stage('Prepare Artifact for Docker') {
            steps {
                script {
                    echo "Searching for the generated WAR file..."
                    def warFilePath = sh(script: "find ${WORKSPACE} -type f -name 'uvc.war' | head -n 1", returnStdout: true).trim()

                    if (!warFilePath) {
                        error "❌ ERROR: uvc.war not found in workspace!"
                    }

                    echo "✅ WAR found at: ${warFilePath}"
                    env.WAR_PATH = warFilePath

                    sh "mkdir -p ${WAR_TARGET}"
                    sh "cp '${env.WAR_PATH}' ${WAR_TARGET}"
                    echo "✅ WAR successfully copied to Docker build context!"
                    sh "ls -l ${WAR_TARGET}"
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh '''
                        cd ${WORKSPACE}/docker/spring-boot-app
                        docker build -t ${DOCKER_IMAGE} .
                    '''

                    echo "Logging into Docker Hub..."
                    withCredentials([usernamePassword(credentialsId: 'docker-cred', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh '''
                            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                            docker push ${DOCKER_IMAGE}
                        '''
                    }
                }
            }
        }

        stage("Trivy Scan") {
            steps {
                script {
	                sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image ${DOCKER_IMAGE} --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table')
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                script {
                    echo "Using previously found WAR file for deployment: ${env.WAR_PATH}"

                    sh "mkdir -p ${WORKSPACE}/docker/webapps/"
                    sh "cp '${env.WAR_PATH}' ${WORKSPACE}/docker/webapps/uvc.war"
                    echo "✅ WAR copied to Docker webapps folder!"

                    sh "ls -ltr ${WORKSPACE}/docker/webapps/"
                    sh "sudo cp -p ${WORKSPACE}/docker/webapps/uvc.war /root/tomcat/docker/webapps/"
                }
            }
        }

        stage('Restart Tomcat') {
            steps {
                echo "Restarting the Tomcat container..."
                sh "docker restart ${TOMCAT_CONTAINER_NAME}"
            }
        }

        stage('Update Deployment File') {
            steps {
                withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                    sh '''
                        echo "Current directory for debugging last step"
                        pwd

                        echo "Changing to workspace dir and reviewing content:"
                        cd ${WORKSPACE} && ls -ltr

                        git config user.email "gstvo2k15@gmail.com"
                        git config user.name "Gustavo Olmo"
                        sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" spring-boot-app-manifests/deployment.yml
                        
                        git add spring-boot-app-manifests/deployment.yml
                        
                        if git diff --cached --exit-code; then
                            echo "No changes to commit."
                        else
                            git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                            git push https://${GITHUB_TOKEN}@github.com/gstvo2k15/tomcat HEAD:fix/deployment
                        fi
                    '''
                }
            }
        }

        stage('Trigger ArgoCD Sync') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'argocd-admin-pass', variable: 'ARGOCD_PASSWORD')]) {
                        sh '''
                            argocd login argocdgolmolab.duckdns.org:443 \
                                --grpc-web \
                                --username admin \
                                --password "hQqK73bQ5b3i2knN" \
                                --insecure
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD Pipeline completed successfully."
        }
        failure {
        }
        always {
            cleanWs()
        }
    }
}
