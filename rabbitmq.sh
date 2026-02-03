#! /bin/bash
source ./common.sh

app_name=rabbitmq
check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "Copying RabbitMQ Repo"

dnf install rabbitmq-server -y &>> $LOGS_FILE
VALIDATE $? "Installing RabbitMQ Server"

systemctl enable rabbitmq-server
systemctl start rabbitmq-server
VALIDATE $? " Enabling and starting RabbitMQ Service"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "Creating RabbitMQ User and setting permissions"

Print_total_time