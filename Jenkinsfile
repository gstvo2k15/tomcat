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
        sh 'echo passed'
        git branch: 'main', url: 'https://github.com/gstvo2k15/tomcat.git'
      }
    }
    stage('Build and Test') {
      steps {
        sh 'ls -ltr'
        // build the project and create a WAR file
        sh 'cd src && mvn clean package'
      }
    }
    stage('Static Code Analysis') {
      environment {
        SONAR_URL = "https://sonarqubegolmolab.duckdns.org"
      }
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
          sh 'cd src && mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
      }
    }
    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "tomcat/ultimate-cicd:${BUILD_NUMBER}"
        // DOCKERFILE_LOCATION = "docker/spring-boot-app/Dockerfile"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
            sh 'cd docker/spring-boot-app && docker build -t ${DOCKER_IMAGE} .'
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
                dockerImage.push()
            }
        }
      }
    }

        stage('Deploy to Tomcat') {
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

                echo "FINISH: Copy to Tomcat folder for webapps:"
                sudo cp -p $WORKSPACE/docker/webapps/uvc.war /root/tomcat/docker/webapps/
                '''
            }
        }

        stage('Restart Tomcat') {
            steps {
                script {
                    sh "docker restart ${TOMCAT_CONTAINER_NAME}"
                }
            }
        }

    stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "tomcat"
            GIT_USER_NAME = "gstvo2k15"
        }
        steps {
            withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                sh '''
                    git config user.email "gstvo2k15@gmail.com"
                    git config user.name "Gustavo Olmo"
                    BUILD_NUMBER=${BUILD_NUMBER}
                    sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" tomcat/spring-boot-app-manifests/deployment.yml
                    git add .
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                '''
            }
        }
    }
  }
}