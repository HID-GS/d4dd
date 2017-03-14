FROM jenkins:alpine
LABEL vendor="HID Global"

RUN install-plugins.sh sonar ssh cloudbees-folder timestamper workflow-aggregator subversion ldap antisamy-markup-formatter ws-cleanup github-organization-folder ssh-slaves email-ext build-timeout ant pipeline-stage-view matrix-auth mailer credentials-binding gradle git pam-auth

COPY jenkins.install.UpgradeWizard.state /var/jenkins_home/jenkins.install.UpgradeWizard.state

COPY jenkins.install.InstallUtil.lastExecVersion /var/jenkins_home/jenkins.install.InstallUtil.lastExecVersion

COPY basic-security.groovy /var/jenkins_home/init.groovy.d/basic-security.groovy

ADD ./id_rsa_insecure /tmp/id_rsa

USER root

RUN rm -f /etc/service/sshd/down && \
    mkdir /root/.ssh && \
    cat /tmp/id_rsa >> /root/.ssh/id_rsa \
      && rm -f /tmp/id_rsa* \
      && chmod 400 /root/.ssh/id_rsa

RUN { \
  echo 'Host utility-container'; \
  echo '    StrictHostKeyChecking no'; \
} > /root/.ssh/config
