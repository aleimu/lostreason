# -*- coding:utf-8 -*-
import re
import time
import datetime
import json
from bson import ObjectId
import traceback
import requests
import os.path
import tornado.locale
import tornado.httpserver
import tornado.ioloop
import tornado.web
from tornado.options import define, options
from pymongo import MongoClient
# from allbiz.Api import allbiz_weixin


import sys

reload(sys)
sys.setdefaultencoding('utf8')
define("port", default=8001, help="run on the given port", type=int)
weixin_max_follow = 900


# 自定义功能函数


def date_to_str(origin_data):
    for x in origin_data:
        if str(type(origin_data.get(x))) == "<type 'datetime.datetime'>":
            origin_data[x] = origin_data.get(x).isoformat()
    return origin_data


def get_weixin_url(data):
    return re.findall(u'http\://mp.weixin.qq.com[a-zA-Z0-9\.\?/&\=\:_]+', data)


# app 配置
class Application(tornado.web.Application):
    def __init__(self):
        handlers = [(r'/', PublicReviewHandler),
                    (r'/search/blogs?(.*?)', PublicBlogHandler),
                    (r'/manage/relationship?(.*?)', ManageRelationshipHandler),
                    (r'/keywords/?(.*?)', KeywordsHandler)
                    ]
        settings = dict(
            template_path=os.path.join(os.path.dirname(__file__), "templates"),
            static_path=os.path.join(os.path.dirname(__file__), "static"),
            debug=False,
        )
        client = MongoClient('localhost', port=27017)
        # if client["mdq_weixin"].authenticate(
        # "lgj", "lgj", mechanism="SCRAM-SHA-1"):
        if client["admin"].authenticate("kb", "kb", mechanism="SCRAM-SHA-1"):
            # 存储未登陆前抓取的公众号和单个文章
            self.biz_info = client["mdq_weixin"]["biz_info"]
            # 存储账号和微信号的关系，对应微信内部编号后的公众号ID
            self.relationship = client["relationship"]["relationship"]
            # 订阅后抓取的公众号推送的文章，内涵编号后的公众号ID
            self.biz_article = client["relationship"]["biz_article"]
            self.words_for_biz = client["mdq_weixin"]["words_for_biz"]
        tornado.web.Application.__init__(self, handlers, **settings)


# 爬虫关键词配置
class KeywordsHandler(tornado.web.RequestHandler):
    # 微信公众号审核平台接口，提供最新抓取的公众号信息，以供筛选
    # curl http://127.0.0.1:8001/keywords
    def get(self, urlinfo=None):
        self.words_for_biz = self.application.words_for_biz
        keywords = []
        for x in self.words_for_biz.find({}, {"word": 1, u'_id': 0}):
            keywords.append(x.get("word"))
        if keywords:
            self.write(';'.join(keywords))

    # curl -X PUT "http://127.0.0.1:8001/keywords" -d
    # '{"keywords":"zhiaahu;laaiu;awho;daawda;我是a"}'
    def put(self, urlinfo=None):
        keywords = json.loads(self.request.body).get('keywords')
        print("keywords:", keywords)
        if not keywords:
            # set_status自定义返回的错误 reason
            self.set_status(status_code=500, reason="not find keywords!")
            self.write_error(status_code=500)
        new_keywords = set(keywords.split(";"))
        old_keywords = set()
        self.words_for_biz = self.application.words_for_biz
        for x in self.words_for_biz.find({}, {"word": 1, u'_id': 0}):
            old_keywords.add(x.get("word"))

        add_keywords = new_keywords - old_keywords
        del_keywords = old_keywords - new_keywords
        # 新增
        if add_keywords:
            time_new = datetime.datetime.now()
            insert_many_list = []
            for x in add_keywords:
                insert_many_list.append(
                    {"word": x, "biz_count": 0, "ctime": time_new})
            self.words_for_biz.insert_many(insert_many_list)
        # 删除
        if del_keywords:
            for x in del_keywords:
                self.words_for_biz.delete_one({'word': x})
        self.write({'edit': "success!"})


