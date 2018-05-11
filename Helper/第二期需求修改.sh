1、公众号审核前、和已订阅的公众号比较去重 ok
2、关键提供新增、预览、增加触发wxseeddiscover查询新增的关键词的按钮 ok 
3、公众号审核，增加显示目前已订阅数目，方便筛选 | 或者自动选择，不用下拉框 ok -自动选择订阅
4、关注后抓取的文章保留7天就够了，关注前抓取的文章保留1个月


5月微信计划：
1.后续取关功能添加补充，
2.通关关键词搜索公众号并检索文章，抓取点赞数，阅读数数据，做微信平台数据筛选功能筛选出可用微信号展示与检索页面。
3.行业概念微信号媒体扩充


# weixin manage config
define("weixin_seed_mongo", default='{{service.weixin_seed_mongo}}')
define("weixin_blog_mongo", default='{{service.weixin_blog_mongo}}')
define("weixin_follow", default='{{service.weixin_follow}}')
define("weixin_get_publicinfo", default='{{service.weixin_get_publicinfo}}')

# mysql config
define("mysql_host", default="{{service.mysql_host}}")
define("mysql_port", default={{service.mysql_port}})
define("mysql_db", default="{{service.mysql_db}}")
define("mysql_name", default="{{service.mysql_name}}")
define("mysql_passwd", default="{{service.mysql_passwd}}")



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


wget https://pypi.python.org/packages/6f/10/5398a054e63ce97921913052fde13ebf332a3a4104c50c4d7be9c465930e/setuptools-26.1.1.zip#md5=f81d3cc109b57b715d46d971737336db
unzip setuptools-26.1.1.zip
sudo python setup.py install

wget --no-check-certificate https://pypi.python.org/packages/e7/a8/7556133689add8d1a54c0b14aeff0acb03c64707ce100ecd53934da1aa13/pip-8.1.2.tar.gz#md5=87083c0b9867963b29f7aba3613e8f4a
tar -zxvf pip-8.1.2.tar.gz
cd pip-8.1.2
安装：
python setup.py install


sudo python -m pip install pygooglechart
python cmstat_server.py --tornado_port=1219



db.message.find({"self_username":{'$exists': true},"talker":{'$exists': true}},{"_id":0,"self_username":1,"talker":1}).pretty().limit(1)

db.runCommand({"distinct":"tokencaller","key":"Caller"})
db.tokencaller.distinct('Caller').length

> db.message.distinct("self_username")
[
	"wxid_7tsg3scve0uq22",
	"wxid_8ok657vxdj6c12",
	"wxid_mpnfqpza47di22",
	"wxid_ueb0hi8xmfvj22"
]

db.message.distinct("self_username","talker")
> db.message.distinct("talker").length
312

db.message.find({"self_username":"wxid_7tsg3scve0uq22"},{"_id":0,"talker":1})

printjson({ "talker" : "gh_5fa646b85173" })

distinct 去重返回一个数组，length 获取长度。
distinct 第一个参数是去重字段，第二个参数是筛选条件。
db.collectionName.distinct('trnrec.stunum', {"trnrec.rttype":0,"trnrec.createtime":{ $gte: ISODate("2017-11-23T00:00:00+0800"), $lt: ISODate("2017-11-24T00:00:00+0800")}}).length
db.inventory.find( { $or: [ { quantity: { $lt: 20 } }, { price: 10 } ] } )
上面的例子会查询集合inventory中所有字段quantity小于20或者price等于10的所有文档。


使用$or条件评估条款，MongoDB会扫描整个文档集合，如果所有的条件支持索引，MongoDB进行索引扫描，因此MongoDB使用索引执行$or表达式，$or中的所有表达式必须支持索引，否则的话MongoDB就会扫描整个集合。

当使用$or查询并且使用索引时，每个$or的条件表达式都可以使用自己的索引，考虑下面的查询：

db.inventory.find( { $or: [ { quantity: { $lt: 20 } }, { price: 10 } ] } )
支持上面的查询你不需要创建一个符合索引，而是在字段quantity上创建一个索引，在price上创建一个索引。
db.inventory.createIndex( { quantity: 1 } )
db.inventory.createIndex( { price: 1 } )

and查询指定同一个字段的多个查询条件


db.inventory.find( { $and: [ { price: { $ne: 1.99 } }, { price: { $exists: true } } ] } )

db.inventory.find( {
    $and : [
        { $or : [ { price : 0.99 }, { price : 1.99 } ] },
        { $or : [ { sale : true }, { qty : { $lt : 20 } } ] }
    ]
} )
以上字段将会查询price字段值等于0.99或1.99并且sale字段值为true或者qty小于20的所有文档；
使用隐式AND操作无法构建此查询，因为它不止一次使用$or操作；

