# -*- coding: utf-8 -*-
import re
import datetime
import configparser
import requests
from bs4 import BeautifulSoup
import scrapy
from cmmc.items import BidItem
# from items import BidItem
import logging


class BidSpider(scrapy.Spider):
    name = 'bid'
    allowed_domains = ['b2b.10086.cn']
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 SE 2.X MetaSr 1.0",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "Referer": "https://b2b.10086.cn/b2b/main/searchNotice.html?noticeBean.title=",
        "Host": "b2b.10086.cn"
    }

    def __init__(self):
        self.cp = configparser.ConfigParser()  ##应用模块函数
        self.cp.read('config.cfg')             #读取配置文件，可以为自己创建的
        self.keywords = self.cp.get("project", "keywords").split(",")  #读取project节点的keywords配置项，以'，'分隔
                                                                       #keywords为爬取的关键字

    def start_requests(self):
        """
        爬虫入口
        :return:
        """
        iurl = (u'https://b2b.10086.cn/b2b/main/searchNotice.html?noticeBean.title=')
        r = requests.get(iurl, headers=self.headers)   #向中移动招标网，提出访问请求
        if r.status_code != 200:              #得到状态码，200为正确访问，非200，则直接return，不执行后面语句
            return
        soup = BeautifulSoup(r.content, 'html')       #解析得到的字节流数据，返回html
        _qt = soup.select_one('[name=_qt]')["value"]  #选择name=_qt行中的value值
        cookies = r.cookies.get_dict()                #得到cookies值，返回字典类型

        url = (u'https://b2b.10086.cn/b2b/main/listVendorNoticeResult.html?'
               u'noticeBean.noticeType=2')            #得到采购招标名单和列表，noticeType=2是第二个返回的列表
        for keyword in self.keywords:
            post_data = {
                '_qt': _qt,  # 随机值
                'page.currentPage': '1',  # 起始分页
                'page.perPageSize': '20',  # 分页大小
                'noticeBean.sourceCH': '',
                'noticeBean.source': '',
                'noticeBean.title': keyword,  # 搜索标题
                'noticeBean.startDate': (datetime.datetime.today() - datetime.timedelta(
                    days=1)).strftime("%Y-%m-%d"),  # 搜索时间，格式200-03-23，当前时间前一天
                'noticeBean.endDate': datetime.datetime.today().strftime(
                    "%Y-%m-%d")                     #结束时间，今天
            }
            meta_item = {'keyword': keyword}        #关键字
            yield scrapy.FormRequest(url, callback=self.parse_paganation,
                                     cookies=cookies, headers=self.headers,
                                     formdata=post_data, meta=meta_item)  #相当于return
                  #模拟表单，Ajax提交post时用，scrapy.FormRequest相当于手动指定POST，自带的formdata专门用来设置表单字段数据，
                  #  即填写账号，密码，实现登入，默认method是POST
            #url是要爬取的网址；callback是回调函数；method是请求方法，GET或者POST；
            #headers是伪装浏览器的头部信息；body是网页源码信息；cookies是登入网站后，网站在你电脑上保留的验证信息
            #meta是要携带或者传递的信息；encoding是编码方式；formdata是表单数据，字典格式，数字也要用引号括起来
            #dont_filter是否重复爬取
    def parse_paganation(self, response):
        """
        爬虫解析
        :param response:
        :return:
        """
        raw_url = u'https://b2b.10086.cn/b2b/main/viewNoticeContent.html?noticeBean.id={}'
        res = response.css("table.zb_result_table tr")
        for i in res[2:]:
            # 提取跳转文章的 id
            raw_text = i.css("::attr(onclick)").extract_first()
            page_id = re.sub("\D", "", raw_text)
            item = BidItem()
            item['tid'] = int(page_id)
            item['company'] = i.css("td::text")[0].extract()
            page_url = raw_url.format(page_id)
            item['url'] = page_url
            item['keyword'] = response.meta['keyword']
            item['pub_date'] = i.css("td::text")[-1].extract()
            item['crawl_time'] = datetime.datetime.now().strftime(
                "%Y-%m-%d %H:%M:%S")
            yield scrapy.Request(page_url, callback=self.parse_content,
                                 headers=self.headers, meta={"page": item})

        link = []
        # 由于当不存在任何返回结果的时候也会存在下一页和尾页的跳转，所以要提前判断
        if response.css("#totalRecordNum::attr(value)").extract_first().replace(
                ',', '') != u'0':
            # 获取可以跳转的标签，为（首页、上一页、下一页、尾页）的子集
            link = response.css("a.link span::text").extract()
        # 存在下一页和尾页的跳转标签
        if u"下一页" in link:
            raw_link = response.css("a.link::attr(onclick)").extract()[-2]
            next_page = re.sub("\D", "", raw_link)
            post_data = {
                'page.currentPage': next_page,
                'page.perPageSize': '20',
                'noticeBean.sourceCH': '',
                'noticeBean.source': '',
                'noticeBean.title': response.meta['keyword'],
                'noticeBean.startDate': (datetime.datetime.today() - datetime.timedelta(
                    days=1)).strftime("%Y-%m-%d"),  # 搜索时间
                'noticeBean.endDate': datetime.datetime.today().strftime(
                    "%Y-%m-%d")
            }
            self.log(post_data, logging.DEBUG)
            yield scrapy.FormRequest(response.request.url,
                                     callback=self.parse_paganation,
                                     headers=self.headers, formdata=post_data,
                                     meta=response.meta)

    def parse_content(self, response):
        """
        正文解析
        :param response:
        :return:
        """
        item = response.meta["page"]
        title = response.css("table.zb_table h1::text").extract_first()
        content = response.xpath("//table[@class='zb_table']").xpath("string(.)").extract_first()
        item['title'] = title
        item['content'] = content
        yield item
