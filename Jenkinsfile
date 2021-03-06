// DEVOPS CI PIPELINE CODE SCAN & IMAGE BUILD
pipeline {
    agent {
        kubernetes {
            // USE JENKINS-ANSIBLE-TERRAFORM AGENT IMAGE TODO: MOUNT TERRAFORM FILES ? PLAYBOOKS AS VOLUMES
            yaml '''
                apiVersion: v1
                kind: Pod
                spec:
                containers:
                - name: cloud-cli
                  image: heirophany/cloud-cli:0.0.2
                  command:
                  - cat
                  tty: true
                  volumeMounts:
                  - mountPath: /var/run/docker.sock
                    name: docker-sock
                - name: terraform
                  image: hashicorp/terraform:0.12.13
                  command:
                  - cat
                  tty: true
                - name: ansible
                  image: core.harbor.example.com/jenkins/ansible:2.9
                  command:
                  - cat
                  tty: true
                  volumeMounts:
                  - mountPath: "/etc/ssh-key"
                    name: ssh-key
                    readOnly: true
                volumes:
                - name: docker-sock
                  hostPath:
                    path: /var/run/docker.sock
                - name: ssh-key
                  secret:
                    secretName: ansible-ssh-key
                    defaultMode: 256
            '''
        }
    }
    environment {
        // USER
        OWNER_NAME = 'mg'
        CREATOR_COMMENTS = 'dev GCP test deployment'
        CREATION_DATE = '05/09/2022'
        WORKSPACE = 'default'

        // CREDENTIALS
        AWS_CREDENTIALS = credentials('aws-aline-jenkins')
        GCLOUD_CREDS=credentials('gcp-aline-jenkins')
        SONARQUBE_CREDS = credentials('sonarqube-token')

        // CONFIGURATION VARIABLES
        BUILD_BRANCH_NAME = 'dev'
        PROVISIONER_TYPE = 'terraform'
        //| TERRAFORM: aws, gcp | SCRIPTS: kind, k3s, k3ai
        PROVIDER_TYPE = 'gcp'
        // eks, ecs, gke, gcm, kind, k3s, k3ai
        CLUSTER_TYPE = 

        // REPOSITORY VARIABLES
        IMAGE_REPO = '${GCP_IMAGE_REPO}'
        IMAGE_REPO_REGION = 'us-east1'
        BUILD_ID = '0.0.1'
        DEPLOYMENT_TYPE = ''
        
        // AWS VARIABLES
        AWS_DEFAULT_REGION = '${AWS_DEFAULT_REGION}'

        // GCP VARIABLES
        DEPLOYMENT_PROJECT_ID = '${GCP_DEPLOYMENT_PROJECT_ID}'
        LOCATION = '${GCP_GKE_LOCATION}'
        CLIENT_EMAIL = '${GCP_CLIENT_EMAIL}'
        PROJECT_ID = "aline-jenkins-gcp"
    }
    stages {
        stage('PROVIDER AUTHENTICATION AWS') {
            // AUTHENTICATES INTO AWS
            when { environment name: 'CLOUD_PROVIDER', value: 'AWS' }
            steps {
                container('cloud-cli') {
                    sh """
                    aws ecr-public get-login-password --region ${AWS_DEFAULT_REGION} |\
                    docker login --username AWS --password-stdin ${IMAGE_REPO}
                    """
                }
            }
        }
        stage('PROVIDER AUTHENTICATION GCP') {
            // AUTHENTICATES INTO GCP
            // when { environment name: 'CLOUD_PROVIDER', value: 'GCP' }
            steps {
                container('cloud-cli') {
                    sh """
                    gcloud version
                    gcloud auth activate-service-account --key-file="$GCLOUD_CREDS"
                    gcloud auth configure-docker us-east1-docker.pkg.dev
                    gcloud config set project "$PROJECT_ID"
                    gcloud auth configure-docker \
                        us-east1-docker.pkg.dev
                    """
                }
            }
        }
        stage('SCAN / PROVISION') {
            steps {
                container('terraform') {
                    sh """
                    #!/bin/bash

                    echo 'SCANNING / PROVISIONING INFRASTRUCTURE...'

                    echo 'IAC APPLY...'
                    source ./deployments/$BUILD_BRANCH_NAME/iac.sh
                """
                }
            }
        }
        stage('DEPLOYMENT') {
            steps {
                container('cloud-cli') {
                    sh """
                    #!/bin/bash

                    echo 'SCANNING / PROVISIONING INFRASTRUCTURE...'

                    echo 'IAC APPLY...'
                    source ./deployments/$BUILD_BRANCH_NAME/deploy.sh
                """
                }
            }
        }
    }
}