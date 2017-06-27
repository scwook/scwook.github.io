---
layout: post
title: "Vibration Sensor Test"
language:
  - en
  - kr
categories: RaspberryPi
---

진동 센서를 이용하여 진동에 따라 깜빡이는 LED를 만들어 보자. 테스트를 하기 전 [WiringPi]({{site.url}}/raspberrypi/2016/05/20/wiringPi-installation-kr.html)가 설치되어 있어야 한다.

### Component

* Raspberry Pi 2 Model B
* [Vibration Sensor](https://www.dfrobot.com/wiki/index.php/DFRobot_Digital_Vibration_Sensor_V2_SKU:DFR0027)
* LED(Operating Voltage: 1.8V ~ 2.3V)
* Resistor 250Ω

![Vibration Test Circuit]({{site.url}}/images/rpi_vibration_test.png)

### Source Code

filename: vibrationTest.c

{% highlight c linenos %}
#include <stdio.h>
#include <wiringPi.h>

void function(void);
int main(void)
{
  if(wiringPiSetup() == -1)
  {
    printf("Unable to start wiringPi\n");
    return 1;
  }

  pinMode(4, OUTPUT);

  wiringPiISR(1, INT_EDGE_FALLING, &function);

  while(1)
  {

  }

  return 0;
}

void function(void)
{
  digitalWrite(4, 1);
  delay(10);
  digitalWrite(4, 0);
}
{% endhighlight %}

### Test

컴파일 후 프로그램을 실행한다.

{% highlight console %}
pi@raspberrypi ~$ gcc -o vibrationTest vibrationTest.c -lwiringPi
pi@raspberrypi ~$ sudo ./vibrationTest
{% endhighlight %}

진동 센서를 흔들었을 때 LED가 깜빡이는 것을 볼 수 있다.
