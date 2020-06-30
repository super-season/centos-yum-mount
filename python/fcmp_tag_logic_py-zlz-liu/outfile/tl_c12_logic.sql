-- ----------------------------------
-- 客户12标签逻辑 2020-03-19 18:27:45
-- ----------------------------------
-- 生成tag表，含必显字段
drop table if exists u_tag_12;
create table u_tag_12 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户标签表'
select 
    name, phone, null dis
from 
    test_member_stores;
    
ALTER TABLE `u_tag_12`
ADD COLUMN `id`  int(11) NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `u_tag_12`
ADD INDEX `index_a` (name, phone) ;

-- 生成dld表
drop table if exists u_dld_12;
create table u_dld_12 like  u_tag_12;
insert into u_dld_12 select * from u_tag_12;

ALTER TABLE `u_dld_12`
COMMENT='用户下载表';

-- 生成mid表
drop table if exists u_mid_12;
create table u_mid_12 like  u_tag_12;
insert into u_mid_12 select * from u_tag_12;

ALTER TABLE `u_mid_12`
COMMENT='用户中间值表';

-- ----------------------------------
--            标签逻辑-标签表
-- ----------------------------------
-- -----------一级标签 身份特征-----------
-- b_1301_tag_type1_case_map
-- 性别
alter table u_tag_12 add column t_u_gender int(5) default 0 comment '性别';

update u_tag_12 
left join test_member_stores 
on u_tag_12.name = test_member_stores.name and u_tag_12.phone = test_member_stores.phone
set u_tag_12.t_u_gender = 
case
when test_member_stores.sex = '男' then 1
when test_member_stores.sex = '女' then 2
else 0 end;

-- b_2002_mid_type1_where
-- 过程值：月龄
alter table u_mid_12 add column age_months int(10) default -1 comment '过程值：月龄';

update u_mid_12 
left join test_member_stores 
on u_mid_12.name = test_member_stores.name and u_mid_12.phone = test_member_stores.phone
set u_mid_12.age_months = TIMESTAMPDIFF(MONTH, test_member_stores.birthday, CURDATE())
where true;

-- b_2002_mid_type1_where
-- 过程值：年龄
alter table u_mid_12 add column age_mid int(10) default 0 comment '过程值：年龄';

update u_mid_12 
set u_mid_12.age_mid = age_months/12
where true;

-- b_1101_tag_type1_case_between
-- 年龄
alter table u_tag_12 add column t_u_age int(5) default 0 comment '年龄';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_age = 
case
when u_mid_12.age_mid >= 0 and u_mid_12.age_mid <= 17 then 1
when u_mid_12.age_mid >= 18 and u_mid_12.age_mid <= 23 then 2
when u_mid_12.age_mid >= 24 and u_mid_12.age_mid <= 27 then 3
when u_mid_12.age_mid >= 28 and u_mid_12.age_mid <= 30 then 4
when u_mid_12.age_mid >= 31 and u_mid_12.age_mid <= 35 then 5
when u_mid_12.age_mid >= 36 and u_mid_12.age_mid <= 40 then 6
when u_mid_12.age_mid >= 41 and u_mid_12.age_mid <= 45 then 7
when u_mid_12.age_mid >= 46 and u_mid_12.age_mid <= 50 then 8
when u_mid_12.age_mid >= 51 and u_mid_12.age_mid <= 55 then 9
when u_mid_12.age_mid >= 56 and u_mid_12.age_mid <= 60 then 10
when u_mid_12.age_mid >= 61 and u_mid_12.age_mid <= 65 then 11
when u_mid_12.age_mid >= 66 and u_mid_12.age_mid <= 70 then 12
when u_mid_12.age_mid >= 71 then 13
else 0 end;

-- b_1301_tag_type1_case_map
-- 类型
alter table u_tag_12 add column t_u_identity_type int(5) default 0 comment '类型';

update u_tag_12 
left join test_member_stores 
on u_tag_12.name = test_member_stores.name and u_tag_12.phone = test_member_stores.phone
set u_tag_12.t_u_identity_type = 
case
when test_member_stores.member_type = '普通会员' then 1
when test_member_stores.member_type = '白金会员' then 2
when test_member_stores.member_type = '黑金会员' then 3
when test_member_stores.member_type = '钻石会员' then 4
else 0 end;

-- b_1301_tag_type1_case_map
-- 来源
alter table u_tag_12 add column t_u_source int(5) default 0 comment '来源';

update u_tag_12 
left join test_member_stores 
on u_tag_12.name = test_member_stores.name and u_tag_12.phone = test_member_stores.phone
set u_tag_12.t_u_source = 
case
when test_member_stores.source = '自营公众号' then 1
when test_member_stores.source = '淘宝商城' then 2
when test_member_stores.source = '京东商城' then 3
when test_member_stores.source = '活动推广' then 4
when test_member_stores.source = '其他' then 5
else 0 end;

-- -----------一级标签 消费特征-----------
-- b_3001_mid_type2_basic
-- 过程值：过程值：最后一次购买日期
alter table u_mid_12 add column last_buydate date default null comment '过程值：过程值：最后一次购买日期';

update u_mid_12 x inner join (
select u_mid_12.id, max(test_sales_summary.buy_date) c from 
u_mid_12 
inner join test_sales_summary 
on u_mid_12.name = test_sales_summary.name and u_mid_12.phone = test_sales_summary.phone
where true
group by u_mid_12.id
) y on x.id = y.id 
set last_buydate = y.c;

-- b_3001_mid_type2_basic
-- 过程值：过程值：第一次购买日期
alter table u_mid_12 add column first_buy date default null comment '过程值：过程值：第一次购买日期';

update u_mid_12 x inner join (
select u_mid_12.id, min(test_sales_summary.buy_date) c from 
u_mid_12 
inner join test_sales_summary 
on u_mid_12.name = test_sales_summary.name and u_mid_12.phone = test_sales_summary.phone
where true
group by u_mid_12.id
) y on x.id = y.id 
set first_buy = y.c;

-- b_3001_mid_type2_basic
-- 过程值：过程值：倒数第二次购买日期
alter table u_mid_12 add column last_second_buydate date default null comment '过程值：过程值：倒数第二次购买日期';

update u_mid_12 x inner join (
select u_mid_12.id, max(test_sales_summary.buy_date) c from 
u_mid_12 
inner join test_sales_summary 
on u_mid_12.name = test_sales_summary.name and u_mid_12.phone = test_sales_summary.phone
where test_sales_summary.buy_date != u_mid_12.last_buydate
group by u_mid_12.id
) y on x.id = y.id 
set last_second_buydate = y.c;

-- b_2002_mid_type1_where
-- 过程值：购买周期
alter table u_mid_12 add column between_lastsecond int(4) default 0 comment '过程值：购买周期';

update u_mid_12 
set u_mid_12.between_lastsecond = TIMESTAMPDIFF(DAY, last_second_buydate,last_buydate)
where true;

-- b_1101_tag_type1_case_between
-- 购买周期
alter table u_tag_12 add column t_u_buy_cycle int(5) default 0 comment '购买周期';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_buy_cycle = 
case
when u_mid_12.between_lastsecond >= 0 and u_mid_12.between_lastsecond <= 90 then 1
when u_mid_12.between_lastsecond >= 91 and u_mid_12.between_lastsecond <= 120 then 2
when u_mid_12.between_lastsecond >= 121 and u_mid_12.between_lastsecond <= 150 then 3
when u_mid_12.between_lastsecond >= 151 and u_mid_12.between_lastsecond <= 180 then 4
when u_mid_12.between_lastsecond >= 211 and u_mid_12.between_lastsecond <= 240 then 5
when u_mid_12.between_lastsecond >= 241 and u_mid_12.between_lastsecond <= 270 then 6
when u_mid_12.between_lastsecond >= 271 and u_mid_12.between_lastsecond <= 300 then 7
when u_mid_12.between_lastsecond >= 301 and u_mid_12.between_lastsecond <= 360 then 8
when u_mid_12.between_lastsecond >= 360 then 9
else 0 end;

