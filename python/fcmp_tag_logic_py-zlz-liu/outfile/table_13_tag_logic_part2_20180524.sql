-- ----------------------------------
-- 客户13标签逻辑 2019-05-28 20:03:58
-- ----------------------------------
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

-- 生成tag表，含必显字段
drop table if exists u_tag_13;
create table u_tag_13 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户标签表'
select 
    phone, cname
from 
    member_info;
    
ALTER TABLE `u_tag_13`
ADD COLUMN `id`  int(11) NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `u_tag_13`
ADD INDEX `index_a` (phone) ;

-- 生成dld表
drop table if exists u_dld_13;
create table u_dld_13 like  u_tag_13;
insert into u_dld_13 select * from u_tag_13;

ALTER TABLE `u_dld_13`
COMMENT='用户下载表';

-- 生成mid表
drop table if exists u_mid_13;
create table u_mid_13 like  u_tag_13;
insert into u_mid_13 select * from u_tag_13;

ALTER TABLE `u_mid_13`
COMMENT='用户中间值表';

-- ----------------------------------
--            标签逻辑-标签表
-- ----------------------------------
-- -----------基本信息-----------
-- b_002_tag_type1_case_between
-- 年龄
alter table u_tag_13 add column t_u_age int(5) default 0 comment '年龄';

update u_tag_13 t left join member_info b 
on t.phone = b.phone
set t.t_u_age = 
case
when b.age <= 17 then 1
when b.age >= 18 and b.age <= 23 then 2
when b.age >= 24 and b.age <= 27 then 3
when b.age >= 28 and b.age <= 30 then 4
when b.age >= 31 and b.age <= 35 then 5
when b.age >= 36 and b.age <= 40 then 6
when b.age >= 41 and b.age <= 45 then 7
when b.age >= 46 and b.age <= 50 then 8
when b.age >= 51 and b.age <= 55 then 9
when b.age >= 56 and b.age <= 60 then 10
when b.age >= 61 and b.age <= 65 then 11
when b.age >= 66 and b.age <= 70 then 12
when b.age >= 71 then 13
else 0 end;

-- b_003_tag_type1_case_str
-- 地址
alter table u_tag_13 add column t_u_address int(5) default 0 comment '地址';

update u_tag_13 t left join member_info b 
on t.phone = b.phone
set t.t_u_address = 
case
when b.province = '上海市' then 1
when b.province = '云南省' then 2
when b.province = '内蒙古自治区' then 3
when b.province = '北京市' then 4
when b.province = '吉林省' then 5
when b.province = '四川省' then 6
when b.province = '天津市' then 7
when b.province = '宁夏回族自治区' then 8
when b.province = '安徽省' then 9
when b.province = '山东省' then 10
when b.province = '山西省' then 11
when b.province = '广东省' then 12
when b.province = '广西壮族自治区' then 13
when b.province = '新疆维吾尔自治区' then 14
when b.province = '江苏省' then 15
when b.province = '江西省' then 16
when b.province = '河北省' then 17
when b.province = '河南省' then 18
when b.province = '浙江省' then 19
when b.province = '海南省' then 20
when b.province = '湖北省' then 21
when b.province = '湖南省' then 22
when b.province = '甘肃省' then 23
when b.province = '福建省' then 24
when b.province = '西藏自治区' then 25
when b.province = '贵州省' then 26
when b.province = '辽宁省' then 27
when b.province = '重庆市' then 28
when b.province = '陕西省' then 29
when b.province = '青海省' then 30
when b.province = '黑龙江省' then 31
else 0 end;

-- 过程值：3个月以前的下单次数
alter table u_mid_13 add column order_times_before3 int(5) default 0 comment '过程值：3个月以前的下单次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.order_time < date_sub(date(20180312),interval 3 month)
group by t.id
) y on x.id = y.id 
set order_times_before3 = y.c;

-- 过程值：3个月以内下单次数
alter table u_mid_13 add column order_times_after3 int(5) default 0 comment '过程值：3个月以内下单次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.order_time >= date_sub(date(20180312),interval 3 month)
group by t.id
) y on x.id = y.id 
set order_times_after3 = y.c;

-- 过程值：12个月以内下单次数
alter table u_mid_13 add column order_times_after12 int(5) default 0 comment '过程值：12个月以内下单次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.order_time >= date_sub(date(20180312),interval 12 month)
group by t.id
) y on x.id = y.id 
set order_times_after12 = y.c;

-- 过程值：总下单次数
alter table u_mid_13 add column order_times_total int(5) default 0 comment '过程值：总下单次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where true
group by t.id
) y on x.id = y.id 
set order_times_total = y.c;

-- 过程值：消费金额总和
alter table u_mid_13 add column total_cost_value int(11) default 0 comment '过程值：消费金额总和';

update u_mid_13 x inner join (
select t.id, sum(b.total_cost) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where true
group by t.id
) y on x.id = y.id 
set total_cost_value = y.c;

-- 客户属性
alter table u_tag_13 add column t_u_ctype int(5) default 2 comment '客户属性';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_ctype = 
case
when b.order_times_before3 = 1 and b.order_times_after3 = 0 then 0
when b.order_times_before3 = 0 and b.order_times_after3 > 0 then 1
else 2 end;

-- 是否高价值客户
alter table u_tag_13 add column t_u_valuable int(5) default 0 comment '是否高价值客户';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_valuable = 
case
when b.order_times_total > 5 and b.total_cost_value > 500 then 1
else 0 end;

-- -- 过程值：首次到店日期
alter table u_mid_13 add column first_come_date date default null comment '过程值：首次到店时间';

update u_mid_13 x inner join (
select t.id, min(b.order_time) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where true
group by t.id
) y on x.id = y.id 
set first_come_date = y.c;

-- -- 过程值：近一年到店计入月数
alter table u_mid_13 add column last_year_interview_month decimal(7,5) default 0.0 comment '过程值：近一年到店计入月数';

update u_mid_13 
set last_year_interview_month = 
case
when first_come_date is null then 99
when first_come_date < date_sub(date(20180312),interval 1 year) then 12.0
when first_come_date > date_sub(date(20180312),interval 1 month) then 1
else datediff(date(20180312),first_come_date)/30 end;

-- -- 过程值：近一年到店频率
alter table u_mid_13 add column last_year_rate decimal(12,3) default 0 comment '过程值：近一年到店频率';

update u_mid_13
set last_year_rate = order_times_after12/last_year_interview_month;

-- b_002_tag_type1_case_between
-- 近一年下单频率
alter table u_tag_13 add column t_u_year_frequency int(5) default 0 comment '近一年下单频率';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_year_frequency = 
case
when b.last_year_rate <= 0.25 then 0
when b.last_year_rate >= 0.25 and b.last_year_rate <= 0.5 then 1
when b.last_year_rate >= 0.5 then 2
else 0 end;

-- b_002_tag_type1_case_between
-- 总下单次数
alter table u_tag_13 add column t_u_total_order int(5) default 0 comment '总下单次数';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_total_order = 
case
when b.order_times_total <= 1 then 0
when b.order_times_total >= 2 and b.order_times_total <= 4 then 1
when b.order_times_total >= 5 and b.order_times_total <= 7 then 2
when b.order_times_total >= 8 and b.order_times_total <= 10 then 3
when b.order_times_total >= 11 and b.order_times_total <= 15 then 4
when b.order_times_total >= 16 then 5
else 0 end;

