pipeline {
        agent any
        
        environment {
            PRISMA_API_URL="https://api.sg.prismacloud.io"
        }
        
        stages {
            stage('Checkout') {
              steps {
                  git branch: 'main', url: 'https://github.com/SeungJuLee91/Testlsj2'
                  stash includes: '**/*', name: 'source'
              }
            }
            stage('Checkov') {
                steps {
                    withCredentials([string(credentialsId: 'PC_USER', variable: 'pc_user'),string(credentialsId: 'PC_PASSWORD', variable: 'pc_password')]) {
                        script {
                            docker.image('bridgecrew/checkov:latest').inside("--entrypoint=''") {
                              unstash 'source'
                              try {
                                  sh '''
                                  checkov -d . \
                                    --use-enforcement-rules \    # 조직 정책 적용
                                    -o cli -o junitxml \         # 출력: CLI + JUnit XML
                                    --output-file-path console,results.xml \  # 출력 경로
                                    --bc-api-key ${pc_user}::${pc_password} \ # 인증 정보
                                    --repo-id SeungJuLee91/Testlsj2 \         # 리포 ID
                                    --branch main                              # 브랜치 지정
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