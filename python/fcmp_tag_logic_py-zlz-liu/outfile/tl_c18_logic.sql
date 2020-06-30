-- ----------------------------------
-- 客户18标签逻辑 2019-07-16 23:50:35
-- ----------------------------------
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

-- 生成tag表，含必显字段
drop table if exists u_tag_18;
create table u_tag_18 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户标签表'
select 
    phone, member_name
from 
    member_info;
    
ALTER TABLE `u_tag_18`
ADD COLUMN `id`  int(11) NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `u_tag_18`
ADD INDEX `index_a` (phone) ;

-- 生成dld表
drop table if exists u_dld_18;
create table u_dld_18 like  u_tag_18;
insert into u_dld_18 select * from u_tag_18;

ALTER TABLE `u_dld_18`
COMMENT='用户下载表';

-- 生成mid表
drop table if exists u_mid_18;
create table u_mid_18 like  u_tag_18;
insert into u_mid_18 select * from u_tag_18;

ALTER TABLE `u_mid_18`
COMMENT='用户中间值表';

-- ----------------------------------
--            标签逻辑-标签表
-- ----------------------------------
-- -----------一级标签 基本信息-----------
-- b_1201_tag_type1_case_where
-- 地址
alter table u_tag_18 add column t_u_address int(5) default 0 comment '地址';

update u_tag_18 
left join member_info 
on u_tag_18.phone = member_info.phone
set u_tag_18.t_u_address = 
case
when member_info.exp_addr like '%上海%' then 1
when member_info.exp_addr like '%云南%' then 2
when member_info.exp_addr like '%内蒙%' then 3
when member_info.exp_addr like '%北京%' then 4
when member_info.exp_addr like '%吉林%' then 5
when member_info.exp_addr like '%四川%' then 6
when member_info.exp_addr like '%天津%' then 7
when member_info.exp_addr like '%宁夏%' then 8
when member_info.exp_addr like '%安徽%' then 9
when member_info.exp_addr like '%山东%' then 10
when member_info.exp_addr like '%山西%' then 11
when member_info.exp_addr like '%广东%' then 12
when member_info.exp_addr like '%广西%' then 13
when member_info.exp_addr like '%新疆%' then 14
when member_info.exp_addr like '%江苏%' then 15
when member_info.exp_addr like '%江西%' then 16
when member_info.exp_addr like '%河北%' then 17
when member_info.exp_addr like '%河南%' then 18
when member_info.exp_addr like '%浙江%' then 19
when member_info.exp_addr like '%海南%' then 20
when member_info.exp_addr like '%湖北%' then 21
when member_info.exp_addr like '%湖南%' then 22
when member_info.exp_addr like '%甘肃%' then 23
when member_info.exp_addr like '%福建%' then 24
when member_info.exp_addr like '%西藏%' then 25
when member_info.exp_addr like '%贵州%' then 26
when member_info.exp_addr like '%辽宁%' then 27
when member_info.exp_addr like '%重庆%' then 28
when member_info.exp_addr like '%陕西%' then 29
when member_info.exp_addr like '%青海%' then 30
when member_info.exp_addr like '%黑龙江%' then 31
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：累计返点积分
alter table u_mid_18 add column point_back int(11) default 0 comment '过程值：累计返点积分';

update u_mid_18 x inner join (
select u_mid_18.id, sum(order_list.point_back) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where true
group by u_mid_18.id
) y on x.id = y.id 
set point_back = y.c;

-- b_1101_tag_type1_case_between
-- 累计返点积分
alter table u_tag_18 add column t_u_point_back int(5) default 0 comment '累计返点积分';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_point_back = 
case
when u_mid_18.point_back >= 1 and u_mid_18.point_back <= 50 then 1
when u_mid_18.point_back >= 51 and u_mid_18.point_back <= 100 then 2
when u_mid_18.point_back >= 101 and u_mid_18.point_back <= 200 then 3
when u_mid_18.point_back >= 201 and u_mid_18.point_back <= 500 then 4
when u_mid_18.point_back >= 501 and u_mid_18.point_back <= 1000 then 5
when u_mid_18.point_back >= 1001 then 6
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：已使用积分
alter table u_mid_18 add column point_pay int(11) default 0 comment '过程值：已使用积分';

update u_mid_18 x inner join (
select u_mid_18.id, sum(order_list.point_pay) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where true
group by u_mid_18.id
) y on x.id = y.id 
set point_pay = y.c;

-- b_1101_tag_type1_case_between
-- 已使用积分
alter table u_tag_18 add column t_u_point_pay int(5) default 0 comment '已使用积分';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_point_pay = 
case
when u_mid_18.point_pay >= 1 and u_mid_18.point_pay <= 50 then 1
when u_mid_18.point_pay >= 51 and u_mid_18.point_pay <= 100 then 2
when u_mid_18.point_pay >= 101 and u_mid_18.point_pay <= 200 then 3
when u_mid_18.point_pay >= 201 and u_mid_18.point_pay <= 500 then 4
when u_mid_18.point_pay >= 501 and u_mid_18.point_pay <= 1000 then 5
when u_mid_18.point_pay >= 1001 then 6
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：最后购买时间
alter table u_mid_18 add column last_pay_time datetime default null comment '过程值：最后购买时间';

update u_mid_18 x inner join (
select u_mid_18.id, max(order_list.pay_time) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where true
group by u_mid_18.id
) y on x.id = y.id 
set last_pay_time = y.c;

-- b_1201_tag_type1_case_where
-- 客户属性
alter table u_tag_18 add column t_u_customer_attr int(5) default 2 comment '客户属性';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_customer_attr = 
case
when TIMESTAMPDIFF(DAY, u_mid_18.last_pay_time, CURDATE()) <= 30 then 1
when TIMESTAMPDIFF(DAY, u_mid_18.last_pay_time, CURDATE()) > 180 then 0
else 2 end;

-- b_2001_tag_type1_where
-- 来源渠道
alter table u_tag_18 add column t_u_source_type int(5) default 0 comment '来源渠道';

update u_tag_18 
set u_tag_18.t_u_source_type = 1
where true;

-- b_3001_mid_type2_basic
-- 过程值：6个月以内下单次数
alter table u_mid_18 add column order_times_after6 int(5) default 0 comment '过程值：6个月以内下单次数';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.pay_time >= date_sub(date(now()),interval 6 month)
group by u_mid_18.id
) y on x.id = y.id 
set order_times_after6 = y.c;

-- b_1101_tag_type1_case_between
-- 近半年购买次数
alter table u_tag_18 add column t_u_halfyear_orders int(5) default 0 comment '近半年购买次数';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_halfyear_orders = 
case
when u_mid_18.order_times_after6 <= 0 then 1
when u_mid_18.order_times_after6 >= 1 and u_mid_18.order_times_after6 <= 3 then 2
when u_mid_18.order_times_after6 >= 4 and u_mid_18.order_times_after6 <= 6 then 3
when u_mid_18.order_times_after6 >= 7 and u_mid_18.order_times_after6 <= 9 then 4
when u_mid_18.order_times_after6 >= 10 and u_mid_18.order_times_after6 <= 12 then 5
when u_mid_18.order_times_after6 >= 13 then 6
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：12个月以内下单次数
alter table u_mid_18 add column order_times_after12 int(5) default 0 comment '过程值：12个月以内下单次数';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.pay_time >= date_sub(date(now()),interval 12 month)
group by u_mid_18.id
) y on x.id = y.id 
set order_times_after12 = y.c;

