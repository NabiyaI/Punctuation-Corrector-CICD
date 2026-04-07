pipeline {
    agent any

    environment {
        // Name of your Azure Container Registry
        REGISTRY_NAME = 'yourregistryname.azurecr.io'
        
        // Image name to build and push
        IMAGE_NAME = 'punctuation-corrector'
        
        // Target App Service Name
        APP_SERVICE_NAME = 'punctuation-corrector-app'
        
        // Resource Group where App Service resides
        RESOURCE_GROUP = 'rg-punctuation-corrector'
        
        // Azure Credentials ID stored in Jenkins
        AZURE_CRED_ID = 'AZURE_SERVICE_PRINCIPAL'
        
        // ACR Credentials ID stored in Jenkins
        ACR_CRED_ID = 'ACR_CREDENTIALS'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image ${REGISTRY_NAME}/${IMAGE_NAME}:${env.BUILD_ID}"
                    bat "docker build -t ${REGISTRY_NAME}/${IMAGE_NAME}:${env.BUILD_ID} -t ${REGISTRY_NAME}/${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Push to Azure Container Registry') {
            steps {
                script {
                    echo "Pushing image to ACR..."
                    withCredentials([usernamePassword(credentialsId: env.ACR_CRED_ID, passwordVariable: 'ACR_PASSWORD', usernameVariable: 'ACR_USERNAME')]) {
                        bat "echo %ACR_PASSWORD% | docker login ${REGISTRY_NAME} -u %ACR_USERNAME% --password-stdin"
                        bat "docker push ${REGISTRY_NAME}/${IMAGE_NAME}:${env.BUILD_ID}"
                        bat "docker push ${REGISTRY_NAME}/${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy to Azure App Service') {
            steps {
                script {
                    echo "Deploying to Azure Web App for Containers..."
                    withCredentials([azureServicePrincipal(credentialsId: env.AZURE_CRED_ID,
                                                           clientIdVariable: 'AZURE_CLIENT_ID',
                                                           clientSecretVariable: 'AZURE_CLIENT_SECRET',
                                                           tenantIdVariable: 'AZURE_TENANT_ID',
                                                           subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID')]) {
                        
                        // Login to Azure using Service Principal
                        bat 'az login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% -t %AZURE_TENANT_ID%'
                        bat 'az account set --subscription %AZURE_SUBSCRIPTION_ID%'
                        
                        // Update the Web App to use the new container image
                        bat """
                            az webapp config container set ^
                                --name ${APP_SERVICE_NAME} ^
                                --resource-group ${RESOURCE_GROUP} ^
                                --docker-custom-image-name ${REGISTRY_NAME}/${IMAGE_NAME}:${env.BUILD_ID} ^
                                --docker-registry-server-url https://${REGISTRY_NAME} ^
                                --docker-registry-server-user %ACR_USERNAME% ^
                                --docker-registry-server-password %ACR_PASSWORD%
                        """
                        
                        // Restart App Service
                        bat "az webapp restart --name ${APP_SERVICE_NAME} --resource-group ${RESOURCE_GROUP}"
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                echo "Pipeline finished."
            }
        }
        success {
            echo "Successfully deployed new version."
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