http://weixin.sogou.com/weixinwap?pg=webSearchList&_rtype=json&ie=utf8&page=1&query=%E8%B4%A2%E7%BB%8F 

http://weixin.sogou.com/weixinwap?query=%E7%9F%A5%E4%B9%8E&type=1&ie=utf8&_sug_=y&_sug_type_=&s_from=input

url = "http://weixin.sogou.com/weixinwap?type=1&ie=utf8&s_from=input&query="

http://weixin.sogou.com/websearch/weixin/pc/anti_account.jsp?t=1525250614127&signature=dlLLl9kDNa*IDhyiMyKd0pfVt0gCFqYZiDTzQoFFH7*TVHx5yFjuNBr-5Mp2AijnxM48mzasdlHHTIxqBAuOQivKmZB6DvhK0kJ-2q*A-mwoKrk2NJiNdi6viv6ttVVX

"/websearch/weixin/pc/anti_account.jsp?t=1525251181995&signature=dlLLl9kDNa*IDhyiMyKd0pfVt0gCFqYZiDTzQoFFH7*TVHx5yFjuNBr-5Mp2AijnxM48mzasdlHHTIxqBAuOQjWVbBbG5eTGXAEOFFaG9sMgz1HI9UZLGzHiOhocZw0C";

http://weixin.sogou.com/websearch/weixin/pc/anti_account.jsp?t=1525250981402&signature=dlLLl9kDNa*IDhyiMyKd0pfVt0gCFqYZiDTzQoFFH7*TVHx5yFjuNBr-5Mp2AijnxM48mzasdlHHTIxqBAuOQg77jWHrwC0hgrpEr*pq04cP-Fz3bR86bdGh6wMawIUK


# 正式环境
http://192.168.209.85:14455/api/v1/wechat/get-gh-msg/自定义id

{"account_id": {'$regex': ".*"}, 'account_name': {'$exists': true},'account_info.status': "normal"}, {"account_id": 1, "account_name": 1, "public_id": 1, "_id": 0}



取消订阅 可能放到下个星期四、五号开发---2018/5/3


媒体选择 ---微信、雪球、知乎、微博、头条、
订阅数 
点赞数 ---针对文章
阅读数 ---针对文章
屏蔽ID
月更文数
更文间隔
备注

Media selection ---WeChat, Snowball, Zhihuo, Weibo, Headline,
Subscriptions
Like the number --- for articles
Reading number --- for articles
Mask ID
Monthly update
Interval
Note

爬虫抓取后自动关注、本地检查已关注的公众号的更文间隔决定取关与否。

db.createCollection('crawl_config')


db.crawl_config.insert({"source":"weixin","follow_num":1000,"mask_id":"gh_123;gh_234;gh_456","month_blogs":5,"interval_blogs":90,"read_num":2000,"like_num":1000,"note":"weixin config!"})



#定时任务
pip install python-crontab
通过命令crontab -e编写任务
crontab -l
https://pypi.org/project/python-crontab/
{
from crontab import CronTab
 
# 创建当前用户的crontab，当然也可以创建其他用户的，但得有足够权限
my_user_cron  = CronTab(user=True)
 
# 创建任务
job = my_user_cron.new(command='echo `date` >> ~/time.log')
 
# 设置任务执行周期，每两分钟执行一次
job.setall('*/2 * * * *')
 
# 当然还支持其他更人性化的设置方式，简单列举一些
job.minute.during(5,50).every(5)
job.hour.every(4)
job.day.on(4, 5, 6)
 
job.dow.on('SUN')
job.dow.on('SUN', 'FRI')
job.month.during('APR', 'NOV')
 
job.setall(time(10, 2))
job.setall(date(2000, 4, 2))
job.setall(datetime(2000, 4, 2, 10, 2))
 
# 同时可以给任务设置comment，这样就可以根据comment查询，很方便
job.set_comment("timelogjob")
 
# 根据comment查询，当时返回值是一个生成器对象，不能直接根据返回值判断任务是否#存在，如果只是判断任务是否存在，可直接遍历my_user_cron.crons
iter = my_user_cron.find_comment('timelogjob')
 
# 同时还支持根据command和执行周期查找，基本类似，不再列举
 
# 任务的disable和enable， 默认enable
job.enable(False)
job.enable()
 
# 最后将crontab写入配置文件
my_user_cron.write()

job_standard_output = job.run()
job.clear()
cron.remove_all('timelogjob')
}

