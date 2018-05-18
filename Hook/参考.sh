先来看看Hooking Android App 的Hook关键点实现Hook模块的注意点：
实现 IXposedHookLoadPackage接口
确定要Hook的Android App的包名
判断要Hook的包名
确定要Hook的AndroidApp的方法
findAndHookMethod 语法

https://blog.csdn.net/nicolelili1/article/details/52471820
https://blog.csdn.net/swimmer2000/article/details/52384817
https://blog.csdn.net/dzsw0117/article/details/79292608

https://blog.csdn.net/true_maitian/article/details/54922611
https://blog.csdn.net/eastmoon502136/article/details/50596806
https://blog.csdn.net/kmyhy/article/details/54929109

https://github.com/duqian291902259/WechatHook-Dusan
https://github.com/rovo89/XposedBridge/wiki/Development-tutorial
https://github.com/rovo89/XposedExamples/tree/master/RedClock
https://github.com/rovo89/XposedBridge
https://github.com/Gh0u1L5/WechatSpellbook



https://github.com/niray/WechatHook/blob/master/app/src/main/java/org/niray/wechatmoneyhook/Main.java


https://github.com/Nicky213Zhang/WeChatAssist/search?p=2&q=com.tencent.mm.&type=&utf8=%E2%9C%93
https://github.com/Gh0u1L5/WechatSpellbook/search?p=1&q=com.tencent&type=&utf8=%E2%9C%93



mAccessibilityService.execShellCmd("am force-stop com.tencent.mm");
mAccessibilityService.execShellCmd("input keyevent 3");
https://www.diycode.cc/topics/374



在mobile的浏览器内通过协议 weixin:// 来调用wechat内置浏览器而打开对应url ?
这个问题很多人问过，但是没有发现一个可行的方案，在第三方浏览器内，希望通过weixin://dl/businessWebview/link/?appid=%s&url=%s 使用微信浏览器打开对应url，这个貌似现在微信屏蔽了这个功能了，只能进入微信，但它内置浏览器不会被调用，其它的一些"weixin://dl/stickers"，"weixin://dl/games"，"weixin://dl/moments" 诸如此类的也不行了。现在还有没有更好的解决方法吗？如果是内部接口，要怎么样的流程去注册这个接口？


微信内置浏览器的JsAPI(WeixinJSBridge续)

https://www.baidufe.com/item/f07a3be0b23b4c9606bb.html


