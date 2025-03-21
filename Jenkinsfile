pipeline {
    agent any

    options {
        preserveStashes()
    }

    environment {
        WORKSPACE_DIR = "${WORKSPACE}/src"
        TOMCAT_CONTAINER_NAME = "docker-tomcat-standalone-1"
        DEPLOY_PATH = "/usr/local/tomcat/webapps/uvc.war"
        DOCKER_IMAGE = "gstvo2k15/ultimate-cicd:v1.0.0"
        SONAR_URL = "https://sonarqubegolmolab.duckdns.org"
        GIT_REPO = "https://github.com/gstvo2k15/tomcat.git"
        WAR_TARGET = "${WORKSPACE}/docker/spring-boot-app/target/"
        MINIO_URL = "https://miniogolmolab.duckdns.org"
        MINIO_BUCKET = "beta"
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

        stage('Security Scan of Dockerfile - Checkov') {
            steps {
                sh '''
                docker run --rm -v $(pwd):/docker bridgecrew/checkov \
                --skip-check CKV_K8S_43 \
                -d /docker
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
                    } else {
                        echo "✅ WAR found at: ${warFilePath}"
                        env.WAR_PATH = warFilePath
                    }

                    def warFile = env.WAR_PATH

                    if (fileExists(warFile)) {
                        withCredentials([usernamePassword(credentialsId: 'nexus-cred', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                            sh '''
                                mkdir -p "$WAR_TARGET"
                                cp "$WAR_PATH" "$WAR_TARGET"
                                echo -e "\n✅ WAR successfully copied to Docker build context!"
                                ls -l "$WAR_TARGET"

                                echo -e "\nUploading WAR file to Nexus..."
                                curl -u "$NEXUS_USER:$NEXUS_PASS" --upload-file "$WAR_PATH" \
                                "https://nexusgolmolab.duckdns.org/repository/maven-releases/uvc-${BUILD_NUMBER}.war"

                                echo -e "\n✅ WAR file successfully uploaded to Nexus!"
                            '''
                        }
                    } else {
                        error "WAR file not found! Build might have failed."
                    }
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
                                --password "$ARGOCD_PASSWORD" \
                                --insecure
                        '''
                    }
                }
            }
        }

        stage('Deploy WAR to Kubernetes') {
            steps {
                script {
                    echo "Updating Kubernetes Deployment to use the latest WAR from Nexus..."

                    withCredentials([string(credentialsId: 'k8s-token', variable: 'K8S_TOKEN')]) {
                        sh '''
                            kubectl config set-credentials jenkins-sa --token=$K8S_TOKEN
                            kubectl set env deployment/spring-boot-app -n tomcatk8s BUILD_NUMBER="${BUILD_NUMBER}"
                            kubectl rollout restart deployment/spring-boot-app -n tomcatk8s
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            script {
                withCredentials([string(credentialsId: 'email_notifier', variable: 'EMAIL_TO')]) {
                    def recipient = EMAIL_TO
                    echo "✅ CI/CD Pipeline completed successfully."
                    emailext body: '''${SCRIPT, template="groovy-html.template"}''', 
                             subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Successful", 
                             mimeType: 'text/html', to: recipient
                }
            }
        }
        failure {
            script {
                withCredentials([string(credentialsId: 'email_notifier', variable: 'EMAIL_TO')]) {
                    def recipient = EMAIL_TO
                    echo "❌ CI/CD Pipeline failed. Check the logs."
                    emailext body: '''${SCRIPT, template="groovy-html.template"}''', 
                             subject: "${env.JOB_NAME} - Build # ${env.BUILD_NUMBER} - Failed", 
                             mimeType: 'text/html', to: recipient
                }
            }
        }
        always {
            cleanWs()
        }
    }
}