-- b_2001_tag_type1_where
-- 购买偏好-成人中老年钙片
alter table u_tag_12 add column t_u_buy_preferences_1 int(5) default 0 comment '购买偏好-成人中老年钙片';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_buy_preferences_1 = 1
where test_sales_summary.buy_product_name like '%中老年%' 
and test_sales_summary.buy_product_name not like '%氨糖软骨素%';

-- b_2001_tag_type1_where
-- 购买偏好-儿童钙片
alter table u_tag_12 add column t_u_buy_preferences_2 int(5) default 0 comment '购买偏好-儿童钙片';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_buy_preferences_2 = 1
where test_sales_summary.buy_product_name like '%儿童%';

-- b_2001_tag_type1_where
-- 购买偏好-成人液体钙
alter table u_tag_12 add column t_u_buy_preferences_3 int(5) default 0 comment '购买偏好-成人液体钙';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_buy_preferences_3 = 1
where test_sales_summary.buy_product_name like '%液体钙%';

-- b_2001_tag_type1_where
-- 购买偏好-维生素D胶囊
alter table u_tag_12 add column t_u_buy_preferences_4 int(5) default 0 comment '购买偏好-维生素D胶囊';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_buy_preferences_4 = 1
where test_sales_summary.buy_product_name like '%维%' 
and test_sales_summary.buy_product_name  like '%胶囊%';

-- b_2001_tag_type1_where
-- 购买偏好-咀嚼片
alter table u_tag_12 add column t_u_buy_preferences_5 int(5) default 0 comment '购买偏好-咀嚼片';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_buy_preferences_5 = 1
where test_sales_summary.buy_product_name like '%咀嚼片%';

-- b_2001_tag_type1_where
-- 购买偏好-氨糖软骨素加钙片
alter table u_tag_12 add column t_u_buy_preferences_6 int(5) default 0 comment '购买偏好-氨糖软骨素加钙片';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_buy_preferences_6 = 1
where test_sales_summary.buy_product_name like '%氨糖%' ;

-- b_2001_tag_type1_where
-- 购买偏好-牛乳钙软糖
alter table u_tag_12 add column t_u_buy_preferences_7 int(5) default 0 comment '购买偏好-牛乳钙软糖';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_buy_preferences_7 = 1
where test_sales_summary.buy_product_name like '%牛乳钙%' ;

-- b_2001_tag_type1_where
-- 购买偏好-缺失
alter table u_tag_12 add column t_u_buy_preferences_0 int(5) default 0 comment '购买偏好-缺失';

update u_tag_12 
set u_tag_12.t_u_buy_preferences_0 = 1
where t_u_buy_preferences_1 = 0 and t_u_buy_preferences_2 = 0 and t_u_buy_preferences_3 = 0 and t_u_buy_preferences_4 = 0 and t_u_buy_preferences_5 = 0;

-- b_3001_mid_type2_basic
-- 过程值：过程值：钙片类购买次数
alter table u_mid_12 add column gaipian_buy_times int(8) default 0 comment '过程值：过程值：钙片类购买次数';

update u_mid_12 x inner join (
select u_mid_12.id, count(*) c from 
u_mid_12 
inner join test_sales_summary 
on u_mid_12.name = test_sales_summary.name and u_mid_12.phone = test_sales_summary.phone
where test_sales_summary.buy_product_name like '%钙片%'
and test_sales_summary.buy_product_name not like '%氨糖%'
group by u_mid_12.id
) y on x.id = y.id 
set gaipian_buy_times = y.c;

-- b_1101_tag_type1_case_between
-- 钙片类购买次数
alter table u_tag_12 add column t_u_buy_bumber int(5) default 0 comment '钙片类购买次数';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_buy_bumber = 
case
when u_mid_12.gaipian_buy_times >= 0 and u_mid_12.gaipian_buy_times <= 0 then 1
when u_mid_12.gaipian_buy_times >= 1 and u_mid_12.gaipian_buy_times <= 3 then 2
when u_mid_12.gaipian_buy_times >= 4 and u_mid_12.gaipian_buy_times <= 6 then 3
when u_mid_12.gaipian_buy_times >= 7 and u_mid_12.gaipian_buy_times <= 9 then 4
when u_mid_12.gaipian_buy_times >= 10 and u_mid_12.gaipian_buy_times <= 12 then 5
when u_mid_12.gaipian_buy_times >= 13 then 6
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：近一年到店次数
alter table u_mid_12 add column year_times int(5) default 0 comment '过程值：近一年到店次数';

update u_mid_12 x inner join (
select u_mid_12.id, count(*) c from 
u_mid_12 
inner join test_sales_summary 
on u_mid_12.name = test_sales_summary.name and u_mid_12.phone = test_sales_summary.phone
where u_mid_12.first_buy > date_sub(CURDATE(), interval 1 year)
group by u_mid_12.id
) y on x.id = y.id 
set year_times = y.c;

-- b_2001_tag_type1_where
-- 近一年到店月数
alter table u_tag_12 add column t_u_number_month int(5) default 0 comment '近一年到店月数';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_number_month = case   when u_mid_12.first_buy is null then 99   when u_mid_12.first_buy < date_sub(CURDATE(),interval 1 year) then 12.0   else datediff(CURDATE(),u_mid_12.first_buy)/30 end
where true;

-- b_2002_mid_type1_where
-- 过程值：近一年到店频率
alter table u_mid_12 add column last_year_rate decimal(12,2) default 0 comment '过程值：近一年到店频率';

update u_mid_12 
left join u_tag_12 
on u_mid_12.id = u_tag_12.id
set u_mid_12.last_year_rate = u_mid_12.year_times / u_tag_12.t_u_number_month
where true;

-- b_1101_tag_type1_case_between
-- 近一年到店频率
alter table u_tag_12 add column t_u_year_frequency int(5) default 0 comment '近一年到店频率';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_year_frequency = 
case
when u_mid_12.last_year_rate >= 0 and u_mid_12.last_year_rate <= 0.25 then 1
when u_mid_12.last_year_rate >= 0.26 and u_mid_12.last_year_rate <= 0.5 then 2
when u_mid_12.last_year_rate >= 0.51 then 3
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：总到店次数
alter table u_mid_12 add column times_total int(5) default 0 comment '过程值：总到店次数';

update u_mid_12 x inner join (
select u_mid_12.id, count(*) c from 
u_mid_12 
inner join test_sales_summary 
on u_mid_12.name = test_sales_summary.name and u_mid_12.phone = test_sales_summary.phone
where true
group by u_mid_12.id
) y on x.id = y.id 
set times_total = y.c;

-- b_1101_tag_type1_case_between
-- 总到店频率
alter table u_tag_12 add column t_u_times_total int(5) default 0 comment '总到店频率';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_times_total = 
case
when u_mid_12.times_total <= 0 then 1
when u_mid_12.times_total >= 1 and u_mid_12.times_total <= 3 then 2
when u_mid_12.times_total >= 4 and u_mid_12.times_total <= 6 then 3
when u_mid_12.times_total >= 7 and u_mid_12.times_total <= 9 then 4
when u_mid_12.times_total >= 10 and u_mid_12.times_total <= 12 then 5
when u_mid_12.times_total >= 13 then 6
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：消费金额总和
alter table u_mid_12 add column consumption_total int(11) default 0 comment '过程值：消费金额总和';

update u_mid_12 x inner join (
select u_mid_12.id, sum(test_sales_summary.buy_number * test_sales_summary.product_price) c from 
u_mid_12 
inner join test_sales_summary 
on u_mid_12.name = test_sales_summary.name and u_mid_12.phone = test_sales_summary.phone
where true
group by u_mid_12.id
) y on x.id = y.id 
set consumption_total = y.c;