# 关注前的抓取的博文检索
class PublicReviewHandler(tornado.web.RequestHandler):
    # 微信公众号审核平台接口，提供最新抓取的公众号信息，以供筛选
    # curl http://127.0.0.1:8001
    def get(self, urlinfo=None):
        self.biz_info = self.application.biz_info  # 存放微信公众号种子，待人工审核
        yesterday = datetime.datetime.fromtimestamp(
            time.time() - 25 * 60 * 60 * 24)
        regex = {"ctime": {"$gte": yesterday}}
        print("regex:", regex)
        # 按时间降序排列
        self.revie_blog_list = self.biz_info.find(
            regex).sort("ctime", -1).limit(300)
        # 组装body体
        self.blog_list = []
        for x in self.revie_blog_list:
            self.blog_list.append({
                "id": x.get("id"),  # mongo存储标记
                "public_id": x.get("public_id"),
                "public_name": x.get("name"),  # 公众号中文名称
                "summaryfull": x.get("summaryfull"),  # 公众号功能描述，简介
                "public_follows": x.get("public_follows"),  # 关注数 微信文章一般获取不到
                "ctime": x.get("ctime").isoformat(),  # 抓取时间
                "source": x.get("source", "微信"),  # 信息源
                "weixinhao": x.get("weixinhao"),  # 微信公众号的名字
                "authfull": x.get("authfull", None),  # 是否微信认证
                "month_blogs": x.get("month_blogs", None),  # 月发文数，目前数据库中没有记录
                "title": x.get("title"),  # 文章、公众号名称
                "blogs_title": x.get("new", {}).get("title", None),  # 文章标题
                "blogs_data": x.get("new", {}).get("data", None),  # 文章标题
                "blogs_url": x.get("new", {}).get("url", None)  # 文章标题
            })
        print("self.public_list:", self.blog_list)
        req_body = {"public_list": self.blog_list}
        if self.blog_list:
            self.write(req_body)

    # 已订阅的不良公众号的筛选
    def put(self, urlinfo=None):
        pass

    # curl -X DELETE "http://127.0.0.1:8001"    提供删除抓取到的种子的接口
    def delete(self, urlinfo=None):
        yesterday = datetime.datetime.fromtimestamp(
            time.time() - 30 * 60 * 60 * 24)
        regex = {"ctime": {"$lt": yesterday}}
        print("regex:", regex)
        # 按时间删除
        self.biz_info = self.application.biz_info
        deleted_count = self.biz_info.delete_many(regex).deleted_count
        self.write({"deleted_count": deleted_count, 'edit': "ok"})


