# coding: utf-8
from string import Template

# 数据库配置
DB_CONFIG = {
    'host': '192.168.0.78',
    'port': 3306,
    'user': 'somebody',
    'password': 'zlz3.14!',
    'db': 'fcmp_liu'
}
#DB_CONFIG = {
#     'host': '47.110.230.115',
#     'port': 3306,
#     'user': 'ftest',
#     'password': 'wC323*&*',
#     'db': 'fcmp'
# }
# 相关配置
# 客户id
CUSTOM_ID = 12
# 标签值表文件路径
TAG_FILE_PATH = 'F:/工作/FCMP项目python/模拟数据-v2练习资料/测试数据-标签值表0306.csv'
MAMA_FILE_PATH = 'E:/原力产品/天爱数据/妈妈网推广7-8.csv'
# 用户标签表、用户中间值表、用户下载表名
TAG_TB_NAME = 'u_tag_12'
DLD_TB_NAME = 'u_dld_12'
MID_TB_NAME = 'u_mid_12'
# 会员表主键
MEMBER_KEY = {'test_member_stores': ['name','phone']}
# 必显字段
DISPLAY_FIELDS = ['null dis']

# 表关联关系,u_tag 和其它表字段的的关联关系
TABLE_RELATION = {
    'test_member_stores': [['test_member_stores', [['name', 'name'], ['phone', 'phone']]]],
    'test_sales_summary': [['test_sales_summary', [['name', 'name'], ['phone', 'phone']]]],
    'test_product_detail': [['test_product_detail', [['product_ID', 'product_ID']]]],
    # 'interview_info': [['interview_info', [['patient_name', 'patient_name'], ['phone', 'phone']]]],
    # 'sign_card_manage': [['sign_card_manage', [['patient_name', 'baby_name'], ['phone', 'card_no']]]],
    # 'time_card_manage': [['time_card_manage', [['patient_name', 'baby_name'], ['phone', 'card_no']]]],
    # 'teeth_card_manage': [['teeth_card_manage', [['patient_name', 'baby_name'], ['phone', 'card_no']]]],
    # 't_iv_erke_doctor': [['t_iv_erke_doctor', [['id', 'uid']]]],
    # 't_iv_chike_doctor': [['t_iv_chike_doctor', [['id', 'uid']]]],
    # 't_iv_zhuanke_doctor': [['t_iv_zhuanke_doctor', [['id', 'uid']]]],
    # 'promotion_sale_report': [['promotion_sale_report', [['patient_name', 'baby_name'], ['phone', 'phone']]]],
    # 't_all_card_manage': [['t_all_card_manage', [['id', 'uid']]]],
    # 'new_costumer_list': [['new_costumer_list', [['patient_name', 'baby_name'], ['phone', 'phone']]]],
    # 'member_mama_5_6': [['member_mama_5_6', [['patient_name', 'name'], ['phone', 'phone']]]],
    # 'member_mama_7_8': [['member_mama_7_8', [['patient_name', 'name'], ['phone', 'phone']]]],
}
#已生成12月第2周
member_info_table_name = 'table_12_52_201912_2'
patient_info_table_name = 'table_12_49_201912_2'
interview_info_gd_table_name = 'table_12_53_201912_2'
interview_info_nh_table_name = 'table_12_54_201912_2'
health_card_manage_table_name = 'table_12_57_201912_2'
sign_card_manage_table_name = 'table_12_56_201912_2'
time_card_manage_table_name = 'table_12_58_201912_2'
teeth_card_manage_table_name = 'table_12_70_201912_2'
new_costumer_list_table_name_gd = 'table_12_50_201912_2'
new_costumer_list_table_name_nh = 'table_12_55_201912_2'

