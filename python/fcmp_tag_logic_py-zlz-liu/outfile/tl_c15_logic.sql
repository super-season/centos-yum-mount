-- ----------------------------------
-- 客户15标签逻辑 2019-07-15 22:25:14
-- ----------------------------------
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

-- 生成tag表，含必显字段
drop table if exists u_tag_15;
create table u_tag_15 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户标签表'
select 
    member_id, member_name, mobile
from 
    member_info;
    
ALTER TABLE `u_tag_15`
ADD COLUMN `id`  int(11) NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `u_tag_15`
ADD INDEX `index_a` (member_id) ;

-- 生成dld表
drop table if exists u_dld_15;
create table u_dld_15 like  u_tag_15;
insert into u_dld_15 select * from u_tag_15;

ALTER TABLE `u_dld_15`
COMMENT='用户下载表';

-- 生成mid表
drop table if exists u_mid_15;
create table u_mid_15 like  u_tag_15;
insert into u_mid_15 select * from u_tag_15;

ALTER TABLE `u_mid_15`
COMMENT='用户中间值表';

-- ----------------------------------
--            标签逻辑-标签表
-- ----------------------------------
-- -----------一级标签 基本信息-----------
-- b_1301_tag_type1_case_map
-- 性别
alter table u_tag_15 add column t_u_gender int(5) default 0 comment '性别';

update u_tag_15 
left join member_info 
on u_tag_15.member_id = member_info.member_id
set u_tag_15.t_u_gender = 
case
when member_info.gender = '男' then 1
when member_info.gender = '女' then 2
else 0 end;

-- b_2002_mid_type1_where
-- 过程值：年龄
alter table u_mid_15 add column age_year int(10) default null comment '过程值：年龄';

update u_mid_15 
left join member_info 
on u_mid_15.member_id = member_info.member_id
set u_mid_15.age_year = TIMESTAMPDIFF(YEAR, member_info.birthday, CURDATE())
where true;

-- b_1101_tag_type1_case_between
-- 年龄
alter table u_tag_15 add column t_u_age int(5) default 0 comment '年龄';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_age = 
case
when u_mid_15.age_year <= 17 then 1
when u_mid_15.age_year >= 18 and u_mid_15.age_year <= 23 then 2
when u_mid_15.age_year >= 24 and u_mid_15.age_year <= 27 then 3
when u_mid_15.age_year >= 28 and u_mid_15.age_year <= 30 then 4
when u_mid_15.age_year >= 31 and u_mid_15.age_year <= 35 then 5
when u_mid_15.age_year >= 36 and u_mid_15.age_year <= 40 then 6
when u_mid_15.age_year >= 41 and u_mid_15.age_year <= 45 then 7
when u_mid_15.age_year >= 46 and u_mid_15.age_year <= 50 then 8
when u_mid_15.age_year >= 51 and u_mid_15.age_year <= 55 then 9
when u_mid_15.age_year >= 56 and u_mid_15.age_year <= 60 then 10
when u_mid_15.age_year >= 61 and u_mid_15.age_year <= 65 then 11
when u_mid_15.age_year >= 66 and u_mid_15.age_year <= 70 then 12
when u_mid_15.age_year >= 71 then 13
else 0 end;

-- b_1201_tag_type1_case_where
-- 地址
alter table u_tag_15 add column t_u_address int(5) default 0 comment '地址';

update u_tag_15 
left join member_info 
on u_tag_15.member_id = member_info.member_id
set u_tag_15.t_u_address = 
case
when member_info.address like '%上海%' then 1
when member_info.address like '%云南%' then 2
when member_info.address like '%内蒙%' then 3
when member_info.address like '%北京%' then 4
when member_info.address like '%吉林%' then 5
when member_info.address like '%四川%' then 6
when member_info.address like '%天津%' then 7
when member_info.address like '%宁夏%' then 8
when member_info.address like '%安徽%' then 9
when member_info.address like '%山东%' then 10
when member_info.address like '%山西%' then 11
when member_info.address like '%广东%' then 12
when member_info.address like '%广西%' then 13
when member_info.address like '%新疆%' then 14
when member_info.address like '%江苏%' then 15
when member_info.address like '%江西%' then 16
when member_info.address like '%河北%' then 17
when member_info.address like '%河南%' then 18
when member_info.address like '%浙江%' then 19
when member_info.address like '%海南%' then 20
when member_info.address like '%湖北%' then 21
when member_info.address like '%湖南%' then 22
when member_info.address like '%甘肃%' then 23
when member_info.address like '%福建%' then 24
when member_info.address like '%西藏%' then 25
when member_info.address like '%贵州%' then 26
when member_info.address like '%辽宁%' then 27
when member_info.address like '%重庆%' then 28
when member_info.address like '%陕西%' then 29
when member_info.address like '%青海%' then 30
when member_info.address like '%黑龙江%' then 31
else 0 end;

-- b_1301_tag_type1_case_map
-- 来源门店
alter table u_tag_15 add column t_u_store int(5) default 0 comment '来源门店';

update u_tag_15 
left join member_info 
on u_tag_15.member_id = member_info.member_id
set u_tag_15.t_u_store = 
case
when member_info.store = '步行街店' then 1
when member_info.store = '东升店' then 2
when member_info.store = '六中店' then 3
when member_info.store = '东方店' then 4
when member_info.store = '长兴店' then 5
else 0 end;

-- b_1301_tag_type1_case_map
-- 会员类型
alter table u_tag_15 add column t_u_member_type int(5) default 0 comment '会员类型';

update u_tag_15 
left join member_info 
on u_tag_15.member_id = member_info.member_id
set u_tag_15.t_u_member_type = 
case
when member_info.member_level = '1' then 1
when member_info.member_level = '2' then 2
when member_info.member_level = '7' then 3
when member_info.member_level = '8' then 4
when member_info.member_level = '9' then 5
else 0 end;

-- b_2001_tag_type1_where
-- 是否生日月
alter table u_tag_15 add column t_u_birth_month int(5) default 0 comment '是否生日月';

update u_tag_15 
left join member_info 
on u_tag_15.member_id = member_info.member_id
set u_tag_15.t_u_birth_month = 1
where month(member_info.birthday) =  month(now());

-- b_1101_tag_type1_case_between
-- 积分余额
alter table u_tag_15 add column t_u_point_balance int(5) default 0 comment '积分余额';

update u_tag_15 
left join member_info 
on u_tag_15.member_id = member_info.member_id
set u_tag_15.t_u_point_balance = 
case
when member_info.point >= 0 and member_info.point <= 0 then 1
when member_info.point >= 1 and member_info.point <= 200 then 2
when member_info.point >= 201 and member_info.point <= 500 then 3
when member_info.point >= 501 and member_info.point <= 800 then 4
when member_info.point >= 801 and member_info.point <= 1000 then 5
when member_info.point >= 1001 then 6
else 0 end;

-- b_1201_tag_type1_case_where
-- 客户属性
alter table u_tag_15 add column t_u_customer_attr int(5) default 0 comment '客户属性';

update u_tag_15 
left join member_info 
on u_tag_15.member_id = member_info.member_id
set u_tag_15.t_u_customer_attr = 
case
when TIMESTAMPDIFF(DAY, member_info.register_date, CURDATE()) <= 90 then 1
when TIMESTAMPDIFF(DAY, member_info.register_date, CURDATE()) > 90 then 2
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：12个月以内下单次数
alter table u_mid_15 add column order_times_after12 int(5) default 0 comment '过程值：12个月以内下单次数';

update u_mid_15 x inner join (
select u_mid_15.id, count(*) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
where order_list.order_time >= date_sub(date(now()),interval 12 month)
group by u_mid_15.id
) y on x.id = y.id 
set order_times_after12 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：总下单次数
alter table u_mid_15 add column order_times_total int(5) default 0 comment '过程值：总下单次数';

update u_mid_15 x inner join (
select u_mid_15.id, count(*) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
where true
group by u_mid_15.id
) y on x.id = y.id 
set order_times_total = y.c;

-- b_3001_mid_type2_basic
-- 过程值：消费金额总和
alter table u_mid_15 add column total_cost_value int(11) default 0 comment '过程值：消费金额总和';

update u_mid_15 x inner join (
select u_mid_15.id, sum(order_list.amount) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
where true
group by u_mid_15.id
) y on x.id = y.id 
set total_cost_value = y.c;

-- b_3001_mid_type2_basic
-- 过程值：首次到店日期
alter table u_mid_15 add column first_come_date date default null comment '过程值：首次到店日期';