# 关注后的抓取的博文检索(source,accou_id,public_id不支持正则,keywords,url支持正则)
class PublicBlogHandler(tornado.web.RequestHandler):
    # curl "http://127.0.0.1:8001/search/blogs?keywords=XXX&source=weixin&accou_id=hehe&public_id=XXX&url=XXXXXX"
    # accou_id 传入后转化成 account_name,public_id转化成
    # alias_name或者public_name，由参数source决定
    def get(self, urlinfo=None):
        # 获取url入参
        account_id = self.get_argument("account_id", default="")  # 账号ID
        public_id = self.get_argument("public_id", default="")  # 公众号ID
        keywords = self.get_argument("keywords", default="")  # 订阅状态
        source = self.get_argument("source", default="")  # 信息源
        url = self.get_argument("url", default="")

        print(
            "account_id :%s ,public_id :%s ,keywords: %s ,source: %s ,url: %s" %
            (account_id, public_id, keywords, source, url))
        # 初始化数据库
        # 订阅后抓取的公众号推送的文章，内涵编号后的公众号ID
        self.biz_article = self.application.biz_article
        # 存储账号和微信号的关系，对应微信内部编号后的公众号ID
        self.relationship = self.application.relationship
        # curl "http://127.0.0.1:8001/search/blogs?keywords=&source=&account_id=&public_id=&url=&data="
        if account_id == "" and public_id == "" and keywords == "" and source == "" and url == "":
            self.public_blog_list = self.biz_article.find().limit(1000)
            print("self.public_blog_list;", self.public_blog_list)
            self.blog_list = []
            for x in self.public_blog_list:
                public_talker = x.get("data", None).get("talker")
                print ("public_talker:", public_talker)
                self.public_info = self.relationship.find_one({"public_info.public_talker": public_talker})
                public_id = self.public_info.get("public_id", None)
                public_name = self.public_info.get("public_info").get("public_name")
                if "wxid" in x.get("username", "") or "gh_" in public_talker:
                    source = "weixin"
                else:
                    source = None
                self.blog_list.append({
                    "public_id": public_id,  # 公众号ID
                    "public_name": public_name,  # 公众号中文名字
                    "title": x.get("title", None),  # 标题
                    # 文章url,
                    "url": get_weixin_url(x.get("data").get("content", "")),
                    "date": x.get("utime").isoformat(),  # 爬到的时间
                    "source": source  # 平台
                })
                print("x:", x)
            req_body = {"blog_list": self.blog_list}
            self.write(req_body)
        else:
            # curl "http://127.0.0.1:8001/search/blogs?keywords=weixin&source=weixin&accou_id=aa&public_id=zhihu&url=&data=1"
            yesterday = datetime.datetime.fromtimestamp(time.time() - 15 * 60 * 60 * 24)
            # 存储账号和微信号的关系，对应微信内部编号后的公众号ID
            self.relationship = self.application.relationship
            # 通过account_id查询得到微信用户别名
            print(account_id)
            print('self.relationship.find_one({"account_id": account_id}):',
                  self.relationship.find_one({"account_id": account_id}))
            alias_name = self.relationship.find_one({"account_id": account_id}).get("account_info").get("alias_name",
                                                                                                        ".*")
            # 通过public_id查询得到微信公众号别名
            public_talker = self.relationship.find_one({"public_id": public_id}).get("public_info").get("public_talker",
                                                                                                        ".*")
            keywords_regex = {'$regex': keywords}
            source_regex = {'$regex': source}
            date_regex = {"$gte": yesterday}
            regex = {
                "username": alias_name,
                "data.content": keywords_regex,
                "data.talker": public_talker,
                "utime": date_regex}
            print("regex:",
                  regex)  # ('regex:', {'username': u'eeee', 'data.talker': u'dddd', 'data.content': {'$regex': u'.*'}, 'utime': {'$gte': datetime.datetime(2018, 3, 29, 20, 41, 8, 920246)}})

            # 按时间降序排列
            self.public_blog_list = self.biz_article.find(
                regex).sort("ctime", -1)
            print("self.public_info_list;", self.public_blog_list)
            self.public_list = []
            for x in self.public_blog_list:
                self.public_list.append({
                    "public_name": x.get("public_name"),  # 公众号中文名字
                    "title": x.get("title", None),  # 标题
                    "url": get_weixin_url(x.get("data").get("content", "")),  # 文章url,
                    "date": x.get("utime").isoformat(),  # 爬到的时间
                    "source": x.get("source")  # 平台
                })
                print("x:", x)
            req_body = {"public_list": self.public_list}
            self.write(req_body)

    # curl -X DELETE "http://127.0.0.1:8001/public?public_id=oIWsFtyFbGBAOKwA3JdLusG6VMtw&status=1&test=test11"
    def delete(self, urlinfo=None):
        public_id = self.get_argument("public_id")
        print("get:", public_id)
        # 删除
        self.biz_article = self.application.biz_article  # 订阅后抓取的公众号推送的文章，内涵编号后的公众号ID
        self.biz_article.delete_one({"id": public_id})
        self.public_blog = self.biz_article.find_one({"id": public_id})
        if not self.public_blog:
            self.write({'delete': "ok", "public_id": public_id})