# 前置逻辑
tl_pre_001 = '''\

-- 生成表new_costumer_list数据
drop table if exists new_costumer_list;
CREATE TABLE IF NOT EXISTS `new_costumer_list` (#判断这张表是否存在，若存在，则跳过创建表操作，
  `baby_name` varchar(32) DEFAULT NULL COMMENT '宝宝姓名',
  `phone` varchar(16) DEFAULT NULL COMMENT '手机号码',
  `source_type` varchar(32) DEFAULT NULL COMMENT '来源分类'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into new_costumer_list
(baby_name, phone, source_type)
select 
 t_50_5, t_50_4, t_50_13
from ''' + new_costumer_list_table_name_gd + ''';

insert into new_costumer_list
(baby_name, phone, source_type)
select 
 t_55_5, t_55_4, t_55_13
from ''' + new_costumer_list_table_name_nh + ''';

-- 生成表member_info数据
drop table if exists member_info;
CREATE TABLE IF NOT EXISTS `member_info` (#判断这张表是否存在，若存在，则跳过创建表操作，
  `member_name` varchar(32) DEFAULT NULL COMMENT '姓名',
  `phone` varchar(16) DEFAULT NULL COMMENT '手机号码',
  `member_type_from_member` varchar(32) DEFAULT NULL COMMENT '会员类型',
  `status` varchar(8) DEFAULT NULL COMMENT '状态',
  `expire_date` varchar(16) DEFAULT NULL COMMENT '到期日期',
  `total_consume` decimal(12,2) DEFAULT NULL COMMENT '累计消费',
  `blance` decimal(12,2) DEFAULT NULL COMMENT '储蓄余额',
  `total_saving` decimal(12,2) DEFAULT NULL COMMENT '累计储值',
  `point` int(11) DEFAULT NULL COMMENT '积分'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into member_info
(member_name, phone, member_type_from_member, status, expire_date, total_consume, blance, total_saving, point)
select 
t_52_0, t_52_1, t_52_2, t_52_3, t_52_4, t_52_5, IF(t_52_6 > 0,t_52_6, 0), t_52_7, t_52_8
from ''' + member_info_table_name + ''';

-- 生成表patient_info数据
drop table if exists patient_info;

CREATE TABLE IF NOT EXISTS `patient_info` (#判断这张表是否存在，若存在，则跳过创建表操作，
  `patient_name` varchar(32) DEFAULT NULL COMMENT '患者姓名',
  `file_no` varchar(16) DEFAULT NULL COMMENT '病案号',
  `birthday` date DEFAULT NULL COMMENT '出生年月',
  `sex` varchar(8) DEFAULT NULL COMMENT '性别',
  `phone` varchar(16) DEFAULT NULL COMMENT '手机号',
  `email` varchar(32) DEFAULT NULL COMMENT '邮箱',
  `member_type_from_patient` varchar(32) DEFAULT NULL COMMENT '会员类型',
  `id_card` varchar(24) DEFAULT NULL COMMENT '身份证号',
  `marital_status` varchar(16) DEFAULT NULL COMMENT '婚姻状况',
  `nation` varchar(8) DEFAULT NULL COMMENT '民族',
  `job` varchar(32) DEFAULT NULL COMMENT '职业',
  `workplace` varchar(100) DEFAULT NULL COMMENT '工作单位',
  `address` varchar(100) DEFAULT NULL COMMENT '地址',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `source` varchar(32) DEFAULT NULL COMMENT '患者来源',
  `card_no` varchar(255) DEFAULT NULL COMMENT '病人卡号',
  `tag` varchar(64) DEFAULT NULL COMMENT '患者标签',
  `wechat_no` varchar(32) DEFAULT NULL COMMENT '微信号'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into patient_info
(patient_name, file_no, birthday, sex, phone, email, member_type_from_patient, id_card, marital_status, nation, job, workplace, address, remark, source, card_no, tag, wechat_no)
select 
*
from ''' + patient_info_table_name + ''';

-- 生成表member_patient_info
drop table if exists member_patient_info;
create table member_patient_info
select 
    pi.*,
    mi.member_type_from_member,
    mi.status,
    mi.expire_date,
    mi.total_consume,
    mi.blance,
    mi.total_saving,
    mi.point
from 
    patient_info pi 
left join 
    member_info mi
on
    md5(CONCAT(pi.patient_name,SUBSTR(pi.phone,1,3),SUBSTR(pi.phone,8))) = md5(CONCAT(mi.member_name,SUBSTR(mi.phone,1,3),SUBSTR(mi.phone,8)));
-- 添加关联字段
alter table member_patient_info add column union_id varchar(128) first;
update member_patient_info set union_id = md5(concat(patient_name,phone));
-- 删除关联字段为空的记录
delete from member_patient_info where union_id is null or trim(union_id) = '';
-- 添加主键（唯一标识）
alter table member_patient_info add column kid bigint primary key auto_increment not null first;
-- 数据去重（去重规则：union_id重复的记录为重复记录，保留kid最大的一条，其他删除）
delete 
    member_patient_info
from 
    member_patient_info,
    (
        select 
            max(kid) kid,
            union_id
        from 
            member_patient_info
        group by 
            union_id
        having 
            count(union_id) > 1
    ) t
where 
    member_patient_info.union_id = t.union_id
and 
    member_patient_info.kid < t.kid;

ALTER TABLE `member_patient_info`
ADD INDEX `index_a` (patient_name, phone) ;

'''

