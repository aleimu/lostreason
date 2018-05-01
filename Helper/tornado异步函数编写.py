http://www.mongoing.com/archives/2797   mongo 索引

http://api.mongodb.com/python/current/api/pymongo/collection.html#pymongo.collection.Collection.find

http://api.mongodb.com/python/current/api/pymongo/cursor.html?highlight=where

https://blog.csdn.net/seeground/article/details/49488407


import asyncmongo

import asyncmongo
import tornado.web

class Handler(tornado.web.RequestHandler):
    @property
    def db(self):
        if not hasattr(self, '_db'):
            self._db = asyncmongo.Client(pool_id='mydb', host='127.0.0.1', port=27017, maxcached=10, maxconnections=50, dbname='test')
        return self._db

    @tornado.web.asynchronous
    def get(self):
        self.db.users.find({'username': self.current_user}, limit=1, callback=self._on_response)
        # or
        # conn = self.db.connection(collectionname="...", dbname="...")
        # conn.find(..., callback=self._on_response)
    def _on_response(self, response, error):
        if error:
            raise tornado.web.HTTPError(500)
        self.render('template', full_name=response['full_name'])

tornado默认在处理函数返回时关闭链接，@tornado.web.asynchronous修饰器使得连接保持开启, 即修饰器将RequestHandler 的 _auto_finish 属性置为 false.需要最后手动调用RequestHandler.finish()方法关闭连接。


使用sleep( )函数，是模拟耗时操作。
sleep函数在tornado 4.1在gen模块中有定义，可以直接使用gen.sleep。
def sleep(duration):
    f = Future()
    ioloop.IOLoop.current().call_later(duration, lambda: f.set_result(None))
    return f


阻塞会大大影响tornado的性能。
比如耗时的数据库查询，耗时的运算。所以只有使用异步的库，才能发挥tornado的高性能。
如果没有相应的异步库，可以自己尝试着写。或者最简单的，使用celery作为异步任务队列。celery有对应的tornado库，tornado-celery。

普通socket请求，它是阻塞的。必须等2s后，服务器才会返回数据。
想要实现异步必须需要满足两个条件:
返回Future对象
将future.set_result方法登记到ioloop中， 在结果返回时，就会调用。


import tornado.httpserver
import tornado.web
import socket
from tornado import ioloop
from tornado import gen 
from tornado.concurrent import Future
 
class MainHandler(tornado.web.RequestHandler):
     
    @gen.coroutine
    def get(self):
        data = yield self.get_data()
        self.write(data)
        self.finish()
 
    def get_data(self):
        future = Future()
        s = socket.socket(socket.AF_INET,socket.SOCK_STREAM) 
        s.connect(('localhost', 8888))
        s.send('hello\n')
 
        def handle_data(sock, event):
            io_loop = ioloop.IOLoop.current()
            io_loop.remove_handler(sock)
            data = sock.recv(1024)
            future.set_result(data)
 
        io_loop = ioloop.IOLoop.current()
        io_loop.add_handler(s, handle_data, io_loop.READ)
 
        return future
 
if __name__ == "__main__":
    app = tornado.web.Application(
        handlers = [
            (r"/", MainHandler)
        ]
    )
 
    http_server = tornado.httpserver.HTTPServer(app)
    http_server.listen(8000)
    tornado.ioloop.IOLoop.instance().start()

    
    
    
作者：杨昆
链接：https://www.zhihu.com/question/41751125/answer/92207423
来源：知乎

异步模型可以分为回调（callback）和协程（coroutine）
asynchronous 这个装饰器用于 callback 风格的异步函数，它告诉被装饰的函数：执行完后别着急走，还有一个任务等你完成。在这个例子中:

class AsyncHandler(RequestHandler):
    @asynchronous
    def get(self):
        http_client = AsyncHTTPClient()
        http_client.fetch("http://example.com",
                          callback=self.on_fetch)

    def on_fetch(self, response):
        do_something_with_response(response)
        self.render("template.html")
