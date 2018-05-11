
#http://blog.51cto.com/chenql/2071267

> db.relationship.getIndexKeys()
[ { "_id" : 1 } ]
> 
> 
> 

> db.relationship.createIndex({"account_id":1,"public_info.public_talker":1})
{
	"createdCollectionAutomatically" : false,
	"numIndexesBefore" : 1,
	"numIndexesAfter" : 2,
	"ok" : 1
}

> db.relationship.getIndexes()
[
	{
		"v" : 1,
		"key" : {
			"_id" : 1
		},
		"name" : "_id_",
		"ns" : "relationship.relationship"
	},
	{
		"v" : 1,
		"key" : {
			"account_id" : 1,
			"public_info.public_talker" : 1
		},
		"name" : "account_id_1_public_info.public_talker_1",
		"ns" : "relationship.relationship"
	}
]

> db.relationship.dropIndex("account_id_1_public_info.public_talker_1")
{ "nIndexesWas" : 2, "ok" : 1 }

> db.relationship.getIndexes()
[
	{
		"v" : 1,
		"key" : {
			"_id" : 1
		},
		"name" : "_id_",
		"ns" : "relationship.relationship"
	}
]

> db.relationship.getIndexKeys()
[ { "_id" : 1 } ]

> db.relationship.createIndex({"account_id":1})
{
	"createdCollectionAutomatically" : false,
	"numIndexesBefore" : 1,
	"numIndexesAfter" : 2,
	"ok" : 1
}
> db.relationship.getIndexKeys()
[ { "_id" : 1 }, { "account_id" : 1 } ]
> 
> 
> db.relationship.createIndex({"public_info.public_talker":1})
{
	"createdCollectionAutomatically" : false,
	"numIndexesBefore" : 2,
	"numIndexesAfter" : 3,
	"ok" : 1
}
> db.relationship.getIndexKeys()
[
	{
		"_id" : 1
	},
	{
		"account_id" : 1
	},
	{
		"public_info.public_talker" : 1
	}
]
> 


> db.relationship.getIndexes()
[
	{
		"v" : 1,
		"key" : {
			"_id" : 1
		},
		"name" : "_id_",
		"ns" : "relationship.relationship"
	},
	{
		"v" : 1,
		"key" : {
			"account_id" : 1
		},
		"name" : "account_id_1",
		"ns" : "relationship.relationship"
	},
	{
		"v" : 1,
		"key" : {
			"public_info.public_talker" : 1
		},
		"name" : "public_info.public_talker_1",
		"ns" : "relationship.relationship"
	}
]
> 

> db.relationship.getIndexKeys()
[
	{
		"_id" : 1
	},
	{
		"account_id" : 1
	},
	{
		"public_info.public_talker" : 1
	}
]
> 

>  db.relationship.dropIndex("public_info.public_talker_1")
{ "nIndexesWas" : 3, "ok" : 1 }
> 
> 
> db.relationship.getIndexKeys()
[ { "_id" : 1 }, { "account_id" : 1 } ]
> 

#########################################################

db.biz_article.createIndex({"utime":1,"data.talker" : 1})

> db.biz_article.getIndexKeys()
[ { "_id" : 1 }, { "utime" : 1, "data.talker" : 1 } ]

[I 180510 11:06:55 web:1908] 304 GET /manage/relationship?account_id=meiguihuadezangli&status=follow&getjson=ture (192.168.40.150) 163206.66ms


db.biz_article.createIndex({"utime":1})
db.biz_article.createIndex({"data.talker" : 1})
[I 180510 11:08:34 web:1908] 304 GET /manage/relationship?account_id=meiguihuadezangli&status=follow&getjson=ture (192.168.40.150) 7609.27ms

# 前后台建索引的查询速度还是有很大差别的
db.biz_article.createIndex({"utime":1},{'background': true})
db.biz_article.createIndex({"data.talker":1},{'background': true})

> db.biz_article.getIndexes()
[
	{
		"v" : 1,
		"key" : {
			"_id" : 1
		},
		"name" : "_id_",
		"ns" : "wechat_v10.biz_article"
	},
	{
		"v" : 1,
		"key" : {
			"utime" : 1
		},
		"name" : "utime_1",
		"ns" : "wechat_v10.biz_article",
		"background" : true
	},
	{
		"v" : 1,
		"key" : {
			"data.talker" : 1
		},
		"name" : "data.talker_1",
		"ns" : "wechat_v10.biz_article",
		"background" : true
	}
]
>

