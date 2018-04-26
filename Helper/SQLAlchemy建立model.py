# -*- coding: utf-8 -*-
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine
from flask import Flask, session, request, render_template, redirect
app = Flask(__name__)
app.config['SECRET_KEY'] = 'a secret string'
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://lgj:lgj@127.0.0.1/lgj1?charset=utf8"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
# app.config['DEBUG'] = True
db = SQLAlchemy(app)


class account(db.Model):
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(255), unique=False)
    password = db.Column(db.String(255), unique=False)
    status = db.Column(db.Integer, unique=False)
    create_time = db.Column(db.Date, unique=False)
    last_login = db.Column(db.Date, unique=False)
    account_type = db.Column(db.Integer, unique=False)
    cookie = db.Column(db.String(1500), unique=False)

    def __init__(self, username, password, status, last_login, account_type, cookie, create_time=None):
        self.username = username
        self.password = password
        self.status = status
        self.create_time = create_time
        self.last_login = last_login
        self.account_type = account_type
        self.cookie = cookie

    def __repr__(self):
        return '<account :%s  %s  %s>' % (str(self.user_id), self.username, self.password)

# 增
user_1= account('lgj111','passwd_lgj111', 1,'2018-04-07 14:28:08', 1,"ikut=6399; baiduid=7a6fcff0b2b0c7b45df3e0e025ed0e75:fg=1;")
db.session.add(user_1)
db.session.add_all([
    account('lgj11111', 'passwd_lgj111', 1, '2018-04-07 14:28:08', 1,
            "ikut=6399; baiduid=7a6fcff0b2b0c7b45df3e0e025ed0e75:fg=1;"),
    account('lgj11122', 'passwd_lgj111', 1, '2018-04-07 14:28:08', 1,
            "ikut=6399; baiduid=7a6fcff0b2b0c7b45df3e0e025ed0e75:fg=1;"),
])
db.session.commit()
# 删
db.session.query(account).filter(account.user_id < 2).delete()
db.session.query(account).filter_by(user_id = 1).delete()
db.session.commit()
# 改
db.session.query(account).filter(account.user_id < 3).update({"username" : "nick", "password":"niubily"})
db.session.commit()
# 查
print(account.query.all())
db.session.query(account).filter_by(user_id=2).first()  # 查询role表中id为2的第一个匹配项目，用".字段名"获取字段值
ret = db.session.query(account).all()
print("ret1:",ret)
ret = db.session.query(account.username, account.password).all()
print("ret2:",ret)
ret = db.session.query(account).filter(account.username.like('lgj%')).all()
print("ret3:",ret)
ret = db.session.query(account).filter(account.username.like('lgj*')).first()
print("ret4:",ret)
# 排序
ret = db.session.query(account).order_by(account.username.desc()).all()
print("ret5:",ret)
ret = db.session.query(account).filter(account.id.user_id._in([46,33,23])).all()
print("ret6:",ret)
"""""
SQLAlchemy中filter()和filter_by()的区别
1、filter引用列名时，使用“类名.属性名”的方式，比较使用两个等号“==”,用于查询简单的列名，不支持比较运算符。
2、filter_by引用列名时，使用“属性名”，比较使用一个等号“=”,比filter_by的功能更强大，支持比较运算符，支持or_、in_等语法。
/*用户表*/
create table if not exists `account` (
  `user_id` int primary key auto_increment comment '账号索引，唯一',
  `username` varchar(255) not null comment '用户名，电话号等',
  `password` varchar(255) not null comment '登陆时必须的参数',
  `status` tinyint(1) not null comment '账号是否可用',
  `create_time` timestamp not null default current_timestamp on update current_timestamp comment '账号创建的时间',
  `last_login` time not null comment '上次登陆时间',
  `account_type` tinyint(1) not null comment '账号的类型，雪球/微博/微信：0/1/2',
  `cookie` varchar(1200) default null comment '登陆状态的cookie，对外提供登陆保持'
) engine=innodb default charset=utf8;
/*公众号表*/
create table if not exists `public`(
    public_id int primary key auto_increment comment '公众号索引id',
    public_name varchar(100) not null comment '公众号名字',
    status tinyint(1) not null comment '公众号订阅状态未订阅，已订阅，拉黑:0,1,2',
    public_type tinyint not null comment '公众号类型 雪球/微博/微信：0/1/2',
    article_number int(3) not null comment '公众号发文总数',
    last_published timestamp not null default current_timestamp on update current_timestamp comment '最近一次的发文时间',
    subscriber int not null comment '订阅者,account.user_id,不漏订阅,不重复订阅'
) engine=innodb default charset=utf8;
常见的SQLALCHEMY列类型.配置选项和关系选项
类型名称    python类型    描述
Integer int 常规整形，通常为32位
SmallInteger    int 短整形，通常为16位
BigInteger  int或long    精度不受限整形
Float   float   浮点数
Numeric decimal.Decimal 定点数
String  str 可变长度字符串
Text    str 可变长度字符串，适合大量文本
Unicode unicode 可变长度Unicode字符串
Boolean bool    布尔型
Date    datetime.date   日期类型
Time    datetime.time   时间类型
Interval    datetime.timedelta  时间间隔
Enum    str 字符列表
PickleType  任意Python对象  自动Pickle序列化
LargeBinary str 二进制
常见的SQLALCHEMY列选项
可选参数    描述
primary_key 如果设置为True，则为该列表的主键
unique  如果设置为True，该列不允许相同值
index   如果设置为True，为该列创建索引，查询效率会更高
nullable    如果设置为True，该列允许为空。如果设置为False，该列不允许空值
default 定义该列的默认值
"""""
def role_test():
    # 定义1个类(由db.Model继承)，注意这个类是数据库真实存在的，因为我是针对已有数据库做转化
    # 我的数据库结构见下图 其中role是数据库的一张表名
    class role(db.Model):
        # id是主键db.Column是字段名， db.INT是数据类型
        id = db.Column(db.INT, primary_key=True)
        name = db.Column(db.String(99), unique=False)
        name_cn = db.Column(db.String(99), unique=False)

        def __init__(self, id, name, name_cn):
            self.id = id
            self.name = name
            self.name_cn = name_cn

        def __repr__(self):
            return '<User %r>' % self.name

    # 初始化role 并插入数据库
    test_role1 = role(8, 'supervisol','超超超超级管理员哦')
    test_role2 = role(9, 'your try', '你试试哦')
    # 创建表，如果不存在
    db.create_all()
    db.session.add(test_role1)
    db.session.add(test_role2)
    db.session.commit()

    #查询数据库
    db.session.query(role).filter_by(id=2).first()  # 查询role表中id为2的第一个匹配项目，用".字段名"获取字段值
    db.session.query(role).all()  # 得到一个list，返回role表里的所有role实例
    db.session.query(role).filter(role.id == 2).first() # 结果与第一种一致
    # 获取指定字段，返回一个生成器 通过遍历来完成相关操作, 也可以强转为list
    db.session.query(role).filter_by(id=2).values('id', 'name', 'name_cn')
    # 模糊查询
    db.session.query(role).filter(role.name_cn.endswith('管理员')).all()  # 获取role表中name_cn字段以管理员结尾的所有内容
    # 修改数据库内容
    user = db.session.query(role).filter_by(id=6).first()  # 将role表中id为6的name改为change
    user.name = 'change'
    db.session.commit()