-- b_1101_tag_type1_case_between
-- 近一年购买次数
alter table u_tag_18 add column t_u_year_orders int(5) default 0 comment '近一年购买次数';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_year_orders = 
case
when u_mid_18.order_times_after12 <= 0 then 1
when u_mid_18.order_times_after12 >= 1 and u_mid_18.order_times_after12 <= 3 then 2
when u_mid_18.order_times_after12 >= 4 and u_mid_18.order_times_after12 <= 6 then 3
when u_mid_18.order_times_after12 >= 7 and u_mid_18.order_times_after12 <= 9 then 4
when u_mid_18.order_times_after12 >= 10 and u_mid_18.order_times_after12 <= 12 then 5
when u_mid_18.order_times_after12 >= 13 then 6
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：近半年消费金额总和
alter table u_mid_18 add column halfyear_spend decimal(11,2) default 0 comment '过程值：近半年消费金额总和';

update u_mid_18 x inner join (
select u_mid_18.id, sum(order_list.total_amount) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.pay_time >= date_sub(date(now()),interval 6 month)
group by u_mid_18.id
) y on x.id = y.id 
set halfyear_spend = y.c;

-- b_1101_tag_type1_case_between
-- 近半年消费金额总和
alter table u_tag_18 add column t_u_halfyear_spend int(5) default 0 comment '近半年消费金额总和';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_halfyear_spend = 
case
when u_mid_18.halfyear_spend >= 1 and u_mid_18.halfyear_spend <= 500 then 1
when u_mid_18.halfyear_spend >= 501 and u_mid_18.halfyear_spend <= 1000 then 2
when u_mid_18.halfyear_spend >= 1001 and u_mid_18.halfyear_spend <= 2000 then 3
when u_mid_18.halfyear_spend >= 2001 and u_mid_18.halfyear_spend <= 5000 then 4
when u_mid_18.halfyear_spend >= 5001 and u_mid_18.halfyear_spend <= 10000 then 5
when u_mid_18.halfyear_spend >= 10001 then 6
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：近一年消费金额总和
alter table u_mid_18 add column year_spend decimal(11,2) default 0 comment '过程值：近一年消费金额总和';

update u_mid_18 x inner join (
select u_mid_18.id, sum(order_list.total_amount) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.pay_time >= date_sub(date(now()),interval 12 month)
group by u_mid_18.id
) y on x.id = y.id 
set year_spend = y.c;

-- b_1101_tag_type1_case_between
-- 近一年消费金额总和
alter table u_tag_18 add column t_u_year_spend int(5) default 0 comment '近一年消费金额总和';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_year_spend = 
case
when u_mid_18.year_spend >= 1 and u_mid_18.year_spend <= 1000 then 1
when u_mid_18.year_spend >= 1001 and u_mid_18.year_spend <= 2000 then 2
when u_mid_18.year_spend >= 2001 and u_mid_18.year_spend <= 3000 then 3
when u_mid_18.year_spend >= 3001 and u_mid_18.year_spend <= 6000 then 4
when u_mid_18.year_spend >= 6001 and u_mid_18.year_spend <= 10000 then 5
when u_mid_18.year_spend >= 10001 then 6
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：总下单次数
alter table u_mid_18 add column order_times_total int(5) default 0 comment '过程值：总下单次数';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where true
group by u_mid_18.id
) y on x.id = y.id 
set order_times_total = y.c;

-- b_3001_mid_type2_basic
-- 过程值：消费金额总和
alter table u_mid_18 add column total_spend decimal(11,2) default 0 comment '过程值：消费金额总和';

update u_mid_18 x inner join (
select u_mid_18.id, sum(order_list.total_amount) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where true
group by u_mid_18.id
) y on x.id = y.id 
set total_spend = y.c;

-- b_2001_tag_type1_where
-- 是否高价值客户
alter table u_tag_18 add column t_u_value_type int(5) default 0 comment '是否高价值客户';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_value_type = 1
where order_times_total > 2 and total_spend > 5000;

-- b_2001_tag_type1_where
-- 曾经购买过茶具种类-陶瓷杯
alter table u_tag_18 add column t_u_tea_set_1 int(5) default 0 comment '曾经购买过茶具种类-陶瓷杯';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_set_1 = 1
where order_list.product_title like '%陶瓷杯%';

-- b_2001_tag_type1_where
-- 曾经购买过茶具种类-陶罐
alter table u_tag_18 add column t_u_tea_set_2 int(5) default 0 comment '曾经购买过茶具种类-陶罐';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_set_2 = 1
where order_list.product_title like '%陶罐%';

-- b_2001_tag_type1_where
-- 曾经购买过茶具种类-保温瓶
alter table u_tag_18 add column t_u_tea_set_3 int(5) default 0 comment '曾经购买过茶具种类-保温瓶';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_set_3 = 1
where order_list.product_title like '%保温瓶%';

-- b_2001_tag_type1_where
-- 曾经购买过茶具种类-茶刀
alter table u_tag_18 add column t_u_tea_set_4 int(5) default 0 comment '曾经购买过茶具种类-茶刀';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_set_4 = 1
where order_list.product_title like '%茶刀%';

-- b_2001_tag_type1_where
-- 曾经购买过茶具种类-茶针
alter table u_tag_18 add column t_u_tea_set_5 int(5) default 0 comment '曾经购买过茶具种类-茶针';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_set_5 = 1
where order_list.product_title like '%茶针%';

-- b_2001_tag_type1_where
-- 曾经购买过茶具种类-缺失
alter table u_tag_18 add column t_u_tea_set_0 int(5) default 0 comment '曾经购买过茶具种类-缺失';

update u_tag_18 
set u_tag_18.t_u_tea_set_0 = 1
where t_u_tea_set_1 = 0 and t_u_tea_set_2 = 0 and t_u_tea_set_3 = 0 and t_u_tea_set_4 = 0 and t_u_tea_set_5 = 0;

-- b_2001_tag_type1_where
-- 曾经购买过规格种类-饼
alter table u_tag_18 add column t_u_tea_spec_1 int(5) default 0 comment '曾经购买过规格种类-饼';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_spec_1 = 1
where order_list.product_title like '%饼%';

-- b_2001_tag_type1_where
-- 曾经购买过规格种类-砖
alter table u_tag_18 add column t_u_tea_spec_2 int(5) default 0 comment '曾经购买过规格种类-砖';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_spec_2 = 1
where order_list.product_title like '%砖%';

-- b_2001_tag_type1_where
-- 曾经购买过规格种类-罐
alter table u_tag_18 add column t_u_tea_spec_3 int(5) default 0 comment '曾经购买过规格种类-罐';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_spec_3 = 1
where order_list.product_title like '%罐%';

-- b_2001_tag_type1_where
-- 曾经购买过规格种类-泡茶
alter table u_tag_18 add column t_u_tea_spec_4 int(5) default 0 comment '曾经购买过规格种类-泡茶';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_spec_4 = 1
where order_list.product_title like '%泡茶%';

