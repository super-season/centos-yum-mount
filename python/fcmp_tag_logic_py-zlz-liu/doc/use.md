## fcmp标签逻辑sql脚本生成程序生成样例


### 1.类型1：用户ID左关联条件查询、case语句
#### 1.1.类型1、case语句、区间判断、tag表

##### SQL样例：
```sql
-- b_1101_tag_type1_case_between
-- 年龄
alter table u_tag_12 add column t_u_age int(5) default 0 comment '年龄';

update u_tag_12 
left join u_mid_12 
on u_tag_12.id = u_mid_12.id
set u_tag_12.t_u_age = 
case
when u_mid_12.age_months >= 0 and u_mid_12.age_months <= 3 then 1
when u_mid_12.age_months >= 4 and u_mid_12.age_months <= 6 then 2
when u_mid_12.age_months >= 7 and u_mid_12.age_months <= 12 then 3
when u_mid_12.age_months >= 13 and u_mid_12.age_months <= 18 then 4
when u_mid_12.age_months >= 19 and u_mid_12.age_months <= 24 then 5
when u_mid_12.age_months >= 25 and u_mid_12.age_months <= 36 then 6
when u_mid_12.age_months >= 37 and u_mid_12.age_months <= 48 then 7
when u_mid_12.age_months >= 49 and u_mid_12.age_months <= 60 then 8
when u_mid_12.age_months >= 61 and u_mid_12.age_months <= 72 then 9
when u_mid_12.age_months >= 73 then 10
else 0 end;
```

##### Python代码：
```python
        # 年龄
        base_conf = {
            'tag_cn_name': '年龄',
            'tag_field_name': 'age',
            'table_join': 'u_mid_12',
            'table_join_field': 'age_months',
            'case_default': '0',
        }
        when_conf = {
            '1': ['0', '3'],
            '2': ['4', '6'],
            '3': ['7', '12'],
            '4': ['13', '18'],
            '5': ['19', '24'],
            '6': ['25', '36'],
            '7': ['37', '48'],
            '8': ['49', '60'],
            '9': ['61', '72'],
            '10': ['73', ''],
        }
        self.b_1101_tag_type1_case_between(base_conf, when_conf)
```

##### 说明：
如果不需要关联表则不要在base_conf中含有table_join这个key。  
b_1101_tag_type1_case_between函数中add column default和case default使用的同一值。

#### 1.2.1.类型1、case语句、when条件、tag表

##### SQL样例：
```sql
-- b_1201_tag_type1_case_where
-- 客户属性
alter table u_tag_13 add column t_u_ctype int(5) default 2 comment '客户属性';

update u_tag_13 
left join u_mid_13 
on u_tag_13.id = u_mid_13.id
set u_tag_13.t_u_ctype = 
case
when u_mid_13.order_times_before3 = 1 and u_mid_13.order_times_after3 = 0 then 0
when u_mid_13.order_times_before3 = 0 and u_mid_13.order_times_after3 > 0 then 1
else 2 end;
```

##### Python代码：
```python
        # 客户属性
        base_conf = {
            'tag_cn_name': '客户属性',
            'tag_field_name': 'ctype',
            'table_join': 'u_mid_13',
            'case_default': '2',
        }
        when_conf = {
            '0': 'u_mid_13.order_times_before3 = 1 and u_mid_13.order_times_after3 = 0',
            '1': 'u_mid_13.order_times_before3 = 0 and u_mid_13.order_times_after3 > 0',
        }
        self.b_1201_tag_type1_case_where(base_conf, when_conf)
```

##### 说明：
如果不需要关联表则不要在base_conf中含有table_join这个key。  
b_1201_tag_type1_case_where函数中add column default和case default使用的同一值。

#### 1.2.2.类型1、case语句、when条件、mid表

##### SQL样例：
```sql
-- b_1202_mid_type1_case_where_else
-- 过程值：近一年到店计入月数
alter table u_mid_12 add column year_months decimal(7,5) default 0.0 comment '过程值：近一年到店计入月数';

update u_mid_12 
set u_mid_12.year_months = 
case
when first_buy is null then 99
when first_buy < date_sub(CURDATE(),interval 1 year) then 12.0
when first_buy > date_sub(CURDATE(),interval 1 month) then 1
else datediff(CURDATE(),first_buy)/30 end;
```

##### Python代码：
```python
        # 过程值：近一年到店计入月数
        base_conf = {
            'tag_cn_name': '过程值：近一年到店计入月数',
            'tag_field_name': 'year_months',
            'tag_field_type': 'decimal(7,5)',
            'tag_field_default': '0.0',
            'case_default': 'datediff(CURDATE(),first_buy)/30',
        }
        when_conf = {
            '99': 'first_buy is null',
            '12.0': 'first_buy < date_sub(CURDATE(),interval 1 year)',
            '1': 'first_buy > date_sub(CURDATE(),interval 1 month)',
        }
        self.b_1202_mid_type1_case_where_else(base_conf, when_conf)
```

