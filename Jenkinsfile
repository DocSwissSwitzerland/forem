pipeline {
  agent any

  stages {
    stage('Docker') {
      steps {
        sh 'docker build . -f Dockerfile.ZurichExpats'
      }
    }

  }
}