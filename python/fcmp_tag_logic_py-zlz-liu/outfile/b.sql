-- b_3001_mid_type2_basic
-- 过程值：拒收次数
alter table u_mid_13 add column reject_value int(5) default 0 comment '过程值：拒收次数';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.comment like '%拒收%'
group by u_mid_13.id
) y on x.id = y.id 
set reject_value = y.c;

-- b_1101_tag_type1_case_between
-- 拒收次数
alter table u_tag_13 add column t_u_reject int(5) default 0 comment '拒收次数';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_reject = 
case
when u_mid_13.reject_value <= 0 then 0
when u_mid_13.reject_value >= 1 and u_mid_13.reject_value <= 1 then 1
when u_mid_13.reject_value >= 2 and u_mid_13.reject_value <= 2 then 2
when u_mid_13.reject_value >= 3 and u_mid_13.reject_value <= 3 then 3
when u_mid_13.reject_value >= 4 and u_mid_13.reject_value <= 4 then 4
when u_mid_13.reject_value >= 5 and u_mid_13.reject_value <= 5 then 5
when u_mid_13.reject_value >= 6 and u_mid_13.reject_value <= 10 then 6
when u_mid_13.reject_value >= 11 then 7
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：退换货次数
alter table u_mid_13 add column return_value int(5) default 0 comment '过程值：退换货次数';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.order_status = '已退货'
group by u_mid_13.id
) y on x.id = y.id 
set return_value = y.c;

-- b_1101_tag_type1_case_between
-- 退换货次数
alter table u_tag_13 add column t_u_return int(5) default 0 comment '退换货次数';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_return = 
case
when u_mid_13.return_value <= 0 then 0
when u_mid_13.return_value >= 1 and u_mid_13.return_value <= 1 then 1
when u_mid_13.return_value >= 2 and u_mid_13.return_value <= 2 then 2
when u_mid_13.return_value >= 3 and u_mid_13.return_value <= 3 then 3
when u_mid_13.return_value >= 4 and u_mid_13.return_value <= 4 then 4
when u_mid_13.return_value >= 5 and u_mid_13.return_value <= 5 then 5
when u_mid_13.return_value >= 6 and u_mid_13.return_value <= 10 then 6
when u_mid_13.return_value >= 11 then 7
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：洗面类复购次数
alter table u_mid_13 add column order_xm_value int(5) default 0 comment '过程值：洗面类复购次数';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%祛痘%' or order_list.goods_name_strs like '%粉刺调理%' or order_list.goods_name_strs like '%洁面%'
group by u_mid_13.id
) y on x.id = y.id 
set order_xm_value = y.c;

-- b_1101_tag_type1_case_between
-- 洗面类复购次数
alter table u_tag_13 add column t_u_order_xm int(5) default 0 comment '洗面类复购次数';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_order_xm = 
case
when u_mid_13.order_xm_value <= 1 then 0
when u_mid_13.order_xm_value >= 2 and u_mid_13.order_xm_value <= 2 then 1
when u_mid_13.order_xm_value >= 3 and u_mid_13.order_xm_value <= 3 then 2
when u_mid_13.order_xm_value >= 4 and u_mid_13.order_xm_value <= 4 then 3
when u_mid_13.order_xm_value >= 5 and u_mid_13.order_xm_value <= 5 then 4
when u_mid_13.order_xm_value >= 6 and u_mid_13.order_xm_value <= 6 then 5
when u_mid_13.order_xm_value >= 7 and u_mid_13.order_xm_value <= 7 then 6
when u_mid_13.order_xm_value >= 8 and u_mid_13.order_xm_value <= 8 then 7
when u_mid_13.order_xm_value >= 9 and u_mid_13.order_xm_value <= 9 then 8
when u_mid_13.order_xm_value >= 10 and u_mid_13.order_xm_value <= 10 then 9
when u_mid_13.order_xm_value >= 11 and u_mid_13.order_xm_value <= 11 then 10
when u_mid_13.order_xm_value >= 12 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：倍润霜复购次数
alter table u_mid_13 add column order_brs_value int(5) default 0 comment '过程值：倍润霜复购次数';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%倍润霜%'
group by u_mid_13.id
) y on x.id = y.id 
set order_brs_value = y.c;