{
#-*- coding:utf-8 -*-
import time
import sched
from threading import Timer

# 第一个工作函数
# 第二个参数 @starttime 表示任务开始的时间
# 很明显参数在建立这个任务的时候就已经传递过去了，至于任务何时开始执行就由调度器决定了
def worker(msg, starttime):
    print u"任务执行的时刻", time.time(), "传达的消息是", msg, '任务建立时刻', starttime


# 创建一个调度器示例
# 第一参数是获取时间的函数，第二个参数是延时函数
print u'----------  两个简单的例子  -------------'
print u'程序启动时刻：', time.time()
s = sched.scheduler(time.time, time.sleep)
s.enter(1, 1, worker, ('hello', time.time()))
s.enter(3, 1, worker, ('world', time.time()))
s.run()  # 这一个 s.run() 启动上面的两个任务

print u'睡眠２秒前时刻：', time.time()
time.sleep(2)
print u'睡眠２秒结束时刻：', time.time()

count = 0
def loopfunc(msg,starttime):
    global count
    print u'启动时刻：', starttime, ' 当前时刻：', time.time(), '消息 --> %s' % (msg)
    count += 1
    if count < 3:
        Timer(3, loopfunc, ('world %d' % (count), time.time())).start()

Timer(3, loopfunc, ('world %d' % (count), time.time())).start()
}




#嵌套更新、更新多个
后面加上可以更新多条的第四个参数，这时候需要用$set操作才能更新多条
db.swxx.update({"ZJHM":"xxxxxxxxxxxxxxxxxx"},{$set:{"ZJHM":"23060419730523301X"}},false,true)

update参数1：筛选条件
参数2：更新哪些字段
参数3：如果没有筛选到符合条件的记录，是否需要将参数2插入到集合中，默认false，不插入
参数4：默认false，一次更新一条；true一次更新多条，此时参数2需要使用$set操作

db.biz_article.update({"method":"insert"},{"data.talker": {'$set':'gh_e6262c43e36c'}})          # 错误
db.biz_article.update({"method":"insert"},{$set: {"data.talker":'gh_e6262c43e36c'}},false,true) #正确
db.biz_article.updateMany({"method":"insert"},{$set: {"data.talker":'gh_e6262c43e36c'}})

import datetime
import time
from pymongo import MongoClient

client_blog = MongoClient('mongodb://admin:admin@192.168.40.190:27018/wechat_v10?authSource=admin')
yesterday = datetime.datetime.fromtimestamp(time.time() - 15 * 60 * 60 * 24)
date_regex = {"$gte": yesterday}
talker_regex = {"data.talker": 'gh_e6262c43e36c', "utime": date_regex}
biz_article = client_blog["wechat_v10"]["biz_article"]
t1 = time.time()
public_blog_list = biz_article.find(talker_regex).limit(1000).sort("ctime", -1)
print public_blog_list.count()
for x in range(1000):
    public_blog_list = biz_article.find(talker_regex).limit(1000).sort("ctime", -1)
    public_blog_list.count()
t2 = time.time()
print(t2 - t1)
public_blog_list = biz_article.find(talker_regex).sort("ctime", -1).limit(1000)
print public_blog_list.count()
for x in range(1000):
    public_blog_list = biz_article.find(talker_regex).sort("ctime", -1).limit(1000)
    public_blog_list.count()

t3 = time.time()
print(t3 - t2)
 
""" sort和limit的先后 速度上没有差别
scrapyer@crawltest004:~/cmstatics$ python test.py 
187
4.06870102882
187
4.08342504501
"""

1、对手机上文章，点赞数，阅读数数据抓取，并对数据添加筛选功能 ，完成对公众号的评分
2、微信管理后台添加取关功能
3、增加配置模块，实现微信公众号发现、审核、关注、取关自动化
4、初期根据配置的关键词(500+)完成自动关注公众号(10000+)，达到微信公众号文章每日入网站待审核库提升到1.5W+的目标

点赞数，阅读数 由抓取的第一篇文章为准，发送给手机客户端，进行抓取，
post{
url:https://mp.weixin.qq.com/s?src=11&timestamp=1525415391&ver=855&signature=LLUVyyKixNiFuIHEebaLfJjbGDdnRMxqTVFYnDzAbGdrHKWVrcNP2UqwBezPG0mynCCxz3LyJjeIQu-OzeY4kaYYw0yaNH2J-KGp0feF25pPGP5PqGKfAQ0qzPn8*Vpi&new=1

public_id:zhihuribao

} 

body{
reads:500
likes:300
follows:4000
}





