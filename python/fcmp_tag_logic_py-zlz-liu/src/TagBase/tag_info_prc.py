# coding: utf-8
# @Time    : 2019/5/11 20:41
# @Author  : zhongshan
# @Email   : 15926220700@139.com

import time

from TagBase.config import (
    TAG_ATTRS_MAP,
    TABLE_NAME_T_TAG,
    TABLE_NAME_T_TAG_VALUE,
)
from TagBase.template import (
    t_tag_ins_template,
    t_tag_value_ins_template
)
from TagProc.template_c12 import (
    DB_CONFIG,
    CUSTOM_ID,
    TAG_FILE_PATH,
)
from common.db_api import DBApi


class TagInfoPrc(object):
    """ 标签信息类
    主要负责载入标签信息文件，生成插入数据库t_tag和t_tag_value表的信息
    """

    def __init__(self, file_path, custom_id, db_config):
        # 标签值表文件路径
        self.file_path = file_path
        self.custom_id = custom_id
        self.tags = []
        self.tag_attrs = []
        self.tag_1_attrs = []
        self.tag_1_ids = {}
        self.db = DBApi(db_config)

        # 当前时间
        self.curr_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))

        # 读取标签文件
        self.read_tag_file()

    def read_tag_file(self):
        """ 读标签值表
        :type tables: 
        :param tables: 
        :rtype: list
        :return: 标签值表中内容载入二维list
        """
        # 读取文件
        with open(self.file_path, 'r', encoding='gbk') as f:
            for line in f.readlines():
                self.tags.append(line.strip('\n').split(','))
        print(self.tags)

        # 解析第一行，确定字段位置
        def pos(str1):
            return self.tags[0].index(str1) if str1 in self.tags[0] else 0

        tag_attrs_pos = dict(zip(TAG_ATTRS_MAP, (map(pos, TAG_ATTRS_MAP.values()))))
        print(tag_attrs_pos)

        # 标签信息行结构化
        self.tag_attrs = []
        for line in self.tags[1:]:
            tag_attr = {'level_1': line[tag_attrs_pos['level_1']],
                        'level_2': line[tag_attrs_pos['level_2']],
                        'level_2_eng': line[tag_attrs_pos['level_2_eng']],
                        'multi': True if line[tag_attrs_pos['multi']] == '是' else False,
                        'level_3s': list(filter(None, line[tag_attrs_pos['level_3_base']:]))}
            self.tag_attrs.append(tag_attr)
        print(self.tag_attrs[-1])

        # 一级标签信息列表
        self.tag_1_attrs = []
        for tag_attr in self.tag_attrs:
            if tag_attr['level_1'] not in self.tag_1_attrs:
                self.tag_1_attrs.append(tag_attr['level_1'])
        print(self.tag_1_attrs)

    def tag_level_1_prc(self):
        """ 处理一级标签
        :type tables: 
        :param tables: 
        :rtype: 
        :return: 
        """

        # 生成insert语句
        def trans(str1):
            return "'" + str1 + "'"

        sqls = []
        for line in self.tag_1_attrs:
            template_dict = {
                't_tag': TABLE_NAME_T_TAG,
                'customer_id': self.custom_id,
                'pid': 0,
                'tag_name': trans(line),
                'tag_define': 'null',
                'dld_field_name': 'null',
                'create_time': trans(self.curr_time),
                'update_time': trans(self.curr_time),
                'status': 1,
            }
            sql = t_tag_ins_template.substitute(template_dict)
            sqls.append(sql)
            print(sql)

        # 写入sql文件
        with open('../../outfile/t_tag_ins.sql', 'w+', encoding='utf8') as f:
            f.write('-- -------------------------------\n')
            f.write('-- Records of ' + self.curr_time + '\n')
            f.write('-- -------------------------------\n')
            f.write('-- 一级标签\n')
            for line in sqls:
                f.write(line + '\n')

        # 执行sql
        for sql in sqls:
            print(self.db.modify(sql))

        # 在标签数据库t_tag中读取一级标签的id，因为二级标签需要设置其父id
        sql = 'select id from t_tag where status = 1 and ' \
              'customer_id = %(customer_id)s and pid = 0 and tag_name = %(tag_name)s'
        self.tag_1_ids = {}
        for line in self.tag_1_attrs:
            self.tag_1_ids[line] = self.db.query_one(sql, {"customer_id": self.custom_id, "tag_name": line})[0]
        print(self.tag_1_ids)

    def tag_level_2_prc(self):
        """ 处理二级标签
        :type tables: 
        :param tables: 
        :rtype: 
        :return: 
        """

        # 生成insert语句
        def trans(str1):
            return "'" + str1 + "'"

        sqls = []
        for tag_attr in self.tag_attrs:
            template_dict = {
                't_tag': TABLE_NAME_T_TAG,
                'customer_id': self.custom_id,
                'pid': self.tag_1_ids[tag_attr['level_1']],
                'tag_name': trans(tag_attr['level_2']),
                'tag_define': 'null',
                'dld_field_name': trans('t_u_' + tag_attr['level_2_eng']),
                'create_time': trans(self.curr_time),
                'update_time': trans(self.curr_time),
                'status': 1,
            }
            sql = t_tag_ins_template.substitute(template_dict)
            sqls.append(sql)
            print(sql)

        # 写入sql文件
        with open('../../outfile/t_tag_ins.sql', 'a+', encoding='utf8') as f:
            f.write('\n-- 二级标签\n')
            for line in sqls:
                f.write(line + '\n')

        # 执行sql
        for sql in sqls:
            print(self.db.modify(sql))

        # 读取二级标签的id，因为三级标签需要设置其二级标签id
        sql = 'select id from t_tag where status = 1 and ' \
              'customer_id = %(customer_id)s and pid = %(pid)s and tag_name = %(tag_name)s'
        for tag_attr in self.tag_attrs:
            tag_attr['level_2_id'] = self.db.query_one(sql, {"customer_id": self.custom_id,
                                                             "pid": self.tag_1_ids[tag_attr['level_1']],
                                                             "tag_name": tag_attr['level_2']})[0]
        print(self.tag_attrs)

    def tag_level_3_prc(self):
        """ 处理三级标签
        :type tables: 
        :param tables: 
        :rtype: 
        :return: 
        """

        # 生成insert语句
        def trans(str1):
            return "'" + str1 + "'"

        sqls = []
        for tag_attr in self.tag_attrs:
            for idx, level_3 in enumerate(tag_attr['level_3s']):
                tag_field_name = 't_u_' + tag_attr['level_2_eng']
                template_dict = {
                    't_tag_value': TABLE_NAME_T_TAG_VALUE,
                    'tag_id': tag_attr['level_2_id'],
                    'value_name': trans(level_3),
                    'match_rule': trans('eq'),
                    'match_val': trans('1') if tag_attr['multi'] else trans(str(idx)),
                    'tag_field_name': trans(tag_field_name + '_' + str(idx))
                    if tag_attr['multi'] else trans(tag_field_name),
                    'create_time': trans(self.curr_time),
                    'update_time': trans(self.curr_time),
                    'status': 1,
                }
                sql = t_tag_value_ins_template.substitute(template_dict)
                sqls.append(sql)
                print(sql)

        # 写入sql文件
        with open('../../outfile/t_tag_value_ins.sql', 'w+', encoding='utf8') as f:
            f.write('-- -------------------------------\n')
            f.write('-- Records of ' + self.curr_time + '\n')
            f.write('-- -------------------------------\n')
            f.write('-- 三级标签\n')
            for line in sqls:
                f.write(line + '\n')

        # 执行sql
        for sql in sqls:
            print(self.db.modify(sql))


if __name__ == "__main__":
    t = TagInfoPrc(TAG_FILE_PATH, CUSTOM_ID, DB_CONFIG)
    t.tag_level_1_prc()
    t.tag_level_2_prc()
    t.tag_level_3_prc()
    print("Finish")
