pipeline {
    agent any
    
    environment {
        ECR_REPOSITORY = credentials('ECR_REPOSITORY')
        AWS_ACCOUNT_ID = credentials('AWS_ACCOUNT_ID')
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        EKS_CLUSTER_NAME = 'mlops-cluster'
        AWS_DEFAULT_REGION = 'us-east-1'
        IMAGE_TAG = "${BUILD_NUMBER}"
        FULL_IMAGE_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${ECR_REPOSITORY}"
        NAMESPACE = "mlops-prod"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Configure AWS & EKS') {
            steps {
                script {
                    sh '''
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set default.region $AWS_DEFAULT_REGION
                        
                        aws eks update-kubeconfig --region $AWS_DEFAULT_REGION --name $EKS_CLUSTER_NAME
                        kubectl get nodes
                    '''
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    sh '''
                        aws ecr get-login-password --region $AWS_DEFAULT_REGION | \
                        docker login --username AWS --password-stdin $FULL_IMAGE_URI
                    '''
                }
            }
        }

        stage('Build & Push Image') {
            steps {
                script {
                    sh '''
                        echo "Building Docker image with cache..."
                        docker build --cache-from $FULL_IMAGE_URI:latest -t $ECR_REPOSITORY:$IMAGE_TAG .
                        docker tag $ECR_REPOSITORY:$IMAGE_TAG $FULL_IMAGE_URI:$IMAGE_TAG
                        docker tag $ECR_REPOSITORY:$IMAGE_TAG $FULL_IMAGE_URI:latest
                        
                        echo "Pushing to ECR..."
                        docker push $FULL_IMAGE_URI:$IMAGE_TAG
                        docker push $FULL_IMAGE_URI:latest
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                script {
                    sh '''
                        kubectl apply -f k8s/namespace.yaml
                        
                        kubectl delete secret ecr-registry-secret -n $NAMESPACE --ignore-not-found=true
                        kubectl create secret docker-registry ecr-registry-secret \
                            --docker-server=$FULL_IMAGE_URI \
                            --docker-username=AWS \
                            --docker-password=$(aws ecr get-login-password --region $AWS_DEFAULT_REGION) \
                            --namespace=$NAMESPACE
                        
                        sed "s|PLACEHOLDER_IMAGE_URI|$FULL_IMAGE_URI:$IMAGE_TAG|g" k8s/deployment.yaml | kubectl apply -f -
                        kubectl apply -f k8s/service.yaml
                        kubectl apply -f k8s/ingress.yaml
                        kubectl apply -f k8s/hpa.yaml
                        
                        kubectl rollout status deployment/cnn-classifier -n $NAMESPACE --timeout=600s
                        kubectl get pods -n $NAMESPACE
                        kubectl get svc -n $NAMESPACE
                        kubectl get ingress -n $NAMESPACE
                    '''
                }
            }
        }
    }

    post {
        always {
            script {
                sh '''
                    docker image rm $ECR_REPOSITORY:$IMAGE_TAG || true
                    docker image rm $FULL_IMAGE_URI:$IMAGE_TAG || true
                    docker image rm $FULL_IMAGE_URI:latest || true
                    docker system prune -f
                '''
            }
        }
        success {
            echo '✅ Deploy no EKS concluído com sucesso!'
        }
        failure {
            script {
                sh '''
                    echo "❌ Pipeline falhou. Coletando logs..."
                    kubectl logs -l app=cnn-classifier -n $NAMESPACE --tail=50 || true
                    kubectl describe deployment cnn-classifier -n $NAMESPACE || true
                '''
            }
        }
    }
}
