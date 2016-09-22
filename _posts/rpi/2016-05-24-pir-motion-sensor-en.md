---
layout: post
title: "PIR Motion Sensor Test"
show: true
language:
  - en
  - kr
categories: RaspberryPi
---
PIR motion sensor used to detect whether a object which emits infrared radiation has moved in or out the sensor range. If the sensor detect a moving object, it make output signal. More infromation about the sensor can be found in the [PIR Motion Sensor wiki](https://www.dfrobot.com/wiki/index.php/PIR_Motion_Sensor_V1.0_SKU:SEN0171). Before the test, [WiringPi]({{site.url}}/raspberrypi/2016/05/20/wiringPi-installation-en.html) must be installed.

### Component

* Raspberry Pi 2 Model B
* [PIR Motion Sensor](https://www.dfrobot.com/wiki/index.php/PIR_Motion_Sensor_V1.0_SKU:SEN0171)
 
![PIR Motion Sensor Test Circuit]({{site.url}}/images/rpi_pir_motion_test.png)

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

Compile and run the program.

{% highlight shell %}
pi@raspberrypi ~$ gcc -o pirMotionTest pirMotionTest.c -lwiringPi
pi@raspberrypi ~$ sudo ./pirMotionTest
{% endhighlight %}

Check motion detection. when you moved in front of the sensor.
