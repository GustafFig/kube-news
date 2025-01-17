pipeline {
  agent any
  stages {
    stage ('Building docker') {
      steps {
        script {
          dockerapp = docker.build("gustaff77/kube-news:${env.BUILD_ID}", '-f ./Dockerfile .')
        }
      }
    }
    stage ('Push Image') {
      steps {
        script {
          docker.withRegistry('https://registry.hub.docker.com', 'DockerHubId') {
            dockerapp.push('latest')
            dockerapp.push("${env.BUILD_ID}")
          }
        }
      }
    }
    stage ('Deploy') {
      environment {
        tag_version = "${env.BUILD_ID}"
      }
      steps {
        withKubeConfig ([credentialsId: 'kube_config_prod']) {
          sh 'sed -i "s/{{TAG}}/$tag_version/g" deployment_cloud.yaml'
          sh 'kubectl apply -f deployment_cloud.yaml'
        }
      }
    }
  }
}