-- b_1101_tag_type1_case_between
-- 消费金额总和
alter table u_tag_12 add column t_u_consumption_total int(5) default 0 comment '消费金额总和';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_consumption_total = 
case
when u_mid_12.consumption_total >= 1 and u_mid_12.consumption_total <= 50 then 1
when u_mid_12.consumption_total >= 51 and u_mid_12.consumption_total <= 100 then 2
when u_mid_12.consumption_total >= 100 and u_mid_12.consumption_total <= 200 then 3
when u_mid_12.consumption_total >= 201 and u_mid_12.consumption_total <= 500 then 4
when u_mid_12.consumption_total >= 501 and u_mid_12.consumption_total <= 1000 then 5
when u_mid_12.consumption_total >= 1001 then 6
else 0 end;

-- b_2002_mid_type1_where
-- 过程值：客单价
alter table u_mid_12 add column average_price decimal(12,2) default 0 comment '过程值：客单价';

update u_mid_12 
set u_mid_12.average_price = consumption_total/(case when times_total= 0  then 1   else times_total  end)
where true;

-- b_1101_tag_type1_case_between
-- 客单价
alter table u_tag_12 add column t_u_price int(5) default 0 comment '客单价';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_price = 
case
when u_mid_12.average_price >= 1 and u_mid_12.average_price <= 50 then 1
when u_mid_12.average_price >= 51 and u_mid_12.average_price <= 100 then 2
when u_mid_12.average_price >= 100 and u_mid_12.average_price <= 200 then 3
when u_mid_12.average_price >= 201 and u_mid_12.average_price <= 500 then 4
when u_mid_12.average_price >= 501 and u_mid_12.average_price <= 1000 then 5
when u_mid_12.average_price >= 1001 then 6
else 0 end;

-- -----------一级标签 产品使用特征-----------
-- b_2001_1_tag_type1_where
-- 产品类型-片剂
alter table u_tag_12 add column t_u_product_type_1 int(2) default 0 comment '产品类型-片剂';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_product_type_1 = 1
where test_product_detail.product_form like '%片剂%' and test_product_detail.product_fenlei like '%钙片%';

-- b_2001_1_tag_type1_where
-- 产品类型-软胶囊
alter table u_tag_12 add column t_u_product_type_2 int(2) default 0 comment '产品类型-软胶囊';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_product_type_2 = 1
where test_product_detail.product_form like '%软胶囊%' and test_product_detail.product_fenlei like '%钙片%';

-- b_2001_1_tag_type1_where
-- 产品类型-颗粒
alter table u_tag_12 add column t_u_product_type_3 int(2) default 0 comment '产品类型-颗粒';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_product_type_3 = 1
where test_product_detail.product_form like '%颗粒%' and test_product_detail.product_fenlei like '%钙片%';

-- b_2001_tag_type1_where
-- 购买偏好-缺失
alter table u_tag_12 add column t_u_product_type_0 int(2) default 0 comment '购买偏好-缺失';

update u_tag_12 
set u_tag_12.t_u_product_type_0 = 1
where t_u_product_type_1 != 1 and t_u_product_type_2 != 1 and t_u_product_type_3 != 1;

-- b_2001_1_tag_type1_where
-- 产品类型-片剂
alter table u_tag_12 add column t_u_tablet_specification_1 int(2) default 0 comment '产品类型-片剂';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_tablet_specification_1 = 1
where test_product_detail.product_form like '%片剂%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=50;

-- b_2001_1_tag_type1_where
-- 产品类型-片剂
alter table u_tag_12 add column t_u_tablet_specification_2 int(2) default 0 comment '产品类型-片剂';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_tablet_specification_2 = 1
where test_product_detail.product_form like '%片剂%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=60;

-- b_2001_1_tag_type1_where
-- 产品类型-片剂
alter table u_tag_12 add column t_u_tablet_specification_3 int(2) default 0 comment '产品类型-片剂';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_tablet_specification_3 = 1
where test_product_detail.product_form like '%片剂%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=80;

-- b_2001_1_tag_type1_where
-- 产品类型-片剂
alter table u_tag_12 add column t_u_tablet_specification_4 int(2) default 0 comment '产品类型-片剂';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_tablet_specification_4 = 1
where test_product_detail.product_form like '%片剂%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=92;

-- b_2001_1_tag_type1_where
-- 产品类型-片剂
alter table u_tag_12 add column t_u_tablet_specification_5 int(2) default 0 comment '产品类型-片剂';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_tablet_specification_5 = 1
where test_product_detail.product_form like '%片剂%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=100;

-- b_2001_1_tag_type1_where
-- 产品类型-片剂
alter table u_tag_12 add column t_u_tablet_specification_6 int(2) default 0 comment '产品类型-片剂';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_tablet_specification_6 = 1
where test_product_detail.product_form like '%片剂%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=120;

-- b_2001_1_tag_type1_where
-- 产品类型-片剂
alter table u_tag_12 add column t_u_tablet_specification_7 int(2) default 0 comment '产品类型-片剂';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_tablet_specification_7 = 1
where test_product_detail.product_form like '%片剂%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=198;

-- b_2001_1_tag_type1_where
-- 产品类型-片剂
alter table u_tag_12 add column t_u_tablet_specification_8 int(2) default 0 comment '产品类型-片剂';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_tablet_specification_8 = 1
where test_product_detail.product_form like '%片剂%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=200;

-- b_2001_1_tag_type1_where
-- 产品类型-片剂
alter table u_tag_12 add column t_u_tablet_specification_9 int(2) default 0 comment '产品类型-片剂';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_tablet_specification_9 = 1
where test_product_detail.product_form like '%片剂%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=300;

-- b_2001_1_tag_type1_where
-- 产品类型-片剂
alter table u_tag_12 add column t_u_tablet_specification_10 int(2) default 0 comment '产品类型-片剂';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_tablet_specification_10 = 1
where test_product_detail.product_form like '%片剂%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=396;

-- b_2001_tag_type1_where
-- 片剂规格-缺失
alter table u_tag_12 add column t_u_tablet_specification_0 int(2) default 0 comment '片剂规格-缺失';

update u_tag_12 
set u_tag_12.t_u_tablet_specification_0 = 1
where t_u_tablet_specification_1 != 1 and t_u_tablet_specification_2 != 1 and t_u_tablet_specification_3 != 1 and t_u_tablet_specification_4 != 1 and t_u_tablet_specification_5 != 1 and t_u_tablet_specification_6 != 1 and t_u_tablet_specification_7 != 1 and t_u_tablet_specification_8 != 1 and t_u_tablet_specification_9 != 1 and t_u_tablet_specification_10 != 1;

-- b_2001_1_tag_type1_where
-- 产品类型-胶囊
alter table u_tag_12 add column t_u_capsule_specification_1 int(2) default 0 comment '产品类型-胶囊';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_capsule_specification_1 = 1
where test_product_detail.product_form like '%软胶囊%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=30;

-- b_2001_1_tag_type1_where
-- 产品类型-胶囊
alter table u_tag_12 add column t_u_capsule_specification_2 int(2) default 0 comment '产品类型-胶囊';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_capsule_specification_2 = 1
where test_product_detail.product_form like '%软胶囊%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=90;

-- b_2001_1_tag_type1_where
-- 产品类型-胶囊
alter table u_tag_12 add column t_u_capsule_specification_3 int(2) default 0 comment '产品类型-胶囊';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_capsule_specification_3 = 1
where test_product_detail.product_form like '%软胶囊%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=110;

-- b_2001_1_tag_type1_where
-- 产品类型-胶囊
alter table u_tag_12 add column t_u_capsule_specification_4 int(2) default 0 comment '产品类型-胶囊';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_capsule_specification_4 = 1
where test_product_detail.product_form like '%软胶囊%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=150;

-- b_2001_1_tag_type1_where
-- 产品类型-胶囊
alter table u_tag_12 add column t_u_capsule_specification_5 int(2) default 0 comment '产品类型-胶囊';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_capsule_specification_5 = 1
where test_product_detail.product_form like '%软胶囊%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=180;

-- b_2001_tag_type1_where
-- 胶囊规格-缺失
alter table u_tag_12 add column t_u_capsule_specification_0 int(2) default 0 comment '胶囊规格-缺失';

