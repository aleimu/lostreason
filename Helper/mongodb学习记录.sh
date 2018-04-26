http://demo.pythoner.com/itt2zh/index.html                      #tornado教程
https://blog.csdn.net/woshixiaosimao/article/details/54581475   #pymongo 学习总结
http://www.runoob.com/mongodb/mongodb-tutorial.html             #mongo 教程
https://docs.mongodb.com/manual/introduction/                   #文档

启动mongodb服务：mongod --dbpath E:\MongoDB\mongodbdata

mongodb的参数说明：
--dbpath 数据库路径(数据文件)
--logpath 日志文件路径
--master 指定为主机器
--slave 指定为从机器
--source 指定主机器的IP地址
--pologSize 指定日志文件大小不超过64M.因为resync是非常操作量大且耗时，最好通过设置一个足够大的oplogSize来避免resync(默认的 oplog大小是空闲磁盘大小的5%)。
--logappend 日志文件末尾添加
--port 启用端口号
--fork 在后台运行
--only 指定只复制哪一个数据库
--slavedelay 指从复制检测的时间间隔
--auth 是否需要验证权限登录(用户名和密码)

vim /etc/mongodb.conf
dbpath=/data/mongodb
logpath=/data/mongodb/log/mongodb.log
logappend=true
port=27017
fork=true
##auth = true # 先关闭, 创建好用户在启动

#通过配置文件启动
mongod -f /etc/mongodb.conf

{
> help
        db.help()                    help on db methods
        db.mycoll.help()             help on collection methods
        sh.help()                    sharding helpers
        rs.help()                    replica set helpers
        help admin                   administrative help
        help connect                 connecting to a db help
        help keys                    key shortcuts
        help misc                    misc things to know
        help mr                      mapreduce

        show dbs                     show database names
        show collections             show collections in current database
        show users                   show users in current database
        show profile                 show most recent system.profile entries with time >= 1ms
        show logs                    show the accessible logger names
        show log [name]              prints out the last segment of log in memory, 'global' is default
        use <db_name>                set current database
        db.foo.find()                list objects in collection foo
        db.foo.find( { a : 1 } )     list objects in foo where a == 1
        it                           result of the last line evaluated; use to further iterate
        DBQuery.shellBatchSize = x   set default number of items to display on shell
        exit                         quit the mongo shell
> db.help()
DB methods:
        db.adminCommand(nameOrDocument) - switches to 'admin' db, and runs command [just calls db.runCommand(...)]
        db.aggregate([pipeline], {options}) - performs a collectionless aggregation on this database; returns a cursor
        db.auth(username, password)
        db.cloneDatabase(fromhost)
        db.commandHelp(name) returns the help for the command
        db.copyDatabase(fromdb, todb, fromhost)
        db.createCollection(name, {size: ..., capped: ..., max: ...})
        db.createView(name, viewOn, [{$operator: {...}}, ...], {viewOptions})
        db.createUser(userDocument)
        db.currentOp() displays currently executing operations in the db
        db.dropDatabase()
        db.eval() - deprecated
        db.fsyncLock() flush data to disk and lock server for backups
        db.fsyncUnlock() unlocks server following a db.fsyncLock()
        db.getCollection(cname) same as db['cname'] or db.cname
        db.getCollectionInfos([filter]) - returns a list that contains the names and options of the dbs collections
        db.getCollectionNames()
        db.getLastError() - just returns the err msg string
        db.getLastErrorObj() - return full status object
        db.getLogComponents()
        db.getMongo() get the server connection object
        db.getMongo().setSlaveOk() allow queries on a replication slave server
        db.getName()
        db.getPrevError()
        db.getProfilingLevel() - deprecated
        db.getProfilingStatus() - returns if profiling is on and slow threshold
        db.getReplicationInfo()
        db.getSiblingDB(name) get the db at the same server as this one
        db.getWriteConcern() - returns the write concern used for any operations on this db, inherited from server object if set
        db.hostInfo() get details about the servers host
        db.isMaster() check replica primary status
        db.killOp(opid) kills the current operation in the db
        db.listCommands() lists all the db commands
        db.loadServerScripts() loads all the scripts in db.system.js
        db.logout()
        db.printCollectionStats()
        db.printReplicationInfo()
        db.printShardingStatus()
        db.printSlaveReplicationInfo()
        db.dropUser(username)
        db.repairDatabase()
        db.resetError()
        db.runCommand(cmdObj) run a database command.  if cmdObj is a string, turns it into {cmdObj: 1}
        db.serverStatus()
        db.setLogLevel(level,<component>)
        db.setProfilingLevel(level,slowms) 0=off 1=slow 2=all
        db.setWriteConcern(<write concern doc>) - sets the write concern for writes to the db
        db.unsetWriteConcern(<write concern doc>) - unsets the write concern for writes to the db
        db.setVerboseShell(flag) display extra information in shell output
        db.shutdownServer()
        db.stats()
        db.version() current version of the server
>

}

#创建db
use mytest

# 创建用户
db.createUser(
    {
        user: "lgj",
        pwd: "lgj",
        roles: [ { role: "readWrite", db: "mytest" } ]
    }
)
# 创建集合
db.createCollection(name="onecollect")
db.createCollection(name="twocollect")
# 验证用户
db.auth("lgj","lgj")



# Python无法连接mongodb：'module' object has no attribute 'Connection' 
import pymongo
conn = pymongo.Connection('localhost',27017)
然后就报错
AttributeError: 'module' object has no attribute 'Connection'
这样的pymongo教程大都是几年前的，pymongo的版本应该也比较低。
新的pymongo中取消了Connection这个方法。
新的版本需要新建一个client，然后才是连接。
>>> from pymongo import MongoClient
>>> client=MongoClient()
>>> client
MongoClient('localhost', 27017)


 (1) 导入
from pymongo import MongoClient

 (2) 连接mongodb
client = MongoClient('localhost',port=27017)

 (3) 连接数据库
db = client.mytest
or 
db = client["mytest"]

注：当连接的数据库设置了auth之后，需要这样连接，不同版本，不同平台都不一样，具体见官方文档
client["mytest"].authenticate("lgj","lgj",mechanism="SCRAM-SHA-1")

(4) 连接数据库中的某个集合
## 获取该数据库中的非系统集合
db.onecollect(include_system_collections=False)

## 连接集合
collection = db["onecollect"]
or 
collection = db.onecollect


insert_data = {
         "author": "Mike",
         "text": "My first blog post!",
         "tags": ["mongodb", "python", "pymongo"],
         "date": datetime.datetime.utcnow()
          }
          