update u_mid_15 x inner join (
select u_mid_15.id, min(order_list.order_time) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
where true
group by u_mid_15.id
) y on x.id = y.id 
set first_come_date = y.c;

-- b_1202_mid_type1_case_where_else
-- 过程值：近一年到店计入月数
alter table u_mid_15 add column last_year_interview_month decimal(7,5) default 0.0 comment '过程值：近一年到店计入月数';

update u_mid_15 
set u_mid_15.last_year_interview_month = 
case
when first_come_date is null then 99
when first_come_date < date_sub(date(now()),interval 1 year) then 12.0
when first_come_date > date_sub(date(now()),interval 1 month) then 1
else datediff(date(now()),first_come_date)/30 end;

-- b_2002_mid_type1_where
-- 过程值：近一年到店频率
alter table u_mid_15 add column last_year_rate decimal(12,3) default 0 comment '过程值：近一年到店频率';

update u_mid_15 
set u_mid_15.last_year_rate = order_times_after12/last_year_interview_month
where true;

-- b_1101_tag_type1_case_between
-- 近一年下单频率
alter table u_tag_15 add column t_u_year_frequency int(5) default 0 comment '近一年下单频率';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_year_frequency = 
case
when u_mid_15.last_year_rate <= 0.25 then 0
when u_mid_15.last_year_rate >= 0.25 and u_mid_15.last_year_rate <= 0.5 then 1
when u_mid_15.last_year_rate >= 0.5 then 2
else 0 end;

-- b_1101_tag_type1_case_between
-- 总到店次数
alter table u_tag_15 add column t_u_times_total int(5) default 0 comment '总到店次数';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_times_total = 
case
when u_mid_15.order_times_total <= 0 then 1
when u_mid_15.order_times_total >= 1 and u_mid_15.order_times_total <= 3 then 2
when u_mid_15.order_times_total >= 4 and u_mid_15.order_times_total <= 6 then 3
when u_mid_15.order_times_total >= 7 and u_mid_15.order_times_total <= 9 then 4
when u_mid_15.order_times_total >= 10 and u_mid_15.order_times_total <= 12 then 5
when u_mid_15.order_times_total >= 13 then 6
else 0 end;

-- b_1101_tag_type1_case_between
-- 消费金额总和
alter table u_tag_15 add column t_u_total_cost int(5) default 0 comment '消费金额总和';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_total_cost = 
case
when u_mid_15.total_cost_value >= 1 and u_mid_15.total_cost_value <= 50 then 1
when u_mid_15.total_cost_value >= 51 and u_mid_15.total_cost_value <= 100 then 2
when u_mid_15.total_cost_value >= 101 and u_mid_15.total_cost_value <= 200 then 3
when u_mid_15.total_cost_value >= 201 and u_mid_15.total_cost_value <= 500 then 4
when u_mid_15.total_cost_value >= 501 and u_mid_15.total_cost_value <= 1000 then 5
when u_mid_15.total_cost_value >= 1001 then 6
else 0 end;

-- b_2002_mid_type1_where
-- 过程值：客单价
alter table u_mid_15 add column per_customer_transaction decimal(12,3) default 0 comment '过程值：客单价';

update u_mid_15 
set u_mid_15.per_customer_transaction = if(order_times_total = 0, 0, total_cost_value/order_times_total)
where true;

-- b_1101_tag_type1_case_between
-- 客单价
alter table u_tag_15 add column t_u_pct int(5) default 0 comment '客单价';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_pct = 
case
when u_mid_15.per_customer_transaction >= 1 and u_mid_15.per_customer_transaction <= 50 then 1
when u_mid_15.per_customer_transaction >= 51 and u_mid_15.per_customer_transaction <= 100 then 2
when u_mid_15.per_customer_transaction >= 101 and u_mid_15.per_customer_transaction <= 200 then 3
when u_mid_15.per_customer_transaction >= 201 and u_mid_15.per_customer_transaction <= 500 then 4
when u_mid_15.per_customer_transaction >= 501 and u_mid_15.per_customer_transaction <= 1000 then 5
when u_mid_15.per_customer_transaction >= 1001 then 6
else 0 end;

-- b_2001_tag_type1_where
-- 门店偏好-步行街
alter table u_tag_15 add column t_u_store_prefer_1 int(5) default 0 comment '门店偏好-步行街';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
set u_tag_15.t_u_store_prefer_1 = 1
where order_list.store like '%步行街%';

-- b_2001_tag_type1_where
-- 门店偏好-东升
alter table u_tag_15 add column t_u_store_prefer_2 int(5) default 0 comment '门店偏好-东升';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
set u_tag_15.t_u_store_prefer_2 = 1
where order_list.store like '%东升%';

-- b_2001_tag_type1_where
-- 门店偏好-六中
alter table u_tag_15 add column t_u_store_prefer_3 int(5) default 0 comment '门店偏好-六中';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
set u_tag_15.t_u_store_prefer_3 = 1
where order_list.store like '%六中%';

-- b_2001_tag_type1_where
-- 门店偏好-东方
alter table u_tag_15 add column t_u_store_prefer_4 int(5) default 0 comment '门店偏好-东方';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
set u_tag_15.t_u_store_prefer_4 = 1
where order_list.store like '%东方%';

-- b_2001_tag_type1_where
-- 门店偏好-长兴
alter table u_tag_15 add column t_u_store_prefer_5 int(5) default 0 comment '门店偏好-长兴';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
set u_tag_15.t_u_store_prefer_5 = 1
where order_list.store like '%长兴%';

-- b_2001_tag_type1_where
-- 门店偏好-缺失
alter table u_tag_15 add column t_u_store_prefer_0 int(5) default 0 comment '门店偏好-缺失';

update u_tag_15 
set u_tag_15.t_u_store_prefer_0 = 1
where t_u_store_prefer_1 = 0 and t_u_store_prefer_2 = 0 and t_u_store_prefer_3 = 0 and t_u_store_prefer_4 = 0 and t_u_store_prefer_5 = 0;

-- b_2001_tag_type1_where
-- OTC偏好-滋补营养类
alter table u_tag_15 add column t_u_preference_otc_1 int(5) default 0 comment 'OTC偏好-滋补营养类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_1 = 1
where product_info.type_name like '%滋补营养类%';

-- b_2001_tag_type1_where
-- OTC偏好-维生素矿物类
alter table u_tag_15 add column t_u_preference_otc_2 int(5) default 0 comment 'OTC偏好-维生素矿物类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_2 = 1
where product_info.type_name like '%维生素矿物类%';

-- b_2001_tag_type1_where
-- OTC偏好-五官科类
alter table u_tag_15 add column t_u_preference_otc_3 int(5) default 0 comment 'OTC偏好-五官科类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_3 = 1
where product_info.type_name like '%五官科类%';

-- b_2001_tag_type1_where
-- OTC偏好-骨伤科类
alter table u_tag_15 add column t_u_preference_otc_4 int(5) default 0 comment 'OTC偏好-骨伤科类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_4 = 1
where product_info.type_name like '%骨伤科类%';

-- b_2001_tag_type1_where
-- OTC偏好-风湿镇痛类
alter table u_tag_15 add column t_u_preference_otc_5 int(5) default 0 comment 'OTC偏好-风湿镇痛类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_5 = 1
where product_info.type_name like '%风湿镇痛类%';

-- b_2001_tag_type1_where
-- OTC偏好-抗感冒类
alter table u_tag_15 add column t_u_preference_otc_6 int(5) default 0 comment 'OTC偏好-抗感冒类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_6 = 1
where product_info.type_name like '%抗感冒类%';

-- b_2001_tag_type1_where
-- OTC偏好-清热解毒类
alter table u_tag_15 add column t_u_preference_otc_7 int(5) default 0 comment 'OTC偏好-清热解毒类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_7 = 1
where product_info.type_name like '%清热解毒类%';

-- b_2001_tag_type1_where
-- OTC偏好-止咳化痰类
alter table u_tag_15 add column t_u_preference_otc_8 int(5) default 0 comment 'OTC偏好-止咳化痰类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_8 = 1
where product_info.type_name like '%止咳化痰类%';

-- b_2001_tag_type1_where
-- OTC偏好-消化系统类
alter table u_tag_15 add column t_u_preference_otc_9 int(5) default 0 comment 'OTC偏好-消化系统类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_9 = 1
where product_info.type_name like '%消化系统类%';

