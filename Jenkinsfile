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
                sh 'mv $WORKSPACE/src/target/uvc.war $WORKSPACE/docker/webapps/uvc.war'
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