-- b_1101_tag_type1_case_between
-- 倍润霜复购次数
alter table u_tag_13 add column t_u_order_brs int(5) default 0 comment '倍润霜复购次数';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_order_brs = 
case
when u_mid_13.order_brs_value <= 1 then 0
when u_mid_13.order_brs_value >= 2 and u_mid_13.order_brs_value <= 2 then 1
when u_mid_13.order_brs_value >= 3 and u_mid_13.order_brs_value <= 3 then 2
when u_mid_13.order_brs_value >= 4 and u_mid_13.order_brs_value <= 4 then 3
when u_mid_13.order_brs_value >= 5 and u_mid_13.order_brs_value <= 5 then 4
when u_mid_13.order_brs_value >= 6 and u_mid_13.order_brs_value <= 6 then 5
when u_mid_13.order_brs_value >= 7 and u_mid_13.order_brs_value <= 7 then 6
when u_mid_13.order_brs_value >= 8 and u_mid_13.order_brs_value <= 8 then 7
when u_mid_13.order_brs_value >= 9 and u_mid_13.order_brs_value <= 9 then 8
when u_mid_13.order_brs_value >= 10 and u_mid_13.order_brs_value <= 10 then 9
when u_mid_13.order_brs_value >= 11 and u_mid_13.order_brs_value <= 11 then 10
when u_mid_13.order_brs_value >= 12 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：面膜类复购次数
alter table u_mid_13 add column order_mm_value int(5) default 0 comment '过程值：面膜类复购次数';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%面膜%' or order_list.goods_name_strs like '%眼膜%' or order_list.goods_name_strs like '%U膜%' or order_list.goods_name_strs like '%冰膜%'
group by u_mid_13.id
) y on x.id = y.id 
set order_mm_value = y.c;

-- b_1101_tag_type1_case_between
-- 面膜类复购次数
alter table u_tag_13 add column t_u_order_mm int(5) default 0 comment '面膜类复购次数';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_order_mm = 
case
when u_mid_13.order_mm_value <= 1 then 0
when u_mid_13.order_mm_value >= 2 and u_mid_13.order_mm_value <= 2 then 1
when u_mid_13.order_mm_value >= 3 and u_mid_13.order_mm_value <= 3 then 2
when u_mid_13.order_mm_value >= 4 and u_mid_13.order_mm_value <= 4 then 3
when u_mid_13.order_mm_value >= 5 and u_mid_13.order_mm_value <= 5 then 4
when u_mid_13.order_mm_value >= 6 and u_mid_13.order_mm_value <= 6 then 5
when u_mid_13.order_mm_value >= 7 and u_mid_13.order_mm_value <= 7 then 6
when u_mid_13.order_mm_value >= 8 and u_mid_13.order_mm_value <= 8 then 7
when u_mid_13.order_mm_value >= 9 and u_mid_13.order_mm_value <= 9 then 8
when u_mid_13.order_mm_value >= 10 and u_mid_13.order_mm_value <= 10 then 9
when u_mid_13.order_mm_value >= 11 and u_mid_13.order_mm_value <= 11 then 10
when u_mid_13.order_mm_value >= 12 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：喷雾类复购次数
alter table u_mid_13 add column order_pw_value int(5) default 0 comment '过程值：喷雾类复购次数';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%喷雾%'
group by u_mid_13.id
) y on x.id = y.id 
set order_pw_value = y.c;

-- b_1101_tag_type1_case_between
-- 喷雾类复购次数
alter table u_tag_13 add column t_u_order_pw int(5) default 0 comment '喷雾类复购次数';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_order_pw = 
case
when u_mid_13.order_pw_value <= 1 then 0
when u_mid_13.order_pw_value >= 2 and u_mid_13.order_pw_value <= 2 then 1
when u_mid_13.order_pw_value >= 3 and u_mid_13.order_pw_value <= 3 then 2
when u_mid_13.order_pw_value >= 4 and u_mid_13.order_pw_value <= 4 then 3
when u_mid_13.order_pw_value >= 5 and u_mid_13.order_pw_value <= 5 then 4
when u_mid_13.order_pw_value >= 6 and u_mid_13.order_pw_value <= 6 then 5
when u_mid_13.order_pw_value >= 7 and u_mid_13.order_pw_value <= 7 then 6
when u_mid_13.order_pw_value >= 8 and u_mid_13.order_pw_value <= 8 then 7
when u_mid_13.order_pw_value >= 9 and u_mid_13.order_pw_value <= 9 then 8
when u_mid_13.order_pw_value >= 10 and u_mid_13.order_pw_value <= 10 then 9
when u_mid_13.order_pw_value >= 11 and u_mid_13.order_pw_value <= 11 then 10
when u_mid_13.order_pw_value >= 12 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：精华类复购次数
alter table u_mid_13 add column order_jh_value int(5) default 0 comment '过程值：精华类复购次数';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%精华液%' or order_list.goods_name_strs like '%精纯液%' or order_list.goods_name_strs like '%冻干粉%'
group by u_mid_13.id
) y on x.id = y.id 
set order_jh_value = y.c;

