
https://blog.csdn.net/DJY1992/article/details/73168865

先来看看Hooking Android App 的Hook关键点实现Hook模块的注意点：

实现 IXposedHookLoadPackage接口
确定要Hook的Android App的包名
判断要Hook的包名
确定要Hook的AndroidApp的方法
findAndHookMethod 语法：
    XposedHelpers.findAndHookMethod(“包名+类名”,
    lpparam.classLoader, “要hook的函数名称”, 第一个参数类型, 第二个参数类型….., new
    XC_MethodHook() { protectedvoidbeforeHookedMethod(MethodHookParam
    param) {
           //函数执行之前要做的操作 } protectedvoidafterHookedMethod(MethodHookParam param) {
    //函数执行之后要做的操作 
	} });



https://servicewechat.com/js-engine


Module继承了IXposedHookLoadPackage接口，当系统加载应用包的时候回回调 handleLoadPackage；

XposedHelpers的静态方法 findAndHookMethod就是hook函数的的方法，其参数对应为   类名+loadPackageParam.classLoader（照写）+方法名+参数类型（根据所hook方法的参数的类型，即有多少个写多少个，加上.class）+XC_MethodHook回调接口；

这里的第一个参数类名必须要有包名前缀，即“packageName+className”，还有一点，如果代码被混淆过，即使你明知道代码中要hook的类名和方法名，但都不一定能用，必须以smali中的名字为准，比如：isOk()混淆之后在smali中的函数名为a，那么hook的时候就必须写a，而不是isOK，第一个参数类名同理！

参数里有一个监听类XC_MethodHook，该类在hook前后回调，通过回调方法的MethodHookParam可以拦截到函数参数


final Class <?> test = XposedHelpers.findClass("com.debug.xposed.xposedtest.test", lpparam.classLoader);
        final Class <?> testndk = XposedHelpers.findClass("com.debug.xposed.xposedtest.testndk", lpparam.classLoader);
        findAndHookMethod("com.debug.xposed.xposedtest.MainActivity", lpparam.classLoader, "testbtn", View.class, new XC_MethodHook() {

            @Override
            protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                XposedBridge.log("Hook之前");
                //getSign
            }

            @Override
            //函数执行后
            protected void afterHookedMethod(MethodHookParam param) throws Throwable {

                XposedBridge.log("Hook之后");
                try {
                    String str1 = (String) XposedHelpers.callMethod(param.thisObject, "test1");
                    Log.i("debug","mainactivity test1 return "+str1);
                    String str2 = (String) XposedHelpers.callMethod(param.thisObject, "test2","xposed input main test2");
                    Log.i("debug","mainactivity test2 return "+str2);

                    Object testObject = test.newInstance();
                    String str3 = (String) XposedHelpers.callMethod(testObject,"test1");
                    Log.i("debug","test test1 return= "+str3);
                    String str4 = (String) XposedHelpers.callMethod(testObject, "test2", "hello ", "txmg");
                    Log.i("debug","test test2 return= "+str4);

                    Object testndkobject = testndk.newInstance();
                    Method myteststr =  XposedHelpers.findMethodBestMatch(testndkobject.getClass(), "teststr");
                    String str5 = (String) myteststr.invoke(testndkobject);
                    Log.i("debug","ndk teststr return= "+str5);

                    Method mytest =  XposedHelpers.findMethodBestMatch(testndkobject.getClass(), "mytest"," gggg");
                    String str6 = (String) mytest.invoke(testndkobject,"mytest input test ");
                    Log.i("debug","ndk mytest return= "+str6);
                }catch (Exception e)
                {
                    e.printStackTrace();
                }

我在beforeHookedMethod中写了两种方法日志，第一个是XposedBridge的静态log，这个日志会显示在Xposed的日志选项里，个人不喜欢这种方法，因为每次运行你要hook的程序，又必须切换页面到Xposed查看日志，太麻烦了，但它有个优点，相比Android中的Log.d（），它能显示抛出的异常，而Android Log不可以。第二个Android Log就不用说了，这里我两种都用了。


https://blog.csdn.net/DJY1992/article/details/73168865
https://bbs.pediy.com/thread-225639.htm
封装了对Android的UI模拟操作的库
https://github.com/luili16/UIMocker



Xposed快速hook关键点
https://www.cnblogs.com/Supperlitt/p/7825960.html

    1、安装apk后，可以得到app使用的dex文件。

　　2、然后解包dex文件得到jar文件。

　　3、通过xposed读取jar中的所有类，

　　4、然后hook,然后读取所有方法hook.

　　5、然后通过关键字，匹配参数，匹配返回值，快速得到操作日志。

　　注意：如果是多个dex，一样是可以的，多个jar。解压然后覆盖保存到一个里面，然后打包成jar就可以，jar就使用zip打包工具就可以，修改后缀就ok.,

dex文件一般都可以通过apk解压得到，然后用apktool工具得到jar文件，针对某些apk无法apktool解包的可以添加-r等操作，不处理资源文件就OK.

　　懒加载plugin如何操作呢？ 找到不类呢？有一种情况，某些dex是专门存放插件，插件是进入到某些页面才会进行加载的，通过懒hook,进入某某页面，然后再进行hook操作，或者hook文件操作即可。





Xposed 包名类名加密要如何hook？多dex如何查找对应的方法？
https://blog.csdn.net/DJY1992/article/details/73168865

 XposedHelpers.findAndHookMethod(Application.class, "attach", Context.class, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                    ClassLoader cl = ((Context)param.args[0]).getClassLoader();
                    Class<?> hookclass = null;
                    try {
                        hookclass = cl.loadClass("xxx.xxx.xxx");
                    } catch (Exception e) {
                        Log.e("dujinyang", "查询报错"+e.getMessage());
                        return;
                    }
                    Log.i("dujinyang", "查询成功");
                    XposedHelpers.findAndHookMethod(hookclass, "xxx", new XC_MethodHook(){
                        //进行hook操作
                    });
                }
            });
			
			
			


import com.tencent.mm.plugin.webview.stub.d;
import com.tencent.mm.plugin.webview.ui.tools.jsapi.b;
import com.tencent.mm.pluginsdk.ui.tools.s;
import com.tencent.mm.protocal.JsapiPermissionWrapper;
import com.tencent.mm.sdk.platformtools.bi;
import com.tencent.mm.sdk.platformtools.x;


    try
    {
      d.d(this.tNB).evaluateJavascript("javascript:WeixinJSBridge._handleMessageFromWeixin(" + this.jau + ")", null);
      return;
    }
    catch (Exception localException)
    {
      x.e("MicroMsg.JsApiHandler", "onSearchWAWidgetReloadData fail, ex = %s", new Object[] { localException.getMessage() });
    }


E:\Zoe\Tools\AndroidKiller_v1.3.1\bin\apktool\jad.exe -d D:\Download\git_zip\class -s .java D:\Download\git_zip\class\webview

https://blog.csdn.net/DJY1992/article/details/73168865




https://blog.csdn.net/zhangmiaoping23/article/details/75375524
https://github.com/WooyunDota/DroidSSLUnpinning
https://github.com/Fuzion24/JustTrustMe




        XposedHelpers.findAndHookMethod(Application.class, "attach", Context.class, new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                Context context = (Context) param.args[0];
                ClassLoader classLoader = context.getClassLoader();
                hookActivity(classLoader);
            }
        });

        public void hookActivity(ClassLoader classLoader) {
            String className = "com.happyelements.hellolua.MainActivity";
            String methodName = "getSignature";
            XposedHelpers.findAndHookMethod(className, classLoader, methodName, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                    //todo
                }
            });
        }














String str = bi.convertStreamToString(paramMMWebView.getContext().getAssets().open("jsapi/wxjs.js"));
Object localObject1 = new StringBuilder("javascript:WeixinJSBridge._handleMessageFromWeixin(");


https://www.cnblogs.com/chaseHard/p/6202803.html
https://testerhome.com/topics/6954


安装包内搜索 business
"https://mp.weixin.qq.com/mp/wacomplain?action=show&appid=%s&pageid=%s&from=%d&&business_appid=%s#wechat_redirect"

weixin://dl/business/?ticket=  到底怎么生成的？调用以下接口

weixin://dl/scan 扫一扫
weixin://dl/feedback 反馈
weixin://dl/moments 朋友圈
weixin://dl/settings 设置
weixin://dl/notifications 消息通知设置
weixin://dl/chat 聊天设置
weixin://dl/general 通用设置
weixin://dl/officialaccounts 公众号
weixin://dl/games 游戏
weixin://dl/help 帮助
weixin://dl/feedback 反馈
weixin://dl/profile 个人信息
weixin://dl/features 功能插件


"weixin://dl/businessTempSession/"
"weixin://dl/businessWebview/link/"



版权归作者所有，任何形式转载请联系作者。
作者：yu（来自豆瓣）
来源：https://www.douban.com/note/653431692/

'weixin://dl/business/?ticket=t59a2235a3662135bfb0e8f7edccc22c5#wechat_redirect#wechat_redirect'


版权归作者所有，任何形式转载请联系作者。
作者：yu（来自豆瓣）
来源：https://www.douban.com/note/653431692/

https://open.weixin.qq.com/sns/webview?url=http%3A%2F%2Fun.m.jd.com%2Fcgi-bin%2Fapp%2Fappjmp%3Fto%3Dp.imtt.qq.com%252fh%253fd%253d7%2526b%253dtrade%2526type%253dsite%2526id%253d4061%2526u%253d%252568%252574%252574%252570%25253a%25252f%25252fvip.3.js.cn%252Fyyzs87.php%253Fticket%253D6148523063446f764c3364344c6d707764336775636d566b4c3364344c7a426c4e3251314d546b314f47466a4e7a6b314e5464694e57566a59575a6a4e546779595749324d6d51774c6d68306257772f644430784e54457a4d4451334d7a4d7a%2526from%253dshare%2526bid%253d13276%2526pid%253d1226104-1438221658%2526_wv%253d1027%2526sid%253dfavewofji%2526type%253d3%2526rnd%253d0.8738031948450953&appid=wxae3e8056daea8727&ts=1513047962&nonce=rjWsn6jYHv&sig=1c3d50cc9b948b2736398e1c1c66c32a&key=ad88abc27c4d295460ca3b05b7ed7a9a723ec81fbdb1e45386946920883a470f9b6e90cd75da4f05b8394a798f4b9446e673410a32c660224c93802cc47f427aa043de1c15cde5463ce4ad0ee5fecdd0&uin=MzY5MDEwNDExNQ%3D%3D&scene=0&version=26050839&pass_ticket=hKkz2FEs91MHFXEbW0vcmXwsfnKdDGqmvpQ1GG0cIYlqNFr5OcrssuH8DwD%2FSFmW




解决方案，将http://debugtbs.qq.com复制到微信对话框发送，然后进入就可以强制使用系统webview，删除x5tbs







webSetting.setJavaScriptCanOpenWindowsAutomatically(true)

setJavaScriptCanOpenWindowsAutomatically

mWebView = (WebView) findViewById(R.id.wv_action);  
        mWebView.getSettings().setJavaScriptEnabled(true);  
        mWebView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);  
        mWebView.addJavascriptInterface(new ExpJavaScriptInterface(), "android");  
        mWebView.loadUrl(webUrl);  
          
        mWebView.setWebChromeClient(wcc);   
          
//      findViewById(R.id.ll_descovery_action_back).setOnClickListener(this);  
  
  
        mWebView.setWebViewClient(new WebViewClient() {  
  
            @Override  
            public boolean shouldOverrideUrlLoading(WebView view, String url) {  
  
                LogUtils.d("url", " shouldOverrideUrlLoading == " + url);  
                // 如下方案可在非微信内部WebView的H5页面中调出微信支付  
                if (url.startsWith("weixin://wap/pay?")) {  
                    try{  
                        Intent intent = new Intent();  
                        intent.setAction(Intent.ACTION_VIEW);  
                        intent.setData(Uri.parse(url));  
                        startActivity(intent);  
  
                    }catch (ActivityNotFoundException e){  
                        MiscUtil.toastShortShow(mContext, "请安装微信最新版！");  
                    }  
                }else{  
                    view.loadUrl(url);  
                }  
                return true;  
            }  
  
            @Override  
            public void onPageStarted(WebView view, String url, Bitmap favicon) {  
                findViewById(R.id.pb_action_progress).setVisibility(View.VISIBLE);  
            }  
  
            @Override  
            public void onPageFinished(WebView view, String url) {  
                findViewById(R.id.pb_action_progress).setVisibility(View.GONE);  
                update();  
            }  
  
            @Override  
            public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {  
                view.stopLoading();  
                view.clearView();  
                view.loadUrl("about:blank");  
                view.clearHistory();  
                update();  
            }  
  
        });  
    }  
      


https://blog.csdn.net/sinat_35241409/article/details/79098724









代码:
        OpenWebviewReq *open = [[OpenWebviewReq alloc] init];
        open.url = parameter;
        [WXApi sendReq:open];

该接口为:调用微信内置浏览器打开网址.

但是总是提示跳转失败, 使用微信Demo,可以正常使用该接口,但更换成我的appid,就跳转失败

请教各位大神,求解决方法





    /**
     * 建议使用普通通知栏来实现打开URL，因为这样可以实现打开内部浏览器
     */
    private void openWebView(String url) {
        Log.e(TAG, "打开浏览器 -> " + url);
        // 请自行实现WebViewActivity
    }

# 微信源码
https://github.com/zhangxhbeta/wechat6.5.3


# 自动点击url进入文字
https://www.cnblogs.com/sasan/p/6978177.html
https://github.com/javaeryang/wechat/blob/1697b43bff8eda7ba42177d1f58c177f869f97f7/app/src/main/java/com/yang/java/wechat/WeHook.java
https://github.com/javaeryang/wechat
https://github.com/huhuang03/libs/blob/60a8b512fbd8689276e211a91d7b4dd566b6b362/android/anlib/wx_xposed/src/main/java/com/th/wx_xposed/server/bean/Classes.java

# 获取文章内容
https://github.com/bupthcp/weixinsrc/blob/8f429daa06526186d1b4c80fcec6e24d713e101b/weixinsrc/com/tencent/mm/ui/tools/WebViewUI.java
https://github.com/842137019/HelperX/blob/0e5afa4bcf66c40fbc4f3ee6e6a540a02741f801/app/src/main/java/com/cc/task/helperx/service/hook/HelperService.java


        // remove update
        XposedHelpers.findAndHookMethod("com.tencent.mm.sandbox.updater.AppUpdaterUI", loadPackageParam.classLoader, "onCreate",
                Bundle.class, new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
                        XposedBridge.log("[AppUpdaterUI] remove app updater ui");
                        ((Activity)param.thisObject).finish();
                    }
                });

        // remove fuck update install
