#! /bin/bash
source ./common.sh

app_name=mysql
check_root

dnf install mysql-server -y &>> $LOGS_FILE
VALIDATE $? "Installing MySQL Server"

systemctl enable mysqld
systemctl start mysqld  
VALIDATE $? " Enabling and starting MySQL Service"

#get the password from the user

mysql_secure_installation --set-root-pass RoboShop@123 &>> $LOGS_FILE
VALIDATE $? "Setting MySQL root password"
Print_total_time