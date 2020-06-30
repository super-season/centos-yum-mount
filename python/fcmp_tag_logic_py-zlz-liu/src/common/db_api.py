# coding: utf-8
# @Time    : 2019/3/8 16:51
# @Author  : huangjiahao
# @Email   : 15625050341@139.com
import pymysql


class DBApi(object):
    """ MySQL Helper 类
    """
    def __init__(self, config):
        self.config = config
        self.__conn = None
        self.__cursor = None

    def connect(self, auto_commit=True):
        try:
            self.__conn = pymysql.connect(
                autocommit=auto_commit, **self.config)
            self.__cursor = self.__conn.cursor()
        except Exception as ex:
            raise Exception("Connect to db failed: {0}".format(ex))

    def _run_sql(self, sql, param=None, func=None):
        if not self.__cursor:
            self.connect()
        cmd = self.__cursor.execute if func is None else func
        return cmd(sql, param)

    # context Method
    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.__del__()

    def query_one(self, sql, param=None):
        self._run_sql(sql, param)
        return self.__cursor.fetchone()

    def query_many(self, sql, param=None):
        self._run_sql(sql, param)
        return self.__cursor.fetchall()

    def modify(self, sql, param=None):
        return self._run_sql(sql, param)

    def modify_many(self, sql, param=None):
        return self._run_sql(sql, param, self.__cursor.executemany)

    def ping(self, reconnect=True):
        self.__conn.ping(reconnect)

    def __del__(self):
        if self.__cursor:
            self.__cursor.close()

        if self.__conn and not self.__conn._closed:
            self.__conn.close()

        self._cursor = None
        self.conn = None

    def close(self):
        return self.__del__()
