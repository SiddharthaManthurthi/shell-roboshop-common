#! /bin/bash
source ./common.sh
app_name=catalogue

check_root
app_setup
nodejs_setup
sytemd_setup

#Loading data into mongodb
cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>> $LOGS_FILE


INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
   mongosh --host $MONGODB_HOST </app/db/master-data.js
   VALIDATE $? "Loading Catalogue Data"
else
    echo -e "$(date "+%Y-%m-%d-%H:%M:%S") |$Y Catalogue DB already exists, skipping data load $N" | tee -a $LOGS_FILE
fi