-- b_2001_tag_type1_where
-- 曾经购买过规格种类-缺失
alter table u_tag_18 add column t_u_tea_spec_0 int(5) default 0 comment '曾经购买过规格种类-缺失';

update u_tag_18 
set u_tag_18.t_u_tea_spec_0 = 1
where t_u_tea_spec_1 = 0 and t_u_tea_spec_2 = 0 and t_u_tea_spec_3 = 0 and t_u_tea_spec_4 = 0;

-- b_2001_tag_type1_where
-- 曾经购买过茶叶种类-青柑
alter table u_tag_18 add column t_u_tea_type_1 int(5) default 0 comment '曾经购买过茶叶种类-青柑';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_type_1 = 1
where order_list.product_title like '%青柑%';

-- b_2001_tag_type1_where
-- 曾经购买过茶叶种类-铁观音
alter table u_tag_18 add column t_u_tea_type_2 int(5) default 0 comment '曾经购买过茶叶种类-铁观音';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_type_2 = 1
where order_list.product_title like '%铁观音%';

-- b_2001_tag_type1_where
-- 曾经购买过茶叶种类-白柑
alter table u_tag_18 add column t_u_tea_type_3 int(5) default 0 comment '曾经购买过茶叶种类-白柑';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_type_3 = 1
where order_list.product_title like '%白柑%';

-- b_2001_tag_type1_where
-- 曾经购买过茶叶种类-桂花香
alter table u_tag_18 add column t_u_tea_type_4 int(5) default 0 comment '曾经购买过茶叶种类-桂花香';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_type_4 = 1
where order_list.product_title like '%桂花香%';

-- b_2001_tag_type1_where
-- 曾经购买过茶叶种类-普洱
alter table u_tag_18 add column t_u_tea_type_5 int(5) default 0 comment '曾经购买过茶叶种类-普洱';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_type_5 = 1
where order_list.product_title like '%普洱%';

-- b_2001_tag_type1_where
-- 曾经购买过茶叶种类-大红袍
alter table u_tag_18 add column t_u_tea_type_6 int(5) default 0 comment '曾经购买过茶叶种类-大红袍';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_type_6 = 1
where order_list.product_title like '%大红袍%';

-- b_2001_tag_type1_where
-- 曾经购买过茶叶种类-白牡丹
alter table u_tag_18 add column t_u_tea_type_7 int(5) default 0 comment '曾经购买过茶叶种类-白牡丹';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_type_7 = 1
where order_list.product_title like '%白牡丹%';

-- b_2001_tag_type1_where
-- 曾经购买过茶叶种类-青茶
alter table u_tag_18 add column t_u_tea_type_8 int(5) default 0 comment '曾经购买过茶叶种类-青茶';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_type_8 = 1
where order_list.product_title like '%青茶%';

-- b_2001_tag_type1_where
-- 曾经购买过茶叶种类-茶香粽
alter table u_tag_18 add column t_u_tea_type_9 int(5) default 0 comment '曾经购买过茶叶种类-茶香粽';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_tea_type_9 = 1
where order_list.product_title like '%茶香粽%';

-- b_2001_tag_type1_where
-- 曾经购买过茶叶种类-缺失
alter table u_tag_18 add column t_u_tea_type_0 int(5) default 0 comment '曾经购买过茶叶种类-缺失';

update u_tag_18 
set u_tag_18.t_u_tea_type_0 = 1
where t_u_tea_type_1 = 0 and t_u_tea_type_2 = 0 and t_u_tea_type_3 = 0 and t_u_tea_type_4 = 0 and t_u_tea_type_5 = 0 and t_u_tea_type_6 = 0 and t_u_tea_type_7 = 0 and t_u_tea_type_8 = 0 and t_u_tea_type_9 = 0;

-- b_2001_tag_type1_where
-- 购买目的-送礼
alter table u_tag_18 add column t_u_buy_purpose_1 int(5) default 0 comment '购买目的-送礼';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_buy_purpose_1 = 1
where order_list.product_title like '%礼%' or order_list.product_title like '%定制%';

-- b_2001_tag_type1_where
-- 购买目的-自饮
alter table u_tag_18 add column t_u_buy_purpose_2 int(5) default 0 comment '购买目的-自饮';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_buy_purpose_2 = 1
where order_list.product_title not like '%礼%' and order_list.product_title not like '%定制%';

-- b_2001_tag_type1_where
-- 购买目的-缺失
alter table u_tag_18 add column t_u_buy_purpose_0 int(5) default 0 comment '购买目的-缺失';

update u_tag_18 
set u_tag_18.t_u_buy_purpose_0 = 1
where t_u_buy_purpose_1 = 0 and t_u_buy_purpose_2 = 0;

-- b_3001_mid_type2_basic
-- 过程值：茶具偏好次数-陶瓷杯
alter table u_mid_18 add column tea_set_pref_1 int(11) default 0 comment '过程值：茶具偏好次数-陶瓷杯';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%陶瓷杯%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_set_pref_1 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：茶具偏好次数-陶罐
alter table u_mid_18 add column tea_set_pref_2 int(11) default 0 comment '过程值：茶具偏好次数-陶罐';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%陶罐%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_set_pref_2 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：茶具偏好次数-保温瓶
alter table u_mid_18 add column tea_set_pref_3 int(11) default 0 comment '过程值：茶具偏好次数-保温瓶';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%保温瓶%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_set_pref_3 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：茶具偏好次数-茶刀
alter table u_mid_18 add column tea_set_pref_4 int(11) default 0 comment '过程值：茶具偏好次数-茶刀';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%茶刀%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_set_pref_4 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：茶具偏好次数-茶针
alter table u_mid_18 add column tea_set_pref_5 int(11) default 0 comment '过程值：茶具偏好次数-茶针';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%茶针%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_set_pref_5 = y.c;

-- b_2002_mid_type1_where
-- 过程值：次数最大值
alter table u_mid_18 add column tea_set_pref_max int(11) default 0 comment '过程值：次数最大值';

update u_mid_18 
set u_mid_18.tea_set_pref_max = greatest(tea_set_pref_1, tea_set_pref_2, tea_set_pref_3, tea_set_pref_4, tea_set_pref_5)
where true;

-- b_2001_tag_type1_where
-- 茶具偏好-陶瓷杯
alter table u_tag_18 add column t_u_tea_set_pref_1 int(5) default 0 comment '茶具偏好-陶瓷杯';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_set_pref_1 = 1
where u_mid_18.tea_set_pref_1 = u_mid_18.tea_set_pref_max and u_mid_18.tea_set_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶具偏好-陶罐
alter table u_tag_18 add column t_u_tea_set_pref_2 int(5) default 0 comment '茶具偏好-陶罐';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_set_pref_2 = 1
where u_mid_18.tea_set_pref_2 = u_mid_18.tea_set_pref_max and u_mid_18.tea_set_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶具偏好-保温瓶
alter table u_tag_18 add column t_u_tea_set_pref_3 int(5) default 0 comment '茶具偏好-保温瓶';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_set_pref_3 = 1
where u_mid_18.tea_set_pref_3 = u_mid_18.tea_set_pref_max and u_mid_18.tea_set_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶具偏好-茶刀
alter table u_tag_18 add column t_u_tea_set_pref_4 int(5) default 0 comment '茶具偏好-茶刀';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_set_pref_4 = 1
where u_mid_18.tea_set_pref_4 = u_mid_18.tea_set_pref_max and u_mid_18.tea_set_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶具偏好-茶针
alter table u_tag_18 add column t_u_tea_set_pref_5 int(5) default 0 comment '茶具偏好-茶针';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_set_pref_5 = 1
where u_mid_18.tea_set_pref_5 = u_mid_18.tea_set_pref_max and u_mid_18.tea_set_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶具偏好-缺失
alter table u_tag_18 add column t_u_tea_set_pref_0 int(5) default 0 comment '茶具偏好-缺失';

