#! /bin/bash

wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get -y update
apt-get -y install jenkins

mkdir /var/run/jenkins
chown jenkins /var/run/jenkins


touch /etc/profile.d/envJenkins.sh
chmod 644 /etc/profile.d/envJenkins.sh
chown root:jenkins /etc/profile.d/envJenkins.sh
echo "export JENKINS_HOME=/mnt/hostShared/jenkins" >> /etc/profile.d/envJenkins.sh
echo 'export JENKINS_OPTS="--logfile=/mnt/hostShared/jenkins_logs"' >> /etc/profile.d/envJenkins.sh


if [ ! -d /mnt/hostShared ]
then
	mkdir /mnt/hostShared;
fi
mv /var/lib/jenkins /mnt/hostShared/
mkdir /mnt/hostShared/jenkins_logs
touch /mnt/hostShared/jenkins_logs/jenkins.log
chown -R jenkins:jenkins /mnt/hostShared/jenkins_logs
mkdir /mnt/hostShared/jenkins_backup
chown jenkins:jenkins /mnt/hostShared/jenkins_backup

mkdir /mnt/hostShared/jenkins_backup
(crontab -l ; echo "0 0 * * * tar zcvf /mnt/hostShared/jenkins_backup/jenkins.tar.gz") | sort - | uniq - | crontab -
(crontab -l ; echo "0 0 * * 1 tar zcvf /mnt/hostShared/jenkins_backup/\`date +\"%Y%m%d\"\`_jenkins.tar.gz") | sort - | uniq - | crontab -
(crontab -l ; echo "0 0 * * 5 find /mnt/hostShared/mysql_backup/*.tar.gz -mtime +30 -exec rm {} \\;") | sort - | uniq - | crontab -

usermod -d /mnt/hostShared/jenkins jenkins
sed -i '/JENKINS_HOME=\/var\/lib\/\$NAME/c\JENKINS_HOME=\/mnt\/hostShared\/\$NAME' /etc/default/jenkins
sed -i '/JENKINS_LOG=\/var\/log\/\$NAME\/\$NAME.log/c\JENKINS_LOG=\/mnt\/hostShared\/\$NAME\/\$NAME.log' /etc/default/jenkins
