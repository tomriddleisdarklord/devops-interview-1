

pipeline {
    agent any

    stages {

        stage('Get deployment files') {
            steps {
                sh "bash bootstrapper.sh"
            }
        }

    }
}
