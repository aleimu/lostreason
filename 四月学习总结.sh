#总结时间 2018.4.2-2018.4.26 

Anaconda2常用命令{

# 创建一个名为python34的环境，指定Python版本是3.4（不用管是3.4.x，conda会为我们自动寻找3.4.x中的最新版本）
conda create --name python34 python=3.4
 
# 安装好后，使用activate激活某个环境
activate python34 # for Windows
source activate python34 # for Linux & Mac
# 激活后，会发现terminal输入的地方多了python34的字样，实际上，此时系统做的事情就是把默认2.7环境从PATH中去除，再把3.4对应的命令加入PATH
 
# 此时，再次输入
python --version
# 可以得到`Python 3.4.5 :: Anaconda 4.1.1 (64-bit)`，即系统已经切换到了3.4的环境
 
# 如果想返回默认的python 2.7环境，运行
deactivate python34 # for Windows
source deactivate python34 # for Linux & Mac
 
# 删除一个已有的环境
conda remove --name python34 --all


# 安装scipy
conda install scipy
# conda会从从远程搜索scipy的相关信息和依赖项目，对于python 3.4，conda会同时安装numpy和mkl（运算加速的库）
 
# 查看已经安装的packages
conda list
# 最新版的conda是从site-packages文件夹中搜索已经安装的包，不依赖于pip，因此可以显示出通过各种方式安装的包

# 查看当前环境下已安装的包
conda list
 
# 查看某个指定环境的已安装包
conda list -n python34
 
# 查找package信息
conda search numpy
 
# 安装package
conda install -n python34 numpy
# 如果不用-n指定环境名称，则被安装在当前活跃环境
# 也可以通过-c指定通过某个channel安装
 
# 更新package
conda update -n python34 numpy
 
# 删除package
conda remove -n python34 numpy
# 更新conda，保持conda最新
conda update conda
 
# 更新anaconda
conda update anaconda
 
# 更新python
conda update python
# 假设当前环境是python 3.4, conda会将python升级为3.4.x系列的当前最新版本
}

pip与python环境配置{

# 激活环境
virtualenv venv
source venv/bin/activate

# 安装flask
pip install flask
# 安装 Bootstrap
pip install flask-bootstrap
# 安装 moment
pip install flask-moment
# 安装 script
pip install flask-script
# 安装 wtf
pip install flask-wtf
# 安装 SQLAlchemy
pip install flask-sqlalchemy

pip install pygooglechart --user

python web_server.py --tornado_port=1219

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
wget https://pypi.python.org/packages/6f/10/5398a054e63ce97921913052fde13ebf332a3a4104c50c4d7be9c465930e/setuptools-26.1.1.zip#md5=f81d3cc109b57b715d46d971737336db
unzip setuptools-26.1.1.zip
sudo python setup.py install

wget --no-check-certificate https://pypi.python.org/packages/e7/a8/7556133689add8d1a54c0b14aeff0acb03c64707ce100ecd53934da1aa13/pip-8.1.2.tar.gz#md5=87083c0b9867963b29f7aba3613e8f4a
tar -zxvf pip-8.1.2.tar.gz
cd pip-8.1.2
安装：
python setup.py install

vim ~/.bash_profile

pycharm创建项目的时候可以选择myweb环境，local

http://python.jobbole.com/81388/
https://www.cnblogs.com/xinyangsdut/p/7753994.html

https://www.cnblogs.com/sunshineyang/p/6818834.html  #python 时间模块小结（time and datetime）
# 时间转化
datetime.date.fromtimestamp(1408058729)
>>> time.time() -1000
1523443359.7678
t=datetime.datetime(2018, 3, 22, 13, 23, 45, 494000).timetuple()
time.mktime(datetime.datetime.now().timetuple())


>>> import time     
>>> import datetime                                     
>>> datetime.datetime.now()                             
datetime.datetime(2018, 4, 11, 19, 9, 1, 700000)        
>>>                                                     
>>> time.mktime(datetime.datetime.now().timetuple())    
1523444947.0                                            
>>> 60*60*24                                            
86400                                                   
>>> c=time.mktime(datetime.datetime.now().timetuple())  
>>> d=c-86400                                           
>>> datetime.date.fromtimestamp(d)                      
datetime.date(2018, 4, 10)    
}

