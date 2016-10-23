#! /bin/bash

mkdir /home/remote
mv /remoteBashrc /home/remote/.bashrc
mv /remoteBash_profile /home/remote/.bash_profile
useradd remote --home /home/remote --group sudo --gid sudo && echo "remote:db_82&Wr:bVqc6D4" | chpasswd
echo "remote        ALL=(ALL)NOPASSWD: ALL" >> /etc/sudoers
usermod -s /bin/bash remote
chown remote:sudo /home/remote/.bashrc
chown remote:sudo /home/remote/.bash_profile
chown -R remote:sudo /home/remote
