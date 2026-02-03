#! /bin/bash
source ./common.sh
check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copying Mongo Repo"

dnf install mongodb-org -y &>> $LOGS_FILE
VALIDATE $? "Installing MongoDB Server"

systemctl enable mongod &>> $LOGS_FILE
VALIDATE $? "Enabling MongoDB Service"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing romote connections"

systemctl restart mongod &>> $LOGS_FILE
VALIDATE $? "Restarting MongoDB Service"

Print_total_time ()