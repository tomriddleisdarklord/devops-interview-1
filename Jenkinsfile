def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

pipeline {
    parameters { 
        string(name: 'BRANCH_TAG', defaultValue: 'dev', description: 'Branch or tag to deploy') 
        choice(name: 'ENV_K8s', choices: ['no-deploy', 'dev', 'test', 'refactor', 'demo', 'prod'], description: 'Environment in Kubernetes')
    }
    agent {
        node {
            label 'docker'
        }
    }

    stages {

        stage('Get deployment files') {
            steps {
                sh "bash bootstrapper.sh"
            }
        }

    }
}
