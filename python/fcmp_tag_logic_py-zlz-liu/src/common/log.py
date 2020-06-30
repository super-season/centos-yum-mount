# coding: utf-8
# @Time    : 2019/3/8 16:00
# @Author  : huangjiahao
# @Email   : 15625050341@139.com
import os
import logging


class LogHelper(object):
    """ 日志类
    """
    log_transform = {"info": logging.INFO, "debug": logging.DEBUG,
                     "error": logging.ERROR, "warn": logging.WARNING}

    def __init__(self, name, level="info"):
        """
        :type name: str
        :param name: 日志命名空间
        :type level: str
        :param level: 日志级别，默认为 info
        """
        self.__name = name
        self.__log_level = self.log_transform.get(level, logging.error)
        self.logger = logging.getLogger(name)
        self.logger.setLevel(self.__log_level)

    def debug(self, msg):
        """
        :type msg: str
        :param msg: 日志信息
        """
        self.logger.debug(msg)

    def info(self, msg):
        """
        :type msg: str
        :param msg: 日志信息
        """
        self.logger.info(msg)

    def warn(self, msg):
        """
        :type msg: str
        :param msg: 日志信息
        """
        self.logger.warning(msg)

    def error(self, msg):
        """
        :type msg: str
        :param msg: 日志信息
        """
        self.logger.error(msg)

    def set_handlers(self, handlers):
        """
        :type handlers: List[logging.Handler]
        :param handlers: 日志的handler列表
        """
        for handler in handlers:
            self.logger.addHandler(handler)


def debug_log(name):
    """ 调试日志生成
    :type name: str
    :param name: 日志名
    :rtype: LogHelper
    """
    logger = LogHelper(name, "debug")
    # config formatter & handler
    formatter = logging.Formatter(fmt='%(asctime)s - %(levelname)s:'
                                  ' %(message)s', datefmt="%Y-%m-%d %H:%M:%S")
    console = logging.StreamHandler()
    console.setFormatter(formatter)
    logger.set_handlers([console])

    return logger


def product_log(name):
    """ 生产日志生成
    :type name: str
    :param name: 日志名
    :rtype: LogHelper
    """
    logger = LogHelper(name, "debug")
    # config formatter & handler
    formatter = logging.Formatter(fmt='%(asctime)s - %(levelname)s:'
                                  ' %(message)s', datefmt="%Y-%m-%d %H:%M:%S")
    console = logging.StreamHandler()
    console.setLevel(logging.DEBUG)
    if not os.path.exists(os.path.abspath('logs/')):
        os.mkdir('logs')
    filehandler = logging.FileHandler(
        filename="logs/%s.log" % name, mode='a+')
    filehandler.setLevel(logging.INFO)
    console.setFormatter(formatter)
    filehandler.setFormatter(formatter)
    logger.set_handlers([console, filehandler])
    return logger
