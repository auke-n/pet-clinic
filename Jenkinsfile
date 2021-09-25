pipeline {

    agent {
        label 'build_server'
    }


    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven 'M3'
        jdk 'jdk8'
    }

    stages {

        stage('Clone Repository') {
        // Get some code from a GitHub repository
            steps {
                git branch: 'main', url: 'git@github.com:auke-n/pet-clinic.git', credentialsId: 'github'
            }
        }

        stage('Build artifact') {
            steps {
                dir('app-src') {
                    sh 'pwd'
                    sh 'ls -la'
                    echo '=== Building Petclinic Application ==='
                    sh 'mvn package'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '=== Building Petclinic Docker Image ==='
                dir('app-src') {
                    sh 'sudo docker build . -t gerbut/pet-clinic:1.${BUILD_NUMBER} -t gerbut/pet-clinic:latest'
                }
            }
        }

        stage('Push Image to Docker Registry') {
            steps {
                echo '=== Push Image to Docker Registry ==='

                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    sh 'docker logout'
                    sh "sudo docker login -u ${env.USERNAME} -p ${env.PASSWORD}"
                    sh "sudo docker push docker.io/gerbut/pet-clinic:1.${BUILD_NUMBER}"
                    sh "sudo docker push docker.io/gerbut/pet-clinic:latest"
                }
            }
        }

        stage('Test Image') {
            steps {
                echo '=== Run container on build_server ==='

                sh '''#!/bin/bash
                      docker stop $(docker ps -a -q)
                      docker rm $(docker ps -a -q)
                      sleep 10
                      docker run -d --name web -p 80:8080 gerbut/pet-clinic:latest
                      sleep 20
                      response_code=$(curl --retry 5 --retry-delay 5 --connect-timeout 5 --max-time 5 -LI http://localhost:80 -o /dev/null -w '%{http_code}\n' -s)
                      if [ ${response_code} -eq 200 ]; then
                              sleep 20
                                      echo "Response code is: ${response_code}"
                                      echo '======Test Passed!===='
                      fi'''

                sh 'sudo docker stop $(docker ps -a -q)'
                sh 'sudo docker rm $(docker ps -a -q)'
            }
        }

        stage('Remove Docker Images from the build_server') {
            steps {
                echo '=== Remove docker images from the build_server ==='
                sh "sudo docker image prune -a -f"
            }
        }

        stage('Deploy to Production') {

            agent any

            steps {
                echo '=== Run application on production-server ==='

                sh 'ssh -i ~/.ssh/jenkins.prv -o StrictHostKeyChecking=no ec2-user@10.0.1.155 "sudo docker rm -f web;"'
                sh 'ssh -i ~/.ssh/jenkins.prv -o StrictHostKeyChecking=no ec2-user@10.0.1.155 "sudo docker run -d --name web -p 80:8080 gerbut/pet-clinic:latest;"'
                sh 'sleep 30'
            }
        }
    }
}