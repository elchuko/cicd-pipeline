pipeline {
    agent any

    tools {
        nodejs 'NodeJs_23'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    def branchName = env.BRANCH_NAME ?: env.GIT_BRANCH?.split('/')?.last() ?: 'main' // Determine branch

                    if (fileExists('cicd-pipeline')) {
                        dir('cicd-pipeline') {
                            sh "whoami"
                            sh "echo $PATH"
                            sh "git checkout ${branchName}"
                            sh "git pull origin ${branchName}"
                            sh "npm install"
                        }
                    } else {
                        sh "git clone --branch ${branchName} https://github.com/elchuko/cicd-pipeline.git"
                    }
                }
            }
        }

        stage('Build') {
            steps {
                dir('cicd-pipeline') {
                    sh "npm run build"
                }
            }
        }

        stage('Test') {
            steps {
                dir('cicd-pipeline') {
                    sh "npm run test"
                }
            }
        }

        stage('Docker build') {
            steps {
                dir('cicd-pipeline') {
                    sh "docker build -t node ."
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def branchName = env.BRANCH_NAME ?: env.GIT_BRANCH?.split('/')?.last() ?: 'main' // Determine branch
                    if (branchName == 'main') {
                        sh "docker stop \$(docker ps -q --filter ancestor=node) || true"
                        sh "docker rm \$(docker ps -aq --filter ancestor=node) || true"
                        sh "docker run -d -p 3000:3000 node"
                    } else if (branchName == 'dev') {
                        // Deploy differently for dev, perhaps on a different port or environment
                        sh "docker stop \$(docker ps -q --filter ancestor=node) || true"
                        sh "docker rm \$(docker ps -aq --filter ancestor=node) || true"
                        sh "docker run -d -p 3001:3000 node" //Dev uses port 3001
                    } else {
                        echo "Branch ${branchName} is not main or dev, skipping deploy"
                    }
                }
            }
        }
    }
}