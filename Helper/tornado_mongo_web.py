import traceback
import os.path
import tornado.locale
import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web
from tornado.options import define, options
from pymongo import MongoClient

define("port", default=8000, help="run on the given port", type=int)

class Application(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/", MainHandler),
        ]
        settings = dict(
            template_path=os.path.join(os.path.dirname(__file__), "templates"),
            static_path=os.path.join(os.path.dirname(__file__), "static"),
            debug=False,
            serve_traceback=True,
        )
        client = MongoClient('localhost', port=27017)
        client["mytest"].authenticate("lgj", "lgj", mechanism="SCRAM-SHA-1")
        self.db = client.mytest
        self.collection1 = self.db["onecollect"]
        tornado.web.Application.__init__(self, handlers, **settings)

class WebHandler(tornado.web.RequestHandler):
    # 重写write_error 方便定位请求错误
    def write_error(self, status_code, **kwargs):
        if self.settings.get("serve_traceback") and "exc_info" in kwargs:
            # in debug mode, try to send a traceback
            self.set_header('Content-Type', 'text/plain')
            error_message={"code":status_code,"error":traceback.format_exception(*kwargs["exc_info"])[-1]}
            self.write(error_message)
            self.finish()
        else:
            self.finish("<html><title>%(code)d: %(message)s</title>"
                        "<body>%(code)d: %(message)s</body></html>" % {
                            "code": status_code,
                            "message": self._reason,
                        })

class MainHandler(WebHandler):
    def get(self):
        coll = self.application.db.onecollect
        result = coll.find_one()
        print("result:%s , type: %s" % (result,type(result)))
        result={"a":1,"b":2}
        self.write(result)
    def post(self):
        greeting = self.get_argument('greeting', 'Hello')
        arg = self.get_argument('arg')
        self.write(greeting + ', friendly user!'+arg)

if __name__ == "__main__":
    tornado.options.parse_command_line()
    http_server = tornado.httpserver.HTTPServer(Application())
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()