//        XposedHelpers.findAndHookMethod("com.tencent.mm.sandbox.updater.AppInstallerUI", loadPackageParam.classLoader, "onCreate",
//                Bundle.class, new XC_MethodHook() {
//                    @Override
//                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
//                        super.afterHookedMethod(param);
//                        Log.d(Main.TAG, "[AppInstallerUI] remove fuck app updater install ui");
//                        ((Activity)param.thisObject).finish();
//                    }
//                });

        // dialog window
        XposedHelpers.findAndHookMethod("com.tencent.mm.ui.base.i", loadPackageParam.classLoader, "show",
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
                        Log.d(Main.TAG, "hook in dialog ...");
                        Dialog dialog = (Dialog) param.thisObject;
                        Button btn = (Button) XposedHelpers.callMethod(param.thisObject, "findViewById", 0x7f10071f);
                        if (btn!=null&&btn.isClickable()&&checkNeedClick(btn.getText().toString())) {
                            Log.d(Main.TAG, "click ok btn: "+btn.getText());
                            btn.performClick();
                        }
                    }
                });
    }


        XposedHelpers.findAndHookMethod("com.tencent.smtt.sdk.WebViewClient", loadPackageParam.classLoader, "onPageStarted",
                Main.webViewClass, String.class,Bitmap.class, new XC_MethodHook(){
                    @SuppressLint("NewApi")
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(final MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
                        // mAfterHookedMethod(mContext, param);
                        String url =(String) param.args[1];
                        XposedBridge.log("******url********:"+url);
                        if (url.contains("addchatroombyinvite")){
                            // add javascript to auto click post form
                            // XposedHelpers.callMethod(param.thisObject, "loadUrl", jsCode);
                            XposedHelpers.callMethod(param.args[0], "evaluateJavascript", Main.autoClickInvitationJsCode, null);
                        } else if(url.contains("weixin://jump/mainframe")){
                            // auto back
                            XposedHelpers.callMethod(param.args[0], "evaluateJavascript", "window.onload=function(){document.addEventListener('WeixinJSBridgeReady',function onBridgeReady(){WeixinJSBridge.call('closeWindow')});}", null);
                        }else if(url.contains("mp.weixin.qq.com")){
                            XposedHelpers.callMethod(param.args[0], "evaluateJavascript", "window.onload=function(){document.addEventListener('WeixinJSBridgeReady',function onBridgeReady(){WeixinJSBridge.call('closeWindow')});}", null);
                        }
                    }
                });


https://blog.csdn.net/luman1991/article/details/52887533







/*
        XposedHelpers.findAndHookMethod(Application.class, "attach", Context.class, new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                ClassLoader cl = ((Context)param.args[0]).getClassLoader();
                //Class<?> hookclass = null;
                try {
                    Main.webViewClientClass = cl.loadClass("com.tencent.smtt.sdk.WebViewClient");
                    //hookclass = cl.loadClass("xxx.xxx.xxx");
                } catch (Exception e) {
                    XposedBridge.log("查询报错"+e.getMessage());
                    return;
                }
                XposedBridge.log("查询成功");
                XposedHelpers.findAndHookMethod(Main.webViewClientClass, "shouldInterceptRequest", Main.wcWebViewClass, Main.webResReqCls, Bundle.class,
                        new XC_MethodHook() {
                            @Override
                            protected void afterHookedMethod(final MethodHookParam param) throws Throwable {
                                Object webResReq = param.args[1];
                                final Map<String, String> headers = (Map) RefUtil.callDeclaredMethod(
                                        webResReq, "getRequestHeaders", new Class[]{});
                                final String referer = headers.get("Referer");
                                Uri uri = (Uri) RefUtil.callDeclaredMethod(webResReq, "getUrl", new Class[]{});
                                final String url = uri.toString();
                                final String pass_ticket = uri.getQueryParameter("pass_ticket");
                                if ("/mp/getappmsgext".equals(uri.getPath())) {
                                    Class webResResponse = classLoader.loadClass(
                                            "com.tencent.smtt.export.external.interfaces.WebResourceResponse");
                                    param.setResult(webResResponse.newInstance());
                                    Uri referUri = Uri.parse(referer);
                                    StringBuilder body = new StringBuilder();
                                    body.append(referUri.getEncodedQuery())
                                            .append("&appmsg_type=9&is_need_ticket=0&is_need_ad=1&is_need_reward=0")
                                            .append("&both_ad=0&reward_uin_count=0&send_time=&msg_daily_idx=1&is_original=0&is_only_read=1");
                                    XposedBridge.log("******body********:"+body);
                                }
                            }
                        });
            }
        });
*/