db.biz_article.createIndex({"utime":1,"data.talker" : 1},{'background': true})



mongo企业版才支持中文分词


db.biz_article.find().explain("executionStats")
db.biz_article.find({"data.talker":"gh_a1071eb140c7"}).explain("executionStats")





db.biz_article.find({"data.talker":"gh_a1071eb140c7","utime" : ISODate("2018-05-10T18:46:55.079Z")}).explain("executionStats")

db.biz_article.find({"data.talker":"gh_a1071eb140c7","utime" : {$gte:ISODate("2018-05-10T18:46:55.079Z")}}).explain("executionStats")

db.biz_article.find({"utime" : {$gte:ISODate("2018-05-10T18:46:55.079Z")},"data.talker":"gh_a1071eb140c7"}).explain("executionStats")

db.biz_article.find({"utime" : {$gte:ISODate("2018-05-10T18:46:55.079Z")},"data.content":{'$regex': ".*"},"data.talker":"gh_a1071eb140c7"}).explain("executionStats")



db.biz_article.createIndex({"utime":1,"data.talker":1})

用hint()方法来强制查询走哪个索引。

我们来看一下，当查询条件是多个的时候，复合索引相比单键索引的强大魅力。    

db.biz_article.find({"utime" : {$gte:ISODate("2018-05-10T18:46:55.079Z")},"data.content":{'$regex': ".*"},"data.talker":"gh_a1071eb140c7"}).hint({"utime":1,"data.talker":1}).explain("executionStats")

# 此索引下
> db.biz_article.getIndexKeys()
[ { "_id" : 1 }, { "utime" : 1 }, { "data.talker" : 1 } ]

db.biz_article.find({"utime" : {$gte:ISODate("2017-12-10T18:46:55.079Z")},"data.talker" : "gh_998487ade47d"}).explain("executionStats") #最快
db.biz_article.find({"data.talker" : "gh_998487ade47d","utime" : {$gte:ISODate("2017-12-10T18:46:55.079Z")}}).explain("executionStats") # 一样

# 更快！
db.biz_article.find({"utime" : {$gte:ISODate("2017-12-10T18:46:55.079Z")},"data.talker" : "gh_998487ade47d"}).hint({"data.talker":1}).explain("executionStats")
db.biz_article.find({"utime" : {$gte:ISODate("2017-12-10T18:46:55.079Z")},"data.talker" : "gh_58f96e659675"}).hint({"data.talker":1}).explain("executionStats")

# 较慢
db.biz_article.find({"utime" : {$gte:ISODate("2017-12-10T18:46:55.079Z")},"data.talker" : "gh_998487ade47d"}).hint({"utime":1,"data.talker":1}).explain("executionStats")

db.biz_article.find({"utime" : {$gte:ISODate("2017-12-10T18:46:55.079Z")},"data.talker" : "gh_998487ade47d"}).hint({"utime":1}).explain("executionStats")


# 35s
db.biz_article.find({"utime" : {$gte:ISODate("2017-12-10T18:46:55.079Z")},"data.talker" : "gh_254089b5ba17"}).count()

db.biz_article.find({"utime" : {$gte:ISODate("2017-12-10T18:46:55.079Z")},"data.talker" : "gh_254089b5ba17"}).explain("executionStats")





#/home/liugj
mongoimport --port 27018 -u admin -p admin --authenticationDatabase admin -d wechat_v10 -c biz_article --file ./biz_article.json --type json 
mongoexport --port 27018 -u admin -p admin --authenticationDatabase admin -d wechat_v10 -c biz_article -o ./biz_article_export.json --type json


#启用全文本索引
db.adminCommand({"setParameter":1,"textSearchEnabled":true})


#给title和context字段建立全文本索引，给title字段2的权重，context字段1的权重。（权重的范围可以是1~1,000,000,000，默认权重是1）
db.biz_article.ensureIndex({"data.content":"text"},{"weights":{"data.content":1}})

db.quotes.createIndex({"data.content":"text"},{default_language:"zhs"})


#搜索的内容是“flotation”
db.biz_article.find({$text:{$search:"weixin"}})

db.biz_article.find({$text:{$search:"分析现货"}})

db.biz_article.find({$text:{$search:"财经要情"}})



