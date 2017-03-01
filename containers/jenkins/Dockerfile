FROM jenkins:alpine

RUN install-plugins.sh sonar cloudbees-folder timestamper workflow-aggregator subversion ldap antisamy-markup-formatter ws-cleanup github-organization-folder ssh-slaves email-ext build-timeout ant pipeline-stage-view matrix-auth mailer credentials-binding gradle git pam-auth

ADD jenkins.install.UpgradeWizard.state /var/jenkins_home/jenkins.install.UpgradeWizard.state

ADD jenkins.install.InstallUtil.lastExecVersion /var/jenkins_home/jenkins.install.InstallUtil.lastExecVersion

ADD basic-security.groovy /var/jenkins_home/init.groovy.d/basic-security.groovy
