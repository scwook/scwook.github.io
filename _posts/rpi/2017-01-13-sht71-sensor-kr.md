---
layout: post
title: "SHT71 Sensor Test"
language:
  - en
  - kr
categories: RaspberryPi
---
SHT71센서는 [DHT22]({{site.url}}//raspberrypi/2016/09/22/dht22-sensor.kr.html)보다 높은 정확성을 가지는 온습도 센서이다. 자세한 센서정보는 SENSIRION사의 [SHT7x](https://www.sensirion.com/kr/environmental-sensors/humidity-sensors/pintype-digital-humidity-sensors/)를 참고한다.

### Component

* Raspberry Pi 2 Model B
* [SHT71](https://www.digikey.com/product-detail/en/sensirion-ag/SHT71/1649-1013-ND/5872295)

![SHT71 Test Circuit]({{site.url}}/images/rpi_sht71_test.png)

### Enable I2C Interface

SHT71센서는 온습도 정보를 I2C Interface를 통해 전송한다. 따라서 Raspberry Pi의 I2C 사용을 할 수 있

### Source Code