# 医生偏好的几张临时表
tl_doctor_002 = '''\
-- 生成表interview_info
CREATE TABLE IF NOT EXISTS `interview_info` (#判断这张表是否存在，若存在，则跳过创建表操作，
  `interview_date` date DEFAULT NULL COMMENT '就诊日期',
  `department` int(11) DEFAULT NULL COMMENT '门诊号',
  `patient_name` varchar(32) DEFAULT NULL COMMENT '患者姓名',
  `sex` varchar(8) DEFAULT NULL COMMENT '性别',
  `age` varchar(10) DEFAULT NULL COMMENT '年龄',
  `phone` varchar(16) DEFAULT NULL COMMENT '手机号码',
  `job` varchar(16) DEFAULT NULL COMMENT '职业',
  `address` varchar(100) DEFAULT NULL COMMENT '地址',
  `workplace` varchar(50) DEFAULT NULL COMMENT '工作单位',
  `sick_date` date DEFAULT NULL COMMENT '发病日期',
  `initial_dia` varchar(255) DEFAULT NULL COMMENT '初步诊断',
  `interview_type` varchar(24) DEFAULT NULL COMMENT '接诊类型',
  `sign_department` varchar(32) DEFAULT NULL COMMENT '登记科室',
  `sign_worker` varchar(16) DEFAULT NULL COMMENT '登记人员',
  `nurse` varchar(16) DEFAULT NULL COMMENT '护士姓名',
  `doctor` varchar(16) DEFAULT NULL COMMENT '接诊医生',
  `summary` varchar(100) DEFAULT NULL COMMENT '体检小结',
  `advice` text COMMENT '治疗意见',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `store` varchar(16) DEFAULT NULL COMMENT '门店'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 增量数据--高德
insert into interview_info
(interview_date, department, patient_name, sex, age, phone, job, address, workplace, sick_date, initial_dia, interview_type, sign_department, sign_worker, nurse, doctor, summary, advice, remark, store)
select 
t_53_0, t_53_1, t_53_2, t_53_3, t_53_4, t_53_5, t_53_6, t_53_7, t_53_8, IF(t_53_9 = '','1970-01-01', t_53_9), t_53_10, t_53_11, t_53_12, t_53_13, t_53_14, t_53_15, t_53_16, t_53_17, t_53_18, '高德'
from ''' + interview_info_gd_table_name + ''';

-- 增量数据--南海
insert into interview_info
(interview_date, department, patient_name, sex, age, phone, job, address, workplace, sick_date, initial_dia, interview_type, sign_department, sign_worker, nurse, doctor, summary, advice,remark, store)
select 
t_54_0, t_54_1, t_54_2, t_54_3, t_54_4, t_54_5, t_54_6, t_54_7, t_54_8, IF(t_54_9 = '','1970-01-01', t_54_9), t_54_10, t_54_11, t_54_12, t_54_13, t_54_14, t_54_15, t_54_16, t_54_17, t_54_18, '南海'
from ''' + interview_info_nh_table_name + ''';

-- 建interview_info表的副本
drop table if exists t_interview_info_t;
create table t_interview_info_t like  interview_info;
insert into t_interview_info_t select * from interview_info;

-- 数据替换：将“口腔筛查师”替换为“庾佩芬”
update t_interview_info_t
set doctor = '庾佩芬'
where doctor = '口腔筛查师';

-- 建表：儿科问诊记录中各医生的问诊次数
drop table if exists t_iv_erke_doctor;
create table t_iv_erke_doctor
select u.id uid, i.doctor, count(*) c
from u_tag_12 u left join t_interview_info_t i
on u.patient_name = i.patient_name and u.phone = i.phone
where i.doctor in ('古锐', '肖雪', '梁妤婷', '李莉', '贺亮', '朱晓华', '张庭艳')
and (i.sign_department like '%儿童保健%' or i.sign_department like '%儿童全科%' or i.sign_department like '%儿科全科门诊%')
group by u.id, i.doctor;

ALTER TABLE `t_iv_erke_doctor`
ADD COLUMN `id`  int(11) NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `t_iv_erke_doctor`
ADD INDEX `index_a` (`uid`) ;

-- 删除一些行，仅保留问诊次数最大值的那些行
delete 
    t_iv_erke_doctor
from 
    t_iv_erke_doctor left join
    (
        select 
            uid,
            max(c) maxc
        from 
            t_iv_erke_doctor
        group by 
            uid
    ) t
    on t_iv_erke_doctor.uid = t.uid
where 
    t_iv_erke_doctor.c < t.maxc;

-- 建表：齿科问诊记录中各医生的问诊次数
drop table if exists t_iv_chike_doctor;
create table t_iv_chike_doctor
select u.id uid, i.doctor, count(*) c
from u_tag_12 u left join t_interview_info_t i
on u.patient_name = i.patient_name and u.phone = i.phone
where i.doctor in ('张栋杰', '申丽妮', '庾佩芬')
and (i.sign_department like '%儿童齿科%' or i.sign_department like '%儿童洁牙%'
 or i.sign_department like '%涂氟%' or i.sign_department like '%儿童口腔科%')
group by u.id, i.doctor;

ALTER TABLE `t_iv_chike_doctor`
ADD COLUMN `id`  int(11) NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `t_iv_chike_doctor`
ADD INDEX `index_a` (`uid`) ;

-- 删除一些行，仅保留问诊次数最大值的那些行
delete 
    t_iv_chike_doctor
from 
    t_iv_chike_doctor left join
    (
        select 
            uid,
            max(c) maxc
        from 
            t_iv_chike_doctor
        group by 
            uid
    ) t
    on t_iv_chike_doctor.uid = t.uid
where 
    t_iv_chike_doctor.c < t.maxc;
    
-- 建表：专科问诊记录中各医生的问诊次数
drop table if exists t_iv_zhuanke_doctor;
create table t_iv_zhuanke_doctor
select u.id uid, i.doctor, count(*) c
from u_tag_12 u left join t_interview_info_t i
on u.patient_name = i.patient_name and u.phone = i.phone
where i.doctor in ('王小亚', '王弘', '翟莺莺', '陈亦阳', '龙秀胜', '郭梦翔', '罗育武', '陶佳',
 '喻宁芬', '王馨', '王建勋', '崔咏怡', '宁书尧', '李志斌', '杨思达', '徐宁', '金颖康',
 '沈振宇', '郭嘉', '林康广')
and (i.sign_department not like '%儿童保健%' and i.sign_department not like '%儿童全科%'
 and i.sign_department not like '%儿科全科门诊%' and i.sign_department not like '%儿童齿科%'
 and i.sign_department not like '%儿童洁牙%' and i.sign_department not like '%涂氟%'
 and i.sign_department not like '%儿童口腔科%')
group by u.id, i.doctor;

ALTER TABLE `t_iv_zhuanke_doctor`
ADD COLUMN `id`  int(11) NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `t_iv_zhuanke_doctor`
ADD INDEX `index_a` (`uid`) ;

-- 删除一些行，仅保留问诊次数最大值的那些行
delete 
    t_iv_zhuanke_doctor
from 
    t_iv_zhuanke_doctor left join
    (
        select 
            uid,
            max(c) maxc
        from 
            t_iv_zhuanke_doctor
        group by 
            uid
    ) t
    on t_iv_zhuanke_doctor.uid = t.uid
where 
    t_iv_zhuanke_doctor.c < t.maxc;
    
'''

