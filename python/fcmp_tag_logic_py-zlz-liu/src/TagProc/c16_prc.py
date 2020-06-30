# coding: utf-8
# @Time    : 2019/5/11 20:41
# @Author  : zhongshan
# @Email   : 15926220700@139.com

from TagBase.tag_logic_prc import TagLogicPrc
from TagProc import template_c16 as template_c


class C16Prc(TagLogicPrc):
    """ 标签逻辑类
    客户C16的标签生成逻辑
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

        # 过程值：注册天数
        base_conf = {
            'tag_cn_name': '过程值：注册天数',
            'tag_field_name': 'reg_days',
            'tag_field_type': 'int(11)',
            'tag_field_default': 'null',
            'table_join': 'customer_list',
            'tag_value': 'TIMESTAMPDIFF(DAY, customer_list.reg_date, CURDATE())',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 过程值：付费功能体验到期时间
        base_conf = {
            'tag_cn_name': '过程值：付费功能体验到期时间',
            'tag_field_name': 'paid_expire_days',
            'tag_field_type': 'int(11)',
            'tag_field_default': 'null',
            'table_join': 'customer_list',
            'tag_value': 'TIMESTAMPDIFF(DAY, CURDATE(), customer_list.reg_date) + 15',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 过程值：免费功能体验到期时间
        base_conf = {
            'tag_cn_name': '过程值：免费功能体验到期时间',
            'tag_field_name': 'free_expire_days',
            'tag_field_type': 'int(11)',
            'tag_field_default': 'null',
            'table_join': 'customer_list',
            'tag_value': 'TIMESTAMPDIFF(DAY, CURDATE(), customer_list.reg_date) + 60',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 客户属性
        base_conf = {
            'tag_cn_name': '客户属性',
            'tag_field_name': 'c_attr',
            'table_join': 'u_mid_16',
            'table_join_field': 'reg_days',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '60'],
            '2': ['61', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 付费功能体验到期时间
        base_conf = {
            'tag_cn_name': '付费功能体验到期时间',
            'tag_field_name': 'paid_expire',
            'table_join': 'u_mid_16',
            'table_join_field': 'paid_expire_days',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '-1'],
            '2': ['0', '3'],
            '3': ['4', '7'],
            '4': ['8', '10'],
            '5': ['11', '15'],
            '6': ['15', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 免费功能体验到期时间
        base_conf = {
            'tag_cn_name': '免费功能体验到期时间',
            'tag_field_name': 'free_expire',
            'table_join': 'u_mid_16',
            'table_join_field': 'free_expire_days',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '-1'],
            '2': ['0', '3'],
            '3': ['4', '7'],
            '4': ['8', '10'],
            '5': ['11', '15'],
            '6': ['15', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 下载表生成
        self._wr_big_comment('下载表生成')
        self.b7_dld_gen()


if __name__ == "__main__":
    c16_config = {'file_path': template_c.TAG_FILE_PATH,
                  'custom_id': template_c.CUSTOM_ID,
                  'db_config': template_c.DB_CONFIG,
                  'tag_tb_name': template_c.TAG_TB_NAME,
                  'dld_tb_name': template_c.DLD_TB_NAME,
                  'mid_tb_name': template_c.MID_TB_NAME,
                  'member_key': template_c.MEMBER_KEY,
                  'table_relation': template_c.TABLE_RELATION,
                  }
    t = C16Prc(c16_config)
    # 生成标签信息
    # t.tag_info.tag_level_1_prc()
    # t.tag_info.tag_level_2_prc()
    # t.tag_info.tag_level_3_prc()
    # print("Finish: 生成标签信息")
    # 生成标签逻辑脚本
    t.gen_script()
    print("Finish")
