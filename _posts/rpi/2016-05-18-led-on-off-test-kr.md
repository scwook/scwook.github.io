---
layout: post
title: "LED On/Off Test"
language:
  - en
  - kr
categories: RaspberryPi
---
버튼을 눌렀을 때 LED가 켜지는 코드를 작성하고 테스트해 보자. 테스트를 하기전 wiringPi가 설치되어 있어야 한다. wiringPi 설치는 [WiringPi Installation](/rpi/2016/05/20/wiringPi-installation-kr.html) 포스트를 참고한다.

테스트 구성은 아래 그림과 같다. 버튼은 한쪽 다리는 5V 출력 pin에 연결되어 있고 다른 한쪽은 GPIO 1번에 연결되어 있다. 버튼의 foating 상태를 막기 위해 10kΩ의 pull-down 저항을 연결하였다. LED는 250Ω 저항과 함께 GPIO 4번에 연결하여 버튼을 눌렀을 때 LED가 켜지는 것을 확인 할 수 있다.

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

테스트를 위해 컴파일 후 프로그램을 실행한다.

{% highlight shell %}
pi@raspberrypi ~$ gcc -o ledTest ledTest.c -lwiringPi
pi@raspberrypi ~$ sudo ./ledTest
{% endhighlight %}

버튼을 눌렀을 때 LED가 켜지는지 확인한다.
