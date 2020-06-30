# coding: utf-8
from string import Template

__all__ = [
    't_tag_ins_template',
    't_tag_value_ins_template'
    ]

# 标签信息
t_tag_ins_str = "INSERT INTO `$t_tag` \
(customer_id, pid, tag_name, tag_define, dld_field_name, create_time, update_time, status) \
VALUES \
($customer_id, $pid, $tag_name, $tag_define, $dld_field_name, $create_time, $update_time, $status);"
t_tag_ins_template = Template(t_tag_ins_str)

t_tag_value_ins_str = "INSERT INTO `$t_tag_value` \
(tag_id, value_name, match_rule, match_val, tag_field_name, create_time, update_time, status) \
VALUES \
($tag_id, $value_name, $match_rule, $match_val, $tag_field_name, $create_time, $update_time, $status);"
t_tag_value_ins_template = Template(t_tag_value_ins_str)

# 标签生成逻辑
# 基础表生成
tl_001_base_gen = '''\
-- 生成tag表，含必显字段
drop table if exists $u_tag;
create table $u_tag 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户标签表'
select 
    $keys_str, $fields
from 
    $tb_customer;
    
ALTER TABLE `$u_tag`
ADD COLUMN `id`  int(11) NOT NULL AUTO_INCREMENT FIRST ,
ADD PRIMARY KEY (`id`);

ALTER TABLE `$u_tag`
ADD INDEX `index_a` ($keys_str) ;

-- 生成dld表
drop table if exists $u_dld;
create table $u_dld like  $u_tag;
insert into $u_dld select * from $u_tag;

ALTER TABLE `$u_dld`
COMMENT='用户下载表';

-- 生成mid表
drop table if exists $u_mid;
create table $u_mid like  $u_tag;
insert into $u_mid select * from $u_tag;

ALTER TABLE `$u_mid`
COMMENT='用户中间值表';

'''
tl_001_base_gen_template = Template(tl_001_base_gen)

# 类型1 case
tl_i_01_type1_case = '''\
-- $tag_cn_name
alter table $u_tag add column $tu_tag_field_name $tag_field_type default $tag_field_default comment '$tag_cn_name';

update $u_tag $join_table
set $u_tag.$tu_tag_field_name = 
case
$when_str
else $case_default end;

'''
tl_i_01_type1_case_template = Template(tl_i_01_type1_case)

# 类型2基本语句
tl_i_02_type2_basic = '''\
-- $tag_cn_name
alter table $u_tag add column $tu_tag_field_name $tag_field_type default $tag_field_default comment '$tag_cn_name';

update $u_tag x inner join (
select $u_tag.id, $agg_func($b_table_join_field) c from 
$u_tag $join_table
where $where_str
group by $u_tag.id
) y on x.id = y.id 
set $tu_tag_field_name = y.c;

'''
tl_i_02_type2_basic_template = Template(tl_i_02_type2_basic)


# 类型1 where条件
tl_i_03_type1_where = '''\
-- $tag_cn_name
alter table $u_tag add column $tu_tag_field_name $tag_field_type default $tag_field_default comment '$tag_cn_name';

update $u_tag $join_table
set $u_tag.$tu_tag_field_name = $tag_value
where $where_str;

'''
tl_i_03_type1_where_template = Template(tl_i_03_type1_where)

# 类型1 where条件  新增，连接两个表
tl_i_03_1_type1_where = '''\
-- $tag_cn_name
alter table $u_tag add column $tu_tag_field_name $tag_field_type default $tag_field_default comment '$tag_cn_name';

update $u_tag  $join_table1  $join_table2
set $u_tag.$tu_tag_field_name = $tag_value
where $where_str;

'''
tl_i_03_1_type1_where_template = Template(tl_i_03_1_type1_where)

# 类型1 外连接+内连接
tl_i_04_type1_where = '''\
-- $tag_cn_name


update u_dld_$custom_id d left join u_tag_$custom_id t 
on d.id = t.id
inner join  t_tag_value v
on v.tag_field_name = 't_u_$tag_field_name' and t.t_u_$tag_field_name = v.match_val
set d.t_u_$tag_field_name = v.value_name;
where $where_str;
'''
tl_i_04_type1_where_template  = Template(tl_i_04_type1_where)

# 下载表生成 单选标签
tl_i_05_dld_single = '''\
-- $tag_cn_name
alter table u_dld_$custom_id add column t_u_$tag_field_name varchar(200) default null comment '$tag_cn_name';

update u_dld_$custom_id d left join u_tag_$custom_id t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_$tag_field_name' and t.t_u_$tag_field_name = v.match_val
set d.t_u_$tag_field_name = v.value_name;
'''
tl_i_05_dld_single_template = Template(tl_i_05_dld_single)

# 下载表生成 多选标签 添加字段
tl_i_06_dld_multi_add = '''\
-- $tag_cn_name
alter table u_dld_$custom_id add column t_u_$tag_field_name varchar(200) default null comment '$tag_cn_name';

'''
tl_i_06_dld_multi_add_template = Template(tl_i_06_dld_multi_add)

# 下载表生成 多选标签 标签值拼接
tl_i_07_dld_multi = '''\
update u_dld_$custom_id d left join u_tag_$custom_id t 
on d.id = t.id
left join t_tag_value v
on v.tag_field_name = 't_u_$tag_field_name_i' and t.t_u_$tag_field_name_i = v.match_val
set d.t_u_$tag_field_name = 
case
when d.t_u_$tag_field_name is null then v.value_name
else concat(d.t_u_$tag_field_name, ',', v.value_name) end
where t.t_u_$tag_field_name_i = 1;

'''
tl_i_07_dld_multi_template = Template(tl_i_07_dld_multi)