-- b_002_tag_type1_case_between
-- 消费金额总和
alter table u_tag_13 add column t_u_total_cost int(5) default 0 comment '消费金额总和';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_total_cost = 
case
when b.total_cost_value <= 50 then 0
when b.total_cost_value >= 50 and b.total_cost_value <= 100 then 1
when b.total_cost_value >= 100 and b.total_cost_value <= 200 then 2
when b.total_cost_value >= 200 and b.total_cost_value <= 500 then 3
when b.total_cost_value >= 500 and b.total_cost_value <= 1000 then 4
when b.total_cost_value >= 1000 then 5
else 0 end;

-- -- 过程值：客单价
alter table u_mid_13 add column per_customer_transaction decimal(12,3) default 0 comment '过程值：客单价';

update u_mid_13
set per_customer_transaction = total_cost_value/order_times_total;

-- b_002_tag_type1_case_between
-- 客单价
alter table u_tag_13 add column t_u_pct int(5) default 0 comment '客单价';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_pct = 
case
when b.per_customer_transaction <= 50 then 0
when b.per_customer_transaction >= 50 and b.per_customer_transaction <= 100 then 1
when b.per_customer_transaction >= 100 and b.per_customer_transaction <= 200 then 2
when b.per_customer_transaction >= 200 and b.per_customer_transaction <= 500 then 3
when b.per_customer_transaction >= 500 and b.per_customer_transaction <= 1000 then 4
when b.per_customer_transaction >= 1000 then 5
else 0 end;

-- 过程值：拒收次数
alter table u_mid_13 add column reject_value int(5) default 0 comment '过程值：拒收次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.comment like '%拒收%'
group by t.id
) y on x.id = y.id 
set reject_value = y.c;

-- b_002_tag_type1_case_between
-- 拒收次数
alter table u_tag_13 add column t_u_reject int(5) default 0 comment '拒收次数';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_reject = 
case
when b.reject_value <= 0 then 0
when b.reject_value >= 1 and b.reject_value <= 1 then 1
when b.reject_value >= 2 and b.reject_value <= 2 then 2
when b.reject_value >= 3 and b.reject_value <= 3 then 3
when b.reject_value >= 4 and b.reject_value <= 4 then 4
when b.reject_value >= 5 and b.reject_value <= 5 then 5
when b.reject_value >= 6 and b.reject_value <= 10 then 6
when b.reject_value >= 11 then 7
else 0 end;

-- 过程值：退换货次数
alter table u_mid_13 add column return_value int(5) default 0 comment '过程值：退换货次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.order_status = '已退货'
group by t.id
) y on x.id = y.id 
set return_value = y.c;

-- b_002_tag_type1_case_between
-- 退换货次数
alter table u_tag_13 add column t_u_return int(5) default 0 comment '退换货次数';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_return = 
case
when b.return_value <= 0 then 0
when b.return_value >= 1 and b.return_value <= 1 then 1
when b.return_value >= 2 and b.return_value <= 2 then 2
when b.return_value >= 3 and b.return_value <= 3 then 3
when b.return_value >= 4 and b.return_value <= 4 then 4
when b.return_value >= 5 and b.return_value <= 5 then 5
when b.return_value >= 6 and b.return_value <= 10 then 6
when b.return_value >= 11 then 7
else 0 end;

-- b_004_mid_type2_basic
-- 洗面类复购次数
alter table u_mid_13 add column order_xm_value int(5) default 0 comment '洗面类复购次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%祛痘%' or b.goods_name_strs like '%粉刺调理%' or b.goods_name_strs like '%洁面%'
group by t.id
) y on x.id = y.id 
set order_xm_value = y.c;

-- b_002_tag_type1_case_between
-- 洗面类复购次数
alter table u_tag_13 add column t_u_order_xm int(5) default 0 comment '洗面类复购次数';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_order_xm = 
case
when b.order_xm_value <= 1 then 0
when b.order_xm_value >= 2 and b.order_xm_value <= 2 then 1
when b.order_xm_value >= 3 and b.order_xm_value <= 3 then 2
when b.order_xm_value >= 4 and b.order_xm_value <= 4 then 3
when b.order_xm_value >= 5 and b.order_xm_value <= 5 then 4
when b.order_xm_value >= 6 and b.order_xm_value <= 6 then 5
when b.order_xm_value >= 7 and b.order_xm_value <= 7 then 6
when b.order_xm_value >= 8 and b.order_xm_value <= 8 then 7
when b.order_xm_value >= 9 and b.order_xm_value <= 9 then 8
when b.order_xm_value >= 10 and b.order_xm_value <= 10 then 9
when b.order_xm_value >= 11 and b.order_xm_value <= 11 then 10
when b.order_xm_value >= 12 then 11
else 0 end;

-- b_004_mid_type2_basic
-- 倍润霜复购次数
alter table u_mid_13 add column order_brs_value int(5) default 0 comment '倍润霜复购次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%倍润霜%'
group by t.id
) y on x.id = y.id 
set order_brs_value = y.c;

-- b_002_tag_type1_case_between
-- 倍润霜复购次数
alter table u_tag_13 add column t_u_order_brs int(5) default 0 comment '倍润霜复购次数';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_order_brs = 
case
when b.order_brs_value <= 1 then 0
when b.order_brs_value >= 2 and b.order_brs_value <= 2 then 1
when b.order_brs_value >= 3 and b.order_brs_value <= 3 then 2
when b.order_brs_value >= 4 and b.order_brs_value <= 4 then 3
when b.order_brs_value >= 5 and b.order_brs_value <= 5 then 4
when b.order_brs_value >= 6 and b.order_brs_value <= 6 then 5
when b.order_brs_value >= 7 and b.order_brs_value <= 7 then 6
when b.order_brs_value >= 8 and b.order_brs_value <= 8 then 7
when b.order_brs_value >= 9 and b.order_brs_value <= 9 then 8
when b.order_brs_value >= 10 and b.order_brs_value <= 10 then 9
when b.order_brs_value >= 11 and b.order_brs_value <= 11 then 10
when b.order_brs_value >= 12 then 11
else 0 end;

-- b_004_mid_type2_basic
-- 面膜类复购次数
alter table u_mid_13 add column order_mm_value int(5) default 0 comment '面膜类复购次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%面膜%' or b.goods_name_strs like '%眼膜%' or b.goods_name_strs like '%U膜%' or b.goods_name_strs like '%冰膜%'
group by t.id
) y on x.id = y.id 
set order_mm_value = y.c;

-- b_002_tag_type1_case_between
-- 面膜类复购次数
alter table u_tag_13 add column t_u_order_mm int(5) default 0 comment '面膜类复购次数';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_order_mm = 
case
when b.order_mm_value <= 1 then 0
when b.order_mm_value >= 2 and b.order_mm_value <= 2 then 1
when b.order_mm_value >= 3 and b.order_mm_value <= 3 then 2
when b.order_mm_value >= 4 and b.order_mm_value <= 4 then 3
when b.order_mm_value >= 5 and b.order_mm_value <= 5 then 4
when b.order_mm_value >= 6 and b.order_mm_value <= 6 then 5
when b.order_mm_value >= 7 and b.order_mm_value <= 7 then 6
when b.order_mm_value >= 8 and b.order_mm_value <= 8 then 7
when b.order_mm_value >= 9 and b.order_mm_value <= 9 then 8
when b.order_mm_value >= 10 and b.order_mm_value <= 10 then 9
when b.order_mm_value >= 11 and b.order_mm_value <= 11 then 10
when b.order_mm_value >= 12 then 11
else 0 end;

