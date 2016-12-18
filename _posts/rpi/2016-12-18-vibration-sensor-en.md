---
layout: post
title: "Vibration Sensor Test"
show: true
language:
  - en
  - kr
categories: RaspberryPi
---

By using a vibration sensor, Let's make a some blinking LED which is response to vibration. Before the test, [WiringPi]({{site.url}}/raspberrypi/2016/05/20/wiringPi-installation-en.html) must be installed. 

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

Compile and run the program.

{% highlight shell %}
pi@raspberrypi ~$ gcc -o vibrationTest vibrationTest.c -lwiringPi
pi@raspberrypi ~$ sudo ./vibrationTest
{% endhighlight %}

Now you can see the blinking LED when you shake the vibration sensor.
