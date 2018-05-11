> db.biz_article.find({"utime" : {$gte:ISODate("2018-05-10T18:46:55.079Z")},"data.content":{'$regex': ".*"},"data.talker":"gh_a1071eb140c7"}).explain("executionStats")
{
	"queryPlanner" : {
		"plannerVersion" : 1,
		"namespace" : "wechat_v10.biz_article",
		"indexFilterSet" : false,
		"parsedQuery" : {
			"$and" : [
				{
					"data.talker" : {
						"$eq" : "gh_a1071eb140c7"
					}
				},
				{
					"utime" : {
						"$gte" : ISODate("2018-05-10T18:46:55.079Z")
					}
				},
				{
					"data.content" : /.*/
				}
			]
		},
		"winningPlan" : {
			"stage" : "FETCH",
			"filter" : {
				"$and" : [
					{
						"data.talker" : {
							"$eq" : "gh_a1071eb140c7"
						}
					},
					{
						"data.content" : /.*/
					}
				]
			},
			"inputStage" : {
				"stage" : "IXSCAN",
				"keyPattern" : {
					"utime" : 1
				},
				"indexName" : "utime_1",
				"isMultiKey" : false,
				"isUnique" : false,
				"isSparse" : false,
				"isPartial" : false,
				"indexVersion" : 1,
				"direction" : "forward",
				"indexBounds" : {
					"utime" : [
						"[new Date(1525978015079), new Date(9223372036854775807)]"
					]
				}
			}
		},
		"rejectedPlans" : [
			{
				"stage" : "FETCH",
				"filter" : {
					"$and" : [
						{
							"utime" : {
								"$gte" : ISODate("2018-05-10T18:46:55.079Z")
							}
						},
						{
							"data.content" : /.*/
						}
					]
				},
				"inputStage" : {
					"stage" : "IXSCAN",
					"keyPattern" : {
						"data.talker" : 1
					},
					"indexName" : "data.talker_1",
					"isMultiKey" : false,
					"isUnique" : false,
					"isSparse" : false,
					"isPartial" : false,
					"indexVersion" : 1,
					"direction" : "forward",
					"indexBounds" : {
						"data.talker" : [
							"[\"gh_a1071eb140c7\", \"gh_a1071eb140c7\"]"
						]
					}
				}
			}
		]
	},
	"executionStats" : {
		"executionSuccess" : true,
		"nReturned" : 99722,
		"executionTimeMillis" : 598,
		"totalKeysExamined" : 99732,
		"totalDocsExamined" : 99732,
		"executionStages" : {
			"stage" : "FETCH",
			"filter" : {
				"$and" : [
					{
						"data.talker" : {
							"$eq" : "gh_a1071eb140c7"
						}
					},
					{
						"data.content" : /.*/
					}
				]
			},
			"nReturned" : 99722,
			"executionTimeMillisEstimate" : 490,
			"works" : 99733,
			"advanced" : 99722,
			"needTime" : 10,
			"needYield" : 0,
			"saveState" : 781,
			"restoreState" : 781,
			"isEOF" : 1,
			"invalidates" : 0,
			"docsExamined" : 99732,
			"alreadyHasObj" : 0,
			"inputStage" : {
				"stage" : "IXSCAN",
				"nReturned" : 99732,
				"executionTimeMillisEstimate" : 120,
				"works" : 99733,
				"advanced" : 99732,
				"needTime" : 0,
				"needYield" : 0,
				"saveState" : 781,
				"restoreState" : 781,
				"isEOF" : 1,
				"invalidates" : 0,
				"keyPattern" : {
					"utime" : 1
				},
				"indexName" : "utime_1",
				"isMultiKey" : false,
				"isUnique" : false,
				"isSparse" : false,
				"isPartial" : false,
				"indexVersion" : 1,
				"direction" : "forward",
				"indexBounds" : {
					"utime" : [
						"[new Date(1525978015079), new Date(9223372036854775807)]"
					]
				},
				"keysExamined" : 99732,
				"dupsTested" : 0,
				"dupsDropped" : 0,
				"seenInvalidated" : 0
			}
		}
	},
	"serverInfo" : {
		"host" : "crawltest004.soniu.com",
		"port" : 27018,
		"version" : "3.2.7",
		"gitVersion" : "4249c1d2b5999ebbf1fdf3bc0e0e3b3ff5c0aaf2"
	},
	"ok" : 1
}





