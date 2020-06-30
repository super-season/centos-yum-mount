# coding: utf-8
from string import Template

# 数据库配置
DB_CONFIG = {
    'host': '47.110.230.115',
    'port': 3306,
    'user': 'ftest',
    'password': 'wC323*&*',
    'db': 'fcmp_c_16'
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
CUSTOM_ID = 16
# 标签值表文件路径
TAG_FILE_PATH = 'C:/Users/Ben/Desktop/fcmp/道一云/标签值表-道一云-标签规则-0618-v1.csv'
# 用户标签表、用户中间值表、用户下载表名
TAG_TB_NAME = 'u_tag_16'
DLD_TB_NAME = 'u_dld_16'
MID_TB_NAME = 'u_mid_16'
# 会员表主键
MEMBER_KEY = {'customer_list': ['corpid']}
# 必显字段
DISPLAY_FIELDS = ['corp_name']

# 表关联关系
TABLE_RELATION = {
    'customer_list': [['customer_list', [['corpid', 'corpid']]]],
}

# 前置逻辑
tl_pre_001 = '''\
-- 生成客户表
drop table if exists customer_list;
CREATE TABLE `customer_list` (
`id`  bigint NOT NULL AUTO_INCREMENT COMMENT 'id' ,
`corpid`  varchar(64) NOT NULL COMMENT 'corpid' ,
`corp_name`  varchar(64) NULL COMMENT '企业名称' ,
`reg_date`  datetime NULL COMMENT '注册时间' ,
`phone`  varchar(32) NULL COMMENT '手机号码' ,
`reg_type`  varchar(32) NULL COMMENT '注册类型' ,
`fans_num`  int(11) NULL COMMENT '关注人数' ,
`order_in15`  int(11) NULL COMMENT '近15日发单' ,
`apps`  varchar(255) NULL COMMENT '托管应用' ,
`login_in15`  date NULL COMMENT '近15天最近一次后台登录' ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8mb4
;

ALTER TABLE `customer_list`
ADD INDEX `index_a` (corpid) ;

-- 将客户上传的客户表清洗、格式转换，插入到上面的客户表中
insert into customer_list (corpid, corp_name, reg_date, phone, reg_type, fans_num, order_in15, apps, login_in15)
select 
t_40_0,
t_40_1,
str_to_date(t_40_2, '%Y/%m/%d %H:%i:%s'),
t_40_3,
t_40_4,
t_40_5,
t_40_6,
t_40_7,
case 
    when t_40_8 != '' then str_to_date(t_40_8, '%Y/%c/%e') 
    else null
end
from table_16_40_201907_1
where t_40_0 is not null and trim(t_40_0) != '';

'''