update u_tag_18 
set u_tag_18.t_u_tea_set_pref_0 = 1
where t_u_tea_set_pref_1 = 0 and t_u_tea_set_pref_2 = 0 and t_u_tea_set_pref_3 = 0 and t_u_tea_set_pref_4 = 0 and t_u_tea_set_pref_5 = 0;

-- b_3001_mid_type2_basic
-- 过程值：规格偏好次数-饼
alter table u_mid_18 add column tea_spec_pref_1 int(11) default 0 comment '过程值：规格偏好次数-饼';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%饼%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_spec_pref_1 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：规格偏好次数-砖
alter table u_mid_18 add column tea_spec_pref_2 int(11) default 0 comment '过程值：规格偏好次数-砖';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%砖%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_spec_pref_2 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：规格偏好次数-罐
alter table u_mid_18 add column tea_spec_pref_3 int(11) default 0 comment '过程值：规格偏好次数-罐';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%罐%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_spec_pref_3 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：规格偏好次数-泡茶
alter table u_mid_18 add column tea_spec_pref_4 int(11) default 0 comment '过程值：规格偏好次数-泡茶';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%泡茶%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_spec_pref_4 = y.c;

-- b_2002_mid_type1_where
-- 过程值：次数最大值
alter table u_mid_18 add column tea_spec_pref_max int(11) default 0 comment '过程值：次数最大值';

update u_mid_18 
set u_mid_18.tea_spec_pref_max = greatest(tea_spec_pref_1, tea_spec_pref_2, tea_spec_pref_3, tea_spec_pref_4)
where true;

-- b_2001_tag_type1_where
-- 规格偏好-饼
alter table u_tag_18 add column t_u_tea_spec_pref_1 int(5) default 0 comment '规格偏好-饼';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_spec_pref_1 = 1
where u_mid_18.tea_spec_pref_1 = u_mid_18.tea_spec_pref_max and u_mid_18.tea_spec_pref_max > 0;

-- b_2001_tag_type1_where
-- 规格偏好-砖
alter table u_tag_18 add column t_u_tea_spec_pref_2 int(5) default 0 comment '规格偏好-砖';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_spec_pref_2 = 1
where u_mid_18.tea_spec_pref_2 = u_mid_18.tea_spec_pref_max and u_mid_18.tea_spec_pref_max > 0;

-- b_2001_tag_type1_where
-- 规格偏好-罐
alter table u_tag_18 add column t_u_tea_spec_pref_3 int(5) default 0 comment '规格偏好-罐';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_spec_pref_3 = 1
where u_mid_18.tea_spec_pref_3 = u_mid_18.tea_spec_pref_max and u_mid_18.tea_spec_pref_max > 0;

-- b_2001_tag_type1_where
-- 规格偏好-泡茶
alter table u_tag_18 add column t_u_tea_spec_pref_4 int(5) default 0 comment '规格偏好-泡茶';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_spec_pref_4 = 1
where u_mid_18.tea_spec_pref_4 = u_mid_18.tea_spec_pref_max and u_mid_18.tea_spec_pref_max > 0;

-- b_2001_tag_type1_where
-- 规格偏好-缺失
alter table u_tag_18 add column t_u_tea_spec_pref_0 int(5) default 0 comment '规格偏好-缺失';

update u_tag_18 
set u_tag_18.t_u_tea_spec_pref_0 = 1
where t_u_tea_spec_pref_1 = 0 and t_u_tea_spec_pref_2 = 0 and t_u_tea_spec_pref_3 = 0 and t_u_tea_spec_pref_4 = 0;

-- b_3001_mid_type2_basic
-- 过程值：茶叶偏好次数-青柑
alter table u_mid_18 add column tea_type_pref_1 int(11) default 0 comment '过程值：茶叶偏好次数-青柑';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%青柑%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_type_pref_1 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：茶叶偏好次数-铁观音
alter table u_mid_18 add column tea_type_pref_2 int(11) default 0 comment '过程值：茶叶偏好次数-铁观音';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%铁观音%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_type_pref_2 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：茶叶偏好次数-白柑
alter table u_mid_18 add column tea_type_pref_3 int(11) default 0 comment '过程值：茶叶偏好次数-白柑';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%白柑%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_type_pref_3 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：茶叶偏好次数-桂花香
alter table u_mid_18 add column tea_type_pref_4 int(11) default 0 comment '过程值：茶叶偏好次数-桂花香';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%桂花香%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_type_pref_4 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：茶叶偏好次数-普洱
alter table u_mid_18 add column tea_type_pref_5 int(11) default 0 comment '过程值：茶叶偏好次数-普洱';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%普洱%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_type_pref_5 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：茶叶偏好次数-大红袍
alter table u_mid_18 add column tea_type_pref_6 int(11) default 0 comment '过程值：茶叶偏好次数-大红袍';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%大红袍%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_type_pref_6 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：茶叶偏好次数-白牡丹
alter table u_mid_18 add column tea_type_pref_7 int(11) default 0 comment '过程值：茶叶偏好次数-白牡丹';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%白牡丹%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_type_pref_7 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：茶叶偏好次数-青茶
alter table u_mid_18 add column tea_type_pref_8 int(11) default 0 comment '过程值：茶叶偏好次数-青茶';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%青茶%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_type_pref_8 = y.c;

-- b_3001_mid_type2_basic
-- 过程值：茶叶偏好次数-茶香粽
alter table u_mid_18 add column tea_type_pref_9 int(11) default 0 comment '过程值：茶叶偏好次数-茶香粽';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%茶香粽%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_type_pref_9 = y.c;

-- b_2002_mid_type1_where
-- 过程值：次数最大值
alter table u_mid_18 add column tea_type_pref_max int(11) default 0 comment '过程值：次数最大值';

update u_mid_18 
set u_mid_18.tea_type_pref_max = greatest(tea_type_pref_1, tea_type_pref_2, tea_type_pref_3, tea_type_pref_4, tea_type_pref_5, tea_type_pref_6, tea_type_pref_7, tea_type_pref_8, tea_type_pref_9)
where true;

