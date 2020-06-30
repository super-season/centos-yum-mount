-- ----------------------------------
-- 客户19标签逻辑 2019-07-30 10:37:09
-- ----------------------------------
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
t_19_1, t_19_2, t_19_3, t_19_4, if(t_19_5 = '', 0, t_19_5), if(t_19_6 = '', 0, t_19_6), if(t_19_7 = '', null, t_19_7), if(t_19_8 = '', null, t_19_8)
from table_19_20190725;

-- 生成tag表，含必显字段
drop table if exists u_tag_19;
create table u_tag_19 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户标签表'
select 
    customer_list_id, member_name, phone
from 
    customer_list;
    
ALTER TABLE `u_tag_19`
ADD COLUMN `id`  int(11) NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `u_tag_19`
ADD INDEX `index_a` (customer_list_id) ;

-- 生成dld表
drop table if exists u_dld_19;
create table u_dld_19 like  u_tag_19;
insert into u_dld_19 select * from u_tag_19;

ALTER TABLE `u_dld_19`
COMMENT='用户下载表';

-- 生成mid表
drop table if exists u_mid_19;
create table u_mid_19 like  u_tag_19;
insert into u_mid_19 select * from u_tag_19;

ALTER TABLE `u_mid_19`
COMMENT='用户中间值表';

-- ----------------------------------
--            标签逻辑-标签表
-- ----------------------------------
-- -----------一级标签 基本信息-----------
-- b_1301_tag_type1_case_map
-- 性别
alter table u_tag_19 add column t_u_gender int(5) default 0 comment '性别';

update u_tag_19 
left join customer_list 
on u_tag_19.customer_list_id = customer_list.customer_list_id
set u_tag_19.t_u_gender = 
case
when customer_list.gender = '男' then 1
when customer_list.gender = '女' then 2
else 0 end;

-- b_2002_mid_type1_where
-- 过程值：年龄
alter table u_mid_19 add column age_year int(10) default null comment '过程值：年龄';

update u_mid_19 
left join customer_list 
on u_mid_19.customer_list_id = customer_list.customer_list_id
set u_mid_19.age_year = TIMESTAMPDIFF(YEAR, customer_list.birthday, CURDATE())
where true;

-- b_1101_tag_type1_case_between
-- 年龄
alter table u_tag_19 add column t_u_age int(5) default 0 comment '年龄';

update u_tag_19 
left join u_mid_19 
on u_tag_19.id = u_mid_19.id
set u_tag_19.t_u_age = 
case
when u_mid_19.age_year <= 6 then 1
when u_mid_19.age_year >= 7 and u_mid_19.age_year <= 9 then 2
when u_mid_19.age_year >= 10 and u_mid_19.age_year <= 12 then 3
when u_mid_19.age_year >= 13 and u_mid_19.age_year <= 15 then 4
when u_mid_19.age_year >= 16 and u_mid_19.age_year <= 18 then 5
else 0 end;

-- b_1101_tag_type1_case_between
-- 剩余课时
alter table u_tag_19 add column t_u_remaining_hours int(5) default 0 comment '剩余课时';

update u_tag_19 
left join customer_list 
on u_tag_19.customer_list_id = customer_list.customer_list_id
set u_tag_19.t_u_remaining_hours = 
case
when customer_list.remaining_hours >= 0 and customer_list.remaining_hours <= 0 then 1
when customer_list.remaining_hours >= 1 and customer_list.remaining_hours <= 1 then 2
when customer_list.remaining_hours >= 2 and customer_list.remaining_hours <= 4 then 3
when customer_list.remaining_hours >= 5 and customer_list.remaining_hours <= 7 then 4
when customer_list.remaining_hours >= 8 and customer_list.remaining_hours <= 10 then 5
when customer_list.remaining_hours >= 11 and customer_list.remaining_hours <= 13 then 6
when customer_list.remaining_hours >= 13 then 7
else 0 end;

