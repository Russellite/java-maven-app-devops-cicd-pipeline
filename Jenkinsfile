#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@master', retriever: modernSCM(
  [$class: 'GitSCMSource',
   remote: 'https://gitlab.com/Russellite/jenkins-shared-library.git',
   credentialsId: 'gitlab-cred'
  ]
)

pipeline {
  agent any

  environment {
    IMAGE_REPO   = 'giftedition/java-maven-app'
    IMAGE_TAG    = "${IMAGE_REPO}:${BUILD_NUMBER}"
    RELEASE_NAME = 'java-maven-app'
    CHART_PATH   = 'helm/java-maven-app'
    NAMESPACE    = 'test'
  }

  stages {
    stage("Multi Stage Image Build") {
      steps {
        script {
          echo "building the docker image..."
          buildImage(IMAGE_TAG)
          dockerLogin()
          dockerPush(IMAGE_TAG)
        }
      }
    }

    stage("Deploy to Kubernetes (Helm)") {
      steps {
        script {
          echo 'deploying docker image with helm...'
          withKubeConfig([credentialsId: 'dg-kubeconfig', serverUrl: 'https://167.71.134.236:6443']) {
            sh """
              helm upgrade --install ${RELEASE_NAME} ${CHART_PATH} \
                -n ${NAMESPACE} --create-namespace \
                --set image.repository="${IMAGE_REPO}" \
                --set image.tag="${BUILD_NUMBER}"
            """
          }
        }
      }
    }
  }
}