###
> db.biz_article.find({"data.talker":"gh_a1071eb140c7","utime" : {$gte:ISODate("2018-05-10T18:46:55.079Z")}}).explain("executionStats")
{
	"queryPlanner" : {
		"plannerVersion" : 1,
		"namespace" : "wechat_v10.biz_article",
		"indexFilterSet" : false,
		"parsedQuery" : {
			"$and" : [
				{
					"data.talker" : {
						"$eq" : "gh_a1071eb140c7"
					}
				},
				{
					"utime" : {
						"$gte" : ISODate("2018-05-10T18:46:55.079Z")
					}
				}
			]
		},
		"winningPlan" : {
			"stage" : "FETCH",
			"filter" : {
				"data.talker" : {
					"$eq" : "gh_a1071eb140c7"
				}
			},
			"inputStage" : {
				"stage" : "IXSCAN",
				"keyPattern" : {
					"utime" : 1
				},
				"indexName" : "utime_1",
				"isMultiKey" : false,
				"isUnique" : false,
				"isSparse" : false,
				"isPartial" : false,
				"indexVersion" : 1,
				"direction" : "forward",
				"indexBounds" : {
					"utime" : [
						"[new Date(1525978015079), new Date(9223372036854775807)]"
					]
				}
			}
		},
		"rejectedPlans" : [
			{
				"stage" : "FETCH",
				"filter" : {
					"utime" : {
						"$gte" : ISODate("2018-05-10T18:46:55.079Z")
					}
				},
				"inputStage" : {
					"stage" : "IXSCAN",
					"keyPattern" : {
						"data.talker" : 1
					},
					"indexName" : "data.talker_1",
					"isMultiKey" : false,
					"isUnique" : false,
					"isSparse" : false,
					"isPartial" : false,
					"indexVersion" : 1,
					"direction" : "forward",
					"indexBounds" : {
						"data.talker" : [
							"[\"gh_a1071eb140c7\", \"gh_a1071eb140c7\"]"
						]
					}
				}
			}
		]
	},
	"executionStats" : {
		"executionSuccess" : true,
		"nReturned" : 99722,
		"executionTimeMillis" : 607,
		"totalKeysExamined" : 99732,
		"totalDocsExamined" : 99732,
		"executionStages" : {
			"stage" : "FETCH",
			"filter" : {
				"data.talker" : {
					"$eq" : "gh_a1071eb140c7"
				}
			},
			"nReturned" : 99722,
			"executionTimeMillisEstimate" : 380,
			"works" : 99733,
			"advanced" : 99722,
			"needTime" : 10,
			"needYield" : 0,
			"saveState" : 782,
			"restoreState" : 782,
			"isEOF" : 1,
			"invalidates" : 0,
			"docsExamined" : 99732,
			"alreadyHasObj" : 0,
			"inputStage" : {
				"stage" : "IXSCAN",
				"nReturned" : 99732,
				"executionTimeMillisEstimate" : 70,
				"works" : 99733,
				"advanced" : 99732,
				"needTime" : 0,
				"needYield" : 0,
				"saveState" : 782,
				"restoreState" : 782,
				"isEOF" : 1,
				"invalidates" : 0,
				"keyPattern" : {
					"utime" : 1
				},
				"indexName" : "utime_1",
				"isMultiKey" : false,
				"isUnique" : false,
				"isSparse" : false,
				"isPartial" : false,
				"indexVersion" : 1,
				"direction" : "forward",
				"indexBounds" : {
					"utime" : [
						"[new Date(1525978015079), new Date(9223372036854775807)]"
					]
				},
				"keysExamined" : 99732,
				"dupsTested" : 0,
				"dupsDropped" : 0,
				"seenInvalidated" : 0
			}
		}
	},
	"serverInfo" : {
		"host" : "crawltest004.soniu.com",
		"port" : 27018,
		"version" : "3.2.7",
		"gitVersion" : "4249c1d2b5999ebbf1fdf3bc0e0e3b3ff5c0aaf2"
	},
	"ok" : 1
}
> 