-- b_1101_tag_type1_case_between
-- 精华类复购次数
alter table u_tag_13 add column t_u_order_jh int(5) default 0 comment '精华类复购次数';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_order_jh = 
case
when u_mid_13.order_jh_value <= 1 then 0
when u_mid_13.order_jh_value >= 2 and u_mid_13.order_jh_value <= 2 then 1
when u_mid_13.order_jh_value >= 3 and u_mid_13.order_jh_value <= 3 then 2
when u_mid_13.order_jh_value >= 4 and u_mid_13.order_jh_value <= 4 then 3
when u_mid_13.order_jh_value >= 5 and u_mid_13.order_jh_value <= 5 then 4
when u_mid_13.order_jh_value >= 6 and u_mid_13.order_jh_value <= 6 then 5
when u_mid_13.order_jh_value >= 7 and u_mid_13.order_jh_value <= 7 then 6
when u_mid_13.order_jh_value >= 8 and u_mid_13.order_jh_value <= 8 then 7
when u_mid_13.order_jh_value >= 9 and u_mid_13.order_jh_value <= 9 then 8
when u_mid_13.order_jh_value >= 10 and u_mid_13.order_jh_value <= 10 then 9
when u_mid_13.order_jh_value >= 11 and u_mid_13.order_jh_value <= 11 then 10
when u_mid_13.order_jh_value >= 12 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：精油类复购次数
alter table u_mid_13 add column order_jy_value int(5) default 0 comment '过程值：精油类复购次数';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%精油%'
group by u_mid_13.id
) y on x.id = y.id 
set order_jy_value = y.c;

-- b_1101_tag_type1_case_between
-- 精油类复购次数
alter table u_tag_13 add column t_u_order_jy int(5) default 0 comment '精油类复购次数';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_order_jy = 
case
when u_mid_13.order_jy_value <= 1 then 0
when u_mid_13.order_jy_value >= 2 and u_mid_13.order_jy_value <= 2 then 1
when u_mid_13.order_jy_value >= 3 and u_mid_13.order_jy_value <= 3 then 2
when u_mid_13.order_jy_value >= 4 and u_mid_13.order_jy_value <= 4 then 3
when u_mid_13.order_jy_value >= 5 and u_mid_13.order_jy_value <= 5 then 4
when u_mid_13.order_jy_value >= 6 and u_mid_13.order_jy_value <= 6 then 5
when u_mid_13.order_jy_value >= 7 and u_mid_13.order_jy_value <= 7 then 6
when u_mid_13.order_jy_value >= 8 and u_mid_13.order_jy_value <= 8 then 7
when u_mid_13.order_jy_value >= 9 and u_mid_13.order_jy_value <= 9 then 8
when u_mid_13.order_jy_value >= 10 and u_mid_13.order_jy_value <= 10 then 9
when u_mid_13.order_jy_value >= 11 and u_mid_13.order_jy_value <= 11 then 10
when u_mid_13.order_jy_value >= 12 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：养发类复购次数
alter table u_mid_13 add column order_yf_value int(5) default 0 comment '过程值：养发类复购次数';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%育发%' or order_list.goods_name_strs like '%固发%'
group by u_mid_13.id
) y on x.id = y.id 
set order_yf_value = y.c;

-- b_1101_tag_type1_case_between
-- 养发类复购次数
alter table u_tag_13 add column t_u_order_yf int(5) default 0 comment '养发类复购次数';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_order_yf = 
case
when u_mid_13.order_yf_value <= 1 then 0
when u_mid_13.order_yf_value >= 2 and u_mid_13.order_yf_value <= 2 then 1
when u_mid_13.order_yf_value >= 3 and u_mid_13.order_yf_value <= 3 then 2
when u_mid_13.order_yf_value >= 4 and u_mid_13.order_yf_value <= 4 then 3
when u_mid_13.order_yf_value >= 5 and u_mid_13.order_yf_value <= 5 then 4
when u_mid_13.order_yf_value >= 6 and u_mid_13.order_yf_value <= 6 then 5
when u_mid_13.order_yf_value >= 7 and u_mid_13.order_yf_value <= 7 then 6
when u_mid_13.order_yf_value >= 8 and u_mid_13.order_yf_value <= 8 then 7
when u_mid_13.order_yf_value >= 9 and u_mid_13.order_yf_value <= 9 then 8
when u_mid_13.order_yf_value >= 10 and u_mid_13.order_yf_value <= 10 then 9
when u_mid_13.order_yf_value >= 11 and u_mid_13.order_yf_value <= 11 then 10
when u_mid_13.order_yf_value >= 12 then 11
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：物流偏好-EMS
alter table u_mid_13 add column ex_pref_1_value int(5) default 0 comment '过程值：物流偏好-EMS';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.express_company like '%EMS%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set ex_pref_1_value = y.c;

-- b_1101_tag_type1_case_between
-- 物流偏好-EMS
alter table u_tag_13 add column t_u_ex_pref_1 int(5) default 0 comment '物流偏好-EMS';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ex_pref_1 = 
case
when u_mid_13.ex_pref_1_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：物流偏好-黑猫
alter table u_mid_13 add column ex_pref_2_value int(5) default 0 comment '过程值：物流偏好-黑猫';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.express_company like '%黑猫%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set ex_pref_2_value = y.c;

