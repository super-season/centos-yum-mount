# coding: utf-8
# @Time    : 2019/5/11 20:41
# @Author  : zhongshan
# @Email   : 15926220700@139.com

from TagBase.tag_logic_prc_liu import TagLogicPrc
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
       # self._wr_sql(template_c.tl_pre_001)

        # 基础表u_tag,u_mid,u_dld三个表生成
        self.b2_base_gen(template_c.DISPLAY_FIELDS)

        # 直接写SQL：生成医生偏好所需的几张表
       # self._wr_sql(template_c.tl_doctor_002)

        # 直接写SQL：生成首次购买产品所需临时表
        #self._wr_sql(template_c.tl_first_buy_003)

        # 合并数据到此结束
        #exit()

        # 标签逻辑
        self._wr_big_comment('标签逻辑-标签表')

        # 一级标签 身份特征
        self._wr_mid_comment('一级标签 身份特征')

        # 性别
        base_conf = {
            'tag_cn_name': '性别',
            'tag_field_name': 'gender',    # #t_tag表中的字段后缀，后面调用的b_1301_tag_type1_case_map是tag表
            'table_join': 'test_member_stores',
            'table_join_field': 'sex',     #连接test_member_stores表中的sex字段
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
            'table_join': 'test_member_stores',
            'tag_value': 'TIMESTAMPDIFF(MONTH, test_member_stores.birthday, CURDATE())',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 过程值：年龄
        base_conf = {
            'tag_cn_name': '过程值：年龄',
            'tag_field_name': 'age_mid',
            'tag_field_type': 'int(10)',
            'tag_field_default': '0',
            'tag_value': 'age_months/12',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # u_tag年龄对应标签值
        base_conf = {
            'tag_cn_name': '年龄',
            'tag_field_name': 'age',
            'table_join': 'u_mid_12',
            'table_join_field': 'age_mid',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '17'],
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



        # 会员类型-普通会员，多值标签，会在member_type_1字段赋值1，然后在结果U-tag表中有相应的数值
        # 类型
        base_conf = {
            'tag_cn_name': '类型',
            'tag_field_name': 'identity_type',    #t_tag表中的字段后缀，后面调用的b_1301_tag_type1_case_map是tag表
            'table_join': 'test_member_stores',
            'table_join_field': 'member_type',   #连接test_member_stores表中的member_type字段
            'case_default': '0',
        }
        when_conf = {
            '1': '普通会员',
            '2': '白金会员',
            '3': '黑金会员',
            '4': '钻石会员',
        }
        self.b_1301_tag_type1_case_map(base_conf, when_conf)


        base_conf = {
            'tag_cn_name': '来源',
            'tag_field_name': 'source',
            'table_join': 'test_member_stores',
            'table_join_field': 'source',
            'case_default': '0',
        }
        when_conf = {
            '1': '自营公众号',
            '2': '淘宝商城',
            '3': '京东商城',
            '4': '活动推广',
            '5': '其他',
        }
        self.b_1301_tag_type1_case_map(base_conf, when_conf)

        # base_conf = {
        #     'tag_cn_name': '会员类型-签约',
        #     'tag_field_name': 'member_type_2',
        #     'tag_field_type': 'int(5)',
        #     'tag_field_default': '0',
        #     'table_join': 'sign_card_manage',
        #     'tag_value': '1',
        #     'where_str': "sign_card_manage.expire >= CURDATE()",
        # }
        # self.b_2001_tag_type1_where(base_conf)

        # 一级标签 消费特征
        self._wr_mid_comment('一级标签 消费特征')

        # u_mid表过程值：最后一次购买日期
        base_conf = {
            'tag_cn_name': '过程值：最后一次购买日期',
            'tag_field_name': 'last_buydate',
            'tag_field_type': 'date',
            'tag_field_default': 'null',
            'table_join': 'test_sales_summary',
            'table_join_field': 'test_sales_summary.buy_date',
            'agg_func': 'max',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # u_mid表过程值：第一次购买日期
        base_conf = {
            'tag_cn_name': '过程值：第一次购买日期',
            'tag_field_name': 'first_buy',
            'tag_field_type': 'date',
            'tag_field_default': 'null',
            'table_join': 'test_sales_summary',
            'table_join_field': 'test_sales_summary.buy_date',
            'agg_func': 'min',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        # u_mid表过程值：倒数第二次购买日期
        base_conf = {
            'tag_cn_name': '过程值：倒数第二次购买日期',
            'tag_field_name': 'last_second_buydate',
            'tag_field_type': 'date',
            'tag_field_default': 'null',
            'table_join': 'test_sales_summary',
            'table_join_field': 'test_sales_summary.buy_date',
            'agg_func': 'max',
            'where_str': 'test_sales_summary.buy_date != u_mid_12.last_buydate', #排除掉最后一次购买日期
        }
        self.b_3001_mid_type2_basic(base_conf)

        # u_mid过程值：购买周期：最后一个购买日期和倒数第二次购买日期时间差
        base_conf = {
            'tag_cn_name': '过程值：购买周期',
            'tag_field_name': 'between_lastsecond',
            'tag_field_type': 'int(4)',
            'tag_field_default': '0',
            'tag_value': 'TIMESTAMPDIFF(DAY, last_second_buydate,last_buydate)',   #last_buydate减去last_second_buydate
            'where_str': 'true',  #first_buy时间在一年之前
        }
        self.b_2002_mid_type1_where(base_conf)

        # u_tag购买周期对应标签值
        base_conf = {
            'tag_cn_name': '购买周期',
            'tag_field_name': 'buy_cycle',
            'table_join': 'u_mid_12',
            'table_join_field': 'between_lastsecond',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '90'],
            '2': ['91', '120'],
            '3': ['121', '150'],
            '4': ['151', '180'],
            '5': ['211', '240'],
            '6': ['241', '270'],
            '7': ['271', '300'],
            '8': ['301', '360'],
            '9': ['360', '']
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)


        # u_tag购买偏好-缺失，儿童钙片，成人中老年钙片，成人液体钙，维生素D胶囊，咀嚼片，氨糖软骨素加钙片，牛乳钙软糖


        # 购买偏好-成人中老年钙片
        base_conf = {
            'tag_cn_name': '购买偏好-成人中老年钙片',
            'tag_field_name': 'buy_preferences_1',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.buy_product_name like '%中老年%' \n" +
                           "and test_sales_summary.buy_product_name not like '%氨糖软骨素%'"
        }
        self.b_2001_tag_type1_where(base_conf)


        # 购买偏好-儿童钙片
        base_conf = {
            'tag_cn_name': '购买偏好-儿童钙片',
            'tag_field_name': 'buy_preferences_2',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.buy_product_name like '%儿童%'"
        }
        self.b_2001_tag_type1_where(base_conf)

        # 购买偏好-成人液体钙
        base_conf = {
            'tag_cn_name': '购买偏好-成人液体钙',
            'tag_field_name': 'buy_preferences_3',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.buy_product_name like '%液体钙%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 购买偏好-维生素D胶囊
        base_conf = {
            'tag_cn_name': '购买偏好-维生素D胶囊',
            'tag_field_name': 'buy_preferences_4',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.buy_product_name like '%维%' \n" +
                           "and test_sales_summary.buy_product_name  like '%胶囊%'"
        }
        self.b_2001_tag_type1_where(base_conf)

        # 购买偏好-咀嚼片
        base_conf = {
            'tag_cn_name': '购买偏好-咀嚼片',
            'tag_field_name': 'buy_preferences_5',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.buy_product_name like '%咀嚼片%'"
        }
        self.b_2001_tag_type1_where(base_conf)

        # 购买偏好-氨糖软骨素加钙片
        base_conf = {
            'tag_cn_name': '购买偏好-氨糖软骨素加钙片',
            'tag_field_name': 'buy_preferences_6',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.buy_product_name like '%氨糖%' "
        }
        self.b_2001_tag_type1_where(base_conf)

        # 购买偏好-牛乳钙软糖
        base_conf = {
            'tag_cn_name': '购买偏好-牛乳钙软糖',
            'tag_field_name': 'buy_preferences_7',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.buy_product_name like '%牛乳钙%' "
        }
        self.b_2001_tag_type1_where(base_conf)

        # 购买偏好-缺失，需要放在最后面，把前面几个字段缺失的做一次计算
        where_str = ' and '.join(['t_u_buy_preferences_' + str(i) + ' = 0'
                                  for i in range(1, 6)])
        base_conf = {
            'tag_cn_name': '购买偏好-缺失',
            'tag_field_name': 'buy_preferences_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # u_mid表过程值：钙片类购买次数
        base_conf = {
            'tag_cn_name': '过程值：钙片类购买次数',
            'tag_field_name': 'gaipian_buy_times',
            'tag_field_type': 'int(8)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "test_sales_summary.buy_product_name like '%钙片%'\n" +
                           "and test_sales_summary.buy_product_name not like '%氨糖%'"
        }
        self.b_3001_mid_type2_basic(base_conf)

        # u_tag表钙片类购买次数
        base_conf = {
            'tag_cn_name': '钙片类购买次数',
            'tag_field_name': 'buy_bumber',    #u_tag字段
            'table_join': 'u_mid_12',
            'table_join_field': 'gaipian_buy_times',   #u_mid_12字段
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '0'],
            '2': ['1', '3'],
            '3': ['4', '6'],
            '4': ['7', '9'],
            '5': ['10', '12'],
            '6': ['13', '']

        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)




        # 过程值：近一年到店次数
        base_conf = {
            'tag_cn_name': '近一年到店次数',
            'tag_field_name': 'year_times',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'table_join_field': 'buy_date',
            'agg_func': 'count',
            'where_str':  'u_mid_12.first_buy > date_sub(CURDATE(), interval 1 year)'
                         # " and interview_info.sign_department not like '%儿童保健%'\n" +
                         # " and interview_info.sign_department not like '%儿童口腔%'\n" +
                         # " and interview_info.sign_department not like '%儿童全科%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 近一年到店月数
        base_conf = {
            'tag_cn_name': '近一年到店月数',
            'tag_field_name': 'number_month',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'u_mid_12',
            'tag_value': 'case '
                         '  when u_mid_12.first_buy is null then 99 '
                         '  when u_mid_12.first_buy < date_sub(CURDATE(),interval 1 year) then 12.0 '
                         '  else datediff(CURDATE(),u_mid_12.first_buy)/30 end',
            'where_str': 'true'
        }
        self.b_2001_tag_type1_where(base_conf)

        # 过程值：近一年到店频率
        base_conf = {
            'tag_cn_name': '过程值：近一年到店频率',
            'tag_field_name': 'last_year_rate',
            'tag_field_type': 'decimal(12,2)',
            'tag_field_default': '0',
            'table_join': 'u_tag_12',
            'tag_value': 'u_mid_12.year_times / u_tag_12.t_u_number_month',
            'where_str': 'true',  #first_buy时间在一年之前
        }
        self.b_2002_mid_type1_where(base_conf)

        # base_conf = {
        #     'tag_cn_name': '近一年到店频率',
        #     'tag_field_name': 'frequency',
        #     'tag_field_type': 'decimal(12,3)',
        #     'tag_field_default': '1',
        #     'table_join': 'u_tag_21',
        #     'tag_value': 'u_mid_21.number_year / u_tag_21.t_u_number_month',
        #     'where_str': 'true',
        # }
        # self.b_2002_mid_type1_where(base_conf)

        # # u_mid过程值：小于一年的近一年到店频率
        # base_conf = {
        #     'tag_cn_name': '过程值：小于一年的近一年到店频率',
        #     'tag_field_name': 'last_year_rate',
        #     'tag_field_type': 'decimal(12,2)',
        #     'tag_field_default': '0',
        #     'tag_value': 'year_times/buy_months',
        #     'where_str': 'first_buy >= date_sub(CURDATE(),interval 1 year)',  #first_buy时间在一年之内
        # }
        # self.b_2002_mid_type1_where(base_conf)

        # u_tag表近一年到店频率，对应标签值
        base_conf = {
            'tag_cn_name': '近一年到店频率',
            'tag_field_name': 'year_frequency',
            'table_join': 'u_mid_12',
            'table_join_field': 'last_year_rate',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '0.25'],
            '2': ['0.26', '0.5'],
            '3': ['0.51', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # u_mid过程值：总到店次数
        base_conf = {
            'tag_cn_name': '总到店次数',
            'tag_field_name': 'times_total',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'true'
        }
        self.b_3001_mid_type2_basic(base_conf)

        # # u_tag表中总到店频率，对应标签值
        base_conf = {
            'tag_cn_name': '总到店频率',
            'tag_field_name': 'times_total',
            'table_join': 'u_mid_12',
            'table_join_field': 'times_total',
            'case_default': '0',
        }
        when_conf = {
            '1': [ '','0'],
            '2': ['1', '3'],
            '3': ['4', '6'],
            '4': ['7', '9'],
            '5': ['10', '12'],
            '6': ['13', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # u_mid过程值:消费金额总和
        base_conf = {
            'tag_cn_name': '消费金额总和',
            'tag_field_name': 'consumption_total',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'table_join_field': 'test_sales_summary.buy_number * test_sales_summary.product_price',
            'agg_func': 'sum',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)

        #u_tag: 消费金额总和对应标签值
        base_conf = {
            'tag_cn_name': '消费金额总和',
            'tag_field_name': 'consumption_total',   #t_tag表中的字段名
            'table_join': 'u_mid_12',
            'table_join_field': 'consumption_total',  #u_mid_12表中的字段名
            'case_default': '0',
        }
        when_conf = {
            '1': ['1', '50'],
            '2': ['51', '100'],
            '3': ['100', '200'],
            '4': ['201', '500'],
            '5': ['501', '1000'],
            '6': ['1001', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # u_mid过程值:客单价：消费金额总和/购买次数
        base_conf = {
            'tag_cn_name': '过程值：客单价',
            'tag_field_name': 'average_price',
            'tag_field_type': 'decimal(12,2)',
            'tag_field_default': '0',
            'tag_value': 'consumption_total/(case when times_total= 0  then 1   else times_total  end)',  #times_total有可能为0，相除报错，所以得分情况
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        #u_tag: 客单价对应标签值
        base_conf = {
            'tag_cn_name': '客单价',
            'tag_field_name': 'price',   #t_tag表中的字段名
            'table_join': 'u_mid_12',
            'table_join_field': 'average_price',  #u_mid_12表中的字段名
            'case_default': '0',
        }
        when_conf = {
            '1': ['1', '50'],
            '2': ['51', '100'],
            '3': ['100', '200'],
            '4': ['201', '500'],
            '5': ['501', '1000'],
            '6': ['1001', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)



        # 一级标签 产品使用特征
        self._wr_mid_comment('一级标签 产品使用特征')


        # 产品类型-片剂
        base_conf = {
            'tag_cn_name': '产品类型-片剂',
            'tag_field_name': 'product_type_1',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%片剂%'"
                         " and test_product_detail.product_fenlei like '%钙片%'",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 产品类型-软胶囊
        base_conf = {
            'tag_cn_name': '产品类型-软胶囊',
            'tag_field_name': 'product_type_2',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%软胶囊%'"
                         " and test_product_detail.product_fenlei like '%钙片%'",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 产品类型-颗粒
        base_conf = {
            'tag_cn_name': '产品类型-颗粒',
            'tag_field_name': 'product_type_3',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%颗粒%'"
                         " and test_product_detail.product_fenlei like '%钙片%'",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 产品类型-缺失
        where_str = ' and '.join(['t_u_product_type_' + str(i) + ' != 1'
                                  for i in range(1, 4)])
        base_conf = {
            'tag_cn_name': '购买偏好-缺失',
            'tag_field_name': 'product_type_0',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 片剂规格-50片
        base_conf = {
            'tag_cn_name': '产品类型-片剂',
            'tag_field_name': 'tablet_specification_1',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%片剂%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=50",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 片剂规格-60片
        base_conf = {
            'tag_cn_name': '产品类型-片剂',
            'tag_field_name': 'tablet_specification_2',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%片剂%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=60",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 片剂规格-80片
        base_conf = {
            'tag_cn_name': '产品类型-片剂',
            'tag_field_name': 'tablet_specification_3',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%片剂%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=80",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 片剂规格-92片
        base_conf = {
            'tag_cn_name': '产品类型-片剂',
            'tag_field_name': 'tablet_specification_4',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%片剂%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=92",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 片剂规格-100片
        base_conf = {
            'tag_cn_name': '产品类型-片剂',
            'tag_field_name': 'tablet_specification_5',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%片剂%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=100",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 片剂规格-120片
        base_conf = {
            'tag_cn_name': '产品类型-片剂',
            'tag_field_name': 'tablet_specification_6',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%片剂%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=120",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 片剂规格-198片
        base_conf = {
            'tag_cn_name': '产品类型-片剂',
            'tag_field_name': 'tablet_specification_7',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%片剂%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=198",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 片剂规格-200片
        base_conf = {
            'tag_cn_name': '产品类型-片剂',
            'tag_field_name': 'tablet_specification_8',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%片剂%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=200",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 片剂规格-300片
        base_conf = {
            'tag_cn_name': '产品类型-片剂',
            'tag_field_name': 'tablet_specification_9',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%片剂%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=300",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 片剂规格-396片
        base_conf = {
            'tag_cn_name': '产品类型-片剂',
            'tag_field_name': 'tablet_specification_10',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%片剂%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=396",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 片剂规格-缺失,片剂，胶囊，颗粒的缺失是分开的
        where_str = ' and '.join(['t_u_tablet_specification_' + str(i) + ' != 1'
                                  for i in range(1, 11)])
        base_conf = {
            'tag_cn_name': '片剂规格-缺失',
            'tag_field_name': 'tablet_specification_0',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 胶囊规格-30粒
        base_conf = {
            'tag_cn_name': '产品类型-胶囊',
            'tag_field_name': 'capsule_specification_1',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%软胶囊%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=30",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 胶囊规格-90粒
        base_conf = {
            'tag_cn_name': '产品类型-胶囊',
            'tag_field_name': 'capsule_specification_2',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%软胶囊%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=90",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 胶囊规格-110粒
        base_conf = {
            'tag_cn_name': '产品类型-胶囊',
            'tag_field_name': 'capsule_specification_3',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%软胶囊%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=110",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 胶囊规格-150粒
        base_conf = {
            'tag_cn_name': '产品类型-胶囊',
            'tag_field_name': 'capsule_specification_4',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%软胶囊%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=150",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 胶囊规格-180粒
        base_conf = {
            'tag_cn_name': '产品类型-胶囊',
            'tag_field_name': 'capsule_specification_5',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%软胶囊%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=180",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 胶囊规格-缺失,片剂，胶囊，颗粒的缺失是分开的
        where_str = ' and '.join(['t_u_capsule_specification_' + str(i) + ' != 1'
                                  for i in range(1, 6)])
        base_conf = {
            'tag_cn_name': '胶囊规格-缺失',
            'tag_field_name': 'capsule_specification_0',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 颗粒规格-40粒
        base_conf = {
            'tag_cn_name': '产品类型-颗粒',
            'tag_field_name': 'particle_specification_1',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%颗粒%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=40",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 颗粒规格-48粒
        base_conf = {
            'tag_cn_name': '产品类型-颗粒',
            'tag_field_name': 'particle_specification_2',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%颗粒%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=48",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 颗粒规格-80粒
        base_conf = {
            'tag_cn_name': '产品类型-颗粒',
            'tag_field_name': 'particle_specification_3',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join1': 'test_sales_summary',
            'table_join2': 'test_product_detail',
            'tag_value': '1',
            'where_str': "test_product_detail.product_form like '%颗粒%'"
                         "and test_product_detail.product_fenlei like '%钙片%'"
                         "and test_product_detail.Specifications_number=80",
        }
        self.b_2001_1_tag_type1_where(base_conf)

        # 颗粒规格-缺失,片剂，胶囊，颗粒的缺失是分开的
        where_str = ' and '.join(['t_u_particle_specification_' + str(i) + ' != 1'
                                  for i in range(1, 4)])
        base_conf = {
            'tag_cn_name': '颗粒规格-缺失',
            'tag_field_name': 'particle_specification_0',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # u_tag服用周期对应标签值，跟购买周期一样
        base_conf = {
            'tag_cn_name': '服用周期',
            'tag_field_name': 'taking_cycle',
            'table_join': 'u_mid_12',
            'table_join_field': 'between_lastsecond',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '90'],
            '2': ['91', '120'],
            '3': ['121', '150'],
            '4': ['151', '180'],
            '5': ['211', '240'],
            '6': ['241', '270'],
            '7': ['271', '300'],
            '8': ['301', '360'],
            '9': ['360', '']
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 一级标签 产品使用特征
        self._wr_mid_comment('一级标签 营销偏好特征')

        # 限时/限量激励活动偏好-前1000件买一送一
        base_conf = {
            'tag_cn_name': '限时/限量激励活动偏好-前1000件买一送一',
            'tag_field_name': 'sale_activity_1',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_type like '%前1000件买一送一%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 限时/限量激励活动偏好-前500件买一送一
        base_conf = {
            'tag_cn_name': '限时/限量激励活动偏好-前500件买一送一',
            'tag_field_name': 'sale_activity_2',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_type like '%前500件买一送一%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 限时/限量激励活动偏好-限时第2件半价
        base_conf = {
            'tag_cn_name': '限时/限量激励活动偏好-限时第2件半价',
            'tag_field_name': 'sale_activity_3',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_type like '%限时第2件半价%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 限时/限量激励活动偏好-前200件买就送100粒
        base_conf = {
            'tag_cn_name': '限时/限量激励活动偏好-前200件买就送100粒',
            'tag_field_name': 'sale_activity_4',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_type like '%前200件买就送100粒%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 限时/限量激励活动偏好-前2小时第2件0元
        base_conf = {
            'tag_cn_name': '限时/限量激励活动偏好-前2小时第2件0元',
            'tag_field_name': 'sale_activity_5',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_type like '%前2小时第2件0元%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 限时/限量激励活动偏好-未参与
        where_str = ' and '.join(['t_u_sale_activity_' + str(i) + ' != 1'
                                  for i in range(1, 6)])
        base_conf = {
            'tag_cn_name': '限时/限量激励活动偏好-未参与',
            'tag_field_name': 'sale_activity_0',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 满减促销活动偏好-满199减80
        base_conf = {
            'tag_cn_name': '满减促销活动偏好-满199减80',
            'tag_field_name': 'full_reduction_1',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_type like '%满199减80%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 满减促销活动偏好-满400减199
        base_conf = {
            'tag_cn_name': '满减促销活动偏好-满400减199',
            'tag_field_name': 'full_reduction_2',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_type like '%满400减199%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 满减促销活动偏好-满2件享受75折
        base_conf = {
            'tag_cn_name': '满减促销活动偏好-满2件享受75折',
            'tag_field_name': 'full_reduction_3',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_type like '%满2件享受75折%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 满减促销活动偏好-满3件享受66折
        base_conf = {
            'tag_cn_name': '满减促销活动偏好-满3件享受66折',
            'tag_field_name': 'full_reduction_4',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_type like '%满3件享受66折%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 满减促销活动偏好-未参与
        where_str = ' and '.join(['t_u_full_reduction_' + str(i) + ' != 1'
                                  for i in range(1, 5)])
        base_conf = {
            'tag_cn_name': '满减促销活动偏好-未参与',
            'tag_field_name': 'full_reduction_0',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 预售付定金活动偏好-预定50元立减10
        base_conf = {
            'tag_cn_name': '预售付定金活动偏好-预定50元立减10',
            'tag_field_name': 'advance_payment_1',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_type like '%预定50元立减10%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 预售付定金活动偏好-定金100元抵150元
        base_conf = {
            'tag_cn_name': '预售付定金活动偏好-定金100元抵150元',
            'tag_field_name': 'advance_payment_2',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_type like '%定金100元抵150元%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 预售付定金活动偏好-定金200元抵350元
        base_conf = {
            'tag_cn_name': '预售付定金活动偏好-定金200元抵350元',
            'tag_field_name': 'advance_payment_3',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_type like '%定金200元抵350元%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 预售付定金活动偏好-未参与
        where_str = ' and '.join(['t_u_advance_payment_' + str(i) + ' != 1'
                                  for i in range(1, 4)])
        base_conf = {
            'tag_cn_name': '预售付定金活动偏好-未参与',
            'tag_field_name': 'advance_payment_0',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)

        # 是否参与京东618品质狂欢节
        base_conf = {
            'tag_cn_name': '是否参与京东618品质狂欢节',
            'tag_field_name': 'jingdong618_carnival',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_name like '%京东618品质狂欢节%'",
        }
        self.b_2001_tag_type1_where(base_conf)


        # 是否参与天猫618理想生活狂欢节
        base_conf = {
            'tag_cn_name': '是否参与天猫618理想生活狂欢节',
            'tag_field_name': 'tianmao618_carnival',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_name like '%天猫618理想生活狂欢节%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 是否参与天猫双十一购物狂欢节
        base_conf = {
            'tag_cn_name': '是否参与天猫双十一购物狂欢节',
            'tag_field_name': 'tianmao1111_carnival',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_name like '%天猫双十一购物狂欢节%'",
        }
        self.b_2001_tag_type1_where(base_conf)


        # 是否参与天猫双十二购物狂欢节
        base_conf = {
            'tag_cn_name': '是否参与天猫双十二购物狂欢节',
            'tag_field_name': 'tianmao1212_carnival',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_name like '%天猫双十二购物狂欢节%'",
        }
        self.b_2001_tag_type1_where(base_conf)


        # 是否参与阿里年货节
        base_conf = {
            'tag_cn_name': '是否参与阿里年货节',
            'tag_field_name': 'ali_shopping',
            'tag_field_type': 'int(2)',
            'tag_field_default': '0',
            'table_join': 'test_sales_summary',
            'tag_value': '1',
            'where_str': "test_sales_summary.activity_name like '%阿里年货节%'",
        }
        self.b_2001_tag_type1_where(base_conf)

        # 一级标签 自定义：再次购买提醒
        self._wr_mid_comment('一级标签 自定义：再次购买提醒')

        # 50片学生儿童钙片,过程值：最后第一次购买日期
        base_conf = {
            'tag_cn_name': '过程值-50片学生儿童钙片最后一次购买日期',
            'tag_field_name': 'last_buy_50',
            'tag_field_type': 'date',
            'tag_field_default': 'null',
            'table_join': 'test_sales_summary',
            'table_join_field': 'buy_date',
            'agg_func': 'max',
            'where_str': "test_sales_summary.buy_product_name like '%50片学生儿童钙片%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 50片学生儿童钙片
        # 过程值：50片学生儿童钙片提醒天数
        base_conf = {
            'tag_cn_name': '过程值：50片学生儿童钙片提醒天数',
            'tag_field_name': 'buy_50',
            'tag_field_type': 'int(10)',
            'tag_field_default': '-1',
            'table_join': 'u_mid_12',
            'tag_value': 'TIMESTAMPDIFF(DAY, last_buy_50, CURDATE()) - 25',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 自定义提醒：50片学生儿童钙片
        base_conf = {
            'tag_cn_name': '50片学生儿童钙片',
            'tag_field_name': 'Children_calcium_50',
            'table_join': 'u_mid_12',
            'table_join_field': 'buy_50',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '5'],
            '2': ['6', '15'],
            '3': ['16', '30'],
            '4': ['31', '60'],
            '5': ['61', '90'],
            '6': ['91', '']
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 80片学生儿童钙片,过程值：过程值-最后第一次购买日期
        base_conf = {
            'tag_cn_name': '过程值-80片学生儿童钙片最后一次购买日期',
            'tag_field_name': 'last_buy_80',
            'tag_field_type': 'date',
            'tag_field_default': 'null',
            'table_join': 'test_sales_summary',
            'table_join_field': 'buy_date',
            'agg_func': 'max',
            'where_str': "test_sales_summary.buy_product_name like '%80片学生儿童钙片%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 80片学生儿童钙片
        # 过程值：80片学生儿童钙片提醒天数
        base_conf = {
            'tag_cn_name': '过程值：80片学生儿童钙片提醒天数',
            'tag_field_name': 'buy_80',
            'tag_field_type': 'int(10)',
            'tag_field_default': '-1',
            'table_join': 'u_mid_12',
            'tag_value': 'TIMESTAMPDIFF(DAY, last_buy_80, CURDATE()) - 40',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 自定义提醒：80片学生儿童钙片
        base_conf = {
            'tag_cn_name': '50片学生儿童钙片',
            'tag_field_name': 'Children_calcium_80',
            'table_join': 'u_mid_12',
            'table_join_field': 'buy_80',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '5'],
            '2': ['6', '15'],
            '3': ['16', '30'],
            '4': ['31', '60'],
            '5': ['61', '90'],
            '6': ['91', '']
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 198片维生素D成人钙片,过程值：最后第一次购买日期
        base_conf = {
            'tag_cn_name': '过程值-198片维生素D成人钙片最后一次购买日期',
            'tag_field_name': 'last_buy_198',
            'tag_field_type': 'date',
            'tag_field_default': 'null',
            'table_join': 'test_sales_summary',
            'table_join_field': 'buy_date',
            'agg_func': 'max',
            'where_str': "test_sales_summary.buy_product_name like '%198片维生素D成人钙片%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 198片维生素D成人钙片
        # 过程值：198片维生素D成人钙片提醒天数
        base_conf = {
            'tag_cn_name': '过程值：198片维生素D成人钙片提醒天数',
            'tag_field_name': 'buy_198',
            'tag_field_type': 'int(10)',
            'tag_field_default': '-1',
            'table_join': 'u_mid_12',
            'tag_value': 'TIMESTAMPDIFF(DAY, last_buy_198, CURDATE()) - 100',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 自定义提醒：198片维生素D成人钙片
        base_conf = {
            'tag_cn_name': '198片维生素D成人钙片',
            'tag_field_name': 'Adult_calcium_198',
            'table_join': 'u_mid_12',
            'table_join_field': 'buy_198',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '5'],
            '2': ['6', '15'],
            '3': ['16', '30'],
            '4': ['31', '60'],
            '5': ['61', '90'],
            '6': ['91', '']
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 300片成人中老年钙片,过程值：最后第一次购买日期
        base_conf = {
            'tag_cn_name': '过程值-300片成人中老年钙片最后一次购买日期',
            'tag_field_name': 'last_buy_300',
            'tag_field_type': 'date',
            'tag_field_default': 'null',
            'table_join': 'test_sales_summary',
            'table_join_field': 'buy_date',
            'agg_func': 'max',
            'where_str': "test_sales_summary.buy_product_name like '%300片成人中老年钙片%'",
        }
        self.b_3001_mid_type2_basic(base_conf)

        # 300片成人中老年钙片
        # 过程值：300片成人中老年钙片提醒天数
        base_conf = {
            'tag_cn_name': '过程值：300片成人中老年钙片提醒天数',
            'tag_field_name': 'buy_300',
            'tag_field_type': 'int(10)',
            'tag_field_default': '-1',
            'table_join': 'u_mid_12',
            'tag_value': 'TIMESTAMPDIFF(DAY, last_buy_300, CURDATE()) - 150',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 自定义提醒：300片成人中老年钙片
        base_conf = {
            'tag_cn_name': '300片成人中老年钙片',
            'tag_field_name': 'elderly_calcium_300',
            'table_join': 'u_mid_12',
            'table_join_field': 'buy_300',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '5'],
            '2': ['6', '15'],
            '3': ['16', '30'],
            '4': ['31', '60'],
            '5': ['61', '90'],
            '6': ['91', '']
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 新关注用户营销提醒
        # 过程值：关注时间
        base_conf = {
            'tag_cn_name': '过程值：关注时间',
            'tag_field_name': 'focus',
            'tag_field_type': 'int(4)',
            'tag_field_default': '0',
            'table_join': 'test_member_stores',
            'tag_value': ' TIMESTAMPDIFF(DAY, test_member_stores.focus_date, CURDATE())',

            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 新关注用户营销提醒
        base_conf = {
            'tag_cn_name': '新关注用户营销提醒',
            'tag_field_name': 'attention_reminder',
            'table_join': 'u_mid_12',
            'table_join_field': 'focus',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '5'],
            '2': ['6', '15'],
            '3': ['16', '30'],
            '4': ['31', '60'],
            '5': ['61', '90'],
            '6': ['91', '']
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)

        # 加购物车用户营销提醒
        # 过程值：加购物车时间
        base_conf = {
            'tag_cn_name': '过程值加购物车时间',
            'tag_field_name': 'shopping',
            'tag_field_type': 'int(4)',
            'tag_field_default': '0',
            'table_join': 'test_member_stores',
            'tag_value': 'TIMESTAMPDIFF(DAY, test_member_stores.join_shopping_date, CURDATE())',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)

        # 加购物车用户营销提醒
        base_conf = {
            'tag_cn_name': '加购物车用户营销提醒',
            'tag_field_name': 'Cart_reminder',
            'table_join': 'u_mid_12',
            'table_join_field': 'shopping',
            'case_default': '0',
        }
        when_conf = {
            '1': ['', '5'],
            '2': ['6', '15'],
            '3': ['16', '30'],
            '4': ['31', '60'],
            '5': ['61', '90'],
            '6': ['91', '']
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
