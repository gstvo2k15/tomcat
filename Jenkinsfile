pipeline {
    agent any

    options {
        preserveStashes()  // Evita que Jenkins borre archivos entre etapas
    }

    environment {
        TOMCAT_CONTAINER_NAME = "docker-tomcat-standalone-1"
        DEPLOY_PATH = "/usr/local/tomcat/webapps/uvc.war"
    }

    triggers {
        githubPush()  // Se activa cuando hay un push en GitHub
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/gstvo2k15/tomcat.git'
            }
        }

        stage('Debugging') {
            steps {
                sh 'pwd'
                sh 'ls -ltrR'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'cd src && mvn clean package'
            }
        }

        stage('Move WAR to docker/webapps') {
            steps {
                sh '''
                echo "DEBUG: Searching WAR generated in current workspace..."

                WAR_PATH=$(find $WORKSPACE -type f -name "uvc.war" | head -n 1)

                if [ -z "$WAR_PATH" ]
                    then
                        echo "ERROR: No WAR was found in current workspace."
                        exit 1
                fi

                echo "DEBUG: WAR found in: $WAR_PATH"

                mkdir -p $WORKSPACE/docker/webapps/
                mv "$WAR_PATH" $WORKSPACE/docker/webapps/uvc.war

                echo "DEBUG: Content of docker/webapps:"
                ls -ltr $WORKSPACE/docker/webapps/
                '''
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                script {
                    sh """
                    docker cp docker/webapps/uvc.war ${TOMCAT_CONTAINER_NAME}:${DEPLOY_PATH}
                    """
                }
            }
        }

        stage('Restart Tomcat') {
            steps {
                script {
                    sh "docker restart ${TOMCAT_CONTAINER_NAME}"
                }
            }
        }
    }
}
