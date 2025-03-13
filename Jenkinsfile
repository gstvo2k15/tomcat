pipeline {
    agent any

    environment {
        CONTAINER_NAME = 'docker-tomcat-standalone-1'
        DEPLOY_PATH = '/usr/local/tomcat/webapps/'
        WAR_NAME = 'uvc.war'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/gstvo2k15/tomcat.git'
            }
        }

        stage('Build & Package') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Deploy to Tomcat (Docker)') {
            steps {
                script {
                    // Remove previously version
                    sh "docker exec ${CONTAINER_NAME} rm -rf ${DEPLOY_PATH}/uvc"

                    // Copy newest war
                    sh "docker cp target/${WAR_NAME} ${CONTAINER_NAME}:${DEPLOY_PATH}"
                }
            }
        }

        stage('Validation') {
            steps {
                script {
                    def response = sh(script: "curl -s -o /dev/null -w '%{http_code}' https://tomcatgolmolab.duckdns.org/uvc", returnStdout: true).trim()
                    if (response != '200') {
                        error("Deployment failed! App is not responding on tomcatgolmolab.duckdns.org/uvc")
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}