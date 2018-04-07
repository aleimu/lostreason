conda create --name myweb python=2.7
activate myweb

#查看这个环境下的包列表
conda list
#安装package
conda install -n myweb flask
#安装pip
conda install -n myweb pip
#通过pip安装
pip install selenium
pip install pymysql
pip install SQLAlchemy


pycharm创建项目的时候可以选择myweb环境，local



http://python.jobbole.com/81388/
https://www.cnblogs.com/xinyangsdut/p/7753994.html




1.在浏览器的地址栏输入：javascript:alert(document.cookie)  (不区分大小写)，就会弹出你在当前网页登录的cookie信息。
2.按F12进入浏览器的开发者模式——console——在命令行输入javascript:alert(document.cookie)，再回车


https://xueqiu.com/

mysql -h127.0.0.1 -u lgj -plgj
use lgj1;

CREATE TABLE item (
id INTEGER NOT NULL AUTO_INCREMENT,
body TEXT, 
category_id INTEGER, 
PRIMARY KEY (id), 
FOREIGN KEY(category_id) REFERENCES category (id)
);