-- b_004_mid_type2_basic
-- 喷雾类复购次数
alter table u_mid_13 add column order_pw_value int(5) default 0 comment '喷雾类复购次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%喷雾%'
group by t.id
) y on x.id = y.id 
set order_pw_value = y.c;

-- b_002_tag_type1_case_between
-- 喷雾类复购次数
alter table u_tag_13 add column t_u_order_pw int(5) default 0 comment '喷雾类复购次数';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_order_pw = 
case
when b.order_pw_value <= 1 then 0
when b.order_pw_value >= 2 and b.order_pw_value <= 2 then 1
when b.order_pw_value >= 3 and b.order_pw_value <= 3 then 2
when b.order_pw_value >= 4 and b.order_pw_value <= 4 then 3
when b.order_pw_value >= 5 and b.order_pw_value <= 5 then 4
when b.order_pw_value >= 6 and b.order_pw_value <= 6 then 5
when b.order_pw_value >= 7 and b.order_pw_value <= 7 then 6
when b.order_pw_value >= 8 and b.order_pw_value <= 8 then 7
when b.order_pw_value >= 9 and b.order_pw_value <= 9 then 8
when b.order_pw_value >= 10 and b.order_pw_value <= 10 then 9
when b.order_pw_value >= 11 and b.order_pw_value <= 11 then 10
when b.order_pw_value >= 12 then 11
else 0 end;

-- b_004_mid_type2_basic
-- 精华类复购次数
alter table u_mid_13 add column order_jh_value int(5) default 0 comment '精华类复购次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%精华液%' or b.goods_name_strs like '%精纯液%' or b.goods_name_strs like '%冻干粉%'
group by t.id
) y on x.id = y.id 
set order_jh_value = y.c;

-- b_002_tag_type1_case_between
-- 精华类复购次数
alter table u_tag_13 add column t_u_order_jh int(5) default 0 comment '精华类复购次数';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_order_jh = 
case
when b.order_jh_value <= 1 then 0
when b.order_jh_value >= 2 and b.order_jh_value <= 2 then 1
when b.order_jh_value >= 3 and b.order_jh_value <= 3 then 2
when b.order_jh_value >= 4 and b.order_jh_value <= 4 then 3
when b.order_jh_value >= 5 and b.order_jh_value <= 5 then 4
when b.order_jh_value >= 6 and b.order_jh_value <= 6 then 5
when b.order_jh_value >= 7 and b.order_jh_value <= 7 then 6
when b.order_jh_value >= 8 and b.order_jh_value <= 8 then 7
when b.order_jh_value >= 9 and b.order_jh_value <= 9 then 8
when b.order_jh_value >= 10 and b.order_jh_value <= 10 then 9
when b.order_jh_value >= 11 and b.order_jh_value <= 11 then 10
when b.order_jh_value >= 12 then 11
else 0 end;

-- b_004_mid_type2_basic
-- 精油类复购次数
alter table u_mid_13 add column order_jy_value int(5) default 0 comment '精油类复购次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%精油%'
group by t.id
) y on x.id = y.id 
set order_jy_value = y.c;

-- b_002_tag_type1_case_between
-- 精油类复购次数
alter table u_tag_13 add column t_u_order_jy int(5) default 0 comment '精油类复购次数';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_order_jy = 
case
when b.order_jy_value <= 1 then 0
when b.order_jy_value >= 2 and b.order_jy_value <= 2 then 1
when b.order_jy_value >= 3 and b.order_jy_value <= 3 then 2
when b.order_jy_value >= 4 and b.order_jy_value <= 4 then 3
when b.order_jy_value >= 5 and b.order_jy_value <= 5 then 4
when b.order_jy_value >= 6 and b.order_jy_value <= 6 then 5
when b.order_jy_value >= 7 and b.order_jy_value <= 7 then 6
when b.order_jy_value >= 8 and b.order_jy_value <= 8 then 7
when b.order_jy_value >= 9 and b.order_jy_value <= 9 then 8
when b.order_jy_value >= 10 and b.order_jy_value <= 10 then 9
when b.order_jy_value >= 11 and b.order_jy_value <= 11 then 10
when b.order_jy_value >= 12 then 11
else 0 end;

-- b_004_mid_type2_basic
-- 养发类复购次数
alter table u_mid_13 add column order_yf_value int(5) default 0 comment '养发类复购次数';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%育发%' or b.goods_name_strs like '%固发%'
group by t.id
) y on x.id = y.id 
set order_yf_value = y.c;

-- b_002_tag_type1_case_between
-- 养发类复购次数
alter table u_tag_13 add column t_u_order_yf int(5) default 0 comment '养发类复购次数';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_order_yf = 
case
when b.order_yf_value <= 1 then 0
when b.order_yf_value >= 2 and b.order_yf_value <= 2 then 1
when b.order_yf_value >= 3 and b.order_yf_value <= 3 then 2
when b.order_yf_value >= 4 and b.order_yf_value <= 4 then 3
when b.order_yf_value >= 5 and b.order_yf_value <= 5 then 4
when b.order_yf_value >= 6 and b.order_yf_value <= 6 then 5
when b.order_yf_value >= 7 and b.order_yf_value <= 7 then 6
when b.order_yf_value >= 8 and b.order_yf_value <= 8 then 7
when b.order_yf_value >= 9 and b.order_yf_value <= 9 then 8
when b.order_yf_value >= 10 and b.order_yf_value <= 10 then 9
when b.order_yf_value >= 11 and b.order_yf_value <= 11 then 10
when b.order_yf_value >= 12 then 11
else 0 end;

-- b_004_mid_type2_basic
-- 物流偏好-EMS
alter table u_mid_13 add column ex_pref_1_value int(5) default 0 comment '物流偏好-EMS';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.express_company like '%EMS%' and TRUE
group by t.id
) y on x.id = y.id 
set ex_pref_1_value = y.c;

-- b_002_tag_type1_case_between
-- 物流偏好-EMS
alter table u_tag_13 add column t_u_ex_pref_1 int(5) default 0 comment '物流偏好-EMS';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_ex_pref_1 = 
case
when b.ex_pref_1_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 物流偏好-黑猫
alter table u_mid_13 add column ex_pref_2_value int(5) default 0 comment '物流偏好-黑猫';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.express_company like '%黑猫%' and TRUE
group by t.id
) y on x.id = y.id 
set ex_pref_2_value = y.c;

-- b_002_tag_type1_case_between
-- 物流偏好-黑猫
alter table u_tag_13 add column t_u_ex_pref_2 int(5) default 0 comment '物流偏好-黑猫';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_ex_pref_2 = 
case
when b.ex_pref_2_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 物流偏好-顺丰
alter table u_mid_13 add column ex_pref_3_value int(5) default 0 comment '物流偏好-顺丰';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.express_company like '%顺丰%' and TRUE
group by t.id
) y on x.id = y.id 
set ex_pref_3_value = y.c;

