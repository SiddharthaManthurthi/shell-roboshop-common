#! /bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/mongodb"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$pwd  
START_TIME=$(date +%s)
$MONGODB_HOST=mongodb.siddharthais.online

mkdir -p $LOGS_FOLDER

echo "Script started excuting at : $(date "+%Y-%m-%d-%H:%M:%S")" | tee -a $LOGS_FILE

check_root (){
   if [ $USERID -ne 0 ]; then
      echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
      exit 1
   fi
}


VALIDATE () {
   if [ $1 -ne 0 ]; then
      echo -e "$(date "+%Y-%m-%d-%H:%M:%S") | $R $2 installation failed $N" | tee -a $LOGS_FILE
      exit 1
    else
        echo -e "$(date "+%Y-%m-%d-%H:%M:%S") | $G $2 installation successful $N" | tee -a $LOGS_FILE
    fi
}

nodejs_setup () {
    dnf module disable nodejs -y &>> $LOGS_FILE
    VALIDATE $? "Disabling NodeJS Module"

    dnf module enable nodejs:20 -y &>> $LOGS_FILE
    VALIDATE $? "Enabling NodeJS 20 Module"

    dnf install nodejs -y &>> $LOGS_FILE
    VALIDATE $? "Installing NodeJS 20"

    npm install  &>> $LOGS_FILE
    VALIDATE $? "Installing NodeJS Dependencies"
}

app_setup (){
    id roboshop &>> $LOGS_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOGS_FILE
        VALIDATE $? "Adding sytem User"
    else
        echo -e "$Y roboshop user already exists, skipping $N" | tee -a $LOGS_FILE
    fi
    mkdir -p /app 
    VALIDATE $? "Creating app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>> $LOGS_FILE
    VALIDATE $? "Downloading $app_name App" 

    cd /app
    VALIDATE $? "Moving to app directory"

    rm -rf /app/*
    VALIDATE $? "Cleaning old code"

    unzip /tmp/$app_name.zip &>> $LOGS_FILE
    VALIDATE $? "Unzippping $app_name code"
}

sytemd_setup (){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Copying systemctl Service File"

    systemctl daemon-reload 
    systemctl enable $app_name  &>> $LOGS_FILE
    systemctl start $app_name 
    VALIDATE $? "Starting and enabling $app_name"
} 

app_restart (){
    systemctl restart $app_name
    VALIDATE $? "Restarting $app_name"
}

Print_total_time (){    
   END_TIME=$(date +%s)
   TOTAL_TIME=$(($END_TIME - $START_TIME))
   echo -e "$Y Total time taken to execute the script : $TOTAL_TIME seconds $N" | tee -a $LOGS_FILE
}