# 账号与公众号关系管理
class ManageRelationshipHandler(tornado.web.RequestHandler):
    # 查询是否关注或被谁关注/查询微信号中关注的所有公众号,提供正则匹配功能
    def get(self, urlinfo=None):
        account_id = self.get_argument("account_id", default=".*")  # 账号ID
        public_id = self.get_argument("public_id", default=".*")  # 公众号ID
        # 可能的状态 follow/unfollow/forbid/review/.
        status = self.get_argument("status", default=".*")  # 订阅状态
        source = self.get_argument("source", default=".*")  # 信息源
        print(
            "account_id :%s ,public_id :%s ,status: %s " %
            (account_id, public_id, status))
        # 存储账号和微信号的关系，对应微信内部编号后的公众号ID
        self.relationship = self.application.relationship
        # curl "http://127.0.0.1:8001/manage/relationship?account_id=2&public_id=aaaa"
        if account_id != ".*" and public_id != ".*" and status == ".*":
            self.public_info = self.relationship.find_one(
                {"account_id": account_id, "public_id": public_id})
            print("self.public_info;", self.public_info)
            if self.public_info:
                req_body = {
                    "public_id": self.public_info.get("public_id"),
                    "public_name": self.public_info.get("public_info").get(
                        "public_name",
                        ""),
                    "status": self.public_info.get("status"),
                    "public_follows": self.public_info.get("public_info").get(
                        "public_follows",
                        ""),
                    "ctime": self.public_info.get("ctime"),
                    "source": self.public_info.get("source")}
                self.write(req_body)
            else:
                # set_status自定义返回的错误 reason
                self.set_status(status_code=500, reason="not find relationship!")
                self.write_error(status_code=500)
        else:
            """
            curl "http://127.0.0.1:8001/manage/relationship?account_id="      获取全部订阅信息
            curl "http://127.0.0.1:8001/manage/relationship?account_id=2"     获取account_id=2用户的所有订阅信息
            curl "http://127.0.0.1:8001/manage/relationship?account_id=2&public_id="
            curl "http://127.0.0.1:8001/manage/relationship?account_id=2&public_id=&status="
            curl "http://127.0.0.1:8001/manage/relationship?"
            curl "http://127.0.0.1:8001/manage/relationship?public_id=a&status=" 获取public_id=a 公众号被订阅的信息
            """
            account_id_regex = {'$regex': account_id}
            public_id_regex = {'$regex': public_id}
            status_regex = {'$regex': status}
            source_regex = {'$regex': source}
            regex = {
                "account_id": account_id_regex,
                "public_id": public_id_regex,
                "status": status_regex,
                "source": source_regex}
            print("regex:", regex)
            self.relationship = self.application.relationship
            self.public_info_list = self.relationship.find(regex)
            print("self.public_info_list;", self.public_info_list)
            self.public_list = []
            for x in self.public_info_list:
                self.public_list.append({
                    "public_id": x.get("public_id"),
                    "public_name": x.get("public_info").get("public_name", ""),
                    "account_id": x.get("account_id", None),
                    "status": x.get("status"),
                    "public_follows": x.get("public_info").get("public_follows", ""),
                    "ctime": x.get("ctime"),
                    "source": x.get("source")
                })
                print("x:", x)
            req_body = {"public_list": self.public_list}
            self.write(req_body)

    # curl -X PUT "http://127.0.0.1:8001/manage/relationship?account_id=1&public_id=234&status=follow/unfollow/forbid/review"
    def put(self, urlinfo=None):
        account_id = self.get_argument("account_id")
        public_id = self.get_argument("public_id")
        status = self.get_argument("status")
        print(
            "account_id :%s ,public_id :%s ,status: %s " %
            (account_id, public_id, status))
        self.relationship = self.application.relationship
        self.account_info = self.relationship.find_one(
            {"account_id": account_id})
        source = self.account_info.get("source")
        if source == "weixin":
            result = self.weixin_follow(account_id, public_id)
            if not result:
                self.set_status(
                    status_code=500,
                    reason="can't follow, the reason: reach follow limit")
                self.write_error(status_code=500)
                raise Exception("can't follow, the reason: reach follow limit")
        if source == "weibo":
            pass
        if source == "xueqiu":
            pass
        self.public_info = self.relationship.find_one(
            {"account_id": account_id, "public_id": public_id})
        """
        db.relationship.insert({
            "account_id":'shouji13',
            "account_name":"myweixinname",
            "account_info":{
            "alias_name":"wxid_kykrb8kn0tr522",
            "cookie":"aaaaa",
            "password":"bbbb",
            "status":"normal"
            }
            "public_id":"zhihu",
            "public_info":{
            "public_name":"知乎",
            "public_talker":"gh_80d2528f3dcd",
            "public_follows":146,
            }
            "status":"review",
            "source":"weixin",
            "ctime":"2018.4.11",
        })
        """
        if not self.public_info:
            # 新增关系
            self.relationship.insert(
                {
                    "account_id": account_id,
                    "public_id": public_id,
                    "status": status,
                    "source": source,
                    "ctime": datetime.datetime.now(),
                    "public_info": {
                        "public_name": "",
                        "public_talker": "",
                        "public_follows": ""},
                    "account_info": {
                        "alias_name": "",
                        "status": "",
                        "cookie": "",
                        "password": ""}})
        else:
            # 更新本地数据库
            self.relationship.update_one({"account_id": account_id, "public_id": public_id}, {
                '$set': {"status": status}})
        # 在查询一下，返回数据
        self.public_info = self.relationship.find_one(
            {"account_id": account_id, "public_id": public_id})
        print("self.public_info;", self.public_info)
        req_body = {"account_id": account_id, "public_id": public_id,
                    "public_name": self.public_info.get("public_name"),
                    "status": self.public_info.get("status"),
                    "result": "ok"
                    }
        if self.public_info:
            self.write(req_body)

    # 批量管理
    # curl -X POST "http://127.0.0.1:8001/manage/relationship" -d '{"source":"weixin",
    # "follows":"12;232;453;432;32;42;53;53;654;64;67;57","unfollows":"34;53;24;421;234;35;35;34;4;64"}'
    # 自动选择手机账号，自动完成分配
    def post(self, urlinfo=None):
        body = json.loads(self.request.body)
        follows_public_id = body.get('follows')
        unfollows_public_id = body.get('unfollows')
        source = body.get("source")
        print("follows:%s ,unfollows :%s ,source :%s" %
              (follows_public_id, unfollows_public_id, source))
        follows_public_id = set(follows_public_id.split(";"))
        unfollows_public_id = set(unfollows_public_id.split(";"))
        self.relationship = self.application.relationship

        if source == "weixin":
            already_follows = set()  # 已关注公众号，进行集合去重，避免不同账号重复关注
            # 先处理取消关注的公众号
            for z in unfollows_public_id:
                account_list = self.application.relationship.find(
                    {"public_id": z})  # 可能有多个账号关注了同一个公众号
                for x in account_list:
                    account_id = x.get("account_id")
                    if self.weixin_follow(account_id, z, follow="unfollow"):
                        self.relationship.update(
                            {'public_id': z}, {'$set': {'status': "unfollow"}})
            # 再处理关注公众号
            all_account_set = set()
            self.account_info = self.relationship.find({"source": source})
            for x in self.account_info:
                all_account_set.add(x.get("account_id"))
            follow_free = {}
            for y in all_account_set:
                follow_free[y] = weixin_max_follow - \
                                 self.relationship.find({"account_id": y, "status": "follow"}).count()
            # 统计每个账号的可用关注量，按降序排列
            follow_free_sort = sorted(
                follow_free.items(),
                key=lambda x: x[1],
                reverse=True)
            # 查询已经关注的公众号
            for a in self.relationship.find({"source": "weixin"}):
                already_follows.add(a.get("public_id"))
            # 去重后遍历关注
            will_follow = list(follows_public_id - already_follows)
            s = len(will_follow)
            t = 0
            follow_success = []
            follow_faild = []
            for account_free_tuple in follow_free_sort:
                for free_times in range(account_free_tuple[1]):
                    if t > s - 1:
                        break
                    if self.weixin_follow(
                            account_free_tuple[0], will_follow[t], "follow"):
                        # 更新本地数据库
                        self.relationship.update_one(
                            {
                                "account_id": account_free_tuple[0], "public_id": will_follow[t]}, {
                                '$set': {
                                    "status": "follow"}})
                        follow_success.append(will_follow[t])
                    else:
                        follow_faild.append(will_follow[t])
                    t = t + 1
            self.write({'follow_success': follow_success,
                        "follow_faild": follow_faild})

    def weixin_follow(self, account_id, public_id, follow="follow"):
        self.relationship = self.application.relationship
        self.account_info = self.relationship.find({"public_id": public_id})
        public_talker = self.account_info.get(
            "public_info").get("public_talker")
        alias_name = self.account_info.get("account_info").get("alias_name")
        already_follows = self.relationship.find(
            {"account_id": account_id}).count()
        if follow == "follow":
            if already_follows >= weixin_max_follow:
                return False
            # 更新
            "http://192.168.207.188:8998/api/v1/follow/微信内部id?user=公众号id/微信内部公账号id"
            mange_host = "http://192.168.207.188:8998"
            follow_url = "/api/v1/follow/%s?user=%s" % (
                alias_name, public_talker)
            req = requests.get(mange_host + follow_url)
            if req.status_code == 200 and "success" in req.content:
                return True
            else:
                raise Exception("follow faild!")
        elif follow == "unfollow":
            mange_host = "http://192.168.207.188:8998"
            unfollow_url = "/api/v1/unfollow/%s?user=%s" % (
                alias_name, public_talker)
            req = requests.get(mange_host + unfollow_url)
            if req.status_code == 200 and "success" in req.content:
                return True
            else:
                raise Exception("unfollow faild!")


