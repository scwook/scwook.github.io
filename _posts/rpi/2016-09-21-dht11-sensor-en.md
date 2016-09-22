---
layout: post
title: "DHT11 Temperature & Humidity Sensor Test"
show: true
language:
  - en
  - kr
categories: RaspberryPi
---
The DHT11 sensor can measure temperature and humidity simultaneously. By using 1-wire signal line, 40bit data are transmitted. Detailed specifications of sensor can be founded in [DHT11 Manual](http://www.micropik.com/PDF/dht11.pdf). In order to test, [WiringPi Installation]({{site.url}}/rpi/2016/05/20/wiringPi-installation-en.html) must be installed.

### Component

* Raspberry Pi 2 Model B
* [DHT11 Sensor](https://www.dfrobot.com/wiki/index.php?title=DHT11_Temperature_and_Humidity_Sensor_%28SKU:_DFR0067%29)
 
![DHT11 Test Circuit]({{site.url}}/images/rpi_dht11_test.png)

### Source Code
The original source code can be founded at [DHT11 GitHub](https://github.com/Hexalyse/RPi-weather-log/blob/master/dht11.c)

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

Compile and run the program
{% highlight shell %}
pi@raspberrypi ~$ gcc -o dht11 dht11.c -lwiringPi
pi@raspberrypi ~$ sudo ./dht11
H = 32.0  T = 26.0
H = 32.0  T = 26.0
H = 32.0  T = 26.0
{% endhighlight %}