{
	
	package com.iwencai.crawl.hechat.APPs.Wechat.functions;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.Paint;
import android.net.Uri;
import android.os.Bundle;
import android.os.Message;
import android.preference.PreferenceManager;
import android.util.Log;
import android.webkit.CookieManager;
import android.webkit.ValueCallback;
import android.app.Application;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.iwencai.crawl.hechat.APPs.Wechat.Main;
import com.iwencai.crawl.hechat.APPs.Wechat.helper.MContentValues;
import com.iwencai.crawl.hechat.Helper.BackgroundService;
import com.iwencai.crawl.hechat.Helper.Constant;
import com.iwencai.crawl.hechat.Helper.RefUtil;
import com.iwencai.crawl.hechat.Helper.Utils;
//import com.iwencai.crawl.hechat.Helper.WechatHookManager;
import com.iwencai.crawl.hechat.Helper.WorkStatusCallback;
import com.iwencai.crawl.hechat.Helper.ThreadUtil;
import com.iwencai.crawl.hechat.Helper.MsgExtBean;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingDeque;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

public class MsgHandler {

    // private static String packageName = "com.tencent.mm";

    private static ClassLoader classLoader;
    private static Context context;
    private static final Pattern articleUrlPattern = Pattern
            .compile("(https?://mp\\.weixin\\.qq\\.com.+?#rd)");

    private static final Pattern invitationUrlPattern = Pattern
            .compile("(https?:.+support\\.weixin\\.qq\\.com.+?addchatroombyinvite\\?.+?3[Dd])]");

    static Activity mActivity=null;

    private static void startWebViewUI(ClassLoader classLoader,String url) throws ClassNotFoundException {//打开微信网页
        if (mActivity != null){
            Class<?> WebViewUIclass=classLoader.loadClass("com.tencent.mm.plugin.webview.ui.tools.WebViewUI");
            XposedBridge.log("微信WebViewClass: "+WebViewUIclass.toString());
            Intent intent=new Intent(mActivity,WebViewUIclass);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.putExtra("rawUrl",url);
            mActivity.startActivity(intent);
        }else {
            hookMainActivity(classLoader);
        }
    }

    private static void hookMainActivity(ClassLoader classLoader){
        String cls="com.tencent.mm.ui.LauncherUI";
        XposedHelpers.findAndHookMethod(cls, classLoader, "onResume", new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                Object object=param.thisObject;
                mActivity= (Activity) object;
            }
        });
    }

    public static void hook(final String packageName, String sVersion, final Context mContext, XC_LoadPackage.LoadPackageParam loadPackageParam) {

        classLoader = loadPackageParam.classLoader;
        context = mContext;

        // if mVersion is empty, set mVersion and insert method package
        if (Main.mVersion == null||Main.mVersion.equals(""))
            setPkgNameWithVersion(sVersion);

        // if method package name is empty, return
        if (Main.databaseMethodPackage==null||Main.databaseMethodPackage.equals("")) {
            //Log.dd(Main.TAG, "Sorry I can't get database package");
            return;
        }

        // insertWithOnConflict(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;I)J
        // updateWithOnConflict(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;I)I

        // hook then insert method
        XposedHelpers.findAndHookMethod(Main.databaseMethodPackage, loadPackageParam.classLoader, Main.insertMethodName,
                String.class, String.class, ContentValues.class, int.class, new XC_MethodHook(){
                    @SuppressLint("NewApi")
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
//                        startWebViewUI(classLoader,"http://www.baidu.com");
                        insertAfterHookedMethod(mContext, param);
                    }
                });

        // update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
        XposedHelpers.findAndHookMethod(Main.databaseMethodPackage, loadPackageParam.classLoader, Main.updateMethodName,
                String.class, ContentValues.class, String.class, String[].class, int.class, new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
                        updateAfterHookedMethod(mContext, param);
                    }
                });

        // auto commit invitation
        // ".ui.widget.MMWebView"
        if (Main.webViewClass==null) {
            try{
                Main.webViewClass = classLoader.loadClass("com.tencent.smtt.sdk.WebView");
                XposedBridge.log("loadClass1....com.tencent.smtt.sdk.WebView...success!"+Main.webViewClass);
            }catch (Exception e){
                XposedBridge.log("loadClass1....com.tencent.smtt.sdk.WebView...error:"+e);
            }
        }

        if (Main.webViewClientClass == null) {
            try {
                Main.wcWebViewClass = classLoader.loadClass("com.tencent.smtt.sdk.WebView");
                Main.xWebx5Class = classLoader.loadClass("com.tencent.xweb.x5.j$2");
                Main.webResReqCls = classLoader.loadClass("com.tencent.smtt.export.external.interfaces.WebResourceRequest");
                XposedBridge.log("loadClass2....WebViewClient/webViewClientClass/WebResourceRequest...success!");
            } catch (Exception e) {
                XposedBridge.log("loadClass2....com.tencent.smtt.sdk.WebViewClient...error:"+e);
            }
        }
        if (Main.webViewClass==null)
            return;

        XposedHelpers.findAndHookMethod(Main.xWebx5Class, "shouldInterceptRequest", Main.wcWebViewClass, Main.webResReqCls, Bundle.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(final MethodHookParam param) throws Throwable {
                        XposedBridge.log("---------------shouldInterceptRequest-------------------start!");
                        Object webResReq = param.args[1];
                        final Map<String, String> headers = (Map) RefUtil.callDeclaredMethod(
                                webResReq, "getRequestHeaders", new Class[]{});
                        final String referer = headers.get("Referer");
                        Uri uri = (Uri) RefUtil.callDeclaredMethod(webResReq, "getUrl", new Class[]{});
                        final String url = uri.toString();
                        final String pass_ticket = uri.getQueryParameter("pass_ticket");
                        if ("/mp/getappmsgext".equals(uri.getPath())) {
                            XposedBridge.log("---------------url-------------------"+url);
                            Class webResResponse = classLoader.loadClass(
                                    "com.tencent.smtt.export.external.interfaces.WebResourceResponse");
                            param.setResult(webResResponse.newInstance());
                            Uri referUri = Uri.parse(referer);
                            StringBuilder body = new StringBuilder();
                            body.append(referUri.getEncodedQuery())
                                    .append("&appmsg_type=9&is_need_ticket=0&is_need_ad=1&is_need_reward=0")
                                    .append("&both_ad=0&reward_uin_count=0&send_time=&msg_daily_idx=1&is_original=0&is_only_read=1");
                            XposedBridge.log("******body********:"+body);

                            requesArticleExtInfo(url, body.toString(), new WorkStatusCallback() {
                                @Override
                                public void onSuccess(Object... params) {
                                    XposedBridge.log("******body********:"+params);
                                    MsgExtBean msgExt = (MsgExtBean) params[0];
                                    int read_num = msgExt.appmsgstat.read_num;
                                    int like_num = msgExt.appmsgstat.like_num;
                                    XposedBridge.log("******read_num********:"+read_num);
                                    XposedBridge.log("******like_num********:"+like_num);
                                }
                                @Override
                                public void onFailure() {
                                }
                            });
                        }
                    };
                });

        XposedHelpers.findAndHookMethod("com.tencent.smtt.sdk.WebViewClient", loadPackageParam.classLoader, "onPageStarted",
                Main.webViewClass, String.class,Bitmap.class, new XC_MethodHook(){
                    @SuppressLint("NewApi")
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(final MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
                        // mAfterHookedMethod(mContext, param);
                        String url =(String) param.args[1];
                        XposedBridge.log("******url********:"+url);
                        if (url.contains("addchatroombyinvite")){
                            // add javascript to auto click post form
                            // XposedHelpers.callMethod(param.thisObject, "loadUrl", jsCode);
                            XposedHelpers.callMethod(param.args[0], "evaluateJavascript", Main.autoClickInvitationJsCode, null);
                        } else if(url.contains("weixin://jump/mainframe")){
                            // auto back
                            XposedHelpers.callMethod(param.args[0], "evaluateJavascript", "window.onload=function(){document.addEventListener('WeixinJSBridgeReady',function onBridgeReady(){WeixinJSBridge.call('closeWindow')});}", null);
                        }else if(url.contains("mp.weixin.qq.com")){
                            XposedHelpers.callMethod(param.args[0], "evaluateJavascript", "window.onload=function(){document.addEventListener('WeixinJSBridgeReady',function onBridgeReady(){WeixinJSBridge.call('closeWindow')});}", null);
                        }
                    }
                });

        XposedHelpers.findAndHookMethod(Main.databaseMethodPackage, loadPackageParam.classLoader, Main.insertMethodName,
                String.class, String.class, ContentValues.class, int.class, new XC_MethodHook(){
                    @SuppressLint("NewApi")
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
                        insertAfterHookedMethod(mContext, param);
                    }
                });

    }

    private static final String TAG = "WechatHookManager";
    private static final String DB_SERVER_BIZ_URL = "http://db.laiyijie.me:8088/transfer/wechat/articles";
    private static final String DB_SERVER_SNS_URL = "http://db.laiyijie.me:8088/transfer/wechat/sns/timelines";

    private static final String Q_UA2 = "QV=3&PL=ADR&PR=WX&PP=com.tencent.mm&PPVN=6.6.3&TBSVC=43603&CO=BK&COVC=043909&PB=GE&VE=GA&DE=PHONE&CHID=0&LCID=9422&MO= PixelXL &RL=1440*2392&OS=7.1.2&API=25";
    private static final String Q_GUID ="b08a5edb5e2a655000ca6e7e13b788cb";
    private static final String UA = "Mozilla/5.0 (Linux; Android 7.1.2; Pixel XL Build/NZH54D; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/57.0.2987.132 MQQBrowser/6.2 TBS/043909 Mobile Safari/537.36 MicroMessenger/6.6.3.1260(0x26060336) NetType/WIFI Language/zh_CN";
    private static final String Q_AUTH ="31045b957cf33acf31e40be2f3e71c5217597676a9729f1b";

    private static final int LAUNCH_INTERVAL = 10000;
    private RequestQueue mRequestQueue;
    private Context mCtx;
    public static Context mAppContext;

    ThreadPoolExecutor mBizCaptureThreadPool;
    BlockingQueue<Runnable> mWorkQueue;

    public void WechatHookManager(Context context) {
        mCtx = context.getApplicationContext();
        //mRequestQueue = getRequestQueue();
        mWorkQueue = new LinkedBlockingDeque();
        mBizCaptureThreadPool = new ThreadPoolExecutor(
                6, 6, 3, TimeUnit.SECONDS, mWorkQueue);
    }

    public static void requesArticleExtInfo(final String extInfourl, final String body, final WorkStatusCallback callback) {
        StringRequest request = new StringRequest(Request.Method.POST, extInfourl,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(final String s) {
                        ThreadUtil.postOnWorkThread(new Runnable() {
                            @Override
                            public void run() {
                                MsgExtBean msgExt = MsgExtBean.buildFromJson(s);
                                msgExt.dumpInfo();
                                if (msgExt.appmsgstat == null) {
                                    XposedBridge.log( "request article extinfo error!");
                                    if (callback != null) {
                                        callback.onFailure();
                                    }
                                }

                                if (msgExt.appmsgstat != null) {
                                    if (callback != null) {
                                        callback.onSuccess(msgExt);
                                    }
                                }
                            }
                        });
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError volleyError) {
                XposedBridge.log("getappmsgext error " + volleyError);
                if (callback != null) {
                    callback.onFailure();
                }
            }
        }
        ) {

            @Override
            public byte[] getBody() throws AuthFailureError {
                return body.getBytes();
            }
        };
    }

    public static String getCookie() {
        CookieManager cookieManager = CookieManager.getInstance();
        return cookieManager.getCookie("https://mp.weixin.qq.com");
    }
    private Map<String, String> makeHttpHeader() {
        Map<String, String> header = new HashMap<>();
        header.put("Cookie", getCookie());
        header.put("Q-UA2", Q_UA2);
        header.put("Q-GUID", Q_GUID);
        header.put("Q-Auth", Q_AUTH);
        //header.put("Referer", referer);
        header.put("User-Agent", UA);
        header.put("X-Requested-With", "XMLHttpRequest");
        return header;
    }

    private static void updateAfterHookedMethod(final Context mContext, final XC_MethodHook.MethodHookParam params) {
        //Log.dd(Main.TAG, "Hooked "+Main.databaseMethodPackage+"."+Main.updateMethodName);

        ContentValues cvs = (ContentValues)params.args[1];

        String[] kValues = (String[])params.args[3];
        if (kValues==null) {
            return;
        }
        String kString = (String) params.args[2];

        Bundle bundle = new Bundle();
        String tableName = (String)params.args[0];
        bundle.putString("tableName", tableName);
        bundle.putInt("rowid", (int)params.args[4]);
        bundle.putLong("return_rowid", (int)params.getResult());
        bundle.putString("keyKey", kString);
        bundle.putCharSequenceArrayList("keyValue", new ArrayList<CharSequence>(Arrays.asList(kValues)));
        bundle.putString("method", "update");
        SharedPreferences sharedPreferences = mContext.getSharedPreferences("notify_key_pref_no_account", Context.MODE_MULTI_PROCESS);

        if (sharedPreferences!=null){
            bundle.putString("username", sharedPreferences.getString("login_weixin_username", Main.userName));
        }else{
            // not correct
            //Log.dd(Main.TAG, "get username error, with null of shared preferences");
            bundle.putString("username", Main.userName);
        }

        bundle.putSerializable("contentValues", new MContentValues().set(cvs));

        // because message handle is a static object
        // so we can use it directly
        Message msg = Message.obtain();
        msg.what = BackgroundService.MSG_TYPE_HOOK_PROCESS;
        msg.setData(bundle);
        BackgroundService.mHandler.sendMessage(msg);
    }

    private static void insertAfterHookedMethod(final Context mContext, final XC_MethodHook.MethodHookParam params) {
        // at here we get params of insert function
        // then we should send them to service to process
        //Log.dd(Main.TAG, "Hooked "+Main.databaseMethodPackage+"."+Main.insertMethodName);

        ContentValues cvs  = (ContentValues)params.args[2];
        String contentX = cvs.getAsString("content");
        if (contentX!=null&&contentX.startsWith("command:")) {
            String command = contentX.replace("command:", "");
            if (command.startsWith("webview:")) {
                String url = command.replace("webview:", "");
                try {
                    Intent intent = new Intent(context, classLoader.loadClass(Main.webViewUri));
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    intent.putExtra("rawUrl", url);
                    String intentString;
                    intentString = intent.toUri(0).toString().replace("android", Main.packageName);
                    mContext.startActivity(Intent.parseUri(intentString, 0));
                } catch (Exception e) {
                    Log.d(Main.TAG, e.toString());
                }
            }else if (command.startsWith("follow:")){
                String tid = command.replace("follow:", "");
                //Log.dd(Main.TAG, "Follow from chat command: "+tid);
                Intent intent = Utils.getStartChatting(null, tid).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                mContext.startActivity(intent);
            } else if (command.contains("mp.weixin.qq.com")){
                XposedBridge.log("start open web url:"+command);
                try {
                    startWebViewUI(classLoader,command);
                } catch (Exception e){
                    XposedBridge.log("open web error:"+e);
                }
                XposedBridge.log("end open web url:"+command);
            } else{
                Log.d(Main.TAG, "Unknow command: "+command);
            }
            return;
        }

        Bundle bundle = new Bundle();
        String tableName = (String)params.args[0];
        bundle.putString("tableName", tableName);
        bundle.putString("type", (String)params.args[1]);
        bundle.putInt("rowid", (int)params.args[3]);
        bundle.putLong("return_rowid", (long)params.getResult());
        bundle.putString("method", "insert");
        SharedPreferences sharedPreferences = mContext.getSharedPreferences("notify_key_pref_no_account", Context.MODE_MULTI_PROCESS);
        if (sharedPreferences!=null){
            bundle.putString("username", sharedPreferences.getString("login_weixin_username", Main.userName));
        }else{
            // not correct
            //Log.dd(Main.TAG, "get username error, with null of shared preferences");
            bundle.putString("username", Main.userName);
        }

        // add username
        // cvs.put("tableName", (String)params.args[0]);

        bundle.putSerializable("contentValues", new MContentValues().set(cvs));

        // because message handle is a static object
        // so we can use it directly
        Message msg = Message.obtain();
        msg.what = BackgroundService.MSG_TYPE_HOOK_PROCESS;
        msg.setData(bundle);
        BackgroundService.mHandler.sendMessage(msg);

        // this maybe a bad new
        // that we can't handle invitation without context
        // so we must do it at now, this make me sad.

        // process chat room invitation
        if (tableName.equals("message")&&cvs.getAsInteger("type")==49) {
            String content = cvs.getAsString("content");
            if (content==null)
                return;

            Matcher m = invitationUrlPattern.matcher(content);
            while(m.find()){
                String url = m.group(1);
                try {processChatRoomInvitation(mContext, url);} catch (Exception e){Log.d(Main.TAG, e.toString());e.printStackTrace();}
            }
        }
    }

    public static void process(Message msg) throws Exception {
        // this method call by service
        // handle params from hooked method.

        // we should know that,
        // this method call with intent
        // so async mode

        // get bundle out
        Bundle bundle = msg.getData();

        String tableName = bundle.getString("tableName");
        if (tableName==null)
            return;

        String type = bundle.getString("type");

        MContentValues mCvs = (MContentValues) bundle.getSerializable("contentValues");
        if (mCvs==null)
            return;

        ContentValues cvs = mCvs.get();
        // at here we get the table name, type and cvs.

        // send data by mqtt
        // yes at here we should send data back to server

        // from here we just to send a broadcast
        // to send data to our server.

        JSONObject data = new JSONObject();
        for (String k: cvs.keySet()) {
            try{data.putOpt(k, cvs.get(k));}catch (Exception e){Log.d(Main.TAG, e.toString());}
        }

        JSONObject parentData = new JSONObject();
        parentData.put("table_name", tableName);
        parentData.put("method", bundle.getString("method"));

        String keyKey  = bundle.getString("keyKey");
        ArrayList<CharSequence> keyValue = bundle.getCharSequenceArrayList("keyValue");

        if (keyKey!=null&&keyValue!=null) {
            JSONObject key = new JSONObject();
            key.put("key_key", keyKey);
            key.put("key_value", keyValue);
            parentData.put("key", key);
        }

        parentData.put("username", bundle.getString("username"));
        parentData.put("rowid", bundle.getInt("rowid"));
        parentData.put("return_rowid", bundle.getLong("return_rowid"));
        parentData.put("data", data);

        Intent intent =  new Intent();
        intent.putExtra("topic", Constant.TOPIC_SEND_MESSAGE);
        intent.putExtra("username", bundle.getString("username"));
        intent.putExtra("data", parentData.toString());
        // if necessary we need to transform data cross file storage
        // send broadcast
        intent.setAction(BackgroundService.BROADCAST_TYPE_SEND_MQTT);
        context.sendBroadcast(intent);

        switch (tableName) {
            case "rconversation":
                handleRconversation(tableName, type, cvs);
                break;
            case "message":
                handleMessage(tableName, type, cvs);
                break;
            default:
                break;
        }
    }

    private static void handleMessage(String tableName, String type, ContentValues cvs) throws Exception {

        //Log.di(com.iwencai.crawl.hechat.APPs.Wechat.Main.TAG, "received a message");

        // intent.putExtra("data", bundle).putExtra("topic", Constant.TOPIC_HEART_BEAT);
        // BackgroundService.MQTTClient.publishMessage(Constant.TOPIC_SEND_MESSAGE, data);

        if (tableName.equals("message")) {
            processMessage(cvs);
        }
    }

    private static void processMessage(ContentValues cvs) {
        String content = (String)cvs.get("content");
        if (cvs.get("type")==null) {
            return;
        }
        switch ((Integer)cvs.get("type")) {
            case 1:
                // normal message, we should to check if chat room invitation is here
                // break;
            case 49:
                // if 49, we should check char room invitation
                //  I'm sorry we can't get thing ok at here
            case 285212721:
                parseArticleXMLAndSend(content, (String)cvs.get("talker"));
                break;
            default:
                break;
        }
    }

    private static void processChatRoomInvitation(final Context mContext, String url) throws Exception {

        // as we all know
        // we should start webView activity
        // only when we are in the main launcher activity.

        // so things we should do
        // that starting the launcherUI at first
        // or maybe we can put this message in the context
        // and then when we start the launcherUI activity
        //  we get the message out and do things what we want to do

        // I think the first way is nice
        // Let's do it now

        // we can't do thing without context
        // so we should do what we want to do
        // as soon as possible
        // that means we should handle this process
        // directly on afterHook method
        // instead of through message handler.

        // make intent to open this url
        //Log.dd(Main.TAG, "invitation url: "+url);
        // as we know we had hook the url open method
        // so when we get real url from from WeChat
        // we can get all necessary params.
        // then we request directly.
        Class<?> webViewClass = classLoader.loadClass(Main.webViewUri);

        Intent intent = new Intent(context, webViewClass);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.putExtra("rawUrl", url);


        String intentString;
        intentString = intent.toUri(0).toString().replace("android", Main.packageName);

        try{
            mContext.startActivity(Intent.parseUri(intentString, 0));
            //Log.dd(Main.TAG, "start web view right now");
        }catch (Exception e){
            //Log.dd(Main.TAG, "get error: "+e.toString());
            //Log.dd(Main.TAG, "add to task queue, will start at next start activity");
            // put job to queue
            Bundle bundle = new Bundle();
            bundle.putString("type", Constant.TASK_TYPE_START_ACTIVITY);
            bundle.putString("intent", intentString);
            Main.taskAfterLauncherQueue.add(bundle);
        }
    }

    private static void handleRconversation(String tableName, String type, ContentValues cv) {
        //Log.di(com.iwencai.crawl.hechat.APPs.Wechat.Main.TAG, "Received a resource conversation, type: "+type);
        if (tableName.equals("rconversation") && cv.get("parentRef") != null && cv.get("parentRef").equals("officialaccounts")) {
            //Log.di(com.iwencai.crawl.hechat.APPs.Wechat.Main.TAG, "This is a article msg.");
            parseArticleXMLAndSend((String) cv.get("content"), (String) cv.get("talker"));
        }
    }

    private static void parseArticleXMLAndSend(String xml, String author) {
        if (xml == null) return;
        String url, title;
        Matcher m = articleUrlPattern.matcher(xml);
        while (m.find()) {
            url = m.group(0);
            title = ""; // m.group(1);
            //Log.dd(Main.TAG, "crawled article url: " + url);

            Bundle bundle = new Bundle();
            bundle.putString("url",  url + "#_FROM_HOOK_BY_ZOE_V2.0");
            bundle.putString("title", title);
            bundle.putString("author", author);

            Message message = Message.obtain();
            message.what = BackgroundService.MSG_TYPE_SAVE_ARTICLE;
            message.setData(bundle);
            BackgroundService.mHandler.sendMessage(message);
        }
    }

    private static void setPkgNameWithVersion(String version) {
        Main.mVersion = version;
        switch (version) {
            case "6.6.5":
                Main.databaseMethodPackage = "com.tencent.wcdb.database.SQLiteDatabase";
                Main.deviceWxLoginInjectMethodName = "initView";
                Main.deviceWxLoginButtonId = "asf";
                break;
            case "6.5.14":
                Main.databaseMethodPackage = "com.tencent.wcdb.database.SQLiteDatabase";
                Main.deviceWxLoginInjectMethodName = "KC";
                Main.deviceWxLoginCheckMethodName = "b";
                Main.deviceWxLoginLoginMethodName = "c";
                Main.deviceWxLoginButtonId = "akw";
                Main.followBizButtonId = "title";
                Main.chattingPackageName = Main.packageName + ".ui.chatting.En_5b8fbb1e";
                Main.chattingAddButtonId = "abs";
                Main.chattingAddButtonIdId  = 0x7f1005b2;
                Main.chattingLinearLayoutIdId = 0x7f0305b6;
                break;
            case "6.5.13":
                Main.databaseMethodPackage = "com.tencent.wcdb.database.SQLiteDatabase";
                break;
            case "6.5.10":
                Main.databaseMethodPackage ="com.tencent.wcdb.database.SQLiteDatabase";
                break;
            case "6.5.8":
                Main.databaseMethodPackage = "com.tencent.wcdb.database.SQLiteDatabase";
                break;
            case "6.3.18":
                Main.databaseMethodPackage = Main.packageName + ".bb.e";
                // Main.getUserNameFromModelPackage =  Main.packageName + ".model.ag";
                // Main.getUserNameMethodName = "y";
                Main.deviceWxLoginInjectMethodName = "Gz";
                Main.deviceWxLoginCheckMethodName = "b";
                Main.deviceWxLoginLoginMethodName = "c";
                break;
            default:
                Main.databaseMethodPackage = "com.tencent" + ".wcdb.database.SQLiteDatabase";

        }

        Main.deviceWxLoginUIPackage = Main.packageName + ".plugin.webwx.ui.ExtDeviceWXLoginUI";
        Main.webViewUri = Main.packageName + ".plugin.webview.ui.tools.WebViewUI";
    }

}


}


