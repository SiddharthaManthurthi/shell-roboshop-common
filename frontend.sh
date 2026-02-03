#! /bin/bash
source ./common.sh

app_name=frontend
app_dir=/usr/share/nginx/html
check_root

dnf module disable nginx -y &>> $LOGS_FILE
dnf module enable nginx:1.24 -y &>> $LOGS_FILE
dnf install nginx -y &>> $LOGS_FILE
VALIDATE $? "Installing Nginx"

systemctl enable nginx  &>> $LOGS_FILE
systemctl start nginx 
VALIDATE $? "Starting and Enabling Nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGS_FILE
VALIDATE $? "Cleaning old Nginx content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "Downloading and Extracting Frontend content"

rm -rf /etc/nginx/nginx.conf

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "Copying Nginx Configuration file"

systemctl restart nginx &>> $LOGS_FILE
VALIDATE $? "Restarting Nginx"

Print_total_time