update u_tag_12 
set u_tag_12.t_u_capsule_specification_0 = 1
where t_u_capsule_specification_1 != 1 and t_u_capsule_specification_2 != 1 and t_u_capsule_specification_3 != 1 and t_u_capsule_specification_4 != 1 and t_u_capsule_specification_5 != 1;

-- b_2001_1_tag_type1_where
-- 产品类型-颗粒
alter table u_tag_12 add column t_u_particle_specification_1 int(2) default 0 comment '产品类型-颗粒';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_particle_specification_1 = 1
where test_product_detail.product_form like '%颗粒%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=40;

-- b_2001_1_tag_type1_where
-- 产品类型-颗粒
alter table u_tag_12 add column t_u_particle_specification_2 int(2) default 0 comment '产品类型-颗粒';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_particle_specification_2 = 1
where test_product_detail.product_form like '%颗粒%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=48;

-- b_2001_1_tag_type1_where
-- 产品类型-颗粒
alter table u_tag_12 add column t_u_particle_specification_3 int(2) default 0 comment '产品类型-颗粒';

update u_tag_12  
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone  
left join test_product_detail 
on test_sales_summary.product_ID = test_product_detail.product_ID
set u_tag_12.t_u_particle_specification_3 = 1
where test_product_detail.product_form like '%颗粒%'and test_product_detail.product_fenlei like '%钙片%'and test_product_detail.Specifications_number=80;

-- b_2001_tag_type1_where
-- 颗粒规格-缺失
alter table u_tag_12 add column t_u_particle_specification_0 int(2) default 0 comment '颗粒规格-缺失';

update u_tag_12 
set u_tag_12.t_u_particle_specification_0 = 1
where t_u_particle_specification_1 != 1 and t_u_particle_specification_2 != 1 and t_u_particle_specification_3 != 1;

-- b_1101_tag_type1_case_between
-- 服用周期
alter table u_tag_12 add column t_u_taking_cycle int(5) default 0 comment '服用周期';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_taking_cycle = 
case
when u_mid_12.between_lastsecond >= 0 and u_mid_12.between_lastsecond <= 90 then 1
when u_mid_12.between_lastsecond >= 91 and u_mid_12.between_lastsecond <= 120 then 2
when u_mid_12.between_lastsecond >= 121 and u_mid_12.between_lastsecond <= 150 then 3
when u_mid_12.between_lastsecond >= 151 and u_mid_12.between_lastsecond <= 180 then 4
when u_mid_12.between_lastsecond >= 211 and u_mid_12.between_lastsecond <= 240 then 5
when u_mid_12.between_lastsecond >= 241 and u_mid_12.between_lastsecond <= 270 then 6
when u_mid_12.between_lastsecond >= 271 and u_mid_12.between_lastsecond <= 300 then 7
when u_mid_12.between_lastsecond >= 301 and u_mid_12.between_lastsecond <= 360 then 8
when u_mid_12.between_lastsecond >= 360 then 9
else 0 end;

-- -----------一级标签 营销偏好特征-----------
-- b_2001_tag_type1_where
-- 限时/限量激励活动偏好-前1000件买一送一
alter table u_tag_12 add column t_u_sale_activity_1 int(2) default 0 comment '限时/限量激励活动偏好-前1000件买一送一';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_sale_activity_1 = 1
where test_sales_summary.activity_type like '%前1000件买一送一%';

-- b_2001_tag_type1_where
-- 限时/限量激励活动偏好-前500件买一送一
alter table u_tag_12 add column t_u_sale_activity_2 int(2) default 0 comment '限时/限量激励活动偏好-前500件买一送一';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_sale_activity_2 = 1
where test_sales_summary.activity_type like '%前500件买一送一%';

-- b_2001_tag_type1_where
-- 限时/限量激励活动偏好-限时第2件半价
alter table u_tag_12 add column t_u_sale_activity_3 int(2) default 0 comment '限时/限量激励活动偏好-限时第2件半价';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_sale_activity_3 = 1
where test_sales_summary.activity_type like '%限时第2件半价%';

-- b_2001_tag_type1_where
-- 限时/限量激励活动偏好-前200件买就送100粒
alter table u_tag_12 add column t_u_sale_activity_4 int(2) default 0 comment '限时/限量激励活动偏好-前200件买就送100粒';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_sale_activity_4 = 1
where test_sales_summary.activity_type like '%前200件买就送100粒%';

-- b_2001_tag_type1_where
-- 限时/限量激励活动偏好-前2小时第2件0元
alter table u_tag_12 add column t_u_sale_activity_5 int(2) default 0 comment '限时/限量激励活动偏好-前2小时第2件0元';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_sale_activity_5 = 1
where test_sales_summary.activity_type like '%前2小时第2件0元%';

-- b_2001_tag_type1_where
-- 限时/限量激励活动偏好-未参与
alter table u_tag_12 add column t_u_sale_activity_0 int(2) default 0 comment '限时/限量激励活动偏好-未参与';

update u_tag_12 
set u_tag_12.t_u_sale_activity_0 = 1
where t_u_sale_activity_1 != 1 and t_u_sale_activity_2 != 1 and t_u_sale_activity_3 != 1 and t_u_sale_activity_4 != 1 and t_u_sale_activity_5 != 1;

-- b_2001_tag_type1_where
-- 满减促销活动偏好-满199减80
alter table u_tag_12 add column t_u_full_reduction_1 int(2) default 0 comment '满减促销活动偏好-满199减80';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_full_reduction_1 = 1
where test_sales_summary.activity_type like '%满199减80%';

-- b_2001_tag_type1_where
-- 满减促销活动偏好-满400减199
alter table u_tag_12 add column t_u_full_reduction_2 int(2) default 0 comment '满减促销活动偏好-满400减199';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_full_reduction_2 = 1
where test_sales_summary.activity_type like '%满400减199%';

-- b_2001_tag_type1_where
-- 满减促销活动偏好-满2件享受75折
alter table u_tag_12 add column t_u_full_reduction_3 int(2) default 0 comment '满减促销活动偏好-满2件享受75折';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_full_reduction_3 = 1
where test_sales_summary.activity_type like '%满2件享受75折%';

-- b_2001_tag_type1_where
-- 满减促销活动偏好-满3件享受66折
alter table u_tag_12 add column t_u_full_reduction_4 int(2) default 0 comment '满减促销活动偏好-满3件享受66折';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_full_reduction_4 = 1
where test_sales_summary.activity_type like '%满3件享受66折%';

-- b_2001_tag_type1_where
-- 满减促销活动偏好-未参与
alter table u_tag_12 add column t_u_full_reduction_0 int(2) default 0 comment '满减促销活动偏好-未参与';

update u_tag_12 
set u_tag_12.t_u_full_reduction_0 = 1
where t_u_full_reduction_1 != 1 and t_u_full_reduction_2 != 1 and t_u_full_reduction_3 != 1 and t_u_full_reduction_4 != 1;

-- b_2001_tag_type1_where
-- 预售付定金活动偏好-预定50元立减10
alter table u_tag_12 add column t_u_advance_payment_1 int(2) default 0 comment '预售付定金活动偏好-预定50元立减10';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_advance_payment_1 = 1
where test_sales_summary.activity_type like '%预定50元立减10%';

-- b_2001_tag_type1_where
-- 预售付定金活动偏好-定金100元抵150元
alter table u_tag_12 add column t_u_advance_payment_2 int(2) default 0 comment '预售付定金活动偏好-定金100元抵150元';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_advance_payment_2 = 1
where test_sales_summary.activity_type like '%定金100元抵150元%';

-- b_2001_tag_type1_where
-- 预售付定金活动偏好-定金200元抵350元
alter table u_tag_12 add column t_u_advance_payment_3 int(2) default 0 comment '预售付定金活动偏好-定金200元抵350元';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_advance_payment_3 = 1
where test_sales_summary.activity_type like '%定金200元抵350元%';

