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

# 去重
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

# or 与 and
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



