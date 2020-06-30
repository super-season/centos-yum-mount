# -*- coding: utf-8 -*-
# @Time    : 2018-9-20 11:05
# @Author  : Huang Jiahao
# @Email   : 15625050341@139.com

import sys
import importlib

importlib.reload(sys)
#sys.setdefaultencoding('utf8')  # 设置默认编码格式为'utf-8'
import os
import datetime
import csv
import pymysql
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.application import MIMEApplication

DB_OPTION = {
    'host': '192.168.0.206',
    'port': 3306,
    'user': 'root',
    'passwd': 'wislife123',
    'db': 'CMMC',
    'charset': 'utf8'
}

EMAIL_OPTION = {
    'msg_from': '原力商情平台',
    'msg_to': '',
    'subject': '{} 移动招标网数据报告',
    #'smtp_server': 'smtp.mxhichina.com',
    'smtp_server': 'smtp.qq.com',
    'smtp_port': '465',
    #'email_from': 'yuqing_service@bdforce.cn',
    'email_from': '739136979@qq.com',
    #'password': 'WisLife@#2018#@',
    'password': 'yonafivocvgbbaib',
    # 'email_to': ['1057603803@qq.com']
    #'email_to': ['13657895359@139.com', '13580590845@139.com', '15926220700@139.com', '13922201286@139.com']
    'email_to': ['13726681098@139.com']
}


def build_gbk_csv(data, date):
    """
    构建 gbk 编码的 csv文件
    :param data: 输入数据，四元组（采购单位，标题，链接，发表日期）列表
    :type data: List[Tuple(str, str, str, str)]
    :param date: 文件名日期
    :type date: str
    :return: None
    """
    fieldnames = [
        u'采购单位'.encode('gbk'),
        u'标题'.encode('gbk'),
        u'链接'.encode('gbk'),
        u'发标日期'.encode('gbk')
    ]
    with open('../report/{}-gbk.csv'.format(date), 'w') as f:   #以日期作为文件名，没有会自动重建
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for bid in data:
            writer.writerow({
                u'采购单位'.encode('gbk'): bid[0].encode('gbk'),
                u'标题'.encode('gbk'): bid[1].encode('gbk'),
                u'链接'.encode('gbk'): bid[2].encode('gbk'),
                u'发标日期'.encode('gbk'): bid[3].strftime('%Y-%m-%d').encode('gbk')
            })


def build_utf8_csv(data, date):
    """
    构建 utf 编码的 csv
    :param data: 输入数据，四元组（采购单位，标题，链接，发表日期）列表
    :type data: List[Tuple(str, str, str, str)]
    :param date: 文件名日期
    :type date: str
    :return: None
    """
    fieldnames = [u'采购单位', u'标题', u'链接', u'发标日期']
    with open('../report/{}.csv'.format(date), 'w') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for bid in data:
            writer.writerow({
                u'采购单位': bid[0].encode('utf8'),
                u'标题': bid[1].encode('utf8'),
                u'链接': bid[2].encode('utf8'),
                u'发标日期': bid[3].strftime('%Y-%m-%d').encode('utf8')
            })


def send_email(date, options):
    """
    发送邮件
    :param date: 要发送的指定日期的文件
    :type date: str
    :param options: 邮件服务配置
    :type options: dict
    :return:
    """
    s = None
    try:
        msg = MIMEMultipart()
        msg['Subject'] = options['subject'].format(date)
        msg['From'] = options['msg_from']
        msg['To'] = options['msg_to'] if options['msg_to'] else u'收件人'

        # 正文部分
        text = MIMEText('{} 中移动招标信息附件报告'.format(date))
        msg.attach(text)

        # 附件部分
        filename = u'{}-gbk.csv'.format(date)
        with open(os.path.join(u'../report/', filename), 'r') as f:
            data = f.read()
        csvpart = MIMEApplication(data)
        csvpart.add_header('Content-Disposition', 'attachment',
                           filename=filename)
        msg.attach(csvpart)

        # 发送邮件
        s = smtplib.SMTP_SSL(options['smtp_server'], options['smtp_port'])
        s.login(options['email_from'], options['password'])
        s.sendmail(options['email_from'], options['email_to'], msg.as_string())
    except Exception as ex:
        print(u"send mail failed: {0}".format(ex))
    finally:
        s.quit() if s else None


def fetch_data_from_mysql():
    """
    获取需要生成报告的数据
    :rtype: List
    """
    today = datetime.datetime.today().strftime("%Y-%m-%d")
    yesterday = (datetime.datetime.today() - datetime.timedelta(
        days=1)).strftime("%Y-%m-%d")
    now_hour = datetime.datetime.now().hour
    # now_hour = 16 
    if now_hour == 8 or now_hour == 14:
        sql = (u"SELECT `company`, `title`, `url`, `pub_date` "
               u"FROM `bid` WHERE `crawl_time` BETWEEN %(ltime)s AND %(rtime)s")
        sql_param = dict()
        sql_param['ltime'] = yesterday + " 16:00:00" if now_hour == 8 else today + " 08:00:00"
        sql_param['rtime'] = today + " 08:00:00" if now_hour == 8 else today + " 16:00:00"
        conn = pymysql.connect(**DB_OPTION)
        cursor = conn.cursor()
        print("sql is {0}, sql_param is {1}".format(sql, sql_param))
        cursor.execute(sql, sql_param)
        bid_collection = cursor.fetchall()
    else:
        bid_collection = []
    return bid_collection

if __name__ == '__main__':
    if not os.path.exists(os.path.join('..', 'report')):
        os.mkdir(os.path.join('..', 'report'))
    today = datetime.datetime.today().strftime("%Y-%m-%d")
    try:
        # 获取报告数据
        bid_collection = fetch_data_from_mysql()
        print("len of collection is {0}".format(len(bid_collection)))
        # 构建 gbk 编码的 csv
        build_gbk_csv(bid_collection, today)
        # 构建 utf 编码的 csv
        build_utf8_csv(bid_collection, today)
        # 发送邮件
        send_email(today, EMAIL_OPTION)
        print("finish")
    except Exception as ex:
        print(ex)