mongo使用记录{
http://python.jobbole.com/tag/tornado/ 
http://www.runoob.com/mongodb/mongodb-operators-type.html #很好的mongo教程
https://www.cnblogs.com/nixingguo/p/7260604.html    #pymongo使用方法


符号含义示例示例含义
$regex匹配正则{'name': {'$regex': '^M.*'}}name以M开头
$exists属性是否存在{'name': {'$exists': True}}name属性存在
$type类型判断{'age': {'$type': 'int'}}age的类型为int
$mod数字模操作{'age': {'$mod': [5, 0]}}年龄模5余0
$text文本查询{'$text': {'$search': 'Mike'}}text类型的属性中包含Mike字符串
$where高级条件查询{'$where': 'obj.fans_count == obj.follows_count'}自身粉丝数等于关注数
https://docs.mongodb.com/manual/reference/operator/query/

创建一个在mydb数据库上具有读写访问权限的用户帐户。

> use mydb
> db.createUser({user: "lgj",pwd: "lgj",roles: ["readWrite"]}) 
> exit

MongoDB中的表叫做集合(Collection)，表中的记录叫做文档(Document)。一个文档记录就是一个JSON对象，对于Python来说，就是一个字典。
下面的代码就会在”users”集合中添加一条文档记录：
user = {'name':'Michael', 'age':18, 'scores':[{'course': 'Math', 'score': 76}]}
mongo.db.users.insert_one(user)

“mongo.db.users”用来获取名为”users”集合对象，类型是”pymongo.collection.Collection”，该对象上的”insert_one()”方法用来创建一条记录。

result = mongo.db.tests.insert_many([{'num': i} for i in range(3)])

# 数据库复制去代替重命名
db.adminCommand({renameCollection: "db1.test1", to: "db2.test2"})
db.copyDatabase('old_name', 'new_name'); 
use old_name 
db.dropDatabase(); 

use admin;
db.runCommand({renameCollection: "test.test", to: "test1.test"});
当你把所有的集合移动到了新的库下，就相当于把整个库重命名了。这会比copyDatabase快很多。

db.runCommand({renameCollection: "mdq_weixin.biz_info", to: "weixin_seed.biz_info"});
db.runCommand({renameCollection: "mdq_weixin.search_words", to: "weixin_seed.search_words"});
db.runCommand({renameCollection: "mdq_weixin.words_for_biz", to: "weixin_seed.words_for_biz"});

db.relationship.drop()
db.biz_article.drop()
db.createCollection('relationship')
db.createCollection('biz_article')

#分页显示
skip(n):表示跨过多少数据行
limit(n):取出的数据行的个数限制

for(var i=0;i<100;i++){
    db.data.insert({"id":i});
}
db.data.find({},{"_id":0})
{ "id" : 0 }
{ "id" : 1 }
............
{ "id" : 19 }
db.data.find({},{"_id":0}).skip(0).limit(5);
{ "id" : 0 }
{ "id" : 1 }
{ "id" : 2 }
{ "id" : 3 }
{ "id" : 4 }
db.data.find({},{"_id":0}).skip(5).limit(5);
{ "id" : 5 }
{ "id" : 6 }
{ "id" : 7 }
{ "id" : 8 }
{ "id" : 9 }

# 负责的查询与显示
db.relationship.find({"account_id":'10','account_name': {'$exists': true},'account_info.password': {'$exists': 'true'},'account_info.cookie': {'$exists': 'true'},'account_info.status': {'$exists': 'true'}},{"account_id":1,"account_name":1,"public_id":1,"_id":0,})

db.relationship.find({'public_id': {$regex: '.*'},"account_id":'10','account_info.follows': {'$exists': true},'account_name': {'$exists': true},'account_info.password': {'$exists': true},'account_info.cookie': {'$exists': 'true'},'account_info.status': 'normal'},{"account_id":1,"account_name":1,"public_id":1,"_id":0,})

字段为空"" 也是true，字段不存在才是false

                         
#查询特定键(select key1,key2 from table;)
print '-------------查询特定键--------'
print '-------------查询身高大于170,并只列出_id,high和age字段(使用列表形式_id默认打印出来,可以使用{}忽视_id):'
for r in collection_set01.find({'high':{'$gt':170}},projection=['high','age']):print r
print '\n'
print '--------------skip参数用法'
for r in collection_set01.find({'high':{'$gt':170}},['high','age'],skip=1):print r #skip=1跳过第一个匹配到的文档
for r in collection_set01.find({'high':{'$gt':170}},['high','age']).skip(1):print r #skip=1跳过第一个匹配到的文档
print '\n'
print '--------------limit参数用法'
for r in collection_set01.find({'high':{'$gt':170}},['high','age'],limit=1):print r #limit=2限制显示2条文档
for x in biz_info.find({'ctime': {'$gt': datetime.datetime(2018, 3, 22, 13, 23, 36, 405000)}},limit=3):
for x in biz_info.find({'ctime': {'$gt': datetime.datetime(2018, 3, 22, 13, 23, 36, 405000)}}).limit(3):
print '--------------用{}描述特定键'
for r in collection_set01.find({'high':{'$gt':170}},{'high':1,'age':1,'_id':False}):print r

print '---------------------多条件查询'
print collection_set01.find_one({'high':{'$gt':10},'age':{'$lt':26,'$gt':10}})

mongodb里比较，用 "$gt" 、"$gte"、 "$lt"、 "$lte"（分别对应">"、 ">=" 、"<" 、"<="），组合起来可以进行范围的查找。比如查昨天的，就可以用

db.CollectionAAA.find({ "CreateTime" : { "$gte" : ISODate("2017-04-20T00:00:00Z") , "$lt" : ISODate("2017-04-21T00:00:00Z") } }).count()  
注意，开始的时候日期使用 "2017-04-20" 和"2017-04-21"

db.mycol.find().pretty()

db.mycol.find({},{"title":1,_id:0}).sort({"title":-1})

> 按“_id”升序排序
> db.mycol.find({},{"title":1,_id:1}).sort({"_id":1})

db.biz_info.find({"date":{"$gte":("2018-03-23")}}).sort({"ctime":-1}).pretty()

db.biz_info.find({"ctime":{"$gte":ISODate("2018-03-22T13:23:38.876Z")}}).sort({"ctime":-1}).pretty().limit(10)


mongodb://[username:password@]host1[:port1][,host2[:port2]

1、安装pymongo
# pip install pymongo

2、连接mongodb
>>> import pymongo
>>> conn = pymongo.MongoClient(host=host,port=port,tz_aware=False)

3、获取数据库列表
>>> conn.database_names()
[u'test1', u'test2', u'admin', u'local']

4、连接数据库
>>> db = conn.get_database("db_name")

5、权限验证
>>> db.authenticate('username', 'password')
True

6、获取聚集列表 (聚集的概念类似于关系型数据库中的表)
>>> db.collection_names()
[u'account', u'role', u'item', u'online']

7、连接聚集
>>> account = db.get_collection("col_name")

8、查看聚集的一条记录
>>> account.find_one()

9、查看聚集的所有key (类似于关系型数据库中的字段)
>>> account.find_one().keys()

10、查看聚集的所有记录
>>> for i in account.find():
... print i

11、查看记录总数
>>> account.find().count()

12、根据条件查询多条记录
>>> for i in account.find({"name": "xxx"}):
... print i

13、对查询结果进行排序 (默认升序ASCENDING)
>>> account.find().sort("name", pymongo.ASCENDING)
>>> account.find().sort([("name", pymongo.ASCENDING), ("active_time", pymongo.DESCENDING)])

14、新增记录
>>> account.insert({"name": "mike", "active_time": "20130408"})

15、更新记录
>>> account.update({"name": "mike"}, {"$set": {"active_time": "20130408120000"}})
注：如果数据中没有键-值"name": "mike"， 会新增"active_time": "20130408120000"

16、删除记录 (不带条件表示全部删除)
>>> account.remove({"name": "mike"})

17. pycharm模糊不清匹配查询
方法1.
import re
{'xxx':re.compile('xxx')}
方法2. 
{'xxx':{'$regex':'xxx'}}

18.and or
account.find({ $or: [ { title: {$regex: 'test'} }, { intro: {$regex: 'test'} } ] })

# shell中的操作

直接使用help会列举出mongodb支持操作
#查看所有数据级别的操作
> db.help()
#查看集合级别的操作
> db.mycoll.help()
#列举数据库命令
> db.listCommands()
}