////////////////////////////////////
{

package com.iwencai.crawl.hechat.APPs.Wechat.functions;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.Paint;
import android.net.Uri;
import android.os.Bundle;
import android.os.Message;
import android.preference.PreferenceManager;
import android.util.Log;
import android.webkit.CookieManager;
import android.webkit.ValueCallback;
import android.app.Application;
/*
import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
*/
import com.iwencai.crawl.hechat.APPs.Wechat.Main;
import com.iwencai.crawl.hechat.APPs.Wechat.helper.MContentValues;
import com.iwencai.crawl.hechat.Helper.BackgroundService;
import com.iwencai.crawl.hechat.Helper.Constant;
import com.iwencai.crawl.hechat.Helper.RefUtil;
import com.iwencai.crawl.hechat.Helper.Utils;
//import com.iwencai.crawl.hechat.Helper.WechatHookManager;
import com.iwencai.crawl.hechat.Helper.WorkStatusCallback;
import com.iwencai.crawl.hechat.Helper.ThreadUtil;
import com.iwencai.crawl.hechat.Helper.MsgExtBean;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingDeque;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

public class MsgHandler {

    // private static String packageName = "com.tencent.mm";

    private static ClassLoader classLoader;
    private static Context context;
    private static final Pattern articleUrlPattern = Pattern
            .compile("(https?://mp\\.weixin\\.qq\\.com.+?#rd)");

    private static final Pattern invitationUrlPattern = Pattern
            .compile("(https?:.+support\\.weixin\\.qq\\.com.+?addchatroombyinvite\\?.+?3[Dd])]");

    static Activity mActivity=null;

    private static void startWebViewUI(ClassLoader classLoader,String url) throws ClassNotFoundException {//打开微信网页
        if (mActivity != null){
            Class<?> WebViewUIclass=classLoader.loadClass("com.tencent.mm.plugin.webview.ui.tools.WebViewUI");
            XposedBridge.log("微信WebViewClass: "+WebViewUIclass.toString());
            Intent intent=new Intent(mActivity,WebViewUIclass);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.putExtra("rawUrl",url);
            mActivity.startActivity(intent);
        }else {
            hookMainActivity(classLoader);
        }
    }

    private static void hookMainActivity(ClassLoader classLoader){
        String cls="com.tencent.mm.ui.LauncherUI";
        XposedHelpers.findAndHookMethod(cls, classLoader, "onResume", new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                Object object=param.thisObject;
                mActivity= (Activity) object;
            }
        });
    }

    public static void hook(final String packageName, String sVersion, final Context mContext, XC_LoadPackage.LoadPackageParam loadPackageParam) {

        classLoader = loadPackageParam.classLoader;
        context = mContext;

        // if mVersion is empty, set mVersion and insert method package
        if (Main.mVersion == null||Main.mVersion.equals(""))
            setPkgNameWithVersion(sVersion);

        // if method package name is empty, return
        if (Main.databaseMethodPackage==null||Main.databaseMethodPackage.equals("")) {
            //Log.dd(Main.TAG, "Sorry I can't get database package");
            return;
        }

        // insertWithOnConflict(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;I)J
        // updateWithOnConflict(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;I)I

        // hook then insert method
        XposedHelpers.findAndHookMethod(Main.databaseMethodPackage, loadPackageParam.classLoader, Main.insertMethodName,
                String.class, String.class, ContentValues.class, int.class, new XC_MethodHook(){
                    @SuppressLint("NewApi")
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
//                        startWebViewUI(classLoader,"http://www.baidu.com");
                        insertAfterHookedMethod(mContext, param);
                    }
                });

        // update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
        XposedHelpers.findAndHookMethod(Main.databaseMethodPackage, loadPackageParam.classLoader, Main.updateMethodName,
                String.class, ContentValues.class, String.class, String[].class, int.class, new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
                        updateAfterHookedMethod(mContext, param);
                    }
                });

        // auto commit invitation
        // ".ui.widget.MMWebView"
        if (Main.webViewClass==null) {
            try{
                Main.webViewClass = classLoader.loadClass("com.tencent.smtt.sdk.WebView");
                XposedBridge.log("loadClass1....com.tencent.smtt.sdk.WebView...success!"+Main.webViewClass);
            }catch (Exception e){
                XposedBridge.log("loadClass1....com.tencent.smtt.sdk.WebView...error:"+e);
            }
        }

        if (Main.webViewClientClass == null) {
            try {
                Main.wcWebViewClass = classLoader.loadClass("com.tencent.smtt.sdk.WebView");
                Main.xWebx5Class = classLoader.loadClass("com.tencent.xweb.x5.j$2");
                Main.webResReqCls = classLoader.loadClass("com.tencent.smtt.export.external.interfaces.WebResourceRequest");
                XposedBridge.log("loadClass2....WebViewClient/webViewClientClass/WebResourceRequest...success!");
            } catch (Exception e) {
                XposedBridge.log("loadClass2....com.tencent.smtt.sdk.WebViewClient...error:"+e);
            }
        }
        if (Main.webViewClass==null)
            return;

        XposedHelpers.findAndHookMethod(Main.xWebx5Class, "shouldInterceptRequest", Main.wcWebViewClass, Main.webResReqCls, Bundle.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(final MethodHookParam param) throws Throwable {
                        XposedBridge.log("---------------shouldInterceptRequest-------------------start!");
                        Object webResReq = param.args[1];
                        final Map<String, String> headers = (Map) RefUtil.callDeclaredMethod(
                                webResReq, "getRequestHeaders", new Class[]{});
                        final String referer = headers.get("Referer");
                        Uri uri = (Uri) RefUtil.callDeclaredMethod(webResReq, "getUrl", new Class[]{});
                        final String url = uri.toString();
                        final String pass_ticket = uri.getQueryParameter("pass_ticket");
                        if ("/mp/getappmsgext".equals(uri.getPath())) {
                            XposedBridge.log("---------------url-------------------"+url);
                            Class webResResponse = classLoader.loadClass(
                                    "com.tencent.smtt.export.external.interfaces.WebResourceResponse");
                            param.setResult(webResResponse.newInstance());
                            Uri referUri = Uri.parse(referer);
                            StringBuilder body = new StringBuilder();
                            body.append(referUri.getEncodedQuery())
                                    .append("&appmsg_type=9&is_need_ticket=0&is_need_ad=1&is_need_reward=0")
                                    .append("&both_ad=0&reward_uin_count=0&send_time=&msg_daily_idx=1&is_original=0&is_only_read=1");
                            XposedBridge.log("******body********:"+body);
                            try{
                                String ReqStr = sendPost(url,body.toString());
                                XposedBridge.log("******Reqstr********:"+ReqStr);
                                MsgExtBean ReqJson = MsgExtBean.buildFromJson(ReqStr);
                                ReqJson.dumpInfo();
                                int read_num = ReqJson.appmsgstat.read_num;
                                int like_num = ReqJson.appmsgstat.like_num;
                                XposedBridge.log("******read_num********:"+read_num);
                                XposedBridge.log("******like_num********:"+like_num);
                            } catch (Exception e) {
                                XposedBridge.log("get read_num like_num error:"+e);
                            }

                            /*
                            makeHttpHeader();
                            requesArticleExtInfo(url, body.toString(), new WorkStatusCallback() {
                                @Override
                                public void onSuccess(Object... params) {
                                    XposedBridge.log("******body********:"+params);
                                    MsgExtBean msgExt = (MsgExtBean) params[0];
                                    int read_num = msgExt.appmsgstat.read_num;
                                    int like_num = msgExt.appmsgstat.like_num;
                                    XposedBridge.log("******read_num********:"+read_num);
                                    XposedBridge.log("******like_num********:"+like_num);
                                }
                                @Override
                                public void onFailure() {
                                }
                            });
                            */
                        }
                    };
                });

        XposedHelpers.findAndHookMethod("com.tencent.smtt.sdk.WebViewClient", loadPackageParam.classLoader, "onPageStarted",
                Main.webViewClass, String.class,Bitmap.class, new XC_MethodHook(){
                    @SuppressLint("NewApi")
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(final MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
                        // mAfterHookedMethod(mContext, param);
                        String url =(String) param.args[1];
                        XposedBridge.log("******url********:"+url);
                        if (url.contains("addchatroombyinvite")){
                            // add javascript to auto click post form
                            // XposedHelpers.callMethod(param.thisObject, "loadUrl", jsCode);
                            XposedHelpers.callMethod(param.args[0], "evaluateJavascript", Main.autoClickInvitationJsCode, null);
                        } else if(url.contains("weixin://jump/mainframe")){
                            // auto back
                            XposedHelpers.callMethod(param.args[0], "evaluateJavascript", "window.onload=function(){document.addEventListener('WeixinJSBridgeReady',function onBridgeReady(){WeixinJSBridge.call('closeWindow')});}", null);
                        }else if(url.contains("mp.weixin.qq.com")){
                            XposedHelpers.callMethod(param.args[0], "evaluateJavascript", "window.onload=function(){document.addEventListener('WeixinJSBridgeReady',function onBridgeReady(){WeixinJSBridge.call('closeWindow')});}", null);
                        }
                    }
                });

        XposedHelpers.findAndHookMethod(Main.databaseMethodPackage, loadPackageParam.classLoader, Main.insertMethodName,
                String.class, String.class, ContentValues.class, int.class, new XC_MethodHook(){
                    @SuppressLint("NewApi")
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
                        insertAfterHookedMethod(mContext, param);
                    }
                });

    }

    private static final String TAG = "WechatHookManager";
    private static final String DB_SERVER_BIZ_URL = "http://db.laiyijie.me:8088/transfer/wechat/articles";
    private static final String DB_SERVER_SNS_URL = "http://db.laiyijie.me:8088/transfer/wechat/sns/timelines";

    private static final String Q_UA2 = "QV=3&PL=ADR&PR=WX&PP=com.tencent.mm&PPVN=6.6.3&TBSVC=43603&CO=BK&COVC=043909&PB=GE&VE=GA&DE=PHONE&CHID=0&LCID=9422&MO= PixelXL &RL=1440*2392&OS=7.1.2&API=25";
    private static final String Q_GUID ="b08a5edb5e2a655000ca6e7e13b788cb";
    private static final String UA = "Mozilla/5.0 (Linux; Android 7.1.2; Pixel XL Build/NZH54D; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/57.0.2987.132 MQQBrowser/6.2 TBS/043909 Mobile Safari/537.36 MicroMessenger/6.6.3.1260(0x26060336) NetType/WIFI Language/zh_CN";
    private static final String Q_AUTH ="31045b957cf33acf31e40be2f3e71c5217597676a9729f1b";

    /*
    private static final int LAUNCH_INTERVAL = 10000;
    private RequestQueue mRequestQueue;
    private Context mCtx;
    public static Context mAppContext;

    ThreadPoolExecutor mBizCaptureThreadPool;
    BlockingQueue<Runnable> mWorkQueue;

    public void WechatHookManager(Context context) {
        mCtx = context.getApplicationContext();
        //mRequestQueue = getRequestQueue();
        mWorkQueue = new LinkedBlockingDeque();
        mBizCaptureThreadPool = new ThreadPoolExecutor(
                6, 6, 3, TimeUnit.SECONDS, mWorkQueue);
    }

    public static void requesArticleExtInfo(final String extInfourl, final String body, final WorkStatusCallback callback) {
        StringRequest request = new StringRequest(Request.Method.POST, extInfourl,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(final String s) {
                        ThreadUtil.postOnWorkThread(new Runnable() {
                            @Override
                            public void run() {
                                MsgExtBean msgExt = MsgExtBean.buildFromJson(s);
                                msgExt.dumpInfo();
                                if (msgExt.appmsgstat == null) {
                                    XposedBridge.log( "request article extinfo error!");
                                    if (callback != null) {
                                        callback.onFailure();
                                    }
                                }

                                if (msgExt.appmsgstat != null) {
                                    if (callback != null) {
                                        callback.onSuccess(msgExt);
                                    }
                                }
                            }
                        });
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError volleyError) {
                XposedBridge.log("getappmsgext error " + volleyError);
                if (callback != null) {
                    callback.onFailure();
                }
            }
        }
        ) {
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                return makeHttpHeader();
            }
            @Override
            public byte[] getBody() throws AuthFailureError {
                return body.getBytes();
            }
        };
    }
*/
    public static String getCookie() {
        CookieManager cookieManager = CookieManager.getInstance();
        return cookieManager.getCookie("https://mp.weixin.qq.com");
    }
    public static Map<String, String> makeHttpHeader() {
        Map<String, String> header = new HashMap<>();
        header.put("Cookie", getCookie());
        header.put("Q-UA2", Q_UA2);
        header.put("Q-GUID", Q_GUID);
        header.put("Q-Auth", Q_AUTH);
        //header.put("Referer", referer);
        header.put("User-Agent", UA);
        header.put("X-Requested-With", "XMLHttpRequest");
        XposedBridge.log("*******header******"+header.toString());
        return header;
    }

    public static String sendPost(String url, String param) {
        PrintWriter out = null;
        BufferedReader in = null;
        String result = "";
        try {
            URL realUrl = new URL(url);
            // 打开和URL之间的连接
            URLConnection conn = realUrl.openConnection();
            // 设置通用的请求属性
            conn.setRequestProperty("accept", "*/*");
            conn.setRequestProperty("connection", "Keep-Alive");
            // 设置请求属性
            conn.setRequestProperty("user-agent", UA);
            conn.setRequestProperty("Cookie", getCookie());
            conn.setRequestProperty("Q-UA2", Q_UA2);
            conn.setRequestProperty("Q-GUID", Q_GUID);
            conn.setRequestProperty("Q-Auth", Q_AUTH);
            conn.setRequestProperty("X-Requested-With", "XMLHttpRequest");
            // 发送POST请求必须设置如下两行
            conn.setDoOutput(true);
            conn.setDoInput(true);
            // 获取URLConnection对象对应的输出流
            out = new PrintWriter(conn.getOutputStream());
            // 发送请求参数
            out.print(param);
            // flush输出流的缓冲
            out.flush();
            // 定义BufferedReader输入流来读取URL的响应
            in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            System.out.println("发送 POST 请求出现异常！"+e);
            e.printStackTrace();
        }
        //使用finally块来关闭输出流、输入流
        finally{
            try{
                if(out!=null){
                    out.close();
                }
                if(in!=null){
                    in.close();
                }
            }
            catch(IOException ex){
                ex.printStackTrace();
            }
        }
        return result;
    }


    private static void updateAfterHookedMethod(final Context mContext, final XC_MethodHook.MethodHookParam params) {
        //Log.dd(Main.TAG, "Hooked "+Main.databaseMethodPackage+"."+Main.updateMethodName);

        ContentValues cvs = (ContentValues)params.args[1];

        String[] kValues = (String[])params.args[3];
        if (kValues==null) {
            return;
        }
        String kString = (String) params.args[2];

        Bundle bundle = new Bundle();
        String tableName = (String)params.args[0];
        bundle.putString("tableName", tableName);
        bundle.putInt("rowid", (int)params.args[4]);
        bundle.putLong("return_rowid", (int)params.getResult());
        bundle.putString("keyKey", kString);
        bundle.putCharSequenceArrayList("keyValue", new ArrayList<CharSequence>(Arrays.asList(kValues)));
        bundle.putString("method", "update");
        SharedPreferences sharedPreferences = mContext.getSharedPreferences("notify_key_pref_no_account", Context.MODE_MULTI_PROCESS);

        if (sharedPreferences!=null){
            bundle.putString("username", sharedPreferences.getString("login_weixin_username", Main.userName));
        }else{
            // not correct
            //Log.dd(Main.TAG, "get username error, with null of shared preferences");
            bundle.putString("username", Main.userName);
        }

        bundle.putSerializable("contentValues", new MContentValues().set(cvs));

        // because message handle is a static object
        // so we can use it directly
        Message msg = Message.obtain();
        msg.what = BackgroundService.MSG_TYPE_HOOK_PROCESS;
        msg.setData(bundle);
        BackgroundService.mHandler.sendMessage(msg);
    }

    private static void insertAfterHookedMethod(final Context mContext, final XC_MethodHook.MethodHookParam params) {
        // at here we get params of insert function
        // then we should send them to service to process
        //Log.dd(Main.TAG, "Hooked "+Main.databaseMethodPackage+"."+Main.insertMethodName);

        ContentValues cvs  = (ContentValues)params.args[2];
        String contentX = cvs.getAsString("content");
        if (contentX!=null&&contentX.startsWith("command:")) {
            String command = contentX.replace("command:", "");
            if (command.startsWith("webview:")) {
                String url = command.replace("webview:", "");
                try {
                    Intent intent = new Intent(context, classLoader.loadClass(Main.webViewUri));
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    intent.putExtra("rawUrl", url);
                    String intentString;
                    intentString = intent.toUri(0).toString().replace("android", Main.packageName);
                    mContext.startActivity(Intent.parseUri(intentString, 0));
                } catch (Exception e) {
                    Log.d(Main.TAG, e.toString());
                }
            }else if (command.startsWith("follow:")){
                String tid = command.replace("follow:", "");
                //Log.dd(Main.TAG, "Follow from chat command: "+tid);
                Intent intent = Utils.getStartChatting(null, tid).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                mContext.startActivity(intent);
            } else if (command.contains("mp.weixin.qq.com")){
                XposedBridge.log("start open web url:"+command);
                try {
                    startWebViewUI(classLoader,command);
                } catch (Exception e){
                    XposedBridge.log("open web error:"+e);
                }
                XposedBridge.log("end open web url:"+command);
            } else{
                Log.d(Main.TAG, "Unknow command: "+command);
            }
            return;
        }

        Bundle bundle = new Bundle();
        String tableName = (String)params.args[0];
        bundle.putString("tableName", tableName);
        bundle.putString("type", (String)params.args[1]);
        bundle.putInt("rowid", (int)params.args[3]);
        bundle.putLong("return_rowid", (long)params.getResult());
        bundle.putString("method", "insert");
        SharedPreferences sharedPreferences = mContext.getSharedPreferences("notify_key_pref_no_account", Context.MODE_MULTI_PROCESS);
        if (sharedPreferences!=null){
            bundle.putString("username", sharedPreferences.getString("login_weixin_username", Main.userName));
        }else{
            // not correct
            //Log.dd(Main.TAG, "get username error, with null of shared preferences");
            bundle.putString("username", Main.userName);
        }

        // add username
        // cvs.put("tableName", (String)params.args[0]);

        bundle.putSerializable("contentValues", new MContentValues().set(cvs));

        // because message handle is a static object
        // so we can use it directly
        Message msg = Message.obtain();
        msg.what = BackgroundService.MSG_TYPE_HOOK_PROCESS;
        msg.setData(bundle);
        BackgroundService.mHandler.sendMessage(msg);

        // this maybe a bad new
        // that we can't handle invitation without context
        // so we must do it at now, this make me sad.

        // process chat room invitation
        if (tableName.equals("message")&&cvs.getAsInteger("type")==49) {
            String content = cvs.getAsString("content");
            if (content==null)
                return;

            Matcher m = invitationUrlPattern.matcher(content);
            while(m.find()){
                String url = m.group(1);
                try {processChatRoomInvitation(mContext, url);} catch (Exception e){Log.d(Main.TAG, e.toString());e.printStackTrace();}
            }
        }
    }

    public static void process(Message msg) throws Exception {
        // this method call by service
        // handle params from hooked method.

        // we should know that,
        // this method call with intent
        // so async mode

        // get bundle out
        Bundle bundle = msg.getData();

        String tableName = bundle.getString("tableName");
        if (tableName==null)
            return;

        String type = bundle.getString("type");

        MContentValues mCvs = (MContentValues) bundle.getSerializable("contentValues");
        if (mCvs==null)
            return;

        ContentValues cvs = mCvs.get();
        // at here we get the table name, type and cvs.

        // send data by mqtt
        // yes at here we should send data back to server

        // from here we just to send a broadcast
        // to send data to our server.

        JSONObject data = new JSONObject();
        for (String k: cvs.keySet()) {
            try{data.putOpt(k, cvs.get(k));}catch (Exception e){Log.d(Main.TAG, e.toString());}
        }

        JSONObject parentData = new JSONObject();
        parentData.put("table_name", tableName);
        parentData.put("method", bundle.getString("method"));

        String keyKey  = bundle.getString("keyKey");
        ArrayList<CharSequence> keyValue = bundle.getCharSequenceArrayList("keyValue");

        if (keyKey!=null&&keyValue!=null) {
            JSONObject key = new JSONObject();
            key.put("key_key", keyKey);
            key.put("key_value", keyValue);
            parentData.put("key", key);
        }

        parentData.put("username", bundle.getString("username"));
        parentData.put("rowid", bundle.getInt("rowid"));
        parentData.put("return_rowid", bundle.getLong("return_rowid"));
        parentData.put("data", data);

        Intent intent =  new Intent();
        intent.putExtra("topic", Constant.TOPIC_SEND_MESSAGE);
        intent.putExtra("username", bundle.getString("username"));
        intent.putExtra("data", parentData.toString());
        // if necessary we need to transform data cross file storage
        // send broadcast
        intent.setAction(BackgroundService.BROADCAST_TYPE_SEND_MQTT);
        context.sendBroadcast(intent);

        switch (tableName) {
            case "rconversation":
                handleRconversation(tableName, type, cvs);
                break;
            case "message":
                handleMessage(tableName, type, cvs);
                break;
            default:
                break;
        }
    }

    private static void handleMessage(String tableName, String type, ContentValues cvs) throws Exception {

        //Log.di(com.iwencai.crawl.hechat.APPs.Wechat.Main.TAG, "received a message");

        // intent.putExtra("data", bundle).putExtra("topic", Constant.TOPIC_HEART_BEAT);
        // BackgroundService.MQTTClient.publishMessage(Constant.TOPIC_SEND_MESSAGE, data);

        if (tableName.equals("message")) {
            processMessage(cvs);
        }
    }

    private static void processMessage(ContentValues cvs) {
        String content = (String)cvs.get("content");
        if (cvs.get("type")==null) {
            return;
        }
        switch ((Integer)cvs.get("type")) {
            case 1:
                // normal message, we should to check if chat room invitation is here
                // break;
            case 49:
                // if 49, we should check char room invitation
                //  I'm sorry we can't get thing ok at here
            case 285212721:
                parseArticleXMLAndSend(content, (String)cvs.get("talker"));
                break;
            default:
                break;
        }
    }

    private static void processChatRoomInvitation(final Context mContext, String url) throws Exception {

        // as we all know
        // we should start webView activity
        // only when we are in the main launcher activity.

        // so things we should do
        // that starting the launcherUI at first
        // or maybe we can put this message in the context
        // and then when we start the launcherUI activity
        //  we get the message out and do things what we want to do

        // I think the first way is nice
        // Let's do it now

        // we can't do thing without context
        // so we should do what we want to do
        // as soon as possible
        // that means we should handle this process
        // directly on afterHook method
        // instead of through message handler.

        // make intent to open this url
        //Log.dd(Main.TAG, "invitation url: "+url);
        // as we know we had hook the url open method
        // so when we get real url from from WeChat
        // we can get all necessary params.
        // then we request directly.
        Class<?> webViewClass = classLoader.loadClass(Main.webViewUri);

        Intent intent = new Intent(context, webViewClass);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.putExtra("rawUrl", url);


        String intentString;
        intentString = intent.toUri(0).toString().replace("android", Main.packageName);

        try{
            mContext.startActivity(Intent.parseUri(intentString, 0));
            //Log.dd(Main.TAG, "start web view right now");
        }catch (Exception e){
            //Log.dd(Main.TAG, "get error: "+e.toString());
            //Log.dd(Main.TAG, "add to task queue, will start at next start activity");
            // put job to queue
            Bundle bundle = new Bundle();
            bundle.putString("type", Constant.TASK_TYPE_START_ACTIVITY);
            bundle.putString("intent", intentString);
            Main.taskAfterLauncherQueue.add(bundle);
        }
    }

    private static void handleRconversation(String tableName, String type, ContentValues cv) {
        //Log.di(com.iwencai.crawl.hechat.APPs.Wechat.Main.TAG, "Received a resource conversation, type: "+type);
        if (tableName.equals("rconversation") && cv.get("parentRef") != null && cv.get("parentRef").equals("officialaccounts")) {
            //Log.di(com.iwencai.crawl.hechat.APPs.Wechat.Main.TAG, "This is a article msg.");
            parseArticleXMLAndSend((String) cv.get("content"), (String) cv.get("talker"));
        }
    }

    private static void parseArticleXMLAndSend(String xml, String author) {
        if (xml == null) return;
        String url, title;
        Matcher m = articleUrlPattern.matcher(xml);
        while (m.find()) {
            url = m.group(0);
            title = ""; // m.group(1);
            //Log.dd(Main.TAG, "crawled article url: " + url);

            Bundle bundle = new Bundle();
            bundle.putString("url",  url + "#_FROM_HOOK_BY_ZOE_V2.0");
            bundle.putString("title", title);
            bundle.putString("author", author);

            Message message = Message.obtain();
            message.what = BackgroundService.MSG_TYPE_SAVE_ARTICLE;
            message.setData(bundle);
            BackgroundService.mHandler.sendMessage(message);
        }
    }

    private static void setPkgNameWithVersion(String version) {
        Main.mVersion = version;
        switch (version) {
            case "6.6.5":
                Main.databaseMethodPackage = "com.tencent.wcdb.database.SQLiteDatabase";
                Main.deviceWxLoginInjectMethodName = "initView";
                Main.deviceWxLoginButtonId = "asf";
                break;
            case "6.5.14":
                Main.databaseMethodPackage = "com.tencent.wcdb.database.SQLiteDatabase";
                Main.deviceWxLoginInjectMethodName = "KC";
                Main.deviceWxLoginCheckMethodName = "b";
                Main.deviceWxLoginLoginMethodName = "c";
                Main.deviceWxLoginButtonId = "akw";
                Main.followBizButtonId = "title";
                Main.chattingPackageName = Main.packageName + ".ui.chatting.En_5b8fbb1e";
                Main.chattingAddButtonId = "abs";
                Main.chattingAddButtonIdId  = 0x7f1005b2;
                Main.chattingLinearLayoutIdId = 0x7f0305b6;
                break;
            case "6.5.13":
                Main.databaseMethodPackage = "com.tencent.wcdb.database.SQLiteDatabase";
                break;
            case "6.5.10":
                Main.databaseMethodPackage ="com.tencent.wcdb.database.SQLiteDatabase";
                break;
            case "6.5.8":
                Main.databaseMethodPackage = "com.tencent.wcdb.database.SQLiteDatabase";
                break;
            case "6.3.18":
                Main.databaseMethodPackage = Main.packageName + ".bb.e";
                // Main.getUserNameFromModelPackage =  Main.packageName + ".model.ag";
                // Main.getUserNameMethodName = "y";
                Main.deviceWxLoginInjectMethodName = "Gz";
                Main.deviceWxLoginCheckMethodName = "b";
                Main.deviceWxLoginLoginMethodName = "c";
                break;
            default:
                Main.databaseMethodPackage = "com.tencent" + ".wcdb.database.SQLiteDatabase";

        }

        Main.deviceWxLoginUIPackage = Main.packageName + ".plugin.webwx.ui.ExtDeviceWXLoginUI";
        Main.webViewUri = Main.packageName + ".plugin.webview.ui.tools.WebViewUI";
    }

}

}
////////////////////////////////////
{
package com.iwencai.crawl.hechat.APPs.Wechat.functions;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.Paint;
import android.net.Uri;
import android.os.Bundle;
import android.os.Message;
import android.preference.PreferenceManager;
import android.util.Log;
import android.webkit.CookieManager;
import com.iwencai.crawl.hechat.APPs.Wechat.Main;
import com.iwencai.crawl.hechat.APPs.Wechat.helper.MContentValues;
import com.iwencai.crawl.hechat.Helper.BackgroundService;
import com.iwencai.crawl.hechat.Helper.Constant;
import com.iwencai.crawl.hechat.Helper.RefUtil;
import com.iwencai.crawl.hechat.Helper.Utils;
import com.iwencai.crawl.hechat.Helper.MsgExtBean;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

public class MsgHandler {

    // private static String packageName = "com.tencent.mm";

    private static ClassLoader classLoader;
    private static Context context;
    private static final Pattern articleUrlPattern = Pattern
            .compile("(https?://mp\\.weixin\\.qq\\.com.+?#rd)");

    private static final Pattern invitationUrlPattern = Pattern
            .compile("(https?:.+support\\.weixin\\.qq\\.com.+?addchatroombyinvite\\?.+?3[Dd])]");

    static Activity mActivity=null;

    private static final String Q_UA2 = "QV=3&PL=ADR&PR=WX&PP=com.tencent.mm&PPVN=6.6.5&TBSVC=43603&CO=BK&COVC=043909&PB=GE&VE=GA&DE=PHONE&CHID=0&LCID=9422&MO= PixelXL &RL=1440*2392&OS=7.1.2&API=25";
    private static final String Q_GUID ="b08a5edb5e2a655000ca6e7e13b788cb";
    private static final String UA = "Mozilla/5.0 (Linux; Android 7.1.2; Pixel XL Build/NZH54D; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/57.0.2987.132 MQQBrowser/6.2 TBS/043909 Mobile Safari/537.36 MicroMessenger/6.6.3.1260(0x26060336) NetType/WIFI Language/zh_CN";
    private static final String Q_AUTH ="31045b957cf33acf31e40be2f3e71c5217597676a9729f1b";


    public static void hook(final String packageName, String sVersion, final Context mContext, XC_LoadPackage.LoadPackageParam loadPackageParam) {

        classLoader = loadPackageParam.classLoader;
        context = mContext;

        // if mVersion is empty, set mVersion and insert method package
        if (Main.mVersion == null||Main.mVersion.equals(""))
            setPkgNameWithVersion(sVersion);

        // if method package name is empty, return
        if (Main.databaseMethodPackage==null||Main.databaseMethodPackage.equals("")) {
            //Log.dd(Main.TAG, "Sorry I can't get database package");
            return;
        }

        // insertWithOnConflict(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;I)J
        // updateWithOnConflict(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;I)I

        // hook then insert method
        XposedHelpers.findAndHookMethod(Main.databaseMethodPackage, loadPackageParam.classLoader, Main.insertMethodName,
                String.class, String.class, ContentValues.class, int.class, new XC_MethodHook(){
                    @SuppressLint("NewApi")
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
//                        startWebViewUI(classLoader,"http://www.baidu.com");
                        insertAfterHookedMethod(mContext, param);
                    }
                });

        // update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
        XposedHelpers.findAndHookMethod(Main.databaseMethodPackage, loadPackageParam.classLoader, Main.updateMethodName,
                String.class, ContentValues.class, String.class, String[].class, int.class, new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
                        updateAfterHookedMethod(mContext, param);
                    }
                });

        // auto commit invitation
        // ".ui.widget.MMWebView"
        if (Main.webViewClass==null) {
            try{
                Main.webViewClass = classLoader.loadClass("com.tencent.smtt.sdk.WebView");
                XposedBridge.log("loadClass1....com.tencent.smtt.sdk.WebView...success!"+Main.webViewClass);
            }catch (Exception e){
                XposedBridge.log("loadClass1....com.tencent.smtt.sdk.WebView...error:"+e);
            }
        }

        if (Main.webViewClientClass == null) {
            try {
                Main.wcWebViewClass = classLoader.loadClass("com.tencent.smtt.sdk.WebView");
                Main.xWebx5Class = classLoader.loadClass("com.tencent.xweb.x5.j$2");
                Main.webResReqCls = classLoader.loadClass("com.tencent.smtt.export.external.interfaces.WebResourceRequest");
                XposedBridge.log("loadClass2....WebViewClient/webViewClientClass/WebResourceRequest...success!");
            } catch (Exception e) {
                XposedBridge.log("loadClass2....com.tencent.smtt.sdk.WebViewClient...error:"+e);
            }
        }
        if (Main.webViewClass==null)
            return;
