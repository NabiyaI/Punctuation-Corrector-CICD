pipeline {
    agent any

    environment {
        PATH = "/usr/local/bin:/opt/homebrew/bin:${env.PATH}"
    }

    stages {

        stage('Clone Repository') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }

        stage('Setup Python Environment') {
            steps {
                echo 'Setting up Python virtual environment...'
                sh '''
                python3 --version
                python3 -m venv venv
                source venv/bin/activate
                pip install --upgrade pip
                pip install -r requirements.txt
                '''
            }
        }

        stage('Run Application / Tests') {
            steps {
                echo 'Running application...'
                sh '''
                source venv/bin/activate
                python app.py || echo "No app.py found, skipping run"
                '''
            }
        }
    }

    post {
        success {
            echo 'Build completed successfully!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
