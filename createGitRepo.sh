#!/bin/bash

clear
read -p 'ENTER PROJECT NAME : ' projectName
gitProject=${projectName}.git

sleep 1

cp -rf /home/git/sushi-starter/post-receive /home/git/repositories/$gitProject/hooks/
sed -i "s/PROJECTNAMESTAGING/$projectName-staging/g" /home/git/repositories/$gitProject/hooks/post-receive
sed -i "s/PROJECTNAMEDEV/$projectName-dev/g" /home/git/repositories/$gitProject/hooks/post-receive
sed -i "s/PROJECTNAME/$projectName/g" /home/git/repositories/$gitProject/hooks/post-receive
chown git:git /home/git/repositories/$gitProject/hooks/post-receive
chmod u+x /home/git/repositories/$gitProject/hooks/post-receive

sleep 2

mkdir /var/www/html/$projectName-dev
chown -R git.git /var/www/html/$projectName-dev
sleep 1 
mkdir /var/www/html/$projectName-staging
chown -R git.git /var/www/html/$projectName-staging

sleep 2

mkdir /tmp/$projectName
cd /tmp/$projectName

git init
git config --global user.name "admin"
git config --global user.email "support@email.com"
git remote add origin git@192.168.6.22:$gitProject.git
cp -rf /home/git/sushi-starter/swp330ultimate/* /tmp/$projectName

git add .
git commit . -m 'Initial Base Code - Starter'

git checkout -b dev master
git checkout master
git checkout -b staging dev
git checkout master
git push --all ##?? wait until html folders are done populated

echo "DONE PUSHING STARTER CODE TO REPOSITORY"
sleep 1
rm -rf /tmp/$projectName

##
##Call script to create database here
##

cd /var/www/html/$projectName-dev
git clone -b dev git@192.168.6.22:$gitProject.git /var/www/html/$projectName-dev/
ls
sleep 2

cd /var/www/html/$projectName-staging
git clone -b staging git@192.168.6.22:$gitProject.git /var/www/html/$projectName-staging/
ls

sleep 2 
clear