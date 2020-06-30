from string import Template


def stringTemplate():
    # 创建一个Template实例tmp
    tmp=Template("I have ${yuan} yuan,I can buy ${how} hotdog")
    yuanList=[1,5,8,10,12,13]
    for yu in yuanList:
        # su        bstitute()按照Template中string输出
        # 并给相应key赋值
        Substitute= tmp.substitute(yuan=yu,how=yu)
        print (Substitute)
    print()
    for yu in yuanList:
        # 使用substitute函数缺少key值包KeyError
        try:
            lackHow= tmp.substitute(yuan=yu)
            print (lackHow)
            print()
        except KeyError as e:
            print("substitute lack key ", e)
    print()
    for yu in yuanList:
        # safe_substitute()在缺少key的情况下
        # 直接原封不动的把字符串显示出来。
        safe_substitute= tmp.safe_substitute(yuan=yu)
        print(safe_substitute)
    print()
# 调用stringTemplate函数
stringTemplate()
