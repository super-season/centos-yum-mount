# coding: utf-8
from string import Template

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': 'zlz3.14!',
    'db': 'fcmp_c_20'
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
CUSTOM_ID = 20
# 标签值表文件路径
TAG_FILE_PATH = 'E:/原力产品/中大树华/标签值表-中大树华-标签规则-0618-v1.csv'
# 用户标签表、用户中间值表、用户下载表名
TAG_TB_NAME = 'u_tag_20'
DLD_TB_NAME = 'u_dld_20'
MID_TB_NAME = 'u_mid_20'
# 会员表主键：读出到u表；加索引；
MEMBER_KEY = {'customer_list': ['customer_list_id']}
# 必显字段：读出到u表；会员表主键自动加入就不用写了；
DISPLAY_FIELDS = ['member_name', 'phone']

# 表关联关系
TABLE_RELATION = {
    'customer_list': [['customer_list', [['customer_list_id', 'customer_list_id']]]],
}

# 前置逻辑
tl_pre_001 = '''\
-- 生成表customer_list
drop table if exists customer_list;
CREATE TABLE `customer_list` (
  `customer_list_id` bigint NOT NULL AUTO_INCREMENT COMMENT 'customer_list_id 主键' ,
  `phone` varchar(32) DEFAULT NULL COMMENT '联系手机',
  `member_name` varchar(32) DEFAULT NULL COMMENT '会员名',
  `class_time` varchar(64) DEFAULT NULL COMMENT '上课时间',
  `class_name` varchar(255) DEFAULT NULL COMMENT '课程名称 ',
  `class_hour` int(11) DEFAULT NULL COMMENT '课程总课时',
  `remaining_hours` int(11) DEFAULT NULL COMMENT '剩余课时',
  `gender` varchar(16) DEFAULT NULL COMMENT '性别',
  `birthday` date DEFAULT NULL COMMENT '出生日期',
  PRIMARY KEY (`customer_list_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户信息表';

ALTER TABLE `customer_list`
ADD INDEX `index_a` (phone) ;

insert into customer_list
(class_time, class_name, member_name, phone, class_hour, remaining_hours, gender, birthday)
select 
t_68_1, t_68_4, t_68_3, t_68_5, t_68_6, if(t_68_7 = '', null, t_68_7), if(t_68_8 = '', null, t_68_8), t_68_9
from table_20_68_20190808;

'''

