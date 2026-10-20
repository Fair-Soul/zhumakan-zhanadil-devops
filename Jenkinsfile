pipeline {
    agent any

    environment {
        STUDENT_NAME    = 'Zhanadil'
        STUDENT_SURNAME = 'Zhumakan'
        STUDENT_GROUP   = 'IT2-2304'
        STUDENT_ID      = '38093'

        IMAGE_NAME      = 'zhumakan-zhanadil-devops'
        CONTAINER_NAME  = 'zhumakan-zhanadil-container'
        APP_PORT        = '8000'
    }

    stages {
        stage('Checkout') {
            steps {
                // download the code from GitHub (repo and branch are set in the job)
                checkout scm
                sh 'git log -1 --pretty=format:"Commit used by Jenkins: %h %s (%an)"'
            }
        }

        stage('Build') {
            steps {
                echo "Student: ${env.STUDENT_NAME} ${env.STUDENT_SURNAME}"
                echo "Group: ${env.STUDENT_GROUP}"
                echo "Student ID: ${env.STUDENT_ID}"
                sh '''
                    chmod +x scripts/*.sh
                    bash -n scripts/Zhumakan_Zhanadil_system.sh
                    bash -n scripts/test_project.sh

                    mkdir -p build
                    echo "Build number: ${BUILD_NUMBER}" > build/build_info.txt
                    echo "Commit: $(git rev-parse --short HEAD)" >> build/build_info.txt
                    echo "Student: ${STUDENT_NAME} ${STUDENT_SURNAME}, ${STUDENT_GROUP}, ID ${STUDENT_ID}" >> build/build_info.txt
                    echo "Date: $(date)" >> build/build_info.txt
                    cat build/build_info.txt
                '''
                archiveArtifacts artifacts: 'build/build_info.txt'
            }
        }

        stage('Test') {
            steps {
                sh './scripts/test_project.sh'
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:latest -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                    docker images ${IMAGE_NAME}
                '''
            }
        }

        stage('Docker Run') {
            steps {
                sh '''
                    # remove the old container with the same name, if it exists
                    docker rm -f ${CONTAINER_NAME} || true

                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${APP_PORT}:8000 \
                        -e STUDENT_NAME="${STUDENT_NAME}" \
                        -e STUDENT_SURNAME="${STUDENT_SURNAME}" \
                        -e STUDENT_GROUP="${STUDENT_GROUP}" \
                        -e STUDENT_ID="${STUDENT_ID}" \
                        ${IMAGE_NAME}:latest

                    # wait a few seconds until the app starts
                    for i in 1 2 3 4 5; do
                        docker logs ${CONTAINER_NAME} 2>&1 | grep -q "Application is running successfully" && break
                        sleep 2
                    done

                    docker ps --filter "name=${CONTAINER_NAME}"
                    docker logs ${CONTAINER_NAME}

                    # if the app did not start, grep returns an error and the stage fails
                    docker logs ${CONTAINER_NAME} 2>&1 | grep "Application is running successfully"
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline finished successfully. Image: ${env.IMAGE_NAME}, container: ${env.CONTAINER_NAME}"
        }
        failure {
            echo 'Pipeline failed. Look at the stage marked in red.'
        }
    }
}
