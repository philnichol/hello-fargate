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
        stage("BuildandTestCode") {
            // don't build this in a container since docker in docker can cause issues
            agent {
                label "docker"
            }
            steps {
                sh '''
                    make codetest
                '''
            }
        }
        stage("PushCode") {
            // don't run this in a container since docker in docker can cause issues
            agent {
                label "docker"
            }
            // only actually push when on main branch
            when {
                branch 'main'
            }
            steps {
                withCredentials(${AWS_CREDENTIALS}) {
                    sh '''
                        make codelogin
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
        stage("ActualResultTest") {
            // only run when on main branch
            when {
                branch 'main'
            }
            steps {
                sh '''
                    make test
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