#
> db.biz_article.find({"utime" : {$gte:ISODate("2018-05-10T18:46:55.079Z")},"data.talker":"gh_a1071eb140c7"}).explain("executionStats")
{
	"queryPlanner" : {
		"plannerVersion" : 1,
		"namespace" : "wechat_v10.biz_article",
		"indexFilterSet" : false,
		"parsedQuery" : {
			"$and" : [
				{
					"data.talker" : {
						"$eq" : "gh_a1071eb140c7"
					}
				},
				{
					"utime" : {
						"$gte" : ISODate("2018-05-10T18:46:55.079Z")
					}
				}
			]
		},
		"winningPlan" : {
			"stage" : "FETCH",
			"filter" : {
				"data.talker" : {
					"$eq" : "gh_a1071eb140c7"
				}
			},
			"inputStage" : {
				"stage" : "IXSCAN",
				"keyPattern" : {
					"utime" : 1
				},
				"indexName" : "utime_1",
				"isMultiKey" : false,
				"isUnique" : false,
				"isSparse" : false,
				"isPartial" : false,
				"indexVersion" : 1,
				"direction" : "forward",
				"indexBounds" : {
					"utime" : [
						"[new Date(1525978015079), new Date(9223372036854775807)]"
					]
				}
			}
		},
		"rejectedPlans" : [
			{
				"stage" : "FETCH",
				"filter" : {
					"utime" : {
						"$gte" : ISODate("2018-05-10T18:46:55.079Z")
					}
				},
				"inputStage" : {
					"stage" : "IXSCAN",
					"keyPattern" : {
						"data.talker" : 1
					},
					"indexName" : "data.talker_1",
					"isMultiKey" : false,
					"isUnique" : false,
					"isSparse" : false,
					"isPartial" : false,
					"indexVersion" : 1,
					"direction" : "forward",
					"indexBounds" : {
						"data.talker" : [
							"[\"gh_a1071eb140c7\", \"gh_a1071eb140c7\"]"
						]
					}
				}
			}
		]
	},
	"executionStats" : {
		"executionSuccess" : true,
		"nReturned" : 99722,
		"executionTimeMillis" : 273,
		"totalKeysExamined" : 99732,
		"totalDocsExamined" : 99732,
		"executionStages" : {
			"stage" : "FETCH",
			"filter" : {
				"data.talker" : {
					"$eq" : "gh_a1071eb140c7"
				}
			},
			"nReturned" : 99722,
			"executionTimeMillisEstimate" : 240,
			"works" : 99733,
			"advanced" : 99722,
			"needTime" : 10,
			"needYield" : 0,
			"saveState" : 780,
			"restoreState" : 780,
			"isEOF" : 1,
			"invalidates" : 0,
			"docsExamined" : 99732,
			"alreadyHasObj" : 0,
			"inputStage" : {
				"stage" : "IXSCAN",
				"nReturned" : 99732,
				"executionTimeMillisEstimate" : 50,
				"works" : 99733,
				"advanced" : 99732,
				"needTime" : 0,
				"needYield" : 0,
				"saveState" : 780,
				"restoreState" : 780,
				"isEOF" : 1,
				"invalidates" : 0,
				"keyPattern" : {
					"utime" : 1
				},
				"indexName" : "utime_1",
				"isMultiKey" : false,
				"isUnique" : false,
				"isSparse" : false,
				"isPartial" : false,
				"indexVersion" : 1,
				"direction" : "forward",
				"indexBounds" : {
					"utime" : [
						"[new Date(1525978015079), new Date(9223372036854775807)]"
					]
				},
				"keysExamined" : 99732,
				"dupsTested" : 0,
				"dupsDropped" : 0,
				"seenInvalidated" : 0
			}
		}
	},
	"serverInfo" : {
		"host" : "crawltest004.soniu.com",
		"port" : 27018,
		"version" : "3.2.7",
		"gitVersion" : "4249c1d2b5999ebbf1fdf3bc0e0e3b3ff5c0aaf2"
	},
	"ok" : 1
}
> 






