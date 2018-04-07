# -*- coding: utf-8 -*-

from flask import Flask, session, request, render_template, redirect
# 返回 Response 对象
from flask import make_response
# 反向生成url,接受函数名作为第一参数，以及一些关键字参数
from flask import url_for
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import create_engine

app = Flask(__name__)
app.config['SECRET_KEY'] = 'a secret string'
app.config["SQLALCHEMY_DATABASE_URI"] = "mysql+pymysql://root:root@127.0.01:3306/lgj?charset=utf8"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
# app.config['DEBUG'] = True
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

class public(db.Model):
    public_id = db.Column(db.Integer, primary_key=True)
    public_name = db.Column(db.String(255), unique=False)
    status = db.Column(db.String(255), unique=False)
    public_type = db.Column(db.Integer, unique=False)
    article_number = db.Column(db.Date, unique=False)
    last_published = db.Column(db.Date, unique=False)
    subscriber = db.Column(db.Integer, unique=False)

    def __init__(self, username, public_name, status, public_type, article_number, last_published, subscriber):
        self.public_name = public_name
        self.status = status
        self.public_type = public_type
        self.article_number = article_number
        self.last_published = last_published
        self.subscriber = subscriber

    def __repr__(self):
        return '<public :%s  %s  %s>' % (str(self.public_id), self.public_name, self.subscriber)

# 初始化数据库
def init_db():
    db.create_all()

# API 部分
@app.route('/')
def index():
    user_agent = request.headers.get('User-Agent')
    return '<h1>Hello World of My Web!</h1><p>Your browser is %s</p>' % user_agent

# 返回特定用户所有的登陆信息
@app.route('/login/info/<int:name_id>', methods=["GET"])
def user_login_info(name_id):
    return '<h1>Hello, %s!</h1>' % name_id, 400

# 查看特定用户所有的关注信息
@app.route('/public/list/<int:name_id>', methods=["GET"])
def public_user(name_id):
    return '<h1>Hello, %s!</h1>' % name_id, 400

# 所有用户订阅的所有公众号---全景展示
@app.route('/public/list/all', methods=["GET"])
def public_list_all():
    pass

# 查看所有公众号
@app.route('/public/list', methods=["GET"])
def public_lists():
    pass

# 查看公众号黑名单
@app.route('/public/blacklist', methods=["GET"])
def public_blacklist():
    pass

# 关注公众号
@app.route('/subscribe/public/<int:name_id>/<int:public_id>', methods=["PUT"])
def subscribe():
    pass

# 取关公众号
@app.route('/unsubscribe/public/<int:name_id>/<int:public_id>', methods=["DELETE"])
def unsubscribe():
    pass

# 自动点赞
@app.route('/automatic/approbate/', methods=["PUT"])
def automatic_approbate():
    pass

# 自动发朋友圈,转发文章
@app.route('/automatic/show/', methods=["PUT"])
def automatic_show():
    pass

# 自动检查账号可用性
@app.route('/automatic/checkaccount/', methods=["PUT"])
def automatic_checkaccount():
    pass

# 关注好友
@app.route('/automatic/friends/', methods=["PUT"])
def automatic_friends():
    pass


""""
# return 的第二个参数定义返回码,'/user/<int:name>' 可以限制name的类型，去掉int就不再限制,methods定义方法
@app.route('/user/<int:name>', methods=["GET"])
def user(name):
    return '<h1>Hello, %s!</h1>' % name, 400

# 使用request进行参数的传值, http://127.0.0.1:5000/query_page?pageid=1&num=2
@app.route("/query_page")
def query_page():
    pageid = request.args.get("pageid")
    num = request.args.get("num")
    return "query page: {0} and {1}".format(pageid, num)

@app.route('/a')
def diy_response():
    response = make_response('<h1>This document carries a cookie!</h1>')
    response.set_cookie('answer', '42')
    return response

@app.route('/b')
def diy_redirect():
    return redirect('http://www.example.com')

@app.route('/')
def indexPage():
    return 'Index Page'


@app.route("/query_user")
def query_user():
    id = request.args.get("id")
    return "query user: {0}".format(id)


with app.test_request_context():
    print(url_for('indexPage'))
    print(url_for('query_user', id=100))

# 　· 反向构建通常比硬编码更具备描述性。更重要的是，它允许你一次性修改 URL， 而不是到处找 URL 修改。
# 　· 构建 URL 能够显式地处理特殊字符和 Unicode 转义，因此你不必去处理这些。
# 　· 如果你的应用不在 URL 根目录下(比如，在 /myapplication 而不在 /)， url_for() 将会适当地替你处理好。
"""""

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5000)  # 指定了debug模式，外部可访问的服务器，端口