# 首次购买产品临时表
tl_first_buy_003 = '''\
-- 建表：首次购买产品合表
drop table if exists t_all_card_manage;
CREATE TABLE `t_all_card_manage` (
  `baby_name` varchar(32) CHARACTER SET utf8 DEFAULT NULL COMMENT '宝宝1姓名',
  `phone` varchar(32) CHARACTER SET utf8 DEFAULT NULL COMMENT '卡号（手机号码）',
  `buy_date` date DEFAULT NULL COMMENT '购买日期',
  `card_type` varchar(64) NOT NULL DEFAULT '',
  `table_type` varchar(16) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
'''
if health_card_manage_table_name != '':
    tl_first_buy_003 += '''-- 生成充值管理表：health_card_manage
CREATE TABLE IF NOT EXISTS `health_card_manage` (#判断这张表是否存在，若存在，则跳过创建表操作，
  `identify` varchar(16) DEFAULT NULL COMMENT '编号',
  `buy_date` date DEFAULT NULL COMMENT '购买日期',
  `store` varchar(16) DEFAULT NULL COMMENT '门店',
  `recharge_amount` decimal(12,2) DEFAULT NULL COMMENT '充值金额（购买价格）',
  `discount` varchar(120) DEFAULT NULL COMMENT '优惠政策',
  `amount_to_card` decimal(12,2) DEFAULT NULL COMMENT '充值到账金额',
  `stage` varchar(16) DEFAULT NULL COMMENT '前台经手人',
  `receipt_channel` varchar(32) DEFAULT NULL COMMENT '收款平台',
  `card_no` varchar(32) DEFAULT NULL COMMENT '卡号（手机号码）',
  `parent` varchar(32) DEFAULT NULL COMMENT '家长姓名',
  `baby1` varchar(32) DEFAULT NULL COMMENT '宝宝1姓名',
  `sex1` varchar(8) DEFAULT NULL COMMENT '宝宝1性别',
  `baby2` varchar(32) DEFAULT NULL COMMENT '宝宝2姓名',
  `sex2` varchar(8) DEFAULT NULL COMMENT '宝宝2性别',
  `baby3` varchar(32) DEFAULT NULL COMMENT '宝宝3姓名',
  `sex3` varchar(8) DEFAULT NULL COMMENT '宝宝3性别',
  `baby4` varchar(32) DEFAULT NULL COMMENT '宝宝4姓名',
  `sex4` varchar(8) DEFAULT NULL COMMENT '宝宝4性别'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 增量数据--充值管理表
insert into health_card_manage
(identify, buy_date, store, recharge_amount, discount, amount_to_card, stage, receipt_channel, card_no, parent, baby1, sex1, baby2, sex2, baby3, sex3, baby4, sex4)
select 
 null, t_57_0, t_57_1, replace(replace(t_57_2, '¥', ''), ',', ''), t_57_3,  replace(replace(t_57_4, '¥', ''), ',', ''), t_57_6, t_57_7, t_57_9, t_57_10, t_57_11, t_57_12, t_57_14, t_57_15, t_57_17, t_57_18, t_57_20, t_57_21
from ''' + health_card_manage_table_name + ''';

insert into t_all_card_manage
select baby1, card_no, buy_date, '', '充值管理表'
from health_card_manage;'''
if sign_card_manage_table_name != '':
    tl_first_buy_003 += '''-- 生成签约管理表：sign_card_manage
CREATE TABLE IF NOT EXISTS `sign_card_manage` (#判断这张表是否存在，若存在，则跳过创建表操作，
  `identify` varchar(16) DEFAULT NULL COMMENT '编号',
  `buy_date` date DEFAULT NULL COMMENT '购买日期',
  `store` varchar(16) DEFAULT NULL COMMENT '门店(新表字段)',
  `card_type` varchar(32) DEFAULT NULL COMMENT '卡类别',
  `year_limit` int(8) DEFAULT NULL COMMENT '年限（新表字段）',
  `discount` varchar(120) DEFAULT NULL COMMENT '优惠政策',
  `price` decimal(12,2) DEFAULT NULL COMMENT '购买价格（元）',
  `stage` varchar(16) DEFAULT NULL COMMENT '前台经手人',
  `receipt_channel` varchar(32) DEFAULT NULL COMMENT '收款渠道(新表字段)',
  `card_no` varchar(32) DEFAULT NULL COMMENT '卡号（手机号码）',
  `parent` varchar(32) DEFAULT NULL COMMENT '家长姓名',
  `baby_name` varchar(32) DEFAULT NULL COMMENT '宝宝姓名',
  `sex` varchar(8) DEFAULT NULL COMMENT '性别',
  `source` varchar(32) DEFAULT NULL COMMENT '客户来源分类(新表字段)',
  `source_info` varchar(64) DEFAULT NULL COMMENT '客户来源详情（新表字段）',
  `sale_activity` varchar(64) DEFAULT NULL COMMENT '参与营销活动（新表字段）',
  `package_enable_date` varchar(32) DEFAULT NULL COMMENT '套餐启用日期(新表字段)',
  `expire` date DEFAULT NULL COMMENT '套餐有限期',
  `child_sub_time` varchar(64) DEFAULT NULL COMMENT '儿保/全科次数(新表字段)',
  `sign_doctor` varchar(16) DEFAULT NULL COMMENT '签约医生',
  `add_helper` varchar(32) DEFAULT NULL COMMENT '添加小助手',
  `ticket_date` varchar(32) DEFAULT NULL COMMENT '卡券发送日期',
  `gift_date` varchar(32) DEFAULT NULL COMMENT '礼盒赠送日期',
  `build_visit` varchar(64) DEFAULT NULL COMMENT '建立到期随访',
  `note_phone_date` varchar(64) DEFAULT NULL COMMENT '电话号码录入日期'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 增量数据--签约管理表
insert into sign_card_manage
(identify, buy_date, store, card_type, year_limit, discount, price, stage, receipt_channel, card_no, parent, baby_name, sex, source, source_info, sale_activity, 
package_enable_date, expire, child_sub_time, sign_doctor, add_helper, ticket_date, gift_date, build_visit, note_phone_date)
select 
null, t_56_0, t_56_1, t_56_2, t_56_3, t_56_4, replace(replace(t_56_5, '¥', ''), ',', ''), t_56_6, t_56_7, t_56_9, t_56_10, t_56_11, t_56_12, t_56_14, t_56_15, t_56_16, IF(t_56_18 = '', '1970-01-01', t_56_18), IF(t_56_19 = '', '1970-01-01', t_56_19), t_56_20, t_56_21, t_56_23, t_56_24, t_56_25, t_56_26, t_56_27
from ''' + sign_card_manage_table_name  + ''';

insert into t_all_card_manage
select baby_name, card_no, buy_date, card_type, '签约管理表'
from sign_card_manage;'''