https://mp.weixin.qq.com/s?src=11&timestamp=1525415391&ver=855&signature=LLUVyyKixNiFuIHEebaLfJjbGDdnRMxqTVFYnDzAbGdrHKWVrcNP2UqwBezPG0mynCCxz3LyJjeIQu-OzeY4kaYYw0yaNH2J-KGp0feF25pPGP5PqGKfAQ0qzPn8*Vpi&new=1&pass_ticket=qMx7ntinAtmqhVn+C23mCuwc9ZRyUp20kIusGgbFLi0=&uin=MTc1MDA1NjU1&ascene=1


https://mp.weixin.qq.com/s?src=11&timestamp=1525415391&ver=855&signature=LLUVyyKixNiFuIHEebaLfJjbGDdnRMxqTVFYnDzAbGdrHKWVrcNP2UqwBezPG0mynCCxz3LyJjeIQu-OzeY4kaYYw0yaNH2J-KGp0feF25pPGP5PqGKfAQ0qzPn8*Vpi&new=1




https://mp.weixin.qq.com/s?timestamp=1525416025&src=3&ver=1&signature=QYFkGEQB0ajCr4tV*Fxn*Is9baqe5EldC3ydqHwDu8qgyYEmo0zAaOZIRCdvDpoiR4f3j6pQhV33XpI56oCBVbW0K6nOnN4EtPoMQBgag3Ytf0FLbGoLvaAdmWbeCBuUIy3BakLbxx0J07QTWd098RyXYbuExSFhmnlvPE1Kv9I=

https://mp.weixin.qq.com/s?timestamp=1525416048&src=3&ver=1&signature=QYFkGEQB0ajCr4tV*Fxn*E8-5KbwjwgqNld0XxYwoOI0nfT42t1Ce6PMyDunRoqe7YhzLxbYTwUu0lqBl5RAdLeDmLlOetTYclQy0wljRmlsBV8etT0Cp9kJwa*37Yqv3audGfl98OgWHfI3Ylln9OqvgIrT6ZlIZPgr1XEAXRM=




https://mp.weixin.qq.com/s?src=11&timestamp=1525415391&ver=855&signature=LLUVyyKixNiFuIHEebaLfJjbGDdnRMxqTVFYnDzAbGdrHKWVrcNP2UqwBezPG0mynCCxz3LyJjeIQu-OzeY4kaYYw0yaNH2J-KGp0feF25pPGP5PqGKfAQ0qzPn8*Vpi&new=1

16.20
https://mp.weixin.qq.com/s?src=11&timestamp=1525415391&ver=855&signature=LLUVyyKixNiFuIHEebaLfJjbGDdnRMxqTVFYnDzAbGdrHKWVrcNP2UqwBezPG0mynCCxz3LyJjeIQu-OzeY4kaYYw0yaNH2J-KGp0feF25pPGP5PqGKfAQ0qzPn8*Vpi&new=1



