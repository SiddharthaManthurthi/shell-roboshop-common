#! /bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/mongodb"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
START_TIME=$(date +%s)

echo "Script started excuting at : $(date "+%Y-%m-%d-%H:%M:%S")" | tee -a $LOGS_FILE

check_root (){
   if [ $USERID -ne 0 ]; then
      echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
      exit 1
   fi
}

mkdir -p $LOGS_FOLDER

VALIDATE () {
   if [ $1 -ne 0 ]; then
      echo -e "$(date "+%Y-%m-%d-%H:%M:%S") | $R $2 installation failed $N" | tee -a $LOGS_FILE
      exit 1
    else
        echo -e "$(date "+%Y-%m-%d-%H:%M:%S") | $G $2 installation successful $N" | tee -a $LOGS_FILE
    fi
}