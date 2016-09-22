---
layout: post
title: "DHT11 Temperature & Humidity Sensor Test"
language:
  - en
  - kr
categories: RaspberryPi
---
DHT11 온도 & 습도 센서는 온도 및 습도를 동시에 측정하여 40bit의 디지털 신호로 전송하는 센서이다. 센서에 대한 자세한 사양 및 통신 방법은 [DHT11 Manual](http://www.micropik.com/PDF/dht11.pdf)을 참고하기 바란다.
테스트에 앞서 기본적으로 [WiringPi](/rpi/2016/05/20/wiringPi-installation-kr.html)가 설치되어 있어야 한다. 

### Component

* Raspberry Pi 2 Model B
* [DHT11 Sensor](https://www.dfrobot.com/wiki/index.php?title=DHT11_Temperature_and_Humidity_Sensor_%28SKU:_DFR0067%29)
 
![DHT11 Test Circuit]({{site.url}}/images/rpi_dht11_test.png)

### Source Code
원본 소스코드는 [DHT11 GitHub](https://github.com/Hexalyse/RPi-weather-log/blob/master/dht11.c)에서 받을 수 있다.

filename: dht11.c

{% highlight c linenos %}
nclude <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define MAX_TIME 85
#define DHT11PIN 1

int dht11_val[5]={0,0,0,0,0};

void dht11_read_val()
{
  uint8_t lststate=HIGH;
  uint8_t counter=0;
  uint8_t j=0,i;

  for(i=0;i<5;i++)
     dht11_val[i]=0;

  pinMode(DHT11PIN,OUTPUT);
  digitalWrite(DHT11PIN,LOW);

  delay(18);

  digitalWrite(DHT11PIN,HIGH);

  delayMicroseconds(40);

  pinMode(DHT11PIN,INPUT);
  for(i=0;i<MAX_TIME;i++)
  {
    counter=0;
    while(digitalRead(DHT11PIN)==lststate){
      counter++;
      delayMicroseconds(1);
      if(counter==255)
        break;
    }

    lststate=digitalRead(DHT11PIN);

    if(counter==255)
       break;

    // top 3 transistions are ignored
    if((i>=4)&&(i%2==0)){
      dht11_val[j/8]<<=1;
      if(counter>16)
        dht11_val[j/8]|=1;
      j++;
    }
  }
  // verify cheksum and print the verified data
  if((j>=40)&&(dht11_val[4]==((dht11_val[0]+dht11_val[1]+dht11_val[2]+dht11_val[3])& 0xFF)))
  {
    printf("H = %d.%d  T = %d.%d\n",dht11_val[0],dht11_val[1],dht11_val[2],dht11_val[3]);
  }
  else
    printf("Invalid Data!!\n");
}

int main(void)
{
  if(wiringPiSetup()==-1)
    exit(1);

  while(1)
  {
     dht11_read_val();
       delay(2000);
  }

  return 0;
}
{% endhighlight %}

컴파일 후 프로그램을 실행한다.
{% highlight shell %}
pi@raspberrypi ~$ gcc -o dht11 dht11.c -lwiringPi
pi@raspberrypi ~$ sudo ./dht11
H = 32.0  T = 26.0
H = 32.0  T = 26.0
H = 32.0  T = 26.0
{% endhighlight %}
