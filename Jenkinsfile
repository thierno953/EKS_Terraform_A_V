pipeline {
    agent any

    stages {
        stage('Configure') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/thierno953/terraform_a_v']])
            }
        }
        stage('Building image') {
            steps {
                sh 'docker build -t terraform_a_v .'
            }
        }

        stage('Pushing to ECR') {
            steps {
                withAWS(credentials: 'AWS-CREDS', region: '<AWS-REGION>') {
                    sh 'aws ecr get-login-password --region <AWS-REGION> | docker login --username AWS --password-stdin <ECR-REGISTRY-ID>'
                    sh 'docker tag terraform_a_v:latest <ECR-REGISTRY-ID>/<IMAGE_NAME>:latest'
                    sh 'docker push <ECR-REGISTRY-ID>/<IMAGE_NAME>:latest'
                }
            }
        }

        stage('K8S Deploy') {
            steps {
                script {
                    withAWS(credentials: 'AWS-CREDS', region: '<AWS-REGION>') {
                        sh 'aws eks update-kubeconfig --name <EKS-CLUSTER> --region <AWS-REGION>'
                        sh 'kubectl apply -f EKS-deployment.yaml'
                    }
                }
            }
        }

        stage('Get Service URL') {
            steps {
                script {
                    def serviceUrl = ""
                    // Wait for the LoadBalancer IP to be assigned
                    timeout(time: 5, unit: 'MINUTES') {
                        while(serviceUrl == "") {
                            serviceUrl = sh(script: "kubectl get svc terraform_a_v-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'", returnStdout: true).trim()
                            if(serviceUrl == "") {
                                echo "Waiting for the LoadBalancer IP..."
                                sleep 10
                            }
                        }
                    }
                    echo "Service URL: http://${serviceUrl}"
                }
            }
        }
    }
}