-- b_2001_tag_type1_where
-- 茶叶偏好-青柑
alter table u_tag_18 add column t_u_tea_type_pref_1 int(5) default 0 comment '茶叶偏好-青柑';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_type_pref_1 = 1
where u_mid_18.tea_type_pref_1 = u_mid_18.tea_type_pref_max and u_mid_18.tea_type_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶叶偏好-铁观音
alter table u_tag_18 add column t_u_tea_type_pref_2 int(5) default 0 comment '茶叶偏好-铁观音';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_type_pref_2 = 1
where u_mid_18.tea_type_pref_2 = u_mid_18.tea_type_pref_max and u_mid_18.tea_type_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶叶偏好-白柑
alter table u_tag_18 add column t_u_tea_type_pref_3 int(5) default 0 comment '茶叶偏好-白柑';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_type_pref_3 = 1
where u_mid_18.tea_type_pref_3 = u_mid_18.tea_type_pref_max and u_mid_18.tea_type_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶叶偏好-桂花香
alter table u_tag_18 add column t_u_tea_type_pref_4 int(5) default 0 comment '茶叶偏好-桂花香';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_type_pref_4 = 1
where u_mid_18.tea_type_pref_4 = u_mid_18.tea_type_pref_max and u_mid_18.tea_type_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶叶偏好-普洱
alter table u_tag_18 add column t_u_tea_type_pref_5 int(5) default 0 comment '茶叶偏好-普洱';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_type_pref_5 = 1
where u_mid_18.tea_type_pref_5 = u_mid_18.tea_type_pref_max and u_mid_18.tea_type_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶叶偏好-大红袍
alter table u_tag_18 add column t_u_tea_type_pref_6 int(5) default 0 comment '茶叶偏好-大红袍';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_type_pref_6 = 1
where u_mid_18.tea_type_pref_6 = u_mid_18.tea_type_pref_max and u_mid_18.tea_type_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶叶偏好-白牡丹
alter table u_tag_18 add column t_u_tea_type_pref_7 int(5) default 0 comment '茶叶偏好-白牡丹';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_type_pref_7 = 1
where u_mid_18.tea_type_pref_7 = u_mid_18.tea_type_pref_max and u_mid_18.tea_type_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶叶偏好-青茶
alter table u_tag_18 add column t_u_tea_type_pref_8 int(5) default 0 comment '茶叶偏好-青茶';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_type_pref_8 = 1
where u_mid_18.tea_type_pref_8 = u_mid_18.tea_type_pref_max and u_mid_18.tea_type_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶叶偏好-茶香粽
alter table u_tag_18 add column t_u_tea_type_pref_9 int(5) default 0 comment '茶叶偏好-茶香粽';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_type_pref_9 = 1
where u_mid_18.tea_type_pref_9 = u_mid_18.tea_type_pref_max and u_mid_18.tea_type_pref_max > 0;

-- b_2001_tag_type1_where
-- 茶叶偏好-缺失
alter table u_tag_18 add column t_u_tea_type_pref_0 int(5) default 0 comment '茶叶偏好-缺失';

update u_tag_18 
set u_tag_18.t_u_tea_type_pref_0 = 1
where t_u_tea_type_pref_1 = 0 and t_u_tea_type_pref_2 = 0 and t_u_tea_type_pref_3 = 0 and t_u_tea_type_pref_4 = 0 and t_u_tea_type_pref_5 = 0 and t_u_tea_type_pref_6 = 0 and t_u_tea_type_pref_7 = 0 and t_u_tea_type_pref_8 = 0 and t_u_tea_type_pref_9 = 0;

-- b_3001_mid_type2_basic
-- 过程值：茶具购买次数
alter table u_mid_18 add column tea_set_reorder int(11) default 0 comment '过程值：茶具购买次数';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%陶瓷杯%' or order_list.product_title like '%陶罐%' or order_list.product_title like '%保温瓶%' or order_list.product_title like '%茶刀%' or order_list.product_title like '%茶针%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_set_reorder = y.c;

-- b_1101_tag_type1_case_between
-- 茶具购买次数
alter table u_tag_18 add column t_u_tea_set_reorder int(5) default 0 comment '茶具购买次数';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_set_reorder = 
case
when u_mid_18.tea_set_reorder <= 1 then 0
when u_mid_18.tea_set_reorder >= 2 and u_mid_18.tea_set_reorder <= 2 then 1
when u_mid_18.tea_set_reorder >= 3 and u_mid_18.tea_set_reorder <= 3 then 2
when u_mid_18.tea_set_reorder >= 4 and u_mid_18.tea_set_reorder <= 4 then 3
when u_mid_18.tea_set_reorder >= 5 and u_mid_18.tea_set_reorder <= 5 then 4
when u_mid_18.tea_set_reorder >= 6 and u_mid_18.tea_set_reorder <= 6 then 5
when u_mid_18.tea_set_reorder >= 7 and u_mid_18.tea_set_reorder <= 7 then 6
when u_mid_18.tea_set_reorder >= 8 and u_mid_18.tea_set_reorder <= 8 then 7
when u_mid_18.tea_set_reorder >= 9 and u_mid_18.tea_set_reorder <= 9 then 8
when u_mid_18.tea_set_reorder >= 10 and u_mid_18.tea_set_reorder <= 10 then 9
when u_mid_18.tea_set_reorder >= 11 and u_mid_18.tea_set_reorder <= 11 then 10
when u_mid_18.tea_set_reorder >= 12 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：规格复购次数
alter table u_mid_18 add column tea_spec_reorder int(11) default 0 comment '过程值：规格复购次数';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%饼%' or order_list.product_title like '%砖%' or order_list.product_title like '%罐%' or order_list.product_title like '%泡茶%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_spec_reorder = y.c;

-- b_1101_tag_type1_case_between
-- 规格复购次数
alter table u_tag_18 add column t_u_tea_spec_reorder int(5) default 0 comment '规格复购次数';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_spec_reorder = 
case
when u_mid_18.tea_spec_reorder <= 1 then 0
when u_mid_18.tea_spec_reorder >= 2 and u_mid_18.tea_spec_reorder <= 2 then 1
when u_mid_18.tea_spec_reorder >= 3 and u_mid_18.tea_spec_reorder <= 3 then 2
when u_mid_18.tea_spec_reorder >= 4 and u_mid_18.tea_spec_reorder <= 4 then 3
when u_mid_18.tea_spec_reorder >= 5 and u_mid_18.tea_spec_reorder <= 5 then 4
when u_mid_18.tea_spec_reorder >= 6 and u_mid_18.tea_spec_reorder <= 6 then 5
when u_mid_18.tea_spec_reorder >= 7 and u_mid_18.tea_spec_reorder <= 7 then 6
when u_mid_18.tea_spec_reorder >= 8 and u_mid_18.tea_spec_reorder <= 8 then 7
when u_mid_18.tea_spec_reorder >= 9 and u_mid_18.tea_spec_reorder <= 9 then 8
when u_mid_18.tea_spec_reorder >= 10 and u_mid_18.tea_spec_reorder <= 10 then 9
when u_mid_18.tea_spec_reorder >= 11 and u_mid_18.tea_spec_reorder <= 11 then 10
when u_mid_18.tea_spec_reorder >= 12 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：茶叶复购次数
alter table u_mid_18 add column tea_type_reorder int(11) default 0 comment '过程值：茶叶复购次数';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.product_title like '%青柑%' or order_list.product_title like '%铁观音%' or order_list.product_title like '%白柑%' or order_list.product_title like '%桂花香%' or order_list.product_title like '%普洱%' or order_list.product_title like '%大红袍%' or order_list.product_title like '%白牡丹%' or order_list.product_title like '%青茶%' or order_list.product_title like '%茶香粽%'
group by u_mid_18.id
) y on x.id = y.id 
set tea_type_reorder = y.c;