-- b_2001_tag_type1_where
-- 预售付定金活动偏好-未参与
alter table u_tag_12 add column t_u_advance_payment_0 int(2) default 0 comment '预售付定金活动偏好-未参与';

update u_tag_12 
set u_tag_12.t_u_advance_payment_0 = 1
where t_u_advance_payment_1 != 1 and t_u_advance_payment_2 != 1 and t_u_advance_payment_3 != 1;

-- b_2001_tag_type1_where
-- 是否参与京东618品质狂欢节
alter table u_tag_12 add column t_u_jingdong618_carnival int(2) default 0 comment '是否参与京东618品质狂欢节';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_jingdong618_carnival = 1
where test_sales_summary.activity_name like '%京东618品质狂欢节%';

-- b_2001_tag_type1_where
-- 是否参与天猫618理想生活狂欢节
alter table u_tag_12 add column t_u_tianmao618_carnival int(2) default 0 comment '是否参与天猫618理想生活狂欢节';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_tianmao618_carnival = 1
where test_sales_summary.activity_name like '%天猫618理想生活狂欢节%';

-- b_2001_tag_type1_where
-- 是否参与天猫双十一购物狂欢节
alter table u_tag_12 add column t_u_tianmao1111_carnival int(2) default 0 comment '是否参与天猫双十一购物狂欢节';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_tianmao1111_carnival = 1
where test_sales_summary.activity_name like '%天猫双十一购物狂欢节%';

-- b_2001_tag_type1_where
-- 是否参与天猫双十二购物狂欢节
alter table u_tag_12 add column t_u_tianmao1212_carnival int(2) default 0 comment '是否参与天猫双十二购物狂欢节';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_tianmao1212_carnival = 1
where test_sales_summary.activity_name like '%天猫双十二购物狂欢节%';

-- b_2001_tag_type1_where
-- 是否参与阿里年货节
alter table u_tag_12 add column t_u_ali_shopping int(2) default 0 comment '是否参与阿里年货节';

update u_tag_12 
left join test_sales_summary 
on u_tag_12.name = test_sales_summary.name and u_tag_12.phone = test_sales_summary.phone
set u_tag_12.t_u_ali_shopping = 1
where test_sales_summary.activity_name like '%阿里年货节%';

-- -----------一级标签 自定义：再次购买提醒-----------
-- b_3001_mid_type2_basic
-- 过程值：过程值-50片学生儿童钙片最后一次购买日期
alter table u_mid_12 add column last_buy_50 date default null comment '过程值：过程值-50片学生儿童钙片最后一次购买日期';

update u_mid_12 x inner join (
select u_mid_12.id, max(buy_date) c from 
u_mid_12 
inner join test_sales_summary 
on u_mid_12.name = test_sales_summary.name and u_mid_12.phone = test_sales_summary.phone
where test_sales_summary.buy_product_name like '%50片学生儿童钙片%'
group by u_mid_12.id
) y on x.id = y.id 
set last_buy_50 = y.c;

-- b_2002_mid_type1_where
-- 过程值：50片学生儿童钙片提醒天数
alter table u_mid_12 add column buy_50 int(10) default -1 comment '过程值：50片学生儿童钙片提醒天数';

update u_mid_12 
set u_mid_12.buy_50 = TIMESTAMPDIFF(DAY, last_buy_50, CURDATE()) - 25
where true;

-- b_1101_tag_type1_case_between
-- 50片学生儿童钙片
alter table u_tag_12 add column t_u_Children_calcium_50 int(5) default 0 comment '50片学生儿童钙片';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_Children_calcium_50 = 
case
when u_mid_12.buy_50 <= 5 then 1
when u_mid_12.buy_50 >= 6 and u_mid_12.buy_50 <= 15 then 2
when u_mid_12.buy_50 >= 16 and u_mid_12.buy_50 <= 30 then 3
when u_mid_12.buy_50 >= 31 and u_mid_12.buy_50 <= 60 then 4
when u_mid_12.buy_50 >= 61 and u_mid_12.buy_50 <= 90 then 5
when u_mid_12.buy_50 >= 91 then 6
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：过程值-80片学生儿童钙片最后一次购买日期
alter table u_mid_12 add column last_buy_80 date default null comment '过程值：过程值-80片学生儿童钙片最后一次购买日期';

update u_mid_12 x inner join (
select u_mid_12.id, max(buy_date) c from 
u_mid_12 
inner join test_sales_summary 
on u_mid_12.name = test_sales_summary.name and u_mid_12.phone = test_sales_summary.phone
where test_sales_summary.buy_product_name like '%80片学生儿童钙片%'
group by u_mid_12.id
) y on x.id = y.id 
set last_buy_80 = y.c;

-- b_2002_mid_type1_where
-- 过程值：80片学生儿童钙片提醒天数
alter table u_mid_12 add column buy_80 int(10) default -1 comment '过程值：80片学生儿童钙片提醒天数';

update u_mid_12 
set u_mid_12.buy_80 = TIMESTAMPDIFF(DAY, last_buy_80, CURDATE()) - 40
where true;

-- b_1101_tag_type1_case_between
-- 50片学生儿童钙片
alter table u_tag_12 add column t_u_Children_calcium_80 int(5) default 0 comment '50片学生儿童钙片';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_Children_calcium_80 = 
case
when u_mid_12.buy_80 <= 5 then 1
when u_mid_12.buy_80 >= 6 and u_mid_12.buy_80 <= 15 then 2
when u_mid_12.buy_80 >= 16 and u_mid_12.buy_80 <= 30 then 3
when u_mid_12.buy_80 >= 31 and u_mid_12.buy_80 <= 60 then 4
when u_mid_12.buy_80 >= 61 and u_mid_12.buy_80 <= 90 then 5
when u_mid_12.buy_80 >= 91 then 6
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：过程值-198片维生素D成人钙片最后一次购买日期
alter table u_mid_12 add column last_buy_198 date default null comment '过程值：过程值-198片维生素D成人钙片最后一次购买日期';

update u_mid_12 x inner join (
select u_mid_12.id, max(buy_date) c from 
u_mid_12 
inner join test_sales_summary 
on u_mid_12.name = test_sales_summary.name and u_mid_12.phone = test_sales_summary.phone
where test_sales_summary.buy_product_name like '%198片维生素D成人钙片%'
group by u_mid_12.id
) y on x.id = y.id 
set last_buy_198 = y.c;

-- b_2002_mid_type1_where
-- 过程值：198片维生素D成人钙片提醒天数
alter table u_mid_12 add column buy_198 int(10) default -1 comment '过程值：198片维生素D成人钙片提醒天数';

update u_mid_12 
set u_mid_12.buy_198 = TIMESTAMPDIFF(DAY, last_buy_198, CURDATE()) - 100
where true;

-- b_1101_tag_type1_case_between
-- 198片维生素D成人钙片
alter table u_tag_12 add column t_u_Adult_calcium_198 int(5) default 0 comment '198片维生素D成人钙片';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_Adult_calcium_198 = 
case
when u_mid_12.buy_198 <= 5 then 1
when u_mid_12.buy_198 >= 6 and u_mid_12.buy_198 <= 15 then 2
when u_mid_12.buy_198 >= 16 and u_mid_12.buy_198 <= 30 then 3
when u_mid_12.buy_198 >= 31 and u_mid_12.buy_198 <= 60 then 4
when u_mid_12.buy_198 >= 61 and u_mid_12.buy_198 <= 90 then 5
when u_mid_12.buy_198 >= 91 then 6
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：过程值-300片成人中老年钙片最后一次购买日期
alter table u_mid_12 add column last_buy_300 date default null comment '过程值：过程值-300片成人中老年钙片最后一次购买日期';

update u_mid_12 x inner join (
select u_mid_12.id, max(buy_date) c from 
u_mid_12 
inner join test_sales_summary 
on u_mid_12.name = test_sales_summary.name and u_mid_12.phone = test_sales_summary.phone
where test_sales_summary.buy_product_name like '%300片成人中老年钙片%'
group by u_mid_12.id
) y on x.id = y.id 
set last_buy_300 = y.c;