##### 说明：
如果不需要关联表则不要在base_conf中含有table_join这个key。  
b_1202_mid_type1_case_where_else函数中add column default和case default是不同的，需要分别指定。

#### 1.3.1.类型1、case语句、when条件、字段等于、tag表

##### SQL样例：
```sql
-- b_1301_tag_type1_case_map
-- 地址
alter table u_tag_15 add column t_u_address int(5) default 0 comment '地址';

update u_tag_15 
left join member_info 
on u_tag_15.member_id = member_info.member_id
set u_tag_15.t_u_address = 
case
when member_info.province = '上海市' then 1
when member_info.province = '云南省' then 2
when member_info.province = '内蒙古自治区' then 3
when member_info.province = '北京市' then 4
when member_info.province = '吉林省' then 5
when member_info.province = '四川省' then 6
when member_info.province = '天津市' then 7
when member_info.province = '宁夏回族自治区' then 8
when member_info.province = '安徽省' then 9
when member_info.province = '山东省' then 10
when member_info.province = '山西省' then 11
when member_info.province = '广东省' then 12
when member_info.province = '广西壮族自治区' then 13
when member_info.province = '新疆维吾尔自治区' then 14
when member_info.province = '江苏省' then 15
when member_info.province = '江西省' then 16
when member_info.province = '河北省' then 17
when member_info.province = '河南省' then 18
when member_info.province = '浙江省' then 19
when member_info.province = '海南省' then 20
when member_info.province = '湖北省' then 21
when member_info.province = '湖南省' then 22
when member_info.province = '甘肃省' then 23
when member_info.province = '福建省' then 24
when member_info.province = '西藏自治区' then 25
when member_info.province = '贵州省' then 26
when member_info.province = '辽宁省' then 27
when member_info.province = '重庆市' then 28
when member_info.province = '陕西省' then 29
when member_info.province = '青海省' then 30
when member_info.province = '黑龙江省' then 31
else 0 end;
```

##### Python代码：
```python
        # 地址
        base_conf = {
            'tag_cn_name': '地址',
            'tag_field_name': 'address',
            'table_join': 'member_info',
            'table_join_field': 'province',
            'case_default': '0',
        }
        when_conf = {
            '1': '上海市',
            '2': '云南省',
            '3': '内蒙古自治区',
            '4': '北京市',
            '5': '吉林省',
            '6': '四川省',
            '7': '天津市',
            '8': '宁夏回族自治区',
            '9': '安徽省',
            '10': '山东省',
            '11': '山西省',
            '12': '广东省',
            '13': '广西壮族自治区',
            '14': '新疆维吾尔自治区',
            '15': '江苏省',
            '16': '江西省',
            '17': '河北省',
            '18': '河南省',
            '19': '浙江省',
            '20': '海南省',
            '21': '湖北省',
            '22': '湖南省',
            '23': '甘肃省',
            '24': '福建省',
            '25': '西藏自治区',
            '26': '贵州省',
            '27': '辽宁省',
            '28': '重庆市',
            '29': '陕西省',
            '30': '青海省',
            '31': '黑龙江省',
        }
        self.b_1301_tag_type1_case_map(base_conf, when_conf)
```

##### 说明：
如果不需要关联表则不要在base_conf中含有table_join这个key。  
b_1201_tag_type1_case_where函数中add column default和case default使用的同一值。

### 2.类型1：用户ID左关联条件查询、where条件
#### 2.1.类型1、where条件、tag表

##### SQL样例：
```sql
-- b_2001_tag_type1_where  
-- 会员类型-健康卡  
alter table u_tag_12 add column t_u_member_type_1 int(5) default 0 comment '会员类型-健康卡';  
  
update u_tag_12   
left join member_patient_info   
on u_tag_12.patient_name = member_patient_info.patient_name and u_tag_12.phone = member_patient_info.phone  
set u_tag_12.t_u_member_type_1 = 1  
where member_patient_info.member_type_from_member like '%折%';  
```

##### Python代码：
```python
        # 会员类型-健康卡
        base_conf = {
            'tag_cn_name': '会员类型-健康卡',
            'tag_field_name': 'member_type_1',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'member_patient_info',
            'tag_value': '1',
            'where_str': "member_patient_info.member_type_from_member like '%折%'",
        }
        self.b_2001_tag_type1_where(base_conf)
```

##### 说明：
如果不需要关联表则不要在base_conf中含有table_join这个key。

#### 2.1.1.特例：多值标签的其它

##### SQL样例：
```sql
-- b_2001_tag_type1_where
-- 会员类型-普通客户
alter table u_tag_12 add column t_u_member_type_0 int(5) default 0 comment '会员类型-普通客户';

update u_tag_12 
set u_tag_12.t_u_member_type_0 = 1
where t_u_member_type_1 = 0 and t_u_member_type_2 = 0 and t_u_member_type_3 = 0 and t_u_member_type_4 = 0 and t_u_member_type_5 = 0 and t_u_member_type_6 = 0;
```

