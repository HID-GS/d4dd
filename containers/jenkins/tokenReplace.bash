#! /bin/bash

function getToken {
  number=$RANDOM
  curl -H "Content-Type:application/x-www-form-urlencoded" -X POST --data "login=admin&name=${number}" -u admin:admin http://sonarqube:9000/api/user_tokens/generate
}

function parseToken {
  cut -d "\"" -f12 ~/token
}

tokenJSON=$(getToken)
echo $tokenJSON > ~/token

token=$(parseToken)

sed -i.bak 's/\(<serverAuthenticationToken>\)\([^<]*\)\(<\/serverAuthenticationToken>\)/\1'${token}'\3/g' /var/jenkins_home/hudson.plugins.sonar.SonarGlobalConfiguration.xml
sed -i.bak 's/\(<properties>sonar.login=\)\([^<]*\)/\1'${token}'/g' /var/jenkins_home/jobs/Update_Unit_Tests_SonarQube/config.xml

/bin/tini -- /usr/local/bin/jenkins.sh