如果没有asynchronous 这个装饰器，当 get 执行完时自动会调用 self.finish 方法，结束当次请求，而用了这个装饰器后，get 返回时放弃调用 self.finish，而由你的回调函数决定什么时候调用，上面的 self.render 就会调用  self.finish。gen.engine 现在已经被 gen.coroutine 取代，适用于 generator 风格的异步函数，被它封装的函数必须是一个 generator。下面这个例子:

class GenAsyncHandler(RequestHandler):
    @gen.coroutine
    def get(self):
        http_client = AsyncHTTPClient()
        response = yield http_client.fetch("http://example.com")
        do_something_with_response(response)
        self.render("template.html")
 当执行到 yield时，暂时让出 cpu 回到 ioloop，同时在 ioloop上注册事件，当异步的操作执行完返回时再由 ioloop调度回来继续执行后面。无论是用 asynchronous 还是 gen.engine 这个装饰器，关键的是 callback 和 yield 时使用的库必须是异步的，否则操作阻塞起不到异步效果，这两个例子使用的AsyncHTTPClient就是官方提供的异步库。tornado的异步库要基于它的 ioloop来实现，可惜的是这方面的异步库并不多。
 

问题 
如何在tornado的coroutine中调用同步阻塞的函数

解决方案 
使用python内置标准库的concurrent.futures.ThreadPoolExecutor和tornado.concurrent.run_on_executor
因为 tornado 自身是单线程的，所以如果我们在某一个时刻执行了一个耗时的任务，那么就会阻塞在这里，无法响应其他的任务请求，这个和 tornado 的高性能服务器称号不符，所以我们要想办法把耗时的任务转换为不阻塞主线程，让耗时的任务不影响对其他请求的响应。
在 python 3.2 上，增加了一个并行库 concurrent.futures，这个库提供了更简单的异步执行函数的方法。
如果是在 2.7 之类的 python 版本上，可以使用 pip install futures 来安装这个库。

 
 #!/usr/bin/env python
#-*-coding:utf-8-*-
import tornado.ioloop
import tornado.web
import tornado.httpserver
from concurrent.futures import ThreadPoolExecutor
from tornado.concurrent import run_on_executor
import time
class App(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r'/', IndexHandler),
            (r'/sleep/(\d+)', SleepHandler),
        ]
        settings = dict()
        tornado.web.Application.__init__(self, handlers, **settings)
class BaseHandler(tornado.web.RequestHandler):
    executor = ThreadPoolExecutor(10)
class IndexHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello, world %s" % time.time())
class SleepHandler(BaseHandler):
    @run_on_executor
    def get(self, n):
        time.sleep(float(n))
        self._callback()
    def _callback(self):
        self.write("after sleep, now I'm back %s" % time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))
if __name__ == "__main__":
    app = App()
    server = tornado.httpserver.HTTPServer(app, xheaders=True)
    server.listen(8888)
    tornado.ioloop.IOLoop.instance().start()
    
# 此时先调用 127.0.0.1:8888/sleep/10 不会阻塞 127.0.0.1:8888/ 了。



class Executor(ThreadPoolExecutor):
    _instance = None

    def __new__(cls, *args, **kwargs):
        if not getattr(cls, '_instance', None):
            cls._instance = ThreadPoolExecutor(max_workers=10)
        return cls._instance


class FutureResponseHandler(tornado.web.RequestHandler):
    executor = Executor()

    @tornado.web.asynchronous
    @tornado.gen.coroutine
    def get(self, *args, **kwargs):

        future = Executor().submit(self.ping, 'www.google.com')

        response = yield tornado.gen.with_timeout(datetime.timedelta(10), future,
                                                  quiet_exceptions=tornado.gen.TimeoutError)

        if response:
            print 'response', response.result()

    @tornado.concurrent.run_on_executor
    def ping(self, url):
        os.system("ping -c 1 {}".format(url))
        return 'after'
 
 
 # ---------------------几种异步方式的dome------------------------#
 
# -*- coding:utf-8 -*-

import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web
import tornado.httpclient
import os
import urllib
import json
import datetime
import time
from pymongo import MongoClient
import tornado.gen
import gevent
import  functools
from concurrent.futures import ThreadPoolExecutor
from tornado.concurrent import run_on_executor


