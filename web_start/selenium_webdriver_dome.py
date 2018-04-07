# -*- coding: utf-8 -*-
from selenium import webdriver

def getxueqiu_toutiao():
    browser = webdriver.Chrome()
    browser.get('https://xueqiu.com/today')
    print("url1:",browser.current_url)
    print("cookie:",str(browser.get_cookies()))
    # 定位到头条
    element = browser.find_element_by_class_name("home__timeline__list")
    print("文章列表:",element.text.encode('utf8'))

    # 正对第一个文章的点击进入操作
    element=element.find_element_by_class_name("home__timeline__item")
    t=element.text
    tt=t.split('\n')
    ttt=browser.find_element_by_link_text(tt[0])
    print("第一篇:", ttt.text)
    ttt.click()
    print(browser.window_handles) #获取所有的选项卡
    # 切换到新点击出的页面
    browser.switch_to_window(browser.window_handles[1])
    # 获得当前页面的URL
    print("url2:",browser.current_url)
    print(browser.page_source)
    browser.close()
    print("url3:",browser.current_url)
    browser.switch_to_window(browser.window_handles[0])
    print("url4:",browser.current_url)
    browser.close()

def maizi():
    from selenium import webdriver
    d = webdriver.Chrome()
    d.get('http://www.baidu.com/')
    d.find_element_by_id('kw').clear()
    d.find_element_by_id('kw').send_keys('麦子学院')
    d.find_element_by_id('su').click()
    d.maximize_window()
    import time
    time.sleep(20)
    d.find_element_by_partial_link_text('专业IT职业教育平台').click()
    time.sleep(3)
    d.switch_to_window(d.window_handles[0])
    time.sleep(3)
    d.switch_to_window(d.window_handles[1])
    d.switch_to_window(d.window_handles[0])
    time.sleep(3)
    d.quit()


def phantomjs_test():
    browser = webdriver.PhantomJS(executable_path = './phantomjs')
    browser.get("https://xueqiu.com/#/")
    trs = browser.find_elements_by_tag_name('tr')
    for tr in trs[1:]:
        print(tr.text.split(' ')[0])


"""
https://www.cnblogs.com/yufeihlf/p/5764807.html         #Python+Selenium WebDriver API：浏览器及元素的常用函数及变量整理总结
http://www.cnblogs.com/yufeihlf/p/5717291.html#test4    #Selenuim+Python之元素定位总结及实例说明
https://www.cnblogs.com/luxiaojun/p/6144748.html        #Selenium + PhantomJS + python 简单实现爬虫的功能
https://www.cnblogs.com/liuwei0824/p/8305808.html       #python-爬虫-selenium模块


注释：在python webdriver中
          current_window_handle为得到当前窗口函数
          window_handles获取所有窗口函数
          switch_to_window（）进入指定的窗口函数

/7079234035/104663655
div
class="home__timeline__list"
"""
