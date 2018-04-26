# -*- coding: utf-8 -*-
import os
import sys
import datetime
from flask import Flask,g,session, request, render_template, redirect,Response,jsonify
# 返回 Response 对象
from flask import make_response
# 反向生成url,接受函数名作为第一参数，以及一些关键字参数
from flask import url_for
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine
from flask_bootstrap import Bootstrap

import sys
reload(sys)
sys.setdefaultencoding('utf8')
# 本地测试上
import sqlite3
from contextlib import closing
from sqlalchemy import create_engine

basedir = os.path.abspath(os.path.dirname(__file__))
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] ='sqlite:///'+ os.path.join(basedir,'mydb.db')
app.config['SECRET_KEY']='这是个密码'

# eng = create_engine("sqlite:///D://MyWeb//mydb.db")
# conn = eng.connect()
# 初始化数据库
# def init_local_db():
#     conn.execute('insert into account values(null,"lgj","passwd_lgj",1,null,"2018-04-03 14:28:08",1,10000,'
#                  '"ikut=6399; baiduid=7a6fcff0b2b0c7b45df3e0e025ed0e75:fg=1; bidupsid=7a6fcff0b2b0c7b45df3e0e025ed0e75; '
#                  'pstm=1522986530; hm_lvt_6859ce5aaf00fb00387e6434e4fcc925=1522989588");')
#     conn.execute('insert into account values(null,"lgj","passwd_lgj",1,null,"2018-04-03 14:28:08",1,10000,'
#                  '"ikut=6399; baiduid=7a6fcff0b2b0c7b45df3e0e025ed0e75:fg=1; bidupsid=7a6fcff0b2b0c7b45df3e0e025ed0e75; '
#                  'pstm=1522986530; hm_lvt_6859ce5aaf00fb00387e6434e4fcc925=1522989588");')
#     conn.execute('insert into account values(null,"lgj","passwd_lgj",1,null,"2018-04-03 14:28:08",1,10000,'
#                  '"ikut=6399; baiduid=7a6fcff0b2b0c7b45df3e0e025ed0e75:fg=1; bidupsid=7a6fcff0b2b0c7b45df3e0e025ed0e75; '
#                  'pstm=1522986530; hm_lvt_6859ce5aaf00fb00387e6434e4fcc925=1522989588");')
#
#     temp=conn.execute('select * from account;')
#     print(temp.fetchall())

# 本地测试下
"""
# linux测试
app = Flask(__name__)
app.config['SECRET_KEY'] = 'a secret string'
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://scrapyer:scrapyer@127.0.0.1:3306/test?charset=utf8"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
"""
bootstrap=Bootstrap(app)
db = SQLAlchemy(app)

# 数据结构 MODEL
class account(db.Model):
    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(255), unique=False)
    password = db.Column(db.String(255), unique=False)
    status = db.Column(db.Integer, unique=False)
    create_time = db.Column(db.Date, unique=False)
    last_login = db.Column(db.Date, unique=False)
    account_type = db.Column(db.Integer, unique=False)
    maxfollows = db.Column(db.Integer, unique=False)
    cookie = db.Column(db.String(1500), unique=False)

    def __init__(self, username, password, status, account_type, maxfollows, cookie, create_time, last_login):
        self.username = username
        self.password = password
        self.status = status
        self.create_time = create_time
        self.last_login = last_login
        self.account_type = account_type
        self.maxfollows = maxfollows
        self.cookie = cookie

    def __repr__(self):
        return '<account :%s  %s  %s>' % (str(self.user_id), self.username, self.password)

class public(db.Model):
    public_id = db.Column(db.Integer, primary_key=True) # '公众号索引id',
    public_name = db.Column(db.String(255), unique=False) #公众号名字
    status = db.Column(db.String(255), unique=False) #公众号订阅状态未订阅，已订阅，拉黑:0,1,2
    public_type = db.Column(db.Integer, unique=False) #公众号类型 雪球/微博/微信：0/1/2 支持之后的账号类型扩充
    article_number = db.Column(db.Integer, unique=False) #公众号发文总数
    public_follows = db.Column(db.Integer, unique=False) #被订阅数
    last_published = db.Column(db.Date, unique=False) #最后一次发表文章时间
    subscriber = db.Column(db.Integer, unique=False) #被谁订阅

    def __init__(self, public_name, status, public_type, article_number, public_follows, subscriber,last_published):
        self.public_name = public_name
        self.status = status
        self.public_type = public_type
        self.article_number = article_number
        self.last_published = last_published
        self.public_follows = public_follows
        self.subscriber = subscriber

    def __repr__(self):
        return '公众号ID：%s 名称：%s 状态：%s 类型：%s 发文数：%s 订阅者: %s 上次发文时间: %s' % \
               (self.public_id, self.public_name,self.status,self.public_type,self.article_number, self.subscriber,self.last_published)
