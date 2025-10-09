pipeline {
    agent any
    environment {
          variable "s3_bucket_name" {
          default = "static-wl-website-s3-bucket"
    }


    stages{
        stage('checkout code')
        {
        steps{
            git branch: 'main', url: 'https://github.com/danish573/STATIC-WEB-APP.git'
            }
        }
        stage('Minify files')
        {
            steps{
                echo "Minifying HTML, CSS and JS..."
                sh 'bash scripts/minify_and_deploy.sh minify'
            }
        }
          stage('Deploy to S3'){
            steps{
                echo "Deploying Static site to S3"
                sh "bash scripts/minify_and_deploy.sh deploy $S3_BUCKET $AWS_REGION"
            }
        }
    }

   post {
    success {
        echo "✅ Deployment Successful! Site is live at: http://${env.S3_BUCKET}.s3-website-${env.AWS_REGION}.amazonaws.com"
    }
    failure {
        echo "❌ Build failed! Check logs."
    }
}


}