-- b_002_tag_type1_case_between
-- 物流偏好-顺丰
alter table u_tag_13 add column t_u_ex_pref_3 int(5) default 0 comment '物流偏好-顺丰';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_ex_pref_3 = 
case
when b.ex_pref_3_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 物流偏好-天天
alter table u_mid_13 add column ex_pref_4_value int(5) default 0 comment '物流偏好-天天';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.express_company like '%天天%' and TRUE
group by t.id
) y on x.id = y.id 
set ex_pref_4_value = y.c;

-- b_002_tag_type1_case_between
-- 物流偏好-天天
alter table u_tag_13 add column t_u_ex_pref_4 int(5) default 0 comment '物流偏好-天天';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_ex_pref_4 = 
case
when b.ex_pref_4_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 物流偏好-圆通
alter table u_mid_13 add column ex_pref_5_value int(5) default 0 comment '物流偏好-圆通';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.express_company like '%圆通%' and TRUE
group by t.id
) y on x.id = y.id 
set ex_pref_5_value = y.c;

-- b_002_tag_type1_case_between
-- 物流偏好-圆通
alter table u_tag_13 add column t_u_ex_pref_5 int(5) default 0 comment '物流偏好-圆通';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_ex_pref_5 = 
case
when b.ex_pref_5_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 物流偏好-申通
alter table u_mid_13 add column ex_pref_6_value int(5) default 0 comment '物流偏好-申通';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.express_company like '%申通%' and TRUE
group by t.id
) y on x.id = y.id 
set ex_pref_6_value = y.c;

-- b_002_tag_type1_case_between
-- 物流偏好-申通
alter table u_tag_13 add column t_u_ex_pref_6 int(5) default 0 comment '物流偏好-申通';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_ex_pref_6 = 
case
when b.ex_pref_6_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 物流偏好-中通
alter table u_mid_13 add column ex_pref_7_value int(5) default 0 comment '物流偏好-中通';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.express_company like '%中通%' and TRUE
group by t.id
) y on x.id = y.id 
set ex_pref_7_value = y.c;

-- b_002_tag_type1_case_between
-- 物流偏好-中通
alter table u_tag_13 add column t_u_ex_pref_7 int(5) default 0 comment '物流偏好-中通';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_ex_pref_7 = 
case
when b.ex_pref_7_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 物流偏好-邮政
alter table u_mid_13 add column ex_pref_8_value int(5) default 0 comment '物流偏好-邮政';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.express_company like '%邮政%' and TRUE
group by t.id
) y on x.id = y.id 
set ex_pref_8_value = y.c;

-- b_002_tag_type1_case_between
-- 物流偏好-邮政
alter table u_tag_13 add column t_u_ex_pref_8 int(5) default 0 comment '物流偏好-邮政';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_ex_pref_8 = 
case
when b.ex_pref_8_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 物流偏好-德邦
alter table u_mid_13 add column ex_pref_9_value int(5) default 0 comment '物流偏好-德邦';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.express_company like '%德邦%' and TRUE
group by t.id
) y on x.id = y.id 
set ex_pref_9_value = y.c;

-- b_002_tag_type1_case_between
-- 物流偏好-德邦
alter table u_tag_13 add column t_u_ex_pref_9 int(5) default 0 comment '物流偏好-德邦';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_ex_pref_9 = 
case
when b.ex_pref_9_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 物流偏好-京东
alter table u_mid_13 add column ex_pref_10_value int(5) default 0 comment '物流偏好-京东';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.express_company like '%京东%' and TRUE
group by t.id
) y on x.id = y.id 
set ex_pref_10_value = y.c;

-- b_002_tag_type1_case_between
-- 物流偏好-京东
alter table u_tag_13 add column t_u_ex_pref_10 int(5) default 0 comment '物流偏好-京东';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_ex_pref_10 = 
case
when b.ex_pref_10_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 物流偏好-缺失
alter table u_mid_13 add column ex_pref_0_value int(5) default 0 comment '物流偏好-缺失';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.express_company is null or b.express_company = ''
group by t.id
) y on x.id = y.id 
set ex_pref_0_value = y.c;

-- b_002_tag_type1_case_between
-- 物流偏好-缺失
alter table u_tag_13 add column t_u_ex_pref_0 int(5) default 0 comment '物流偏好-缺失';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_ex_pref_0 = 
case
when b.ex_pref_0_value >= 1 then 1
else 0 end;

-- b_005_tag_type1_one_where
-- 物流偏好其他
alter table u_tag_13 add column t_u_ex_pref_11 int(5) default 0 comment '物流偏好其他';

update u_tag_13
set t_u_ex_pref_11 = 1
where t_u_ex_pref_0 = 0 and t_u_ex_pref_1 = 0 and t_u_ex_pref_2 = 0 and t_u_ex_pref_3 = 0 and t_u_ex_pref_4 = 0 and t_u_ex_pref_5 = 0 and t_u_ex_pref_6 = 0 and t_u_ex_pref_7 = 0 and t_u_ex_pref_8 = 0 and t_u_ex_pref_9 = 0 and t_u_ex_pref_10 = 0;

-- b_004_mid_type2_basic
-- 支付偏好-微信支付
alter table u_mid_13 add column pay_pref_1_value int(5) default 0 comment '支付偏好-微信支付';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.pay_mode like '%微信%' and b.pay_mode not like '%预付款%' and b.pay_mode not like '%预支付%' and b.pay_mode not like '%货到付款%'
group by t.id
) y on x.id = y.id 
set pay_pref_1_value = y.c;

-- b_002_tag_type1_case_between
-- 支付偏好-微信支付
alter table u_tag_13 add column t_u_pay_pref_1 int(5) default 0 comment '支付偏好-微信支付';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_pay_pref_1 = 
case
when b.pay_pref_1_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 支付偏好-支付宝支付
alter table u_mid_13 add column pay_pref_2_value int(5) default 0 comment '支付偏好-支付宝支付';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.pay_mode like '%支付宝%' and b.pay_mode not like '%预付款%' and b.pay_mode not like '%预支付%' and b.pay_mode not like '%货到付款%'
group by t.id
) y on x.id = y.id 
set pay_pref_2_value = y.c;

-- b_002_tag_type1_case_between
-- 支付偏好-支付宝支付
alter table u_tag_13 add column t_u_pay_pref_2 int(5) default 0 comment '支付偏好-支付宝支付';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_pay_pref_2 = 
case
when b.pay_pref_2_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 支付偏好-现金支付
alter table u_mid_13 add column pay_pref_3_value int(5) default 0 comment '支付偏好-现金支付';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.pay_mode like '%现金%' and b.pay_mode not like '%货到付款%'
group by t.id
) y on x.id = y.id 
set pay_pref_3_value = y.c;

-- b_002_tag_type1_case_between
-- 支付偏好-现金支付
alter table u_tag_13 add column t_u_pay_pref_3 int(5) default 0 comment '支付偏好-现金支付';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_pay_pref_3 = 
case
when b.pay_pref_3_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 支付偏好-银行支付
alter table u_mid_13 add column pay_pref_4_value int(5) default 0 comment '支付偏好-银行支付';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.pay_mode like '%银行%' and b.pay_mode not like '%预付款%' and b.pay_mode not like '%预支付%' and b.pay_mode not like '%货到付款%'
group by t.id
) y on x.id = y.id 
set pay_pref_4_value = y.c;