-- b_2001_tag_type1_where
-- OTC偏好-外用药类
alter table u_tag_15 add column t_u_preference_otc_10 int(5) default 0 comment 'OTC偏好-外用药类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_10 = 1
where product_info.type_name like '%外用药类%';

-- b_2001_tag_type1_where
-- OTC偏好-泌尿生殖系统类
alter table u_tag_15 add column t_u_preference_otc_11 int(5) default 0 comment 'OTC偏好-泌尿生殖系统类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_11 = 1
where product_info.type_name like '%泌尿生殖系统类%';

-- b_2001_tag_type1_where
-- OTC偏好-妇科类
alter table u_tag_15 add column t_u_preference_otc_12 int(5) default 0 comment 'OTC偏好-妇科类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_12 = 1
where product_info.type_name like '%妇科类%';

-- b_2001_tag_type1_where
-- OTC偏好-其他类
alter table u_tag_15 add column t_u_preference_otc_13 int(5) default 0 comment 'OTC偏好-其他类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_otc_13 = 1
where product_info.type_name like '%其他类%';

-- b_2001_tag_type1_where
-- OTC偏好-缺失
alter table u_tag_15 add column t_u_preference_otc_0 int(5) default 0 comment 'OTC偏好-缺失';

update u_tag_15 
set u_tag_15.t_u_preference_otc_0 = 1
where t_u_preference_otc_1 = 0 and t_u_preference_otc_2 = 0 and t_u_preference_otc_3 = 0 and t_u_preference_otc_4 = 0 and t_u_preference_otc_5 = 0 and t_u_preference_otc_6 = 0 and t_u_preference_otc_7 = 0 and t_u_preference_otc_8 = 0 and t_u_preference_otc_9 = 0 and t_u_preference_otc_10 = 0 and t_u_preference_otc_11 = 0 and t_u_preference_otc_12 = 0 and t_u_preference_otc_13 = 0;

-- b_2001_tag_type1_where
-- RX偏好-滋补营养类
alter table u_tag_15 add column t_u_preference_rx_1 int(5) default 0 comment 'RX偏好-滋补营养类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_1 = 1
where product_info.type_name like '%滋补营养类%';

-- b_2001_tag_type1_where
-- RX偏好-维生素矿物类
alter table u_tag_15 add column t_u_preference_rx_2 int(5) default 0 comment 'RX偏好-维生素矿物类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_2 = 1
where product_info.type_name like '%维生素矿物类%';

-- b_2001_tag_type1_where
-- RX偏好-五官科类
alter table u_tag_15 add column t_u_preference_rx_3 int(5) default 0 comment 'RX偏好-五官科类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_3 = 1
where product_info.type_name like '%五官科类%';

-- b_2001_tag_type1_where
-- RX偏好-风湿镇痛类
alter table u_tag_15 add column t_u_preference_rx_4 int(5) default 0 comment 'RX偏好-风湿镇痛类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_4 = 1
where product_info.type_name like '%风湿镇痛类%';

-- b_2001_tag_type1_where
-- RX偏好-心脏血管类
alter table u_tag_15 add column t_u_preference_rx_5 int(5) default 0 comment 'RX偏好-心脏血管类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_5 = 1
where product_info.type_name like '%心脏血管类%';

-- b_2001_tag_type1_where
-- RX偏好-糖尿病类
alter table u_tag_15 add column t_u_preference_rx_6 int(5) default 0 comment 'RX偏好-糖尿病类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_6 = 1
where product_info.type_name like '%糖尿病类%';

-- b_2001_tag_type1_where
-- RX偏好-消化系统类
alter table u_tag_15 add column t_u_preference_rx_7 int(5) default 0 comment 'RX偏好-消化系统类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_7 = 1
where product_info.type_name like '%消化系统类%';

-- b_2001_tag_type1_where
-- RX偏好-感冒止咳类
alter table u_tag_15 add column t_u_preference_rx_8 int(5) default 0 comment 'RX偏好-感冒止咳类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_8 = 1
where product_info.type_name like '%感冒止咳类%';

-- b_2001_tag_type1_where
-- RX偏好-清热解毒类
alter table u_tag_15 add column t_u_preference_rx_9 int(5) default 0 comment 'RX偏好-清热解毒类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_9 = 1
where product_info.type_name like '%清热解毒类%';

-- b_2001_tag_type1_where
-- RX偏好-外用药类
alter table u_tag_15 add column t_u_preference_rx_10 int(5) default 0 comment 'RX偏好-外用药类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_10 = 1
where product_info.type_name like '%外用药类%';

-- b_2001_tag_type1_where
-- RX偏好-泌尿生殖系统类
alter table u_tag_15 add column t_u_preference_rx_11 int(5) default 0 comment 'RX偏好-泌尿生殖系统类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_11 = 1
where product_info.type_name like '%泌尿生殖系统类%';

-- b_2001_tag_type1_where
-- RX偏好-抗菌消炎类
alter table u_tag_15 add column t_u_preference_rx_12 int(5) default 0 comment 'RX偏好-抗菌消炎类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_12 = 1
where product_info.type_name like '%抗菌消炎类%';

-- b_2001_tag_type1_where
-- RX偏好-注射类
alter table u_tag_15 add column t_u_preference_rx_13 int(5) default 0 comment 'RX偏好-注射类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_13 = 1
where product_info.type_name like '%注射类%';

-- b_2001_tag_type1_where
-- RX偏好-抗高血压类
alter table u_tag_15 add column t_u_preference_rx_14 int(5) default 0 comment 'RX偏好-抗高血压类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_14 = 1
where product_info.type_name like '%抗高血压类%';

-- b_2001_tag_type1_where
-- RX偏好-妇科类
alter table u_tag_15 add column t_u_preference_rx_15 int(5) default 0 comment 'RX偏好-妇科类';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_15 = 1
where product_info.type_name like '%妇科类%';

-- b_2001_tag_type1_where
-- RX偏好-其他
alter table u_tag_15 add column t_u_preference_rx_16 int(5) default 0 comment 'RX偏好-其他';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_rx_16 = 1
where product_info.type_name like '%其他%';

-- b_2001_tag_type1_where
-- RX偏好-缺失
alter table u_tag_15 add column t_u_preference_rx_0 int(5) default 0 comment 'RX偏好-缺失';

update u_tag_15 
set u_tag_15.t_u_preference_rx_0 = 1
where t_u_preference_rx_1 = 0 and t_u_preference_rx_2 = 0 and t_u_preference_rx_3 = 0 and t_u_preference_rx_4 = 0 and t_u_preference_rx_5 = 0 and t_u_preference_rx_6 = 0 and t_u_preference_rx_7 = 0 and t_u_preference_rx_8 = 0 and t_u_preference_rx_9 = 0 and t_u_preference_rx_10 = 0 and t_u_preference_rx_11 = 0 and t_u_preference_rx_12 = 0 and t_u_preference_rx_13 = 0 and t_u_preference_rx_14 = 0 and t_u_preference_rx_15 = 0 and t_u_preference_rx_16 = 0;

-- b_2001_tag_type1_where
-- 中药偏好-精制饮片
alter table u_tag_15 add column t_u_preference_zy_1 int(5) default 0 comment '中药偏好-精制饮片';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_zy_1 = 1
where product_info.type_name like '%精制饮片%';

-- b_2001_tag_type1_where
-- 中药偏好-贵细
alter table u_tag_15 add column t_u_preference_zy_2 int(5) default 0 comment '中药偏好-贵细';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_zy_2 = 1
where product_info.type_name like '%贵细%';

-- b_2001_tag_type1_where
-- 中药偏好-饮片
alter table u_tag_15 add column t_u_preference_zy_3 int(5) default 0 comment '中药偏好-饮片';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_zy_3 = 1
where product_info.type_name like '%饮片%';

-- b_2001_tag_type1_where
-- 中药偏好-备用
alter table u_tag_15 add column t_u_preference_zy_4 int(5) default 0 comment '中药偏好-备用';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_preference_zy_4 = 1
where product_info.type_name like '%备用%';

-- b_2001_tag_type1_where
-- 中药偏好-缺失
alter table u_tag_15 add column t_u_preference_zy_0 int(5) default 0 comment '中药偏好-缺失';

update u_tag_15 
set u_tag_15.t_u_preference_zy_0 = 1
where t_u_preference_zy_1 = 0 and t_u_preference_zy_2 = 0 and t_u_preference_zy_3 = 0 and t_u_preference_zy_4 = 0;