-- b_1101_tag_type1_case_between
-- 物流偏好-黑猫
alter table u_tag_13 add column t_u_ex_pref_2 int(5) default 0 comment '物流偏好-黑猫';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ex_pref_2 = 
case
when u_mid_13.ex_pref_2_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：物流偏好-顺丰
alter table u_mid_13 add column ex_pref_3_value int(5) default 0 comment '过程值：物流偏好-顺丰';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.express_company like '%顺丰%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set ex_pref_3_value = y.c;

-- b_1101_tag_type1_case_between
-- 物流偏好-顺丰
alter table u_tag_13 add column t_u_ex_pref_3 int(5) default 0 comment '物流偏好-顺丰';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ex_pref_3 = 
case
when u_mid_13.ex_pref_3_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：物流偏好-天天
alter table u_mid_13 add column ex_pref_4_value int(5) default 0 comment '过程值：物流偏好-天天';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.express_company like '%天天%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set ex_pref_4_value = y.c;

-- b_1101_tag_type1_case_between
-- 物流偏好-天天
alter table u_tag_13 add column t_u_ex_pref_4 int(5) default 0 comment '物流偏好-天天';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ex_pref_4 = 
case
when u_mid_13.ex_pref_4_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：物流偏好-圆通
alter table u_mid_13 add column ex_pref_5_value int(5) default 0 comment '过程值：物流偏好-圆通';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.express_company like '%圆通%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set ex_pref_5_value = y.c;

-- b_1101_tag_type1_case_between
-- 物流偏好-圆通
alter table u_tag_13 add column t_u_ex_pref_5 int(5) default 0 comment '物流偏好-圆通';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ex_pref_5 = 
case
when u_mid_13.ex_pref_5_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：物流偏好-申通
alter table u_mid_13 add column ex_pref_6_value int(5) default 0 comment '过程值：物流偏好-申通';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.express_company like '%申通%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set ex_pref_6_value = y.c;

-- b_1101_tag_type1_case_between
-- 物流偏好-申通
alter table u_tag_13 add column t_u_ex_pref_6 int(5) default 0 comment '物流偏好-申通';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ex_pref_6 = 
case
when u_mid_13.ex_pref_6_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：物流偏好-中通
alter table u_mid_13 add column ex_pref_7_value int(5) default 0 comment '过程值：物流偏好-中通';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.express_company like '%中通%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set ex_pref_7_value = y.c;

-- b_1101_tag_type1_case_between
-- 物流偏好-中通
alter table u_tag_13 add column t_u_ex_pref_7 int(5) default 0 comment '物流偏好-中通';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ex_pref_7 = 
case
when u_mid_13.ex_pref_7_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：物流偏好-邮政
alter table u_mid_13 add column ex_pref_8_value int(5) default 0 comment '过程值：物流偏好-邮政';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.express_company like '%邮政%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set ex_pref_8_value = y.c;

-- b_1101_tag_type1_case_between
-- 物流偏好-邮政
alter table u_tag_13 add column t_u_ex_pref_8 int(5) default 0 comment '物流偏好-邮政';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ex_pref_8 = 
case
when u_mid_13.ex_pref_8_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：物流偏好-德邦
alter table u_mid_13 add column ex_pref_9_value int(5) default 0 comment '过程值：物流偏好-德邦';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.express_company like '%德邦%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set ex_pref_9_value = y.c;

-- b_1101_tag_type1_case_between
-- 物流偏好-德邦
alter table u_tag_13 add column t_u_ex_pref_9 int(5) default 0 comment '物流偏好-德邦';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ex_pref_9 = 
case
when u_mid_13.ex_pref_9_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：物流偏好-京东
alter table u_mid_13 add column ex_pref_10_value int(5) default 0 comment '过程值：物流偏好-京东';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.express_company like '%京东%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set ex_pref_10_value = y.c;

-- b_1101_tag_type1_case_between
-- 物流偏好-京东
alter table u_tag_13 add column t_u_ex_pref_10 int(5) default 0 comment '物流偏好-京东';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ex_pref_10 = 
case
when u_mid_13.ex_pref_10_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：物流偏好-韵达
alter table u_mid_13 add column ex_pref_11_value int(5) default 0 comment '过程值：物流偏好-韵达';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.express_company like '%韵达%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set ex_pref_11_value = y.c;

-- b_1101_tag_type1_case_between
-- 物流偏好-韵达
alter table u_tag_13 add column t_u_ex_pref_11 int(5) default 0 comment '物流偏好-韵达';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ex_pref_11 = 
case
when u_mid_13.ex_pref_11_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：物流偏好-缺失
alter table u_mid_13 add column ex_pref_0_value int(5) default 0 comment '过程值：物流偏好-缺失';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.express_company is null or order_list.express_company = ''
group by u_mid_13.id
) y on x.id = y.id 
set ex_pref_0_value = y.c;

-- b_1101_tag_type1_case_between
-- 物流偏好-缺失
alter table u_tag_13 add column t_u_ex_pref_0 int(5) default 0 comment '物流偏好-缺失';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ex_pref_0 = 
case
when u_mid_13.ex_pref_0_value >= 1 then 1
else 0 end;