/*
        XposedHelpers.findAndHookMethod(Main.xWebx5Class, "shouldInterceptRequest", Main.wcWebViewClass, Main.webResReqCls, Bundle.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(final MethodHookParam param) throws Throwable {
                        Object webResReq = param.args[1];
                        final Map<String, String> headers = (Map) RefUtil.callDeclaredMethod(
                                webResReq, "getRequestHeaders", new Class[]{});
                        final String referer = headers.get("Referer");
                        Uri uri = (Uri) RefUtil.callDeclaredMethod(webResReq, "getUrl", new Class[]{});
                        final String url = uri.toString();
                        final String pass_ticket = uri.getQueryParameter("pass_ticket");
                        if ("/mp/getappmsgext".equals(uri.getPath())) {
                            XposedBridge.log("---------------url-------------------"+url);
                            Class webResResponse = classLoader.loadClass(
                                    "com.tencent.smtt.export.external.interfaces.WebResourceResponse");
                            param.setResult(webResResponse.newInstance());
                            Uri referUri = Uri.parse(referer);
                            StringBuilder body = new StringBuilder();
                            body.append(referUri.getEncodedQuery())
                                    .append("&appmsg_type=9&is_need_ticket=0&is_need_ad=1&is_need_reward=0")
                                    .append("&both_ad=0&reward_uin_count=0&send_time=&msg_daily_idx=1&is_original=0&is_only_read=1");
                            XposedBridge.log("******body********:"+body);
                            try{
                                String ReqStr = sendPost(url,body.toString());
                                XposedBridge.log("******Reqstr********:"+ReqStr);
                                MsgExtBean ReqJson = MsgExtBean.buildFromJson(ReqStr);
                                ReqJson.dumpInfo();
                                int read_num = ReqJson.appmsgstat.read_num;
                                int like_num = ReqJson.appmsgstat.like_num;
                                XposedBridge.log("******read_num********:"+read_num);
                                XposedBridge.log("******like_num********:"+like_num);
                            } catch (Exception e) {
                                XposedBridge.log("get read_num like_num error:"+e);
                            }
                        }
                    }
                });
*/
        XposedHelpers.findAndHookMethod("com.tencent.smtt.sdk.WebViewClient", loadPackageParam.classLoader, "onPageStarted",
                Main.webViewClass, String.class,Bitmap.class, new XC_MethodHook(){
                    @SuppressLint("NewApi")
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(final MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
                        // mAfterHookedMethod(mContext, param);
                        String url =(String) param.args[1];
                        XposedBridge.log("******url********:"+url);
                        if (url.contains("addchatroombyinvite")){
                            // add javascript to auto click post form
                            // XposedHelpers.callMethod(param.thisObject, "loadUrl", jsCode);
                            XposedHelpers.callMethod(param.args[0], "evaluateJavascript", Main.autoClickInvitationJsCode, null);
                        } else if(url.contains("weixin://jump/mainframe")){
                            // auto back
                            XposedHelpers.callMethod(param.args[0], "evaluateJavascript", "window.onload=function(){document.addEventListener('WeixinJSBridgeReady',function onBridgeReady(){WeixinJSBridge.call('closeWindow')});}", null);
                        }else if(url.contains("mp.weixin.qq.com")){
                            XposedHelpers.findAndHookMethod(Main.xWebx5Class, "shouldInterceptRequest", Main.wcWebViewClass, Main.webResReqCls, Bundle.class,
                                    new XC_MethodHook() {
                                        @Override
                                        protected void afterHookedMethod(final MethodHookParam param) throws Throwable {
                                            Object webResReq = param.args[1];
                                            final Map<String, String> headers = (Map) RefUtil.callDeclaredMethod(
                                                    webResReq, "getRequestHeaders", new Class[]{});
                                            final String referer = headers.get("Referer");
                                            Uri uri = (Uri) RefUtil.callDeclaredMethod(webResReq, "getUrl", new Class[]{});
                                            final String url = uri.toString();
                                            final String pass_ticket = uri.getQueryParameter("pass_ticket");
                                            if ("/mp/getappmsgext".equals(uri.getPath())) {
                                                XposedBridge.log("---------------url-------------------"+url);
                                                Class webResResponse = classLoader.loadClass(
                                                        "com.tencent.smtt.export.external.interfaces.WebResourceResponse");
                                                param.setResult(webResResponse.newInstance());
                                                Uri referUri = Uri.parse(referer);
                                                StringBuilder body = new StringBuilder();
                                                body.append(referUri.getEncodedQuery())
                                                        .append("&appmsg_type=9&is_need_ticket=0&is_need_ad=1&is_need_reward=0")
                                                        .append("&both_ad=0&reward_uin_count=0&send_time=&msg_daily_idx=1&is_original=0&is_only_read=1");
                                                XposedBridge.log("******body********:"+body);
                                                try{
                                                    String ReqStr = sendPost(url,body.toString());
                                                    XposedBridge.log("******Reqstr********:"+ReqStr);
                                                    MsgExtBean ReqJson = MsgExtBean.buildFromJson(ReqStr);
                                                    ReqJson.dumpInfo();
                                                    int read_num = ReqJson.appmsgstat.read_num;
                                                    int like_num = ReqJson.appmsgstat.like_num;
                                                    XposedBridge.log("******read_num********:"+read_num);
                                                    XposedBridge.log("******like_num********:"+like_num);
                                                } catch (Exception e) {
                                                    XposedBridge.log("get read_num like_num error:"+e);
                                                }
                                            }
                                        }
                                    });

                            XposedHelpers.callMethod(param.args[0], "evaluateJavascript", "window.onload=function(){document.addEventListener('WeixinJSBridgeReady',function onBridgeReady(){WeixinJSBridge.call('closeWindow')});}", null);
                        }
                    }
                });

        XposedHelpers.findAndHookMethod(Main.databaseMethodPackage, loadPackageParam.classLoader, Main.insertMethodName,
                String.class, String.class, ContentValues.class, int.class, new XC_MethodHook(){
                    @SuppressLint("NewApi")
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        super.beforeHookedMethod(param);
                    }

                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        super.afterHookedMethod(param);
                        insertAfterHookedMethod(mContext, param);
                    }
                });

    }

    private static void startWebViewUI(ClassLoader classLoader,String url) throws ClassNotFoundException {//打开微信网页
        if (mActivity != null){
            Class<?> WebViewUIclass=classLoader.loadClass("com.tencent.mm.plugin.webview.ui.tools.WebViewUI");
            XposedBridge.log("微信WebViewClass: "+WebViewUIclass.toString());
            Intent intent=new Intent(mActivity,WebViewUIclass);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.putExtra("rawUrl",url);
            mActivity.startActivity(intent);
        }else {
            hookMainActivity(classLoader);
        }
    }

    private static void hookMainActivity(ClassLoader classLoader){
        String cls="com.tencent.mm.ui.LauncherUI";
        XposedHelpers.findAndHookMethod(cls, classLoader, "onResume", new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                Object object=param.thisObject;
                mActivity= (Activity) object;
            }
        });
    }

    public static String getCookie() {
        CookieManager cookieManager = CookieManager.getInstance();
        return cookieManager.getCookie("https://mp.weixin.qq.com");
    }

    public static Map<String, String> makeHttpHeader() {
        Map<String, String> header = new HashMap<>();
        header.put("Cookie", getCookie());
        header.put("Q-UA2", Q_UA2);
        header.put("Q-GUID", Q_GUID);
        header.put("Q-Auth", Q_AUTH);
        //header.put("Referer", referer);
        header.put("User-Agent", UA);
        header.put("X-Requested-With", "XMLHttpRequest");
        XposedBridge.log("*******header******"+header.toString());
        return header;
    }

    public static String sendPost(String url, String param) {
        PrintWriter out = null;
        BufferedReader in = null;
        String result = "";
        try {
            URL realUrl = new URL(url);
            // 打开和URL之间的连接
            URLConnection conn = realUrl.openConnection();
            // 设置通用的请求属性
            conn.setRequestProperty("accept", "*/*");
            //conn.setRequestProperty("connection", "Keep-Alive");
            // 设置请求属性
            conn.setRequestProperty("user-agent", UA);
            conn.setRequestProperty("Cookie", getCookie());
            conn.setRequestProperty("Q-UA2", Q_UA2);
            conn.setRequestProperty("Q-GUID", Q_GUID);
            conn.setRequestProperty("Q-Auth", Q_AUTH);
            conn.setRequestProperty("X-Requested-With", "XMLHttpRequest");
            // 发送POST请求必须设置如下两行
            conn.setDoOutput(true);
            conn.setDoInput(true);
            // 获取URLConnection对象对应的输出流
            out = new PrintWriter(conn.getOutputStream());
            // 发送请求参数
            out.print(param);
            // flush输出流的缓冲
            out.flush();
            // 定义BufferedReader输入流来读取URL的响应
            in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()));
            String line;
            while ((line = in.readLine()) != null) {
                result += line;
            }
        } catch (Exception e) {
            System.out.println("发送 POST 请求出现异常！"+e);
            e.printStackTrace();
        }
        //使用finally块来关闭输出流、输入流
        finally{
            try{
                if(out!=null){
                    out.close();
                }
                if(in!=null){
                    in.close();
                }
            }
            catch(IOException ex){
                ex.printStackTrace();
            }
        }
        return result;
    }


    private static void updateAfterHookedMethod(final Context mContext, final XC_MethodHook.MethodHookParam params) {
        //Log.dd(Main.TAG, "Hooked "+Main.databaseMethodPackage+"."+Main.updateMethodName);

        ContentValues cvs = (ContentValues)params.args[1];

        String[] kValues = (String[])params.args[3];
        if (kValues==null) {
            return;
        }
        String kString = (String) params.args[2];

        Bundle bundle = new Bundle();
        String tableName = (String)params.args[0];
        bundle.putString("tableName", tableName);
        bundle.putInt("rowid", (int)params.args[4]);
        bundle.putLong("return_rowid", (int)params.getResult());
        bundle.putString("keyKey", kString);
        bundle.putCharSequenceArrayList("keyValue", new ArrayList<CharSequence>(Arrays.asList(kValues)));
        bundle.putString("method", "update");
        SharedPreferences sharedPreferences = mContext.getSharedPreferences("notify_key_pref_no_account", Context.MODE_MULTI_PROCESS);

        if (sharedPreferences!=null){
            bundle.putString("username", sharedPreferences.getString("login_weixin_username", Main.userName));
        }else{
            // not correct
            //Log.dd(Main.TAG, "get username error, with null of shared preferences");
            bundle.putString("username", Main.userName);
        }

        bundle.putSerializable("contentValues", new MContentValues().set(cvs));

        // because message handle is a static object
        // so we can use it directly
        Message msg = Message.obtain();
        msg.what = BackgroundService.MSG_TYPE_HOOK_PROCESS;
        msg.setData(bundle);
        BackgroundService.mHandler.sendMessage(msg);
    }

    private static void insertAfterHookedMethod(final Context mContext, final XC_MethodHook.MethodHookParam params) {
        // at here we get params of insert function
        // then we should send them to service to process
        //Log.dd(Main.TAG, "Hooked "+Main.databaseMethodPackage+"."+Main.insertMethodName);

        ContentValues cvs  = (ContentValues)params.args[2];
        String contentX = cvs.getAsString("content");
        if (contentX!=null&&contentX.startsWith("command:")) {
            String command = contentX.replace("command:", "");
            if (command.startsWith("webview:")) {
                String url = command.replace("webview:", "");
                try {
                    Intent intent = new Intent(context, classLoader.loadClass(Main.webViewUri));
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    intent.putExtra("rawUrl", url);
                    String intentString;
                    intentString = intent.toUri(0).toString().replace("android", Main.packageName);
                    mContext.startActivity(Intent.parseUri(intentString, 0));
                } catch (Exception e) {
                    Log.d(Main.TAG, e.toString());
                }
            }else if (command.startsWith("follow:")){
                String tid = command.replace("follow:", "");
                //Log.dd(Main.TAG, "Follow from chat command: "+tid);
                Intent intent = Utils.getStartChatting(null, tid).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                mContext.startActivity(intent);
            } else if (command.contains("mp.weixin.qq.com")){
                XposedBridge.log("start open web url:"+command);
                try {
                    startWebViewUI(classLoader,command);
                } catch (Exception e){
                    XposedBridge.log("open web error:"+e);
                }
                XposedBridge.log("end open web url:"+command);
            } else{
                Log.d(Main.TAG, "Unknow command: "+command);
            }
            return;
        }

        Bundle bundle = new Bundle();
        String tableName = (String)params.args[0];
        bundle.putString("tableName", tableName);
        bundle.putString("type", (String)params.args[1]);
        bundle.putInt("rowid", (int)params.args[3]);
        bundle.putLong("return_rowid", (long)params.getResult());
        bundle.putString("method", "insert");
        SharedPreferences sharedPreferences = mContext.getSharedPreferences("notify_key_pref_no_account", Context.MODE_MULTI_PROCESS);
        if (sharedPreferences!=null){
            bundle.putString("username", sharedPreferences.getString("login_weixin_username", Main.userName));
        }else{
            // not correct
            //Log.dd(Main.TAG, "get username error, with null of shared preferences");
            bundle.putString("username", Main.userName);
        }

        // add username
        // cvs.put("tableName", (String)params.args[0]);

        bundle.putSerializable("contentValues", new MContentValues().set(cvs));

        // because message handle is a static object
        // so we can use it directly
        Message msg = Message.obtain();
        msg.what = BackgroundService.MSG_TYPE_HOOK_PROCESS;
        msg.setData(bundle);
        BackgroundService.mHandler.sendMessage(msg);

        // this maybe a bad new
        // that we can't handle invitation without context
        // so we must do it at now, this make me sad.

        // process chat room invitation
        if (tableName.equals("message")&&cvs.getAsInteger("type")==49) {
            String content = cvs.getAsString("content");
            if (content==null)
                return;

            Matcher m = invitationUrlPattern.matcher(content);
            while(m.find()){
                String url = m.group(1);
                try {processChatRoomInvitation(mContext, url);} catch (Exception e){Log.d(Main.TAG, e.toString());e.printStackTrace();}
            }
        }
    }

    public static void process(Message msg) throws Exception {
        // this method call by service
        // handle params from hooked method.

        // we should know that,
        // this method call with intent
        // so async mode

        // get bundle out
        Bundle bundle = msg.getData();

        String tableName = bundle.getString("tableName");
        if (tableName==null)
            return;

        String type = bundle.getString("type");

        MContentValues mCvs = (MContentValues) bundle.getSerializable("contentValues");
        if (mCvs==null)
            return;

        ContentValues cvs = mCvs.get();
        // at here we get the table name, type and cvs.

        // send data by mqtt
        // yes at here we should send data back to server

        // from here we just to send a broadcast
        // to send data to our server.

        JSONObject data = new JSONObject();
        for (String k: cvs.keySet()) {
            try{data.putOpt(k, cvs.get(k));}catch (Exception e){Log.d(Main.TAG, e.toString());}
        }

        JSONObject parentData = new JSONObject();
        parentData.put("table_name", tableName);
        parentData.put("method", bundle.getString("method"));

        String keyKey  = bundle.getString("keyKey");
        ArrayList<CharSequence> keyValue = bundle.getCharSequenceArrayList("keyValue");

        if (keyKey!=null&&keyValue!=null) {
            JSONObject key = new JSONObject();
            key.put("key_key", keyKey);
            key.put("key_value", keyValue);
            parentData.put("key", key);
        }

        parentData.put("username", bundle.getString("username"));
        parentData.put("rowid", bundle.getInt("rowid"));
        parentData.put("return_rowid", bundle.getLong("return_rowid"));
        parentData.put("data", data);

        Intent intent =  new Intent();
        intent.putExtra("topic", Constant.TOPIC_SEND_MESSAGE);
        intent.putExtra("username", bundle.getString("username"));
        intent.putExtra("data", parentData.toString());
        // if necessary we need to transform data cross file storage
        // send broadcast
        intent.setAction(BackgroundService.BROADCAST_TYPE_SEND_MQTT);
        context.sendBroadcast(intent);

        switch (tableName) {
            case "rconversation":
                handleRconversation(tableName, type, cvs);
                break;
            case "message":
                handleMessage(tableName, type, cvs);
                break;
            default:
                break;
        }
    }

    private static void handleMessage(String tableName, String type, ContentValues cvs) throws Exception {

        //Log.di(com.iwencai.crawl.hechat.APPs.Wechat.Main.TAG, "received a message");

        // intent.putExtra("data", bundle).putExtra("topic", Constant.TOPIC_HEART_BEAT);
        // BackgroundService.MQTTClient.publishMessage(Constant.TOPIC_SEND_MESSAGE, data);

        if (tableName.equals("message")) {
            processMessage(cvs);
        }
    }

    private static void processMessage(ContentValues cvs) {
        String content = (String)cvs.get("content");
        if (cvs.get("type")==null) {
            return;
        }
        switch ((Integer)cvs.get("type")) {
            case 1:
                // normal message, we should to check if chat room invitation is here
                // break;
            case 49:
                // if 49, we should check char room invitation
                //  I'm sorry we can't get thing ok at here
            case 285212721:
                parseArticleXMLAndSend(content, (String)cvs.get("talker"));
                break;
            default:
                break;
        }
    }

    private static void processChatRoomInvitation(final Context mContext, String url) throws Exception {

        // as we all know
        // we should start webView activity
        // only when we are in the main launcher activity.

        // so things we should do
        // that starting the launcherUI at first
        // or maybe we can put this message in the context
        // and then when we start the launcherUI activity
        //  we get the message out and do things what we want to do

        // I think the first way is nice
        // Let's do it now

        // we can't do thing without context
        // so we should do what we want to do
        // as soon as possible
        // that means we should handle this process
        // directly on afterHook method
        // instead of through message handler.

        // make intent to open this url
        //Log.dd(Main.TAG, "invitation url: "+url);
        // as we know we had hook the url open method
        // so when we get real url from from WeChat
        // we can get all necessary params.
        // then we request directly.
        Class<?> webViewClass = classLoader.loadClass(Main.webViewUri);

        Intent intent = new Intent(context, webViewClass);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.putExtra("rawUrl", url);


        String intentString;
        intentString = intent.toUri(0).toString().replace("android", Main.packageName);

        try{
            mContext.startActivity(Intent.parseUri(intentString, 0));
            //Log.dd(Main.TAG, "start web view right now");
        }catch (Exception e){
            //Log.dd(Main.TAG, "get error: "+e.toString());
            //Log.dd(Main.TAG, "add to task queue, will start at next start activity");
            // put job to queue
            Bundle bundle = new Bundle();
            bundle.putString("type", Constant.TASK_TYPE_START_ACTIVITY);
            bundle.putString("intent", intentString);
            Main.taskAfterLauncherQueue.add(bundle);
        }
    }

    private static void handleRconversation(String tableName, String type, ContentValues cv) {
        //Log.di(com.iwencai.crawl.hechat.APPs.Wechat.Main.TAG, "Received a resource conversation, type: "+type);
        if (tableName.equals("rconversation") && cv.get("parentRef") != null && cv.get("parentRef").equals("officialaccounts")) {
            //Log.di(com.iwencai.crawl.hechat.APPs.Wechat.Main.TAG, "This is a article msg.");
            parseArticleXMLAndSend((String) cv.get("content"), (String) cv.get("talker"));
        }
    }

    private static void parseArticleXMLAndSend(String xml, String author) {
        if (xml == null) return;
        String url, title;
        Matcher m = articleUrlPattern.matcher(xml);
        while (m.find()) {
            url = m.group(0);
            title = ""; // m.group(1);
            //Log.dd(Main.TAG, "crawled article url: " + url);

            Bundle bundle = new Bundle();
            bundle.putString("url",  url + "#_FROM_HOOK_BY_ZOE_V2.0");
            bundle.putString("title", title);
            bundle.putString("author", author);

            Message message = Message.obtain();
            message.what = BackgroundService.MSG_TYPE_SAVE_ARTICLE;
            message.setData(bundle);
            BackgroundService.mHandler.sendMessage(message);
        }
    }

    private static void setPkgNameWithVersion(String version) {
        Main.mVersion = version;
        switch (version) {
            case "6.6.5":
                Main.databaseMethodPackage = "com.tencent.wcdb.database.SQLiteDatabase";
                Main.deviceWxLoginInjectMethodName = "initView";
                Main.deviceWxLoginButtonId = "asf";
                break;
            case "6.5.14":
                Main.databaseMethodPackage = "com.tencent.wcdb.database.SQLiteDatabase";
                Main.deviceWxLoginInjectMethodName = "KC";
                Main.deviceWxLoginCheckMethodName = "b";
                Main.deviceWxLoginLoginMethodName = "c";
                Main.deviceWxLoginButtonId = "akw";
                Main.followBizButtonId = "title";
                Main.chattingPackageName = Main.packageName + ".ui.chatting.En_5b8fbb1e";
                Main.chattingAddButtonId = "abs";
                Main.chattingAddButtonIdId  = 0x7f1005b2;
                Main.chattingLinearLayoutIdId = 0x7f0305b6;
                break;
            case "6.5.13":
                Main.databaseMethodPackage = "com.tencent.wcdb.database.SQLiteDatabase";
                break;
            case "6.5.10":
                Main.databaseMethodPackage ="com.tencent.wcdb.database.SQLiteDatabase";
                break;
            case "6.5.8":
                Main.databaseMethodPackage = "com.tencent.wcdb.database.SQLiteDatabase";
                break;
            case "6.3.18":
                Main.databaseMethodPackage = Main.packageName + ".bb.e";
                // Main.getUserNameFromModelPackage =  Main.packageName + ".model.ag";
                // Main.getUserNameMethodName = "y";
                Main.deviceWxLoginInjectMethodName = "Gz";
                Main.deviceWxLoginCheckMethodName = "b";
                Main.deviceWxLoginLoginMethodName = "c";
                break;
            default:
                Main.databaseMethodPackage = "com.tencent" + ".wcdb.database.SQLiteDatabase";

        }

        Main.deviceWxLoginUIPackage = Main.packageName + ".plugin.webwx.ui.ExtDeviceWXLoginUI";
        Main.webViewUri = Main.packageName + ".plugin.webview.ui.tools.WebViewUI";
    }

}

}

