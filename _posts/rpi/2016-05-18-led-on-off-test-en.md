---
layout: post
title: "LED On/Off Test"
show: true
language:
  - en
  - kr
categories: RaspberryPi
---
Let's turn on LED when a button is pushed. Before the test, wiringPi must be installed.

The test circuit is shown as in figure. one leg of button is connect to 5V output pin and another leg is connect to #1 pin of GPIO and 10kΩ pull-down resistor is used to prevent floating state.

### Component

* Raspberry Pi 2 Model B
* Push Button
* LED(Operating Voltage: 1.8V ~ 2.3V)
* Resistor 250Ω, 10kΩ
 
![GPIO Test Circuit]({{site.url}}/images/rpi_gpio_led_test.png)

### Source Code
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

Compile and run the program.

{% highlight shell %}
pi@raspberrypi ~$ gcc -o buttonTest buttonTest.c -lwiringPi
pi@raspberrypi ~$ sudo ./buttonTest
{% endhighlight %}