-- b_2001_tag_type1_where
-- 物流偏好-其他
alter table u_tag_13 add column t_u_ex_pref_12 int(5) default 0 comment '物流偏好-其他';

update u_tag_13 
set u_tag_13.t_u_ex_pref_12 = 1
where t_u_ex_pref_0 = 0 and t_u_ex_pref_1 = 0 and t_u_ex_pref_2 = 0 and t_u_ex_pref_3 = 0 and t_u_ex_pref_4 = 0 and t_u_ex_pref_5 = 0 and t_u_ex_pref_6 = 0 and t_u_ex_pref_7 = 0 and t_u_ex_pref_8 = 0 and t_u_ex_pref_9 = 0 and t_u_ex_pref_10 = 0 and t_u_ex_pref_11 = 0;

-- b_3001_mid_type2_basic
-- 过程值：支付偏好-微信支付
alter table u_mid_13 add column pay_pref_1_value int(5) default 0 comment '过程值：支付偏好-微信支付';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.pay_mode like '%微信%' and order_list.pay_mode not like '%预付款%' and order_list.pay_mode not like '%预支付%' and order_list.pay_mode not like '%货到付款%'
group by u_mid_13.id
) y on x.id = y.id 
set pay_pref_1_value = y.c;

-- b_1101_tag_type1_case_between
-- 支付偏好-微信支付
alter table u_tag_13 add column t_u_pay_pref_1 int(5) default 0 comment '支付偏好-微信支付';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_pay_pref_1 = 
case
when u_mid_13.pay_pref_1_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：支付偏好-支付宝支付
alter table u_mid_13 add column pay_pref_2_value int(5) default 0 comment '过程值：支付偏好-支付宝支付';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.pay_mode like '%支付宝%' and order_list.pay_mode not like '%预付款%' and order_list.pay_mode not like '%预支付%' and order_list.pay_mode not like '%货到付款%'
group by u_mid_13.id
) y on x.id = y.id 
set pay_pref_2_value = y.c;

-- b_1101_tag_type1_case_between
-- 支付偏好-支付宝支付
alter table u_tag_13 add column t_u_pay_pref_2 int(5) default 0 comment '支付偏好-支付宝支付';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_pay_pref_2 = 
case
when u_mid_13.pay_pref_2_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：支付偏好-现金支付
alter table u_mid_13 add column pay_pref_3_value int(5) default 0 comment '过程值：支付偏好-现金支付';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.pay_mode like '%现金%' and order_list.pay_mode not like '%货到付款%'
group by u_mid_13.id
) y on x.id = y.id 
set pay_pref_3_value = y.c;

-- b_1101_tag_type1_case_between
-- 支付偏好-现金支付
alter table u_tag_13 add column t_u_pay_pref_3 int(5) default 0 comment '支付偏好-现金支付';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_pay_pref_3 = 
case
when u_mid_13.pay_pref_3_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：支付偏好-银行支付
alter table u_mid_13 add column pay_pref_4_value int(5) default 0 comment '过程值：支付偏好-银行支付';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.pay_mode like '%银行%' and order_list.pay_mode not like '%预付款%' and order_list.pay_mode not like '%预支付%' and order_list.pay_mode not like '%货到付款%'
group by u_mid_13.id
) y on x.id = y.id 
set pay_pref_4_value = y.c;

-- b_1101_tag_type1_case_between
-- 支付偏好-银行支付
alter table u_tag_13 add column t_u_pay_pref_4 int(5) default 0 comment '支付偏好-银行支付';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_pay_pref_4 = 
case
when u_mid_13.pay_pref_4_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：支付偏好-货到付款
alter table u_mid_13 add column pay_pref_5_value int(5) default 0 comment '过程值：支付偏好-货到付款';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.pay_mode like '%货到付款%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set pay_pref_5_value = y.c;

-- b_1101_tag_type1_case_between
-- 支付偏好-货到付款
alter table u_tag_13 add column t_u_pay_pref_5 int(5) default 0 comment '支付偏好-货到付款';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_pay_pref_5 = 
case
when u_mid_13.pay_pref_5_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：支付偏好-微信/支付宝/银行预付款
alter table u_mid_13 add column pay_pref_6_value int(5) default 0 comment '过程值：支付偏好-微信/支付宝/银行预付款';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.pay_mode like '%预付款%' or order_list.pay_mode like '%预支付%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set pay_pref_6_value = y.c;

-- b_1101_tag_type1_case_between
-- 支付偏好-微信/支付宝/银行预付款
alter table u_tag_13 add column t_u_pay_pref_6 int(5) default 0 comment '支付偏好-微信/支付宝/银行预付款';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_pay_pref_6 = 
case
when u_mid_13.pay_pref_6_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：支付偏好-缺失
alter table u_mid_13 add column pay_pref_0_value int(5) default 0 comment '过程值：支付偏好-缺失';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.pay_mode is null or order_list.pay_mode = ''
group by u_mid_13.id
) y on x.id = y.id 
set pay_pref_0_value = y.c;

