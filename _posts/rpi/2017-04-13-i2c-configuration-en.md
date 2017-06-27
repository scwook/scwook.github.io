---
layout: post
title: "I2C Configuration of Raspberry Pi"
show: true
language:
  - en
  - kr
categories: RaspberryPi
---
I2C(Inter-Integrated Circuit)is a serial based protocol developed by the Philips Electronics and it has two bus lines which are SCL(Serial Clock) for clock synchronization and SDA(Serial Data) for data transmission. Although I2C has low transmission speed, it can connect to many devices by one bus line. Raspberry pi support two I2C interface and it can be enabled using Configuration Tool. The dedicated pin number of I2C can be checked by using [gpio readall]({{site.url}}/raspberrypi/2015/05/20/wiringPi-installation-en.html) command.

In order to use I2C interface, open the **Raspberry Pi Configuration Tool**.

{% highlight console %}
pi@raspberrypi ~$ sudo raspi-config
{% endhighlight %}

Select **Advanced Options**

![Select Advanced Options]({{site.url}}/images/rpi_i2c_config1.png)

Select **I2C** and set enable **Yes**

![Select I2C]({{site.url}}/images/rpi_i2c_config2.png)

![Enable Yes]({{site.url}}/images/rpi_i2c_config3.png)

### Connection Test

In order to test, install **i2c-tools**.

{% highlight console %}
pi@raspberrypi ~$ sudo aptitude install i2c-tools
{% endhighlight %}

Now you can check device address which is connected to raspberry pi using **i2cdetect** command. blow address is a BME280 sensor that is connected to I2C 1.

{% highlight console %}
pi@raspberrypi ~$ sudo i2cdetect -y 1
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- 76 --  
{% endhighlight %}
