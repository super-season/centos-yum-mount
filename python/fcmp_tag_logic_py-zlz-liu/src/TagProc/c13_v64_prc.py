# coding: utf-8
# @Time    : 2019/5/11 20:41
# @Author  : zhongshan
# @Email   : 15926220700@139.com

from TagBase.tag_logic_prc import TagLogicPrc
from TagProc import template_c13_v64 as template_c


class C13Prc(TagLogicPrc):
    """ 标签逻辑类
    客户C13的标签生成逻辑
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

        self._wr_big_comment('标签逻辑-标签表')
        self._wr_mid_comment('基本信息')

        # 标签逻辑
        # 年龄
        base_conf = {
            'tag_cn_name': '年龄',
            'tag_field_name': 'age',
            'table_join': 'member_info',
            'table_join_field': 'age',
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
            'table_join_field': 'province',
            'case_default': '0',
        }
        when_conf = {
            '1': '上海市',
            '2': '云南省',
            '3': '内蒙古自治区',
            '4': '北京市',
            '5': '吉林省',
            '6': '四川省',
            '7': '天津市',
            '8': '宁夏回族自治区',
            '9': '安徽省',
            '10': '山东省',
            '11': '山西省',
            '12': '广东省',
            '13': '广西壮族自治区',
            '14': '新疆维吾尔自治区',
            '15': '江苏省',
            '16': '江西省',
            '17': '河北省',
            '18': '河南省',
            '19': '浙江省',
            '20': '海南省',
            '21': '湖北省',
            '22': '湖南省',
            '23': '甘肃省',
            '24': '福建省',
            '25': '西藏自治区',
            '26': '贵州省',
            '27': '辽宁省',
            '28': '重庆市',
            '29': '陕西省',
            '30': '青海省',
            '31': '黑龙江省',
        }
        self.b_1301_tag_type1_case_map(base_conf, when_conf)

        # 客户属性
        # 过程值：3年前的下单次数
        base_conf = {
            'tag_cn_name': '3年前的下单次数',
            'tag_field_name': 'order_times_before3y',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'order_list.order_time < date_sub(date(' + template_c.CURRENT_DATE + '),interval 3 year)',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：3年内的下单次数
        base_conf = {
            'tag_cn_name': '3年内的下单次数',
            'tag_field_name': 'order_times_after3y',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'order_list.order_time >= date_sub(date(' + template_c.CURRENT_DATE + '),interval 3 year)',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：2年前的下单次数
        base_conf = {
            'tag_cn_name': '2年前的下单次数',
            'tag_field_name': 'order_times_before2y',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'order_list.order_time < date_sub(date(' + template_c.CURRENT_DATE + '),interval 2 year)',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：2年内的下单次数
        base_conf = {
            'tag_cn_name': '2年内的下单次数',
            'tag_field_name': 'order_times_after2y',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'order_list.order_time >= date_sub(date(' + template_c.CURRENT_DATE + '),interval 2 year)',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：1年前的下单次数
        base_conf = {
            'tag_cn_name': '1年前的下单次数',
            'tag_field_name': 'order_times_before1y',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'order_list.order_time < date_sub(date(' + template_c.CURRENT_DATE + '),interval 1 year)',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：1年内的下单次数
        base_conf = {
            'tag_cn_name': '1年内的下单次数',
            'tag_field_name': 'order_times_after1y',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'order_list.order_time >= date_sub(date(' + template_c.CURRENT_DATE + '),interval 1 year)',
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
            'table_join_field': 'order_list.total_cost',
            'agg_func': 'sum',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 客户属性
        base_conf = {
            'tag_cn_name': '客户属性',
            'tag_field_name': 'ctype',
            'table_join': 'u_mid_13',
            'case_default': '0',
        }
        when_conf = {
            '0': 'u_mid_13.order_times_before3y > 0 and u_mid_13.order_times_after3y = 0',
            '1': 'u_mid_13.order_times_before2y > 0 and u_mid_13.order_times_after2y = 0',
            '2': 'u_mid_13.order_times_before1y > 0 and u_mid_13.order_times_after1y = 0',
            '3': 'u_mid_13.order_times_before1y = 0 and u_mid_13.order_times_after1y > 0',
            '4': 'u_mid_13.order_times_before1y > 0 and u_mid_13.order_times_after1y > 0',
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 过程值：第一批5月购买次数
        base_conf = {
            'tag_cn_name': '第一批5月购买次数',
            'tag_field_name': 'may_one_orders',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "order_list.member_group = 1 and date_format(order_list.order_time, '%Y-%m')='2019-05'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：第二批5月购买次数
        base_conf = {
            'tag_cn_name': '第二批5月购买次数',
            'tag_field_name': 'may_two_orders',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "order_list.member_group = 2 and date_format(order_list.order_time, '%Y-%m')='2019-05'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 第一批5月已消费
        base_conf = {
            'tag_cn_name': '第一批5月已消费',
            'tag_field_name': 'may_one',
            'table_join': 'u_mid_13',
            'case_default': '0',
        }
        when_conf = {
            '1': 'u_mid_13.may_one_orders >= 1',
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 第二批5月已消费
        base_conf = {
            'tag_cn_name': '第二批5月已消费',
            'tag_field_name': 'may_two',
            'table_join': 'u_mid_13',
            'case_default': '0',
        }
        when_conf = {
            '1': 'u_mid_13.may_two_orders >= 1',
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 过程值：客单价800元客户购买次数
        base_conf = {
            'tag_cn_name': '客单价800元客户购买次数',
            'tag_field_name': 'group_one_orders',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "order_list.member_group = 1",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：客单价1300元客户购买次数
        base_conf = {
            'tag_cn_name': '客单价1300元客户购买次数',
            'tag_field_name': 'group_two_orders',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "order_list.member_group = 2",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 客单价800元客户
        base_conf = {
            'tag_cn_name': '客单价800元客户',
            'tag_field_name': 'group_one',
            'table_join': 'u_mid_13',
            'case_default': '0',
        }
        when_conf = {
            '1': 'u_mid_13.group_one_orders >= 1',
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 客单价1300元客户
        base_conf = {
            'tag_cn_name': '客单价1300元客户',
            'tag_field_name': 'group_two',
            'table_join': 'u_mid_13',
            'case_default': '0',
        }
        when_conf = {
            '1': 'u_mid_13.group_two_orders >= 1',
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 是否高价值客户
        base_conf = {
            'tag_cn_name': '是否高价值客户',
            'tag_field_name': 'valuable',
            'table_join': 'u_mid_13',
            'case_default': '0',
        }
        when_conf = {
            '1': 'u_mid_13.order_times_total > 5 and u_mid_13.total_cost_value > 500',
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 总下单次数
        base_conf = {
            'tag_cn_name': '总下单次数',
            'tag_field_name': 'total_order',
            'table_join': 'u_mid_13',
            'table_join_field': 'order_times_total',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '1'],
            '1': ['2', '4'],
            '2': ['5', '7'],
            '3': ['8', '10'],
            '4': ['11', '15'],
            '5': ['16', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 消费金额总和
        base_conf = {
            'tag_cn_name': '消费金额总和',
            'tag_field_name': 'total_cost',
            'table_join': 'u_mid_13',
            'table_join_field': 'total_cost_value',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '50'],
            '1': ['50', '100'],
            '2': ['100', '200'],
            '3': ['200', '500'],
            '4': ['500', '1000'],
            '5': ['1000', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：拒收次数
        base_conf = {
            'tag_cn_name': '拒收次数',
            'tag_field_name': 'reject_value',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'agg_func': 'count',
            'where_str': "order_list.comment like '%拒收%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 拒收次数
        base_conf = {
            'tag_cn_name': '拒收次数',
            'tag_field_name': 'reject',
            'table_join': 'u_mid_13',
            'table_join_field': 'reject_value',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '0'],
            '1': ['1', '1'],
            '2': ['2', '2'],
            '3': ['3', '3'],
            '4': ['4', '4'],
            '5': ['5', '5'],
            '6': ['6', '10'],
            '7': ['11', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：退换货次数
        base_conf = {
            'tag_cn_name': '退换货次数',
            'tag_field_name': 'return_value',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'agg_func': 'count',
            'where_str': "order_list.order_status = '已退货'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 退换货次数
        base_conf = {
            'tag_cn_name': '退换货次数',
            'tag_field_name': 'return',
            'table_join': 'u_mid_13',
            'table_join_field': 'return_value',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '0'],
            '1': ['1', '1'],
            '2': ['2', '2'],
            '3': ['3', '3'],
            '4': ['4', '4'],
            '5': ['5', '5'],
            '6': ['6', '10'],
            '7': ['11', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        def _order_xxx(i_string, e_string, t_strings):
            # 复购次数通用
            # 购买次数
            where_str = ' or '.join(["order_list.goods_name_strs like '%" + t_string + "%'"
                                     for t_string in t_strings])
            base_conf = {
                'tag_cn_name': i_string,
                'tag_field_name': e_string + '_value',
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 'order_list',
                'table_join_field': 'any_string',
                'agg_func': 'count',
                'where_str': where_str,
            }
            self.b_3001_mid_type2_basic(base_conf)
            # 复购次数
            base_conf = {
                'tag_cn_name': i_string,
                'tag_field_name': e_string,
                'table_join': 'u_mid_13',
                'table_join_field': e_string + '_value',
                'case_default': '0',
            }
            # 复购次数要在购买次数的基础上减一，因此对应的区间范围数值要减一
            when_conf = {
                '0': ['', '1'],
                '1': ['2', '2'],
                '2': ['3', '3'],
                '3': ['4', '4'],
                '4': ['5', '5'],
                '5': ['6', '6'],
                '6': ['7', '7'],
                '7': ['8', '8'],
                '8': ['9', '9'],
                '9': ['10', '10'],
                '10': ['11', '11'],
                '11': ['12', ''],
            }
            self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 洗面类复购次数等同类标签
        _order_xxx('洗面类复购次数', 'order_xm', ['祛痘', '粉刺调理', '洁面'])
        _order_xxx('倍润霜复购次数', 'order_brs', ['倍润霜'])
        _order_xxx('面膜类复购次数', 'order_mm', ['面膜', '眼膜', 'U膜', '冰膜'])
        _order_xxx('喷雾类复购次数', 'order_pw', ['喷雾'])
        _order_xxx('精华类复购次数', 'order_jh', ['精华液', '精纯液', '冻干粉'])
        _order_xxx('精油类复购次数', 'order_jy', ['精油'])
        _order_xxx('养发类复购次数', 'order_yf', ['育发', '固发'])

        def _purchase_base(tag_cn_name, tag_field_name, where_str, where_cond=''):
            # 消费偏好通用
            # 中间值：次数
            where_str1 = where_str if(where_cond == '') else where_str + " and " + where_cond
            base_conf = {
                'tag_cn_name': tag_cn_name,
                'tag_field_name': tag_field_name + '_value',
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 'order_list',
                'table_join_field': 'any_string',
                'agg_func': 'count',
                'where_str': where_str1,
            }
            self.b_3001_mid_type2_basic(base_conf)
            # 标签
            base_conf = {
                'tag_cn_name': tag_cn_name,
                'tag_field_name': tag_field_name,
                'table_join': 'u_mid_13',
                'table_join_field': tag_field_name + '_value',
                'case_default': '0',
            }
            # 0/1两种取值
            when_conf = {
                '1': ['1', ''],
            }
            self.b_1101_tag_type1_case_between(base_conf, when_conf)

        def _purchase_common(w_field, tag_cn_name, tag_field_name, t_strings, where_cond=''):
            # 消费偏好普通三级标签通用
            where_str_or = ' or '.join([w_field + " like '%" + t_string + "%'"
                                        for t_string in t_strings[0]])
            where_str_and = ' and '.join([w_field + " not like '%" + t_string + "%'"
                                         for t_string in t_strings[1]])
            if(where_str_or == ''): where_str_or = 'TRUE'
            if(where_str_and == ''): where_str_and = 'TRUE'
            where_str = ' and '.join([where_str_or, where_str_and])
            _purchase_base(tag_cn_name, tag_field_name, where_str, where_cond)

        def _purchase_lack(w_field, tag_cn_name, tag_field_name, where_cond = ''):
            # 消费偏好 缺失
            where_str = w_field + " is null or " + w_field + " = ''"
            _purchase_base(tag_cn_name, tag_field_name, where_str, where_cond)

        def _purchase_tag(w_field, tag_cn_name_1, tag_field_name_1, delivery_keyword, where_cond=''):
            # 消费偏好 标签逻辑
            # 普通标签
            for idx, tag_key in enumerate(list(delivery_keyword.keys())):
                tag_cn_name = tag_cn_name_1 + '-' + tag_key
                tag_field_name = tag_field_name_1 + '_' + str(idx + 1)
                _purchase_common(w_field, tag_cn_name, tag_field_name, delivery_keyword[tag_key], where_cond)
            # 缺失
            _purchase_lack(w_field, tag_cn_name_1 + '-缺失', tag_field_name_1 + '_0', where_cond)
            # 其他
            where_str = ' and '.join(['t_u_' + tag_field_name_1 + '_' + str(i) + ' = 0'
                                      for i in range(0, len(delivery_keyword) + 1)])
            base_conf = {
                'tag_cn_name': tag_cn_name_1 + '-其他',
                'tag_field_name': tag_field_name_1 + '_' + str(len(delivery_keyword) + 1),
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'tag_value': '1',
                'where_str': where_str,
            }
            self.b_2001_tag_type1_where(base_conf)

        # 物流偏好
        w_field = 'order_list.express_company'
        tag_cn_name_1 = '物流偏好'
        tag_field_name_1 = 'ex_pref'
        delivery_keyword = {
            'EMS': [['EMS'], []],
            '黑猫': [['黑猫'], []],
            '顺丰': [['顺丰'], []],
            '天天': [['天天'], []],
            '圆通': [['圆通'], []],
            '申通': [['申通'], []],
            '中通': [['中通'], []],
            '邮政': [['邮政'], []],
            '德邦': [['德邦'], []],
            '京东': [['京东'], []],
            '韵达': [['韵达'], []],
        }
        _purchase_tag(w_field, tag_cn_name_1, tag_field_name_1, delivery_keyword)

        # 支付偏好
        w_field = 'order_list.pay_mode'
        tag_cn_name_1 = '支付偏好'
        tag_field_name_1 = 'pay_pref'
        delivery_keyword = {
            '微信支付': [['微信'], ['预付款', '预支付', '货到付款']],
            '支付宝支付': [['支付宝'], ['预付款', '预支付', '货到付款']],
            '现金支付': [['现金'], ['货到付款']],
            '银行支付': [['银行'], ['预付款', '预支付', '货到付款']],
            '货到付款': [['货到付款'], []],
            '微信/支付宝/银行预付款': [['预付款', '预支付'], []],
        }
        _purchase_tag(w_field, tag_cn_name_1, tag_field_name_1, delivery_keyword)

        # 产品偏好
        w_field = 'order_list.goods_name_strs'
        tag_cn_name_1 = '产品偏好'
        tag_field_name_1 = 'product_pref'
        delivery_keyword = {
            '补水': [['补水'], []],
            '保湿': [['保湿'], []],
            '洁面': [['洁面'], []],
            '祛痘': [['祛痘'], []],
            '喷雾': [['喷雾'], []],
            '眼霜': [['眼霜'], []],
            '倍润霜': [['倍润霜'], []],
            '隔离霜': [['隔离霜'], []],
            '面膜': [['面膜'], []],
            '眼膜': [['眼膜'], []],
            'U膜': [['U膜'], []],
            '睡眠冰膜': [['睡眠冰膜'], []],
            '精华液': [['精华液'], []],
            '精纯液': [['精纯液'], []],
            '冻干粉': [['冻干粉'], []],
            '雪肤': [['雪肤'], []],
            '固发育发': [['固发', '育发'], []],
            '细纹修护': [['细纹修护'], []],
            '精油': [['精油'], []],
            '粉刺调理': [['粉刺调理'], []],
            '舒缓': [['舒缓'], []],
        }
        _purchase_tag(w_field, tag_cn_name_1, tag_field_name_1, delivery_keyword)

        # 复购率的部分逻辑
        self._wr_sql(template_c.tl_reorder_002)

        # 复购率的其它逻辑
        reorder_values = ['补水', '保湿', '眼霜', '倍润霜', '隔离霜', '面膜', '眼膜', '精华液', '精纯液']
        for idx, rv in enumerate(reorder_values):
            base_conf = {
                'tag_cn_name': '复购率最高产品-' + rv,
                'tag_field_name': 'prefer_product_' + str(idx + 1),
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'table_join': 't_re_order_max',
                'tag_value': '1',
                'where_str': "t_re_order_max.product_cat = '" + rv + "'",
            }
            self.b_2001_tag_type1_where(base_conf)
        # 无复购
        where_str = ' and '.join(['t_u_prefer_product_' + str(i) + ' = 0'
                                  for i in range(1, len(reorder_values) + 1)])
        base_conf = {
            'tag_cn_name': '复购率最高产品-无复购',
            'tag_field_name': 'prefer_product_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 过程值：2016下单次数
        base_conf = {
            'tag_cn_name': '2016下单次数',
            'tag_field_name': 'order_times_2016_total',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "date_format(order_list.order_time, '%Y')='2016'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：2016下单金额
        base_conf = {
            'tag_cn_name': '2016下单金额',
            'tag_field_name': 'total_cost_2016_value',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'order_list.total_cost',
            'agg_func': 'sum',
            'where_str': "date_format(order_list.order_time, '%Y')='2016'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 2016下单次数
        base_conf = {
            'tag_cn_name': '2016下单次数',
            'tag_field_name': 'total_order_2016',
            'table_join': 'u_mid_13',
            'table_join_field': 'order_times_2016_total',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '1'],
            '1': ['2', '4'],
            '2': ['5', '7'],
            '3': ['8', '10'],
            '4': ['11', '15'],
            '5': ['16', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 2016下单金额
        base_conf = {
            'tag_cn_name': '2016下单金额',
            'tag_field_name': 'total_cost_2016',
            'table_join': 'u_mid_13',
            'table_join_field': 'total_cost_2016_value',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '50'],
            '1': ['50', '100'],
            '2': ['100', '200'],
            '3': ['200', '500'],
            '4': ['500', '1000'],
            '5': ['1000', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 购买产品类型2016
        w_field = 'order_list.goods_name_strs'
        tag_cn_name_1 = '购买产品类型2016'
        tag_field_name_1 = 'product_pref_2016'
        delivery_keyword = {
            '补水': [['补水'], []],
            '保湿': [['保湿'], []],
            '洁面': [['洁面'], []],
            '祛痘': [['祛痘'], []],
            '喷雾': [['喷雾'], []],
            '眼霜': [['眼霜'], []],
            '倍润霜': [['倍润霜'], []],
            '隔离霜': [['隔离霜'], []],
            '面膜': [['面膜'], []],
            '眼膜': [['眼膜'], []],
            'U膜': [['U膜'], []],
            '睡眠冰膜': [['睡眠冰膜'], []],
            '精华液': [['精华液'], []],
            '精纯液': [['精纯液'], []],
            '冻干粉': [['冻干粉'], []],
            '雪肤': [['雪肤'], []],
            '固发育发': [['固发', '育发'], []],
            '细纹修护': [['细纹修护'], []],
            '精油': [['精油'], []],
            '粉刺调理': [['粉刺调理'], []],
            '舒缓': [['舒缓'], []],
        }
        where_cond = "date_format(order_list.order_time, '%Y')='2016'"
        _purchase_tag(w_field, tag_cn_name_1, tag_field_name_1, delivery_keyword, where_cond)

        # 过程值：2017下单次数
        base_conf = {
            'tag_cn_name': '2017下单次数',
            'tag_field_name': 'order_times_2017_total',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "date_format(order_list.order_time, '%Y')='2017'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：2017下单金额
        base_conf = {
            'tag_cn_name': '2017下单金额',
            'tag_field_name': 'total_cost_2017_value',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'order_list.total_cost',
            'agg_func': 'sum',
            'where_str': "date_format(order_list.order_time, '%Y')='2017'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 2017下单次数
        base_conf = {
            'tag_cn_name': '2017下单次数',
            'tag_field_name': 'total_order_2017',
            'table_join': 'u_mid_13',
            'table_join_field': 'order_times_2017_total',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '1'],
            '1': ['2', '4'],
            '2': ['5', '7'],
            '3': ['8', '10'],
            '4': ['11', '15'],
            '5': ['16', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 2017下单金额
        base_conf = {
            'tag_cn_name': '2017下单金额',
            'tag_field_name': 'total_cost_2017',
            'table_join': 'u_mid_13',
            'table_join_field': 'total_cost_2017_value',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '50'],
            '1': ['50', '100'],
            '2': ['100', '200'],
            '3': ['200', '500'],
            '4': ['500', '1000'],
            '5': ['1000', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 购买产品类型2017
        w_field = 'order_list.goods_name_strs'
        tag_cn_name_1 = '购买产品类型2017'
        tag_field_name_1 = 'product_pref_2017'
        delivery_keyword = {
            '补水': [['补水'], []],
            '保湿': [['保湿'], []],
            '洁面': [['洁面'], []],
            '祛痘': [['祛痘'], []],
            '喷雾': [['喷雾'], []],
            '眼霜': [['眼霜'], []],
            '倍润霜': [['倍润霜'], []],
            '隔离霜': [['隔离霜'], []],
            '面膜': [['面膜'], []],
            '眼膜': [['眼膜'], []],
            'U膜': [['U膜'], []],
            '睡眠冰膜': [['睡眠冰膜'], []],
            '精华液': [['精华液'], []],
            '精纯液': [['精纯液'], []],
            '冻干粉': [['冻干粉'], []],
            '雪肤': [['雪肤'], []],
            '固发育发': [['固发', '育发'], []],
            '细纹修护': [['细纹修护'], []],
            '精油': [['精油'], []],
            '粉刺调理': [['粉刺调理'], []],
            '舒缓': [['舒缓'], []],
        }
        where_cond = "date_format(order_list.order_time, '%Y')='2017'"
        _purchase_tag(w_field, tag_cn_name_1, tag_field_name_1, delivery_keyword, where_cond)

        # 过程值：2018下单次数
        base_conf = {
            'tag_cn_name': '2018下单次数',
            'tag_field_name': 'order_times_2018_total',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "date_format(order_list.order_time, '%Y')='2018'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：2018下单金额
        base_conf = {
            'tag_cn_name': '2018下单金额',
            'tag_field_name': 'total_cost_2018_value',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'order_list.total_cost',
            'agg_func': 'sum',
            'where_str': "date_format(order_list.order_time, '%Y')='2018'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 2018下单次数
        base_conf = {
            'tag_cn_name': '2018下单次数',
            'tag_field_name': 'total_order_2018',
            'table_join': 'u_mid_13',
            'table_join_field': 'order_times_2018_total',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '1'],
            '1': ['2', '4'],
            '2': ['5', '7'],
            '3': ['8', '10'],
            '4': ['11', '15'],
            '5': ['16', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 2018下单金额
        base_conf = {
            'tag_cn_name': '2018下单金额',
            'tag_field_name': 'total_cost_2018',
            'table_join': 'u_mid_13',
            'table_join_field': 'total_cost_2018_value',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '50'],
            '1': ['50', '100'],
            '2': ['100', '200'],
            '3': ['200', '500'],
            '4': ['500', '1000'],
            '5': ['1000', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 购买产品类型2018
        w_field = 'order_list.goods_name_strs'
        tag_cn_name_1 = '购买产品类型2018'
        tag_field_name_1 = 'product_pref_2018'
        delivery_keyword = {
            '补水': [['补水'], []],
            '保湿': [['保湿'], []],
            '洁面': [['洁面'], []],
            '祛痘': [['祛痘'], []],
            '喷雾': [['喷雾'], []],
            '眼霜': [['眼霜'], []],
            '倍润霜': [['倍润霜'], []],
            '隔离霜': [['隔离霜'], []],
            '面膜': [['面膜'], []],
            '眼膜': [['眼膜'], []],
            'U膜': [['U膜'], []],
            '睡眠冰膜': [['睡眠冰膜'], []],
            '精华液': [['精华液'], []],
            '精纯液': [['精纯液'], []],
            '冻干粉': [['冻干粉'], []],
            '雪肤': [['雪肤'], []],
            '固发育发': [['固发', '育发'], []],
            '细纹修护': [['细纹修护'], []],
            '精油': [['精油'], []],
            '粉刺调理': [['粉刺调理'], []],
            '舒缓': [['舒缓'], []],
        }
        where_cond = "date_format(order_list.order_time, '%Y')='2018'"
        _purchase_tag(w_field, tag_cn_name_1, tag_field_name_1, delivery_keyword, where_cond)

        # 过程值：2019下单次数
        base_conf = {
            'tag_cn_name': '2019下单次数',
            'tag_field_name': 'order_times_2019_total',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "date_format(order_list.order_time, '%Y')='2019'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 过程值：2019下单金额
        base_conf = {
            'tag_cn_name': '2019下单金额',
            'tag_field_name': 'total_cost_2019_value',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'order_list.total_cost',
            'agg_func': 'sum',
            'where_str': "date_format(order_list.order_time, '%Y')='2019'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 2019下单次数
        base_conf = {
            'tag_cn_name': '2019下单次数',
            'tag_field_name': 'total_order_2019',
            'table_join': 'u_mid_13',
            'table_join_field': 'order_times_2019_total',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '1'],
            '1': ['2', '4'],
            '2': ['5', '7'],
            '3': ['8', '10'],
            '4': ['11', '15'],
            '5': ['16', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 2019下单金额
        base_conf = {
            'tag_cn_name': '2019下单金额',
            'tag_field_name': 'total_cost_2019',
            'table_join': 'u_mid_13',
            'table_join_field': 'total_cost_2019_value',
            'case_default': '0',
        }
        when_conf = {
            '0': ['', '50'],
            '1': ['50', '100'],
            '2': ['100', '200'],
            '3': ['200', '500'],
            '4': ['500', '1000'],
            '5': ['1000', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 购买产品类型2019
        w_field = 'order_list.goods_name_strs'
        tag_cn_name_1 = '购买产品类型2019'
        tag_field_name_1 = 'product_pref_2019'
        delivery_keyword = {
            '补水': [['补水'], []],
            '保湿': [['保湿'], []],
            '洁面': [['洁面'], []],
            '祛痘': [['祛痘'], []],
            '喷雾': [['喷雾'], []],
            '眼霜': [['眼霜'], []],
            '倍润霜': [['倍润霜'], []],
            '隔离霜': [['隔离霜'], []],
            '面膜': [['面膜'], []],
            '眼膜': [['眼膜'], []],
            'U膜': [['U膜'], []],
            '睡眠冰膜': [['睡眠冰膜'], []],
            '精华液': [['精华液'], []],
            '精纯液': [['精纯液'], []],
            '冻干粉': [['冻干粉'], []],
            '雪肤': [['雪肤'], []],
            '固发育发': [['固发', '育发'], []],
            '细纹修护': [['细纹修护'], []],
            '精油': [['精油'], []],
            '粉刺调理': [['粉刺调理'], []],
            '舒缓': [['舒缓'], []],
        }
        where_cond = "date_format(order_list.order_time, '%Y')='2019'"
        _purchase_tag(w_field, tag_cn_name_1, tag_field_name_1, delivery_keyword, where_cond)

        # 下载表生成
        self._wr_big_comment('下载表生成')
        self.b7_dld_gen()


if __name__ == "__main__":
    # 配置信息
    c13_config = {'file_path': template_c.TAG_FILE_PATH,
                  'custom_id': template_c.CUSTOM_ID,
                  'db_config': template_c.DB_CONFIG,
                  'tag_tb_name': template_c.TAG_TB_NAME,
                  'dld_tb_name': template_c.DLD_TB_NAME,
                  'mid_tb_name': template_c.MID_TB_NAME,
                  'member_key': template_c.MEMBER_KEY,
                  'table_relation': template_c.TABLE_RELATION,
                  }
    t = C13Prc(c13_config)
    # 生成标签信息
    # t.tag_info.tag_level_1_prc()
    # t.tag_info.tag_level_2_prc()
    # t.tag_info.tag_level_3_prc()
    # print("Finish: 生成标签信息")
    # 生成标签逻辑脚本
    t.gen_script()
    print("Finish")
