---
layout: post
title: "LED On/Off Test"
show: true
language:
  - en
  - kr
categories: RaspberryPi
---
Let's turn on LED when a button is pushed. Before the test, [WiringPi Installation]({{site.url}}/raspberrypi/2016/05/20/wiringPi-installation-en.html) must be installed.

The figure below shows a test circuit. one leg of button is connect to 5V output pin and another leg is connect to #1 pin of GPIO. In order to prevent floating status of button, 10kΩ pull-down resistor is connected. LED is connected to GPIO #4 with 250Ω resistor so that button state can be checked.  

### Component

* Raspberry Pi 2 Model B
* Push Button
* LED(Operating Voltage: 1.8V ~ 2.3V)
* Resistor 250Ω, 10kΩ
 
![GPIO Test Circuit]({{site.url}}/images/rpi_gpio_led_test.png)

### Source Code

filename: ledTest.c

{% highlight c linenos %}
#include <wiringPi.h>

#define LED 4
#define BUTTON 1

int main(void)
{
  if(wiringPiSetup() == -1)
    return 1;

  pinMode(LED, OUTPUT);
  pinMode(BUTTON, INPUT);

  digitalWrite(LED, 0);
  int input = 0;

  for(;;)
  {
    if(digitalRead(BUTTON))
      digitalWrite(LED, 1);
    else
      digitalWrite(LED, 0); 

    delay(100);
  }

  return 0;
}
{% endhighlight %}

### Test

Compile and run the program.

{% highlight console %}
pi@raspberrypi ~$ gcc -o ledTest ledTest.c -lwiringPi
pi@raspberrypi ~$ sudo ./ledTest
{% endhighlight %}

Check the LED ON when you pushed the button.