if __name__ == "__main__":
    tornado.options.parse_command_line()  # python mytornao_web.py --port=8002
    http_server = tornado.httpserver.HTTPServer(Application())
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()


"""
# 使用或创建数据库
>use newdb
switched to db newdb

# 删除数据库
>db.dropDatabase()
>{ "dropped" : "newdb", "ok" : 1 }

# 删除集合
> db.relationship.drop()
true
# 创建集合
db.createCollection("relationship")

db.biz_article.insert({
	"return_rowid" : 1679,
    "username" : "eeee",
	"table_name" : "message",
	"rowid" : 0,
	"data" : {
		"status" : 3,
		"msgSvrId" : NumberLong("4808144205718605830"),
		"isSend" : 0,
		"talkerId" : 30,
		"msgId" : 1679,
		"bizChatId" : -1,
		"imgPath" : "THUMBNAIL_DIRPATH://th_773de52c1fc50fe3f58146573be8238a",
		"content" : "~SEMI_XML~\u0000+.msg.appmsg.mmreader.category.item.dhttp://mp.weixin.qq.com/s?__biz=MzA4MDU0MzQ4Mg==&mid=2653228065&idx=1&sn=51df390e887bacd694acb60c15d3b7e5&chksm=847307b4b3048ea2675a3f8bc593f9c5fc0b1c9bfb73d90eb8a2a5890012b759c495909be2cd&scene=0#rd\u0000).msg.appmsg.mmreader.el_flag\u0000\u00010\u0000$.msg.appmsg.mmreader.template_header\u0000\u0000\u0000\f.msg.appinfo\u0000\u0005\n    \u0000*0\u0012.mtem.cover\u0000http://mmbiz.qpic.cn/mmbiz_jpg/2Se8MibpDj7CbPGvTPEdjtEoj7W1r2HqJEqzjOTicWibuYN5Ie1yMic8Esq1ng9Dy0W3I4kxMosbfXqDsGDshkszfw/640?wxtype=jpeg&wxfrom=0\u0000\u0012.msg.appmsg.lowurl\u0000\u0000\u0000\".msg.appmsg.mmreader.category.item\u0000\u0011\n ",
		"flag" : 0,
		"talker" : "dddd",
		"rowid" : 1679,
		"type" : 285212721,
		"lvbuffer" : "[B@3c8d443",
		"bizClientMsgId" : "mmbizcluster_1_3080543482_1000000602",
		"createTime" : NumberLong("1510183096000"),
		"msgSeq" : 658604798
	},
	"method" : "insert",
	"utime" : ISODate("2018-04-09T07:32:35.216Z")
})


db.relationship.insert({
            "account_id":'aaa',
            "account_name":"bbbb",
            "account_info":{
            "alias_name":"eeee",
            "cookie":"123",
            "password":"123",
            "status":"1223"
            },
            "public_id":"zhihu",
            "public_info":{
            "public_name":"cccc",
            "public_talker":"dddd",
            "public_follows":"123",
            },
            "status":"review",
            "source":"weixin",
            "ctime":"2018.4.11",
        })

"""