"""
    # 失败，异常等事件记录
    class business(db.Model):
        pass
"""
# 初始化数据库by sql
def init_db():
    today_date = datetime.date.today()
    db.create_all()
    user_1 = account('lgj111', 'passwd_lgj111', 1, 2131,1,"ikut=6399; baiduid=7a6fcff0b2b0c7b45df3e0e025ed0e75:fg=1;",create_time=today_date, last_login=today_date)
    db.session.add(user_1)
    db.session.add_all([public(u"财经", 1, 2, 1000, 100000, 1, last_published= today_date),
                        public(u"知乎财经", 1, 2, 1000, 100000, 1, last_published= today_date),
                        public(u"新浪财经", 1, 2, 1000, 100000, 2, last_published= today_date),
                        public(u"腾讯财经", 2, 2, 1000, 100000, 3, last_published= today_date),
                        public(u"知乎财经", 1, 1, 1000, 100000, 1, last_published= today_date),
                        public(u"百度财经", 1, 2, 1000, 100000, 5, last_published= today_date),
                        public(u"知乎财经", 4, 2, 1000, 100000, 1, last_published= today_date),
                        public(u"雪球财经", 1, 2, 1000, 100000, 8, last_published= today_date)
                        ])
    db.session.commit()

    # public_id = db.Column(db.Integer, primary_key=True)
    # public_name = db.Column(db.String(255), unique=False)
    # status = db.Column(db.String(255), unique=False)
    # public_type = db.Column(db.Integer, unique=False)
    # article_number = db.Column(db.Date, unique=False)
    # public_follows = db.Column(db.Integer, unique=False)
    # last_published = db.Column(db.Date, unique=False)
    # subscriber = db.Column(db.Integer, unique=False)


from flask_wtf import FlaskForm
from wtforms import StringField, BooleanField,SubmitField,PasswordField,IntegerField,SelectField,SelectMultipleField
from wtforms.validators import DataRequired, Required, Length
# 在这里定义form需要提交的数据的数目、类型、过滤规则等。
# StringField 类表示type="text"的<input>元素
# StringField 构造函数的参数validators指定一个由验证函数组成的列表，函数Required()确保提交不为空
# SubmitField 类表示type="submit"的<input>元素

class add_account_form(FlaskForm):
    username = StringField('username:', validators=[Required(), Length(3)])
    password = PasswordField("password:", validators=[Required(), Length(3)])
    status = IntegerField('status:', validators=[Required()])
    account_type = IntegerField('account_type:',  validators=[Required()])
    maxfollows = IntegerField('maxfollows:', validators=[Required()])
    submit = SubmitField('Submit')

class edit_account_form(FlaskForm):
    username = StringField('username:', validators=[Required(), Length(3)])
    password = PasswordField("password:", validators=[Required(), Length(3)])
    status = IntegerField('status:', validators=[Required()])
    account_type = IntegerField('account_type:',  validators=[Required()])
    maxfollows = IntegerField('maxfollows:', validators=[Required()])
    operate = SelectField('operate', choices=[
        ('update1', 'update'),
        ('delete1', 'delete'),
        ('lock1', 'lock')
    ])
    submit = SubmitField('submit')

class edit_public_form(FlaskForm):
    # public_name = StringField('public_name:', validators=[Required()])
    # status = IntegerField("status:", validators=[Required()])
    # public_type = IntegerField('public_type:', validators=[Required()])
    # article_number = IntegerField('article_number:',  validators=[Required()])
    # public_follows = IntegerField('public_follows:', validators=[Required()])
    # last_published = IntegerField('last_published:', validators=[Required()])
    # subscriber = IntegerField('subscriber:', validators=[Required()])
    operate = SelectField('operate', choices=['取消关注', '拉黑', '标记'])
    submit = SubmitField('Submit')

# API 部分
@app.route('/')
def index():
    # 查询所有用户并展示
    account_list = db.session.query(account.user_id,account.username, account.account_type).all()
    print("account_list:",account_list)
    return render_template('myindex.html', account_list=account_list)

