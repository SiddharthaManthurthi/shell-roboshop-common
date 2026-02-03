#! /bin/bash
source ./common.sh

app_name=redis
check_root

dnf module disable redis -y &>> $LOGS_FILE
VALIDATE $? "Disabling Redis Module"

dnf module enable redis:7 -y &>> $LOGS_FILE
VALIDATE $? "Enabling Redis 7 Module"

dnf install redis -y  &>> $LOGS_FILE
VALIDATE $? "Installing Redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Updating Redis Configuration"

systemctl enable redis &>> $LOGS_FILE
VALIDATE $? "Enabling Redis Service"

systemctl start redis &>> $LOGS_FILE
VALIDATE $? "Starting Redis Service"

Print_total_time