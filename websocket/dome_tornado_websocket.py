# coding:utf-8

import tornado.web
import tornado.ioloop
import tornado.httpserver
import tornado.options
import os
import datetime

from tornado.web import RequestHandler
from tornado.options import define, options
from tornado.websocket import WebSocketHandler

define("port", default=8000, type=int)

class IndexHandler(RequestHandler):
    def get(self):
        self.render("index.html")

class ChatHandler(WebSocketHandler):

    users = set()  # 用来存放在线用户的容器

    def open(self):
        self.users.add(self)  # 建立连接后添加用户到容器中
        for u in self.users:  # 向已在线用户发送消息
            u.write_message(u"[%s]-[%s]-进入聊天室" % (self.request.remote_ip, datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")))

    def on_message(self, message):
        for u in self.users:  # 向在线用户广播消息
            u.write_message(u"[%s]-[%s]-说：%s" % (self.request.remote_ip, datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), message))

    def on_close(self):
        self.users.remove(self) # 用户关闭连接后从容器中移除用户
        for u in self.users:
            u.write_message(u"[%s]-[%s]-离开聊天室" % (self.request.remote_ip, datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")))

    def check_origin(self, origin):
        return True  # 允许WebSocket的跨域请求

if __name__ == '__main__':
    tornado.options.parse_command_line()
    app = tornado.web.Application([
            (r"/", IndexHandler),
            (r"/chat", ChatHandler),
        ],
        static_path = os.path.join(os.path.dirname(__file__), "static"),
        template_path = os.path.join(os.path.dirname(__file__), "template"),
        debug = False
        )
    http_server = tornado.httpserver.HTTPServer(app)
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.current().start()
    
    
#html

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>聊天室</title>
</head>
<body>
    <div id="contents" style="height:500px;overflow:auto;"></div>
    <div>
        <textarea id="msg"></textarea>
        <a href="javascript:;" onclick="sendMsg()">发送</a>
    </div>
    <script src="{{static_url('jquery.min.js')}}"></script>
    <script type="text/javascript">
        var ws = new WebSocket("ws://XXX.XXX.XXX.XXX:8000/chat");
        ws.onmessage = function(e) {
            $("#contents").append("<p>" + e.data + "</p>");
        }
        function sendMsg() {
            var msg = $("#msg").val();
            ws.send(msg);
            $("#msg").val("");
        }
    </script>
</body>
</html>