if time_card_manage_table_name != '':
    tl_first_buy_003 += '''-- 生成次卡管理表：time_card_manage
CREATE TABLE IF NOT EXISTS `time_card_manage` (#判断这张表是否存在，若存在，则跳过创建表操作，
  `identify` varchar(16) DEFAULT NULL COMMENT '编号',
  `buy_date` date DEFAULT NULL COMMENT '购买日期',
  `store` varchar(16) DEFAULT NULL COMMENT '门店',
  `card_type` varchar(32) DEFAULT NULL COMMENT '产品名称',
  `discount` varchar(64) DEFAULT NULL COMMENT '优惠政策',
  `price` decimal(12,2) DEFAULT NULL COMMENT '实收价格（元）',
  `stage` varchar(16) DEFAULT NULL COMMENT '前台经手人',
  `receipt_channel` varchar(32) DEFAULT NULL COMMENT '收款平台',
  `card_no` varchar(32) DEFAULT NULL COMMENT '卡号（手机号码）',
  `baby_name` varchar(32) DEFAULT NULL COMMENT '宝宝姓名',
  `sex` varchar(8) DEFAULT NULL COMMENT '性别'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 增量数据--次卡管理表
insert into time_card_manage
(identify, buy_date, store, card_type, discount, price, stage, receipt_channel, card_no, baby_name, sex)
select 
 null, t_58_0, t_58_1, t_58_2, t_58_3, replace(replace(t_58_4, '¥', ''), ',', ''), t_58_5, t_58_6, t_58_9, t_58_11, t_58_12
from ''' + time_card_manage_table_name + ''';

insert into t_all_card_manage
select baby_name, card_no, buy_date, card_type, '次卡管理表'
from time_card_manage;'''