-- b_1101_tag_type1_case_between
-- 茶叶复购次数
alter table u_tag_18 add column t_u_tea_type_reorder int(5) default 0 comment '茶叶复购次数';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_tea_type_reorder = 
case
when u_mid_18.tea_type_reorder <= 1 then 0
when u_mid_18.tea_type_reorder >= 2 and u_mid_18.tea_type_reorder <= 2 then 1
when u_mid_18.tea_type_reorder >= 3 and u_mid_18.tea_type_reorder <= 3 then 2
when u_mid_18.tea_type_reorder >= 4 and u_mid_18.tea_type_reorder <= 4 then 3
when u_mid_18.tea_type_reorder >= 5 and u_mid_18.tea_type_reorder <= 5 then 4
when u_mid_18.tea_type_reorder >= 6 and u_mid_18.tea_type_reorder <= 6 then 5
when u_mid_18.tea_type_reorder >= 7 and u_mid_18.tea_type_reorder <= 7 then 6
when u_mid_18.tea_type_reorder >= 8 and u_mid_18.tea_type_reorder <= 8 then 7
when u_mid_18.tea_type_reorder >= 9 and u_mid_18.tea_type_reorder <= 9 then 8
when u_mid_18.tea_type_reorder >= 10 and u_mid_18.tea_type_reorder <= 10 then 9
when u_mid_18.tea_type_reorder >= 11 and u_mid_18.tea_type_reorder <= 11 then 10
when u_mid_18.tea_type_reorder >= 12 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：退换款次数
alter table u_mid_18 add column reject_times int(11) default 0 comment '过程值：退换款次数';

update u_mid_18 x inner join (
select u_mid_18.id, count(*) c from 
u_mid_18 
inner join order_list 
on u_mid_18.phone = order_list.phone
where order_list.close_reason = '退款'
group by u_mid_18.id
) y on x.id = y.id 
set reject_times = y.c;

-- b_1101_tag_type1_case_between
-- 退换款次数
alter table u_tag_18 add column t_u_reject_times int(5) default 0 comment '退换款次数';

update u_tag_18 
left join u_mid_18 
on u_tag_18.id = u_mid_18.id
set u_tag_18.t_u_reject_times = 
case
when u_mid_18.reject_times <= 0 then 0
when u_mid_18.reject_times >= 1 and u_mid_18.reject_times <= 1 then 1
when u_mid_18.reject_times >= 2 and u_mid_18.reject_times <= 2 then 2
when u_mid_18.reject_times >= 3 and u_mid_18.reject_times <= 3 then 3
when u_mid_18.reject_times >= 4 and u_mid_18.reject_times <= 4 then 4
when u_mid_18.reject_times >= 5 and u_mid_18.reject_times <= 5 then 5
when u_mid_18.reject_times >= 6 and u_mid_18.reject_times <= 10 then 6
when u_mid_18.reject_times >= 11 then 7
else 0 end;

-- b_2001_tag_type1_where
-- 是否参加618活动
alter table u_tag_18 add column t_u_promotion_618 int(5) default 0 comment '是否参加618活动';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_promotion_618 = 1
where month(order_list.pay_time) = 6 and day(order_list.pay_time) = 18;

-- b_2001_tag_type1_where
-- 是否参加双11活动
alter table u_tag_18 add column t_u_promotion_1111 int(5) default 0 comment '是否参加双11活动';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_promotion_1111 = 1
where month(order_list.pay_time) = 11 and day(order_list.pay_time) = 11;

-- b_2001_tag_type1_where
-- 是否参加双12活动
alter table u_tag_18 add column t_u_promotion_1212 int(5) default 0 comment '是否参加双12活动';

update u_tag_18 
left join order_list 
on u_tag_18.phone = order_list.phone
set u_tag_18.t_u_promotion_1212 = 1
where month(order_list.pay_time) = 12 and day(order_list.pay_time) = 12;

-- ----------------------------------
--            下载表生成
-- ----------------------------------
-- b7_dld_gen
-- 地址
alter table u_dld_18 add column t_u_address varchar(200) default null comment '地址';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_address' and t.t_u_address = v.match_val
set d.t_u_address = v.value_name;

-- 累计返点积分
alter table u_dld_18 add column t_u_point_back varchar(200) default null comment '累计返点积分';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_point_back' and t.t_u_point_back = v.match_val
set d.t_u_point_back = v.value_name;

-- 已使用积分
alter table u_dld_18 add column t_u_point_pay varchar(200) default null comment '已使用积分';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_point_pay' and t.t_u_point_pay = v.match_val
set d.t_u_point_pay = v.value_name;

-- 客户属性
alter table u_dld_18 add column t_u_customer_attr varchar(200) default null comment '客户属性';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_customer_attr' and t.t_u_customer_attr = v.match_val
set d.t_u_customer_attr = v.value_name;

-- 来源渠道
alter table u_dld_18 add column t_u_source_type varchar(200) default null comment '来源渠道';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_source_type' and t.t_u_source_type = v.match_val
set d.t_u_source_type = v.value_name;

-- 近半年购买次数
alter table u_dld_18 add column t_u_halfyear_orders varchar(200) default null comment '近半年购买次数';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_halfyear_orders' and t.t_u_halfyear_orders = v.match_val
set d.t_u_halfyear_orders = v.value_name;

-- 近一年购买次数
alter table u_dld_18 add column t_u_year_orders varchar(200) default null comment '近一年购买次数';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_year_orders' and t.t_u_year_orders = v.match_val
set d.t_u_year_orders = v.value_name;

-- 近半年消费金额总和
alter table u_dld_18 add column t_u_halfyear_spend varchar(200) default null comment '近半年消费金额总和';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_halfyear_spend' and t.t_u_halfyear_spend = v.match_val
set d.t_u_halfyear_spend = v.value_name;

-- 近一年消费金额总和
alter table u_dld_18 add column t_u_year_spend varchar(200) default null comment '近一年消费金额总和';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_year_spend' and t.t_u_year_spend = v.match_val
set d.t_u_year_spend = v.value_name;

-- 是否高价值客户
alter table u_dld_18 add column t_u_value_type varchar(200) default null comment '是否高价值客户';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_value_type' and t.t_u_value_type = v.match_val
set d.t_u_value_type = v.value_name;

-- 曾经购买过茶具种类
alter table u_dld_18 add column t_u_tea_set varchar(200) default null comment '曾经购买过茶具种类';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_0' and t.t_u_tea_set_0 = v.match_val
set d.t_u_tea_set = 
case
when d.t_u_tea_set is null then v.value_name
else concat(d.t_u_tea_set, ',', v.value_name) end
where t.t_u_tea_set_0 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_1' and t.t_u_tea_set_1 = v.match_val
set d.t_u_tea_set = 
case
when d.t_u_tea_set is null then v.value_name
else concat(d.t_u_tea_set, ',', v.value_name) end
where t.t_u_tea_set_1 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_2' and t.t_u_tea_set_2 = v.match_val
set d.t_u_tea_set = 
case
when d.t_u_tea_set is null then v.value_name
else concat(d.t_u_tea_set, ',', v.value_name) end
where t.t_u_tea_set_2 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_3' and t.t_u_tea_set_3 = v.match_val
set d.t_u_tea_set = 
case
when d.t_u_tea_set is null then v.value_name
else concat(d.t_u_tea_set, ',', v.value_name) end
where t.t_u_tea_set_3 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_4' and t.t_u_tea_set_4 = v.match_val
set d.t_u_tea_set = 
case
when d.t_u_tea_set is null then v.value_name
else concat(d.t_u_tea_set, ',', v.value_name) end
where t.t_u_tea_set_4 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_5' and t.t_u_tea_set_5 = v.match_val
set d.t_u_tea_set = 
case
when d.t_u_tea_set is null then v.value_name
else concat(d.t_u_tea_set, ',', v.value_name) end
where t.t_u_tea_set_5 = 1;