-- b_2001_tag_type1_where
-- 是否参加会员日
alter table u_tag_15 add column t_u_member_day int(5) default 0 comment '是否参加会员日';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_member_day = 1
where product_info.product_name like '%特价%';

-- b_3001_mid_type2_basic
-- 过程值：复购次数-滋补营养类
alter table u_mid_15 add column order_zbyy int(5) default 0 comment '过程值：复购次数-滋补营养类';

update u_mid_15 x inner join (
select u_mid_15.id, count(*) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join product_info 
on order_list.product_code = product_info.product_code
where product_info.type_name like '%滋补营养类%'
group by u_mid_15.id
) y on x.id = y.id 
set order_zbyy = y.c;

-- b_1101_tag_type1_case_between
-- 复购次数-滋补营养类
alter table u_tag_15 add column t_u_order_zbyy int(5) default 0 comment '复购次数-滋补营养类';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_order_zbyy = 
case
when u_mid_15.order_zbyy - 1 <= 0 then 0
when u_mid_15.order_zbyy - 1 >= 1 and u_mid_15.order_zbyy - 1 <= 1 then 1
when u_mid_15.order_zbyy - 1 >= 2 and u_mid_15.order_zbyy - 1 <= 2 then 2
when u_mid_15.order_zbyy - 1 >= 3 and u_mid_15.order_zbyy - 1 <= 3 then 3
when u_mid_15.order_zbyy - 1 >= 4 and u_mid_15.order_zbyy - 1 <= 4 then 4
when u_mid_15.order_zbyy - 1 >= 5 and u_mid_15.order_zbyy - 1 <= 5 then 5
when u_mid_15.order_zbyy - 1 >= 6 and u_mid_15.order_zbyy - 1 <= 6 then 6
when u_mid_15.order_zbyy - 1 >= 7 and u_mid_15.order_zbyy - 1 <= 7 then 7
when u_mid_15.order_zbyy - 1 >= 8 and u_mid_15.order_zbyy - 1 <= 8 then 8
when u_mid_15.order_zbyy - 1 >= 9 and u_mid_15.order_zbyy - 1 <= 9 then 9
when u_mid_15.order_zbyy - 1 >= 10 and u_mid_15.order_zbyy - 1 <= 10 then 10
when u_mid_15.order_zbyy - 1 >= 11 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：复购次数-维生素矿物类
alter table u_mid_15 add column order_wsskw int(5) default 0 comment '过程值：复购次数-维生素矿物类';

update u_mid_15 x inner join (
select u_mid_15.id, count(*) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join product_info 
on order_list.product_code = product_info.product_code
where product_info.type_name like '%维生素矿物类%'
group by u_mid_15.id
) y on x.id = y.id 
set order_wsskw = y.c;

-- b_1101_tag_type1_case_between
-- 复购次数-维生素矿物类
alter table u_tag_15 add column t_u_order_wsskw int(5) default 0 comment '复购次数-维生素矿物类';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_order_wsskw = 
case
when u_mid_15.order_wsskw - 1 <= 0 then 0
when u_mid_15.order_wsskw - 1 >= 1 and u_mid_15.order_wsskw - 1 <= 1 then 1
when u_mid_15.order_wsskw - 1 >= 2 and u_mid_15.order_wsskw - 1 <= 2 then 2
when u_mid_15.order_wsskw - 1 >= 3 and u_mid_15.order_wsskw - 1 <= 3 then 3
when u_mid_15.order_wsskw - 1 >= 4 and u_mid_15.order_wsskw - 1 <= 4 then 4
when u_mid_15.order_wsskw - 1 >= 5 and u_mid_15.order_wsskw - 1 <= 5 then 5
when u_mid_15.order_wsskw - 1 >= 6 and u_mid_15.order_wsskw - 1 <= 6 then 6
when u_mid_15.order_wsskw - 1 >= 7 and u_mid_15.order_wsskw - 1 <= 7 then 7
when u_mid_15.order_wsskw - 1 >= 8 and u_mid_15.order_wsskw - 1 <= 8 then 8
when u_mid_15.order_wsskw - 1 >= 9 and u_mid_15.order_wsskw - 1 <= 9 then 9
when u_mid_15.order_wsskw - 1 >= 10 and u_mid_15.order_wsskw - 1 <= 10 then 10
when u_mid_15.order_wsskw - 1 >= 11 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：复购次数-五官科类
alter table u_mid_15 add column order_wgk int(5) default 0 comment '过程值：复购次数-五官科类';

update u_mid_15 x inner join (
select u_mid_15.id, count(*) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join product_info 
on order_list.product_code = product_info.product_code
where product_info.type_name like '%五官科类%'
group by u_mid_15.id
) y on x.id = y.id 
set order_wgk = y.c;

-- b_1101_tag_type1_case_between
-- 复购次数-五官科类
alter table u_tag_15 add column t_u_order_wgk int(5) default 0 comment '复购次数-五官科类';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_order_wgk = 
case
when u_mid_15.order_wgk - 1 <= 0 then 0
when u_mid_15.order_wgk - 1 >= 1 and u_mid_15.order_wgk - 1 <= 1 then 1
when u_mid_15.order_wgk - 1 >= 2 and u_mid_15.order_wgk - 1 <= 2 then 2
when u_mid_15.order_wgk - 1 >= 3 and u_mid_15.order_wgk - 1 <= 3 then 3
when u_mid_15.order_wgk - 1 >= 4 and u_mid_15.order_wgk - 1 <= 4 then 4
when u_mid_15.order_wgk - 1 >= 5 and u_mid_15.order_wgk - 1 <= 5 then 5
when u_mid_15.order_wgk - 1 >= 6 and u_mid_15.order_wgk - 1 <= 6 then 6
when u_mid_15.order_wgk - 1 >= 7 and u_mid_15.order_wgk - 1 <= 7 then 7
when u_mid_15.order_wgk - 1 >= 8 and u_mid_15.order_wgk - 1 <= 8 then 8
when u_mid_15.order_wgk - 1 >= 9 and u_mid_15.order_wgk - 1 <= 9 then 9
when u_mid_15.order_wgk - 1 >= 10 and u_mid_15.order_wgk - 1 <= 10 then 10
when u_mid_15.order_wgk - 1 >= 11 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：复购次数-风湿镇痛类
alter table u_mid_15 add column order_fszt int(5) default 0 comment '过程值：复购次数-风湿镇痛类';

update u_mid_15 x inner join (
select u_mid_15.id, count(*) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join product_info 
on order_list.product_code = product_info.product_code
where product_info.type_name like '%风湿镇痛类%'
group by u_mid_15.id
) y on x.id = y.id 
set order_fszt = y.c;

-- b_1101_tag_type1_case_between
-- 复购次数-风湿镇痛类
alter table u_tag_15 add column t_u_order_fszt int(5) default 0 comment '复购次数-风湿镇痛类';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_order_fszt = 
case
when u_mid_15.order_fszt - 1 <= 0 then 0
when u_mid_15.order_fszt - 1 >= 1 and u_mid_15.order_fszt - 1 <= 1 then 1
when u_mid_15.order_fszt - 1 >= 2 and u_mid_15.order_fszt - 1 <= 2 then 2
when u_mid_15.order_fszt - 1 >= 3 and u_mid_15.order_fszt - 1 <= 3 then 3
when u_mid_15.order_fszt - 1 >= 4 and u_mid_15.order_fszt - 1 <= 4 then 4
when u_mid_15.order_fszt - 1 >= 5 and u_mid_15.order_fszt - 1 <= 5 then 5
when u_mid_15.order_fszt - 1 >= 6 and u_mid_15.order_fszt - 1 <= 6 then 6
when u_mid_15.order_fszt - 1 >= 7 and u_mid_15.order_fszt - 1 <= 7 then 7
when u_mid_15.order_fszt - 1 >= 8 and u_mid_15.order_fszt - 1 <= 8 then 8
when u_mid_15.order_fszt - 1 >= 9 and u_mid_15.order_fszt - 1 <= 9 then 9
when u_mid_15.order_fszt - 1 >= 10 and u_mid_15.order_fszt - 1 <= 10 then 10
when u_mid_15.order_fszt - 1 >= 11 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：复购次数-消化系统类
alter table u_mid_15 add column order_xhxt int(5) default 0 comment '过程值：复购次数-消化系统类';

update u_mid_15 x inner join (
select u_mid_15.id, count(*) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join product_info 
on order_list.product_code = product_info.product_code
where product_info.type_name like '%消化系统类%'
group by u_mid_15.id
) y on x.id = y.id 
set order_xhxt = y.c;

