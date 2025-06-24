pipeline {
    agent any
    
    environment {
        PRISMA_API_URL = "https://api.sg.prismacloud.io"
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/SeungJuLee91/Testlsj2'
                stash includes: '**/*', name: 'source'
            }
        }

        stage('Inject Risk') {
            steps {
                script {
                    sh '''
                        # ⚠️ 하드코딩된 시크릿 (Prisma Cloud가 탐지 가능)
                        echo "AWS_SECRET_ACCESS_KEY=abcd1234" > secrets.env
                        
                        # ⚠️ 취약한 패키지 설치
                        echo "flask==0.10" > requirements.txt
                        pip install -r requirements.txt || true
                    '''
                }
            }
        }

        stage('Checkov') {
            steps {
                withCredentials([
                    string(credentialsId: 'PC_USER', variable: 'pc_user'),
                    string(credentialsId: 'PC_PASSWORD', variable: 'pc_password')
                ]) {
                    script {
                        docker.image('bridgecrew/checkov:latest').inside("--entrypoint=''") {
                            unstash 'source'
                            try {
                                sh '''
                                    checkov -d . --use-enforcement-rules -o cli -o junitxml \
                                    --output-file-path console,results.xml \
                                    --bc-api-key ${pc_user}::${pc_password} \
                                    --repo-id SeungJuLee91/Testlsj2 --branch main
                                '''
                                junit skipPublishingChecks: true, testResults: 'results.xml'
                            } catch (err) {
                                junit skipPublishingChecks: true, testResults: 'results.xml'
                                throw err
                            }
                        }
                    }
                }
            }
        }
    }

    options {
        preserveStashes()
        timestamps()
    }
}
