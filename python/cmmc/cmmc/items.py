# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class BidItem(scrapy.Item):
    tid = scrapy.Field()
    company = scrapy.Field()
    title = scrapy.Field()
    url = scrapy.Field()
    content = scrapy.Field()
    keyword = scrapy.Field()
    crawl_time = scrapy.Field()
    pub_date = scrapy.Field()
