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
        WAR_TARGET = "${WORKSPACE_DIR}/docker/spring-boot-app/target/"
        WAR_PATH = ""
    }

    triggers {
        githubPush()
    }

    stages {

        // ======================================
        // 🔵 CONTINUOUS INTEGRATION (CI)
        // ======================================

        stage('Checkout') {
            steps {
                echo "Cloning repository into ${WORKSPACE_DIR}..."
                sh '''
                    if [ -d "${WORKSPACE}/.git" ]
                      then
                          echo "Repository already exists, fetching latest changes..."
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
                sh "ls -l ${WORKSPACE_DIR}"
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

                    if (!warFilePath || warFilePath == "null") {
                        error "❌ ERROR: uvc.war not found in workspace! Check if the file exists with 'ls -lR ${WORKSPACE}/target/'"
                    }

                    echo "✅ WAR found at: ${warFilePath}"

                    // Store the WAR path globally
                    env.WAR_PATH = warFilePath

                    // Ensure the target directory exists
                    sh "mkdir -p ${WORKSPACE}/docker/spring-boot-app/target/"

                    // Copy the WAR to the Docker build context
                    sh "cp '${env.WAR_PATH}' ${WORKSPACE}/docker/spring-boot-app/target/"

                    echo "✅ WAR successfully copied to Docker build context!"
                    sh "ls -l ${WORKSPACE}/docker/spring-boot-app/target/"
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
                            echo "Pushing image..."
                            docker push ${DOCKER_IMAGE}
                        '''
                    }
                }
            }
        }

        // ======================================
        // 🔴 CONTINUOUS DELIVERY (CD)
        // ======================================

        stage('Deploy to Tomcat') {
            steps {
                script {
                    echo "Using previously found WAR file for deployment: ${env.WAR_PATH}"

                    // Ensure the target directory exists
                    sh "mkdir -p ${WORKSPACE}/docker/webapps/"

                    // Move the WAR to Tomcat's webapps directory
                    sh "mv '${env.WAR_PATH}' ${WORKSPACE}/docker/webapps/uvc.war"

                    echo "✅ WAR moved to Docker webapps folder!"
                    sh "ls -ltr ${WORKSPACE}/docker/webapps/"

                    echo "Copying WAR to Tomcat..."
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
                        cd ${WORKSPACE_DIR}
                        git config user.email "gstvo2k15@gmail.com"
                        git config user.name "Gustavo Olmo"

                        # Update the YAML file with the new BUILD_NUMBER
                        sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" spring-boot-app-manifests/deployment.yml
                        
                        git add .
                        git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                        git push https://${GITHUB_TOKEN}@github.com/gstvo2k15/tomcat HEAD:main
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD Pipeline completed successfully."
        }
        failure {
            echo "❌ CI/CD Pipeline failed. Check the logs."
        }
        always {
            cleanWs()
        }
    }
}