tornado使用记录{
#教程
http://www.tornadoweb.cn/documentation#_2
http://shouce.jb51.net/tornado/ch1.html
https://www.cnblogs.com/wupeiqi/articles/5702910.html
https://blog.csdn.net/qq_16234613/article/details/52223104


'''打开指定网页'''
class TemHandler(tornado.web.RequestHandler):

    def get(self):
        self.render('01in-out.html')


'''跳转指定路由'''
class RecHandler(tornado.web.RequestHandler):

    def get(self):
        self.redirect("/tem")


'''查看访问服务器的IP地址'''
class ReqHandler(tornado.web.RequestHandler):

    def get(self):
        self.write(self.request.remote_ip) # 浏览器显示IP地址
        print(type(self.request.remote_ip),repr(self.request.remote_ip)) # 显示在后台服务器上
        print(self.request.full_url)
        
# -*- coding:utf-8 -*-

import tornado.web
import tornado.httpserver
import tornado.options
import tornado.ioloop
from tornado.options import define,options

define('port', default=8080, help='run port', type=int)
define('version', default='0.0.1', help='version 0.0.1', type=str)


class SetHandler(tornado.web.RequestHandler):

    def get(self):
        self.write('set_header')
        self.set_header('aaa',111) # 设置响应头
        self.set_header('ccc',222)
        self.set_header('ccc',333) # 重复设置会覆盖前面的
        self.clear_header('ccc')   # 清除响应头
        self.add_header('ccc',333) # 增加响应头


class AddHandler(tornado.web.RequestHandler):

    def get(self):
        self.write('add_header')
        self.add_header('abc',444)  # 增加响应头


class SendHandler(tornado.web.RequestHandler):

    def get(self):
        self.write('send_error <br>')
        # self.flush()  # 如果加上这个flush会小小的中断一下 后面的send_error 不会执行 write 会执行
        # self.finish()  # 如果加上这个finish会彻底中断,后面的任何指令都不会执行
        self.write('我被执行了')
        self.send_error(404)


class NotFoundHandler(tornado.web.RequestHandler):

    def get(self, *args, **kwargs):
        self.send_error(404)   

    def write_error(self, status_code, **kwargs):
        self.render('error.html')



class StatusHandler(tornado.web.RequestHandler):

    def get(self, *args, **kwargs):  # 重写状态码
        self.write('set_status')
        self.set_status(200,'every good !')


'''工作流程'''
class IndexHandler(tornado.web.RequestHandler):

    def set_default_headers(self):
        print('-----set_default_headers:设置headers----')

    def initialize(self):
        print('----initialize: 初始化----')

    def prepare(self):
        print('----prepare:准备工作----')

    def get(self, *args, **kwargs):
        self.write('----get 处理请求----')

    def post(self, *args, **kwargs):
        self.write('----post 处理请求----')

    def write_error(self, status_code, **kwargs):
        self.render('error.html')

    def on_finish(self):
        print('----on_finish: 处理结束 释放资源----')
 

application = tornado.web.Application(
    handlers = [
    (r"/",SetHandler),
    (r"/add",AddHandler),
    (r"/send",SendHandler),
    (r"/status",StatusHandler),
    (r"/index",IndexHandler),
    (r"/(.*)",NotFoundHandler),
    ],
    template_path = './error',
    debug = True,
)

if __name__ == '__main__':
    print(options.port)
    print(options.version)
    tornado.options.parse_command_line()
    http_server = tornado.httpserver.HTTPServer(application)
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()
}

