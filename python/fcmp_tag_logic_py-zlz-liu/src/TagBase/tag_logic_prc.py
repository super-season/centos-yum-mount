# coding: utf-8
# @Time    : 2019/5/11 20:41
# @Author  : zhongshan
# @Email   : 15926220700@139.com

import sys
import time

from TagBase import template

from TagBase.tag_info_prc import TagInfoPrc
from TagProc import template_c13


class TagLogicPrc(object):
    """ 标签逻辑类
    主要负责生成标签生成逻辑脚本
    """

    def __init__(self, c_config):
        # 标签值表文件路径
        self.custom_id = c_config['custom_id']
        self.mama_file_path = c_config['mama_file_path']
        self.tag_info = TagInfoPrc(c_config['file_path'], c_config['custom_id'], c_config['db_config'])
        # 用户标签表、用户中间值表、用户下载表名
        self.tag_tb_name = c_config['tag_tb_name']
        self.dld_tb_name = c_config['dld_tb_name']
        self.mid_tb_name = c_config['mid_tb_name']
        self.member_key = c_config['member_key']
        # 输出文件
        self.out_name = '../../outfile/tl_c' + str(self.custom_id) + '_logic.sql'
        # 当前时间
        self.curr_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
        # 表关联关系
        self.table_relation = c_config['table_relation']
        self.table_relation[self.tag_tb_name] = [[self.tag_tb_name, [['id', 'id']]]]
        self.table_relation[self.dld_tb_name] = [[self.dld_tb_name, [['id', 'id']]]]
        self.table_relation[self.mid_tb_name] = [[self.mid_tb_name, [['id', 'id']]]]

    def _wr_sql(self, sql):
        # 生成sql文件
        with open(self.out_name, 'a+', encoding='utf8') as f:
            f.write(sql)

    def _wr_comment(self, c):
        # 打印sql注释
        with open(self.out_name, 'a+', encoding='utf8') as f:
            f.write('-- ' + c + '\n')

    def _wr_mid_comment(self, c):
        # 打印sql注释
        with open(self.out_name, 'a+', encoding='utf8') as f:
            f.write('-- -----------' + c + '-----------\n')

    def _wr_big_comment(self, c):
        # 打印sql注释
        with open(self.out_name, 'a+', encoding='utf8') as f:
            f.write('-- ----------------------------------\n')
            f.write('--            ' + c + '\n')
            f.write('-- ----------------------------------\n')

    def b1_file_init(self):
        # 生成sql文件
        with open(self.out_name, 'w+', encoding='utf8') as f:
            f.write('-- ----------------------------------\n')
            f.write('-- 客户' + str(self.custom_id) + '标签逻辑 ' + self.curr_time + '\n')
            f.write('-- ----------------------------------\n')

    def b2_base_gen(self, display_fields):
        # 生成tag/dld/mid表，含必显字段
        table_name = list(self.member_key.keys())[0]
        template_dict = {
            'u_tag': self.tag_tb_name,
            'u_dld': self.dld_tb_name,
            'u_mid': self.mid_tb_name,
            'keys_str': ', '.join(self.member_key[table_name]),
            'tb_customer': table_name,
            'fields': ', '.join(display_fields),
        }
        sql = template.tl_001_base_gen_template.substitute(template_dict)
        self._wr_sql(sql)

    def _table_relation(self, tb_src, tb_obj, join_str='left'):
        # 单表关联情况下将表名转为列表
        tb_obj_list = tb_obj if isinstance(tb_obj, list) else [tb_obj]
        # 表连接和关联关系字符串生成
        sql = ''
        # 已经关联过的表的集合
        tb_set = set([tb_src])
        # 多个关联表中取一个
        for tb_obj in tb_obj_list:
            # 一个关联表的多级关联关系中取一级
            # 每个表关联字符串中的左表，最左边是u表
            tb_left = tb_src
            for table_relation in self.table_relation[tb_obj]:
                # 这个表已经关联过了
                if table_relation[0] in tb_set:
                    # 更新左表表名
                    tb_left = table_relation[0]
                else:
                    # 拼接关联关系
                    r1 = [(tb_left + '.' + r[0] + ' = ' + table_relation[0] + '.' + r[1]) for r in table_relation[1]]
                    sql += '\n' + join_str + ' join ' + table_relation[0] + ' \non ' + ' and '.join(r1)
                    # 更新左表表名
                    tb_left = table_relation[0]
                    # 将右表加入已关联表集合
                    tb_set.add(table_relation[0])
        return sql

    def _i_01_type1_case(self, base_conf, when_conf, f_when):
        # 类型1 case between
        # 如果是t_tag表则字段前面加t_u_
        tu_tag_field_name = ('t_u_' if base_conf['u_tag'] == self.tag_tb_name else '') + base_conf['tag_field_name']
        # 拼接关联关系
        join_table = self._table_relation(base_conf['u_tag'], base_conf['table_join'])\
            if 'table_join' in base_conf.keys() else ''

        # 拼接when条件
        w = [f_when(key) for key in list(when_conf.keys())]

        template_dict = {
            'tag_cn_name': base_conf['tag_cn_name'],
            'tu_tag_field_name': tu_tag_field_name,
            'tag_field_type': base_conf['tag_field_type'],
            'tag_field_default': base_conf['tag_field_default'],
            'u_tag': base_conf['u_tag'],
            'join_table': join_table,
            'when_str': '\n'.join(w),
            'case_default': base_conf['case_default'],
        }
        sql = template.tl_i_01_type1_case_template.substitute(template_dict)
        self._wr_sql(sql)

    def _i_01_01_type1_case_between(self, base_conf, when_conf):
        # 拼接when条件
        def f_when(key):
            if when_conf[key][0] == '':
                return 'when ' + base_conf['table_join'] + '.' + base_conf['table_join_field'] + ' <= ' + when_conf[key][1] + ' then ' + key
            elif when_conf[key][1] == '':
                return 'when ' + base_conf['table_join'] + '.' + base_conf['table_join_field'] + ' >= ' + when_conf[key][0] + ' then ' + key
            else:
                return 'when ' + base_conf['table_join'] + '.' + base_conf['table_join_field'] + ' >= ' + when_conf[key][0] \
                       + ' and ' + base_conf['table_join'] + '.' + base_conf['table_join_field'] + ' <= ' + when_conf[key][1] + ' then ' + key
        self._i_01_type1_case(base_conf, when_conf, f_when)

    def _i_01_02_type1_case_where(self, base_conf, when_conf):
        # 拼接when条件
        def f_when(key):
            return 'when ' + when_conf[key] + ' then ' + key
        self._i_01_type1_case(base_conf, when_conf, f_when)

    def _i_01_03_type1_case_map(self, base_conf, when_conf):
        # 拼接when条件
        def f_when(key):
            return 'when ' + base_conf['table_join'] + '.' + base_conf['table_join_field'] + " = '" + when_conf[key] + "' then " + key
        self._i_01_type1_case(base_conf, when_conf, f_when)

    def b_1101_tag_type1_case_between(self, base_conf, when_conf):
        # 类型1 case between tag表
        self._wr_comment(sys._getframe().f_code.co_name)

        base_conf['tag_field_type'] = 'int(5)'
        base_conf['tag_field_default'] = base_conf['case_default']
        base_conf['u_tag'] = self.tag_tb_name
        self._i_01_01_type1_case_between(base_conf, when_conf)

    def b_1201_tag_type1_case_where(self, base_conf, when_conf):
        # 类型1 case where tag表
        self._wr_comment(sys._getframe().f_code.co_name)

        base_conf['tag_field_type'] = 'int(5)'
        base_conf['tag_field_default'] = base_conf['case_default']
        base_conf['u_tag'] = self.tag_tb_name
        self._i_01_02_type1_case_where(base_conf, when_conf)

    def b_1202_mid_type1_case_where_else(self, base_conf, when_conf):
        # 类型1 case where mid表
        self._wr_comment(sys._getframe().f_code.co_name)

        base_conf['u_tag'] = self.mid_tb_name
        self._i_01_02_type1_case_where(base_conf, when_conf)

    def b_1301_tag_type1_case_map(self, base_conf, when_conf):
        # 类型1 case 字符串直接映射
        self._wr_comment(sys._getframe().f_code.co_name)

        base_conf['tag_field_type'] = 'int(5)'
        base_conf['tag_field_default'] = '0'
        base_conf['u_tag'] = self.tag_tb_name
        self._i_01_03_type1_case_map(base_conf, when_conf)

    def _i_02_type1_where(self, base_conf):
        # 类型1 2表 where条件
        # 如果是t_tag表则字段前面加t_u_
        tu_tag_field_name = ('t_u_' if base_conf['u_tag'] == self.tag_tb_name else '') + base_conf['tag_field_name']
        # 拼接关联关系

        join_table = self._table_relation(base_conf['u_tag'], base_conf['table_join'])\
            if 'table_join' in base_conf.keys() else ''
        template_dict = {
            'tag_cn_name': base_conf['tag_cn_name'],
            'tu_tag_field_name': tu_tag_field_name,
            'tag_field_type': base_conf['tag_field_type'],
            'tag_field_default': base_conf['tag_field_default'],
            'u_tag': base_conf['u_tag'],
            'join_table': join_table,
            'tag_value': base_conf['tag_value'],
            'where_str': base_conf['where_str'],
        }
        sql = template.tl_i_03_type1_where_template.substitute(template_dict)
        self._wr_sql(sql)

    def b_2001_tag_type1_where(self, base_conf):
        # 类型1 tag表 where条件
        self._wr_comment(sys._getframe().f_code.co_name)

        base_conf['u_tag'] = self.tag_tb_name
        self._i_02_type1_where(base_conf)

    def b_2002_mid_type1_where(self, base_conf):
        # 类型1 mid表 where条件
        self._wr_comment(sys._getframe().f_code.co_name)

        base_conf['u_tag'] = self.mid_tb_name
        self._i_02_type1_where(base_conf)

    def _i_03_type2_basic(self, base_conf):
        # 类型2基本语句
        # 拼接关联关系
        join_table = self._table_relation(base_conf['u_tag'], base_conf['table_join'], 'inner')\
            if 'table_join' in base_conf.keys() else ''
        # 聚合函数是count则count(*)
        b_table_join_field = '*' if base_conf['agg_func'] == 'count' else base_conf['table_join_field']
        # 如果是t_tag表则字段前面加t_u_
        tu_tag_field_name = ('t_u_' if base_conf['u_tag'] == self.tag_tb_name else '') + base_conf['tag_field_name']
        # 如果是t_mid表则注释前面加过程值字样
        mid_tag_cn_name = ('过程值：' if base_conf['u_tag'] == self.mid_tb_name else '') + base_conf['tag_cn_name']

        template_dict = {
            'tag_cn_name': mid_tag_cn_name,
            'tu_tag_field_name': tu_tag_field_name,
            'tag_field_type': base_conf['tag_field_type'],
            'tag_field_default': base_conf['tag_field_default'],
            'u_tag': base_conf['u_tag'],
            'join_table': join_table,
            'b_table_join_field': b_table_join_field,
            'agg_func': base_conf['agg_func'],
            'where_str': base_conf['where_str'],
        }
        sql = template.tl_i_02_type2_basic_template.substitute(template_dict)
        self._wr_sql(sql)

    def b_3001_mid_type2_basic(self, base_conf):
        # 类型2基本语句
        self._wr_comment(sys._getframe().f_code.co_name)

        base_conf['u_tag'] = self.mid_tb_name
        self._i_03_type2_basic(base_conf)

    def _i_05_dld_single(self, base_conf):
        # 下载表生成 单选标签
        template_dict = {
            'tag_cn_name': base_conf['tag_cn_name'],
            'tag_field_name': base_conf['tag_field_name'],
            'custom_id': self.custom_id,
        }
        sql = template.tl_i_05_dld_single_template.substitute(template_dict)
        self._wr_sql(sql)

    def _i_06_dld_multi_add(self, base_conf):
        # 下载表生成 多选标签 添加字段
        template_dict = {
            'tag_cn_name': base_conf['tag_cn_name'],
            'tag_field_name': base_conf['tag_field_name'],
            'custom_id': self.custom_id,
        }
        sql = template.tl_i_06_dld_multi_add_template.substitute(template_dict)
        self._wr_sql(sql)

    def _i_07_dld_multi(self, base_conf):
        # 下载表生成 多选标签 标签值拼接
        template_dict = {
            'custom_id': self.custom_id,
            'tag_field_name': base_conf['tag_field_name'],
            'tag_field_name_i': base_conf['tag_field_name_i'],
        }
        sql = template.tl_i_07_dld_multi_template.substitute(template_dict)
        self._wr_sql(sql)

    def b7_dld_gen(self):
        # 下载表生成
        self._wr_comment(sys._getframe().f_code.co_name)

        for tag_attr in self.tag_info.tag_attrs:
            # 多选标签
            if tag_attr['multi']:
                # 添加字段
                base_conf = {
                    'tag_cn_name': tag_attr['level_2'],
                    'tag_field_name': tag_attr['level_2_eng'],
                }
                self._i_06_dld_multi_add(base_conf)
                # 标签值拼接
                for i in range(0, len(tag_attr['level_3s'])):
                    base_conf = {
                        'tag_field_name': tag_attr['level_2_eng'],
                        'tag_field_name_i': tag_attr['level_2_eng'] + '_' + str(i),
                    }
                    self._i_07_dld_multi(base_conf)
            # 单选标签
            else:
                base_conf = {
                    'tag_cn_name': tag_attr['level_2'],
                    'tag_field_name': tag_attr['level_2_eng'],
                }
                self._i_05_dld_single(base_conf)


if __name__ == "__main__":
    c13_config = {'file_path': template_c13.TAG_FILE_PATH,
                  'custom_id': template_c13.CUSTOM_ID,
                  'db_config': template_c13.DB_CONFIG,
                  'tag_tb_name': template_c13.TAG_TB_NAME,
                  'dld_tb_name': template_c13.DLD_TB_NAME,
                  'mid_tb_name': template_c13.MID_TB_NAME,
                  'member_key': template_c13.MEMBER_KEY,
                  'table_relation': template_c13.TABLE_RELATION,
                  }
    t = TagLogicPrc(c13_config)
    print(t._table_relation('u_tag_13', ['table2']))
    print(t._table_relation('u_tag_13', ['table2'], 'inner'))
    print("Finish")
