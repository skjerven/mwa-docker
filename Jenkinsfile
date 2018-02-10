def container

pipeline {
  agent any
  stages {
    ansiColor('xterm') {
      /* Checkout git repo with Dockerfiles to build and create a shortened commit ID
      * that will be used in tagging containers pushed to Docker Hub */
      stage('Clone repository') {
        checkout scm
        shortCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
      }

      // Build container
      stage('Build image') {
        container = docker.build("bskjerven/mwa-docker:${env.BUILD_ID}")
      }

      // Test Docker build
      stage('Test image') {
        //sh 'dgoss run --name=mwa-docker-dspsr-test --rm -ti bskjerven/mwa-docker dspsr -F 128:D -E tests/dspsr/1644-4559.eph -P tests/dspsr/1644-4559.polyco tests/dspsr/1644-4559.cpsr2'
        sh 'echo "Running tests"'
        container.inside("--name='dspsr-test' -v tests/dspsr:/tmp") {
          sh 'dspsr -F 128:D -E /tmp/1644-4559.eph -P tmp/1644-4559.polyco -O /tmp/dspsr_out /tmp/1644-4559.cpsr2'
        }
      }

      /* Push image to public Docker Hub with 2 tags:
       *  - Jenkins build tag
       *  - latest tag */
      stage('Push image') {
        docker.withRegistry('', 'docker-hub-credentials') {
          container.push("jenkins-build-${shortCommit}-${env.BUILD_TIMESTAMP}")
          container.push("latest")
        }
      }
    }
  }

  post {
    always {
      script {
        sh 'echo "docker rmi bskjerven/mwa-docker"'
      }
    }
    failure {
      sendEmail('brian.skjerven@pawsey.org.au')
    }
    changed {
      sendEmail('brian.skjerven@pawsey.org.au')
    }
  }
}