-- b_1101_tag_type1_case_between
-- 支付偏好-缺失
alter table u_tag_13 add column t_u_pay_pref_0 int(5) default 0 comment '支付偏好-缺失';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_pay_pref_0 = 
case
when u_mid_13.pay_pref_0_value >= 1 then 1
else 0 end;

-- b_2001_tag_type1_where
-- 支付偏好-其他
alter table u_tag_13 add column t_u_pay_pref_7 int(5) default 0 comment '支付偏好-其他';

update u_tag_13 
set u_tag_13.t_u_pay_pref_7 = 1
where t_u_pay_pref_0 = 0 and t_u_pay_pref_1 = 0 and t_u_pay_pref_2 = 0 and t_u_pay_pref_3 = 0 and t_u_pay_pref_4 = 0 and t_u_pay_pref_5 = 0 and t_u_pay_pref_6 = 0;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-补水
alter table u_mid_13 add column product_pref_1_value int(5) default 0 comment '过程值：产品偏好-补水';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%补水%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_1_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-补水
alter table u_tag_13 add column t_u_product_pref_1 int(5) default 0 comment '产品偏好-补水';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_1 = 
case
when u_mid_13.product_pref_1_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-保湿
alter table u_mid_13 add column product_pref_2_value int(5) default 0 comment '过程值：产品偏好-保湿';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%保湿%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_2_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-保湿
alter table u_tag_13 add column t_u_product_pref_2 int(5) default 0 comment '产品偏好-保湿';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_2 = 
case
when u_mid_13.product_pref_2_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-洁面
alter table u_mid_13 add column product_pref_3_value int(5) default 0 comment '过程值：产品偏好-洁面';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%洁面%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_3_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-洁面
alter table u_tag_13 add column t_u_product_pref_3 int(5) default 0 comment '产品偏好-洁面';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_3 = 
case
when u_mid_13.product_pref_3_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-祛痘
alter table u_mid_13 add column product_pref_4_value int(5) default 0 comment '过程值：产品偏好-祛痘';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%祛痘%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_4_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-祛痘
alter table u_tag_13 add column t_u_product_pref_4 int(5) default 0 comment '产品偏好-祛痘';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_4 = 
case
when u_mid_13.product_pref_4_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-喷雾
alter table u_mid_13 add column product_pref_5_value int(5) default 0 comment '过程值：产品偏好-喷雾';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%喷雾%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_5_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-喷雾
alter table u_tag_13 add column t_u_product_pref_5 int(5) default 0 comment '产品偏好-喷雾';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_5 = 
case
when u_mid_13.product_pref_5_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-眼霜
alter table u_mid_13 add column product_pref_6_value int(5) default 0 comment '过程值：产品偏好-眼霜';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%眼霜%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_6_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-眼霜
alter table u_tag_13 add column t_u_product_pref_6 int(5) default 0 comment '产品偏好-眼霜';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_6 = 
case
when u_mid_13.product_pref_6_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-倍润霜
alter table u_mid_13 add column product_pref_7_value int(5) default 0 comment '过程值：产品偏好-倍润霜';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%倍润霜%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_7_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-倍润霜
alter table u_tag_13 add column t_u_product_pref_7 int(5) default 0 comment '产品偏好-倍润霜';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_7 = 
case
when u_mid_13.product_pref_7_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-隔离霜
alter table u_mid_13 add column product_pref_8_value int(5) default 0 comment '过程值：产品偏好-隔离霜';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%隔离霜%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_8_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-隔离霜
alter table u_tag_13 add column t_u_product_pref_8 int(5) default 0 comment '产品偏好-隔离霜';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_8 = 
case
when u_mid_13.product_pref_8_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-面膜
alter table u_mid_13 add column product_pref_9_value int(5) default 0 comment '过程值：产品偏好-面膜';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%面膜%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_9_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-面膜
alter table u_tag_13 add column t_u_product_pref_9 int(5) default 0 comment '产品偏好-面膜';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_9 = 
case
when u_mid_13.product_pref_9_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-眼膜
alter table u_mid_13 add column product_pref_10_value int(5) default 0 comment '过程值：产品偏好-眼膜';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%眼膜%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_10_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-眼膜
alter table u_tag_13 add column t_u_product_pref_10 int(5) default 0 comment '产品偏好-眼膜';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_10 = 
case
when u_mid_13.product_pref_10_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-U膜
alter table u_mid_13 add column product_pref_11_value int(5) default 0 comment '过程值：产品偏好-U膜';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%U膜%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_11_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-U膜
alter table u_tag_13 add column t_u_product_pref_11 int(5) default 0 comment '产品偏好-U膜';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_11 = 
case
when u_mid_13.product_pref_11_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-睡眠冰膜
alter table u_mid_13 add column product_pref_12_value int(5) default 0 comment '过程值：产品偏好-睡眠冰膜';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%睡眠冰膜%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_12_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-睡眠冰膜
alter table u_tag_13 add column t_u_product_pref_12 int(5) default 0 comment '产品偏好-睡眠冰膜';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_12 = 
case
when u_mid_13.product_pref_12_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-精华液
alter table u_mid_13 add column product_pref_13_value int(5) default 0 comment '过程值：产品偏好-精华液';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%精华液%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_13_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-精华液
alter table u_tag_13 add column t_u_product_pref_13 int(5) default 0 comment '产品偏好-精华液';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_13 = 
case
when u_mid_13.product_pref_13_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-精纯液
alter table u_mid_13 add column product_pref_14_value int(5) default 0 comment '过程值：产品偏好-精纯液';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%精纯液%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_14_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-精纯液
alter table u_tag_13 add column t_u_product_pref_14 int(5) default 0 comment '产品偏好-精纯液';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_14 = 
case
when u_mid_13.product_pref_14_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-冻干粉
alter table u_mid_13 add column product_pref_15_value int(5) default 0 comment '过程值：产品偏好-冻干粉';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%冻干粉%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_15_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-冻干粉
alter table u_tag_13 add column t_u_product_pref_15 int(5) default 0 comment '产品偏好-冻干粉';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_15 = 
case
when u_mid_13.product_pref_15_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-雪肤
alter table u_mid_13 add column product_pref_16_value int(5) default 0 comment '过程值：产品偏好-雪肤';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%雪肤%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_16_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-雪肤
alter table u_tag_13 add column t_u_product_pref_16 int(5) default 0 comment '产品偏好-雪肤';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_16 = 
case
when u_mid_13.product_pref_16_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-固发育发
alter table u_mid_13 add column product_pref_17_value int(5) default 0 comment '过程值：产品偏好-固发育发';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%固发%' or order_list.goods_name_strs like '%育发%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_17_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-固发育发
alter table u_tag_13 add column t_u_product_pref_17 int(5) default 0 comment '产品偏好-固发育发';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_17 = 
case
when u_mid_13.product_pref_17_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-细纹修护
alter table u_mid_13 add column product_pref_18_value int(5) default 0 comment '过程值：产品偏好-细纹修护';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%细纹修护%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_18_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-细纹修护
alter table u_tag_13 add column t_u_product_pref_18 int(5) default 0 comment '产品偏好-细纹修护';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_18 = 
case
when u_mid_13.product_pref_18_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-精油
alter table u_mid_13 add column product_pref_19_value int(5) default 0 comment '过程值：产品偏好-精油';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%精油%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_19_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-精油
alter table u_tag_13 add column t_u_product_pref_19 int(5) default 0 comment '产品偏好-精油';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_19 = 
case
when u_mid_13.product_pref_19_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-粉刺调理
alter table u_mid_13 add column product_pref_20_value int(5) default 0 comment '过程值：产品偏好-粉刺调理';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%粉刺调理%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_20_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-粉刺调理
alter table u_tag_13 add column t_u_product_pref_20 int(5) default 0 comment '产品偏好-粉刺调理';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_20 = 
case
when u_mid_13.product_pref_20_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-舒缓
alter table u_mid_13 add column product_pref_21_value int(5) default 0 comment '过程值：产品偏好-舒缓';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs like '%舒缓%' and TRUE
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_21_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-舒缓
alter table u_tag_13 add column t_u_product_pref_21 int(5) default 0 comment '产品偏好-舒缓';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_21 = 
case
when u_mid_13.product_pref_21_value >= 1 then 1
else 0 end;

