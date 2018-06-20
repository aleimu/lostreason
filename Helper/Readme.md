http://demo.pythoner.com/itt2zh/index.html

class IndexHandler(tornado.web.RequestHandler):
    def get(self):
        greeting = self.get_argument('greeting', 'Hello')
        self.write(greeting + ', friendly user!')
    def write_error(self, status_code, **kwargs):
        self.write("Gosh darnit, user! You caused a %d error." % status_code)

# 为什么 Tornado 在调用 self.finish() 以后不终止 RequestHandler 中相关处理函数的运行？

self.finish()代表回应生成的终结，并不代表着请求处理逻辑的终结。假设你有一个block的逻辑是和回应无关的，那么放在self.finish()的后面可以显著的缩短响应时间。所以，如果你确定自己的逻辑需要立即返回，可以在self.finish()后立刻return。Tornado在将这个自由留给了你自己。另外一个理由是，在call stack里让顶端的函数去弹出一个非顶端的函数，这个逻辑有点奇怪。唯一能够提供退出的机制就是异常了。但是在正常逻辑里面使用异常去实现一个功能，也是很怪的逻辑。同理还有self.render/self.write 
我们在所有这种response语句前加return 例如 return self.redirect('/')。