-- 曾经购买过规格种类
alter table u_dld_18 add column t_u_tea_spec varchar(200) default null comment '曾经购买过规格种类';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_spec_0' and t.t_u_tea_spec_0 = v.match_val
set d.t_u_tea_spec = 
case
when d.t_u_tea_spec is null then v.value_name
else concat(d.t_u_tea_spec, ',', v.value_name) end
where t.t_u_tea_spec_0 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_spec_1' and t.t_u_tea_spec_1 = v.match_val
set d.t_u_tea_spec = 
case
when d.t_u_tea_spec is null then v.value_name
else concat(d.t_u_tea_spec, ',', v.value_name) end
where t.t_u_tea_spec_1 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_spec_2' and t.t_u_tea_spec_2 = v.match_val
set d.t_u_tea_spec = 
case
when d.t_u_tea_spec is null then v.value_name
else concat(d.t_u_tea_spec, ',', v.value_name) end
where t.t_u_tea_spec_2 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_spec_3' and t.t_u_tea_spec_3 = v.match_val
set d.t_u_tea_spec = 
case
when d.t_u_tea_spec is null then v.value_name
else concat(d.t_u_tea_spec, ',', v.value_name) end
where t.t_u_tea_spec_3 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_spec_4' and t.t_u_tea_spec_4 = v.match_val
set d.t_u_tea_spec = 
case
when d.t_u_tea_spec is null then v.value_name
else concat(d.t_u_tea_spec, ',', v.value_name) end
where t.t_u_tea_spec_4 = 1;

-- 曾经购买过茶叶种类
alter table u_dld_18 add column t_u_tea_type varchar(200) default null comment '曾经购买过茶叶种类';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_0' and t.t_u_tea_type_0 = v.match_val
set d.t_u_tea_type = 
case
when d.t_u_tea_type is null then v.value_name
else concat(d.t_u_tea_type, ',', v.value_name) end
where t.t_u_tea_type_0 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_1' and t.t_u_tea_type_1 = v.match_val
set d.t_u_tea_type = 
case
when d.t_u_tea_type is null then v.value_name
else concat(d.t_u_tea_type, ',', v.value_name) end
where t.t_u_tea_type_1 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_2' and t.t_u_tea_type_2 = v.match_val
set d.t_u_tea_type = 
case
when d.t_u_tea_type is null then v.value_name
else concat(d.t_u_tea_type, ',', v.value_name) end
where t.t_u_tea_type_2 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_3' and t.t_u_tea_type_3 = v.match_val
set d.t_u_tea_type = 
case
when d.t_u_tea_type is null then v.value_name
else concat(d.t_u_tea_type, ',', v.value_name) end
where t.t_u_tea_type_3 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_4' and t.t_u_tea_type_4 = v.match_val
set d.t_u_tea_type = 
case
when d.t_u_tea_type is null then v.value_name
else concat(d.t_u_tea_type, ',', v.value_name) end
where t.t_u_tea_type_4 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_5' and t.t_u_tea_type_5 = v.match_val
set d.t_u_tea_type = 
case
when d.t_u_tea_type is null then v.value_name
else concat(d.t_u_tea_type, ',', v.value_name) end
where t.t_u_tea_type_5 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_6' and t.t_u_tea_type_6 = v.match_val
set d.t_u_tea_type = 
case
when d.t_u_tea_type is null then v.value_name
else concat(d.t_u_tea_type, ',', v.value_name) end
where t.t_u_tea_type_6 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_7' and t.t_u_tea_type_7 = v.match_val
set d.t_u_tea_type = 
case
when d.t_u_tea_type is null then v.value_name
else concat(d.t_u_tea_type, ',', v.value_name) end
where t.t_u_tea_type_7 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_8' and t.t_u_tea_type_8 = v.match_val
set d.t_u_tea_type = 
case
when d.t_u_tea_type is null then v.value_name
else concat(d.t_u_tea_type, ',', v.value_name) end
where t.t_u_tea_type_8 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_9' and t.t_u_tea_type_9 = v.match_val
set d.t_u_tea_type = 
case
when d.t_u_tea_type is null then v.value_name
else concat(d.t_u_tea_type, ',', v.value_name) end
where t.t_u_tea_type_9 = 1;

-- 购买目的
alter table u_dld_18 add column t_u_buy_purpose varchar(200) default null comment '购买目的';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_purpose_0' and t.t_u_buy_purpose_0 = v.match_val
set d.t_u_buy_purpose = 
case
when d.t_u_buy_purpose is null then v.value_name
else concat(d.t_u_buy_purpose, ',', v.value_name) end
where t.t_u_buy_purpose_0 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_purpose_1' and t.t_u_buy_purpose_1 = v.match_val
set d.t_u_buy_purpose = 
case
when d.t_u_buy_purpose is null then v.value_name
else concat(d.t_u_buy_purpose, ',', v.value_name) end
where t.t_u_buy_purpose_1 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_buy_purpose_2' and t.t_u_buy_purpose_2 = v.match_val
set d.t_u_buy_purpose = 
case
when d.t_u_buy_purpose is null then v.value_name
else concat(d.t_u_buy_purpose, ',', v.value_name) end
where t.t_u_buy_purpose_2 = 1;

-- 茶具偏好
alter table u_dld_18 add column t_u_tea_set_pref varchar(200) default null comment '茶具偏好';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_pref_0' and t.t_u_tea_set_pref_0 = v.match_val
set d.t_u_tea_set_pref = 
case
when d.t_u_tea_set_pref is null then v.value_name
else concat(d.t_u_tea_set_pref, ',', v.value_name) end
where t.t_u_tea_set_pref_0 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_pref_1' and t.t_u_tea_set_pref_1 = v.match_val
set d.t_u_tea_set_pref = 
case
when d.t_u_tea_set_pref is null then v.value_name
else concat(d.t_u_tea_set_pref, ',', v.value_name) end
where t.t_u_tea_set_pref_1 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_pref_2' and t.t_u_tea_set_pref_2 = v.match_val
set d.t_u_tea_set_pref = 
case
when d.t_u_tea_set_pref is null then v.value_name
else concat(d.t_u_tea_set_pref, ',', v.value_name) end
where t.t_u_tea_set_pref_2 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_pref_3' and t.t_u_tea_set_pref_3 = v.match_val
set d.t_u_tea_set_pref = 
case
when d.t_u_tea_set_pref is null then v.value_name
else concat(d.t_u_tea_set_pref, ',', v.value_name) end
where t.t_u_tea_set_pref_3 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_pref_4' and t.t_u_tea_set_pref_4 = v.match_val
set d.t_u_tea_set_pref = 
case
when d.t_u_tea_set_pref is null then v.value_name
else concat(d.t_u_tea_set_pref, ',', v.value_name) end
where t.t_u_tea_set_pref_4 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_pref_5' and t.t_u_tea_set_pref_5 = v.match_val
set d.t_u_tea_set_pref = 
case
when d.t_u_tea_set_pref is null then v.value_name
else concat(d.t_u_tea_set_pref, ',', v.value_name) end
where t.t_u_tea_set_pref_5 = 1;

