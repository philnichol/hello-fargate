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
    }

    options {
        timeout(time: 10, unit: "MINUTES")
        buildDiscarder(logRotator(numToKeepStr: "5"))
    }

    stages {
        stage("Prep") {
            steps {
                withCredentials(${AWS_CREDENTIALS}) {
                    sh '''
                        make prep
                        make tffmt
                        make tfinit
                        make tfvalidate
                        make codelogin
                    '''
                }
            }
        }
        stage("CreateECR") {
            // only actually build when on main branch
            when {
                branch 'main'
            }
            steps {
                withCredentials(${AWS_CREDENTIALS}) {
                    sh '''
                        make tfecrapply
                    '''
                }
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
                withCredentials(${AWS_CREDENTIALS}) {
                    sh '''
                        make codepush
                    '''
                }
            }
        }
        stage("BuildInfra") {
            // only actually build when on main branch
            when {
                branch 'main'
            }
            steps {
                withCredentials(${AWS_CREDENTIALS}) {
                    sh '''
                        make tfapply
                    '''
                }
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