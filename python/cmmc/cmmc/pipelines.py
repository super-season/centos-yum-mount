# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://doc.scrapy.org/en/latest/topics/item-pipeline.html
import configparser
import pymysql
import logging

logging.basicConfig(level="INFO")


class CmmcPipeline(object):
    def __init__(self):
        """
        连接数据库
        """
        cp = configparser.SafeConfigParser()
        cp.read('config.cfg')
        try:
            self.CONN = pymysql.connect(
                host=cp.get('db', 'host'),
                port=int(cp.get('db', 'port')),
                db=cp.get('db', 'db'),
                user=cp.get('db', 'user'),
                passwd=cp.get('db', 'passwd'),
                charset='utf8'
            )
            self.CURSOR = self.CONN.cursor()
        except Exception as ex:
            logging.debug(
                u'Create database connection failure, {}'.format(ex.message))

    def process_item(self, item, spider):
        if self.has_page_existed(item['tid']):
            return item
        sql = u"""
            INSERT INTO `bid` (`tid`, `company`, `title`, `url`,`content`, 
            `keyword`, `crawl_time`, `pub_date`) VALUES (%(tid)s, %(company)s, 
            %(title)s, %(url)s,%(content)s, %(keyword)s, %(crawl_time)s, 
            %(pub_date)s)"""
        sql_param = dict()
        sql_param['tid'] = item['tid']
        sql_param['company'] = item['company']
        sql_param['title'] = item['title']
        sql_param['url'] = item['url']
        sql_param['content'] = item['content']
        sql_param['keyword'] = item['keyword']
        sql_param['crawl_time'] = item['crawl_time']
        sql_param['pub_date'] = item['pub_date']
        try:
            self.CURSOR.execute(sql, sql_param)
        except Exception as ex:
            self.CONN.rollback()
            logging.debug(u'something wrong happened when insert data into database! ')
            logging.error(ex, exc_info=1)
        else:
            self.CONN.commit()
            logging.info(u'insert db success!')
        finally:
            return item

    def has_page_existed(self, page_id):
        has_existed = False
        sql = u"SELECT COUNT(1) FROM `bid` WHERE `tid` = %(tid)s"
        sql_param = dict()
        sql_param['tid'] = page_id
        try:
            self.CURSOR.execute(sql, sql_param)
            count = self.CURSOR.fetchone()[0]
            if count > 0:
                has_existed = True
        except Exception as ex:
            logging.error(
                u'something wrong happened when searching page id has existed or not! {}',
                ex)
        finally:
            return has_existed
