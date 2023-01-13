pipeline {
    agent any 
  environment {
        PATH = "/usr/share/maven"
    }
    stages {

        stage('GetCode') { 
            steps {
                git ''
            }
        }

        stage('Stage-1 : clean') { 
            steps {
                sh 'mvn clean package'
            }
        }
         stage('Stage-2 : Validate') { 
            steps {
                sh 'mvn validate'
            }
        }
         stage('Stage-3 : Compile') { 
            steps {
                sh 'mvn compile'
            }
        }
         stage('sonarQube analysis') { 
            steps {
                sh 'mvn sonar:sonar'
            }
        }
          stage('Stage-5 : Install') { 
            steps {
                sh 'mvn install -DskipTests'
            }
        }
          stage('Stage-6 : Verify') { 
            steps {
                sh 'mvn verify -DskipTests'
            }
        }
          stage('Stage-7 : Package') { 
            steps {
                sh 'mvn package -DskipTests'
            }
        }

           stage('Stage-8 : Deploy an Artifact to Artifactory Manager i.e. Nexus/Jfrog') { 
            steps {
                sh 'mvn deploy -DskipTests'
            }
        }

          stage('Stage-9 : Deployment - Deploy a Artifact devops-3.0.0-SNAPSHOT.war file to Tomcat Server') { 
            steps {
                sh 'curl -u admin:redhat@123 -T target/**.war "http://54.238.178.6:8080/manager/text/deploy?path=/softobiz&update=true"'
            }
        } 
  
          stage('Stage-10 : SmokeTest') { 
            steps {
                sh 'curl --retry-delay 10 --retry 5 "http://54.238.178.6:8080/AWS"'
            }
        }

  
    }
}
