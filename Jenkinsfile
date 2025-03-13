pipeline{
    agent any

    stages{
        stage ('Build'){
            steps{
                sh 'mvn clean package'
            }
            post{
                success{
                    echo "Archiving the Artifacts"
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
        stage ('Deploy to Tomcat server'){
            steps{
                deploy adapters: [tomcat9(credentialsId: '58cc-asdasd0', path: '', url: 'https://tomcatgolmolab.duckdns.org')]
            }
        }
    }
}