-- b_1101_tag_type1_case_between
-- 复购次数-消化系统类
alter table u_tag_15 add column t_u_order_xhxt int(5) default 0 comment '复购次数-消化系统类';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_order_xhxt = 
case
when u_mid_15.order_xhxt - 1 <= 0 then 0
when u_mid_15.order_xhxt - 1 >= 1 and u_mid_15.order_xhxt - 1 <= 1 then 1
when u_mid_15.order_xhxt - 1 >= 2 and u_mid_15.order_xhxt - 1 <= 2 then 2
when u_mid_15.order_xhxt - 1 >= 3 and u_mid_15.order_xhxt - 1 <= 3 then 3
when u_mid_15.order_xhxt - 1 >= 4 and u_mid_15.order_xhxt - 1 <= 4 then 4
when u_mid_15.order_xhxt - 1 >= 5 and u_mid_15.order_xhxt - 1 <= 5 then 5
when u_mid_15.order_xhxt - 1 >= 6 and u_mid_15.order_xhxt - 1 <= 6 then 6
when u_mid_15.order_xhxt - 1 >= 7 and u_mid_15.order_xhxt - 1 <= 7 then 7
when u_mid_15.order_xhxt - 1 >= 8 and u_mid_15.order_xhxt - 1 <= 8 then 8
when u_mid_15.order_xhxt - 1 >= 9 and u_mid_15.order_xhxt - 1 <= 9 then 9
when u_mid_15.order_xhxt - 1 >= 10 and u_mid_15.order_xhxt - 1 <= 10 then 10
when u_mid_15.order_xhxt - 1 >= 11 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：复购次数-清热解毒类
alter table u_mid_15 add column order_qrjd int(5) default 0 comment '过程值：复购次数-清热解毒类';

update u_mid_15 x inner join (
select u_mid_15.id, count(*) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join product_info 
on order_list.product_code = product_info.product_code
where product_info.type_name like '%清热解毒类%'
group by u_mid_15.id
) y on x.id = y.id 
set order_qrjd = y.c;

-- b_1101_tag_type1_case_between
-- 复购次数-清热解毒类
alter table u_tag_15 add column t_u_order_qrjd int(5) default 0 comment '复购次数-清热解毒类';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_order_qrjd = 
case
when u_mid_15.order_qrjd - 1 <= 0 then 0
when u_mid_15.order_qrjd - 1 >= 1 and u_mid_15.order_qrjd - 1 <= 1 then 1
when u_mid_15.order_qrjd - 1 >= 2 and u_mid_15.order_qrjd - 1 <= 2 then 2
when u_mid_15.order_qrjd - 1 >= 3 and u_mid_15.order_qrjd - 1 <= 3 then 3
when u_mid_15.order_qrjd - 1 >= 4 and u_mid_15.order_qrjd - 1 <= 4 then 4
when u_mid_15.order_qrjd - 1 >= 5 and u_mid_15.order_qrjd - 1 <= 5 then 5
when u_mid_15.order_qrjd - 1 >= 6 and u_mid_15.order_qrjd - 1 <= 6 then 6
when u_mid_15.order_qrjd - 1 >= 7 and u_mid_15.order_qrjd - 1 <= 7 then 7
when u_mid_15.order_qrjd - 1 >= 8 and u_mid_15.order_qrjd - 1 <= 8 then 8
when u_mid_15.order_qrjd - 1 >= 9 and u_mid_15.order_qrjd - 1 <= 9 then 9
when u_mid_15.order_qrjd - 1 >= 10 and u_mid_15.order_qrjd - 1 <= 10 then 10
when u_mid_15.order_qrjd - 1 >= 11 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：复购次数-妇科类
alter table u_mid_15 add column order_fk int(5) default 0 comment '过程值：复购次数-妇科类';

update u_mid_15 x inner join (
select u_mid_15.id, count(*) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join product_info 
on order_list.product_code = product_info.product_code
where product_info.type_name like '%妇科类%'
group by u_mid_15.id
) y on x.id = y.id 
set order_fk = y.c;

-- b_1101_tag_type1_case_between
-- 复购次数-妇科类
alter table u_tag_15 add column t_u_order_fk int(5) default 0 comment '复购次数-妇科类';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_order_fk = 
case
when u_mid_15.order_fk - 1 <= 0 then 0
when u_mid_15.order_fk - 1 >= 1 and u_mid_15.order_fk - 1 <= 1 then 1
when u_mid_15.order_fk - 1 >= 2 and u_mid_15.order_fk - 1 <= 2 then 2
when u_mid_15.order_fk - 1 >= 3 and u_mid_15.order_fk - 1 <= 3 then 3
when u_mid_15.order_fk - 1 >= 4 and u_mid_15.order_fk - 1 <= 4 then 4
when u_mid_15.order_fk - 1 >= 5 and u_mid_15.order_fk - 1 <= 5 then 5
when u_mid_15.order_fk - 1 >= 6 and u_mid_15.order_fk - 1 <= 6 then 6
when u_mid_15.order_fk - 1 >= 7 and u_mid_15.order_fk - 1 <= 7 then 7
when u_mid_15.order_fk - 1 >= 8 and u_mid_15.order_fk - 1 <= 8 then 8
when u_mid_15.order_fk - 1 >= 9 and u_mid_15.order_fk - 1 <= 9 then 9
when u_mid_15.order_fk - 1 >= 10 and u_mid_15.order_fk - 1 <= 10 then 10
when u_mid_15.order_fk - 1 >= 11 then 11
else 0 end;

-- b_2001_tag_type1_where
-- 是否购买糖尿病类药品
alter table u_tag_15 add column t_u_buy_tnb int(5) default 0 comment '是否购买糖尿病类药品';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_buy_tnb = 1
where product_info.type_name like '%糖尿病类%';

-- b_2001_tag_type1_where
-- 是否购买心脑血管类药品
alter table u_tag_15 add column t_u_buy_xzxg int(5) default 0 comment '是否购买心脑血管类药品';

update u_tag_15 
left join order_list 
on u_tag_15.member_id = order_list.member_id
left join product_info 
on order_list.product_code = product_info.product_code
set u_tag_15.t_u_buy_xzxg = 1
where product_info.type_name like '%心脑血管类%';

-- b_3001_mid_type2_basic
-- 过程值：购买提醒最后购买日期-盐酸二甲双胍
alter table u_mid_15 add column remind_ejsg_date date default null comment '过程值：购买提醒最后购买日期-盐酸二甲双胍';

update u_mid_15 x inner join (
select u_mid_15.id, max(order_list.order_time) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
where order_list.product_code = 27790
group by u_mid_15.id
) y on x.id = y.id 
set remind_ejsg_date = y.c;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒服用周期-盐酸二甲双胍
alter table u_mid_15 add column remind_ejsg_cycle int(11) default null comment '过程值：购买提醒服用周期-盐酸二甲双胍';

update u_mid_15 x inner join (
select u_mid_15.id, max(usage_info.take_cycle) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join usage_info 
on order_list.product_code = usage_info.product_code
where order_list.product_code = 27790
group by u_mid_15.id
) y on x.id = y.id 
set remind_ejsg_cycle = y.c;

-- b_2002_mid_type1_where
-- 购买提醒剩余天数-盐酸二甲双胍
alter table u_mid_15 add column remind_ejsg int(5) default null comment '购买提醒剩余天数-盐酸二甲双胍';

update u_mid_15 
left join order_list 
on u_mid_15.member_id = order_list.member_id
left join usage_info 
on order_list.product_code = usage_info.product_code
set u_mid_15.remind_ejsg = remind_ejsg_cycle - TIMESTAMPDIFF(DAY, u_mid_15.remind_ejsg_date, CURDATE())
where true;

-- b_1101_tag_type1_case_between
-- 购买提醒-盐酸二甲双胍
alter table u_tag_15 add column t_u_remind_ejsg int(5) default 0 comment '购买提醒-盐酸二甲双胍';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_remind_ejsg = 
case
when u_mid_15.remind_ejsg <= 0 then 1
when u_mid_15.remind_ejsg >= 1 and u_mid_15.remind_ejsg <= 5 then 2
when u_mid_15.remind_ejsg >= 6 and u_mid_15.remind_ejsg <= 10 then 3
when u_mid_15.remind_ejsg >= 11 and u_mid_15.remind_ejsg <= 15 then 4
when u_mid_15.remind_ejsg >= 15 then 5
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒最后购买日期-诺和龙
alter table u_mid_15 add column remind_nhl_date date default null comment '过程值：购买提醒最后购买日期-诺和龙';