-- b_2002_mid_type1_where
-- 过程值：300片成人中老年钙片提醒天数
alter table u_mid_12 add column buy_300 int(10) default -1 comment '过程值：300片成人中老年钙片提醒天数';

update u_mid_12 
set u_mid_12.buy_300 = TIMESTAMPDIFF(DAY, last_buy_300, CURDATE()) - 150
where true;

-- b_1101_tag_type1_case_between
-- 300片成人中老年钙片
alter table u_tag_12 add column t_u_elderly_calcium_300 int(5) default 0 comment '300片成人中老年钙片';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_elderly_calcium_300 = 
case
when u_mid_12.buy_300 <= 5 then 1
when u_mid_12.buy_300 >= 6 and u_mid_12.buy_300 <= 15 then 2
when u_mid_12.buy_300 >= 16 and u_mid_12.buy_300 <= 30 then 3
when u_mid_12.buy_300 >= 31 and u_mid_12.buy_300 <= 60 then 4
when u_mid_12.buy_300 >= 61 and u_mid_12.buy_300 <= 90 then 5
when u_mid_12.buy_300 >= 91 then 6
else 0 end;

-- b_2002_mid_type1_where
-- 过程值：关注时间
alter table u_mid_12 add column focus int(4) default 0 comment '过程值：关注时间';

update u_mid_12 
left join test_member_stores 
on u_mid_12.name = test_member_stores.name and u_mid_12.phone = test_member_stores.phone
set u_mid_12.focus =  TIMESTAMPDIFF(DAY, test_member_stores.focus_date, CURDATE())
where true;

-- b_1101_tag_type1_case_between
-- 新关注用户营销提醒
alter table u_tag_12 add column t_u_attention_reminder int(5) default 0 comment '新关注用户营销提醒';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_attention_reminder = 
case
when u_mid_12.focus >= 0 and u_mid_12.focus <= 5 then 1
when u_mid_12.focus >= 6 and u_mid_12.focus <= 15 then 2
when u_mid_12.focus >= 16 and u_mid_12.focus <= 30 then 3
when u_mid_12.focus >= 31 and u_mid_12.focus <= 60 then 4
when u_mid_12.focus >= 61 and u_mid_12.focus <= 90 then 5
when u_mid_12.focus >= 91 then 6
else 0 end;

-- b_2002_mid_type1_where
-- 过程值加购物车时间
alter table u_mid_12 add column shopping int(4) default 0 comment '过程值加购物车时间';

update u_mid_12 
left join test_member_stores 
on u_mid_12.name = test_member_stores.name and u_mid_12.phone = test_member_stores.phone
set u_mid_12.shopping = TIMESTAMPDIFF(DAY, test_member_stores.join_shopping_date, CURDATE())
where true;

-- b_1101_tag_type1_case_between
-- 加购物车用户营销提醒
alter table u_tag_12 add column t_u_Cart_reminder int(5) default 0 comment '加购物车用户营销提醒';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_Cart_reminder = 
case
when u_mid_12.shopping <= 5 then 1
when u_mid_12.shopping >= 6 and u_mid_12.shopping <= 15 then 2
when u_mid_12.shopping >= 16 and u_mid_12.shopping <= 30 then 3
when u_mid_12.shopping >= 31 and u_mid_12.shopping <= 60 then 4
when u_mid_12.shopping >= 61 and u_mid_12.shopping <= 90 then 5
when u_mid_12.shopping >= 91 then 6
else 0 end;

-- ----------------------------------
--            下载表生成
-- ----------------------------------
-- b7_dld_gen
-- 性别
alter table u_dld_12 add column t_u_gender varchar(200) default null comment '性别';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_gender' and t.t_u_gender = v.match_val
set d.t_u_gender = v.value_name;
-- 年龄
alter table u_dld_12 add column t_u_age varchar(200) default null comment '年龄';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_age' and t.t_u_age = v.match_val
set d.t_u_age = v.value_name;
-- 类型
alter table u_dld_12 add column t_u_identity_type varchar(200) default null comment '类型';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_identity_type' and t.t_u_identity_type = v.match_val
set d.t_u_identity_type = v.value_name;
-- 来源
alter table u_dld_12 add column t_u_source varchar(200) default null comment '来源';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_source' and t.t_u_source = v.match_val
set d.t_u_source = v.value_name;
-- 购买周期
alter table u_dld_12 add column t_u_buy_cycle varchar(200) default null comment '购买周期';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_cycle' and t.t_u_buy_cycle = v.match_val
set d.t_u_buy_cycle = v.value_name;
-- 购买偏好
alter table u_dld_12 add column t_u_buy_preferences varchar(200) default null comment '购买偏好';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_preferences_0' and t.t_u_buy_preferences_0 = v.match_val
set d.t_u_buy_preferences = 
case
when d.t_u_buy_preferences is null then v.value_name
else concat(d.t_u_buy_preferences, ',', v.value_name) end
where t.t_u_buy_preferences_0 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_preferences_1' and t.t_u_buy_preferences_1 = v.match_val
set d.t_u_buy_preferences = 
case
when d.t_u_buy_preferences is null then v.value_name
else concat(d.t_u_buy_preferences, ',', v.value_name) end
where t.t_u_buy_preferences_1 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_preferences_2' and t.t_u_buy_preferences_2 = v.match_val
set d.t_u_buy_preferences = 
case
when d.t_u_buy_preferences is null then v.value_name
else concat(d.t_u_buy_preferences, ',', v.value_name) end
where t.t_u_buy_preferences_2 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_preferences_3' and t.t_u_buy_preferences_3 = v.match_val
set d.t_u_buy_preferences = 
case
when d.t_u_buy_preferences is null then v.value_name
else concat(d.t_u_buy_preferences, ',', v.value_name) end
where t.t_u_buy_preferences_3 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_preferences_4' and t.t_u_buy_preferences_4 = v.match_val
set d.t_u_buy_preferences = 
case
when d.t_u_buy_preferences is null then v.value_name
else concat(d.t_u_buy_preferences, ',', v.value_name) end
where t.t_u_buy_preferences_4 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_preferences_5' and t.t_u_buy_preferences_5 = v.match_val
set d.t_u_buy_preferences = 
case
when d.t_u_buy_preferences is null then v.value_name
else concat(d.t_u_buy_preferences, ',', v.value_name) end
where t.t_u_buy_preferences_5 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_preferences_6' and t.t_u_buy_preferences_6 = v.match_val
set d.t_u_buy_preferences = 
case
when d.t_u_buy_preferences is null then v.value_name
else concat(d.t_u_buy_preferences, ',', v.value_name) end
where t.t_u_buy_preferences_6 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_preferences_7' and t.t_u_buy_preferences_7 = v.match_val
set d.t_u_buy_preferences = 
case
when d.t_u_buy_preferences is null then v.value_name
else concat(d.t_u_buy_preferences, ',', v.value_name) end
where t.t_u_buy_preferences_7 = 1;