-- b_3001_mid_type2_basic
-- 过程值：产品偏好-缺失
alter table u_mid_13 add column product_pref_0_value int(5) default 0 comment '过程值：产品偏好-缺失';

update u_mid_13 x inner join (
select u_mid_13.id, count(*) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where order_list.goods_name_strs is null or order_list.goods_name_strs = ''
group by u_mid_13.id
) y on x.id = y.id 
set product_pref_0_value = y.c;

-- b_1101_tag_type1_case_between
-- 产品偏好-缺失
alter table u_tag_13 add column t_u_product_pref_0 int(5) default 0 comment '产品偏好-缺失';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_product_pref_0 = 
case
when u_mid_13.product_pref_0_value >= 1 then 1
else 0 end;

-- b_2001_tag_type1_where
-- 产品偏好-其他
alter table u_tag_13 add column t_u_product_pref_22 int(5) default 0 comment '产品偏好-其他';

update u_tag_13 
set u_tag_13.t_u_product_pref_22 = 1
where t_u_product_pref_0 = 0 and t_u_product_pref_1 = 0 and t_u_product_pref_2 = 0 and t_u_product_pref_3 = 0 and t_u_product_pref_4 = 0 and t_u_product_pref_5 = 0 and t_u_product_pref_6 = 0 and t_u_product_pref_7 = 0 and t_u_product_pref_8 = 0 and t_u_product_pref_9 = 0 and t_u_product_pref_10 = 0 and t_u_product_pref_11 = 0 and t_u_product_pref_12 = 0 and t_u_product_pref_13 = 0 and t_u_product_pref_14 = 0 and t_u_product_pref_15 = 0 and t_u_product_pref_16 = 0 and t_u_product_pref_17 = 0 and t_u_product_pref_18 = 0 and t_u_product_pref_19 = 0 and t_u_product_pref_20 = 0 and t_u_product_pref_21 = 0;

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

