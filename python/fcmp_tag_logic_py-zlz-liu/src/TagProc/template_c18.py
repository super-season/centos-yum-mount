# coding: utf-8
from string import Template

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': '',
    'db': 'fcmp_c_18'
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
CUSTOM_ID = 18
# 标签值表文件路径
TAG_FILE_PATH = 'C:/Users/Ben/Desktop/fcmp/瑞丰茶叶c18/茶叶-研发/瑞丰茶叶-标签值表-0716-v2.1.csv'
# 用户标签表、用户中间值表、用户下载表名
TAG_TB_NAME = 'u_tag_18'
DLD_TB_NAME = 'u_dld_18'
MID_TB_NAME = 'u_mid_18'
# 会员表主键：读出到u表；加索引；
MEMBER_KEY = {'member_info': ['phone']}
# 必显字段：读出到u表；会员表主键自动加入就不用写了；
DISPLAY_FIELDS = ['member_name']

# 表关联关系
TABLE_RELATION = {
    'member_info': [['member_info', [['phone', 'phone']]]],
    'order_list': [['order_list', [['phone', 'phone']]]],
}

# 前置逻辑
tl_pre_001 = '''\
-- 生成表order_list
drop table if exists order_list;
CREATE TABLE `order_list` (
  `phone` varchar(32) DEFAULT NULL COMMENT '联系手机',
  `member_name` varchar(32) DEFAULT NULL COMMENT '买家会员名',
  `alipay` varchar(64) DEFAULT NULL COMMENT '买家支付宝账号',
  `exp_addr` varchar(255) DEFAULT NULL COMMENT '收货地址 ',
  `point_back` int(11) DEFAULT NULL COMMENT '返点积分',
  `point_pay` int(11) DEFAULT NULL COMMENT '买家支付积分',
  `pay_time` datetime DEFAULT NULL COMMENT '订单付款时间 ',
  `total_amount` decimal(11,2) DEFAULT NULL COMMENT '总金额',
  `product_title` varchar(255) DEFAULT NULL COMMENT '宝贝标题 ',
  `close_reason` varchar(64) DEFAULT NULL COMMENT '订单关闭原因'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

insert into order_list
(phone, member_name, alipay, exp_addr, point_back, point_pay, pay_time, total_amount, product_title, close_reason)
select 
t_48_18, t_48_1, t_48_2, t_48_15, t_48_9, t_48_7, if(t_48_20 = '', null, str_to_date(t_48_20, '%c/%e/%y %k:%i')), t_48_8, t_48_21, t_48_29
from table_18_48_20190712;

update order_list set phone = substr(phone, 2, 11);

ALTER TABLE `order_list`
ADD COLUMN `id`  BIGINT NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `order_list`
ADD INDEX `index_ph` (`phone`) ;

-- 提取用户表
drop table if exists member_info;
create table member_info 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户唯一标识表'
select p1.phone, o1.member_name, o1.alipay, o1.exp_addr from 
  (select p.phone, max(o.id) mi from
    (select phone, max(pay_time) pt from order_list 
    where LENGTH(phone) = 11 and (phone REGEXP '[^0-9]') = 0 and SUBSTR(phone, 1, 1) = '1'
    group by phone) p 
  left join order_list o on p.phone = o.phone and p.pt = o.pay_time
  group by p.phone) p1
left join order_list o1 on p1.mi = o1.id;

ALTER TABLE `member_info`
ADD COLUMN `id`  BIGINT NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `member_info`
ADD INDEX `index_ph` (`phone`) ;

'''

