#-*- coding:utf-8 -*-

import configparser

# #创建config.cfg配置文件
config = configparser.ConfigParser()  #应用模块函数
# config['DEFAULT'] = {'default':'yes'}  #DEFAULT节点
# config['path'] = {'userinfo':r'F:\pycharm\学习\day29\userinfo'}  #path节点，userinfo为节点配置项
# with open('config.cfg','w',encoding='utf-8') as f:
#     config.write(f)   #配置文件写入

#查看
config.read('config.cfg',encoding='utf-8')   #先要读配置文件，才能增删改查
print(config.sections())   #查看节点，不包括default默认节点
print('project' in config)    #判断path节点是否在config中
print(config.get('project','keywords'))
print(config['project']['keywords'])  #得到path节点userinfo的值

for k in config['project']:   # 打印'path'节点下的配置项的同时还会打印默认节点下的所有项
    print(k)  # 得到配置项userinfo  default

print(config.items('project'))  #得到path列表，包括default

#增加和修改
# config.add_section('IP')  # 增加节点
# print(config.sections())  # ['path', 'IP']
# config.set('IP', 'ip', '192.168.1.1')  # 给节点增加配置项
# config.set('path', 'userinfo', 'None')  # 修改配置项
# print(config['IP']['ip'])  # 192.168.1.1
# print(config['path']['userinfo'])  # None
# config.write(open('config.cfg', 'w', encoding='utf-8'))  # 将修改重新写回文件

#删除节点
# config.remove_section('IP')  # 删除节点
# print(config.sections())  # ['path']
# print(config.items('path'))  # [('default', 'yes'), ('userinfo', 'None')]
# config.remove_option('path', 'userinfo')  # 删除节点中的配置项
# print(config.items('path'))  # [('default', 'yes')]
# config.write(open('config.cfg', 'w', encoding='utf-8'))  # 将修改重新写回文件