{u'summaryfull': u'\u4e00\u4e2a\u4e13\u5fc3\u5356\u65b0\u4e2d\u5f0f\u8c03\u914d\u5c45\u5bb6\u8336\u7684\u9017\u6bd4\u53f7.', u'image': u'http://wx.qlogo.cn/mmhead/Q3auHgzwzM6NZos9f4ibz3yEbvjdtjzddaWbc5tJEx5ORf5fJ780Ugg/0', u'encGzhUrl': u'http://mp.weixin.qq.com/profile?src=3&timestamp=1525423362&ver=1&signature=hyaM71u1oti2hUizKxcS49an4lgjD6xu7ll8325JVsBIi2u9FfxarFFU*vMg3yMRrq38KwIucOdv1pVxOO0QKg==', u'vip': u'1', u'weixinhao': u'zhihuchaye', u'authfull': u'\u957f\u6c99\u83ca\u82f1\u826f\u54c1\u724c\u7b56\u5212\u6709\u9650\u516c\u53f8', u'qrcode': u'http://weixin.qq.com/r/ekOxqYHEgNz-rcXK9xZo', u'auth_id': u'2', u'title': u'\u77e5\u4e4e\u8336\u4e5f', u'id': u'oIWsFt5qOEDRs36J4dw2QwkLpiAs', u'showurl': u'mp.weixin.qq.com/count/oIWs...', u'encQrcodeUrl': u'http://mp.weixin.qq.com/rr?src=3&timestamp=1525423362&ver=1&signature=pzqiqZMsB4gjMqU3*4ReIpsPU2uRwN5WQ3Zs1e9sgfV-gmU980Ag9VFiJHnRHxs4sEb2MYLIBz9q2v9qEk7px*1xhj-H3R7bLpq-j518q00=', u'auth': u'\u957f\u6c99\u83ca\u82f1\u826f\u54c1\u724c\u7b56\u5212\u6709\u9650\u516c\u53f8', u'tplid': u'554', 'nowpage': 1, u'date': u'2018-04-29', u'news': {u'headimage': u'http://wx.qlogo.cn/mmhead/Q3auHgzwzM6NZos9f4ibz3yEbvjdtjzddaWbc5tJEx5ORf5fJ780Ugg/0', u'pagesize': u'1k', u'imglink': u'http://mmbiz.qpic.cn/mmbiz_jpg/M5NRBJ2icPIbYhTSoicbHSR7TnQJUvPnauibicskodcibD8SyibJsKc8Wekr7ZJJsHWWD9vOIYnQiavm0IKicsv8UUicXdA/0?wx_fmt=jpeg', u'title': u'\u5206\u4eab\u56fe\u7247', u'sourcename': u'\u77e5\u4e4e\u8336\u4e5f', u'new_sn': u'AAAAAC1QTYO8_Gdx_Zko5ShROxE', u'title1': u'\u5206\u4eab\u56fe\u7247', u'isV': u'1', u'url': u'http://mp.weixin.qq.com/count/oIWsFt5qOEDRs36J4dw2QwkLpiAs/2247485028/1&scene=6', u'tplid': u'550', u'InnerURL': u'http://mp.weixin.qq.com/count/oIWsFt5qOEDRs36J4dw2QwkLpiAs/2247485028/1/AAAAAC1QTYO8_Gdx_Zko5ShROxE', u'date': u'2018-04-29', u'showurl': u'mp.weixin.qq.com/count/oIWs...', u'nonews': u'0'}, 'indexInPage': 1, u'name': u'\ue40a\u77e5\u4e4e\u8336\u4e5f\ue40b', u'pagesize': [u'1k', u'1k'], u'@docid': u'ab735a258a90e8e1-6bee54fcbd896b2a-7bf390ccfe91a9b317408ac6dae1a744', u'url': u'http://mp.weixin.qq.com/count/oIWsFt5qOEDRs36J4dw2QwkLpiAs', u'lastModified': u'1524975359', u'summary': u'\u4e00\u4e2a\u4e13\u5fc3\u5356\u65b0\u4e2d\u5f0f\u8c03\u914d\u5c45\u5bb6\u8336\u7684\u9017\u6bd4\u53f7.', u'nonews': u'0', u'encArticleUrl': u'http://mp.weixin.qq.com/s?src=11&timestamp=1525423362&ver=855&signature=p1wV0g1V5rEVcc6eyiMsyxdYlHy*WTST7v7sw0d4Co*Pu*JoUGwFGvgBbLi9LOyO2H-opWejAKH0pC1oeKolsz7wxwVCR026PZmYq5N-5Ikby21-mgqqV4YNzFI0mSUb&new=1'}

encGzhUrl 公众号主页，显示信息和10条最近的文章
encQrcodeUrl 二维码的url
encArticleUrl 最新的文章临时url




