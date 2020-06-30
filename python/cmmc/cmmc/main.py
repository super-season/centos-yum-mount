# -*- coding: utf-8 -*-
# @Time    : 2018-9-19 14:42
# @Author  : Huang Jiahao
# @Email   : 15625050341@139.com

from scrapy.crawler import CrawlerProcess
from scrapy.utils.project import get_project_settings
import re
import datetime
import configparser
import requests
from bs4 import BeautifulSoup
import scrapy
from cmmc.items import BidItem
# from items import BidItem
import logging
# from spiders.bid import BidSpider


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
        self.cp = configparser.ConfigParser()
        self.cp.read('config.cfg',encoding="utf-8")
        self.keywords = self.cp.get("project", "keywords").split(",")

    def start_requests(self):
        """
        爬虫入口
        :return:
        """
        iurl = (u'https://b2b.10086.cn/b2b/main/searchNotice.html?noticeBean.title=')  #中移动采购与招标网公告查询网站
        r = requests.get(iurl, headers=self.headers)   #爬取网页
        if r.status_code != 200:                       #若状态码不是200，即爬取失败，return返回空，None
            return
        soup = BeautifulSoup(r.content, 'html')        #用beautifulsoup解析中移动招标网得到html格式内容
        _qt = soup.select_one('[name=_qt]')["value"]   #公司查询下面有个input。。。
        cookies = r.cookies.get_dict()                 #得到cookies，格式为字典格式

        url = (u'https://b2b.10086.cn/b2b/main/listVendorNoticeResult.html?'
               u'noticeBean.noticeType=2')
        for keyword in self.keywords:     #需要爬的关键字，在config.cfg中
            post_data = {                 #请求数据
                '_qt': _qt,  # 随机值
                'page.currentPage': '1',  # 起始分页
                'page.perPageSize': '20',  # 分页大小
                'noticeBean.sourceCH': '',
                'noticeBean.source': '',
                'noticeBean.title': keyword,  # 搜索标题
                'noticeBean.startDate': (datetime.datetime.today() - datetime.timedelta(
                    days=1)).strftime("%Y-%m-%d"),  # 搜索时间，开始时间
                'noticeBean.endDate': datetime.datetime.today().strftime(
                    "%Y-%m-%d")                     #结束时间
            }
            meta_item = {'keyword': keyword}   #标题
            yield scrapy.FormRequest(url, callback=self.parse_paganation,   #yield相当于return，但是返回一个生成器，用for迭代时，会执行该代码，callback把返回结果回调函数
                                     cookies=cookies, headers=self.headers,
                                     formdata=post_data, meta=meta_item)

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


process = CrawlerProcess(get_project_settings())
process.crawl(BidSpider)

process.start()