-- b_1301_tag_type1_case_map
-- 所属课程
alter table u_tag_19 add column t_u_class_name int(5) default 0 comment '所属课程';

update u_tag_19 
left join customer_list 
on u_tag_19.customer_list_id = customer_list.customer_list_id
set u_tag_19.t_u_class_name = 
case
when customer_list.class_name = '艺术涂鸦班' then 1
when customer_list.class_name = '创意漫画初级班' then 2
when customer_list.class_name = '创意绘画中级班' then 3
when customer_list.class_name = '硬笔书法班' then 4
when customer_list.class_name = '写意国画班' then 5
when customer_list.class_name = '趣味色彩班' then 6
when customer_list.class_name = '基础素描' then 7
when customer_list.class_name = '创意漫画班' then 8
when customer_list.class_name = '漫画班' then 9
when customer_list.class_name = '成人素描' then 10
when customer_list.class_name = '成人国画' then 11
when customer_list.class_name = '创意漫画中级' then 12
when customer_list.class_name = '成人油画班' then 13
else 0 end;

-- b_1202_mid_type1_case_where_else
-- 过程值：周几
alter table u_mid_19 add column class_time int(5) default 0 comment '过程值：周几';

update u_mid_19 
left join customer_list 
on u_mid_19.customer_list_id = customer_list.customer_list_id
set u_mid_19.class_time = 
case
when customer_list.class_time = '周日' then 1
when customer_list.class_time = '周一' then 2
when customer_list.class_time = '周二' then 3
when customer_list.class_time = '周三' then 4
when customer_list.class_time = '周四' then 5
when customer_list.class_time = '周五' then 6
when customer_list.class_time = '周六' then 7
else 0 end;

-- b_1201_tag_type1_case_where
-- 课程提醒
alter table u_tag_19 add column t_u_class_remind int(5) default 0 comment '课程提醒';

update u_tag_19 
left join u_mid_19 
on u_tag_19.id = u_mid_19.id
set u_tag_19.t_u_class_remind = 
case
when (u_mid_19.class_time - DAYOFWEEK(CURDATE())) in (-1,-2,-3,-4) then 1
when (u_mid_19.class_time - DAYOFWEEK(CURDATE())) = 0 then 2
when (u_mid_19.class_time - DAYOFWEEK(CURDATE())) in (1,-6) then 3
when (u_mid_19.class_time - DAYOFWEEK(CURDATE())) in (2,-5) then 4
else 0 end;

-- ----------------------------------
--            下载表生成
-- ----------------------------------
-- b7_dld_gen
-- 性别
alter table u_dld_19 add column t_u_gender varchar(200) default null comment '性别';

update u_dld_19 d left join u_tag_19 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_gender' and t.t_u_gender = v.match_val
set d.t_u_gender = v.value_name;

-- 年龄
alter table u_dld_19 add column t_u_age varchar(200) default null comment '年龄';

update u_dld_19 d left join u_tag_19 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_age' and t.t_u_age = v.match_val
set d.t_u_age = v.value_name;

-- 剩余课时
alter table u_dld_19 add column t_u_remaining_hours varchar(200) default null comment '剩余课时';

update u_dld_19 d left join u_tag_19 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_remaining_hours' and t.t_u_remaining_hours = v.match_val
set d.t_u_remaining_hours = v.value_name;

-- 所属课程
alter table u_dld_19 add column t_u_class_name varchar(200) default null comment '所属课程';

update u_dld_19 d left join u_tag_19 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_class_name' and t.t_u_class_name = v.match_val
set d.t_u_class_name = v.value_name;

-- 上课时间提醒
alter table u_dld_19 add column t_u_class_remind varchar(200) default null comment '上课时间提醒';

update u_dld_19 d left join u_tag_19 t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_class_remind' and t.t_u_class_remind = v.match_val
set d.t_u_class_remind = v.value_name;

