# coding: utf-8
# @Time    : 2019/7/25 11:09
# @Author  : zhoulizhong
# @Email   : 919781714@qq.com

from TagBase.tag_logic_prc import TagLogicPrc
from TagProc import template_c20 as template_c


class C20Prc(TagLogicPrc):
    """ 标签逻辑类
    客户C20--中大树华的标签生成逻辑
    """

    def __init__(self, c_config):
        super().__init__(c_config)

        # 生成sql文件
        self.b1_file_init()

    def gen_script(self):
        """ 生成全部sql脚本
        """
        # 前置操作：生成会员表
        self._wr_sql(template_c.tl_pre_001)

        # 基础表生成
        self.b2_base_gen(template_c.DISPLAY_FIELDS)

        # 标签逻辑
        self._wr_big_comment('标签逻辑-标签表')

        # 一级标签 基本信息
        self._wr_mid_comment('一级标签 基本信息')

        # 性别
        base_conf = {
            'tag_cn_name': '性别',
            'tag_field_name': 'gender',
            'table_join': 'customer_list',
            'table_join_field': 'gender',
            'case_default': '0',
        }
        when_conf = {
            '1': '男',
            '2': '女',
        }
        self.b_1301_tag_type1_case_map(base_conf, when_conf)

        # 过程值：年龄
        base_conf = {
            'tag_cn_name': '过程值：年龄',
            'tag_field_name': 'age_year',
            'tag_field_type': 'int(10)',
            'tag_field_default': 'null',
            'table_join': 'customer_list',
            'tag_value': 'TIMESTAMPDIFF(YEAR, customer_list.birthday, CURDATE())',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 年龄
        base_conf = {
            'tag_cn_name': '年龄',
            'tag_field_name': 'age',
            'table_join': 'u_mid_20',
            'table_join_field': 'age_year',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '6'],
            '2': ['7', '9'],
            '3': ['10', '12'],
            '4': ['13', '15'],
            '5': ['16', '18'],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 剩余课时
        base_conf = {
            'tag_cn_name': '剩余课时',
            'tag_field_name': 'remaining_hours',
            'table_join': 'customer_list',
            'table_join_field': 'remaining_hours',
            'case_default': '0',
        }

        when_conf = {
            '1': ['0', '0'],
            '2': ['1', '1'],
            '3': ['2', '4'],
            '4': ['5', '7'],
            '5': ['8', '10'],
            '6': ['11', '13'],
            '7': ['13', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 所属课程
        base_conf = {
            'tag_cn_name': '所属课程',
            'tag_field_name': 'class_name',
            'table_join': 'customer_list',
            'table_join_field': 'class_name',
            'case_default': '0',
        }
        when_conf = {
            '1': '艺术涂鸦班',
            '2': '创意漫画初级班',
            '3': '创意绘画中级班',
            '4': '硬笔书法班',
            '5': '写意国画班',
            '6': '趣味色彩班',
            '7': '基础素描',
            '8': '创意漫画班',
            '9': '漫画班',
            '10': '成人素描',
            '11': '成人国画',
            '12': '创意漫画中级',
            '13': '成人油画班',
        }
        self.b_1301_tag_type1_case_map(base_conf, when_conf)

        # 过程值：周几
        base_conf = {
            'tag_cn_name': '过程值：周几',
            'tag_field_name': 'class_time',
            'tag_field_type': 'int(5)',
            'table_join': 'customer_list',
            'table_join_field': 'class_time',
            'tag_field_default': '0',
            'case_default': '0',
        }
        when_conf = {
            '1': 'customer_list.class_time = \'周日\'',
            '2': 'customer_list.class_time = \'周一\'',
            '3': 'customer_list.class_time = \'周二\'',
            '4': 'customer_list.class_time = \'周三\'',
            '5': 'customer_list.class_time = \'周四\'',
            '6': 'customer_list.class_time = \'周五\'',
            '7': 'customer_list.class_time = \'周六\'',
            '8': 'customer_list.class_time = \'周一至周五\'',

        }
        self.b_1202_mid_type1_case_where_else(base_conf, when_conf)

        # 课程提醒
        base_conf = {
            'tag_cn_name': '课程提醒',
            'tag_field_name': 'class_remind',
            'table_join': 'u_mid_20',
            'case_default': '0',
        }
        when_conf = {
            # 本自然周课程结束
            '1': '(u_mid_20.class_time - DAYOFWEEK(CURDATE())) in (-1,-2,-3,-4)',
            # 今天
            '2': '(u_mid_20.class_time - DAYOFWEEK(CURDATE())) in(0,3,4,5,6)',
            # 明天
            '3': '(((u_mid_20.class_time = 8 and u_mid_20.class_time - DAYOFWEEK(CURDATE())) = 7) or ((u_mid_20.class_time - DAYOFWEEK(CURDATE())) in (1,-6)))',
            # 后天
            '4': '(((u_mid_20.class_time = 8 and u_mid_20.class_time - DAYOFWEEK(CURDATE())) = 1) or ((u_mid_20.class_time - DAYOFWEEK(CURDATE())) in (2,-5, 7)))',

        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 下载表生成
        self._wr_big_comment('下载表生成')
        self.b7_dld_gen()

if __name__ == "__main__":
    c20_config = {'file_path': template_c.TAG_FILE_PATH,
                  'custom_id': template_c.CUSTOM_ID,
                  'db_config': template_c.DB_CONFIG,
                  'tag_tb_name': template_c.TAG_TB_NAME,
                  'dld_tb_name': template_c.DLD_TB_NAME,
                  'mid_tb_name': template_c.MID_TB_NAME,
                  'member_key': template_c.MEMBER_KEY,
                  'table_relation': template_c.TABLE_RELATION,
                  }
    t = C20Prc(c20_config)
    # 生成标签信息
    # t.tag_info.tag_level_1_prc()

    # t.tag_info.tag_level_2_prc()

    # t.tag_info.tag_level_3_prc()

    # print("Finish: 生成标签信息")
    # 生成标签逻辑脚本
    t.gen_script()
    print("Finish")
