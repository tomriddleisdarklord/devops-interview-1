

pipeline {
    parameters { 
        string(name: 'BRANCH_TAG', defaultValue: 'main', description: 'Branch or tag to deploy') 
        choice(name: 'ENV_K8s', choices: ['dev', 'test', 'production'], description: 'Environment in Kubernetes')
    }
    agent any

    stages {

        stage('Get deployment files') {
            steps {
                sh "bash bootstrapper.sh"
            }
        }

    }
}