> db.biz_article.find({"utime" : {$gte:ISODate("2017-12-10T18:46:55.079Z")},"data.talker" : "gh_254089b5ba17"}).explain("executionStats")
{
	"queryPlanner" : {
		"plannerVersion" : 1,
		"namespace" : "wechat_v10.biz_article",
		"indexFilterSet" : false,
		"parsedQuery" : {
			"$and" : [
				{
					"data.talker" : {
						"$eq" : "gh_254089b5ba17"
					}
				},
				{
					"utime" : {
						"$gte" : ISODate("2017-12-10T18:46:55.079Z")
					}
				}
			]
		},
		"winningPlan" : {
			"stage" : "FETCH",
			"filter" : {
				"utime" : {
					"$gte" : ISODate("2017-12-10T18:46:55.079Z")
				}
			},
			"inputStage" : {
				"stage" : "IXSCAN",
				"keyPattern" : {
					"data.talker" : 1
				},
				"indexName" : "data.talker_1",
				"isMultiKey" : false,
				"isUnique" : false,
				"isSparse" : false,
				"isPartial" : false,
				"indexVersion" : 1,
				"direction" : "forward",
				"indexBounds" : {
					"data.talker" : [
						"[\"gh_254089b5ba17\", \"gh_254089b5ba17\"]"
					]
				}
			}
		},
		"rejectedPlans" : [
			{
				"stage" : "FETCH",
				"filter" : {
					"data.talker" : {
						"$eq" : "gh_254089b5ba17"
					}
				},
				"inputStage" : {
					"stage" : "IXSCAN",
					"keyPattern" : {
						"utime" : 1
					},
					"indexName" : "utime_1",
					"isMultiKey" : false,
					"isUnique" : false,
					"isSparse" : false,
					"isPartial" : false,
					"indexVersion" : 1,
					"direction" : "forward",
					"indexBounds" : {
						"utime" : [
							"[new Date(1512931615079), new Date(9223372036854775807)]"
						]
					}
				}
			}
		]
	},
	"executionStats" : {
		"executionSuccess" : true,
		"nReturned" : 202339,
		"executionTimeMillis" : 25004,
		"totalKeysExamined" : 202339,
		"totalDocsExamined" : 202339,
		"executionStages" : {
			"stage" : "FETCH",
			"filter" : {
				"utime" : {
					"$gte" : ISODate("2017-12-10T18:46:55.079Z")
				}
			},
			"nReturned" : 202339,
			"executionTimeMillisEstimate" : 22620,
			"works" : 202340,
			"advanced" : 202339,
			"needTime" : 0,
			"needYield" : 0,
			"saveState" : 2374,
			"restoreState" : 2374,
			"isEOF" : 1,
			"invalidates" : 0,
			"docsExamined" : 202339,
			"alreadyHasObj" : 0,
			"inputStage" : {
				"stage" : "IXSCAN",
				"nReturned" : 202339,
				"executionTimeMillisEstimate" : 440,
				"works" : 202340,
				"advanced" : 202339,
				"needTime" : 0,
				"needYield" : 0,
				"saveState" : 2374,
				"restoreState" : 2374,
				"isEOF" : 1,
				"invalidates" : 0,
				"keyPattern" : {
					"data.talker" : 1
				},
				"indexName" : "data.talker_1",
				"isMultiKey" : false,
				"isUnique" : false,
				"isSparse" : false,
				"isPartial" : false,
				"indexVersion" : 1,
				"direction" : "forward",
				"indexBounds" : {
					"data.talker" : [
						"[\"gh_254089b5ba17\", \"gh_254089b5ba17\"]"
					]
				},
				"keysExamined" : 202339,
				"dupsTested" : 0,
				"dupsDropped" : 0,
				"seenInvalidated" : 0
			}
		}
	},
	"serverInfo" : {
		"host" : "crawltest004.soniu.com",
		"port" : 27018,
		"version" : "3.2.7",
		"gitVersion" : "4249c1d2b5999ebbf1fdf3bc0e0e3b3ff5c0aaf2"
	},
	"ok" : 1
}
>