if teeth_card_manage_table_name != '':
    tl_first_buy_003 += '''-- 生成齿科套餐管理表：teeth_card_manage
CREATE TABLE IF NOT EXISTS `teeth_card_manage` (#判断这张表是否存在，若存在，则跳过创建表操作，
  `buy_date` date DEFAULT NULL COMMENT '购买日期',
  `store` varchar(16) DEFAULT NULL COMMENT '门店',
  `card_type` varchar(32) DEFAULT NULL COMMENT '产品名称',
  `discount` varchar(64) DEFAULT NULL COMMENT '优惠政策',
  `price` decimal(12,2) DEFAULT NULL COMMENT '实收价格（元）',
  `stage` varchar(16) DEFAULT NULL COMMENT '前台经手人',
  `receipt_channel` varchar(32) DEFAULT NULL COMMENT '收款平台',
  `customer_identity` varchar(32) DEFAULT NULL COMMENT '客户身份',
  `card_no` varchar(32) DEFAULT NULL COMMENT '卡号（手机号码）',
  `parent` varchar(32) DEFAULT NULL,
  `baby_name` varchar(32) DEFAULT NULL COMMENT '宝宝姓名',
  `sex` varchar(8) DEFAULT NULL COMMENT '性别'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 增量数据--齿科套餐管理表
insert into teeth_card_manage
(buy_date, store, card_type, discount, price, stage, receipt_channel, customer_identity, card_no, parent, baby_name, sex)
select 
t_70_0, t_70_1, t_70_2, t_70_3, replace(t_70_4, ',', ''), t_70_5, t_70_6, t_70_7, t_70_8, '', t_70_10, t_70_11
from ''' + teeth_card_manage_table_name + ''';

insert into t_all_card_manage
select baby_name, card_no, buy_date, card_type, '齿科套餐管理表'
from teeth_card_manage;'''

tl_first_buy_003 += '''\
ALTER TABLE t_all_card_manage
ADD INDEX `index_a`(`baby_name`, `phone`);

-- 增添用户ID字段
alter table t_all_card_manage add column uid int(11) default 0 comment '对应于tag表中的id';

update t_all_card_manage t
left join u_tag_12 u
on t.baby_name = u.patient_name and t.phone = u.phone
set t.uid = u.id;

-- 删除一些行，仅保留日期最早购买的那些行
delete 
    t_all_card_manage
from 
    t_all_card_manage left join
    (
        select 
            uid,
            min(buy_date) min_d
        from 
            t_all_card_manage
        group by 
            uid
    ) t
    on t_all_card_manage.uid = t.uid
where 
    t_all_card_manage.buy_date > t.min_d;

'''
