---
layout: post
title: "I2C Configuration of Raspberry Pi"
language:
  - en
  - kr
categories: RaspberryPi
---
I2C(Inter-Integrated Circuit)는 필립스에서 개발한 통신 프로토콜이며 클럭 동기화를 위한 SCL(Serial Clock)과 데이터 전송을 위한 SDA(Serial Data)로 구성되어 있다. I2C는 속도가 느리지만 하나의 버스에 많은 수의 장치를 연결할 수 있는 장점이 있다. Raspberry Pi는 2개의 I2C Interface를 지원하며 Configuration Tool을 사용하여 활성화 할 수 있다. I2C Pin 번호는 [gpio readall]({{site.url}}/raspberrypi/2015/05/20/wiringPi-installation-kr.html) 명령으로 확인 할 수 있다.

### Enable I2C Interface

I2C를 사용하기 위해 Raspberry Pi Configuration Tool을 실행한다.

{% highlight console %}
pi@raspberrypi ~$ sudo raspi-config
{% endhighlight %}

Advanced Options을 선택한다.

![Select Advanced Options]({{site.url}}/images/rpi_i2c_config1.png)

I2C를 선택한 후 Yes로 설정 한다.

![Select I2C]({{site.url}}/images/rpi_i2c_config2.png)

![Enable Yes]({{site.url}}/images/rpi_i2c_config3.png)

### Connection Test

테스트를 위해 i2c-tools 설치한다.

{% highlight console %}
pi@raspberrypi ~$ sudo aptitude install i2c-tools
{% endhighlight %}

설치가 완료되면  i2cdetect 명령을 통해 연결된 장치의 주소를 확인 할 수 있다. 아래는 1번 I2C에 BME280 센서를 연결했을 경우 출력되는 주소이다.

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