#后台索引 查找
> db.biz_article.find({"utime" : {$gte:ISODate("2017-12-10T18:46:55.079Z")},"data.talker" : "gh_254089b5ba17"}).explain("executionStats")
{
	"queryPlanner" : {
		"plannerVersion" : 1,
		"namespace" : "wechat_v10.biz_article",
		"indexFilterSet" : false,
		"parsedQuery" : {
			"$and" : [
				{
					"data.talker" : {
						"$eq" : "gh_254089b5ba17"
					}
				},
				{
					"utime" : {
						"$gte" : ISODate("2017-12-10T18:46:55.079Z")
					}
				}
			]
		},
		"winningPlan" : {
			"stage" : "FETCH",
			"filter" : {
				"utime" : {
					"$gte" : ISODate("2017-12-10T18:46:55.079Z")
				}
			},
			"inputStage" : {
				"stage" : "IXSCAN",
				"keyPattern" : {
					"data.talker" : 1
				},
				"indexName" : "data.talker_1",
				"isMultiKey" : false,
				"isUnique" : false,
				"isSparse" : false,
				"isPartial" : false,
				"indexVersion" : 1,
				"direction" : "forward",
				"indexBounds" : {
					"data.talker" : [
						"[\"gh_254089b5ba17\", \"gh_254089b5ba17\"]"
					]
				}
			}
		},
		"rejectedPlans" : [
			{
				"stage" : "FETCH",
				"filter" : {
					"data.talker" : {
						"$eq" : "gh_254089b5ba17"
					}
				},
				"inputStage" : {
					"stage" : "IXSCAN",
					"keyPattern" : {
						"utime" : 1
					},
					"indexName" : "utime_1",
					"isMultiKey" : false,
					"isUnique" : false,
					"isSparse" : false,
					"isPartial" : false,
					"indexVersion" : 1,
					"direction" : "forward",
					"indexBounds" : {
						"utime" : [
							"[new Date(1512931615079), new Date(9223372036854775807)]"
						]
					}
				}
			}
		]
	},
	"executionStats" : {
		"executionSuccess" : true,
		"nReturned" : 202339,
		"executionTimeMillis" : 45140,
		"totalKeysExamined" : 202339,
		"totalDocsExamined" : 202339,
		"executionStages" : {
			"stage" : "FETCH",
			"filter" : {
				"utime" : {
					"$gte" : ISODate("2017-12-10T18:46:55.079Z")
				}
			},
			"nReturned" : 202339,
			"executionTimeMillisEstimate" : 41330,
			"works" : 202340,
			"advanced" : 202339,
			"needTime" : 0,
			"needYield" : 0,
			"saveState" : 3234,
			"restoreState" : 3234,
			"isEOF" : 1,
			"invalidates" : 0,
			"docsExamined" : 202339,
			"alreadyHasObj" : 0,
			"inputStage" : {
				"stage" : "IXSCAN",
				"nReturned" : 202339,
				"executionTimeMillisEstimate" : 680,
				"works" : 202340,
				"advanced" : 202339,
				"needTime" : 0,
				"needYield" : 0,
				"saveState" : 3234,
				"restoreState" : 3234,
				"isEOF" : 1,
				"invalidates" : 0,
				"keyPattern" : {
					"data.talker" : 1
				},
				"indexName" : "data.talker_1",
				"isMultiKey" : false,
				"isUnique" : false,
				"isSparse" : false,
				"isPartial" : false,
				"indexVersion" : 1,
				"direction" : "forward",
				"indexBounds" : {
					"data.talker" : [
						"[\"gh_254089b5ba17\", \"gh_254089b5ba17\"]"
					]
				},
				"keysExamined" : 202339,
				"dupsTested" : 0,
				"dupsDropped" : 0,
				"seenInvalidated" : 0
			}
		}
	},
	"serverInfo" : {
		"host" : "crawltest004.soniu.com",
		"port" : 27018,
		"version" : "3.2.7",
		"gitVersion" : "4249c1d2b5999ebbf1fdf3bc0e0e3b3ff5c0aaf2"
	},
	"ok" : 1
}
































