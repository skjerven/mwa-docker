def container

pipeline {

  agent any

  options {
    timeout(time: 1, unit: 'HOURS')
    timestamps()
  }

  stages {
    /* Checkout git repo with Dockerfiles to build and create a shortened commit ID
     * that will be used in tagging containers pushed to Docker Hub */
    stage('Clone repository') {
      steps {
        checkout scm
        script {
          shortCommit = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
        }
      }
    }

    // Build container
    stage('Build image') {
      steps {
        script {
          container = docker.build("bskjerven/mwa-docker")
        }
      }
    }

    // Test Docker build
    stage('Test image') {
      steps {
        script {
          //sh 'dgoss run --name=mwa-docker-dspsr-test --rm -ti bskjerven/mwa-docker dspsr -F 128:D -E tests/dspsr/1644-4559.eph -P tests/dspsr/1644-4559.polyco tests/dspsr/1644-4559.cpsr2'
          sh 'echo "Running tests"'
          container.inside("--name='dspsr-test' -v tests/dspsr:/tmp") {
            sh 'dspsr -F 128:D -E /tmp/1644-4559.eph -P tmp/1644-4559.polyco -O /tmp/dspsr_out /tmp/1644-4559.cpsr2'
          }
        }
      }
    }

    /* Push image to public Docker Hub with 2 tags:
     *  - Jenkins build tag
     *  - latest tag */
    stage('Push image') {
      steps {
        script {
          docker.withRegistry('', 'docker-hub-credentials') {
            container.push("jenkins-build-${shortCommit}-${env.BUILD_TIMESTAMP}")
            container.push("latest")
          }
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
      subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
      body: """<p>FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
        <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
      recipientProviders: [[$class: 'DevelopersRecipientProvider']]
    }
    changed {
      subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
      body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
        <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
      recipientProviders: [[$class: 'DevelopersRecipientProvider']]
    }
  }
}