update u_mid_15 x inner join (
select u_mid_15.id, max(order_list.order_time) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
where order_list.product_code = 23289
group by u_mid_15.id
) y on x.id = y.id 
set remind_nhl_date = y.c;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒服用周期-诺和龙
alter table u_mid_15 add column remind_nhl_cycle int(11) default null comment '过程值：购买提醒服用周期-诺和龙';

update u_mid_15 x inner join (
select u_mid_15.id, max(usage_info.take_cycle) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join usage_info 
on order_list.product_code = usage_info.product_code
where order_list.product_code = 23289
group by u_mid_15.id
) y on x.id = y.id 
set remind_nhl_cycle = y.c;

-- b_2002_mid_type1_where
-- 购买提醒剩余天数-诺和龙
alter table u_mid_15 add column remind_nhl int(5) default null comment '购买提醒剩余天数-诺和龙';

update u_mid_15 
left join order_list 
on u_mid_15.member_id = order_list.member_id
left join usage_info 
on order_list.product_code = usage_info.product_code
set u_mid_15.remind_nhl = remind_nhl_cycle - TIMESTAMPDIFF(DAY, u_mid_15.remind_nhl_date, CURDATE())
where true;

-- b_1101_tag_type1_case_between
-- 购买提醒-诺和龙
alter table u_tag_15 add column t_u_remind_nhl int(5) default 0 comment '购买提醒-诺和龙';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_remind_nhl = 
case
when u_mid_15.remind_nhl <= 0 then 1
when u_mid_15.remind_nhl >= 1 and u_mid_15.remind_nhl <= 5 then 2
when u_mid_15.remind_nhl >= 6 and u_mid_15.remind_nhl <= 10 then 3
when u_mid_15.remind_nhl >= 11 and u_mid_15.remind_nhl <= 15 then 4
when u_mid_15.remind_nhl >= 15 then 5
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒最后购买日期-格列齐特
alter table u_mid_15 add column remind_glqt_date date default null comment '过程值：购买提醒最后购买日期-格列齐特';

update u_mid_15 x inner join (
select u_mid_15.id, max(order_list.order_time) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
where order_list.product_code = 14100
group by u_mid_15.id
) y on x.id = y.id 
set remind_glqt_date = y.c;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒服用周期-格列齐特
alter table u_mid_15 add column remind_glqt_cycle int(11) default null comment '过程值：购买提醒服用周期-格列齐特';

update u_mid_15 x inner join (
select u_mid_15.id, max(usage_info.take_cycle) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join usage_info 
on order_list.product_code = usage_info.product_code
where order_list.product_code = 14100
group by u_mid_15.id
) y on x.id = y.id 
set remind_glqt_cycle = y.c;

-- b_2002_mid_type1_where
-- 购买提醒剩余天数-格列齐特
alter table u_mid_15 add column remind_glqt int(5) default null comment '购买提醒剩余天数-格列齐特';

update u_mid_15 
left join order_list 
on u_mid_15.member_id = order_list.member_id
left join usage_info 
on order_list.product_code = usage_info.product_code
set u_mid_15.remind_glqt = remind_glqt_cycle - TIMESTAMPDIFF(DAY, u_mid_15.remind_glqt_date, CURDATE())
where true;

-- b_1101_tag_type1_case_between
-- 购买提醒-格列齐特
alter table u_tag_15 add column t_u_remind_glqt int(5) default 0 comment '购买提醒-格列齐特';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_remind_glqt = 
case
when u_mid_15.remind_glqt <= 0 then 1
when u_mid_15.remind_glqt >= 1 and u_mid_15.remind_glqt <= 5 then 2
when u_mid_15.remind_glqt >= 6 and u_mid_15.remind_glqt <= 10 then 3
when u_mid_15.remind_glqt >= 11 and u_mid_15.remind_glqt <= 15 then 4
when u_mid_15.remind_glqt >= 15 then 5
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒最后购买日期-尼群地平
alter table u_mid_15 add column remind_nqdp_date date default null comment '过程值：购买提醒最后购买日期-尼群地平';

update u_mid_15 x inner join (
select u_mid_15.id, max(order_list.order_time) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
where order_list.product_code = 34081
group by u_mid_15.id
) y on x.id = y.id 
set remind_nqdp_date = y.c;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒服用周期-尼群地平
alter table u_mid_15 add column remind_nqdp_cycle int(11) default null comment '过程值：购买提醒服用周期-尼群地平';

update u_mid_15 x inner join (
select u_mid_15.id, max(usage_info.take_cycle) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join usage_info 
on order_list.product_code = usage_info.product_code
where order_list.product_code = 34081
group by u_mid_15.id
) y on x.id = y.id 
set remind_nqdp_cycle = y.c;

-- b_2002_mid_type1_where
-- 购买提醒剩余天数-尼群地平
alter table u_mid_15 add column remind_nqdp int(5) default null comment '购买提醒剩余天数-尼群地平';

update u_mid_15 
left join order_list 
on u_mid_15.member_id = order_list.member_id
left join usage_info 
on order_list.product_code = usage_info.product_code
set u_mid_15.remind_nqdp = remind_nqdp_cycle - TIMESTAMPDIFF(DAY, u_mid_15.remind_nqdp_date, CURDATE())
where true;

-- b_1101_tag_type1_case_between
-- 购买提醒-尼群地平
alter table u_tag_15 add column t_u_remind_nqdp int(5) default 0 comment '购买提醒-尼群地平';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_remind_nqdp = 
case
when u_mid_15.remind_nqdp <= 0 then 1
when u_mid_15.remind_nqdp >= 1 and u_mid_15.remind_nqdp <= 5 then 2
when u_mid_15.remind_nqdp >= 6 and u_mid_15.remind_nqdp <= 10 then 3
when u_mid_15.remind_nqdp >= 11 and u_mid_15.remind_nqdp <= 15 then 4
when u_mid_15.remind_nqdp >= 15 then 5
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒最后购买日期-湘江
alter table u_mid_15 add column remind_xj_date date default null comment '过程值：购买提醒最后购买日期-湘江';

update u_mid_15 x inner join (
select u_mid_15.id, max(order_list.order_time) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
where order_list.product_code = 16720
group by u_mid_15.id
) y on x.id = y.id 
set remind_xj_date = y.c;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒服用周期-湘江
alter table u_mid_15 add column remind_xj_cycle int(11) default null comment '过程值：购买提醒服用周期-湘江';

update u_mid_15 x inner join (
select u_mid_15.id, max(usage_info.take_cycle) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join usage_info 
on order_list.product_code = usage_info.product_code
where order_list.product_code = 16720
group by u_mid_15.id
) y on x.id = y.id 
set remind_xj_cycle = y.c;

-- b_2002_mid_type1_where
-- 购买提醒剩余天数-湘江
alter table u_mid_15 add column remind_xj int(5) default null comment '购买提醒剩余天数-湘江';

update u_mid_15 
left join order_list 
on u_mid_15.member_id = order_list.member_id
left join usage_info 
on order_list.product_code = usage_info.product_code
set u_mid_15.remind_xj = remind_xj_cycle - TIMESTAMPDIFF(DAY, u_mid_15.remind_xj_date, CURDATE())
where true;

-- b_1101_tag_type1_case_between
-- 购买提醒-湘江
alter table u_tag_15 add column t_u_remind_xj int(5) default 0 comment '购买提醒-湘江';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_remind_xj = 
case
when u_mid_15.remind_xj <= 0 then 1
when u_mid_15.remind_xj >= 1 and u_mid_15.remind_xj <= 5 then 2
when u_mid_15.remind_xj >= 6 and u_mid_15.remind_xj <= 10 then 3
when u_mid_15.remind_xj >= 11 and u_mid_15.remind_xj <= 15 then 4
when u_mid_15.remind_xj >= 15 then 5
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒最后购买日期-圣元
alter table u_mid_15 add column remind_sy_date date default null comment '过程值：购买提醒最后购买日期-圣元';

update u_mid_15 x inner join (
select u_mid_15.id, max(order_list.order_time) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
where order_list.product_code = 28851
group by u_mid_15.id
) y on x.id = y.id 
set remind_sy_date = y.c;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒服用周期-圣元
alter table u_mid_15 add column remind_sy_cycle int(11) default null comment '过程值：购买提醒服用周期-圣元';

