pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/NabiyaI/Punctuation-Corrector-CICD.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                python3 --version || true
                pip3 install --upgrade pip
                pip3 install -r requirements.txt || true
                '''
            }
        }

        stage('Run App / Tests') {
            steps {
                sh '''
                echo "Running project..."
                python3 app.py || echo "No app.py found"
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline ran successfully 🚀'
        }
        failure {
            echo 'Pipeline failed ❌'
        }
    }
}