-- b_2001_tag_type1_where
-- 复购率最高产品-补水
alter table u_tag_13 add column t_u_prefer_product_1 int(5) default 0 comment '复购率最高产品-补水';

update u_tag_13 
left join t_re_order_max 
on u_tag_13.phone = t_re_order_max.phone
set u_tag_13.t_u_prefer_product_1 = 1
where t_re_order_max.product_cat = '补水';

-- b_2001_tag_type1_where
-- 复购率最高产品-保湿
alter table u_tag_13 add column t_u_prefer_product_2 int(5) default 0 comment '复购率最高产品-保湿';

update u_tag_13 
left join t_re_order_max 
on u_tag_13.phone = t_re_order_max.phone
set u_tag_13.t_u_prefer_product_2 = 1
where t_re_order_max.product_cat = '保湿';

-- b_2001_tag_type1_where
-- 复购率最高产品-眼霜
alter table u_tag_13 add column t_u_prefer_product_3 int(5) default 0 comment '复购率最高产品-眼霜';

update u_tag_13 
left join t_re_order_max 
on u_tag_13.phone = t_re_order_max.phone
set u_tag_13.t_u_prefer_product_3 = 1
where t_re_order_max.product_cat = '眼霜';

-- b_2001_tag_type1_where
-- 复购率最高产品-倍润霜
alter table u_tag_13 add column t_u_prefer_product_4 int(5) default 0 comment '复购率最高产品-倍润霜';

update u_tag_13 
left join t_re_order_max 
on u_tag_13.phone = t_re_order_max.phone
set u_tag_13.t_u_prefer_product_4 = 1
where t_re_order_max.product_cat = '倍润霜';

-- b_2001_tag_type1_where
-- 复购率最高产品-隔离霜
alter table u_tag_13 add column t_u_prefer_product_5 int(5) default 0 comment '复购率最高产品-隔离霜';

update u_tag_13 
left join t_re_order_max 
on u_tag_13.phone = t_re_order_max.phone
set u_tag_13.t_u_prefer_product_5 = 1
where t_re_order_max.product_cat = '隔离霜';

-- b_2001_tag_type1_where
-- 复购率最高产品-面膜
alter table u_tag_13 add column t_u_prefer_product_6 int(5) default 0 comment '复购率最高产品-面膜';

update u_tag_13 
left join t_re_order_max 
on u_tag_13.phone = t_re_order_max.phone
set u_tag_13.t_u_prefer_product_6 = 1
where t_re_order_max.product_cat = '面膜';

-- b_2001_tag_type1_where
-- 复购率最高产品-眼膜
alter table u_tag_13 add column t_u_prefer_product_7 int(5) default 0 comment '复购率最高产品-眼膜';

update u_tag_13 
left join t_re_order_max 
on u_tag_13.phone = t_re_order_max.phone
set u_tag_13.t_u_prefer_product_7 = 1
where t_re_order_max.product_cat = '眼膜';

-- b_2001_tag_type1_where
-- 复购率最高产品-精华液
alter table u_tag_13 add column t_u_prefer_product_8 int(5) default 0 comment '复购率最高产品-精华液';

update u_tag_13 
left join t_re_order_max 
on u_tag_13.phone = t_re_order_max.phone
set u_tag_13.t_u_prefer_product_8 = 1
where t_re_order_max.product_cat = '精华液';

-- b_2001_tag_type1_where
-- 复购率最高产品-精纯液
alter table u_tag_13 add column t_u_prefer_product_9 int(5) default 0 comment '复购率最高产品-精纯液';

update u_tag_13 
left join t_re_order_max 
on u_tag_13.phone = t_re_order_max.phone
set u_tag_13.t_u_prefer_product_9 = 1
where t_re_order_max.product_cat = '精纯液';

-- b_2001_tag_type1_where
-- 复购率最高产品-无复购
alter table u_tag_13 add column t_u_prefer_product_0 int(5) default 0 comment '复购率最高产品-无复购';

update u_tag_13 
set u_tag_13.t_u_prefer_product_0 = 1
where t_u_prefer_product_1 = 0 and t_u_prefer_product_2 = 0 and t_u_prefer_product_3 = 0 and t_u_prefer_product_4 = 0 and t_u_prefer_product_5 = 0 and t_u_prefer_product_6 = 0 and t_u_prefer_product_7 = 0 and t_u_prefer_product_8 = 0 and t_u_prefer_product_9 = 0;