-- b_002_tag_type1_case_between
-- 支付偏好-银行支付
alter table u_tag_13 add column t_u_pay_pref_4 int(5) default 0 comment '支付偏好-银行支付';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_pay_pref_4 = 
case
when b.pay_pref_4_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 支付偏好-货到付款
alter table u_mid_13 add column pay_pref_5_value int(5) default 0 comment '支付偏好-货到付款';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.pay_mode like '%货到付款%' and TRUE
group by t.id
) y on x.id = y.id 
set pay_pref_5_value = y.c;

-- b_002_tag_type1_case_between
-- 支付偏好-货到付款
alter table u_tag_13 add column t_u_pay_pref_5 int(5) default 0 comment '支付偏好-货到付款';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_pay_pref_5 = 
case
when b.pay_pref_5_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 支付偏好-微信/支付宝/银行预付款
alter table u_mid_13 add column pay_pref_6_value int(5) default 0 comment '支付偏好-微信/支付宝/银行预付款';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.pay_mode like '%预付款%' or b.pay_mode like '%预支付%' and TRUE
group by t.id
) y on x.id = y.id 
set pay_pref_6_value = y.c;

-- b_002_tag_type1_case_between
-- 支付偏好-微信/支付宝/银行预付款
alter table u_tag_13 add column t_u_pay_pref_6 int(5) default 0 comment '支付偏好-微信/支付宝/银行预付款';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_pay_pref_6 = 
case
when b.pay_pref_6_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 支付偏好-缺失
alter table u_mid_13 add column pay_pref_0_value int(5) default 0 comment '支付偏好-缺失';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.pay_mode is null or b.pay_mode = ''
group by t.id
) y on x.id = y.id 
set pay_pref_0_value = y.c;

-- b_002_tag_type1_case_between
-- 支付偏好-缺失
alter table u_tag_13 add column t_u_pay_pref_0 int(5) default 0 comment '支付偏好-缺失';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_pay_pref_0 = 
case
when b.pay_pref_0_value >= 1 then 1
else 0 end;

-- b_005_tag_type1_one_where
-- 支付偏好其他
alter table u_tag_13 add column t_u_pay_pref_7 int(5) default 0 comment '支付偏好其他';

update u_tag_13
set t_u_pay_pref_7 = 1
where t_u_pay_pref_0 = 0 and t_u_pay_pref_1 = 0 and t_u_pay_pref_2 = 0 and t_u_pay_pref_3 = 0 and t_u_pay_pref_4 = 0 and t_u_pay_pref_5 = 0 and t_u_pay_pref_6 = 0;

-- b_004_mid_type2_basic
-- 产品偏好-补水
alter table u_mid_13 add column product_pref_1_value int(5) default 0 comment '产品偏好-补水';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%补水%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_1_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-补水
alter table u_tag_13 add column t_u_product_pref_1 int(5) default 0 comment '产品偏好-补水';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_1 = 
case
when b.product_pref_1_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-保湿
alter table u_mid_13 add column product_pref_2_value int(5) default 0 comment '产品偏好-保湿';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%保湿%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_2_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-保湿
alter table u_tag_13 add column t_u_product_pref_2 int(5) default 0 comment '产品偏好-保湿';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_2 = 
case
when b.product_pref_2_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-洁面
alter table u_mid_13 add column product_pref_3_value int(5) default 0 comment '产品偏好-洁面';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%洁面%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_3_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-洁面
alter table u_tag_13 add column t_u_product_pref_3 int(5) default 0 comment '产品偏好-洁面';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_3 = 
case
when b.product_pref_3_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-祛痘
alter table u_mid_13 add column product_pref_4_value int(5) default 0 comment '产品偏好-祛痘';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%祛痘%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_4_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-祛痘
alter table u_tag_13 add column t_u_product_pref_4 int(5) default 0 comment '产品偏好-祛痘';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_4 = 
case
when b.product_pref_4_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-喷雾
alter table u_mid_13 add column product_pref_5_value int(5) default 0 comment '产品偏好-喷雾';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%喷雾%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_5_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-喷雾
alter table u_tag_13 add column t_u_product_pref_5 int(5) default 0 comment '产品偏好-喷雾';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_5 = 
case
when b.product_pref_5_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-眼霜
alter table u_mid_13 add column product_pref_6_value int(5) default 0 comment '产品偏好-眼霜';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%眼霜%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_6_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-眼霜
alter table u_tag_13 add column t_u_product_pref_6 int(5) default 0 comment '产品偏好-眼霜';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_6 = 
case
when b.product_pref_6_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-倍润霜
alter table u_mid_13 add column product_pref_7_value int(5) default 0 comment '产品偏好-倍润霜';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%倍润霜%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_7_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-倍润霜
alter table u_tag_13 add column t_u_product_pref_7 int(5) default 0 comment '产品偏好-倍润霜';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_7 = 
case
when b.product_pref_7_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-隔离霜
alter table u_mid_13 add column product_pref_8_value int(5) default 0 comment '产品偏好-隔离霜';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%隔离霜%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_8_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-隔离霜
alter table u_tag_13 add column t_u_product_pref_8 int(5) default 0 comment '产品偏好-隔离霜';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_8 = 
case
when b.product_pref_8_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-面膜
alter table u_mid_13 add column product_pref_9_value int(5) default 0 comment '产品偏好-面膜';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%面膜%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_9_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-面膜
alter table u_tag_13 add column t_u_product_pref_9 int(5) default 0 comment '产品偏好-面膜';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_9 = 
case
when b.product_pref_9_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-眼膜
alter table u_mid_13 add column product_pref_10_value int(5) default 0 comment '产品偏好-眼膜';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%眼膜%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_10_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-眼膜
alter table u_tag_13 add column t_u_product_pref_10 int(5) default 0 comment '产品偏好-眼膜';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_10 = 
case
when b.product_pref_10_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-U膜
alter table u_mid_13 add column product_pref_11_value int(5) default 0 comment '产品偏好-U膜';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%U膜%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_11_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-U膜
alter table u_tag_13 add column t_u_product_pref_11 int(5) default 0 comment '产品偏好-U膜';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_11 = 
case
when b.product_pref_11_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-睡眠冰膜
alter table u_mid_13 add column product_pref_12_value int(5) default 0 comment '产品偏好-睡眠冰膜';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%睡眠冰膜%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_12_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-睡眠冰膜
alter table u_tag_13 add column t_u_product_pref_12 int(5) default 0 comment '产品偏好-睡眠冰膜';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_12 = 
case
when b.product_pref_12_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-精华液
alter table u_mid_13 add column product_pref_13_value int(5) default 0 comment '产品偏好-精华液';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%精华液%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_13_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-精华液
alter table u_tag_13 add column t_u_product_pref_13 int(5) default 0 comment '产品偏好-精华液';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_13 = 
case
when b.product_pref_13_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-精纯液
alter table u_mid_13 add column product_pref_14_value int(5) default 0 comment '产品偏好-精纯液';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%精纯液%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_14_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-精纯液
alter table u_tag_13 add column t_u_product_pref_14 int(5) default 0 comment '产品偏好-精纯液';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_14 = 
case
when b.product_pref_14_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-冻干粉
alter table u_mid_13 add column product_pref_15_value int(5) default 0 comment '产品偏好-冻干粉';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%冻干粉%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_15_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-冻干粉
alter table u_tag_13 add column t_u_product_pref_15 int(5) default 0 comment '产品偏好-冻干粉';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_15 = 
case
when b.product_pref_15_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-雪肤
alter table u_mid_13 add column product_pref_16_value int(5) default 0 comment '产品偏好-雪肤';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%雪肤%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_16_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-雪肤
alter table u_tag_13 add column t_u_product_pref_16 int(5) default 0 comment '产品偏好-雪肤';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_16 = 
case
when b.product_pref_16_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-固发育发
alter table u_mid_13 add column product_pref_17_value int(5) default 0 comment '产品偏好-固发育发';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%固发%' or b.goods_name_strs like '%育发%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_17_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-固发育发
alter table u_tag_13 add column t_u_product_pref_17 int(5) default 0 comment '产品偏好-固发育发';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_17 = 
case
when b.product_pref_17_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-细纹修护
alter table u_mid_13 add column product_pref_18_value int(5) default 0 comment '产品偏好-细纹修护';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%细纹修护%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_18_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-细纹修护
alter table u_tag_13 add column t_u_product_pref_18 int(5) default 0 comment '产品偏好-细纹修护';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_18 = 
case
when b.product_pref_18_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-精油
alter table u_mid_13 add column product_pref_19_value int(5) default 0 comment '产品偏好-精油';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%精油%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_19_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-精油
alter table u_tag_13 add column t_u_product_pref_19 int(5) default 0 comment '产品偏好-精油';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_19 = 
case
when b.product_pref_19_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-粉刺调理
alter table u_mid_13 add column product_pref_20_value int(5) default 0 comment '产品偏好-粉刺调理';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs like '%粉刺调理%' and TRUE
group by t.id
) y on x.id = y.id 
set product_pref_20_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-粉刺调理
alter table u_tag_13 add column t_u_product_pref_20 int(5) default 0 comment '产品偏好-粉刺调理';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_20 = 
case
when b.product_pref_20_value >= 1 then 1
else 0 end;