https://github.com/JMcn/anyproxy-docker
docker{

1.Dockerfile文件。

#This docker file uses the fedora image
#Version 1- Edition 1
#Author: Fredric,Zhu

FROM fedora_local:20
MAINTAINER fredric Fredric2010@outlook.com
ADD nodejs  /root/nodejs
RUN cd  /root/nodejs/node-v8.9.3-linux-x86/bin && cp node /usr/bin/node
RUN cd  /root/nodejs/node-v8.9.3-linux-x86/lib/node_modules/npm && ./configure && make install
RUN  /usr/bin/npm install -g anyproxy

WORKDIR /root/proxy
2.运行方式。

docker run -ti --privileged=true -v /home/fredric/proxy:/root/proxy -p 8001:8001 -p 8002:8002 --name=anyproxy_sh  anyproxy_local /bin/bash
执行方式，

docker start  anyproxy_sh
docker exec -ti anyproxy_sh anyproxy


docker的常用命令{
（1）docker  attach    
Attach to a running container：进入一个正在运行的容器
（2）docker  start
 Start a stopped container：启动一个停止的容器，让它的状态变为running
（3）docker  stop
     Stop a running container：停止一个正在运行的容器
（4）docker  rm
 Remove one or more containers：删除一个停止的容器（如果说这个容器是running状态时，先要执行docker stop命令，再执行docker rm命令，才能删除容器）
（5）docker  kill
  Kill a running container：删除一个正在运行的容器
（6）其他docker命令  
    build     Build an image from a Dockerfile
    commit    Create a new image from a container's changes
    cp        Copy files/folders from a container's filesystem to the host path
    create    Create a new container
    diff      Inspect changes on a container\'s filesystem
    events    Get real time events from the server
    exec      Run a command in an existing container
    export    Stream the contents of a container as a tar archive
    history   Show the history of an image
    images    List images
    import    Create a new filesystem image from the contents of a tarball
    info      Display system-wide information
    inspect   Return low-level information on a container
    load      Load an image from a tar archive
    login     Register or log in to a Docker registry server
    logout    Log out from a Docker registry server
    logs      Fetch the logs of a container
    port      Lookup the public-facing port that is NAT-ed to PRIVATE_PORT
    pause     Pause all processes within a container
    ps        List containers
    pull      Pull an image or a repository from a Docker registry server
    push      Push an image or a repository to a Docker registry server
    restart   Restart a running container
    rmi       Remove one or more images
    run       Run a command in a new container
    save      Save an image to a tar archive
    search    Search for an image on the Docker Hub 
    tag       Tag an image into a repository
    top       Lookup the running processes of a container
    unpause   Unpause a paused container
    version   Show the Docker version information
	wait      Block until a container stops, then print its exit code
}



192.168.40.162

service docker start

git clone https://github.com/JMcn/anyproxy-docker.git

sudo docker build /home/liugj/anyproxy-docker
sudo docker build -t lgj_nodejs /home/liugj/anyproxy-docker

sudo docker search anyproxy-docker

sudo docker build -t lgj_nodejs .

systemctl stop docker
echo "DOCKER_OPTS=\"\$DOCKER_OPTS --registry-mirror=http://f2d6cb40.m.daocloud.io\"" | sudo tee -a /etc/default/docker
service docker restart
 
比较快的镜像地址：

Docker 官方中国区
https://registry.docker-cn.com
1
网易
http://hub-mirror.c.163.com
1
ustc
https://docker.mirrors.ustc.edu.cn
 
docker run anyproxy-docker --registry-mirror=https://docker.mirrors.ustc.edu.cn


DockerFile{
分为四部分组成：基础镜像信、维护者信息、镜像操作指令和容器启动时执行指令。例如：

#第一行必须指令基于的基础镜像
From ubutu

#维护者信息
MAINTAINER docker_user  docker_user@mail.com

#镜像的操作指令
apt/sourcelist.list

RUN apt-get update && apt-get install -y ngnix 
RUN echo "\ndaemon off;">>/etc/ngnix/nignix.conf

#容器启动时执行指令
CMD /usr/sbin/ngnix
}

docker pull http://hub-mirror.c.163.com:5000/centos

docker pull http://hub.c.163.com/public/anyproxy-docker

sudo docker images http://hub-mirror.c.163.com:5000/centos





# 配置代理
http_proxy=hexin:hx300033@192.168.0.1:88
https_proxy=$http_proxy  
no_proxy=*.abc.com,10.*.*.*,192.168.*.*,*.local,localhost,127.0.0.1  
export http_proxy https_proxy no_proxy  

192.168.0.1，88，：hexin，密码：hx300033。


sudo docker images
lgj_nodejs                                                 latest                          b6df74936891        About an hour ago   695 MB
c49bfb61ab11


sudo docker run -d --name anyproxy -p "8001:8001" -p "8002:8002" -v $(pwd):/anyproxy jmcn/anyproxy-docker
sudo docker ps
sudo docker stop b26f54103cc4

docker run -it anyproxy:version /bin/bash

#进入容器
sudo docker run -it jmcn/anyproxy-docker /bin/bash



使用docker镜像nginx:latest以后台模式启动一个容器,并将容器命名为mynginx。

docker run --name mynginx -d nginx:latest
使用镜像nginx:latest以后台模式启动一个容器,并将容器的80端口映射到主机随机端口。

docker run -P -d nginx:latest
使用镜像nginx:latest以后台模式启动一个容器,将容器的80端口映射到主机的80端口,主机的目录/data映射到容器的/data。

docker run -p 80:80 -v /data:/data -d nginx:latest
使用镜像nginx:latest以交互模式启动一个容器,在容器内执行/bin/bash命令。

runoob@runoob:~$ docker run -it nginx:latest /bin/bash
root@b8573233d675:/# 


sudo docker run --net='host' -v /home/liugj/anyproxy-docker:/opt/sample_js -it jmcn/anyproxy-docker /bin/bash



var jsonstr =JSON.stringify(jsonObject );  
var jsonObject= jQuery.parseJSON(jsonstr);  
var str = '{ "name": "Violet", "occupation": "character" }'; 
var obj = str.parseJSON(); 
alert(obj.toJSONString()); 
}


