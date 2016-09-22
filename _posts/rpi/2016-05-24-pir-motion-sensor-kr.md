---
layout: post
title: "PIR Motion Sensor Test"
language:
  - en
  - kr
categories: RaspberryPi
---
PIR 모션 센서는 적외선으로 움직임을 감지하는 센서로 일정한 범위 내에 적외선을 방출하는 물체가 움직일 경우 이를 감지하여 출력 신호로 내보낸다. 센서에 대한 자세한 사양은 [PIR Motion Sensor wiki](https://www.dfrobot.com/wiki/index.php/PIR_Motion_Sensor_V1.0_SKU:SEN0171)를 참고하기 바란다. 테스트를 하기 위해서는 [WiringPi]({{site.url}}/rpi/2016/05/20/wiringPi-installation-kr.html)가 설치되어 있어야 한다.

### Component

* Raspberry Pi 2 Model B
* [PIR Motion Sensor](https://www.dfrobot.com/wiki/index.php/PIR_Motion_Sensor_V1.0_SKU:SEN0171)
 
![GPIO Test Circuit]({{site.url}}/images/rpi_pir_motion_test.png)

### Source Code

filename: pirMotionTest.c

{% highlight c linenos %}
#include <stdio.h>
#include <wiringPi.h>

#define PIR 1

int main(void)
{
  if(wiringPiSetup() == -1)
    return 1;

  pinMode(PIR, INPUT);

  int input = 0;

  for(;;)
  {
    if(digitalRead(PIR))
    {
      printf("Motion Detected!\n");

      delay(5000);
    }
  }

  return 0;
}
{% endhighlight %}

### Test

컴파일 후 프고그램을 실행한다.

{% highlight shell %}
pi@raspberrypi ~$ gcc -o pirMotionTest pirMotionTest.c -lwiringPi
pi@raspberrypi ~$ sudo ./pirMotionTest
{% endhighlight %}

센서 앞에서 움직여 모션이 감지되는지 확인한다.