-- b_004_mid_type2_basic
-- 产品偏好-缺失
alter table u_mid_13 add column product_pref_0_value int(5) default 0 comment '产品偏好-缺失';

update u_mid_13 x inner join (
select t.id, count(*) c from 
u_mid_13 t inner join order_list b 
on t.phone = b.phone
where b.goods_name_strs is null or b.goods_name_strs = ''
group by t.id
) y on x.id = y.id 
set product_pref_0_value = y.c;

-- b_002_tag_type1_case_between
-- 产品偏好-缺失
alter table u_tag_13 add column t_u_product_pref_0 int(5) default 0 comment '产品偏好-缺失';

update u_tag_13 t left join u_mid_13 b 
on t.id = b.id
set t.t_u_product_pref_0 = 
case
when b.product_pref_0_value >= 1 then 1
else 0 end;

-- b_005_tag_type1_one_where
-- 产品偏好其他
alter table u_tag_13 add column t_u_product_pref_21 int(5) default 0 comment '产品偏好其他';

update u_tag_13
set t_u_product_pref_21 = 1
where t_u_product_pref_0 = 0 and t_u_product_pref_1 = 0 and t_u_product_pref_2 = 0 and t_u_product_pref_3 = 0 and t_u_product_pref_4 = 0 and t_u_product_pref_5 = 0 and t_u_product_pref_6 = 0 and t_u_product_pref_7 = 0 and t_u_product_pref_8 = 0 and t_u_product_pref_9 = 0 and t_u_product_pref_10 = 0 and t_u_product_pref_11 = 0 and t_u_product_pref_12 = 0 and t_u_product_pref_13 = 0 and t_u_product_pref_14 = 0 and t_u_product_pref_15 = 0 and t_u_product_pref_16 = 0 and t_u_product_pref_17 = 0 and t_u_product_pref_18 = 0 and t_u_product_pref_19 = 0 and t_u_product_pref_20 = 0;


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

-- b_006_tag_type1_2_where
-- 复购率最高产品-补水
alter table u_tag_13 add column t_u_prefer_product_1 int(5) default 0 comment '复购率最高产品-补水';

update u_tag_13 t left join t_re_order_max b 
on t.phone = b.phone
set t.t_u_prefer_product_1 = 1
where b.product_cat = '补水';

-- b_006_tag_type1_2_where
-- 复购率最高产品-保湿
alter table u_tag_13 add column t_u_prefer_product_2 int(5) default 0 comment '复购率最高产品-保湿';

update u_tag_13 t left join t_re_order_max b 
on t.phone = b.phone
set t.t_u_prefer_product_2 = 1
where b.product_cat = '保湿';

-- b_006_tag_type1_2_where
-- 复购率最高产品-眼霜
alter table u_tag_13 add column t_u_prefer_product_3 int(5) default 0 comment '复购率最高产品-眼霜';

update u_tag_13 t left join t_re_order_max b 
on t.phone = b.phone
set t.t_u_prefer_product_3 = 1
where b.product_cat = '眼霜';

-- b_006_tag_type1_2_where
-- 复购率最高产品-倍润霜
alter table u_tag_13 add column t_u_prefer_product_4 int(5) default 0 comment '复购率最高产品-倍润霜';

update u_tag_13 t left join t_re_order_max b 
on t.phone = b.phone
set t.t_u_prefer_product_4 = 1
where b.product_cat = '倍润霜';

-- b_006_tag_type1_2_where
-- 复购率最高产品-隔离霜
alter table u_tag_13 add column t_u_prefer_product_5 int(5) default 0 comment '复购率最高产品-隔离霜';

update u_tag_13 t left join t_re_order_max b 
on t.phone = b.phone
set t.t_u_prefer_product_5 = 1
where b.product_cat = '隔离霜';

-- b_006_tag_type1_2_where
-- 复购率最高产品-面膜
alter table u_tag_13 add column t_u_prefer_product_6 int(5) default 0 comment '复购率最高产品-面膜';

update u_tag_13 t left join t_re_order_max b 
on t.phone = b.phone
set t.t_u_prefer_product_6 = 1
where b.product_cat = '面膜';

-- b_006_tag_type1_2_where
-- 复购率最高产品-眼膜
alter table u_tag_13 add column t_u_prefer_product_7 int(5) default 0 comment '复购率最高产品-眼膜';

update u_tag_13 t left join t_re_order_max b 
on t.phone = b.phone
set t.t_u_prefer_product_7 = 1
where b.product_cat = '眼膜';

-- b_006_tag_type1_2_where
-- 复购率最高产品-精华液
alter table u_tag_13 add column t_u_prefer_product_8 int(5) default 0 comment '复购率最高产品-精华液';

update u_tag_13 t left join t_re_order_max b 
on t.phone = b.phone
set t.t_u_prefer_product_8 = 1
where b.product_cat = '精华液';

-- b_006_tag_type1_2_where
-- 复购率最高产品-精纯液
alter table u_tag_13 add column t_u_prefer_product_9 int(5) default 0 comment '复购率最高产品-精纯液';

update u_tag_13 t left join t_re_order_max b 
on t.phone = b.phone
set t.t_u_prefer_product_9 = 1
where b.product_cat = '精纯液';

-- b_005_tag_type1_one_where
-- 复购率最高产品-无复购
alter table u_tag_13 add column t_u_prefer_product_0 int(5) default 0 comment '复购率最高产品-无复购';

update u_tag_13
set t_u_prefer_product_0 = 1
where t_u_prefer_product_1 = 0 and t_u_prefer_product_2 = 0 and t_u_prefer_product_3 = 0 and t_u_prefer_product_4 = 0 and t_u_prefer_product_5 = 0 and t_u_prefer_product_6 = 0 and t_u_prefer_product_7 = 0 and t_u_prefer_product_8 = 0 and t_u_prefer_product_9 = 0;

