#! /bin/bash
source ./common.sh

app_name=shipping
check_root
app_setup
java_setup
sytemd_setup

dnf install mysql -y  &>>$LOGS_FILE
VALIDATE $? "Installing MySQL"


mysql -h $MYSQL_HOST -uroot -pRoboShop@123 -e 'use cities'
if [ $? -ne 0 ]; then

    mysql -h $MYSQL_HOST -uroot -pRoboShop@123 < /app/db/schema.sql &>>$LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@123 < /app/db/app-user.sql &>>$LOGS_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@123 < /app/db/master-data.sql &>>$LOGS_FILE
    VALIDATE $? "Loaded data into MySQL"
else
    echo -e "data is already loaded ... $Y SKIPPING $N"
fi

app_restart
Print_total_time