jqurey使用记录{

1.在浏览器的地址栏输入：javascript:alert(document.cookie)  (不区分大小写)，就会弹出你在当前网页登录的cookie信息。
2.按F12进入浏览器的开发者模式——console——在命令行输入javascript:alert(document.cookie)，再回车

$.ajax({
url: 'http://127.0.0.1:1218/public/review', 
type: "GET",
async: false,//true表示异步 false表示同步
contentType: "application/json",
dataType: 'json',
success: function(results) { 
var parsedJson = $.parseJSON(results); 
alert(parsedJson); 
}
error: function(){
alert("get error!");
} 
});

$("#button1").click(function(){
  $.get('http://127.0.0.1:1218/public/review',function(data,status){
    alert("Data: " + data + "\nStatus: " + status);
  });
});


前端跳转的一个总结吧。
我们可以利用http的重定向来跳转

window.location.replace("http://www.jb51.net");
使用href来跳转
window.location.href = "http://www.jb51.net";
使用jQuery的属性替换方法
$(location).attr('href', 'http://www.jb51.net');
$(window).attr('location','http://www.jb51.net');
$(location).prop('href', 'http://www.jb51.net')


$.all('*',function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "X-Requested-With");
    res.header("Access-Control-Allow-Methods","PUT,POST,GET,DELETE,OPTIONS");
    next();
});
//在客户端对ajax进行设定
$.ajaxSettings.crossDomain = true;