坑
{
root@crawldev001:/opt/sample_js# anyproxy --port 8023 
the default rule for AnyProxy.
Anyproxy rules initialize finished, have fun!
(node:76) DeprecationWarning: 'GLOBAL' is deprecated, use 'global'
GUI interface started at : http://192.168.40.162:8002/
Http proxy started at 192.168.40.162:8023
Caught exception: Error: listen EADDRINUSE :::8002


在docker外把其他的anyproxy进程结束掉，只保留需要的
sudo docker ps |grep anyprox
sudo docker stop b26f54103cc4

}


https://mp.weixin.qq.com/s?src=11&timestamp=1525694401&ver=862&signature=E6*Fx6KKHx*NSnvowtSki6hQ5sAd4EzlXxC1S9*ofmC5r3fjLtv0Jfy*uC7V0WFSlUKcfThK9wjuQKBSlA9ZcCo65qzKwzSEgIvEVCSzb116ic1GatcG4F6lcid1fKYm&new=1

#encode

curl -v -X POST http://192.168.40.162:8002/getwxinfo -d "name=111&url=https%3a%2f%2fmp.weixin.qq.com%2fs%3fsrc%3d11%26timestamp%3d1525694401%26ver%3d862%26signature%3dE6*Fx6KKHx*NSnvowtSki6hQ5sAd4EzlXxC1S9*ofmC5r3fjLtv0Jfy*uC7V0WFSlUKcfThK9wjuQKBSlA9ZcCo65qzKwzSEgIvEVCSzb116ic1GatcG4F6lcid1fKYm%26new%3d1"








查询等操作运行优化 ---之后优化，需要先上线了解数据量再选优化方案
启动关闭需要脚本 --已有脚本存在
抓取数据冗余  --第二期中会做抓取过滤再入库处理
新增跟抓取合并 --
超过900弹窗提示错误 --第二期修改

# 导入文章数据
#/home/liugj
mongoimport --port 27018 -u admin -p admin --authenticationDatabase admin -d wechat_v10 -c biz_article --file ./biz_article.json --type json 
mongoexport --port 27018 -u admin -p admin --authenticationDatabase admin -d wechat_v10 -c biz_article -o ./biz_article_export.json --type json

db.biz_article.update({"username" : "wxid_kykrb8kn0tr522"},{"$set":{"utime" : ISODate("2018-05-08T17:05:57.265Z")}},{$set: {"data.talker":'gh_9dc3859f5c56'}},false,true)

account.update({"name": "mike"}, {"$set": {"active_time": "20130408120000"}})
 
data.talker

db.biz_article.update({"username" : "wxid_kykrb8kn0tr522"},{"$set":{"utime" : ISODate("2018-05-08T17:05:57.265Z")}},false,true)
db.biz_article.update({"username" : "wxid_kykrb8kn0tr522"},{$set: {"data.talker":'gh_9dc3859f5c56'}},false,true)


db.biz_article.find({"data.talker":"gh_9dc3859f5c56","data.content": {'$regex': ".*"},"utime":{$gte:ISODate("2018-05-01T17:05:57.265Z")}})


db.relationship.update({"public_id" : "gh_9dc3859f5c56"},{$set: {"public_info.public_talker":'gh_9dc3859f5c56'}},false,true)


('talker:', u'nickqvNt4m0RjPE5')
public_blog_list count:0
('talker:', u'nickxGfzlBJsP9Sp')
public_blog_list count:0
('talker:', u'nickpNvRjyg0EZiJ')
public_blog_list count:0
('talker:', u'nickvoWEYQNXtbdF')
public_blog_list count:0
('talker:', u'nickAh4kxu6shdg1')
public_blog_list count:0
('talker:', u'nickx57JAxKtLSJY')
public_blog_list count:0
('talker:', u'nickcQx1mOUMg3gQ')
public_blog_list count:0


# 检索6小时以内的抓取文章
time_regex = datetime.datetime.fromtimestamp(time.time() - 60 * 60 * 6)
blogs_info_list = self.biz_info.find({"ctime": {"$gte": time_regex}},
                                     {"_id": 0, "utime": 1,"weixinhao":1,
                                      "encArticleUrl":1,"authfull":1,"month_blogs":1}).limit(5000)
crawl_config = self.crawl_config.find_one({"source":"weixin"})
crawl_config.get("month_blogs")

