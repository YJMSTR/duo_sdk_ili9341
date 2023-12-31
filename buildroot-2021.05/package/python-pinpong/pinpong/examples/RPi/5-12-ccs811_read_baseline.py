# -*- coding: utf-8 -*-

#实验效果：读取I2C CCS811空气质量传感器
#接线：使用windows或linux电脑连接一块arduino主控板，空气质量传感器接到I2C口SCL SDA
import time
from pinpong.board import Board
from pinpong.libs.dfrobot_ccs811 import CCS811, CCS811_Ecycle, CCS811_Emode


Board("RPI").begin()  #初始化


ccs811 = CCS811(bus_num=1)

while True:
    if(ccs811.check_data_ready()):
        print("baseline:",ccs811.read_baseline())
    else:
        print("data is not ready!")
    time.sleep(1)