JSON.stringify() 方法用于将一个json值转为字符串；

JSON.parse() 方法用于将json字符串转化成对象；


$("#button2").click(function(){
    account_id = $('#name').val();
    $.ajax({
            type: "GET",
            url: 'http://localhost:1218/public/review', 
            async: false,
            dataType: 'json',
            success: function(results) { 
                var parsedJson = $.parseJSON(results); 
                alert(parsedJson); 
            }
    });
});


$("#mybutton").click(function(){
    name = $('#name').val();
    age = $('#age').val();
    data = {'name': name, 'age': age};
    $.ajax({
          type: 'POST',
          url: '',
          data: data,
          dataType: 'json',
          success: function(ret){
              name ='<div>' + ret.name + '</div>';
              sex ='<div>' + ret.sex + '</div>';
              $('#desc').html(name + sex);
        }
    });
});



/**
     * 获取数据ajax-get请求
     * @author laixm
     */
    $.sanjiGetJSON = function (url,data,callback){
        $.ajax({
            url:url,
            type:"get",
            contentType:"application/json",
            dataType:"json",
            timeout:10000,
            data:data,
            success:function(data){
                callback(data);
            }
        });
    };

    /**
     * 提交json数据的post请求
     * @author laixm
     */
    $.postJSON = function(url,data,callback){
        $.ajax({
            url:url,
            type:"post",
            contentType:"application/json",
            dataType:"json",
            data:data,
            timeout:60000,
            success:function(msg){
                callback(msg);
            },
            error:function(xhr,textstatus,thrown){

            }
        });
    };

    /**
     * 修改数据的ajax-put请求
     * @author laixm
     */
    $.putJSON = function(url,data,callback){
        $.ajax({
            url:url,
            type:"put",
            contentType:"application/json",
            dataType:"json",
            data:data,
            timeout:20000,
            success:function(msg){
                callback(msg);
            },
            error:function(xhr,textstatus,thrown){

            }
        });
    };
    /**
     * 删除数据的ajax-delete请求
     * @author laixm
     */
    $.deleteJSON = function(url,data,callback){
        $.ajax({
            url:url,
            type:"delete",
            contentType:"application/json",
            dataType:"json",
            data:data,
            success:function(msg){
                callback(msg);
            },
            error:function(xhr,textstatus,thrown){

            }
        });
    };
    
    
    
    
    
    
          关键词: <textarea  type="text" name="keywords" id='keywords_input',value="" style="width:1000px;height:300px;line-height:600px;word-break:break-all"/>
          
          
    $(".yes").click(function(){
        var account_id=$('#account_id').val()
        var weixinhao=$('#yes').val()
        console.log(account_id);
        console.log(yes);
        console.log("/manage/relationship/1?account_id="+account_id+"&public_id="+weixinhao+"&status=follow");
        $.ajax({
                url:"/manage/relationship/1?account_id="+account_id+"&public_id="+weixinhao+"&status=follow",
                type:"PUT",
                contentType : "application/json",
                success:function(result){
                    alert("success!");
                },
                error: function (jqXHR, textStatus, errorThrown) {
                            /*弹出jqXHR对象的信息*/
                            alert(jqXHR.responseText);
                            alert(jqXHR.status);
                            alert(jqXHR.readyState);
                            alert(jqXHR.statusText);
                            /*弹出其他两个参数的信息*/
                            alert(textStatus);
                            alert(errorThrown);
                        },

            });
    });
          
          
          
          
          
                error: function (jqXHR, textStatus, errorThrown) {
                            /*弹出jqXHR对象的信息*/
                            alert(jqXHR.responseText);
                            alert(jqXHR.status);
                            alert(jqXHR.readyState);
                            alert(jqXHR.statusText);
                            /*弹出其他两个参数的信息*/
                            alert(textStatus);
                            alert(errorThrown);
                        },
                        
                        
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                             alert(XMLHttpRequest.status);
                             alert(XMLHttpRequest.readyState);
                             alert(textStatus);
                    },
                    
                    
        var account_id=$('#account_id').val();
        var weixinhao=$(this).val();        //获取当前点击的值
        console.log(account_id);
        console.log(weixinhao);
        console.log($(".one_tr").text());
        console.log($("#one_tr").text());
        console.log($('#one_tr').val());
        console.log($('.one_tr').val());
        console.log($('.blog_2').val());
        console.log($('#blog_2').val());
        console.log($('.blog_2').text());
        console.log($('#blog_2').text());
        

    // 获取选择框中的值
    $(".get_publics").click(function(){
        var select_id_value =$("#select_id").val();//获取的是value
        var select_id_val = $("#select_id").find("option:selected").text();//ID:{{one_account[0]}} 账号:{{one_account[1]}}
        console.log(select_id_value,select_id_val)
        var public_id=$(this).val();//获取当前按钮的值
        console.log(public_id)
        var public_id=$(#public_id).val();//获取public_id的值
        console.log(public_id)
        if (public_id.length <1){
            alert("请输入需要查询的公众号");
        }
        else{
            /*从url中获取account_id*/
            var account_id=GetQueryString("account_id")
            console.log("/manage/relationship/1?account_id="+account_id+"&public_id="+public_id+"&status=unfollow");
            $.ajax({
                    url:"/manage/relationship/1?account_id=" + account_id + "&public_id=" + public_id + "&status=unfollow",
                    type:"GET",
                    contentType : "application/json",
                    success:function(result){
                        alert("success!");
                        $(location).attr('href', "/manage/relationship/1?account_id="+account_id+"&status=follow");
                    },
                    error: function (jqXHR, textStatus) {
                        /*弹出错误信息*/
                        alert(textStatus + " : "+ jqXHR.status + " " + jqXHR.statusText);
                    },
            });
        }
    }); 
    
    
    var cs = new table({
        "tableId":"cs_table",    //必须 表格id
        "headers":["媒体","公众号名称","公众号账号","月发文数","日抓取量","最新更文时间","继续关注？"],   //必须 thead表头
        "data":data,         //必须 tbody 数据展示
        "displayNum": 20,    //必须   默认 10  每页显示行数
        "groupDataNum":50,     //可选    默认 10  组数
        "display_tfoot":true, // true/false  是否显示tfoot --- 默认false
        "bindContentTr":function(){ //可选 给tbody 每行绑定事件回调
            this.tableObj.find("tbody").on("click",'tr',function(e){
                return false;
                var tr_index = $(this).data("tr_index");        // tr行号  从0开始
                var data_index = $(this).data("data_index");   //数据行号  从0开始
            })
        },
        sort:true,    // 点击表头是否排序 true/false  --- 默认false
        sortContent:[
            {
                index:0,//表头序号
                compareCallBack:function(a,b){ //排序比较的回调函数
                    var a=parseInt(a.id,10);
                    var b=parseInt(b.id,10);
                    if(a < b)
                        return -1;
                    else if(a == b)
                        return 0;
                    else
                        return 1;
                }
            },
            {
                index:3,//表头序号
                compareCallBack:function(a,b){ //排序比较的回调函数
                    var a=parseInt(a.age,5);
                    var b=parseInt(b.age,5);
                    if(a < b)
                        return -1;
                    else if(a == b)
                        return 0;
                    else
                        return 1;
                }
            }
    ],
        specialRows:[
            {
                row:4,
                cssText:{
                     "color":"#FFCF17"
                }
            }
        ],
        search:true   // 默认为false 没有搜索
    });
    
    
    var cs = new table({
        "tableId":"cs_table",  //必须
        "headers":["媒体","公众号名称","公众号账号","月发文数","日抓取量","最新更文时间","继续关注？"],   //必须 thead表头
        "data":data,    //必须
        "displayNum": 20,  //必须  默认 10
        "groupDataNum":50 //可选  默认 10
    });
    
    
public_id = $(this).parent().parent().find("td").eq(2);


        x = $(this).parent();
        y = x.parent();
        z = y.find("td").eq(2);
        alert(z.text())
        console.log('11111' + x.text());
        alert(z);
        var account_id=$("#select_id").find("option:selected").text();
        var public_id=$("tr td:eq(2)").text()
        
            
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="utf-8">
    <title>菜鸟教程(runoob.com)</title>
    </head>
    <body>

    <p>点击按钮显示或者关闭对话窗口。</p>
    <button onclick="showDialog()">显示对话窗口</button>
    <button onclick="closeDialog()">关闭对话窗口</button>
    <p><b>注意：</b>  目前只有Chrome Canary，Safari 6 浏览器支持 <dialog> 元素。</p>
    <dialog id="myDialog">这是一个对话窗口</dialog>
    <script>
    var x = document.getElementById("myDialog"); 
    function showDialog(){ 
        x.show(); 
    } 
    function closeDialog(){
        x.close(); 
    } 
    </script>

    </body>
    </html>



    function tankuang(pWidth,content)
    {    
        $("#msg").remove();
        var html ='<div id="msg" style="position:fixed;top:50%;width:100%;height:30px;line-height:30px;margin-top:-15px;"><p style="background:#000;opacity:0.8;width:'+ pWidth +'px;color:#fff;text-align:center;padding:10px 10px;margin:0 auto;font-size:12px;border-radius:4px;">'+ content +'</p></div>'
        $("body").append(html);
        var t=setTimeout(next,2000);
        function next()
        {
            $("#msg").remove();
            
        }
    }
        
        

    $(".axc-success").show().delay(3000).fadeOut();



    var HuiFang={
    m_tishi :null,//全局变量 判断是否存在p,
    //提示p 等待2秒自动关闭
    Funtishi: function (content, url) {
    if (HuiFang.m_tishi == null) {
    HuiFang.m_tishi = '<p class="xiaoxikuang none" id="app_tishi" style="z-index:9999;left: 15%;width:70%;position: fixed;background:none;bottom:10%;"> <p class="app_tishi" style="background: none repeat scroll 0 0 #000; border-radius: 30px;color: #fff; margin: 0 auto;padding: 1.5em;text-align: center;width: 70%;opacity: 0.8; font-family:Microsoft YaHei;letter-spacing: 1px;font-size: 1.5em;"></p></p>';
    $(document.body).append(HuiFang.m_tishi);
    }
    $("#app_tishi").show();
    $(".app_tishi").html(content);
    if (url) {
    window.setTimeout("location.href='" + url + "'", 1500);
    } else {
    setTimeout('$("#app_tishi").fadeOut()', 1500);
    }
    },
    }

    使用：
    HuiFang.Funtishi("请输入名字。");


        function sleep(numberMillis) {
            alert(1)
            var now = new Date();
            var exitTime = now.getTime() + numberMillis;
            while (true) {
                now = new Date();
                if (now.getTime() > exitTime){
                    return;
                    alert(2)
                }
            }
        }
        // 订阅结果消息闪现
        function flash_message2(message){
            $("#flash_message_id").text("")
            $("#flash_message_id").text(message);
            var t=setTimeout(next,2000);
            function next()
            {
                $("#flash_message_id").text("");
            }
        }
}

