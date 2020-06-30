# coding: utf-8
# @Time    : 2019/5/11 20:41
# @Author  : zhongshan
# @Email   : 15926220700@139.com

from TagBase.tag_logic_prc import TagLogicPrc
from TagProc import template_c18 as template_c


class C18Prc(TagLogicPrc):
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

        # 地址
        base_conf = {
            'tag_cn_name': '地址',
            'tag_field_name': 'address',
            'table_join': 'member_info',
            'case_default': '0',
        }
        when_conf = {
            '1':  "member_info.exp_addr like '%上海%'",
            '2':  "member_info.exp_addr like '%云南%'",
            '3':  "member_info.exp_addr like '%内蒙%'",
            '4':  "member_info.exp_addr like '%北京%'",
            '5':  "member_info.exp_addr like '%吉林%'",
            '6':  "member_info.exp_addr like '%四川%'",
            '7':  "member_info.exp_addr like '%天津%'",
            '8':  "member_info.exp_addr like '%宁夏%'",
            '9':  "member_info.exp_addr like '%安徽%'",
            '10': "member_info.exp_addr like '%山东%'",
            '11': "member_info.exp_addr like '%山西%'",
            '12': "member_info.exp_addr like '%广东%'",
            '13': "member_info.exp_addr like '%广西%'",
            '14': "member_info.exp_addr like '%新疆%'",
            '15': "member_info.exp_addr like '%江苏%'",
            '16': "member_info.exp_addr like '%江西%'",
            '17': "member_info.exp_addr like '%河北%'",
            '18': "member_info.exp_addr like '%河南%'",
            '19': "member_info.exp_addr like '%浙江%'",
            '20': "member_info.exp_addr like '%海南%'",
            '21': "member_info.exp_addr like '%湖北%'",
            '22': "member_info.exp_addr like '%湖南%'",
            '23': "member_info.exp_addr like '%甘肃%'",
            '24': "member_info.exp_addr like '%福建%'",
            '25': "member_info.exp_addr like '%西藏%'",
            '26': "member_info.exp_addr like '%贵州%'",
            '27': "member_info.exp_addr like '%辽宁%'",
            '28': "member_info.exp_addr like '%重庆%'",
            '29': "member_info.exp_addr like '%陕西%'",
            '30': "member_info.exp_addr like '%青海%'",
            '31': "member_info.exp_addr like '%黑龙江%'",
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 过程值：累计返点积分
        base_conf = {
            'tag_cn_name': '累计返点积分',
            'tag_field_name': 'point_back',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'order_list.point_back',
            'agg_func': 'sum',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 累计返点积分
        base_conf = {
            'tag_cn_name': '累计返点积分',
            'tag_field_name': 'point_back',
            'table_join': 'u_mid_18',
            'table_join_field': 'point_back',
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

        # 过程值：已使用积分
        base_conf = {
            'tag_cn_name': '已使用积分',
            'tag_field_name': 'point_pay',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'order_list.point_pay',
            'agg_func': 'sum',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 已使用积分
        base_conf = {
            'tag_cn_name': '已使用积分',
            'tag_field_name': 'point_pay',
            'table_join': 'u_mid_18',
            'table_join_field': 'point_pay',
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

        # 过程值：最后购买时间
        base_conf = {
            'tag_cn_name': '最后购买时间',
            'tag_field_name': 'last_pay_time',
            'tag_field_type': 'datetime',
            'tag_field_default': 'null',
            'table_join': 'order_list',
            'table_join_field': 'order_list.pay_time',
            'agg_func': 'max',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 客户属性
        base_conf = {
            'tag_cn_name': '客户属性',
            'tag_field_name': 'customer_attr',
            'table_join': 'u_mid_18',
            'case_default': '2',
        }
        when_conf = {
            '1':  "TIMESTAMPDIFF(DAY, u_mid_18.last_pay_time, CURDATE()) <= 30",
            '0':  "TIMESTAMPDIFF(DAY, u_mid_18.last_pay_time, CURDATE()) > 180",
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)

        # 来源渠道
        base_conf = {
            'tag_cn_name': '来源渠道',
            'tag_field_name': 'source_type',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': 'true',
        }
        self.b_2001_tag_type1_where(base_conf)

        # 过程值：6个月以内下单次数
        base_conf = {
            'tag_cn_name': '6个月以内下单次数',
            'tag_field_name': 'order_times_after6',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'order_list.pay_time >= date_sub(date(now()),interval 6 month)',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 近半年购买次数
        base_conf = {
            'tag_cn_name': '近半年购买次数',
            'tag_field_name': 'halfyear_orders',
            'table_join': 'u_mid_18',
            'table_join_field': 'order_times_after6',
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

        # 过程值：12个月以内下单次数
        base_conf = {
            'tag_cn_name': '12个月以内下单次数',
            'tag_field_name': 'order_times_after12',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'order_list.pay_time >= date_sub(date(now()),interval 12 month)',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 近一年购买次数
        base_conf = {
            'tag_cn_name': '近一年购买次数',
            'tag_field_name': 'year_orders',
            'table_join': 'u_mid_18',
            'table_join_field': 'order_times_after12',
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

        # 过程值：近半年消费金额总和
        base_conf = {
            'tag_cn_name': '近半年消费金额总和',
            'tag_field_name': 'halfyear_spend',
            'tag_field_type': 'decimal(11,2)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'order_list.total_amount',
            'agg_func': 'sum',
            'where_str': 'order_list.pay_time >= date_sub(date(now()),interval 6 month)',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 近半年消费金额总和
        base_conf = {
            'tag_cn_name': '近半年消费金额总和',
            'tag_field_name': 'halfyear_spend',
            'table_join': 'u_mid_18',
            'table_join_field': 'halfyear_spend',
            'case_default': '0',
        }
        when_conf = {
            '1': ['1', '500'],
            '2': ['501', '1000'],
            '3': ['1001', '2000'],
            '4': ['2001', '5000'],
            '5': ['5001', '10000'],
            '6': ['10001', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 过程值：近一年消费金额总和
        base_conf = {
            'tag_cn_name': '近一年消费金额总和',
            'tag_field_name': 'year_spend',
            'tag_field_type': 'decimal(11,2)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'order_list.total_amount',
            'agg_func': 'sum',
            'where_str': 'order_list.pay_time >= date_sub(date(now()),interval 12 month)',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 近一年消费金额总和
        base_conf = {
            'tag_cn_name': '近一年消费金额总和',
            'tag_field_name': 'year_spend',
            'table_join': 'u_mid_18',
            'table_join_field': 'year_spend',
            'case_default': '0',
        }
        when_conf = {
            '1': ['1', '1000'],
            '2': ['1001', '2000'],
            '3': ['2001', '3000'],
            '4': ['3001', '6000'],
            '5': ['6001', '10000'],
            '6': ['10001', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

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
            'tag_field_name': 'total_spend',
            'tag_field_type': 'decimal(11,2)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'order_list.total_amount',
            'agg_func': 'sum',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 是否高价值客户
        base_conf = {
            'tag_cn_name': '是否高价值客户',
            'tag_field_name': 'value_type',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'u_mid_18',
            'tag_value': '1',
            'where_str': "order_times_total > 2 and total_spend > 5000",
        }
        self.b_2001_tag_type1_where(base_conf)

        def _run_conf_0(tag_confs, name_conf):
            for idx, key in enumerate(list(tag_confs.keys())):
                # 值
                base_conf = {
                    'tag_cn_name': name_conf[0] + '-' + key,
                    'tag_field_name': name_conf[1] + '_' + str(idx + 1),
                    'tag_field_type': 'int(5)',
                    'tag_field_default': '0',
                    'table_join': 'order_list',
                    'tag_value': '1',
                    'where_str': "order_list.product_title like '%" + tag_confs[key] + "%'",
                }
                self.b_2001_tag_type1_where(base_conf)

            # -缺失
            where_str = ' and '.join(['t_u_' + name_conf[1] + '_' + str(i) + ' = 0'
                                      for i in range(1, len(tag_confs) + 1)])
            base_conf = {
                'tag_cn_name': name_conf[0] + '-缺失',
                'tag_field_name': name_conf[1] + '_0',
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'tag_value': '1',
                'where_str': where_str,
            }
            self.b_2001_tag_type1_where(base_conf)

        # 曾经购买过茶具种类
        tag_confs = {
            '陶瓷杯': '陶瓷杯',
            '陶罐': '陶罐',
            '保温瓶': '保温瓶',
            '茶刀': '茶刀',
            '茶针': '茶针',
        }
        name_conf = ['曾经购买过茶具种类', 'tea_set']

        _run_conf_0(tag_confs, name_conf)

        # 曾经购买过规格种类
        tag_confs = {
            '饼': '饼',
            '砖': '砖',
            '罐': '罐',
            '泡茶': '泡茶',
        }
        name_conf = ['曾经购买过规格种类', 'tea_spec']

        _run_conf_0(tag_confs, name_conf)

        # 曾经购买过茶叶种类
        tag_confs = {
            '青柑': '青柑',
            '铁观音': '铁观音',
            '白柑': '白柑',
            '桂花香': '桂花香',
            '普洱': '普洱',
            '大红袍': '大红袍',
            '白牡丹': '白牡丹',
            '青茶': '青茶',
            '茶香粽': '茶香粽',
        }
        name_conf = ['曾经购买过茶叶种类', 'tea_type']

        _run_conf_0(tag_confs, name_conf)

        # 购买目的-送礼
        base_conf = {
            'tag_cn_name': '购买目的-送礼',
            'tag_field_name': 'buy_purpose_1',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'tag_value': '1',
            'where_str': "order_list.product_title like '%礼%' or order_list.product_title like '%定制%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 购买目的-自饮
        base_conf = {
            'tag_cn_name': '购买目的-自饮',
            'tag_field_name': 'buy_purpose_2',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'tag_value': '1',
            'where_str': "order_list.product_title not like '%礼%' and order_list.product_title not like '%定制%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 购买目的-缺失
        where_str = ' and '.join(['t_u_buy_purpose_' + str(i) + ' = 0'
                                  for i in range(1, 3)])
        base_conf = {
            'tag_cn_name': '购买目的-缺失',
            'tag_field_name': 'buy_purpose_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        def _run_conf_1(tag_confs, name_conf):
            for idx, key in enumerate(list(tag_confs.keys())):
                # 次数
                base_conf = {
                    'tag_cn_name': name_conf[0] + '次数-' + key,
                    'tag_field_name': name_conf[1] + '_' + str(idx + 1),
                    'tag_field_type': 'int(11)',
                    'tag_field_default': '0',
                    'table_join': 'order_list',
                    'table_join_field': 'any_string',
                    'agg_func': 'count',
                    'where_str': "order_list.product_title like '%" + tag_confs[key] + "%'",
                }
                self.b_3001_mid_type2_basic(base_conf)

            # 过程值：次数最大值
            value_str = ', '.join([name_conf[1] + '_' + str(i)
                                   for i in range(1, len(tag_confs) + 1)])
            base_conf = {
                'tag_cn_name': '过程值：次数最大值',
                'tag_field_name': name_conf[1] + '_max',
                'tag_field_type': 'int(11)',
                'tag_field_default': '0',
                'tag_value': 'greatest(' + value_str + ')',
                'where_str': 'true',
            }
            self.b_2002_mid_type1_where(base_conf)

            for idx, key in enumerate(list(tag_confs.keys())):
                # 标签值
                base_conf = {
                    'tag_cn_name': name_conf[0] + '-' + key,
                    'tag_field_name': name_conf[1] + '_' + str(idx + 1),
                    'tag_field_type': 'int(5)',
                    'tag_field_default': '0',
                    'table_join': 'u_mid_18',
                    'tag_value': '1',
                    'where_str': "u_mid_18." + name_conf[1] + '_' + str(idx + 1) +
                                 " = u_mid_18." + name_conf[1] + '_max' +
                                 " and u_mid_18." + name_conf[1] + '_max > 0',
                }
                self.b_2001_tag_type1_where(base_conf)

            # -缺失
            where_str = ' and '.join(['t_u_' + name_conf[1] + '_' + str(i) + ' = 0'
                                      for i in range(1, len(tag_confs) + 1)])
            base_conf = {
                'tag_cn_name': name_conf[0] + '-缺失',
                'tag_field_name': name_conf[1] + '_0',
                'tag_field_type': 'int(5)',
                'tag_field_default': '0',
                'tag_value': '1',
                'where_str': where_str,
            }
            self.b_2001_tag_type1_where(base_conf)

        # 茶具偏好
        tag_confs = {
            '陶瓷杯': '陶瓷杯',
            '陶罐': '陶罐',
            '保温瓶': '保温瓶',
            '茶刀': '茶刀',
            '茶针': '茶针',
        }
        name_conf = ['茶具偏好', 'tea_set_pref']

        _run_conf_1(tag_confs, name_conf)

        # 规格偏好
        tag_confs = {
            '饼': '饼',
            '砖': '砖',
            '罐': '罐',
            '泡茶': '泡茶',
        }
        name_conf = ['规格偏好', 'tea_spec_pref']

        _run_conf_1(tag_confs, name_conf)

        # 茶叶偏好
        tag_confs = {
            '青柑': '青柑',
            '铁观音': '铁观音',
            '白柑': '白柑',
            '桂花香': '桂花香',
            '普洱': '普洱',
            '大红袍': '大红袍',
            '白牡丹': '白牡丹',
            '青茶': '青茶',
            '茶香粽': '茶香粽',
        }
        name_conf = ['茶叶偏好', 'tea_type_pref']

        _run_conf_1(tag_confs, name_conf)

        # 过程值：茶具购买次数
        base_conf = {
            'tag_cn_name': '茶具购买次数',
            'tag_field_name': 'tea_set_reorder',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "order_list.product_title like '%陶瓷杯%'" +
                         " or order_list.product_title like '%陶罐%'" +
                         " or order_list.product_title like '%保温瓶%'" +
                         " or order_list.product_title like '%茶刀%'" +
                         " or order_list.product_title like '%茶针%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 茶具复购次数
        base_conf = {
            'tag_cn_name': '茶具购买次数',
            'tag_field_name': 'tea_set_reorder',
            'table_join': 'u_mid_18',
            'table_join_field': 'tea_set_reorder',
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

        # 过程值：规格复购次数
        base_conf = {
            'tag_cn_name': '规格复购次数',
            'tag_field_name': 'tea_spec_reorder',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "order_list.product_title like '%饼%'" +
                         " or order_list.product_title like '%砖%'" +
                         " or order_list.product_title like '%罐%'" +
                         " or order_list.product_title like '%泡茶%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 规格复购次数
        base_conf = {
            'tag_cn_name': '规格复购次数',
            'tag_field_name': 'tea_spec_reorder',
            'table_join': 'u_mid_18',
            'table_join_field': 'tea_spec_reorder',
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

        # 过程值：茶叶复购次数
        base_conf = {
            'tag_cn_name': '茶叶复购次数',
            'tag_field_name': 'tea_type_reorder',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "order_list.product_title like '%青柑%'" +
                         " or order_list.product_title like '%铁观音%'" +
                         " or order_list.product_title like '%白柑%'" +
                         " or order_list.product_title like '%桂花香%'" +
                         " or order_list.product_title like '%普洱%'" +
                         " or order_list.product_title like '%大红袍%'" +
                         " or order_list.product_title like '%白牡丹%'" +
                         " or order_list.product_title like '%青茶%'" +
                         " or order_list.product_title like '%茶香粽%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 茶叶复购次数
        base_conf = {
            'tag_cn_name': '茶叶复购次数',
            'tag_field_name': 'tea_type_reorder',
            'table_join': 'u_mid_18',
            'table_join_field': 'tea_type_reorder',
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

        # 过程值：退换款次数
        base_conf = {
            'tag_cn_name': '退换款次数',
            'tag_field_name': 'reject_times',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "order_list.close_reason = '退款'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 退换款次数
        base_conf = {
            'tag_cn_name': '退换款次数',
            'tag_field_name': 'reject_times',
            'table_join': 'u_mid_18',
            'table_join_field': 'reject_times',
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

        # 是否参加618活动
        base_conf = {
            'tag_cn_name': '是否参加618活动',
            'tag_field_name': 'promotion_618',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'tag_value': '1',
            'where_str': "month(order_list.pay_time) = 6 and day(order_list.pay_time) = 18",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 是否参加双11活动
        base_conf = {
            'tag_cn_name': '是否参加双11活动',
            'tag_field_name': 'promotion_1111',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'tag_value': '1',
            'where_str': "month(order_list.pay_time) = 11 and day(order_list.pay_time) = 11",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 是否参加双12活动
        base_conf = {
            'tag_cn_name': '是否参加双12活动',
            'tag_field_name': 'promotion_1212',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'tag_value': '1',
            'where_str': "month(order_list.pay_time) = 12 and day(order_list.pay_time) = 12",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 下载表生成
        self._wr_big_comment('下载表生成')
        self.b7_dld_gen()

if __name__ == "__main__":
    c18_config = {'file_path': template_c.TAG_FILE_PATH,
                  'custom_id': template_c.CUSTOM_ID,
                  'db_config': template_c.DB_CONFIG,
                  'tag_tb_name': template_c.TAG_TB_NAME,
                  'dld_tb_name': template_c.DLD_TB_NAME,
                  'mid_tb_name': template_c.MID_TB_NAME,
                  'member_key': template_c.MEMBER_KEY,
                  'table_relation': template_c.TABLE_RELATION,
                  }
    t = C18Prc(c18_config)
    # 生成标签信息
    # t.tag_info.tag_level_1_prc()
    # t.tag_info.tag_level_2_prc()
    # t.tag_info.tag_level_3_prc()
    # print("Finish: 生成标签信息")
    # 生成标签逻辑脚本
    t.gen_script()
    print("Finish")