-- 钙片类购买次数
alter table u_dld_12 add column t_u_buy_bumber varchar(200) default null comment '钙片类购买次数';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_bumber' and t.t_u_buy_bumber = v.match_val
set d.t_u_buy_bumber = v.value_name;
-- 近一年到店频率
alter table u_dld_12 add column t_u_year_frequency varchar(200) default null comment '近一年到店频率';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_year_frequency' and t.t_u_year_frequency = v.match_val
set d.t_u_year_frequency = v.value_name;
-- 总到店次数
alter table u_dld_12 add column t_u_times_total varchar(200) default null comment '总到店次数';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_times_total' and t.t_u_times_total = v.match_val
set d.t_u_times_total = v.value_name;
-- 消费金额总和
alter table u_dld_12 add column t_u_consumption_total varchar(200) default null comment '消费金额总和';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_consumption_total' and t.t_u_consumption_total = v.match_val
set d.t_u_consumption_total = v.value_name;
-- 客单价
alter table u_dld_12 add column t_u_price varchar(200) default null comment '客单价';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_price' and t.t_u_price = v.match_val
set d.t_u_price = v.value_name;
-- 产品类型
alter table u_dld_12 add column t_u_product_type varchar(200) default null comment '产品类型';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_type_0' and t.t_u_product_type_0 = v.match_val
set d.t_u_product_type = 
case
when d.t_u_product_type is null then v.value_name
else concat(d.t_u_product_type, ',', v.value_name) end
where t.t_u_product_type_0 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_type_1' and t.t_u_product_type_1 = v.match_val
set d.t_u_product_type = 
case
when d.t_u_product_type is null then v.value_name
else concat(d.t_u_product_type, ',', v.value_name) end
where t.t_u_product_type_1 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_type_2' and t.t_u_product_type_2 = v.match_val
set d.t_u_product_type = 
case
when d.t_u_product_type is null then v.value_name
else concat(d.t_u_product_type, ',', v.value_name) end
where t.t_u_product_type_2 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_type_3' and t.t_u_product_type_3 = v.match_val
set d.t_u_product_type = 
case
when d.t_u_product_type is null then v.value_name
else concat(d.t_u_product_type, ',', v.value_name) end
where t.t_u_product_type_3 = 1;

-- 片剂规格
alter table u_dld_12 add column t_u_tablet_specification varchar(200) default null comment '片剂规格';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tablet_specification_0' and t.t_u_tablet_specification_0 = v.match_val
set d.t_u_tablet_specification = 
case
when d.t_u_tablet_specification is null then v.value_name
else concat(d.t_u_tablet_specification, ',', v.value_name) end
where t.t_u_tablet_specification_0 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tablet_specification_1' and t.t_u_tablet_specification_1 = v.match_val
set d.t_u_tablet_specification = 
case
when d.t_u_tablet_specification is null then v.value_name
else concat(d.t_u_tablet_specification, ',', v.value_name) end
where t.t_u_tablet_specification_1 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tablet_specification_2' and t.t_u_tablet_specification_2 = v.match_val
set d.t_u_tablet_specification = 
case
when d.t_u_tablet_specification is null then v.value_name
else concat(d.t_u_tablet_specification, ',', v.value_name) end
where t.t_u_tablet_specification_2 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tablet_specification_3' and t.t_u_tablet_specification_3 = v.match_val
set d.t_u_tablet_specification = 
case
when d.t_u_tablet_specification is null then v.value_name
else concat(d.t_u_tablet_specification, ',', v.value_name) end
where t.t_u_tablet_specification_3 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tablet_specification_4' and t.t_u_tablet_specification_4 = v.match_val
set d.t_u_tablet_specification = 
case
when d.t_u_tablet_specification is null then v.value_name
else concat(d.t_u_tablet_specification, ',', v.value_name) end
where t.t_u_tablet_specification_4 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tablet_specification_5' and t.t_u_tablet_specification_5 = v.match_val
set d.t_u_tablet_specification = 
case
when d.t_u_tablet_specification is null then v.value_name
else concat(d.t_u_tablet_specification, ',', v.value_name) end
where t.t_u_tablet_specification_5 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tablet_specification_6' and t.t_u_tablet_specification_6 = v.match_val
set d.t_u_tablet_specification = 
case
when d.t_u_tablet_specification is null then v.value_name
else concat(d.t_u_tablet_specification, ',', v.value_name) end
where t.t_u_tablet_specification_6 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tablet_specification_7' and t.t_u_tablet_specification_7 = v.match_val
set d.t_u_tablet_specification = 
case
when d.t_u_tablet_specification is null then v.value_name
else concat(d.t_u_tablet_specification, ',', v.value_name) end
where t.t_u_tablet_specification_7 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tablet_specification_8' and t.t_u_tablet_specification_8 = v.match_val
set d.t_u_tablet_specification = 
case
when d.t_u_tablet_specification is null then v.value_name
else concat(d.t_u_tablet_specification, ',', v.value_name) end
where t.t_u_tablet_specification_8 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tablet_specification_9' and t.t_u_tablet_specification_9 = v.match_val
set d.t_u_tablet_specification = 
case
when d.t_u_tablet_specification is null then v.value_name
else concat(d.t_u_tablet_specification, ',', v.value_name) end
where t.t_u_tablet_specification_9 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tablet_specification_10' and t.t_u_tablet_specification_10 = v.match_val
set d.t_u_tablet_specification = 
case
when d.t_u_tablet_specification is null then v.value_name
else concat(d.t_u_tablet_specification, ',', v.value_name) end
where t.t_u_tablet_specification_10 = 1;

-- 胶囊规格
alter table u_dld_12 add column t_u_capsule_specification varchar(200) default null comment '胶囊规格';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_capsule_specification_0' and t.t_u_capsule_specification_0 = v.match_val
set d.t_u_capsule_specification = 
case
when d.t_u_capsule_specification is null then v.value_name
else concat(d.t_u_capsule_specification, ',', v.value_name) end
where t.t_u_capsule_specification_0 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_capsule_specification_1' and t.t_u_capsule_specification_1 = v.match_val
set d.t_u_capsule_specification = 
case
when d.t_u_capsule_specification is null then v.value_name
else concat(d.t_u_capsule_specification, ',', v.value_name) end
where t.t_u_capsule_specification_1 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_capsule_specification_2' and t.t_u_capsule_specification_2 = v.match_val
set d.t_u_capsule_specification = 
case
when d.t_u_capsule_specification is null then v.value_name
else concat(d.t_u_capsule_specification, ',', v.value_name) end
where t.t_u_capsule_specification_2 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_capsule_specification_3' and t.t_u_capsule_specification_3 = v.match_val
set d.t_u_capsule_specification = 
case
when d.t_u_capsule_specification is null then v.value_name
else concat(d.t_u_capsule_specification, ',', v.value_name) end
where t.t_u_capsule_specification_3 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_capsule_specification_4' and t.t_u_capsule_specification_4 = v.match_val
set d.t_u_capsule_specification = 
case
when d.t_u_capsule_specification is null then v.value_name
else concat(d.t_u_capsule_specification, ',', v.value_name) end
where t.t_u_capsule_specification_4 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_capsule_specification_5' and t.t_u_capsule_specification_5 = v.match_val
set d.t_u_capsule_specification = 
case
when d.t_u_capsule_specification is null then v.value_name
else concat(d.t_u_capsule_specification, ',', v.value_name) end
where t.t_u_capsule_specification_5 = 1;

-- 颗粒规格
alter table u_dld_12 add column t_u_particle_specification varchar(200) default null comment '颗粒规格';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_particle_specification_0' and t.t_u_particle_specification_0 = v.match_val
set d.t_u_particle_specification = 
case
when d.t_u_particle_specification is null then v.value_name
else concat(d.t_u_particle_specification, ',', v.value_name) end
where t.t_u_particle_specification_0 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_particle_specification_1' and t.t_u_particle_specification_1 = v.match_val
set d.t_u_particle_specification = 
case
when d.t_u_particle_specification is null then v.value_name
else concat(d.t_u_particle_specification, ',', v.value_name) end
where t.t_u_particle_specification_1 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_particle_specification_2' and t.t_u_particle_specification_2 = v.match_val
set d.t_u_particle_specification = 
case
when d.t_u_particle_specification is null then v.value_name
else concat(d.t_u_particle_specification, ',', v.value_name) end
where t.t_u_particle_specification_2 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_particle_specification_3' and t.t_u_particle_specification_3 = v.match_val
set d.t_u_particle_specification = 
case
when d.t_u_particle_specification is null then v.value_name
else concat(d.t_u_particle_specification, ',', v.value_name) end
where t.t_u_particle_specification_3 = 1;