遇到的坑{

#RuntimeError: Working outside of application context.
    这个问题的原因是在没有激活程序上下文之前进行了一些程序上下文或请求上下文的操作 
    解决办法很简单就是推送程序上下文，在获得程序上下文后再执行相应的操作 
    方法 1
    from myapp import app#myapp是我的程序文件，里面初始了Flask对象app
    from flask import current_app
    with app.app_context():
        print current_app.name

    方法 2
    from myappimport app
    from flask import current_app
    app_ctx = app.app_context()
    app_ctx.push()
    print current_app.name
    app_ctx.pop()


#UnicodeEncodeError: 'latin-1' codec cant encode characters in position 0-1: ordinal not in range(256) Scrapy
    1.使用scrapy对数据进行入库时,出现如下错误:
    UnicodeEncodeError: 'latin-1' codec cant encode characters in position 0-1: ordinal not in range(256)
    解决方法,在sql.py中,或者是链接数据库时,添加:
    pymysql.connect(host='127.0.0.1', port=3306, user='root', passwd='root', db='entry_admin',charset="utf8")
    2.如果是其他情况出现的,可使用:
    create_engine('mysql+mysqldb://USER:@SERVER:PORT/DB?charset=utf8', encoding='utf-8')


#mongo 的角色 Built-In Roles（内置角色）: 
    1. 数据库用户角色: read、readWrite;
    2. 数据库管理角色: dbAdmin、dbOwner、userAdmin；
    3. 集群管理角色: clusterAdmin、clusterManager、clusterMonitor、hostManager；
    4. 备份恢复角色: backup、restore；
    5. 所有数据库角色: readAnyDatabase、readWriteAnyDatabase、userAdminAnyDatabase、dbAdminAnyDatabase
    6. 超级用户角色: root  
    // 这里还有几个角色间接或直接提供了系统超级用户的访问（dbOwner 、userAdmin、userAdminAnyDatabase）
    7. 内部角色: __system
    
    
    Read: 允许用户读取指定数据库
    readWrite: 允许用户读写指定数据库
    dbAdmin: 允许用户在指定数据库中执行管理函数，如索引创建、删除，查看统计或访问system.profile
    userAdmin: 允许用户向system.users集合写入，可以找指定数据库里创建、删除和管理用户
    clusterAdmin: 只在admin数据库中可用，赋予用户所有分片和复制集相关函数的管理权限。
    readAnyDatabase: 只在admin数据库中可用，赋予用户所有数据库的读权限
    readWriteAnyDatabase: 只在admin数据库中可用，赋予用户所有数据库的读写权限
    userAdminAnyDatabase: 只在admin数据库中可用，赋予用户所有数据库的userAdmin权限
    dbAdminAnyDatabase: 只在admin数据库中可用，赋予用户所有数据库的dbAdmin权限。
    root: 只在admin数据库中可用。超级账号，超级权限

# mysql 事务锁住了，需要手动kill进程
mysql> delete from entry_admin.et_pages where id=2653146;
ERROR 1205 (HY000): Lock wait timeout exceeded; try restarting transaction

https://blog.csdn.net/mayor125/article/details/76186661


}