update u_mid_15 x inner join (
select u_mid_15.id, max(usage_info.take_cycle) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join usage_info 
on order_list.product_code = usage_info.product_code
where order_list.product_code = 28851
group by u_mid_15.id
) y on x.id = y.id 
set remind_sy_cycle = y.c;

-- b_2002_mid_type1_where
-- 购买提醒剩余天数-圣元
alter table u_mid_15 add column remind_sy int(5) default null comment '购买提醒剩余天数-圣元';

update u_mid_15 
left join order_list 
on u_mid_15.member_id = order_list.member_id
left join usage_info 
on order_list.product_code = usage_info.product_code
set u_mid_15.remind_sy = remind_sy_cycle - TIMESTAMPDIFF(DAY, u_mid_15.remind_sy_date, CURDATE())
where true;

-- b_1101_tag_type1_case_between
-- 购买提醒-圣元
alter table u_tag_15 add column t_u_remind_sy int(5) default 0 comment '购买提醒-圣元';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_remind_sy = 
case
when u_mid_15.remind_sy <= 0 then 1
when u_mid_15.remind_sy >= 1 and u_mid_15.remind_sy <= 5 then 2
when u_mid_15.remind_sy >= 6 and u_mid_15.remind_sy <= 10 then 3
when u_mid_15.remind_sy >= 11 and u_mid_15.remind_sy <= 15 then 4
when u_mid_15.remind_sy >= 15 then 5
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒最后购买日期-拜阿司匹灵
alter table u_mid_15 add column remind_baspl_date date default null comment '过程值：购买提醒最后购买日期-拜阿司匹灵';

update u_mid_15 x inner join (
select u_mid_15.id, max(order_list.order_time) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
where order_list.product_code = 10102
group by u_mid_15.id
) y on x.id = y.id 
set remind_baspl_date = y.c;

-- b_3001_mid_type2_basic
-- 过程值：购买提醒服用周期-拜阿司匹灵
alter table u_mid_15 add column remind_baspl_cycle int(11) default null comment '过程值：购买提醒服用周期-拜阿司匹灵';

update u_mid_15 x inner join (
select u_mid_15.id, max(usage_info.take_cycle) c from 
u_mid_15 
inner join order_list 
on u_mid_15.member_id = order_list.member_id
inner join usage_info 
on order_list.product_code = usage_info.product_code
where order_list.product_code = 10102
group by u_mid_15.id
) y on x.id = y.id 
set remind_baspl_cycle = y.c;

-- b_2002_mid_type1_where
-- 购买提醒剩余天数-拜阿司匹灵
alter table u_mid_15 add column remind_baspl int(5) default null comment '购买提醒剩余天数-拜阿司匹灵';

update u_mid_15 
left join order_list 
on u_mid_15.member_id = order_list.member_id
left join usage_info 
on order_list.product_code = usage_info.product_code
set u_mid_15.remind_baspl = remind_baspl_cycle - TIMESTAMPDIFF(DAY, u_mid_15.remind_baspl_date, CURDATE())
where true;

-- b_1101_tag_type1_case_between
-- 购买提醒-拜阿司匹灵
alter table u_tag_15 add column t_u_remind_baspl int(5) default 0 comment '购买提醒-拜阿司匹灵';

update u_tag_15 
left join u_mid_15 
on u_tag_15.id = u_mid_15.id
set u_tag_15.t_u_remind_baspl = 
case
when u_mid_15.remind_baspl <= 0 then 1
when u_mid_15.remind_baspl >= 1 and u_mid_15.remind_baspl <= 5 then 2
when u_mid_15.remind_baspl >= 6 and u_mid_15.remind_baspl <= 10 then 3
when u_mid_15.remind_baspl >= 11 and u_mid_15.remind_baspl <= 15 then 4
when u_mid_15.remind_baspl >= 15 then 5
else 0 end;

-- ----------------------------------
--            下载表生成
-- ----------------------------------
-- b7_dld_gen
-- 性别
alter table u_dld_15 add column t_u_gender varchar(200) default null comment '性别';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_gender' and t.t_u_gender = v.match_val
set d.t_u_gender = v.value_name;

-- 年龄
alter table u_dld_15 add column t_u_age varchar(200) default null comment '年龄';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_age' and t.t_u_age = v.match_val
set d.t_u_age = v.value_name;

-- 地址
alter table u_dld_15 add column t_u_address varchar(200) default null comment '地址';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_address' and t.t_u_address = v.match_val
set d.t_u_address = v.value_name;

-- 来源门店
alter table u_dld_15 add column t_u_store varchar(200) default null comment '来源门店';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_store' and t.t_u_store = v.match_val
set d.t_u_store = v.value_name;

-- 会员类型
alter table u_dld_15 add column t_u_member_type varchar(200) default null comment '会员类型';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_member_type' and t.t_u_member_type = v.match_val
set d.t_u_member_type = v.value_name;

-- 是否生日月
alter table u_dld_15 add column t_u_birth_month varchar(200) default null comment '是否生日月';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_birth_month' and t.t_u_birth_month = v.match_val
set d.t_u_birth_month = v.value_name;

-- 积分余额
alter table u_dld_15 add column t_u_point_balance varchar(200) default null comment '积分余额';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_point_balance' and t.t_u_point_balance = v.match_val
set d.t_u_point_balance = v.value_name;

-- 客户属性
alter table u_dld_15 add column t_u_customer_attr varchar(200) default null comment '客户属性';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_customer_attr' and t.t_u_customer_attr = v.match_val
set d.t_u_customer_attr = v.value_name;

-- 近一年到店频率
alter table u_dld_15 add column t_u_year_frequency varchar(200) default null comment '近一年到店频率';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_year_frequency' and t.t_u_year_frequency = v.match_val
set d.t_u_year_frequency = v.value_name;

-- 总到店次数
alter table u_dld_15 add column t_u_times_total varchar(200) default null comment '总到店次数';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_times_total' and t.t_u_times_total = v.match_val
set d.t_u_times_total = v.value_name;

-- 消费金额总和
alter table u_dld_15 add column t_u_total_cost varchar(200) default null comment '消费金额总和';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_total_cost' and t.t_u_total_cost = v.match_val
set d.t_u_total_cost = v.value_name;

-- 客单价
alter table u_dld_15 add column t_u_pct varchar(200) default null comment '客单价';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_pct' and t.t_u_pct = v.match_val
set d.t_u_pct = v.value_name;

-- 门店偏好
alter table u_dld_15 add column t_u_store_prefer varchar(200) default null comment '门店偏好';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_store_prefer_0' and t.t_u_store_prefer_0 = v.match_val
set d.t_u_store_prefer = 
case
when d.t_u_store_prefer is null then v.value_name
else concat(d.t_u_store_prefer, ',', v.value_name) end
where t.t_u_store_prefer_0 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_store_prefer_1' and t.t_u_store_prefer_1 = v.match_val
set d.t_u_store_prefer = 
case
when d.t_u_store_prefer is null then v.value_name
else concat(d.t_u_store_prefer, ',', v.value_name) end
where t.t_u_store_prefer_1 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_store_prefer_2' and t.t_u_store_prefer_2 = v.match_val
set d.t_u_store_prefer = 
case
when d.t_u_store_prefer is null then v.value_name
else concat(d.t_u_store_prefer, ',', v.value_name) end
where t.t_u_store_prefer_2 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_store_prefer_3' and t.t_u_store_prefer_3 = v.match_val
set d.t_u_store_prefer = 
case
when d.t_u_store_prefer is null then v.value_name
else concat(d.t_u_store_prefer, ',', v.value_name) end
where t.t_u_store_prefer_3 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_store_prefer_4' and t.t_u_store_prefer_4 = v.match_val
set d.t_u_store_prefer = 
case
when d.t_u_store_prefer is null then v.value_name
else concat(d.t_u_store_prefer, ',', v.value_name) end
where t.t_u_store_prefer_4 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_store_prefer_5' and t.t_u_store_prefer_5 = v.match_val
set d.t_u_store_prefer = 
case
when d.t_u_store_prefer is null then v.value_name
else concat(d.t_u_store_prefer, ',', v.value_name) end
where t.t_u_store_prefer_5 = 1;

