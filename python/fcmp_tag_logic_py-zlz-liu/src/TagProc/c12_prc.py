# coding: utf-8
# @Time    : 2019/5/11 20:41
# @Author  : zhongshan
# @Email   : 15926220700@139.com

from TagBase.tag_logic_prc import TagLogicPrc
from TagProc import template_c12_liu as template_c


class C12Prc(TagLogicPrc):
    """ 标签逻辑类
    客户C12的标签生成逻辑
    """

    def __init__(self, c_config):
        super().__init__(c_config)

        # 生成sql文件
        self.b1_file_init()
        self.mama_list = []

    def gen_script(self):
        """ 生成全部sql脚本
        """
        # 前置操作：生成会员表
        self._wr_sql(template_c.tl_pre_001)

        # 基础表生成
        self.b2_base_gen(template_c.DISPLAY_FIELDS)

        # 直接写SQL：生成医生偏好所需的几张表
        self._wr_sql(template_c.tl_doctor_002)

        # 直接写SQL：生成首次购买产品所需临时表
        self._wr_sql(template_c.tl_first_buy_003)

        # 合并数据到此结束
        exit()

        # 标签逻辑
        self._wr_big_comment('标签逻辑-标签表')

        # 一级标签 身份特征
        self._wr_mid_comment('一级标签 身份特征')

        # 性别
        base_conf = {
            'tag_cn_name': '性别',
            'tag_field_name': 'gender',
            'table_join': 'member_patient_info',
            'table_join_field': 'sex',
            'case_default': '0',
        }
        when_conf = {
            '1': '男',
            '2': '女',
        }
        self.b_1301_tag_type1_case_map(base_conf, when_conf)

        # 过程值：月龄
        base_conf = {
            'tag_cn_name': '过程值：月龄',
            'tag_field_name': 'age_months',
            'tag_field_type': 'int(10)',
            'tag_field_default': '-1',
            'table_join': 'member_patient_info',
            'tag_value': 'TIMESTAMPDIFF(MONTH, member_patient_info.birthday, CURDATE())',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 年龄
        base_conf = {
            'tag_cn_name': '年龄',
            'tag_field_name': 'age',
            'table_join': 'u_mid_12',
            'table_join_field': 'age_months',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '3'],
            '2': ['4', '6'],
            '3': ['7', '12'],
            '4': ['13', '18'],
            '5': ['19', '24'],
            '6': ['25', '36'],
            '7': ['37', '48'],
            '8': ['49', '60'],
            '9': ['61', '72'],
            '10': ['73', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：南海店次数
        base_conf = {
            'tag_cn_name': '南海店次数',
            'tag_field_name': 'store_wanda_time',
            'tag_field_type': 'int(8)',
            'tag_field_default': '0',
            'table_join': 'interview_info',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "interview_info.store = '南海'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：高德店次数
        base_conf = {
            'tag_cn_name': '高德店次数',
            'tag_field_name': 'store_gaode_time',
            'tag_field_type': 'int(8)',
            'tag_field_default': '0',
            'table_join': 'interview_info',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "interview_info.store = '高德'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 门店偏好-数据缺失
        base_conf = {
            'tag_cn_name': '门店偏好-数据缺失',
            'tag_field_name': 'store_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'u_mid_12',
            'tag_value': '1',
            'where_str': 'u_mid_12.store_wanda_time = 0 and u_mid_12.store_gaode_time = 0',
        }
        self.b_2001_tag_type1_where(base_conf)

        # 门店偏好-广州高德
        base_conf = {
            'tag_cn_name': '门店偏好-广州高德',
            'tag_field_name': 'store_1',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'u_mid_12',
            'tag_value': '1',
            'where_str': 'u_mid_12.store_gaode_time > 0 and u_mid_12.store_gaode_time >= u_mid_12.store_wanda_time',
        }
        self.b_2001_tag_type1_where(base_conf)

        # 门店偏好-佛山南海万达
        base_conf = {
            'tag_cn_name': '门店偏好-佛山南海万达',
            'tag_field_name': 'store_2',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'u_mid_12',
            'tag_value': '1',
            'where_str': 'u_mid_12.store_wanda_time > 0 and u_mid_12.store_wanda_time >= u_mid_12.store_gaode_time',
        }
        self.b_2001_tag_type1_where(base_conf)

        # 会员类型-健康卡
        base_conf = {
            'tag_cn_name': '会员类型-健康卡',
            'tag_field_name': 'member_type_1',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'member_patient_info',
            'tag_value': '1',
            'where_str': "member_patient_info.member_type_from_member like '%折%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 会员类型-签约
        base_conf = {
            'tag_cn_name': '会员类型-签约',
            'tag_field_name': 'member_type_2',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'sign_card_manage',
            'tag_value': '1',
            'where_str': "sign_card_manage.expire >= CURDATE()",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 会员类型-2次卡
        base_conf = {
            'tag_cn_name': '会员类型-2次卡',
            'tag_field_name': 'member_type_3',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'member_patient_info',
            'tag_value': '1',
            'where_str': "member_patient_info.member_type_from_member like '%2次%'" +
                         " or member_patient_info.member_type_from_member like '%两次%'" +
                         " or member_patient_info.member_type_from_member like '%双次%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 会员类型-5次卡
        base_conf = {
            'tag_cn_name': '会员类型-5次卡',
            'tag_field_name': 'member_type_4',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'member_patient_info',
            'tag_value': '1',
            'where_str': "member_patient_info.member_type_from_member like '%5次%'" +
                         " or member_patient_info.member_type_from_member like '%五次%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 会员类型-其他次卡
        base_conf = {
            'tag_cn_name': '会员类型-其他次卡',
            'tag_field_name': 'member_type_5',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'member_patient_info',
            'tag_value': '1',
            'where_str': "member_patient_info.member_type_from_member like '%次%'\n" +
                         " and not (member_patient_info.member_type_from_member like '%无限次%')\n" +
                         " and not (member_patient_info.member_type_from_member like '%不限次%')\n" +
                         " and not (member_patient_info.member_type_from_member like '%2次%')\n" +
                         " and not (member_patient_info.member_type_from_member like '%两次%')\n" +
                         " and not (member_patient_info.member_type_from_member like '%双次%')\n" +
                         " and not (member_patient_info.member_type_from_member like '%5次%')\n" +
                         " and not (member_patient_info.member_type_from_member like '%五次%')",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 会员类型-齿科套餐
        base_conf = {
            'tag_cn_name': '会员类型-齿科套餐',
            'tag_field_name': 'member_type_6',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'member_patient_info',
            'tag_value': '1',
            'where_str': "member_patient_info.member_type_from_member like '%齿科套餐%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 会员类型-普通客户
        where_str = ' and '.join(['t_u_member_type_' + str(i) + ' = 0'
                                  for i in range(1, 7)])
        base_conf = {
            'tag_cn_name': '会员类型-普通客户',
            'tag_field_name': 'member_type_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 首次购买产品
        base_conf = {
            'tag_cn_name': '首次购买产品',
            'tag_field_name': 'first_order',
            'table_join': 't_all_card_manage',
            'case_default': '0',
        }
        when_conf = {
            '1': "t_all_card_manage.table_type = '充值管理表'",
            '2': "t_all_card_manage.table_type = '签约管理表'",
            '3': "t_all_card_manage.table_type = '次卡管理表'" +
                 " and (t_all_card_manage.card_type like '%2次%'" +
                 " or t_all_card_manage.card_type like '%两次%'" +
                 " or t_all_card_manage.card_type like '%双次%')",
            '4': "t_all_card_manage.table_type = '次卡管理表'" +
                 " and (t_all_card_manage.card_type like '%5次%'" +
                 " or t_all_card_manage.card_type like '%五次%')",
            '5': "t_all_card_manage.table_type = '次卡管理表'",
            '6': "t_all_card_manage.table_type = '齿科套餐管理表'",
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 来源
        base_conf = {
            'tag_cn_name': '来源',
            'tag_field_name': 'source',
            'table_join': 'new_costumer_list',
            'case_default': '13',
        }
        when_conf = {
            '0': "new_costumer_list.source_type is null" +
                 " or new_costumer_list.source_type = ''",
            '1': "new_costumer_list.source_type like '%朋友%'" +
                 " or new_costumer_list.source_type like '%杨思达%'" +
                 " or new_costumer_list.source_type like '%黄映纯%'",
            '2': "new_costumer_list.source_type like '%公众号%'" +
                 " and new_costumer_list.source_type not like '%天爱%'" +
                 " and new_costumer_list.source_type not like '%培儿屋%'",
            '3': "new_costumer_list.source_type like '%群%'",
            '4': "new_costumer_list.source_type like '%培儿屋%'",
            '5': "new_costumer_list.source_type like '%月子中心%'" +
                 " or new_costumer_list.source_type like '%宝媛会%'",
            '6': "new_costumer_list.source_type like '%第三方平台%'" +
                 " or new_costumer_list.source_type like '%大众点评%'",
            '7': "new_costumer_list.source_type like '%渠道合作%'",
            '8': "new_costumer_list.source_type like '%早教中心%'",
            '9': "new_costumer_list.source_type like '%医护人员推荐%'",
            '10': "new_costumer_list.source_type like '%天爱%'",
            '11': "new_costumer_list.source_type like '%外部推广%'",
            '12': "new_costumer_list.source_type like '%微信%'" +
                  " and new_costumer_list.source_type not like '%群%'" +
                  " and new_costumer_list.source_type not like '%公众号%'",
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 过程值：最后购买日期，计算购买周期用：最后一次购买和倒数第二次购买的时间差
        base_conf = {
            'tag_cn_name': '最后购买日期',
            'tag_field_name': 'last_buy',
            'tag_field_type': 'date',
            'tag_field_default': 'null',
            'table_join': 'test_sales_summary',
            'table_join_field': 'test_sales_summary.buy_date',
            'agg_func': 'max',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：最后一次购买日期距今天数
        base_conf = {
            'tag_cn_name': '过程值：最后一次购买日期距今天数',
            'tag_field_name': 'last_buy',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': 'TIMESTAMPDIFF(DAY, last_buy, CURDATE())',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 首次到店
        base_conf = {
            'tag_cn_name': '首次到店',
            'tag_field_name': 'first_buy',
            'table_join': 'u_mid_12',
            'table_join_field': 'first_buy_days',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '7'],
            '2': ['8', '15'],
            '3': ['16', '30'],
            '4': ['31', '60'],
            '5': ['61', '90'],
            '6': ['91', '180'],
            '7': ['181', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 签约类型-白金卡
        base_conf = {
            'tag_cn_name': '签约类型-白金卡',
            'tag_field_name': 'sign_type_1',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'sign_card_manage',
            'tag_value': '1',
            'where_str': "sign_card_manage.card_type like '%白金卡%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 签约类型-金卡
        base_conf = {
            'tag_cn_name': '签约类型-金卡',
            'tag_field_name': 'sign_type_2',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'sign_card_manage',
            'tag_value': '1',
            'where_str': "sign_card_manage.card_type like '%金卡%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 签约类型-钻石卡
        base_conf = {
            'tag_cn_name': '签约类型-钻石卡',
            'tag_field_name': 'sign_type_3',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'sign_card_manage',
            'tag_value': '1',
            'where_str': "sign_card_manage.card_type like '%钻石卡%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 签约类型-体验卡
        base_conf = {
            'tag_cn_name': '签约类型-体验卡',
            'tag_field_name': 'sign_type_4',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'sign_card_manage',
            'tag_value': '1',
            'where_str': "sign_card_manage.card_type like '%体验卡%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 签约类型-旧套餐无限次卡
        base_conf = {
            'tag_cn_name': '签约类型-旧套餐无限次卡',
            'tag_field_name': 'sign_type_5',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'sign_card_manage',
            'tag_value': '1',
            'where_str': "sign_card_manage.card_type like '%1年儿童无忧卡%'\n" +
                         " or sign_card_manage.card_type like '%1年婴儿无忧卡（0-1岁）%'\n" +
                         " or sign_card_manage.card_type like '%儿保套餐（两年）%'\n" +
                         " or sign_card_manage.card_type like '%儿保套餐（一年）%'\n" +
                         " or sign_card_manage.card_type like '%新生儿套餐%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 签约类型-线上3650
        base_conf = {
            'tag_cn_name': '签约类型-线上3650',
            'tag_field_name': 'sign_type_6',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'sign_card_manage',
            'tag_value': '1',
            'where_str': "sign_card_manage.card_type like '%3650%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 签约类型-南海6888
        base_conf = {
            'tag_cn_name': '签约类型-南海6888',
            'tag_field_name': 'sign_type_7',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'sign_card_manage',
            'tag_value': '1',
            'where_str': "sign_card_manage.card_type like '%6888%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 签约类型-线上线下8688
        base_conf = {
            'tag_cn_name': '签约类型-线上线下8688',
            'tag_field_name': 'sign_type_8',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'sign_card_manage',
            'tag_value': '1',
            'where_str': "sign_card_manage.card_type like '%8688%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 签约类型-缺失
        where_str = ' and '.join(['t_u_sign_type_' + str(i) + ' = 0'
                                  for i in range(1, 9)])
        base_conf = {
            'tag_cn_name': '签约类型-缺失',
            'tag_field_name': 'sign_type_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 次卡类别--2次卡
        base_conf = {
            'tag_cn_name': '次卡类别--2次卡',
            'tag_field_name': 'times_type_1',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'time_card_manage',
            'tag_value': '1',
            'where_str': "time_card_manage.card_type like '%2次卡%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 次卡类别--3次卡
        base_conf = {
            'tag_cn_name': '次卡类别--3次卡',
            'tag_field_name': 'times_type_2',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'time_card_manage',
            'tag_value': '1',
            'where_str': "time_card_manage.card_type like '%3次卡%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 次卡类别--5次卡
        base_conf = {
            'tag_cn_name': '次卡类别--5次卡',
            'tag_field_name': 'times_type_3',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'time_card_manage',
            'tag_value': '1',
            'where_str': "time_card_manage.card_type like '%5次卡%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 次卡类别--其他次卡
        base_conf = {
            'tag_cn_name': '次卡类别--其他次卡',
            'tag_field_name': 'times_type_4',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'time_card_manage',
            'tag_value': '1',
            'where_str': "time_card_manage.card_type not like '%2次卡%'\n" +
                         " or time_card_manage.card_type not like '%3次卡%'\n" +
                         " or time_card_manage.card_type not like '%5次卡%'\n" +
                         " or time_card_manage.card_type is not null",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 次卡类别-缺失
        where_str = ' and '.join(['t_u_times_type_' + str(i) + ' = 0'
                                  for i in range(1, 5)])
        base_conf = {
            'tag_cn_name': '次卡类别-缺失',
            'tag_field_name': 'times_type_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 齿科套餐类型--0-5岁套餐
        base_conf = {
            'tag_cn_name': '齿科套餐类型--0-5岁套餐',
            'tag_field_name': 'teeth_type_1',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'teeth_card_manage',
            'tag_value': '1',
            'where_str': "teeth_card_manage.card_type like '%0-5岁套餐%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 齿科套餐类型--6-12岁套餐
        base_conf = {
            'tag_cn_name': '齿科套餐类型--6-12岁套餐',
            'tag_field_name': 'teeth_type_2',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'teeth_card_manage',
            'tag_value': '1',
            'where_str': "teeth_card_manage.card_type like '%6-12岁套餐%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 齿科套餐类型--0-12岁套餐
        base_conf = {
            'tag_cn_name': '齿科套餐类型--0-12岁套餐',
            'tag_field_name': 'teeth_type_3',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'teeth_card_manage',
            'tag_value': '1',
            'where_str': "teeth_card_manage.card_type like '%0-12岁套餐%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 齿科套餐类型--家庭齿科医生服务
        base_conf = {
            'tag_cn_name': '齿科套餐类型--家庭齿科医生服务',
            'tag_field_name': 'teeth_type_4',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'teeth_card_manage',
            'tag_value': '1',
            'where_str': "teeth_card_manage.card_type like '%家庭齿科医生服务%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 齿科套餐类型--家庭齿科D套餐
        base_conf = {
            'tag_cn_name': '齿科套餐类型--家庭齿科D套餐',
            'tag_field_name': 'teeth_type_5',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'teeth_card_manage',
            'tag_value': '1',
            'where_str': "teeth_card_manage.card_type like '%家庭齿科D套餐%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 齿科套餐类型--家庭齿科E套餐
        base_conf = {
            'tag_cn_name': '齿科套餐类型--家庭齿科E套餐',
            'tag_field_name': 'teeth_type_6',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'teeth_card_manage',
            'tag_value': '1',
            'where_str': "teeth_card_manage.card_type like '%家庭齿科E套餐%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 齿科套餐类型-缺失
        where_str = ' and '.join(['t_u_teeth_type_' + str(i) + ' = 0'
                                  for i in range(1, 7)])
        base_conf = {
            'tag_cn_name': '齿科套餐类型-缺失',
            'tag_field_name': 'teeth_type_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 当前是否为有效健康卡客户--是
        base_conf = {
            'tag_cn_name': '当前是否为有效健康卡客户--是',
            'tag_field_name': 'health_card_1',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'member_patient_info',
            'tag_value': '1',
            'where_str': "member_patient_info.member_type_from_patient like '%折%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 当前是否为有效健康卡客户--否
        base_conf = {
            'tag_cn_name': '当前是否为有效健康卡客户--否',
            'tag_field_name': 'health_card_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'member_patient_info',
            'tag_value': '1',
            'where_str': "member_patient_info.member_type_from_patient not like '%折%'",
        }
        self.b_2001_tag_type1_where(base_conf)


        # 过程值：套餐有效期距今天数
        base_conf = {
            'tag_cn_name': '过程值：套餐有效期距今天数',
            'tag_field_name': 'expire_days',
            'tag_field_type': 'int(5)',
            'tag_field_default': 'null',
            'table_join': 'sign_card_manage',
            'tag_value': 'TIMESTAMPDIFF(DAY, CURDATE(), sign_card_manage.expire)',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 签约到期
        base_conf = {
            'tag_cn_name': '签约到期',
            'tag_field_name': 'expire',
            'table_join': 'u_mid_12',
            'table_join_field': 'expire_days',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '0'],
            '2': ['1', '5'],
            '3': ['6', '15'],
            '4': ['16', '30'],
            '5': ['31', '60'],
            '6': ['61', '90'],
            '7': ['91', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 健康卡余额
        base_conf = {
            'tag_cn_name': '健康卡余额',
            'tag_field_name': 'balance',
            'table_join': 'member_patient_info',
            'table_join_field': 'blance',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '500'],
            '2': ['501', '1000'],
            '3': ['1001', '2000'],
            '4': ['2001', '3000'],
            '5': ['3001', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 一级标签 行为特征
        self._wr_mid_comment('一级标签 行为特征')

        # 过程值：近一年到店次数
        base_conf = {
            'tag_cn_name': '近一年到店次数',
            'tag_field_name': 'year_times',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'interview_info',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'interview_info.interview_date >= date_sub(CURDATE(),interval 1 year)',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：近一年到店计入月数
        base_conf = {
            'tag_cn_name': '过程值：近一年到店计入月数',
            'tag_field_name': 'year_months',
            'tag_field_type': 'decimal(7,5)',
            'tag_field_default': '0.0',
            'case_default': 'datediff(CURDATE(),first_buy)/30',
        }
        when_conf = {
            '99': 'first_buy is null',
            '12.0': 'first_buy < date_sub(CURDATE(),interval 1 year)',
            '1': 'first_buy > date_sub(CURDATE(),interval 1 month)',
        }
        self.b_1202_mid_type1_case_where_else(base_conf, when_conf)


        # 近一年到店频率
        base_conf = {
            'tag_cn_name': '近一年到店频率',
            'tag_field_name': 'year_frequency',
            'table_join': 'u_mid_12',
            'table_join_field': 'year_times',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '0'],
            '2': ['1', '3'],
            '3': ['4', '6'],
            '4': ['7', '9'],
            '5': ['10', '12'],
            '6': ['13', '18'],
            '7': ['19', '24'],
            '8': ['24', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：近半年到店次数
        base_conf = {
            'tag_cn_name': '近半年到店次数',
            'tag_field_name': 'half_year_times',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'interview_info',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'interview_info.interview_date >= date_sub(CURDATE(),interval 6 month)',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 近半年到店频率
        base_conf = {
            'tag_cn_name': '近半年到店频率',
            'tag_field_name': 'half_year_frequency',
            'table_join': 'u_mid_12',
            'table_join_field': 'half_year_times',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '0'],
            '2': ['1', '3'],
            '3': ['4', '6'],
            '4': ['7', '9'],
            '5': ['10', '12'],
            '6': ['12', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：总到店次数
        base_conf = {
            'tag_cn_name': '总到店次数',
            'tag_field_name': 'times_total',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'interview_info',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 总到店次数
        base_conf = {
            'tag_cn_name': '总到店次数',
            'tag_field_name': 'times_total',
            'table_join': 'u_mid_12',
            'table_join_field': 'times_total',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '0'],
            '2': ['1', '3'],
            '3': ['4', '6'],
            '4': ['7', '12'],
            '5': ['13', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：儿童保健次数
        base_conf = {
            'tag_cn_name': '儿童保健次数',
            'tag_field_name': 'times_erbao',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'interview_info',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "interview_info.sign_department like '%儿童保健%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 儿童保健次数
        base_conf = {
            'tag_cn_name': '儿童保健次数',
            'tag_field_name': 'times_erbao',
            'table_join': 'u_mid_12',
            'table_join_field': 'times_erbao',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '0'],
            '2': ['1', '3'],
            '3': ['4', '6'],
            '4': ['7', '12'],
            '5': ['13', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：儿童全科次数
        base_conf = {
            'tag_cn_name': '儿童全科次数',
            'tag_field_name': 'times_quanke',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'interview_info',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "interview_info.sign_department like '%儿童全科%'\n" +
                        " or interview_info.sign_department like '%儿科全科门诊%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 儿童全科次数
        base_conf = {
            'tag_cn_name': '儿童全科次数',
            'tag_field_name': 'times_quanke',
            'table_join': 'u_mid_12',
            'table_join_field': 'times_quanke',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '0'],
            '2': ['1', '3'],
            '3': ['4', '6'],
            '4': ['7', '12'],
            '5': ['13', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：儿童齿科次数
        base_conf = {
            'tag_cn_name': '儿童齿科次数',
            'tag_field_name': 'times_chike',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'interview_info',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "interview_info.sign_department like '%儿童齿科%'\n" +
                         " or interview_info.sign_department like '%儿童洁牙%'\n" +
                         " or interview_info.sign_department like '%涂氟%'\n" +
                         " or interview_info.sign_department like '%儿童口腔科%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 儿童齿科次数
        base_conf = {
            'tag_cn_name': '儿童齿科次数',
            'tag_field_name': 'times_chike',
            'table_join': 'u_mid_12',
            'table_join_field': 'times_chike',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '0'],
            '2': ['1', '3'],
            '3': ['4', '6'],
            '4': ['7', '12'],
            '5': ['13', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：儿童专科次数
        base_conf = {
            'tag_cn_name': '儿童专科次数',
            'tag_field_name': 'times_zhuanke',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'interview_info',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "interview_info.sign_department is not null and interview_info.sign_department !=''\n" +
                         " and interview_info.sign_department not like '%儿童保健%'\n" +
                         " and interview_info.sign_department not like '%儿童口腔%'\n" +
                         " and interview_info.sign_department not like '%儿童全科%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 儿童专科次数
        base_conf = {
            'tag_cn_name': '儿童专科次数',
            'tag_field_name': 'times_zhuanke',
            'table_join': 'u_mid_12',
            'table_join_field': 'times_zhuanke',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '0'],
            '2': ['1', '3'],
            '3': ['4', '6'],
            '4': ['7', '12'],
            '5': ['13', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值:累计充值金额
        base_conf = {
            'tag_cn_name': '累计充值金额',
            'tag_field_name': 'total_recharge',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'time_card_manage',
            'table_join_field': 'time_card_manage.price',
            'agg_func': 'sum',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 累计充值金额
        base_conf = {
            'tag_cn_name': '累计充值金额',
            'tag_field_name': 'total_recharge',
            'table_join': 'u_mid_12',
            'table_join_field': 'total_recharge',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '0'],
            '2': ['1', '3000'],
            '3': ['3001', '5000'],
            '4': ['5001', '10000'],
            '5': ['10001', '15000'],
            '6': ['15001', '20000'],
            '7': ['20001', '25000'],
            '8': ['25001', '30000'],
            '9': ['30001', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：累计充值次数
        base_conf = {
            'tag_cn_name': '累计充值次数',
            'tag_field_name': 'total_recharge_times',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'time_card_manage',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "true",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 累计充值次数
        base_conf = {
            'tag_cn_name': '累计充值次数',
            'tag_field_name': 'total_recharge_times',
            'table_join': 'u_mid_12',
            'table_join_field': 'total_recharge_times',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '0'],
            '2': ['1', '1'],
            '3': ['2', '2'],
            '4': ['3', '3'],
            '5': ['4', '4'],
            '6': ['5', '5'],
            '7': ['6', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：近半年充值次数
        base_conf = {
            'tag_cn_name': '近半年充值次数',
            'tag_field_name': 'half_year_recharge_times',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'time_card_manage',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "time_card_manage.buy_date >= date_sub(CURDATE(),interval 6 month)",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 近半年充值次数
        base_conf = {
            'tag_cn_name': '近半年充值次数',
            'tag_field_name': 'half_year_recharge_times',
            'table_join': 'u_mid_12',
            'table_join_field': 'half_year_recharge_times',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '0'],
            '2': ['1', '1'],
            '3': ['2', '2'],
            '4': ['3', '3'],
            '5': ['4', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：近1年充值次数
        base_conf = {
            'tag_cn_name': '近1年充值次数',
            'tag_field_name': 'year_recharge_times',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'time_card_manage',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "time_card_manage.buy_date >= date_sub(CURDATE(),interval 1 year)",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 近1年充值次数
        base_conf = {
            'tag_cn_name': '近1年充值次数',
            'tag_field_name': 'year_recharge_times',
            'table_join': 'u_mid_12',
            'table_join_field': 'year_recharge_times',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '0'],
            '2': ['1', '1'],
            '3': ['2', '2'],
            '4': ['3', '3'],
            '5': ['4', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 参与历史营销活动-2018-2019年终大促
        base_conf = {
            'tag_cn_name': '参与历史营销活动-2018-2019年终大促',
            'tag_field_name': 'promotion_1',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'promotion_sale_report',
            'tag_value': '1',
            'where_str': "promotion_sale_report.buy_product like '%充值5000%'" +
                         " or promotion_sale_report.buy_product like '%充值8000%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 参与历史营销活动-2019店庆
        base_conf = {
            'tag_cn_name': '参与历史营销活动-2019店庆',
            'tag_field_name': 'promotion_2',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'promotion_sale_report',
            'tag_value': '1',
            'where_str': "promotion_sale_report.phone is not null",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 参与历史营销活动-2019年妈网5/6月活动
        base_conf = {
            'tag_cn_name': '参与历史营销活动-2019年妈网5/6月活动',
            'tag_field_name': 'promotion_3',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'member_mama_5_6',
            'tag_value': '1',
            'where_str': "member_mama_5_6.phone is not null",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 参与历史营销活动-2019年妈网7/8月活动
        base_conf = {
            'tag_cn_name': '参与历史营销活动-2019年妈网7/8月活动',
            'tag_field_name': 'promotion_4',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'member_mama_7_8',
            'tag_value': '1',
            'where_str': "member_mama_7_8.phone is not null",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 参与历史营销活动-缺失
        where_str = ' and '.join(['t_u_promotion_' + str(i) + ' = 0'
                                  for i in range(1, 5)])
        base_conf = {
            'tag_cn_name': '参与历史营销活动-缺失',
            'tag_field_name': 'promotion_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 一级标签 就诊信息偏好
        self._wr_mid_comment('一级标签 就诊信息偏好')

        # 科室偏好-儿童保健
        base_conf = {
            'tag_cn_name': '科室偏好-儿童保健',
            'tag_field_name': 'dept_preference_1',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'u_mid_12',
            'tag_value': '1',
            'where_str': "u_mid_12.age_months < 24 and u_mid_12.times_erbao >= 2",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 过程值：近一年到店次数-全科
        base_conf = {
            'tag_cn_name': '近一年到店次数-全科',
            'tag_field_name': 'year_times_quanke',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'interview_info',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'interview_info.interview_date >= date_sub(CURDATE(),interval 1 year)\n' +
                         " and (interview_info.sign_department like '%儿童全科%'\n" +
                        " or interview_info.sign_department like '%儿科全科门诊%')",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：近一年到店频率-全科
        base_conf = {
            'tag_cn_name': '过程值：近一年到店频率-全科',
            'tag_field_name': 'last_year_rate_quanke',
            'tag_field_type': 'decimal(12,3)',
            'tag_field_default': '0',
            'tag_value': 'year_times_quanke/year_months',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 科室偏好-儿童全科
        base_conf = {
            'tag_cn_name': '科室偏好-儿童全科',
            'tag_field_name': 'dept_preference_2',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'u_mid_12',
            'tag_value': '1',
            'where_str': "u_mid_12.last_year_rate_quanke >= 1",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 科室偏好-儿童齿科
        base_conf = {
            'tag_cn_name': '科室偏好-儿童齿科',
            'tag_field_name': 'dept_preference_3',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'u_mid_12',
            'tag_value': '1',
            'where_str': "u_mid_12.times_chike >= 3",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 过程值：近一年到店次数-专科
        base_conf = {
            'tag_cn_name': '近一年到店次数-专科',
            'tag_field_name': 'year_times_zhuanke',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'interview_info',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'interview_info.interview_date >= date_sub(CURDATE(),interval 1 year)\n' +
                         " and interview_info.sign_department is not null and interview_info.sign_department !=''\n" +
                         " and interview_info.sign_department not like '%儿童保健%'\n" +
                         " and interview_info.sign_department not like '%儿童口腔%'\n" +
                         " and interview_info.sign_department not like '%儿童全科%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：近一年到店频率-专科
        base_conf = {
            'tag_cn_name': '过程值：近一年到店频率-全科',
            'tag_field_name': 'last_year_rate_zhuanke',
            'tag_field_type': 'decimal(12,3)',
            'tag_field_default': '0',
            'tag_value': 'year_times_zhuanke/year_months',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 科室偏好-儿童专科
        base_conf = {
            'tag_cn_name': '科室偏好-儿童专科',
            'tag_field_name': 'dept_preference_4',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'u_mid_12',
            'tag_value': '1',
            'where_str': "u_mid_12.last_year_rate_zhuanke >= 0.75",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 科室偏好-无明显偏好
        base_conf = {
            'tag_cn_name': '科室偏好-无明显偏好',
            'tag_field_name': 'dept_preference_5',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'u_mid_12',
            'tag_value': '1',
            'where_str': "(u_mid_12.times_erbao >= 1 or u_mid_12.times_quanke >= 1\n" +
                         " or u_mid_12.times_chike >= 1 or u_mid_12.times_zhuanke >= 1)\n" +
                         " and u_tag_12.t_u_dept_preference_1 = 0 and u_tag_12.t_u_dept_preference_2 = 0\n" +
                         " and u_tag_12.t_u_dept_preference_3 = 0 and u_tag_12.t_u_dept_preference_4 = 0\n",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 科室偏好-缺失
        where_str = ' and '.join(['t_u_dept_preference_' + str(i) + ' = 0'
                                  for i in range(1, 6)])
        base_conf = {
            'tag_cn_name': '科室偏好-缺失',
            'tag_field_name': 'dept_preference_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 过程值：接诊，儿科医生偏好
        doctors = ['古锐', '肖雪', '梁妤婷', '李莉', '贺亮', '朱晓华', '张庭艳']
        for idx, doctor in enumerate(doctors):
            base_conf = {
                'tag_cn_name': '过程值：接诊，儿科医生偏好-' + doctor,
                'tag_field_name': 'erke_doctor_pref_' + str(idx+1),
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 't_iv_erke_doctor',
                'tag_value': '1',
                'where_str': "t_iv_erke_doctor.doctor = '" + doctor + "'",
            }
            self.b_2002_mid_type1_where(base_conf)

        # 儿科医生偏好
        doctors_list = [['古锐', '古医生', '古医生M'],
                        ['肖雪', '肖医生', '肖医生M'],
                        ['梁妤婷', '梁医生', '梁医生M'],
                        ['李莉', '李医生'],
                        ['贺亮', '贺医生'],
                        ['朱晓华', '朱医生'],
                        ['张庭艳', '张医生'],
                        ]
        for idx, doctors in enumerate(doctors_list):
            # 儿科医生偏好
            where_str = ' or '.join([("sign_card_manage.sign_doctor = '" + doctor + "'") for doctor in doctors])
            base_conf = {
                'tag_cn_name': '儿科医生偏好-' + doctors[0],
                'tag_field_name': 'doctor_preference_erke_' + str(idx+1),
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': ['sign_card_manage', 'u_mid_12'],
                'tag_value': '1',
                'where_str': '(' + where_str + ')\n' +
                             " or ((u_mid_12.times_erbao + u_mid_12.times_quanke) > 2" +
                             " and u_mid_12.erke_doctor_pref_" + str(idx+1) + " = 1)",
            }
            self.b_2001_tag_type1_where(base_conf)

        # 儿科医生偏好-缺失
        doctors = ['古锐', '肖雪', '梁妤婷', '李莉', '贺亮', '朱晓华', '张庭艳']
        where_str = ' and '.join([("u_mid_12.erke_doctor_pref_" + str(i + 1) + " = 0")
                                 for i in range(0, len(doctors))])
        base_conf = {
            'tag_cn_name': '儿科医生偏好-缺失',
            'tag_field_name': 'doctor_preference_erke_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': ['sign_card_manage', 'u_mid_12'],
            'tag_value': '1',
            'where_str': '(' + where_str + ')\n' +
                         " and sign_card_manage.sign_doctor is null",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 儿科医生偏好-无偏好
        where_str = ' and '.join(['t_u_doctor_preference_erke_' + str(i) + ' = 0'
                                  for i in range(0, 8)])
        base_conf = {
            'tag_cn_name': '儿科医生偏好-无偏好',
            'tag_field_name': 'doctor_preference_erke_8',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 过程值：接诊，齿科医生偏好
        doctors = ['张栋杰', '申丽妮', '庾佩芬']
        for idx, doctor in enumerate(doctors):
            base_conf = {
                'tag_cn_name': '过程值：接诊，齿科医生偏好-' + doctor,
                'tag_field_name': 'chike_doctor_pref_' + str(idx+1),
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 't_iv_chike_doctor',
                'tag_value': '1',
                'where_str': "t_iv_chike_doctor.doctor = '" + doctor + "'",
            }
            self.b_2002_mid_type1_where(base_conf)

        # 齿科医生偏好
        for idx, doctor in enumerate(doctors):
            # 齿科医生偏好
            base_conf = {
                'tag_cn_name': '齿科医生偏好-' + doctor,
                'tag_field_name': 'doctor_preference_chike_' + str(idx+1),
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 'u_mid_12',
                'tag_value': '1',
                'where_str': "u_mid_12.times_chike > 2" +
                             " and u_mid_12.chike_doctor_pref_" + str(idx+1) + " = 1",
            }
            self.b_2001_tag_type1_where(base_conf)

        # 齿科医生偏好-缺失
        where_str = ' and '.join([("u_mid_12.chike_doctor_pref_" + str(i + 1) + " = 0")
                                 for i in range(0, len(doctors))])
        base_conf = {
            'tag_cn_name': '齿科医生偏好-缺失',
            'tag_field_name': 'doctor_preference_chike_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': ['sign_card_manage', 'u_mid_12'],
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 齿科医生偏好-无偏好
        where_str = ' and '.join(['t_u_doctor_preference_chike_' + str(i) + ' = 0'
                                  for i in range(0, 4)])
        base_conf = {
            'tag_cn_name': '齿科医生偏好-无偏好',
            'tag_field_name': 'doctor_preference_chike_4',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 过程值：接诊，专科医生偏好
        doctors = ['王小亚', '王弘', '翟莺莺', '陈亦阳', '龙秀胜', '郭梦翔', '罗育武', '陶佳',
                   '喻宁芬', '王馨', '王建勋', '崔咏怡']
        for idx, doctor in enumerate(doctors):
            base_conf = {
                'tag_cn_name': '过程值：接诊，专科医生偏好-' + doctor,
                'tag_field_name': 'zhuanke_doctor_pref_' + str(idx+1),
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 't_iv_zhuanke_doctor',
                'tag_value': '1',
                'where_str': "t_iv_zhuanke_doctor.doctor = '" + doctor + "'",
            }
            self.b_2002_mid_type1_where(base_conf)

        # 专科医生偏好
        for idx, doctor in enumerate(doctors):
            # 专科医生偏好
            base_conf = {
                'tag_cn_name': '专科医生偏好-' + doctor,
                'tag_field_name': 'doctor_preference_zhuanke_' + str(idx+1),
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 'u_mid_12',
                'tag_value': '1',
                'where_str': "u_mid_12.times_zhuanke > 2" +
                             " and u_mid_12.zhuanke_doctor_pref_" + str(idx+1) + " = 1",
            }
            self.b_2001_tag_type1_where(base_conf)

        # 专科医生偏好-缺失
        where_str = ' and '.join([("u_mid_12.zhuanke_doctor_pref_" + str(i + 1) + " = 0")
                                 for i in range(0, len(doctors))])
        base_conf = {
            'tag_cn_name': '专科医生偏好-缺失',
            'tag_field_name': 'doctor_preference_zhuanke_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': ['sign_card_manage', 'u_mid_12'],
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 专科医生偏好-无偏好
        where_str = ' and '.join(['t_u_doctor_preference_zhuanke_' + str(i) + ' = 0'
                                  for i in range(0, 13)])
        base_conf = {
            'tag_cn_name': '专科医生偏好-无偏好',
            'tag_field_name': 'doctor_preference_zhuanke_13',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 过程值：日龄
        base_conf = {
            'tag_cn_name': '过程值：日龄',
            'tag_field_name': 'age_days',
            'tag_field_type': 'int(10)',
            'tag_field_default': '-1',
            'table_join': 'member_patient_info',
            'tag_value': 'TIMESTAMPDIFF(DAY, member_patient_info.birthday, CURDATE())',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 儿保提醒
        base_conf = {
            'tag_cn_name': '儿保提醒',
            'tag_field_name': 'care_remind',
            'table_join': 'u_mid_12',
            'table_join_field': 'age_days',
            'case_default': '0',
        }
        when_conf = {
            '1': ['54', '67'],
            '2': ['84', '97'],
            '3': ['114', '127'],
            '4': ['144', '157'],
            '5': ['174', '187'],
            '6': ['266', '285'],
            '7': ['351', '380'],
            '8': ['436', '465'],
            '9': ['526', '555'],
            '10': ['716', '745'],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 下载表生成
        self._wr_big_comment('下载表生成')
        self.b7_dld_gen()


    def read_mama_file(self):
        """ 读标妈妈网推广
        :type tables:
        :param tables:
        :rtype: list
        :return: 标签值表中内容载入二维list
        """
        # 读取文件
        with open(self.mama_file_path, 'r', encoding='utf8') as f:
            for line in f.readlines():
                self.mama_list.append(line.strip('\n').split(','))
        print(self.mama_list)


        # 名单信息行结构化
        self.mama_attrs = []
        sqls = []
        for line in self.mama_list[1:]:

            mama_attrs = {'name': line[0],
                        'phone': line[1]}

            self.mama_attrs.append(mama_attrs)
            sql = "INSERT INTO `member_mama_7_8` (name, phone) VALUES ('" + line[0] + "','" + line[1] + "' );"
            sqls.append(sql)
        print(sqls)

        with open('../../outfile/t_mama_7-8_ins.sql', 'a+', encoding='utf8') as f:
            f.write('\n-- 妈妈网7-8月推广名单\n')
            for line in sqls:
                f.write(line + '\n')

if __name__ == "__main__":
    c12_config = {'file_path': template_c.TAG_FILE_PATH,
                  'custom_id': template_c.CUSTOM_ID,
                  'db_config': template_c.DB_CONFIG,
                  'tag_tb_name': template_c.TAG_TB_NAME,
                  'dld_tb_name': template_c.DLD_TB_NAME,
                  'mid_tb_name': template_c.MID_TB_NAME,
                  'member_key': template_c.MEMBER_KEY,
                  'table_relation': template_c.TABLE_RELATION,
                  'mama_file_path': template_c.MAMA_FILE_PATH,

                  }
    t = C12Prc(c12_config)
    # 生成标签信息
    #t.tag_info.tag_level_1_prc()
    #t.tag_info.tag_level_2_prc()
    #t.tag_info.tag_level_3_prc()
    #print("Finish: 生成标签信息")
    # 生成标签逻辑脚本
    t.gen_script()
    # t.read_mama_file()
    print("Finish")