-- 规格偏好
alter table u_dld_18 add column t_u_tea_spec_pref varchar(200) default null comment '规格偏好';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_spec_pref_0' and t.t_u_tea_spec_pref_0 = v.match_val
set d.t_u_tea_spec_pref = 
case
when d.t_u_tea_spec_pref is null then v.value_name
else concat(d.t_u_tea_spec_pref, ',', v.value_name) end
where t.t_u_tea_spec_pref_0 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_spec_pref_1' and t.t_u_tea_spec_pref_1 = v.match_val
set d.t_u_tea_spec_pref = 
case
when d.t_u_tea_spec_pref is null then v.value_name
else concat(d.t_u_tea_spec_pref, ',', v.value_name) end
where t.t_u_tea_spec_pref_1 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_spec_pref_2' and t.t_u_tea_spec_pref_2 = v.match_val
set d.t_u_tea_spec_pref = 
case
when d.t_u_tea_spec_pref is null then v.value_name
else concat(d.t_u_tea_spec_pref, ',', v.value_name) end
where t.t_u_tea_spec_pref_2 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_spec_pref_3' and t.t_u_tea_spec_pref_3 = v.match_val
set d.t_u_tea_spec_pref = 
case
when d.t_u_tea_spec_pref is null then v.value_name
else concat(d.t_u_tea_spec_pref, ',', v.value_name) end
where t.t_u_tea_spec_pref_3 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_spec_pref_4' and t.t_u_tea_spec_pref_4 = v.match_val
set d.t_u_tea_spec_pref = 
case
when d.t_u_tea_spec_pref is null then v.value_name
else concat(d.t_u_tea_spec_pref, ',', v.value_name) end
where t.t_u_tea_spec_pref_4 = 1;

-- 茶叶偏好
alter table u_dld_18 add column t_u_tea_type_pref varchar(200) default null comment '茶叶偏好';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_pref_0' and t.t_u_tea_type_pref_0 = v.match_val
set d.t_u_tea_type_pref = 
case
when d.t_u_tea_type_pref is null then v.value_name
else concat(d.t_u_tea_type_pref, ',', v.value_name) end
where t.t_u_tea_type_pref_0 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_pref_1' and t.t_u_tea_type_pref_1 = v.match_val
set d.t_u_tea_type_pref = 
case
when d.t_u_tea_type_pref is null then v.value_name
else concat(d.t_u_tea_type_pref, ',', v.value_name) end
where t.t_u_tea_type_pref_1 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_pref_2' and t.t_u_tea_type_pref_2 = v.match_val
set d.t_u_tea_type_pref = 
case
when d.t_u_tea_type_pref is null then v.value_name
else concat(d.t_u_tea_type_pref, ',', v.value_name) end
where t.t_u_tea_type_pref_2 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_pref_3' and t.t_u_tea_type_pref_3 = v.match_val
set d.t_u_tea_type_pref = 
case
when d.t_u_tea_type_pref is null then v.value_name
else concat(d.t_u_tea_type_pref, ',', v.value_name) end
where t.t_u_tea_type_pref_3 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_pref_4' and t.t_u_tea_type_pref_4 = v.match_val
set d.t_u_tea_type_pref = 
case
when d.t_u_tea_type_pref is null then v.value_name
else concat(d.t_u_tea_type_pref, ',', v.value_name) end
where t.t_u_tea_type_pref_4 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_pref_5' and t.t_u_tea_type_pref_5 = v.match_val
set d.t_u_tea_type_pref = 
case
when d.t_u_tea_type_pref is null then v.value_name
else concat(d.t_u_tea_type_pref, ',', v.value_name) end
where t.t_u_tea_type_pref_5 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_pref_6' and t.t_u_tea_type_pref_6 = v.match_val
set d.t_u_tea_type_pref = 
case
when d.t_u_tea_type_pref is null then v.value_name
else concat(d.t_u_tea_type_pref, ',', v.value_name) end
where t.t_u_tea_type_pref_6 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_pref_7' and t.t_u_tea_type_pref_7 = v.match_val
set d.t_u_tea_type_pref = 
case
when d.t_u_tea_type_pref is null then v.value_name
else concat(d.t_u_tea_type_pref, ',', v.value_name) end
where t.t_u_tea_type_pref_7 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_pref_8' and t.t_u_tea_type_pref_8 = v.match_val
set d.t_u_tea_type_pref = 
case
when d.t_u_tea_type_pref is null then v.value_name
else concat(d.t_u_tea_type_pref, ',', v.value_name) end
where t.t_u_tea_type_pref_8 = 1;

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_pref_9' and t.t_u_tea_type_pref_9 = v.match_val
set d.t_u_tea_type_pref = 
case
when d.t_u_tea_type_pref is null then v.value_name
else concat(d.t_u_tea_type_pref, ',', v.value_name) end
where t.t_u_tea_type_pref_9 = 1;

-- 茶具复购次数
alter table u_dld_18 add column t_u_tea_set_reorder varchar(200) default null comment '茶具复购次数';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_set_reorder' and t.t_u_tea_set_reorder = v.match_val
set d.t_u_tea_set_reorder = v.value_name;

-- 规格复购次数
alter table u_dld_18 add column t_u_tea_spec_reorder varchar(200) default null comment '规格复购次数';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_spec_reorder' and t.t_u_tea_spec_reorder = v.match_val
set d.t_u_tea_spec_reorder = v.value_name;

-- 茶叶复购次数
alter table u_dld_18 add column t_u_tea_type_reorder varchar(200) default null comment '茶叶复购次数';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_tea_type_reorder' and t.t_u_tea_type_reorder = v.match_val
set d.t_u_tea_type_reorder = v.value_name;

-- 退换款次数
alter table u_dld_18 add column t_u_reject_times varchar(200) default null comment '退换款次数';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_reject_times' and t.t_u_reject_times = v.match_val
set d.t_u_reject_times = v.value_name;

-- 是否参加618活动
alter table u_dld_18 add column t_u_promotion_618 varchar(200) default null comment '是否参加618活动';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_promotion_618' and t.t_u_promotion_618 = v.match_val
set d.t_u_promotion_618 = v.value_name;

-- 是否参加双11活动
alter table u_dld_18 add column t_u_promotion_1111 varchar(200) default null comment '是否参加双11活动';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_promotion_1111' and t.t_u_promotion_1111 = v.match_val
set d.t_u_promotion_1111 = v.value_name;

-- 是否参加双12活动
alter table u_dld_18 add column t_u_promotion_1212 varchar(200) default null comment '是否参加双12活动';

update u_dld_18 d left join u_tag_18 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_promotion_1212' and t.t_u_promotion_1212 = v.match_val
set d.t_u_promotion_1212 = v.value_name;