-- OTC偏好（非处方药）
alter table u_dld_15 add column t_u_preference_otc varchar(200) default null comment 'OTC偏好（非处方药）';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_0' and t.t_u_preference_otc_0 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_0 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_1' and t.t_u_preference_otc_1 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_1 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_2' and t.t_u_preference_otc_2 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_2 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_3' and t.t_u_preference_otc_3 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_3 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_4' and t.t_u_preference_otc_4 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_4 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_5' and t.t_u_preference_otc_5 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_5 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_6' and t.t_u_preference_otc_6 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_6 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_7' and t.t_u_preference_otc_7 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_7 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_8' and t.t_u_preference_otc_8 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_8 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_9' and t.t_u_preference_otc_9 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_9 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_10' and t.t_u_preference_otc_10 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_10 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_11' and t.t_u_preference_otc_11 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_11 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_12' and t.t_u_preference_otc_12 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_12 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_otc_13' and t.t_u_preference_otc_13 = v.match_val
set d.t_u_preference_otc = 
case
when d.t_u_preference_otc is null then v.value_name
else concat(d.t_u_preference_otc, ',', v.value_name) end
where t.t_u_preference_otc_13 = 1;

-- RX偏好（处方药）
alter table u_dld_15 add column t_u_preference_rx varchar(200) default null comment 'RX偏好（处方药）';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_0' and t.t_u_preference_rx_0 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_0 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_1' and t.t_u_preference_rx_1 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_1 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_2' and t.t_u_preference_rx_2 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_2 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_3' and t.t_u_preference_rx_3 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_3 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_4' and t.t_u_preference_rx_4 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_4 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_5' and t.t_u_preference_rx_5 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_5 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_6' and t.t_u_preference_rx_6 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_6 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_7' and t.t_u_preference_rx_7 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_7 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_8' and t.t_u_preference_rx_8 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_8 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_9' and t.t_u_preference_rx_9 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_9 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_10' and t.t_u_preference_rx_10 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_10 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_11' and t.t_u_preference_rx_11 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_11 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_12' and t.t_u_preference_rx_12 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_12 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_13' and t.t_u_preference_rx_13 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_13 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_14' and t.t_u_preference_rx_14 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_14 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_15' and t.t_u_preference_rx_15 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_15 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_rx_16' and t.t_u_preference_rx_16 = v.match_val
set d.t_u_preference_rx = 
case
when d.t_u_preference_rx is null then v.value_name
else concat(d.t_u_preference_rx, ',', v.value_name) end
where t.t_u_preference_rx_16 = 1;

-- 中药偏好
alter table u_dld_15 add column t_u_preference_zy varchar(200) default null comment '中药偏好';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_zy_0' and t.t_u_preference_zy_0 = v.match_val
set d.t_u_preference_zy = 
case
when d.t_u_preference_zy is null then v.value_name
else concat(d.t_u_preference_zy, ',', v.value_name) end
where t.t_u_preference_zy_0 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_zy_1' and t.t_u_preference_zy_1 = v.match_val
set d.t_u_preference_zy = 
case
when d.t_u_preference_zy is null then v.value_name
else concat(d.t_u_preference_zy, ',', v.value_name) end
where t.t_u_preference_zy_1 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_zy_2' and t.t_u_preference_zy_2 = v.match_val
set d.t_u_preference_zy = 
case
when d.t_u_preference_zy is null then v.value_name
else concat(d.t_u_preference_zy, ',', v.value_name) end
where t.t_u_preference_zy_2 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_zy_3' and t.t_u_preference_zy_3 = v.match_val
set d.t_u_preference_zy = 
case
when d.t_u_preference_zy is null then v.value_name
else concat(d.t_u_preference_zy, ',', v.value_name) end
where t.t_u_preference_zy_3 = 1;

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_preference_zy_4' and t.t_u_preference_zy_4 = v.match_val
set d.t_u_preference_zy = 
case
when d.t_u_preference_zy is null then v.value_name
else concat(d.t_u_preference_zy, ',', v.value_name) end
where t.t_u_preference_zy_4 = 1;

-- 是否参加会员日
alter table u_dld_15 add column t_u_member_day varchar(200) default null comment '是否参加会员日';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_member_day' and t.t_u_member_day = v.match_val
set d.t_u_member_day = v.value_name;

-- 滋补营养类复购次数
alter table u_dld_15 add column t_u_order_zbyy varchar(200) default null comment '滋补营养类复购次数';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_zbyy' and t.t_u_order_zbyy = v.match_val
set d.t_u_order_zbyy = v.value_name;

-- 维生素矿物类复购次数
alter table u_dld_15 add column t_u_order_wsskw varchar(200) default null comment '维生素矿物类复购次数';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_wsskw' and t.t_u_order_wsskw = v.match_val
set d.t_u_order_wsskw = v.value_name;

-- 五官科类复购次数
alter table u_dld_15 add column t_u_order_wgk varchar(200) default null comment '五官科类复购次数';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_wgk' and t.t_u_order_wgk = v.match_val
set d.t_u_order_wgk = v.value_name;

-- 风湿镇痛类复购次数
alter table u_dld_15 add column t_u_order_fszt varchar(200) default null comment '风湿镇痛类复购次数';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_fszt' and t.t_u_order_fszt = v.match_val
set d.t_u_order_fszt = v.value_name;

-- 消化系统类复购次数
alter table u_dld_15 add column t_u_order_xhxt varchar(200) default null comment '消化系统类复购次数';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_xhxt' and t.t_u_order_xhxt = v.match_val
set d.t_u_order_xhxt = v.value_name;

-- 清热解毒类复购次数
alter table u_dld_15 add column t_u_order_qrjd varchar(200) default null comment '清热解毒类复购次数';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_qrjd' and t.t_u_order_qrjd = v.match_val
set d.t_u_order_qrjd = v.value_name;

-- 妇科类复购次数
alter table u_dld_15 add column t_u_order_fk varchar(200) default null comment '妇科类复购次数';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_fk' and t.t_u_order_fk = v.match_val
set d.t_u_order_fk = v.value_name;

-- 是否购买糖尿病类药品
alter table u_dld_15 add column t_u_buy_tnb varchar(200) default null comment '是否购买糖尿病类药品';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_tnb' and t.t_u_buy_tnb = v.match_val
set d.t_u_buy_tnb = v.value_name;

-- 是否购买心脑血管类药品
alter table u_dld_15 add column t_u_buy_xzxg varchar(200) default null comment '是否购买心脑血管类药品';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_xzxg' and t.t_u_buy_xzxg = v.match_val
set d.t_u_buy_xzxg = v.value_name;

-- 盐酸二甲双胍缓释片购买提醒
alter table u_dld_15 add column t_u_remind_ejsg varchar(200) default null comment '盐酸二甲双胍缓释片购买提醒';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_remind_ejsg' and t.t_u_remind_ejsg = v.match_val
set d.t_u_remind_ejsg = v.value_name;

-- 诺和龙(瑞格列奈片)购买提醒
alter table u_dld_15 add column t_u_remind_nhl varchar(200) default null comment '诺和龙(瑞格列奈片)购买提醒';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_remind_nhl' and t.t_u_remind_nhl = v.match_val
set d.t_u_remind_nhl = v.value_name;

-- 格列齐特片购买提醒
alter table u_dld_15 add column t_u_remind_glqt varchar(200) default null comment '格列齐特片购买提醒';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_remind_glqt' and t.t_u_remind_glqt = v.match_val
set d.t_u_remind_glqt = v.value_name;

-- 尼群地平片购买提醒
alter table u_dld_15 add column t_u_remind_nqdp varchar(200) default null comment '尼群地平片购买提醒';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_remind_nqdp' and t.t_u_remind_nqdp = v.match_val
set d.t_u_remind_nqdp = v.value_name;

-- 马来酸依那普利片(湘江)购买提醒
alter table u_dld_15 add column t_u_remind_xj varchar(200) default null comment '马来酸依那普利片(湘江)购买提醒';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_remind_xj' and t.t_u_remind_xj = v.match_val
set d.t_u_remind_xj = v.value_name;

-- 苯磺酸氨氯地平片（圣元）购买提醒
alter table u_dld_15 add column t_u_remind_sy varchar(200) default null comment '苯磺酸氨氯地平片（圣元）购买提醒';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_remind_sy' and t.t_u_remind_sy = v.match_val
set d.t_u_remind_sy = v.value_name;

-- 阿司匹林肠溶片(拜阿司匹灵)购买提醒
alter table u_dld_15 add column t_u_remind_baspl varchar(200) default null comment '阿司匹林肠溶片(拜阿司匹灵)购买提醒';

update u_dld_15 d left join u_tag_15 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_remind_baspl' and t.t_u_remind_baspl = v.match_val
set d.t_u_remind_baspl = v.value_name;