-- ----------------------------------
--            下载表生成
-- ----------------------------------
-- b_007_dld
-- 年龄
alter table u_dld_13 add column t_u_age varchar(200) default null comment '年龄';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_age' and t.t_u_age = v.match_val
set d.t_u_age = v.value_name;

-- 地址
alter table u_dld_13 add column t_u_address varchar(200) default null comment '地址';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_address' and t.t_u_address = v.match_val
set d.t_u_address = v.value_name;

-- 客户属性
alter table u_dld_13 add column t_u_ctype varchar(200) default null comment '客户属性';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ctype' and t.t_u_ctype = v.match_val
set d.t_u_ctype = v.value_name;

-- 是否高价值客户
alter table u_dld_13 add column t_u_valuable varchar(200) default null comment '是否高价值客户';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_valuable' and t.t_u_valuable = v.match_val
set d.t_u_valuable = v.value_name;

-- 近一年下单频率
alter table u_dld_13 add column t_u_year_frequency varchar(200) default null comment '近一年下单频率';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_year_frequency' and t.t_u_year_frequency = v.match_val
set d.t_u_year_frequency = v.value_name;

-- 总下单次数
alter table u_dld_13 add column t_u_total_order varchar(200) default null comment '总下单次数';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_total_order' and t.t_u_total_order = v.match_val
set d.t_u_total_order = v.value_name;

-- 消费金额总和
alter table u_dld_13 add column t_u_total_cost varchar(200) default null comment '消费金额总和';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_total_cost' and t.t_u_total_cost = v.match_val
set d.t_u_total_cost = v.value_name;

-- 客单价
alter table u_dld_13 add column t_u_pct varchar(200) default null comment '客单价';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_pct' and t.t_u_pct = v.match_val
set d.t_u_pct = v.value_name;

-- 拒收次数
alter table u_dld_13 add column t_u_reject varchar(200) default null comment '拒收次数';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_reject' and t.t_u_reject = v.match_val
set d.t_u_reject = v.value_name;

-- 退换货次数
alter table u_dld_13 add column t_u_return varchar(200) default null comment '退换货次数';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_return' and t.t_u_return = v.match_val
set d.t_u_return = v.value_name;

-- 复购率最高产品
alter table u_dld_13 add column t_u_prefer_product varchar(200) default null comment '复购率最高产品';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_prefer_product_0' and t.t_u_prefer_product_0 = v.match_val
set d.t_u_prefer_product = 
case
when d.t_u_prefer_product is null then v.value_name
else concat(d.t_u_prefer_product, ',', v.value_name) end
where t.t_u_prefer_product_0 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_prefer_product_1' and t.t_u_prefer_product_1 = v.match_val
set d.t_u_prefer_product = 
case
when d.t_u_prefer_product is null then v.value_name
else concat(d.t_u_prefer_product, ',', v.value_name) end
where t.t_u_prefer_product_1 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_prefer_product_2' and t.t_u_prefer_product_2 = v.match_val
set d.t_u_prefer_product = 
case
when d.t_u_prefer_product is null then v.value_name
else concat(d.t_u_prefer_product, ',', v.value_name) end
where t.t_u_prefer_product_2 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_prefer_product_3' and t.t_u_prefer_product_3 = v.match_val
set d.t_u_prefer_product = 
case
when d.t_u_prefer_product is null then v.value_name
else concat(d.t_u_prefer_product, ',', v.value_name) end
where t.t_u_prefer_product_3 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_prefer_product_4' and t.t_u_prefer_product_4 = v.match_val
set d.t_u_prefer_product = 
case
when d.t_u_prefer_product is null then v.value_name
else concat(d.t_u_prefer_product, ',', v.value_name) end
where t.t_u_prefer_product_4 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_prefer_product_5' and t.t_u_prefer_product_5 = v.match_val
set d.t_u_prefer_product = 
case
when d.t_u_prefer_product is null then v.value_name
else concat(d.t_u_prefer_product, ',', v.value_name) end
where t.t_u_prefer_product_5 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_prefer_product_6' and t.t_u_prefer_product_6 = v.match_val
set d.t_u_prefer_product = 
case
when d.t_u_prefer_product is null then v.value_name
else concat(d.t_u_prefer_product, ',', v.value_name) end
where t.t_u_prefer_product_6 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_prefer_product_7' and t.t_u_prefer_product_7 = v.match_val
set d.t_u_prefer_product = 
case
when d.t_u_prefer_product is null then v.value_name
else concat(d.t_u_prefer_product, ',', v.value_name) end
where t.t_u_prefer_product_7 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_prefer_product_8' and t.t_u_prefer_product_8 = v.match_val
set d.t_u_prefer_product = 
case
when d.t_u_prefer_product is null then v.value_name
else concat(d.t_u_prefer_product, ',', v.value_name) end
where t.t_u_prefer_product_8 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_prefer_product_9' and t.t_u_prefer_product_9 = v.match_val
set d.t_u_prefer_product = 
case
when d.t_u_prefer_product is null then v.value_name
else concat(d.t_u_prefer_product, ',', v.value_name) end
where t.t_u_prefer_product_9 = 1;

-- 洗面类复购次数
alter table u_dld_13 add column t_u_order_xm varchar(200) default null comment '洗面类复购次数';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_xm' and t.t_u_order_xm = v.match_val
set d.t_u_order_xm = v.value_name;

-- 倍润霜复购次数
alter table u_dld_13 add column t_u_order_brs varchar(200) default null comment '倍润霜复购次数';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_brs' and t.t_u_order_brs = v.match_val
set d.t_u_order_brs = v.value_name;

-- 面膜类复购次数
alter table u_dld_13 add column t_u_order_mm varchar(200) default null comment '面膜类复购次数';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_mm' and t.t_u_order_mm = v.match_val
set d.t_u_order_mm = v.value_name;

-- 喷雾类复购次数
alter table u_dld_13 add column t_u_order_pw varchar(200) default null comment '喷雾类复购次数';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_pw' and t.t_u_order_pw = v.match_val
set d.t_u_order_pw = v.value_name;

-- 精华类复购次数
alter table u_dld_13 add column t_u_order_jh varchar(200) default null comment '精华类复购次数';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_jh' and t.t_u_order_jh = v.match_val
set d.t_u_order_jh = v.value_name;

-- 精油类复购次数
alter table u_dld_13 add column t_u_order_jy varchar(200) default null comment '精油类复购次数';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_jy' and t.t_u_order_jy = v.match_val
set d.t_u_order_jy = v.value_name;

-- 养发类复购次数
alter table u_dld_13 add column t_u_order_yf varchar(200) default null comment '养发类复购次数';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_order_yf' and t.t_u_order_yf = v.match_val
set d.t_u_order_yf = v.value_name;

