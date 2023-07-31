DATABASE_PASS='admin'
sudo yum update -y
sudo yum install epel-release -y
sudo yum install git mariadb-server -y    
sudo systemctl start mariadb
sudo systemctl enable mariadb
cd /tmp
git clone -b main https://github.com/hkhcoder/vprofile-project.git
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "delete from mysql.user where user='root' and host not in ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "delete from mysql.user where user=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "delete from mysql.db where db='test' or db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "flush privileges"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* to 'admin'@'localhost' identified by 'admin'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* to 'admin'@'%' identified by 'admin'"
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
sudo mysql -u root -p"$DATABASE_PASS" -e "flush privileges"
cd vprofile-project
mysql -u root -padmin accounts < src/main/resources/db_backup.sql
sudo systemctl restart mariadb
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart mariadb