{
	package com.iwencai.crawl.hechat;

import java.io.IOException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import dalvik.system.DexFile;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;
import static de.robv.android.xposed.XposedHelpers.findAndHookMethod;
import de.robv.android.xposed.IXposedHookLoadPackage;


public class Main implements IXposedHookLoadPackage {
    public final static String TAG = "HeChat";
    public final static String packageName = "com.tencent.mm";
    public final static String chatting = "com.tencent.mm.ui.chatting";
    XC_LoadPackage.LoadPackageParam loadPackageParam;

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam param) {
        loadPackageParam = param;
        log("1-----packageName-----:"+ loadPackageParam.packageName);
        if (!loadPackageParam.packageName.contains(packageName)) {
            log("2-----packageName-----:" + loadPackageParam.packageName);
            return;
        }
        log("3-----packageName-----:" + loadPackageParam.packageName);

        if (loadPackageParam.packageName.contains(chatting)) {
            log("4-----packageName-----:" + loadPackageParam.packageName);
        }

//        try {
//            try {
//                hook();
//            } catch (ClassNotFoundException e) {
//                e.printStackTrace();
//            }
//        } catch (IOException e) {
//        }
    }


    public void hook() throws IOException, ClassNotFoundException {
        DexFile dexFile = new DexFile(loadPackageParam.appInfo.sourceDir);
        Enumeration<String> classNames = dexFile.entries();
        while (classNames.hasMoreElements()) {
            String className = classNames.nextElement();

            if (isClassNameValid(className)) {
                final Class clazz = Class.forName(className, false, loadPackageParam.classLoader);
                for (Method method: clazz.getDeclaredMethods()) {
                    if (!Modifier.isAbstract(method.getModifiers())) {
                        XposedBridge.hookMethod(method, new XC_MethodHook() {
                            @Override
                            protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                                log("5-----packageName-----:"+ loadPackageParam.packageName);
                                log("HOOKED: " + clazz.getName() + "\\" + param.method.getName());
                            }
                        });
                    }
                }
            }
        }
    }

    public void log(Object str) {
        SimpleDateFormat df = new SimpleDateFormat("HH:mm:ss");
        XposedBridge.log("[" + df.format(new Date()) + "]:  "
                + str.toString());
    }

    public boolean isClassNameValid(String className) {
        return className.startsWith(loadPackageParam.packageName)
                && !className.contains("$")
                && !className.contains("BuildConfig")
                && !className.equals(loadPackageParam.packageName + ".R");
    }
}

}


