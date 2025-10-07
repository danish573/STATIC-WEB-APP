pipeline {
    agent any
    environment {
        S3_BUCKET = "static_website_s3_bucket"
        AWS_REGION ="us-east-1"
    }

    stages{
        stage('checkout code')
        {
        steps{
            git branch: 'main' url: "https://github.com/danish573/STATIC-WEB-APP.git"
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
                echo "Deploying Static site to s3"
                sh 'bash sripts/minify_and_deploy.sh deploy'
            }
        }   
    }

    post{
        success{
            echo "Deployment Successful! Site is live at: http://$S3_BUCKET.s3-website-$AWS_REGION.amazonaws.com"
        }
        failure{
            echo "❌ Build failed! Check logs."
        }
    }


}