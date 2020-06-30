# coding: utf-8
from string import Template


# 量子健康
# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': '',
    'db': 'fcmp_c_13'
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
CUSTOM_ID = 13
# 标签值表文件路径
TAG_FILE_PATH = 'C:/Users/Ben/Desktop/fcmp/数据_量子健康/【量子健康】标签值表20190523.csv'
# 用户标签表、用户中间值表、用户下载表名
TAG_TB_NAME = 'u_tag_13'
DLD_TB_NAME = 'u_dld_13'
MID_TB_NAME = 'u_mid_13'
# 会员表主键
MEMBER_KEY = {'member_info': ['phone']}
# 必显字段
DISPLAY_FIELDS = ['cname']

# 表关联关系
TABLE_RELATION = {
    'member_info': [['member_info', [['phone', 'phone']]]],
    'order_list': [['order_list', [['phone', 'phone']]]],
    't_re_order_max': [['t_re_order_max', [['phone', 'phone']]]],
    'table2': [['table1', [['u_phone', 't1_phone'], ['u_cname', 't1_cname']]],
               ['table2', [['t1_store_id', 't2_store_id']]]]
}

# 前置逻辑
tl_pre_001 = '''\
-- 合并多张销售月表为一张销售总表
drop table if exists order_list;
create table order_list
          select * from order_list_201612
union all select * from order_list_201701
union all select * from order_list_201702
union all select * from order_list_201703
union all select * from order_list_201704
union all select * from order_list_201705
union all select * from order_list_201706
union all select * from order_list_201707
union all select * from order_list_201708
union all select * from order_list_201709
union all select * from order_list_201710
union all select * from order_list_201711
union all select * from order_list_201712
union all select * from order_list_201801
union all select * from order_list_201802
union all select * from order_list_201803;

ALTER TABLE `order_list`
ADD COLUMN `id`  BIGINT NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `order_list`
ADD INDEX `index_ot` (`order_time`) ,
ADD INDEX `index_ph` (`phone`) ;

-- 提取用户表
drop table if exists member_info;
create table member_info 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户唯一标识表'
select p1.phone, o1.cname, o1.age, o1.province, o1.city, o1.district, o1.addr from 
  (select p.phone, max(o.id) mi from
    (select phone, max(order_time) odt from order_list 
    where LENGTH(phone) = 11 and (phone REGEXP '[^0-9]') = 0 and SUBSTR(phone, 1, 1) = '1'
    group by phone) p 
  left join order_list o on p.phone = o.phone and p.odt = o.order_time
  group by p.phone) p1
left join order_list o1 on p1.mi = o1.id;

ALTER TABLE `member_info`
ADD COLUMN `id`  BIGINT NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `member_info`
ADD INDEX `index_ph` (`phone`) ;

-- 数据清洗：省
update member_info set province = '内蒙古自治区' where province = '内蒙古';
update member_info set province = '广西壮族自治区' where province = '广西';
update member_info set province = '贵州省' where province = '贵州';
update member_info set province = '黑龙江省' where province = '黑龙江';
update member_info set province = '宁夏回族自治区' where province = '宁夏省';

'''

# 复购率的部分逻辑
tl_reorder_002 = '''\
-- 复购率最高产品
drop table if exists t_re_order;
CREATE TABLE `t_re_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) DEFAULT NULL,
  `cname` varchar(20) DEFAULT NULL,
  `product_cat` varchar(20) DEFAULT NULL,
  `order_times` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `index_a` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COMMENT='复购率临时表';

insert into t_re_order (phone, cname, product_cat, order_times) 
select phone, cname, '补水', product_pref_1_value from u_mid_13 where product_pref_1_value >= 2;

insert into t_re_order (phone, cname, product_cat, order_times) 
select phone, cname, '保湿', product_pref_2_value from u_mid_13 where product_pref_2_value >= 2;

insert into t_re_order (phone, cname, product_cat, order_times) 
select phone, cname, '眼霜', product_pref_6_value from u_mid_13 where product_pref_6_value >= 2;

insert into t_re_order (phone, cname, product_cat, order_times) 
select phone, cname, '倍润霜', product_pref_7_value from u_mid_13 where product_pref_7_value >= 2;

insert into t_re_order (phone, cname, product_cat, order_times) 
select phone, cname, '隔离霜', product_pref_8_value from u_mid_13 where product_pref_8_value >= 2;

insert into t_re_order (phone, cname, product_cat, order_times) 
select phone, cname, '面膜', product_pref_9_value from u_mid_13 where product_pref_9_value >= 2;

insert into t_re_order (phone, cname, product_cat, order_times) 
select phone, cname, '眼膜', product_pref_10_value from u_mid_13 where product_pref_10_value >= 2;

insert into t_re_order (phone, cname, product_cat, order_times) 
select phone, cname, '精华液', product_pref_13_value from u_mid_13 where product_pref_13_value >= 2;

insert into t_re_order (phone, cname, product_cat, order_times) 
select phone, cname, '精纯液', product_pref_14_value from u_mid_13 where product_pref_14_value >= 2;

-- 复购率最高临时表
drop table if exists t_re_order_max;
create table t_re_order_max 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='复购率最高临时表'
select b.* from
(select phone, max(order_times) ot from t_re_order group by phone) a
inner join t_re_order b
on a.phone = b.phone and a.ot = b.order_times;

ALTER TABLE `t_re_order_max`
ADD INDEX `index_ph` (`phone`) ;

'''
