# coding: utf-8
# @Time    : 2019/5/11 20:41
# @Author  : zhongshan
# @Email   : 15926220700@139.com

from TagBase.tag_logic_prc import TagLogicPrc
from TagProc import template_c15 as template_c


class C15Prc(TagLogicPrc):
    """ 标签逻辑类
    客户C15的标签生成逻辑
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
            'table_join': 'member_info',
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
            'table_join': 'member_info',
            'tag_value': 'TIMESTAMPDIFF(YEAR, member_info.birthday, CURDATE())',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 年龄
        base_conf = {
            'tag_cn_name': '年龄',
            'tag_field_name': 'age',
            'table_join': 'u_mid_15',
            'table_join_field': 'age_year',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '17'],
            '2': ['18', '23'],
            '3': ['24', '27'],
            '4': ['28', '30'],
            '5': ['31', '35'],
            '6': ['36', '40'],
            '7': ['41', '45'],
            '8': ['46', '50'],
            '9': ['51', '55'],
            '10': ['56', '60'],
            '11': ['61', '65'],
            '12': ['66', '70'],
            '13': ['71', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 地址
        base_conf = {
            'tag_cn_name': '地址',
            'tag_field_name': 'address',
            'table_join': 'member_info',
            'case_default': '0',
        }
        when_conf = {
            '1':  "member_info.address like '%上海%'",
            '2':  "member_info.address like '%云南%'",
            '3':  "member_info.address like '%内蒙%'",
            '4':  "member_info.address like '%北京%'",
            '5':  "member_info.address like '%吉林%'",
            '6':  "member_info.address like '%四川%'",
            '7':  "member_info.address like '%天津%'",
            '8':  "member_info.address like '%宁夏%'",
            '9':  "member_info.address like '%安徽%'",
            '10': "member_info.address like '%山东%'",
            '11': "member_info.address like '%山西%'",
            '12': "member_info.address like '%广东%'",
            '13': "member_info.address like '%广西%'",
            '14': "member_info.address like '%新疆%'",
            '15': "member_info.address like '%江苏%'",
            '16': "member_info.address like '%江西%'",
            '17': "member_info.address like '%河北%'",
            '18': "member_info.address like '%河南%'",
            '19': "member_info.address like '%浙江%'",
            '20': "member_info.address like '%海南%'",
            '21': "member_info.address like '%湖北%'",
            '22': "member_info.address like '%湖南%'",
            '23': "member_info.address like '%甘肃%'",
            '24': "member_info.address like '%福建%'",
            '25': "member_info.address like '%西藏%'",
            '26': "member_info.address like '%贵州%'",
            '27': "member_info.address like '%辽宁%'",
            '28': "member_info.address like '%重庆%'",
            '29': "member_info.address like '%陕西%'",
            '30': "member_info.address like '%青海%'",
            '31': "member_info.address like '%黑龙江%'",
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 来源门店
        base_conf = {
            'tag_cn_name': '来源门店',
            'tag_field_name': 'store',
            'table_join': 'member_info',
            'table_join_field': 'store',
            'case_default': '0',
        }
        when_conf = {
            '1': '步行街店',
            '2': '东升店',
            '3': '六中店',
            '4': '东方店',
            '5': '长兴店',
        }
        self.b_1301_tag_type1_case_map(base_conf, when_conf)

        # 会员类型
        base_conf = {
            'tag_cn_name': '会员类型',
            'tag_field_name': 'member_type',
            'table_join': 'member_info',
            'table_join_field': 'member_level',
            'case_default': '0',
        }
        when_conf = {
            '1': '1',
            '2': '2',
            '3': '7',
            '4': '8',
            '5': '9',
        }
        self.b_1301_tag_type1_case_map(base_conf, when_conf)

        # 是否生日月
        base_conf = {
            'tag_cn_name': '是否生日月',
            'tag_field_name': 'birth_month',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'member_info',
            'tag_value': '1',
            'where_str': "month(member_info.birthday) =  month(now())",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 积分余额
        base_conf = {
            'tag_cn_name': '积分余额',
            'tag_field_name': 'point_balance',
            'table_join': 'member_info',
            'table_join_field': 'point',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '0'],
            '2': ['1', '200'],
            '3': ['201', '500'],
            '4': ['501', '800'],
            '5': ['801', '1000'],
            '6': ['1001', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 客户属性
        base_conf = {
            'tag_cn_name': '客户属性',
            'tag_field_name': 'customer_attr',
            'table_join': 'member_info',
            'case_default': '0',
        }
        when_conf = {
            '1':  "TIMESTAMPDIFF(DAY, member_info.register_date, CURDATE()) <= 90",
            '2':  "TIMESTAMPDIFF(DAY, member_info.register_date, CURDATE()) > 90",
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 过程值：12个月以内下单次数
        base_conf = {
            'tag_cn_name': '12个月以内下单次数',
            'tag_field_name': 'order_times_after12',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'order_list.order_time >= date_sub(date(now()),interval 12 month)',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：总下单次数
        base_conf = {
            'tag_cn_name': '总下单次数',
            'tag_field_name': 'order_times_total',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：消费金额总和
        base_conf = {
            'tag_cn_name': '消费金额总和',
            'tag_field_name': 'total_cost_value',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'order_list.amount',
            'agg_func': 'sum',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：首次到店日期
        base_conf = {
            'tag_cn_name': '首次到店日期',
            'tag_field_name': 'first_come_date',
            'tag_field_type': 'date',
            'tag_field_default': 'null',
            'table_join': 'order_list',
            'table_join_field': 'order_list.order_time',
            'agg_func': 'min',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：近一年到店计入月数
        base_conf = {
            'tag_cn_name': '过程值：近一年到店计入月数',
            'tag_field_name': 'last_year_interview_month',
            'tag_field_type': 'decimal(7,5)',
            'tag_field_default': '0.0',
            'case_default': 'datediff(date(now()),first_come_date)/30',
        }
        when_conf = {
            '99': 'first_come_date is null',
            '12.0': 'first_come_date < date_sub(date(now()),interval 1 year)',
            '1': 'first_come_date > date_sub(date(now()),interval 1 month)',
        }
        self.b_1202_mid_type1_case_where_else(base_conf, when_conf)

        # 过程值：近一年到店频率
        base_conf = {
            'tag_cn_name': '过程值：近一年到店频率',
            'tag_field_name': 'last_year_rate',
            'tag_field_type': 'decimal(12,3)',
            'tag_field_default': '0',
            'tag_value': 'order_times_after12/last_year_interview_month',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 近一年下单频率
        base_conf = {
            'tag_cn_name': '近一年下单频率',
            'tag_field_name': 'year_frequency',
            'table_join': 'u_mid_15',
            'table_join_field': 'last_year_rate',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '0.25'],
            '1': ['0.25', '0.5'],
            '2': ['0.5', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 总到店次数
        base_conf = {
            'tag_cn_name': '总到店次数',
            'tag_field_name': 'times_total',
            'table_join': 'u_mid_15',
            'table_join_field': 'order_times_total',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '0'],
            '2': ['1', '3'],
            '3': ['4', '6'],
            '4': ['7', '9'],
            '5': ['10', '12'],
            '6': ['13', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 消费金额总和
        base_conf = {
            'tag_cn_name': '消费金额总和',
            'tag_field_name': 'total_cost',
            'table_join': 'u_mid_15',
            'table_join_field': 'total_cost_value',
            'case_default': '0',
        }
        when_conf = {
            '1': ['1', '50'],
            '2': ['51', '100'],
            '3': ['101', '200'],
            '4': ['201', '500'],
            '5': ['501', '1000'],
            '6': ['1001', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：客单价
        base_conf = {
            'tag_cn_name': '过程值：客单价',
            'tag_field_name': 'per_customer_transaction',
            'tag_field_type': 'decimal(12,3)',
            'tag_field_default': '0',
            'tag_value': 'if(order_times_total = 0, 0, total_cost_value/order_times_total)',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 客单价
        base_conf = {
            'tag_cn_name': '客单价',
            'tag_field_name': 'pct',
            'table_join': 'u_mid_15',
            'table_join_field': 'per_customer_transaction',
            'case_default': '0',
        }
        when_conf = {
            '1': ['1', '50'],
            '2': ['51', '100'],
            '3': ['101', '200'],
            '4': ['201', '500'],
            '5': ['501', '1000'],
            '6': ['1001', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 门店偏好
        store_confs = {
            '1': '步行街',
            '2': '东升',
            '3': '六中',
            '4': '东方',
            '5': '长兴',
        }

        for idx, key in enumerate(list(store_confs.keys())):
            # 门店偏好
            base_conf = {
                'tag_cn_name': '门店偏好-' + store_confs[key],
                'tag_field_name': 'store_prefer_' + str(idx + 1),
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 'order_list',
                'tag_value': '1',
                'where_str': "order_list.store like '%" + store_confs[key] + "%'",
            }
            self.b_2001_tag_type1_where(base_conf)

        # 门店偏好-缺失
        where_str = ' and '.join(['t_u_store_prefer_' + str(i) + ' = 0'
                                  for i in range(1, 6)])
        base_conf = {
            'tag_cn_name': '门店偏好-缺失',
            'tag_field_name': 'store_prefer_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # OTC偏好
        store_confs = {
            '1': '滋补营养类',
            '2': '维生素矿物类',
            '3': '五官科类',
            '4': '骨伤科类',
            '5': '风湿镇痛类',
            '6': '抗感冒类',
            '7': '清热解毒类',
            '8': '止咳化痰类',
            '9': '消化系统类',
            '10': '外用药类',
            '11': '泌尿生殖系统类',
            '12': '妇科类',
            '13': '其他类',
        }

        for idx, key in enumerate(list(store_confs.keys())):
            # OTC偏好
            base_conf = {
                'tag_cn_name': 'OTC偏好-' + store_confs[key],
                'tag_field_name': 'preference_otc_' + str(idx + 1),
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 'product_info',
                'tag_value': '1',
                'where_str': "product_info.type_name like '%" + store_confs[key] + "%'",
            }
            self.b_2001_tag_type1_where(base_conf)

        # OTC偏好-缺失
        where_str = ' and '.join(['t_u_preference_otc_' + str(i) + ' = 0'
                                  for i in range(1, 14)])
        base_conf = {
            'tag_cn_name': 'OTC偏好-缺失',
            'tag_field_name': 'preference_otc_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # RX偏好
        store_confs = {
            '1': '滋补营养类',
            '2': '维生素矿物类',
            '3': '五官科类',
            '4': '风湿镇痛类',
            '5': '心脏血管类',
            '6': '糖尿病类',
            '7': '消化系统类',
            '8': '感冒止咳类',
            '9': '清热解毒类',
            '10': '外用药类',
            '11': '泌尿生殖系统类',
            '12': '抗菌消炎类',
            '13': '注射类',
            '14': '抗高血压类',
            '15': '妇科类',
            '16': '其他',
        }

        for idx, key in enumerate(list(store_confs.keys())):
            # RX偏好
            base_conf = {
                'tag_cn_name': 'RX偏好-' + store_confs[key],
                'tag_field_name': 'preference_rx_' + str(idx + 1),
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 'product_info',
                'tag_value': '1',
                'where_str': "product_info.type_name like '%" + store_confs[key] + "%'",
            }
            self.b_2001_tag_type1_where(base_conf)

        # RX偏好-缺失
        where_str = ' and '.join(['t_u_preference_rx_' + str(i) + ' = 0'
                                  for i in range(1, 17)])
        base_conf = {
            'tag_cn_name': 'RX偏好-缺失',
            'tag_field_name': 'preference_rx_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 中药偏好
        store_confs = {
            '1': '精制饮片',
            '2': '贵细',
            '3': '饮片',
            '4': '备用',
        }

        for idx, key in enumerate(list(store_confs.keys())):
            # 中药偏好
            base_conf = {
                'tag_cn_name': '中药偏好-' + store_confs[key],
                'tag_field_name': 'preference_zy_' + str(idx + 1),
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 'product_info',
                'tag_value': '1',
                'where_str': "product_info.type_name like '%" + store_confs[key] + "%'",
            }
            self.b_2001_tag_type1_where(base_conf)

        # 中药偏好-缺失
        where_str = ' and '.join(['t_u_preference_zy_' + str(i) + ' = 0'
                                  for i in range(1, 5)])
        base_conf = {
            'tag_cn_name': '中药偏好-缺失',
            'tag_field_name': 'preference_zy_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 是否参加会员日
        base_conf = {
            'tag_cn_name': '是否参加会员日',
            'tag_field_name': 'member_day',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'product_info',
            'tag_value': '1',
            'where_str': "product_info.product_name like '%特价%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 复购次数
        cond_confs = {
            '滋补营养类': 'order_zbyy',
            '维生素矿物类': 'order_wsskw',
            '五官科类': 'order_wgk',
            '风湿镇痛类': 'order_fszt',
            '消化系统类': 'order_xhxt',
            '清热解毒类': 'order_qrjd',
            '妇科类': 'order_fk',
        }

        for key in list(cond_confs.keys()):
            # 过程值：复购次数
            base_conf = {
                'tag_cn_name': '复购次数-' + key,
                'tag_field_name': cond_confs[key],
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 'product_info',
                'table_join_field': 'any_string',
                'agg_func': 'count',
                'where_str': "product_info.type_name like '%" + key + "%'",
            }
            self.b_3001_mid_type2_basic(base_conf)

            # 复购次数
            base_conf = {
                'tag_cn_name': '复购次数-' + key,
                'tag_field_name': cond_confs[key],
                'table_join': 'u_mid_15',
                'table_join_field': cond_confs[key] + ' - 1',
                'case_default': '0',
            }
            when_conf = {
                '0': ['', '0'],
                '1': ['1', '1'],
                '2': ['2', '2'],
                '3': ['3', '3'],
                '4': ['4', '4'],
                '5': ['5', '5'],
                '6': ['6', '6'],
                '7': ['7', '7'],
                '8': ['8', '8'],
                '9': ['9', '9'],
                '10': ['10', '10'],
                '11': ['11', ''],
            }
            self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 是否购买糖尿病类药品
        base_conf = {
            'tag_cn_name': '是否购买糖尿病类药品',
            'tag_field_name': 'buy_tnb',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'product_info',
            'tag_value': '1',
            'where_str': "product_info.type_name like '%糖尿病类%'",
        }
        self.b_2001_tag_type1_where(base_conf)
        # 是否购买心脑血管类药品
        base_conf = {
            'tag_cn_name': '是否购买心脑血管类药品',
            'tag_field_name': 'buy_xzxg',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'product_info',
            'tag_value': '1',
            'where_str': "product_info.type_name like '%心脑血管类%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 购买提醒
        cond_confs = {
            '盐酸二甲双胍': ['remind_ejsg', '27790'],
            '诺和龙': ['remind_nhl', '23289'],
            '格列齐特': ['remind_glqt', '14100'],
            '尼群地平': ['remind_nqdp', '34081'],
            '湘江': ['remind_xj', '16720'],
            '圣元': ['remind_sy', '28851'],
            '拜阿司匹灵': ['remind_baspl', '10102'],
        }

        for key in list(cond_confs.keys()):
            # 过程值：购买提醒最后购买日期
            base_conf = {
                'tag_cn_name': '购买提醒最后购买日期-' + key,
                'tag_field_name': cond_confs[key][0] + '_date',
                'tag_field_type': 'date',
                'tag_field_default': 'null',
                'table_join': 'order_list',
                'table_join_field': 'order_list.order_time',
                'agg_func': 'max',
                'where_str': "order_list.product_code = " + cond_confs[key][1],
            }
            self.b_3001_mid_type2_basic(base_conf)

            # 过程值：购买提醒服用周期
            base_conf = {
                'tag_cn_name': '购买提醒服用周期-' + key,
                'tag_field_name': cond_confs[key][0] + '_cycle',
                'tag_field_type': 'int(11)',
                'tag_field_default': 'null',
                'table_join': 'usage_info',
                'table_join_field': 'usage_info.take_cycle',
                'agg_func': 'max',
                'where_str': "order_list.product_code = " + cond_confs[key][1],
            }
            self.b_3001_mid_type2_basic(base_conf)

            # 过程值：购买提醒剩余天数
            base_conf = {
                'tag_cn_name': '购买提醒剩余天数-' + key,
                'tag_field_name': cond_confs[key][0],
                'tag_field_type': 'int(5)',
                'tag_field_default': 'null',
                'table_join': ['usage_info', 'u_mid_15'],
                'tag_value': cond_confs[key][0] + '_cycle' + " - "
                             "TIMESTAMPDIFF(DAY, u_mid_15." + cond_confs[key][0] + '_date' + ", CURDATE())",
                'where_str': 'true',
            }
            self.b_2002_mid_type1_where(base_conf)

            # 购买提醒
            base_conf = {
                'tag_cn_name': '购买提醒-' + key,
                'tag_field_name': cond_confs[key][0],
                'table_join': 'u_mid_15',
                'table_join_field': cond_confs[key][0],
                'case_default': '0',
            }
            when_conf = {
                '1': ['', '0'],
                '2': ['1', '5'],
                '3': ['6', '10'],
                '4': ['11', '15'],
                '5': ['15', ''],
            }
            self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 下载表生成
        self._wr_big_comment('下载表生成')
        self.b7_dld_gen()

if __name__ == "__main__":
    c15_config = {'file_path': template_c.TAG_FILE_PATH,
                  'custom_id': template_c.CUSTOM_ID,
                  'db_config': template_c.DB_CONFIG,
                  'tag_tb_name': template_c.TAG_TB_NAME,
                  'dld_tb_name': template_c.DLD_TB_NAME,
                  'mid_tb_name': template_c.MID_TB_NAME,
                  'member_key': template_c.MEMBER_KEY,
                  'table_relation': template_c.TABLE_RELATION,
                  }
    t = C15Prc(c15_config)
    # 生成标签信息
    # t.tag_info.tag_level_1_prc()
    # t.tag_info.tag_level_2_prc()
    # t.tag_info.tag_level_3_prc()
    # print("Finish: 生成标签信息")
    # 生成标签逻辑脚本
    t.gen_script()
    print("Finish")
