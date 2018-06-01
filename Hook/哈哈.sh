
{
java中的类修饰符、成员变量修饰符、方法修饰符


//类修饰符：
public（访问控制符），将一个类声明为公共类，他可以被任何对象访问，一个程序的主类必须是公共类。

abstract，将一个类声明为抽象类，没有实现的方法，需要子类提供方法实现。

final，将一个类生命为最终（即非继承类），表示他不能被其他类继承。

friendly，默认的修饰符，只有在相同包中的对象才能使用这样的类。


//成员变量修饰符：
public（公共访问控制符），指定该变量为公共的，他可以被任何对象的方法访问。

private（私有访问控制符）指定该变量只允许自己的类的方法访问，其他任何类（包括子类）中的方法均不能访问。

protected（保护访问控制符）指定该变量可以别被自己的类和子类访问。在子类中可以覆盖此变量。

friendly ，在同一个包中的类可以访问，其他包中的类不能访问。

final，最终修饰符，指定此变量的值不能变。

static（静态修饰符）指定变量被所有对象共享，即所有实例都可以使用该变量。变量属于这个类。

transient（过度修饰符）指定该变量是系统保留，暂无特别作用的临时性变量。

volatile（易失修饰符）指定该变量可以同时被几个线程控制和修改。


//方法修饰符：
public（公共控制符）

private（私有控制符）指定此方法只能有自己类等方法访问，其他的类不能访问（包括子类）

protected（保护访问控制符）指定该方法可以被它的类和子类进行访问。

final，指定该方法不能被重载。

static，指定不需要实例化就可以激活的一个方法。

synchronize，同步修饰符，在多个线程中，该修饰符用于在运行前，对他所属的方法加锁，以防止其他线程的访问，运行结束后解锁。

native，本地修饰符。指定此方法的方法体是用其他语言在程序外部编写的。	
	
}

{

        XposedHelpers.findAndHookMethod(Main.xWebx5Class, "shouldInterceptRequest", Main.wcWebViewClass, Main.webResReqCls, Bundle.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(final MethodHookParam param) throws Throwable {
                        Object webResReq = param.args[1];
                        final Map<String, String> headers = (Map) RefUtil.callDeclaredMethod(
                                webResReq, "getRequestHeaders", new Class[]{});
                        //XposedBridge.log("******headers********:" + headers);
                        boolean flag = headers.containsKey("Referer");
                        if(flag) {
                            final String referer = headers.get("Referer");
                            //XposedBridge.log("******Referer********:" + referer);
                            if (referer.contains("mp.weixin.qq.com")) {
                                Uri uri = (Uri) RefUtil.callDeclaredMethod(webResReq, "getUrl", new Class[]{});
                                final String url_Getappmsgext = uri.toString();
                                if ("/mp/getappmsgext".equals(uri.getPath())) {
                                    XposedBridge.log("---------------Main.RawUrl-------------------" + Main.RawUrl);
                                    XposedBridge.log("---------------cats[]-------------------" + cats[0]+cats[1]);

                                    Class webResResponse = classLoader.loadClass("com.tencent.smtt.export.external.interfaces.WebResourceResponse");
                                    param.setResult(webResResponse.newInstance());
                                    Uri referUri = Uri.parse(referer);
                                    StringBuilder body = new StringBuilder();
                                    body.append(referUri.getEncodedQuery())
                                            .append("&appmsg_type=9&is_need_ticket=0&is_need_ad=1&is_need_reward=0")
                                            .append("&both_ad=0&reward_uin_count=0&send_time=&msg_daily_idx=1&is_original=0&is_only_read=1");
                                    try {
                                        String ReqStr = sendPost(url_Getappmsgext, body.toString());
                                        XposedBridge.log("getappmsgext result:" + ReqStr);
                                        MsgExtBean ReqJson = MsgExtBean.buildFromJson(ReqStr);
                                        ReqJson.dumpInfo();
                                        int read_num = ReqJson.appmsgstat.read_num;
                                        int like_num = ReqJson.appmsgstat.like_num;
                                        XposedBridge.log("******read_num,like_num********:" + read_num + "|" + like_num);
                                        // 发送给注册端
                                        handleReadLike(referer, read_num, like_num);
                                    } catch (Exception e) {
                                        XposedBridge.log("get read_num like_num error:" + e);
                                    }
                                }
                            }
                        }
                    }
                });	
	
}

{
"weixin://addfriend"	
https://github.com/search?p=4&q=%22weixin%3A%2F%2Faddfriend%22&type=Code



tencent/mm/plugin/webview/ui/tools/jsapi/g
"open_biz_chat:unfollow"

https://github.com/fkzhang/WechatUnrecalled #666666666666

https://github.com/zhangxhbeta/wechat6.5.3

https://github.com/leej0hn/NonHelper/blob/915a679f1154ef4e3b7862df8deff26f3bcb3d5e/app/src/main/java/com/redscarf/nonhelper/hook/wechat/WechatHook.java # 666666666
}
