#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGO_HOST=mongodb.daws78s.online

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

cd /opt
VALIDATE $? "Moving to opt directory"

wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz &>>$LOGFILE
VALIDATE $? "Downloading Node exporter"

tar -xf node_exporter-1.8.2.linux-amd64.tar.gz &>>$LOGFILE
VALIDATE $? "Extracted node exporter"

mv node_exporter-1.8.2.linux-amd64 node_exporter &>>$LOGFILE
VALIDATE $? "Renamed node exporter"

cp /home/ec2-user/prometheus/node_exporter.service /etc/systemd/system/node_exporter.service &>>$LOGFILE
VALIDATE $? "created node exporter service"
 
systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon reload"

systemctl enable node_exporter &>>$LOGFILE
VALIDATE $? "enabled node exporter"

systemctl start node_exporter &>>$LOGFILE
VALIDATE $? "Started node exporter"