from tornado.options import define, options
define("port", default=8000, help="run on the given port", type=int)

# app 配置
class Application(tornado.web.Application):
    def __init__(self):
        settings = dict(
            template_path=os.path.join(os.path.dirname(__file__), "templates"),
            static_path=os.path.join(os.path.dirname(__file__), "static"),
            debug=False,
        )
        handlers = [(r'/sync', IndexHandler_sync),
                    (r'/async', IndexHandler_async),
                    ]
        client = MongoClient('localhost', port=27017)
        if client["mytest"].authenticate("lgj", "lgj", mechanism="SCRAM-SHA-1"):
            self.relationship = client["relationship"]["relationship"]

        tornado.web.Application.__init__(self, handlers, **settings)

class FristHandler(tornado.web.RequestHandler):

    def get_mongo_sync(self):
        time.sleep(0.1)
        body = []
        #print("get_mongo start!")
        relationship = self.application.relationship
        for x in relationship.find():
            body.append(x.get('account_name'))
        #print("get_mongo end!")
        return body

    def get_mongo_async1(self):
        #gevent.sleep(0.2)  # 并不是异步大概是因为没有注册到tornado事件循环中 这里和同步效果一样！
        tornado.gen.sleep(0.1)  # 有效！
        body = []
        #print("get_mongo start!")
        # relationship = self.application.relationship
        # for x in relationship.find():
        #     body.append(x.get('account_name'))
        #print("get_mongo end!")
        body =range(100)
        return body

    @tornado.gen.coroutine
    def get_mongo_async2(self):
        #gevent.sleep(0.2)  # 并不是异步大概是因为没有注册到tornado事件循环中 这里和同步效果一样！
        tornado.gen.sleep(0.1)  # 有效！
        body = []
        #print("get_mongo start!")
        # relationship = self.application.relationship
        # for x in relationship.find():
        #     body.append(x.get('account_name'))
        #print("get_mongo end!")
        body =range(100)
        return body

class IndexHandler_sync(FristHandler):
    def get(self):
        print("IndexHandler_sync get start!")
        relationship = self.application.relationship
        body=self.get_mongo_sync()
        self.write({'body':body})
        print("IndexHandler_sync get end!")

    def get2(self, *args, **kwargs):
        # 耗时的代码
        os.system("ping -c 2 www.baidu.com")
        self.finish('It works')

class IndexHandler_async(FristHandler):

    @tornado.web.asynchronous
    @tornado.gen.coroutine
    def get(self):
        print("IndexHandler_async get start!")
        response = yield tornado.gen.multi([self.get_mongo_async2()])
        #print ("response:",response)
        self.write({'body':list(response)})
        self.finish()
        print("IndexHandler_async get end!")

    @tornado.web.asynchronous
    @tornado.gen.coroutine
    def get1(self):
        print("IndexHandler_async get start!")
        response = yield  tornado.gen.maybe_future(self.get_mongo_async1())
        #print ("response:",response)
        self.write({'body':list(response)})
        self.finish()
        print("IndexHandler_async get end!")


    @tornado.web.asynchronous
    @tornado.gen.coroutine
    def get2(self):
        print("IndexHandler_async get start!")
        response = yield tornado.gen.Task(self.get_mongo_async2)
        #print ("response:",response)
        self.write({'body':list(response)})
        self.finish()
        print("IndexHandler_async get end!")



    executor = ThreadPoolExecutor(10)
    @tornado.web.asynchronous
    @tornado.gen.coroutine
    def get2(self, *args, **kwargs):

        url = 'www.baidu.com'
        tornado.ioloop.IOLoop.instance().add_callback(functools.partial(self.ping, url))
        self.finish('It works')

    @run_on_executor    # 标记成后台程序执行。
    def ping(self, url):
        os.system("ping -c 2 {}".format(url))

if __name__ == "__main__":
    tornado.options.parse_command_line()  # python mytornao_web.py --port=8002
    http_server = tornado.httpserver.HTTPServer(Application())
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()