# API 部分
@app.route('/edit/account/<int:user_id>',methods=['GET', 'POST'])
def edit_account_info(user_id):
    # 单用户信息展示并提供简单操作
    account_info = db.session.query(account).filter_by(user_id=user_id).first()
    account_info_list=(account_info.user_id,account_info.username,account_info.password,account_info.status,
                       account_info.account_type,account_info.maxfollows,account_info.cookie)
    print("account_info:",account_info_list)
    form = edit_account_form(formdata=account_info_list)
    today_date = datetime.date.today()
    if form.validate_on_submit():
            try:
                if form.operate.data == "update":
                    db.session.query(account).filter(account.user_id ==user_id).update(
                        {"username": form.username.data, "password": form.password.data,
                         "maxfollows":form.maxfollows.data})
                if form.operate.data == "delete":
                    db.session.query(account).filter_by(user_id = user_id).delete()
                if form.operate.data == "lock":
                    db.session.query(account).filter(account.user_id == user_id).update({"status": 1})
            except:
                db.session.rollback()
            return redirect(url_for('index'))
    return render_template('operate_account.html', form=form,user_id=user_id)

@app.route('/show/account/<int:user_id>',methods=['GET'])
def show_account_info(user_id):
    # 单用户信息展示并提供简单操作
    account_info = db.session.query(account).filter_by(user_id=user_id).first()
    account_info_list={
        "user_id":account_info.user_id,
        "username":account_info.username,
        "password":account_info.password,
        "status":account_info.status,
        "account_type":account_info.account_type,
        "maxfollows":account_info.maxfollows,
        "cookie":account_info.cookie
    }
    print("account_info:",account_info_list)
    return jsonify(account_info_list)

@app.route('/add/account',methods=['GET', 'POST'])
def add_account():
    form = add_account_form()
    today_date = datetime.date.today()
    if form.validate_on_submit():
            print("form.username:",form.username.data)
            print("form.password:", form.password.data)
            print("form.maxfollows:", form.maxfollows.data)
            try:
                new_user = account(form.username.data, form.password.data, form.status.data, form.account_type.data,
                                 form.maxfollows.data,"",create_time=today_date, last_login=today_date)
                print("new_user:",new_user)
                db.session.add(new_user)
                db.session.commit()
            except Exception as e:
                print("Exception is:", e)
                db.session.rollback()
            return redirect(url_for('index'))
    return render_template('add_account.html', form=form)

# 查看特定用户所有的关注信息
@app.route('/public/list/<int:user_id>', methods=["GET"])
def show_users_public(user_id):
    # 查询用户关注的公众号
    public_info = db.session.query(public).filter_by(subscriber=user_id).all()
    print("account_list:",public_info)
    return render_template('show_users_public.html', public_list=public_info,user_id=user_id)
"""
    # public_info = db.session.query(public).filter_by(user_id=user_id).all()
    # public_id = db.Column(db.Integer, primary_key=True)
    # public_name = db.Column(db.String(255), unique=False)
    # status = db.Column(db.String(255), unique=False)
    # public_type = db.Column(db.Integer, unique=False)
    # article_number = db.Column(db.Date, unique=False)
    # public_follows = db.Column(db.Integer, unique=False)
    # last_published = db.Column(db.Date, unique=False)
    # subscriber = db.Column(db.Integer, unique=False)
"""
# 关注、取关公众号
@app.route('/subscribe/public/', methods=["GET","PUT","DELETE"])
def subscribe():
    # 单用户信息展示并提供简单操作
    # /subscribe/public?user_id=XX&public_id=XX&operate=delete\unsubscribe\forbid
    user_id = request.args.get('user_id')
    public_id = request.args.get('public_id')
    operate = request.args.get('operate')
    print(u"从url获取参数：",user_id,public_id,operate)
    subscribe_info = db.session.query(public).filter_by(subscriber=user_id).filter_by(public_id=public_id)
    print("account_info:", subscribe_info)
    if subscribe_info:
        # choices=['取消关注', '拉黑', '取消拉黑']
        try:
            if operate == 'permit':
                db.session.query(public).filter_by(subscriber = user_id).filter_by(public_id=public_id).update({"status": 1})
                print(u"洗白账号成功")
            if operate == 'forbid':
                db.session.query(public).filter_by(subscriber = user_id).filter_by(public_id=public_id).update({"status": 2})
                print(u"拉黑账号成功")
            if operate == 'unsubscribe':
                db.session.query(public).filter_by(subscriber = user_id).filter_by(public_id=public_id).delete()
                print(u"取消订阅成功")
            db.session.commit()
        except Exception as e:
            print("Exception is:",e)
            db.session.rollback()
    return redirect(url_for('show_users_public',user_id=user_id))

if __name__ == '__main__':
    # init_db()
    app.run(debug=False, host='127.0.0.1', port=5000)  # 指定了debug模式，外部可访问的服务器，端口