-- 服用周期
alter table u_dld_12 add column t_u_taking_cycle varchar(200) default null comment '服用周期';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_taking_cycle' and t.t_u_taking_cycle = v.match_val
set d.t_u_taking_cycle = v.value_name;
-- 限时/限量激励活动偏好
alter table u_dld_12 add column t_u_sale_activity varchar(200) default null comment '限时/限量激励活动偏好';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_sale_activity_0' and t.t_u_sale_activity_0 = v.match_val
set d.t_u_sale_activity = 
case
when d.t_u_sale_activity is null then v.value_name
else concat(d.t_u_sale_activity, ',', v.value_name) end
where t.t_u_sale_activity_0 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_sale_activity_1' and t.t_u_sale_activity_1 = v.match_val
set d.t_u_sale_activity = 
case
when d.t_u_sale_activity is null then v.value_name
else concat(d.t_u_sale_activity, ',', v.value_name) end
where t.t_u_sale_activity_1 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_sale_activity_2' and t.t_u_sale_activity_2 = v.match_val
set d.t_u_sale_activity = 
case
when d.t_u_sale_activity is null then v.value_name
else concat(d.t_u_sale_activity, ',', v.value_name) end
where t.t_u_sale_activity_2 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_sale_activity_3' and t.t_u_sale_activity_3 = v.match_val
set d.t_u_sale_activity = 
case
when d.t_u_sale_activity is null then v.value_name
else concat(d.t_u_sale_activity, ',', v.value_name) end
where t.t_u_sale_activity_3 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_sale_activity_4' and t.t_u_sale_activity_4 = v.match_val
set d.t_u_sale_activity = 
case
when d.t_u_sale_activity is null then v.value_name
else concat(d.t_u_sale_activity, ',', v.value_name) end
where t.t_u_sale_activity_4 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_sale_activity_5' and t.t_u_sale_activity_5 = v.match_val
set d.t_u_sale_activity = 
case
when d.t_u_sale_activity is null then v.value_name
else concat(d.t_u_sale_activity, ',', v.value_name) end
where t.t_u_sale_activity_5 = 1;

-- 满减促销活动偏好
alter table u_dld_12 add column t_u_full_reduction varchar(200) default null comment '满减促销活动偏好';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_full_reduction_0' and t.t_u_full_reduction_0 = v.match_val
set d.t_u_full_reduction = 
case
when d.t_u_full_reduction is null then v.value_name
else concat(d.t_u_full_reduction, ',', v.value_name) end
where t.t_u_full_reduction_0 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_full_reduction_1' and t.t_u_full_reduction_1 = v.match_val
set d.t_u_full_reduction = 
case
when d.t_u_full_reduction is null then v.value_name
else concat(d.t_u_full_reduction, ',', v.value_name) end
where t.t_u_full_reduction_1 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_full_reduction_2' and t.t_u_full_reduction_2 = v.match_val
set d.t_u_full_reduction = 
case
when d.t_u_full_reduction is null then v.value_name
else concat(d.t_u_full_reduction, ',', v.value_name) end
where t.t_u_full_reduction_2 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_full_reduction_3' and t.t_u_full_reduction_3 = v.match_val
set d.t_u_full_reduction = 
case
when d.t_u_full_reduction is null then v.value_name
else concat(d.t_u_full_reduction, ',', v.value_name) end
where t.t_u_full_reduction_3 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_full_reduction_4' and t.t_u_full_reduction_4 = v.match_val
set d.t_u_full_reduction = 
case
when d.t_u_full_reduction is null then v.value_name
else concat(d.t_u_full_reduction, ',', v.value_name) end
where t.t_u_full_reduction_4 = 1;

-- 预售付定金活动偏好
alter table u_dld_12 add column t_u_advance_payment varchar(200) default null comment '预售付定金活动偏好';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_advance_payment_0' and t.t_u_advance_payment_0 = v.match_val
set d.t_u_advance_payment = 
case
when d.t_u_advance_payment is null then v.value_name
else concat(d.t_u_advance_payment, ',', v.value_name) end
where t.t_u_advance_payment_0 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_advance_payment_1' and t.t_u_advance_payment_1 = v.match_val
set d.t_u_advance_payment = 
case
when d.t_u_advance_payment is null then v.value_name
else concat(d.t_u_advance_payment, ',', v.value_name) end
where t.t_u_advance_payment_1 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_advance_payment_2' and t.t_u_advance_payment_2 = v.match_val
set d.t_u_advance_payment = 
case
when d.t_u_advance_payment is null then v.value_name
else concat(d.t_u_advance_payment, ',', v.value_name) end
where t.t_u_advance_payment_2 = 1;

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_advance_payment_3' and t.t_u_advance_payment_3 = v.match_val
set d.t_u_advance_payment = 
case
when d.t_u_advance_payment is null then v.value_name
else concat(d.t_u_advance_payment, ',', v.value_name) end
where t.t_u_advance_payment_3 = 1;

-- 是否参与京东618品质狂欢节
alter table u_dld_12 add column t_u_jingdong618_carnival varchar(200) default null comment '是否参与京东618品质狂欢节';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_jingdong618_carnival' and t.t_u_jingdong618_carnival = v.match_val
set d.t_u_jingdong618_carnival = v.value_name;
-- 是否参与天猫618理想生活狂欢节
alter table u_dld_12 add column t_u_tianmao618_carnival varchar(200) default null comment '是否参与天猫618理想生活狂欢节';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tianmao618_carnival' and t.t_u_tianmao618_carnival = v.match_val
set d.t_u_tianmao618_carnival = v.value_name;
-- 是否参与天猫双十一购物狂欢节
alter table u_dld_12 add column t_u_tianmao1111_carnival varchar(200) default null comment '是否参与天猫双十一购物狂欢节';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tianmao1111_carnival' and t.t_u_tianmao1111_carnival = v.match_val
set d.t_u_tianmao1111_carnival = v.value_name;
-- 是否参与天猫双十二购物狂欢节
alter table u_dld_12 add column t_u_tianmao1212_carnival varchar(200) default null comment '是否参与天猫双十二购物狂欢节';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tianmao1212_carnival' and t.t_u_tianmao1212_carnival = v.match_val
set d.t_u_tianmao1212_carnival = v.value_name;
-- 是否参与阿里年货节
alter table u_dld_12 add column t_u_ali_shopping varchar(200) default null comment '是否参与阿里年货节';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ali_shopping' and t.t_u_ali_shopping = v.match_val
set d.t_u_ali_shopping = v.value_name;
-- 50片学生儿童钙片
alter table u_dld_12 add column t_u_Children_calcium_50 varchar(200) default null comment '50片学生儿童钙片';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_Children_calcium_50' and t.t_u_Children_calcium_50 = v.match_val
set d.t_u_Children_calcium_50 = v.value_name;
-- 80片学生儿童钙片
alter table u_dld_12 add column t_u_Children_calcium_80 varchar(200) default null comment '80片学生儿童钙片';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_Children_calcium_80' and t.t_u_Children_calcium_80 = v.match_val
set d.t_u_Children_calcium_80 = v.value_name;
-- 198片维生素D成人钙片
alter table u_dld_12 add column t_u_Adult_calcium_198 varchar(200) default null comment '198片维生素D成人钙片';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_Adult_calcium_198' and t.t_u_Adult_calcium_198 = v.match_val
set d.t_u_Adult_calcium_198 = v.value_name;
-- 300片成人中老年钙片
alter table u_dld_12 add column t_u_elderly_calcium_300 varchar(200) default null comment '300片成人中老年钙片';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_elderly_calcium_300' and t.t_u_elderly_calcium_300 = v.match_val
set d.t_u_elderly_calcium_300 = v.value_name;
-- 新关注用户营销提醒
alter table u_dld_12 add column t_u_attention_reminder varchar(200) default null comment '新关注用户营销提醒';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_attention_reminder' and t.t_u_attention_reminder = v.match_val
set d.t_u_attention_reminder = v.value_name;
-- 加购物车用户营销提醒
alter table u_dld_12 add column t_u_Cart_reminder varchar(200) default null comment '加购物车用户营销提醒';

update u_dld_12 d left join u_tag_12 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_Cart_reminder' and t.t_u_Cart_reminder = v.match_val
set d.t_u_Cart_reminder = v.value_name;
