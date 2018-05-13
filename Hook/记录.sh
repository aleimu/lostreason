
教你用Xposed模块征服微信！
http://www.miui.com/forum.php?mod=viewthread&tid=7369925 
#安装包
https://pan.lanzou.com/b44314



[Xposed框架]Android Hook 菜鸟入门教程三
https://www.52pojie.cn/thread-536890-1-1.html

https://www.jianshu.com/p/c5140d29112d


https://www.cnblogs.com/mumublog/articles/6053391.html
https://mp.weixin.qq.com/wiki?t=resource/res_main&id=mp1455784140

#代理设置
https://blog.csdn.net/wudinaniya/article/details/78841564



微信搜狗{


POST /mp/getappmsgext?f=json&uin=&key=&pass_ticket=&wxtoken=777&devicetype=&clientversion=&appmsg_token=&x5=0&f=json HTTP/1.1 
host : mp.weixin.qq.com 
connection : keep-alive 
content-length : 534 
origin : https://mp.weixin.qq.com 
x-requested-with : XMLHttpRequest 
user-agent : Mozilla/5.0 (Linux; Android 4.4.2; MI 6 Build/NMF26X) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/30.0.0.0 Mobile Safari/537.36 
content-type : application/x-www-form-urlencoded; charset=UTF-8 
accept : */* 
referer : https://mp.weixin.qq.com/s/rXxpqwR1evnRvHrPc9735Q 
accept-encoding : gzip,deflate 
accept-language : zh-CN,en-US;q=0.8 
cookie : rewardsn=; wxtokenkey=777 


request body


r=0.8862062327098101&__biz=MzI1Mjc4NDg5MQ%3D%3D&appmsg_type=6&mid=100000326&sn=5fccbf6ecf27140ab8691bdfc31e0dc8&idx=1&scene=&title=%25E7%25AD%2594%25E7%2596%2591%25E8%25A7%25A3%25E6%2583%2591&ct=1516599636&abtest_cookie=&devicetype=&version=%2Fmmbizwap%2Fzh_CN%2Fhtmledition%2Fjs%2Fappmsg%2Findex3db0db.js&is_need_ticket=0&is_need_ad=0&comment_id=0&is_need_reward=0&both_ad=0&reward


}



#url --weixin-post

https://mp.weixin.qq.com/mp/getappmsgext?f=json&uin=777&key=777&pass_ticket=vP3zWHMb0nWialMjpUMIXN7S5XydXddgU8Oc6l3sxfPZ9JDPgFp8HarU%25252Be%25252Fkc%25252BCI&wxtoken=777&devicetype=iOS11.3&clientversion=16060622&appmsg_token=952_0AtWRCoKHVN1zLxcdp5omIgLpGNcFZUOYaaK0U0RXa_At7HzvH4uEnuf2VwwimMWtUyxM924xVobwRCr&x5=0&f=json

通过appmsg_token和文章关联，其他参数和文章没有关系（文章源代码里appmsg_token值与该地址中的值相同）


https://mp.weixin.qq.com/mp/getappmsgext?f=json&uin=777&key=777&pass_ticket=vP3zWHMb0nWialMjpUMIXN7S5XydXddgU8Oc6l3sxfPZ9JDPgFp8HarU%25252Be%25252Fkc%25252BCI&wxtoken=777&devicetype=iOS11.3&clientversion=16060622&appmsg_token=952_0AtWRCoKHVN1zLxcdp5omIgLpGNcFZUOYaaK0U0RXa_At7HzvH4uEnuf2VwwimMWtUyxM924xVobwRCr&x5=0&f=json

# url --sogou-post

https://mp.weixin.qq.com/mp/getappmsgext?f=json&uin=&key=&pass_ticket=&wxtoken=777&devicetype=&clientversion=&appmsg_token=&x5=0&f=json

# 微信搜狗也会进行获取点赞输和阅读输的请求，但是由于部分信息获取不到，所以post了返回的也是报错



weixinbridge

夜神模拟器/屏幕密码 lgj@123



document.addEventListener("WeixinJSBridgeReady",function(){
    WeixinJSBridge.call("showToolbar")
});

https://developers.weixin.qq.com/miniprogram/dev/devtools/download.html?t=201714

https://down.52pojie.cn/Tools/Android_Tools/




# apk -->jar

apktool d -f D:\hook\package\wx6.6.5.apk -o D:\hook\package\tmp\


https://bitbucket.org/iBotPeaches/apktool/downloads/

https://blog.csdn.net/Fisher_3/article/details/78654450


# jar --> java
https://github.com/skylot/jadx
https://blog.csdn.net/Fisher_3/article/details/78654450
D:\hook\AndroidKiller_v1.3.1\bin\jadx\bin\jadx -d out classes-dex2jar.jar







D:\hook\AndroidKiller_v1.3.1\projects\WeXposed（微x模块）28_1.21



首先将目标apk文件的后缀改为.rar，比如base.apk改为base.rar，方便解压。
解压刚刚得到base.rar文件。可以看到解压出来的文件里面有一个的后缀名是.dex，名字一般来说是classes.dex，反正他是什么一会儿就输入什么。没错，dex2jar就是对他起作用的。
进入dex2jar的那一堆bat命令所在的文件夹，找到那个名字里面带有dex2jar.bat的bat命令，我的这个版本是这个

打开控制台，进入dex2jar所在的文件夹，注意，是那个有一大堆bat命令的地方，那才是终点。

输入命令 d2j-dex2jar.bat classes.dex的全路径（比如：E:\lypeer\classes.dex），敲回车。
然后稍等一会儿就可以看到在dex2jar的文件夹里多了一个jar包




d2j-dex2jar.bat classes.dex

#文件窗口多开
Q-Dir

微信浏览器 X5

搜索内容很多



GET /s?__biz=MzI1Mjc4NDg5MQ==&mid=100000326&idx=1&sn=5fccbf6ecf27140ab8691bdfc31e0dc8&chksm=69df3bd25ea8b2c4c090d67225ff6e67c8c03decfd216515e68177e3f37bb8ae8e31ce1467a5&scene=18&ascene=7&devicetype=android-19&version=26060632&nettype=WIFI&abtest_cookie=BQABAAoACwAMAA0AEgAIAD6LHgB3ix4AlYweANGOHgD%2Bjh4AQ48eAE%2BPHgCEjx4AAAA%3D&lang=zh_CN&pass_ticket=cYPKQXatcgjQhF8h7foJZqK9SYuxz1r%2FpPLgO6w8zg19jNt4wNIqrznMtnQHIyVF&wx_header=1 HTTP/1.1 
host : mp.weixin.qq.com 
connection : keep-alive 
accept : text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8 
x-wechat-uin : MjA3MDM2MTUwOQ%3D%3D 
x-wechat-key : 95dc4253938e3c7ba742c1cee1e9768e270c78aae72ae8ec5489da0d3650e1eb7feeceab2255928bf723842de2be47d523c600c95868aafeca49c7ad2e3ae9bc62cda3b2f887382d5b211203b02b7ef9 
user-agent : Mozilla/5.0 (Linux; Android 4.4.2; MI 6 Build/NMF26X) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/30.0.0.0 Mobile Safari/537.36 MicroMessenger/6.6.6.1300(0x26060632) NetType/WIFI Language/zh_CN 
accept-encoding : gzip,deflate 
accept-language : zh-CN,en-US;q=0.8 
cookie : rewardsn=; wxuin=2070361509; devicetype=android-19; version=26060632; lang=zh_CN; pass_ticket=uKmHdYg5L4ia/jLmdb0ZSwHUZANGt7O9iwmbZHgLoSudPwkZoL7N7tbb+vjDtosi; wap_sid2=CKXrnNsHElxRbDd3QWFCYTRvTGdwendMdFk3U0lPeDJSRVdEYlphel9aYmExX2xvaU5HQjg4bFhnMXdJMUJfdl9mOXprVFFOUWgxN3Jfc0dBaHlLYzNQUDFEdjR6THdEQUFBfjC7nt/XBTgNQAE=; wxtokenkey=777 
x-requested-with : com.tencent.mm


举个栗子，你要去知道手机某个应用包中的某个类中的某个方法中的某个参数，那么你的模块就要指明那个包，哪个类，哪个方法，当系统重启时加载目标应用包时，加载了你的模块的Xposed框架会识别到，接下来，如果你指明的应用中的某一方法被系统执行了，那么Xposed也会识别到，然后让你的模块去Hook（顾名思义，就是就是钩子，陷阱的意思；也可以说是拦截）这个方法，并可以利用模块的接口让方法的参数和返回结果暴露出来。


https://blog.csdn.net/yin1031468524/article/details/63254757

XPosed暴力列举Package下所有的方法调用
https://blog.csdn.net/swimmer2000/article/details/52384817




微信巫师
http://repo.xposed.info/module/com.gh0u1l5.wechatmagician
https://github.com/Gh0u1L5/WechatMagician
https://github.com/rovo89/XposedBridge




https://www.2cto.com/kf/201607/524588.html
https://blog.csdn.net/swimmer2000/article/details/52384817
http://burningcodes.net/%E4%BD%BF%E7%94%A8xposed-hook%E4%BB%BB%E6%84%8F%E5%87%BD%E6%95%B0/
https://www.cnblogs.com/dacainiao/p/6002830.html
https://github.com/boyliang/AllHookInOne

https://github.com/weechatfly


#做app
http://www.androiddevtools.cn/
https://blog.csdn.net/love4399/article/details/77164500
http://www.runoob.com/w3cnote/android-app-develop-learning.html
https://blog.csdn.net/it_beecoder/article/details/52662142
https://pan.baidu.com/s/1pLHsxf1#list/path=%2FAndroidStudio


是将TortoiseGit给卸载了,然后再在其官网下载了最新版本的重新安装了,安装后仍然需要再重启电
https://tortoisegit.org/download/
https://jingyan.baidu.com/article/359911f552827957fe0306f8.html
https://www.aliyun.com/jiaocheng/873811.html
