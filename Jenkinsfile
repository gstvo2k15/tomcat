pipeline {
    agent any

    options {
        preserveStashes()
    }

    environment {
        WORKSPACE_DIR = "${WORKSPACE}/src"
        TOMCAT_CONTAINER_NAME = "docker-tomcat-standalone-1"
        DEPLOY_PATH = "/usr/local/tomcat/webapps/uvc.war"
        DOCKER_IMAGE = "tomcat/ultimate-cicd:${BUILD_NUMBER}"
        SONAR_URL = "https://sonarqubegolmolab.duckdns.org"
        GIT_REPO = "https://github.com/gstvo2k15/tomcat.git"
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
                echo "Moving the WAR file to the Docker build context..."
                sh '''
                    mkdir -p ${WORKSPACE_DIR}/docker/spring-boot-app/target/
                    cp ${WORKSPACE_DIR}/target/uvc.war ${WORKSPACE_DIR}/docker/spring-boot-app/target/
                    ls -l ${WORKSPACE_DIR}/docker/spring-boot-app/target/
                '''
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    echo "Building Docker image with the embedded WAR file..."
                    sh '''
                        cd ${WORKSPACE}/docker/spring-boot-app
                        docker build -t ${DOCKER_IMAGE} .
                    '''

                    echo "Pushing image to Docker Hub..."
                    docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }

        // ======================================
        // 🔴 CONTINUOUS DELIVERY (CD)
        // ======================================

        stage('Deploy to Tomcat') {
            steps {
                echo "Copying the WAR file to the Tomcat server..."
                sh '''
                    mkdir -p ${WORKSPACE_DIR}/docker/webapps/
                    cp ${WORKSPACE_DIR}/target/uvc.war ${WORKSPACE_DIR}/docker/webapps/

                    echo "Contents of docker/webapps:"
                    ls -ltr ${WORKSPACE_DIR}/docker/webapps/

                    echo "Copying WAR to Tomcat..."
                    sudo cp -p ${WORKSPACE_DIR}/docker/webapps/uvc.war /root/tomcat/docker/webapps/
                '''
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
