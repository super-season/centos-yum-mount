# coding: utf-8
from string import Template

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': '',
    'db': 'fcmp_c_15'
}
# DB_CONFIG = {
#     'host': '47.110.230.115',
#     'port': 3306,
#     'user': 'ftest',
#     'password': 'wC323*&*',
#     'db': 'fcmp'
# }
# 相关配置
# 客户id
CUSTOM_ID = 15
# 标签值表文件路径
TAG_FILE_PATH = 'C:/Users/Ben/Desktop/fcmp/岳阳药店/岳阳药店-标签值表-v3.21.csv'
# 用户标签表、用户中间值表、用户下载表名
TAG_TB_NAME = 'u_tag_15'
DLD_TB_NAME = 'u_dld_15'
MID_TB_NAME = 'u_mid_15'
# 会员表主键：读出到u表；加索引；
MEMBER_KEY = {'member_info': ['member_id']}
# 必显字段：读出到u表；
DISPLAY_FIELDS = ['member_name', 'mobile']

# 表关联关系
TABLE_RELATION = {
    'member_info': [['member_info', [['member_id', 'member_id']]]],
    'order_list': [['order_list', [['member_id', 'member_id']]]],
    'product_info': [['order_list', [['member_id', 'member_id']]],
                     ['product_info', [['product_code', 'product_code']]]],
    'usage_info': [['order_list', [['member_id', 'member_id']]],
                   ['usage_info', [['product_code', 'product_code']]]],
}

# 前置逻辑
tl_pre_001 = '''\
-- 生成表member_info
drop table if exists member_info;
CREATE TABLE `member_info` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
  `member_id` varchar(32) DEFAULT NULL COMMENT '会员号',
  `member_name` varchar(32) DEFAULT NULL COMMENT '会员名称',
  `mobile` varchar(32) DEFAULT NULL COMMENT '移动电话',
  `gender` varchar(16) DEFAULT NULL COMMENT '性别',
  `birthday` date DEFAULT NULL COMMENT '出生日期',
  `address` varchar(255) DEFAULT NULL COMMENT '会员地址',
  `store` varchar(32) DEFAULT NULL COMMENT '门店名称',
  `member_level` int(5) DEFAULT NULL COMMENT '会员等级代号',
  `point` decimal(11,2) DEFAULT NULL COMMENT '积分',
  `register_date` date DEFAULT NULL COMMENT '办卡日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员维护表';

insert into member_info
(member_id, member_name, mobile, gender, birthday, address, store, member_level, point, register_date)
select 
t_43_2, t_43_3, t_43_22, t_43_6, if(t_43_20 = '', null, str_to_date(t_43_20, '%Y%m%d')), t_43_4, t_43_19, t_43_13, t_43_14, if(t_43_15 = '', null, str_to_date(t_43_15, '%Y%m%d'))
from table_15_43_201907_1;

ALTER TABLE `member_info`
ADD INDEX `index_a` (member_id) ;

-- 生成表order_list
drop table if exists order_list;
CREATE TABLE `order_list` (
  `member_id` varchar(32) DEFAULT NULL COMMENT '会员卡号',
  `amount` decimal(11,2) DEFAULT NULL COMMENT '金额',
  `store` varchar(32) DEFAULT NULL COMMENT '门店',
  `product_code` varchar(32) DEFAULT NULL COMMENT '品种代号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员销售记录表';

insert into order_list
(member_id, amount, store, product_code)
select 
t_46_18, t_46_9, t_46_1, t_46_2
from table_15_46_20190712;

-- 为每个月的会员销售记录表添加购买日期，为上个月1日
alter table order_list add column order_time date default null comment '购买日期';
update order_list set order_time = date(20190601);

ALTER TABLE `order_list`
ADD INDEX `index_a` (member_id) ;

-- 生成表product_info
drop table if exists product_info;
CREATE TABLE `product_info` (
  `product_code` varchar(32) DEFAULT NULL COMMENT '代号',
  `type_name` varchar(32) DEFAULT NULL COMMENT '类别名称',
  `product_name` varchar(256) DEFAULT NULL COMMENT '品名'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='品名基础资料表';

insert into product_info
(product_code, type_name, product_name)
select 
t_47_1, t_47_2, t_47_3
from table_15_47_20190712;

ALTER TABLE `product_info`
ADD INDEX `index_a` (product_code) ;

-- 生成表usage_info
drop table if exists usage_info;
CREATE TABLE `usage_info` (
  `product_code` varchar(32) DEFAULT NULL COMMENT '商品代号',
  `take_cycle` int(11) DEFAULT NULL COMMENT '周期'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='药品用法用量汇总表';

insert into usage_info
(product_code, take_cycle)
select 
t_41_0, if(t_41_6 = '', null, substring_index(t_41_6, '天', 1))
from table_15_41_20190710;

ALTER TABLE `usage_info`
ADD INDEX `index_a` (product_code) ;

'''

