
# 返回特定用户所有的登陆信息
/login/info/{name}					get

# 查看特定用户所有的关注信息
/public/list/{name}					get

# 所有用户订阅的所有公众号---全景展示
/public/list/all					get

# 查看所有公众号
/public/list						get

# 查看公众号黑名单
/public/blacklist					get


# 关注公众号
/subscribe/public/{publicname}		put delect
# 取关公众号
/unsubscribe/public/{publicname}	put
# 自动点赞
/automatic/approbate/				put 
# 自动发朋友圈
/automatic/show/					put 
# 自动检查账号可用性
/automatic/checkaccount/			put 
# 关注好友
/automatic/friends/					put 