-- 物流偏好
alter table u_dld_13 add column t_u_ex_pref varchar(200) default null comment '物流偏好';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ex_pref_0' and t.t_u_ex_pref_0 = v.match_val
set d.t_u_ex_pref = 
case
when d.t_u_ex_pref is null then v.value_name
else concat(d.t_u_ex_pref, ',', v.value_name) end
where t.t_u_ex_pref_0 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ex_pref_1' and t.t_u_ex_pref_1 = v.match_val
set d.t_u_ex_pref = 
case
when d.t_u_ex_pref is null then v.value_name
else concat(d.t_u_ex_pref, ',', v.value_name) end
where t.t_u_ex_pref_1 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ex_pref_2' and t.t_u_ex_pref_2 = v.match_val
set d.t_u_ex_pref = 
case
when d.t_u_ex_pref is null then v.value_name
else concat(d.t_u_ex_pref, ',', v.value_name) end
where t.t_u_ex_pref_2 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ex_pref_3' and t.t_u_ex_pref_3 = v.match_val
set d.t_u_ex_pref = 
case
when d.t_u_ex_pref is null then v.value_name
else concat(d.t_u_ex_pref, ',', v.value_name) end
where t.t_u_ex_pref_3 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ex_pref_4' and t.t_u_ex_pref_4 = v.match_val
set d.t_u_ex_pref = 
case
when d.t_u_ex_pref is null then v.value_name
else concat(d.t_u_ex_pref, ',', v.value_name) end
where t.t_u_ex_pref_4 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ex_pref_5' and t.t_u_ex_pref_5 = v.match_val
set d.t_u_ex_pref = 
case
when d.t_u_ex_pref is null then v.value_name
else concat(d.t_u_ex_pref, ',', v.value_name) end
where t.t_u_ex_pref_5 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ex_pref_6' and t.t_u_ex_pref_6 = v.match_val
set d.t_u_ex_pref = 
case
when d.t_u_ex_pref is null then v.value_name
else concat(d.t_u_ex_pref, ',', v.value_name) end
where t.t_u_ex_pref_6 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ex_pref_7' and t.t_u_ex_pref_7 = v.match_val
set d.t_u_ex_pref = 
case
when d.t_u_ex_pref is null then v.value_name
else concat(d.t_u_ex_pref, ',', v.value_name) end
where t.t_u_ex_pref_7 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ex_pref_8' and t.t_u_ex_pref_8 = v.match_val
set d.t_u_ex_pref = 
case
when d.t_u_ex_pref is null then v.value_name
else concat(d.t_u_ex_pref, ',', v.value_name) end
where t.t_u_ex_pref_8 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ex_pref_9' and t.t_u_ex_pref_9 = v.match_val
set d.t_u_ex_pref = 
case
when d.t_u_ex_pref is null then v.value_name
else concat(d.t_u_ex_pref, ',', v.value_name) end
where t.t_u_ex_pref_9 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ex_pref_10' and t.t_u_ex_pref_10 = v.match_val
set d.t_u_ex_pref = 
case
when d.t_u_ex_pref is null then v.value_name
else concat(d.t_u_ex_pref, ',', v.value_name) end
where t.t_u_ex_pref_10 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_ex_pref_11' and t.t_u_ex_pref_11 = v.match_val
set d.t_u_ex_pref = 
case
when d.t_u_ex_pref is null then v.value_name
else concat(d.t_u_ex_pref, ',', v.value_name) end
where t.t_u_ex_pref_11 = 1;

-- 支付偏好
alter table u_dld_13 add column t_u_pay_pref varchar(200) default null comment '支付偏好';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_pay_pref_0' and t.t_u_pay_pref_0 = v.match_val
set d.t_u_pay_pref = 
case
when d.t_u_pay_pref is null then v.value_name
else concat(d.t_u_pay_pref, ',', v.value_name) end
where t.t_u_pay_pref_0 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_pay_pref_1' and t.t_u_pay_pref_1 = v.match_val
set d.t_u_pay_pref = 
case
when d.t_u_pay_pref is null then v.value_name
else concat(d.t_u_pay_pref, ',', v.value_name) end
where t.t_u_pay_pref_1 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_pay_pref_2' and t.t_u_pay_pref_2 = v.match_val
set d.t_u_pay_pref = 
case
when d.t_u_pay_pref is null then v.value_name
else concat(d.t_u_pay_pref, ',', v.value_name) end
where t.t_u_pay_pref_2 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_pay_pref_3' and t.t_u_pay_pref_3 = v.match_val
set d.t_u_pay_pref = 
case
when d.t_u_pay_pref is null then v.value_name
else concat(d.t_u_pay_pref, ',', v.value_name) end
where t.t_u_pay_pref_3 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_pay_pref_4' and t.t_u_pay_pref_4 = v.match_val
set d.t_u_pay_pref = 
case
when d.t_u_pay_pref is null then v.value_name
else concat(d.t_u_pay_pref, ',', v.value_name) end
where t.t_u_pay_pref_4 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_pay_pref_5' and t.t_u_pay_pref_5 = v.match_val
set d.t_u_pay_pref = 
case
when d.t_u_pay_pref is null then v.value_name
else concat(d.t_u_pay_pref, ',', v.value_name) end
where t.t_u_pay_pref_5 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_pay_pref_6' and t.t_u_pay_pref_6 = v.match_val
set d.t_u_pay_pref = 
case
when d.t_u_pay_pref is null then v.value_name
else concat(d.t_u_pay_pref, ',', v.value_name) end
where t.t_u_pay_pref_6 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_pay_pref_7' and t.t_u_pay_pref_7 = v.match_val
set d.t_u_pay_pref = 
case
when d.t_u_pay_pref is null then v.value_name
else concat(d.t_u_pay_pref, ',', v.value_name) end
where t.t_u_pay_pref_7 = 1;

-- 产品偏好
alter table u_dld_13 add column t_u_product_pref varchar(200) default null comment '产品偏好';

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_0' and t.t_u_product_pref_0 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_0 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_1' and t.t_u_product_pref_1 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_1 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_2' and t.t_u_product_pref_2 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_2 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_3' and t.t_u_product_pref_3 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_3 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_4' and t.t_u_product_pref_4 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_4 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_5' and t.t_u_product_pref_5 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_5 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_6' and t.t_u_product_pref_6 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_6 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_7' and t.t_u_product_pref_7 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_7 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_8' and t.t_u_product_pref_8 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_8 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_9' and t.t_u_product_pref_9 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_9 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_10' and t.t_u_product_pref_10 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_10 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_11' and t.t_u_product_pref_11 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_11 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_12' and t.t_u_product_pref_12 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_12 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_13' and t.t_u_product_pref_13 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_13 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_14' and t.t_u_product_pref_14 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_14 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_15' and t.t_u_product_pref_15 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_15 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_16' and t.t_u_product_pref_16 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_16 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_17' and t.t_u_product_pref_17 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_17 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_18' and t.t_u_product_pref_18 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_18 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_19' and t.t_u_product_pref_19 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_19 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_20' and t.t_u_product_pref_20 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_20 = 1;

update u_dld_13 d left join u_tag_13 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_product_pref_21' and t.t_u_product_pref_21 = v.match_val
set d.t_u_product_pref = 
case
when d.t_u_product_pref is null then v.value_name
else concat(d.t_u_product_pref, ',', v.value_name) end
where t.t_u_product_pref_21 = 1;

-- dld表敏感信息掩码
alter table u_dld_13 add column t_u_cname_x varchar(100) default 0 comment '掩码后姓名';
alter table u_dld_13 add column t_u_phone_x varchar(32) default 0 comment '掩码后电话';

update u_dld_13 set t_u_cname_x = (CONCAT(SUBSTR(cname,1,1),'**'));
update u_dld_13 set t_u_phone_x = (CONCAT(SUBSTR(phone,1,3),'****',SUBSTR(phone,8,4)));