##### Python代码：
```python
        # 会员类型-普通客户
        where_str = ' and '.join(['t_u_member_type_' + str(i) + ' = 0'
                                  for i in range(1, 7)])
        base_conf = {
            'tag_cn_name': '会员类型-普通客户',
            'tag_field_name': 'member_type_0',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'tag_value': '1',
            'where_str': where_str,
        }
        self.b_2001_tag_type1_where(base_conf)
```

#### 2.2.类型1、where条件、mid表、不需要关联表

##### SQL样例：
```sql
-- b_2002_mid_type1_where
-- 过程值：近一年到店频率
alter table u_mid_13 add column last_year_rate decimal(12,3) default 0 comment '过程值：近一年到店频率';

update u_mid_13 
set u_mid_13.last_year_rate = order_times_after12/last_year_interview_month
where true;
```

##### Python代码：
```python
        # 过程值：近一年到店频率
        base_conf = {
            'tag_cn_name': '过程值：近一年到店频率',
            'tag_field_name': 'last_year_rate',
            'tag_field_type': 'decimal(12,3)',
            'tag_field_default': '0',
            'tag_value': 'order_times_after12/last_year_interview_month',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)
```

##### 说明：
如果不需要关联表则不要在base_conf中含有table_join这个key。

#### 2.2.1.类型1、where条件、mid表、需要关联表的例子

##### SQL样例：
```sql
-- b_2002_mid_type1_where
-- 过程值：套餐有效期距今天数
alter table u_mid_12 add column expire_days int(5) default null comment '过程值：套餐有效期距今天数';

update u_mid_12 
left join sign_card_manage 
on u_mid_12.patient_name = sign_card_manage.baby_name and u_mid_12.phone = sign_card_manage.card_no
set u_mid_12.expire_days = TIMESTAMPDIFF(DAY, sign_card_manage.expire, CURDATE())
where true;
```

##### Python代码：
```python
        # 过程值：套餐有效期距今天数
        base_conf = {
            'tag_cn_name': '过程值：套餐有效期距今天数',
            'tag_field_name': 'expire_days',
            'tag_field_type': 'int(5)',
            'tag_field_default': 'null',
            'table_join': 'sign_card_manage',
            'tag_value': 'TIMESTAMPDIFF(DAY, sign_card_manage.expire, CURDATE())',
            'where_str': 'true',
        }
        self.b_2002_mid_type1_where(base_conf)
```

##### 说明：
如果不需要关联表则不要在base_conf中含有table_join这个key。



### 3.类型2：基于用户ID的聚合操作
#### 3.1.类型2、mid表

##### SQL样例：
```sql
-- b_3001_mid_type2_basic
-- 过程值：消费金额总和
alter table u_mid_13 add column total_cost_value int(11) default 0 comment '过程值：消费金额总和';

update u_mid_13 x inner join (
select u_mid_13.id, sum(order_list.total_cost) c from 
u_mid_13 
inner join order_list 
on u_mid_13.phone = order_list.phone
where true
group by u_mid_13.id
) y on x.id = y.id 
set total_cost_value = y.c;
```

##### Python代码：
```python
        # 过程值：消费金额总和
        base_conf = {
            'tag_cn_name': '消费金额总和',
            'tag_field_name': 'total_cost_value',
            'tag_field_type': 'int(11)',
            'tag_field_default': '0',
            'table_join': 'order_list',
            'table_join_field': 'order_list.total_cost',
            'agg_func': 'sum',
            'where_str': 'true',
        }
        self.b_3001_mid_type2_basic(base_conf)
```

##### 说明：
如果聚合函数是count(*)则不需要聚合函数字段，这时table_join_field可以填写'any_string'；  
where条件可以不需要，这时where_str可以填写'true'；  

一个聚合函数count、有where条件的例子：
```python
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': "order_list.member_group = 1",
```

#### 3.1.1.count聚合函数、有where条件的例子

##### SQL样例：
```sql
-- b_3001_mid_type2_basic
-- 过程值：近一年到店次数
alter table u_mid_12 add column year_times int(5) default 0 comment '过程值：近一年到店次数';

update u_mid_12 x inner join (
select u_mid_12.id, count(*) c from 
u_mid_12 
inner join interview_info 
on u_mid_12.patient_name = interview_info.patient_name and u_mid_12.phone = interview_info.phone
where interview_info.interview_date >= date_sub(CURDATE(),interval 1 year)
group by u_mid_12.id
) y on x.id = y.id 
set year_times = y.c;
```

##### Python代码：
```python
        # 过程值：近一年到店次数
        base_conf = {
            'tag_cn_name': '近一年到店次数',
            'tag_field_name': 'year_times',
            'tag_field_type': 'int(5)',
            'tag_field_default': '0',
            'table_join': 'interview_info',
            'table_join_field': 'any_string',
            'agg_func': 'count',
            'where_str': 'interview_info.interview_date >= date_sub(CURDATE(),interval 1 year)',
        }
        self.b_3001_mid_type2_basic(base_conf)
```










