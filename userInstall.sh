#! /bin/bash

echo "
/etc/hosts is READ-ONLY into docker container. You will need to use a run option to add svn working with novent repository :
--add-host=example.loc:172.17.0.2
"

cd /mnt/
tar -zcvf /home/remote/hostSharedSkeleton.tar.gz hostShared
chown remote:sudo /home/remote/hostSharedSkeleton.tar.gz
chmod 664 /home/remote/hostSharedSkeleton.tar.gz