{
05-22 16:20:06.797 4686-4795/com.tencent.mm:tools I/Xposed: ---------------shouldInterceptRequest-------------------start!
05-22 16:20:06.829 4686-4795/com.tencent.mm:tools I/Xposed: ---------------shouldInterceptRequest-------------------start!
05-22 16:20:06.851 4686-4795/com.tencent.mm:tools I/Xposed: ---------------shouldInterceptRequest-------------------start!
05-22 16:20:06.870 4686-4795/com.tencent.mm:tools I/Xposed: ---------------shouldInterceptRequest-------------------start!
05-22 16:20:06.883 4686-4795/com.tencent.mm:tools I/Xposed: ---------------shouldInterceptRequest-------------------start!
05-22 16:20:07.606 4686-4795/com.tencent.mm:tools I/Xposed: ---------------shouldInterceptRequest-------------------start!
05-22 16:20:07.606 4686-4795/com.tencent.mm:tools I/Xposed: ---------------url-------------------http://mp.weixin.qq.com/mp/getappmsgext?f=json&uin=777&key=777&pass_ticket=DyrfWXqxoNGwIyOznUe6SfvGj7xaSgU%25252BzAkML6Ax%25252FLe5KeltPyBeefYIn1xxxYS2&wxtoken=777&devicetype=android-23&clientversion=26060532&appmsg_token=957_TGvpTSQqHd%252BMxHzVMeeMtVhFz09hkIudTcigq2QFdBImBJGJoeE3GsJlK_qrCSL_2-_qjs4jPzvi9DMd&x5=1&f=json
05-22 16:20:07.606 4686-4795/com.tencent.mm:tools I/Xposed: ******body********:__biz=MzI1Mjc4NDg5MQ==&mid=2247484034&idx=1&sn=ad798948709eff2eb34dbdf48905db2f&ascene=1&devicetype=android-23&version=26060532&nettype=WIFI&abtest_cookie=AwABAAoACwAMAAYAPoseAOOLHgBKjh4Aco8eAHePHgBYkB4AAAA%3D&lang=zh_CN&pass_ticket=DyrfWXqxoNGwIyOznUe6SfvGj7xaSgU%2BzAkML6Ax%2FLe5KeltPyBeefYIn1xxxYS2&wx_header=1&appmsg_type=9&is_need_ticket=0&is_need_ad=1&is_need_reward=0&both_ad=0&reward_uin_count=0&send_time=&msg_daily_idx=1&is_original=0&is_only_read=1
05-22 16:20:07.607 4686-4795/com.tencent.mm:tools I/WebViewFactory: Loading com.android.webview version 52.0.2743.100 (code 275610000)
05-22 16:20:07.641 4686-4795/com.tencent.mm:tools W/System: ClassLoader referenced unknown path: /system/app/webview/lib/arm
05-22 16:20:07.651 4686-4795/com.tencent.mm:tools I/art: Rejecting re-init on previously-failed class java.lang.Class<com.android.webview.chromium.ServiceWorkerControllerAdapter>
05-22 16:20:07.652 4686-4795/com.tencent.mm:tools I/art: Rejecting re-init on previously-failed class java.lang.Class<com.android.webview.chromium.ServiceWorkerControllerAdapter>
05-22 16:20:07.653 4686-4795/com.tencent.mm:tools I/art: Rejecting re-init on previously-failed class java.lang.Class<com.android.webview.chromium.TokenBindingManagerAdapter>
05-22 16:20:07.653 4686-4795/com.tencent.mm:tools I/art: Rejecting re-init on previously-failed class java.lang.Class<com.android.webview.chromium.TokenBindingManagerAdapter>
05-22 16:20:07.663 4686-4795/com.tencent.mm:tools I/cr_LibraryLoader: Time to load native libraries: 3 ms (timestamps 1675-1678)
05-22 16:20:07.663 4686-4795/com.tencent.mm:tools I/cr_LibraryLoader: Expected native library version number "52.0.2743.100", actual native library version number "52.0.2743.100"
05-22 16:20:07.686 4686-4686/com.tencent.mm:tools W/art: Long monitor contention event with owner method=long android.database.sqlite.SQLiteConnection.nativeOpen(java.lang.String, int, java.lang.String, boolean, boolean) from SQLiteConnection.java:4294967294 waiters=0 for 1.586s
05-22 16:20:07.688 4686-4795/com.tencent.mm:tools I/Xposed: *******header******{X-Requested-With=XMLHttpRequest, Q-UA2=QV=3&PL=ADR&PR=WX&PP=com.tencent.mm&PPVN=6.6.3&TBSVC=43603&CO=BK&COVC=043909&PB=GE&VE=GA&DE=PHONE&CHID=0&LCID=9422&MO= PixelXL &RL=1440*2392&OS=7.1.2&API=25, Cookie=wxuin=3789529722; devicetype=android-23; version=26060532; lang=zh_CN; pass_ticket=PyTBvgL843N0ZM7FRnt0LNQ1WackIGZ7IlBpMeCIJOM3n02fwmmE5rw2VwBLxgr0; wap_sid2=CPrE/o4OElx1OEEwblNsbFFhUmRxMHZHbHFiQ1pMLWVSSEdGZEdwUG1hblE3S1RkNGtSVWJYc3g1LVpyT0JLWWppZXhTS2hfY3FVcTFaeUdqekNxX3d3SjhyWEpFYjBEQUFBfjDLpI/YBTgNQAE=; rewardsn=7d3c4f43a7a0d28e4572; wxtokenkey=777, Q-Auth=31045b957cf33acf31e40be2f3e71c5217597676a9729f1b, User-Agent=Mozilla/5.0 (Linux; Android 7.1.2; Pixel XL Build/NZH54D; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/57.0.2987.132 MQQBrowser/6.2 TBS/043909 Mobile Safari/537.36 MicroMessenger/6.6.3.1260(0x26060336) NetType/WIFI Language/zh_CN, Q-GUID=b08a5edb5e2a655000ca6e7e13b788cb}
05-22 16:20:07.688 4686-4795/com.tencent.mm:tools I/art: Rejecting re-init on previously-failed class java.lang.Class<com.iwencai.crawl.hechat.APPs.Wechat.functions.MsgHandler$9>





05-22 16:44:04.692 8413-8540/com.tencent.mm:tools I/Xposed: ---------------url-------------------http://mp.weixin.qq.com/mp/getappmsgext?f=json&uin=777&key=777&pass_ticket=yAsmwgCevFuXRpAEt2coyfJLDX2IxyWDJQ1giBH9OgqrvlUqOpZ%25252FeIZAdRskGHPv&wxtoken=777&devicetype=android-23&clientversion=26060532&appmsg_token=957_yHXLyBqZtN%252FrDkn%252BMeeMtVhFz09hkIudTcigqxVbiz7vl9VfKYSEnPSCkH0TijKiIrVeH0-vLi2qH8tl&x5=1&f=json
05-22 16:44:04.692 8413-8540/com.tencent.mm:tools I/Xposed: ******body********:__biz=MzI1Mjc4NDg5MQ==&mid=2247484034&idx=1&sn=ad798948709eff2eb34dbdf48905db2f&ascene=1&devicetype=android-23&version=26060532&nettype=WIFI&abtest_cookie=AwABAAoACwAMAAYAPoseAOOLHgBKjh4Aco8eAHePHgBYkB4AAAA%3D&lang=zh_CN&pass_ticket=yAsmwgCevFuXRpAEt2coyfJLDX2IxyWDJQ1giBH9OgqrvlUqOpZ%2FeIZAdRskGHPv&wx_header=1&appmsg_type=9&is_need_ticket=0&is_need_ad=1&is_need_reward=0&both_ad=0&reward_uin_count=0&send_time=&msg_daily_idx=1&is_original=0&is_only_read=1
05-22 16:44:04.722 8533-8533/? W/MemoryCheckThre: type=1400 audit(0.0:97718): avc: denied { read } for name="mem" dev="debugfs" ino=10307108 scontext=u:r:untrusted_app:s0:c512,c768 tcontext=u:object_r:debugfs:s0 tclass=file permissive=0
05-22 16:44:04.722 8533-8533/? W/MemoryCheckThre: type=1400 audit(0.0:97719): avc: denied { read } for name="mem" dev="debugfs" ino=10307108 scontext=u:r:untrusted_app:s0:c512,c768 tcontext=u:object_r:debugfs:s0 tclass=file permissive=0
05-22 16:44:04.791 8413-8413/com.tencent.mm:tools I/chromium: [INFO:CONSOLE(1321)] "[moon] load js complete, url num : 8, total mod count : 127, hit num: 0, use time : 198ms", source: http://mp.weixin.qq.com/s?__biz=MzI1Mjc4NDg5MQ==&mid=2247484034&idx=1&sn=ad798948709eff2eb34dbdf48905db2f&ascene=1&devicetype=android-23&version=26060532&nettype=WIFI&abtest_cookie=AwABAAoACwAMAAYAPoseAOOLHgBKjh4Aco8eAHePHgBYkB4AAAA%3D&lang=zh_CN&pass_ticket=yAsmwgCevFuXRpAEt2coyfJLDX2IxyWDJQ1giBH9OgqrvlUqOpZ%2FeIZAdRskGHPv&wx_header=1 (1321)
05-22 16:44:04.801 8413-8413/com.tencent.mm:tools I/chromium: [INFO:CONSOLE(1787)] "房小宝儿init setPageTitle :top[3033]:title_show[false]", source: http://res.wx.qq.com/mmbizwap/zh_CN/htmledition/style/page/appmsg_new/not_in_mm.css3de35e.js,/mmbizwap/zh_CN/htmledition/style/page/appmsg_new/combo.css3df3b9.js,/mmbizwap/zh_CN/htmledition/js/appmsg/appmsg_report3dae33.js,/mmbizwap/zh_CN/htmledition/js/biz_common/moment3518c6.js,/mmbizwap/zh_CN/htmledition/js/biz_wap/jsapi/core3d3b85.js,/mmbizwap/zh_CN/htmledition/js/biz_common/dom/event3a25e9.js,/mmbizwap/zh_CN/htmledition/js/appmsg/test3d3b85.js,/mmbizwap/zh_CN/htmledition/js/biz_wap/utils/mmversion3de208.js,/mmbizwap/zh_CN/htmledition/js/appmsg/max_age3d3b85.js,/mmbizwap/zh_CN/htmledition/js/biz_common/dom/attr3518c6.js,/mmbizwap/zh_CN/htmledition/js/biz_wap/utils/ajax3d3b85.js,/mmbizwap/zh_CN/htmledition/js/appmsg/log300330.js,/mmbizwap/zh_CN/htmledition/js/biz_common/dom/class3518c6.js,/mmbizwap/zh_CN/htmledition/js/biz_wap/utils/device34c264.js,/mmbizwap/zh_CN/htmledition/js/biz_common/utils/string/html3518c6.js,/mmbizwap/zh_CN/htmledition/js/appmsg/index3df379.js (1787)
05-22 16:44:04.890 8413-8540/com.tencent.mm:tools I/Xposed: ******Req********:{"advertisement_num":1,"advertisement_info":[{"hint_txt":"","url":"http:\/\/aduland.dianping.com\/page\/landingpage\/tencent?dpShopId=80823312&amp;slotId=30004&amp;launchId=23174992&amp;dpCreativeId=74042090&amp;newLp=true&amp;weixinadkey=1d48c25292d7c3af5362697d4437c01f12bbd12e182cbea80002458a7a8e9f1fbe8a596892bd496dc5dbf8fcb4b09b0a&amp;gdt_vid=wx0daalbfe54o7pm00&amp;weixinadinfo=33508973.wx0daalbfe54o7pm00.0.1","type":"0","rl":"http:\/\/ad.wx.com:12638\/cgi-bin\/click?viewid=wmFE1NyMOJfO4D2pxUXjYSLvjLsLKrNMoptZpQQTCnPdEpuxgfOeW5FrYAy%2FUwpNcjZXtMLeMiD7oDcJX8ZKB2Bw7z5of9UunP8I7AeRwKZ9kkSyyl5%2FIYtaMk3AT3wTSxF7rvPBc7Vy337Fp3x987jvvk7R7QZvVDI6KZQOqP1V44hsK0CVWQVoj5OqFFh4pMQg5XgF0wINZF2A1cpYPfCH5b1RAm6gfXM7fwg%2FitNlpnUw1ByLW4snBHBEllqjtOgdcUS%2BsMUMwPGNN2o7G6l00n2VAdYNuIGyKT2WDUKcyzlAZ1WZnmuUCStkBt0XvmVXGwM6wOZjzrTs2AL4TfDqI9CePX%2F75vPMs1G6n1vjHePDlMwrfGcn2%2Bd%2FsRcRNSZUVvuHFn2dPaGXfNJEh6X7MR8smv5luZpAdfa6SmNt7hCSrvJVLgQOUl4j%2Bed5VVSbShKsbuDVdXzEK3TOheE1QQYkXlOPX%2FRj5Rq2SaKcjnzXTRVpA0v2hqWAL2am1AFpOOBVKWsssuUXsJ05Z9yhspz95NEomhJm5xcaPgJ5LiSffoTHF%2F%2FAW%2BZ%2FG1iKj0WqCiZWRIekAvIgF9YmIRvWmwuIsS%2BOQVRdcK7mXZuHOECA%2FOYLcmFRo1sHpDTEzVBAqSrQZYIXCLsohhcsh%2FJMM0fGlEubgjMyhKtxORhaV0FiDmAxKbDdAD5XtHYI4XRFQSDXSzhhUaNbB6Q0xPDkbJL8TySFmFtzFNXBI55WMRjQtnWs6HjNKnm7vIyT9SC68JCddkSy24MiQT%2Bwu62pUDREiSVeILJQ%2Bfntjuk9QE53JAFDfqydnxZ6XMXHAuqAxA%2FZU05YvgBvR6qou%2FLYTLLkoNpT7GbpmCLNPMKxG2LpqTqwrcJT61s%2Fgk7aI0IMr2RZA55MKX%2BIX9pgdwwF8WMYHqRtSCqxHmC2uynvOuBHYqHminLQIGR56hWH0LRVrmLiKf9P5fqrguDhJ3bAJPIJ5QVUO%2BYY%2BAAxTh4xoihyhdn%2BLJW%2F%2BUF1afji%2BJQrBOcF0FJbK81zS7YCyjz6%2BotdGfxIKyEzNVpC7NyqjQunYuXiF17KVCPx%2FWFDxzU5rIVq3%2FzAohQ5J2JnkGyEn90gihWwbAou58y%2BlAu665R1qlle%2FTMlc3CAGcddHmFy7SsSGzrFEgbDw2qAhkRw0kW2JYEfLCJLJBoE3%2BqXzVkJ0qVmQZIo24%2F6mHQ%2FC3VjRtLJXKooeBjfYOtpkxM6V5gFZhVVEgGf9aIkHEjl1XD6Lvm1Aw%3D%3D","apurl":"http:\/\/ad.wx.com:12638\/cgi-bin\/exposure?viewid=wmFE1NyMOJfO4D2pxUXjYSLvjLsLKrNMoptZpQQTCnPdEpuxgfOeW5FrYAy%2FUwpNcjZXtMLeMiD7oDcJX8ZKB2Bw7z5of9UunP8I7AeRwKZ9kkSyyl5%2FIYtaMk3AT3wTSxF7rvPBc7Vy337Fp3x987jvvk7R7QZvVDI6KZQOqP1V44hsK0CVWQVoj5OqFFh4pMQg5XgF0wINZF2A1cpYPfCH5b1RAm6gfXM7fwg%2FitNlpnUw1ByLW4snBHBEllqjtOgdcUS%2BsMUMwPGNN2o7G6l00n2VAdYNuIGyKT2WDUKcyzlAZ1WZnmuUCStkBt0XvmVXGwM6wOZjzrTs2AL4TfDqI9CePX%2F75vPMs1G6n1vjHePDlMwrfGcn2%2Bd%2FsRcRNSZUVvuHFn2dPaGXfNJEh6X7MR8smv5luZpAdfa6SmNt7hCSrvJVLgQOUl4j%2Bed5VVSbShKsbuDVdXzEK3TOheE1QQYkXlOPX%2FRj5Rq2SaKcjnzXTRVpA0v2hqWAL2am1AFpOOBVKWsssuUXsJ05Z9yhspz95NEomhJm5xcaPgJ5LiSffoTHF%2F%2FAW%2BZ%2FG1iKj0WqCiZWRIekAvIgF9YmIRvWmwuIsS%2BOQVRdcK7mXZuHOECA%2FOYLcmFRo1sHpDTEzVBAqSrQZYIXCLsohhcsh%2FJMM0fGlEubgjMyhKtxORhaV0FiDmAxKbDdAD5XtHYI4XRFQSDXSzhhUaNbB6Q0xPDkbJL8TySFmFtzFNXBI55WMRjQtnWs6HjNKnm7vIyT9SC68JCddkSy24MiQT%2Bwu62pUDREiSVeILJQ%2Bfntjuk9QE53JAFDfqydnxZ6XMXHAuqAxA%2FZU05YvgBvR6qou%2FLYTLLkoNpT7GbpmCLNPMKxG2LpqTqwrcJT61s%2Fgk7aI0IMr2RZA55MKX%2BIX9pgdwwF8WMYHqRtSCqxHmC2uynvOuBHYqHminLQIGR56hWH0LRVrmLiKf9P5fqrguDhJ3bAJPIJ5QVUO%2BYY%2BAAxTh4xoihyhdn%2BLJW%2F%2BUF1afji%2BJQrBOcF0FJbK81zS7YCyjz6%2BotdGfxIKyEzNVpC7NyqjQunYuXiF17KVCPx%2FWFDxzU5rIVq3%2FzAohQ5J2JnkGyEn90gihWwbAou58y%2BlAu665R1qlle%2FTMlc3CAGcddHmFy7SsSGzrFEgbDw2qAhkRw0kW2JYEfLCJLJBoE3%2BqXzVkJ0qVmQZIo24%2F6mHQ%2FC3VjRtLJXKooeBjfYOtpkxM6V5gFZhVVEgGf9aIkHEjl1XD6Lvm1Aw%3D%3D","traceid":"wx0daalbfe54o7pm00","group_id":"","ticket":"","aid":"33508973","pt":2,"image_url":"http:\/\/pgdt.gtimg.cn\/gdt\/0\/DAAdwljAJGACmAAeBa63FuA2rpTjN0.jpg\/0?ck=035b4326de782806648f5fe4276d55df","ad_desc":"","biz_appid":"","pos_type":0,"watermark_type":2,"logo":"","is_cpm":0,"dest_type":0,"material_width":582,"material_height":166,"ad_width":0,"ad_height":0,"use_new_protocol":0,"product_type":31,"material_type":2}],"appmsgstat":{"show":true,"is_login":true,"liked":true,"read_num":1031,"like_num":50,"ret":0,"real_read_num":0},"reward_head_imgs":[],"base_resp":{"wxtoken":777}}
05-22 16:44:04.893 8413-8540/com.tencent.mm:tools I/Xposed: ---------------shouldInterceptRequest-------------------start!
05-22 16:44:04.898 8413-8540/com.tencent.mm:tools I/Xposed: ---------------shouldInterceptRequest-------------------start!
05-22 16:44:05.388 8413-8413/com.tencent.mm:tools I/chromium: [INFO:CONSOLE(3245)] "WeixinJSBridge exec time", source:  (3245)
05-22 16:44:05.488 6901-6901/com.tencent.mm I/Xposed: 1........de.robv.android.xposed.XC_MethodHook$MethodHookParam@f8a85f4
05-22 16:44:05.488 6901-6901/com.tencent.mm I/Xposed: task job queue is empty.	
	
}






