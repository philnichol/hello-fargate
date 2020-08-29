pipeline {
    agent {
        docker {
            label "docker"
            image "CI_IMAGE:VERSION"
            args '-e "HOME=/" -u 0:0'
        }
    }

    environment {
        ACCOUNT_NUMBER = "12345678"
        AWS_CREDENTIALS = "aws-jenkins-credentials"
        ECR_REGION = sh(
            returnStdout: true,
            script: "grep -e region infrastructure/terraform.tfvars | cut -d '=' -f 2 | tr -d '[:space:]' | tr -d '\"'"
        )
        NAME = sh(
            returnStdout: true,
            script: "grep -e name infrastructure/terraform.tfvars | cut -d '=' -f 2 | tr -d '[:space:]' | tr -d '\"'"
        )
        ENV = sh(
            returnStdout: true,
            script: "grep -e env infrastructure/terraform.tfvars | cut -d '=' -f 2 | tr -d '[:space:]' | tr -d '\"'"
        )
        IMAGE_TAG = sh(
            returnStdout: true,
            script: "grep -e image_tag infrastructure/terraform.tfvars | cut -d '=' -f 2 | tr -d '[:space:]' | tr -d '\"'"
        )
        GIT_REF = sh(
            returnStdout: true,
            script: "git log -n 1 --pretty=format:'%h'"
        ).trim()
        ECR_NAME = "${ACCOUNT_NUMBER}.dkr.ecr.${ECR_REGION}.amazonaws.com"
        IMAGE_NAME = "${ECR_NAME}/${NAME}-${ENV}"
    }

    options {
        timeout(time: 10, unit: "MINUTES")
        buildDiscarder(logRotator(numToKeepStr: "5"))
    }

    stages {
        stage("Prep") {
            steps {
                sh '''
                    make prep
                    make tffmt
                    make tfinit
                    make tfvalidate
                    make codelogin
                '''
            }
        }
        stage("CreateECR") {
            // only actually build when on main branch
            when {
                branch 'main'
            }
            steps {
                sh '''
                    make tfecrapply
                '''
            }
        }
        stage("BuildCode") {
            steps {
                sh '''
                    make codebuild
                '''
            }
        }
        stage("PushCode") {
            // only actually push when on main branch
            when {
                branch 'main'
            }
            steps {
                sh '''
                    make codepush
                '''
            }
        }
        stage("BuildInfra") {
            // only actually build when on main branch
            when {
                branch 'main'
            }
            steps {
                sh '''
                    make tfapply
                '''
            }
        }
    }
    post {
        always {
            // run this after execution so it can be used in a multibranch pipeline
            // returning status to bitbucket so it can be used to test that a branch builds before a PR
            // deleteDir since we're running the docker container as root
            script {
                currentBuild.result = currentBuild.result ?: 'SUCCESS'
                notifyBitbucket()
                deleteDir()
            }
        }
    }
}