flask的quick_form{

quick_form(form, action=".", method="post", extra_classes=None, role="form", form_type="basic", horizontal_columns=('lg', 2, 10), enctype=None, button_map={}, id="")
Outputs Bootstrap-markup for a complete Flask-WTF form.

Parameters:	
form – The form to output.
method – <form> method attribute.
extra_classes – The classes to add to the <form>.
role – <form> role attribute.
form_type – One of basic, inline or horizontal. See the Bootstrap docs for details on different form layouts.
horizontal_columns – When using the horizontal layout, layout forms like this. Must be a 3-tuple of (column-type, left-column-size, right-colum-size).
enctype – <form> enctype attribute. If None, will automatically be set to multipart/form-data if a FileField is present in the form.
button_map – A dictionary, mapping button field names to names such as primary, danger or success. Buttons not found in the button_map will use the default type of button.
id – The <form> id attribute.

}

杂碎{

mysql -h192.168.40.190 -uscrapyer -pscrapyer -P 3306
mysql -h127.0.0.1 -u lgj -plgj
mongo --port 27018 -u admin -p admin --authenticationDatabase admin
mysql -uroot -proot 
# 可以创建表
CREATE TABLE item (
id INTEGER NOT NULL AUTO_INCREMENT,
body TEXT, 
category_id INTEGER, 
PRIMARY KEY (id), 
FOREIGN KEY(category_id) REFERENCES category (id)
);


}

