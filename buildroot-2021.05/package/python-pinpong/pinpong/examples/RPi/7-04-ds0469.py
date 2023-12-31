# -*- coding: utf-8 -*-
import time
from pinpong.board import Board
from pinpong.libs.dfrobot_ds0469 import DS0469

Board("RPI").begin()#初始化

rtc = DS0469(bus_num=4) #根据支持的i2c设备填写

#rtc.adjust_aotu()                                  #自动调整时间
rtc.adjust_rtc(2021,1,4,1,13,30,59)                 #设置时间，年月日星期时分秒

while True:
    rtc.read()
    print("{}-{}-{} {}:{}:{}".format(rtc.year,rtc.month,rtc.day,rtc.hour,rtc.minute,rtc.second))
    print(rtc.week)
    time.sleep(1)