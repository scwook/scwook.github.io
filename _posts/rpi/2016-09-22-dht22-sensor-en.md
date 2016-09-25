---
layout: post
title: "DHT22 Temperature & Humidity Sensor Test"
show: true
language:
  - en
  - kr
categories: RaspberryPi
---
The DHT22 Temperature & Humidity sensor is a high sensitive sensor for accuracy and range of measurement more than [DHT11]({{site.url}}/raspberrypi/2016/09/21/dht11-sensor-en.html) snesor. Detailed specifications of sensor can be founded in [DHT22 Manual](https://www.sparkfun.com/datasheets/Sensors/Temperature/DHT22.pdf). In order to test, [WiringPi]({{site.url}}/raspberrypi/2016/05/20/wiringPi-installation-en.html) must be installed.

### Component

* Raspberry Pi 2 Model B
* [DHT22 Sensor](https://www.dfrobot.com/wiki/index.php/DHT22_Temperature_and_humidity_module_SKU:SEN0137)
 
![DHT22 Test Circuit]({{site.url}}/images/rpi_dht22_test.png)

### Source Code
filename: dht22.c

{% highlight c linenos %}
include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define MAX_TIME 85
#define DHT22PIN 1

int dht22_val[5]={0,0,0,0,0};

void dht22_read_val()
{
  uint8_t lststate=HIGH;
  uint8_t counter=0;
  uint8_t j=0,i;

  for(i=0;i<5;i++)
     dht22_val[i]=0;

  pinMode(DHT22PIN,OUTPUT);
  digitalWrite(DHT22PIN,LOW);

  delay(18);

  digitalWrite(DHT22PIN,HIGH);

  delayMicroseconds(40);

  pinMode(DHT22PIN,INPUT);
  for(i=0;i<MAX_TIME;i++)
  {
    counter=0;
    while(digitalRead(DHT22PIN)==lststate){
      counter++;
      delayMicroseconds(1);
      if(counter==255)
        break;
    }

    lststate=digitalRead(DHT22PIN);

    if(counter==255)
       break;

    // top 3 transistions are ignored
    if((i>=4)&&(i%2==0)){
      dht22_val[j/8]<<=1;
      if(counter>16)
        dht22_val[j/8]|=1;
      j++;
    }
  }
  // verify cheksum and print the verified data
  if((j>=40)&&(dht22_val[4]==((dht22_val[0]+dht22_val[1]+dht22_val[2]+dht22_val[3])& 0xFF)))
  {
    float t, h;

    h = (float)dht22_val[0] * 256 + (float)dht22_val[1];
    h /= 10;

    t = (float)(dht22_val[2] & 0x7F)* 256 + (float)dht22_val[3];
    t /= 10.0;

    if ((dht22_val[2] & 0x80) != 0) t *= -1;

    printf("Humidity = %.2f %% Temperature = %.2f *C \n", h, t );
  }
  else
    printf("Data not good, skip\n");
}

int main(void)
{

  if(wiringPiSetup()==-1)
    exit(1);

  while(1)
  {
     dht22_read_val();
     delay(1000);
  }

  return 0;
}
{% endhighlight %}

### Test

Compile and run the program
{% highlight shell %}
pi@raspberrypi ~$ gcc -o dht22 dht22.c -lwiringPi
pi@raspberrypi ~$ sudo ./dht22 
Humidity = 56.60 % Temperature = 25.80 *C 
Humidity = 56.30 % Temperature = 25.80 *C 
Humidity = 56.10 % Temperature = 25.80 *C 
{% endhighlight %}