account_info_listall = {
    "jsz1993":["JohnCx","周筱鲁"],
    "rustgolang":["wxid_mpnfqpza47di22","Zoe"],
    "buchiyudegou":["wxid_hnxit03r8q9722","feimao"],
    "y_h_d_t":["wxid_19skfm8ksdxo22","硬汉赌徒"],
    "thszq001":["wxid_8ok657vxdj6c12","筱筱"],
    "thszq002":["wxid_kg4x3smbwiyk22","秋瑾"],
    "thszq003":["wxid_tkvuo6cxjt2o22","樱花"],
    "iFinD_test":["wxid_qi1axrf93ril12","iFinD移动终端测试"],
    "kanhujiandefengjinga":["wxid_phtnk47jjs0622","看不见的风景"],
    "meiguihuadezangli":["wxid_yakkybhj2e8e22","玫瑰花的葬礼"],
    "aichimaodeyuaaa":["wxid_slyofeu3eo1p22","爱吃猫的鱼"],
    "THS-17316900047":["wxid_kykrb8kn0tr522","taohua"],
    "mutourenshishui":["wxid_8kbskd7b5de722","木头人"],
}



db.biz_article.update({"method":"insert"},{$set: {"data.talker":'gh_a1071eb140c7'}},false,true)
db.biz_article.update({"method":"insert"},{$set:{"utime":ISODate("2018-05-10T18:46:55.079Z")}},false,true)


db.biz_article.find({'data.talker': 'gh_040f76975ea1'}).pretty()

db.biz_article.find({'data.talker': 'gh_a1071eb140c7'}).pretty()


async: true,
beforeSend: function () {
    $("p").hide();
},
complete: function () {
    $("p").show();
},

$("img").css("display","none");




#缓存数据库
biz_article_cache

db.biz_article_cache.createIndex({"account_id":1},{'background': true})


source      #平台
account_id  #账号ID
public_id   #公众号ID
public_name #公众号名字
blogs:[{"url":get_weixin_url(one_blog.get("data").get("content",None)),"title":"aaaaddad","utime":"2018.5.13"},{"title": get_weixin_title(one_blog.get("data").get("content",None)),"title":"aaaaddad","utime":"2018.5.13"},]
            # 近期文章列表---去重
refresh_time #最近一次刷新数据库时间
month_num   #月发文数
day_num    # 日发文数
lastblog_time   #最近文章的时间


                "account_id": x.get("account_id", None),
                "public_id": x.get("public_id"),
                "public_name": x.get("public_info").get("public_name", ""),
                "source": "weixin",
                "month_blog_num": month_blog_num,       # 月发文数
                "day_blog_num": day_blog_num,           # 日发文数
                "new_blog_date":last_blog_time,         # 最新文章的时间
                "refresh_time": datetime.datetime.now(),# 上次刷新缓存数据库时间
                "blogs":month_blogs,                    # 文章列表
                
                

db.biz_article_cache.insert({"source":"weixin","account_id":"account_id","public_id":"public_id","blogs":[],"refresh_time":123,"month_blog_num":10,"day_blog_num":2})
db.biz_article_cache.findOneAndReplace({"score": 123},{"team":"Therapeutic Hamsters", "score" : 22250 },{sort:{"score":1},project: {"_id":0,"team" : 1 }})
db.biz_article_cache.findOneAndUpdate({"account_id":"account_id1"},{"source":"weixin","account_id":"account_id","public_id":"public_id","blogs":[],"refresh_time":123,"month_blog_num":10,"day_blog_num":2})


# 不存在就创建,自动组合条件和后面的$set项，拼接成完整记录
db.biz_article_cache.update({"account_id":"account_id","public_id":"public_id"},{$set:{"source" : "weixin","blogs" : [ ], "refresh_time" : 123, "month_blog_num" : 10, "day_blog_num" : 2}},{upsert:true})

> db.biz_article_cache.update({"account_id":"*****","public_id":"public_id"},{$set:{"source" : "weixin","blogs" : [ ], "refresh_time" : 123, "month_blog_num" : 10, "day_blog_num" : 2}},{upsert:true})
WriteResult({
	"nMatched" : 0,
	"nUpserted" : 1,
	"nModified" : 0,
	"_id" : ObjectId("5af5495d1e0ad9218447d98a")
})
> 
> db.biz_article_cache.find().count()
6
> 
> 
> db.biz_article_cache.update({"account_id":"*****","public_id":"public_id"},{$set:{"source" : "weixin","blogs" : [ ], "refresh_time" : 123, "month_blog_num" : 10, "day_blog_num" : 2}},{upsert:true})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 0 })
> db.biz_article_cache.find().count()
6

> db.biz_article_cache.find({"account_id":"*****","public_id":"public_id"})
{ "_id" : ObjectId("5af5495d1e0ad9218447d98a"), "account_id" : "*****", "public_id" : "public_id", "source" : "weixin", "blogs" : [ ], "refresh_time" : 123, "month_blog_num" : 10, "day_blog_num" : 2 }