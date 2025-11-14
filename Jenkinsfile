pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: kaniko-agent
spec:
  serviceAccountName: jenkins
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:latest
      args: ["sleep", "infinity"]

    - name: aws
      image: amazon/aws-cli:latest
      command: ["cat"]
      tty: true
"""
        }
    }

    environment {
        AWS_REGION   = "us-east-1"
        ECR_REGISTRY = "306208069784.dkr.ecr.us-east-1.amazonaws.com"
        ECR_REPO     = "${ECR_REGISTRY}/lesson-5-ecr"
        IMAGE_TAG    = "build-${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout infra (lesson-8-9)') {
            steps {
                checkout scm
            }
        }

        stage('Checkout app source (lesson-4)') {
            steps {
                dir("app-src") {
                    git branch: 'lesson-4',
                        url: 'https://github.com/misfits3z/my-microservice-project.git',
                        credentialsId: 'git-creds'
                }
            }
        }

        stage('Login to ECR') {
            steps {
                container('aws') {
                    withCredentials([usernamePassword(credentialsId: 'aws-creds',
                                                     usernameVariable: 'AWS_ACCESS_KEY_ID',
                                                     passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh """
                        aws configure set region ${AWS_REGION}
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY

                        aws ecr get-login-password --region ${AWS_REGION} \
                           | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                        """
                    }
                }
            }
        }

        stage('Build & Push Docker image') {
            steps {
                dir("app-src") {
                    container('kaniko') {
                        sh """
                        /kaniko/executor \
                          --context `pwd` \
                          --dockerfile Dockerfile \
                          --destination ${ECR_REPO}:${IMAGE_TAG}
                        """
                    }
                }
            }
        }

        stage('Update Helm chart image tag') {
            steps {
                sh """
                sed -i 's/^\\s*tag:.*/  tag: ${IMAGE_TAG}/' charts/django-app/values.yaml
                """
            }
        }

        stage('Commit & Push Helm changes') {
            steps {
                sh """
                git config user.email "jenkins@local"
                git config user.name "Jenkins"

                git add charts/django-app/values.yaml
                git commit -m "Update image tag to ${IMAGE_TAG}" || true
                git push origin HEAD:lesson-8-9
                """
            }
        }

    }
}
