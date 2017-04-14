---
layout: post
title: "SHT71 Sensor Test"
language:
  - en
  - kr
categories: RaspberryPi
---
SHT71 temperature & humidity sensor is a more high sensitive sensor than [DHT22]({{site.url}}/raspberrypi/2016/09/22/dht22-sensor.kr.html). More detailed information of SHT71 sensor can be founded in [SHT7x](https://www.sensirion.com/kr/environmental-sensors/humidity-sensors/pintype-digital-humidity-sensors/)

### Component

* Raspberry Pi 2 Model B
* [SHT71](https://www.digikey.com/product-detail/en/sensirion-ag/SHT71/1649-1013-ND/5872295)

![SHT71 Test Circuit]({{site.url}}/images/rpi_sht71_test.png)

### Enable I2C Interface

SHT71 sensor use I2C interface of raspberry pi. To enalbe I2C of raspberry pi, Please refer to [I2C Configuration of Raspberry Pi]({{site.url}}/raspberrypi/2017/04/13/i2c-configuration-kr.html)

### Source Code

기본 코드는 아래 사이트의 코드를 사용했으며 wiringPi Library에 맞게 변경하였다.

[https://www.john.geek.nz/2012/08/reading-data-from-a-sensirion-sht1x-with-a-raspberry-pi](https://www.john.geek.nz/2012/08/reading-data-from-a-sensirion-sht1x-with-a-raspberry-pi/)

filename: testSHT1x.c

{% highlight c linenos %}
//SHT71 Sensor Test code
//filename: testSHT1x.c

// Compile with: gcc -o testSHT1x ./../bcm2835-1.3/src/bcm2835.c ./RPi_SHT1x.c testSHT1x.c

/*
Raspberry Pi SHT1x communication library.
By:      John Burns (www.john.geek.nz)
Date:    14 August 2012
License: CC BY-SA v3.0 - http://creativecommons.org/licenses/by-sa/3.0/

This is a derivative work based on
        Name: Nice Guy SHT11 library
        By: Daesung Kim
        Date: 04/04/2011
        Source: http://www.theniceguy.net/2722

Dependencies:
        BCM2835 Raspberry Pi GPIO Library - http://www.open.com.au/mikem/bcm2835/

Sensor:
        Sensirion SHT11 Temperature and Humidity Sensor interfaced to Raspberry Pi GPIO port

SHT pins:
        1. GND  - Connected to GPIO Port P1-06 (Ground)
        2. DATA - Connected via a 10k pullup resistor to GPIO Port P1-01 (3V3 Power)
        2. DATA - Connected to GPIO Port P1-18 (GPIO 24)
        3. SCK  - Connected to GPIO Port P1-16 (GPIO 23)
        4. VDD  - Connected to GPIO Port P1-01 (3V3 Power)

Note:
        GPIO Pins can be changed in the Defines of RPi_SHT1x.h
*/

#include "RPi_SHT1x.h"

void printTempAndHumidity(void)
{
        unsigned char noError = 1;
        value humi_val,temp_val;

        int spin = 4;
        int dpin = 5;
        // Wait at least 11ms after power-up (chapter 3.1)
        delay(20);

        // Set up the SHT1x Data and Clock Pins
        SHT1x_InitPins(spin, dpin);

        // Reset the SHT1x
        SHT1x_Reset(spin, dpin);

        // Request Temperature measurement
        noError = SHT1x_Measure_Start( spin, dpin ,SHT1xMeaT );
        if (!noError) {
                printf("Measure Start Error1\n");
                return;
                }
        // Read Temperature measurement
        noError = SHT1x_Get_Measure_Value( spin, dpin, (unsigned short int*) &temp_val.i );
        if (!noError) {
                printf("Measure Value Error1\n");
                return;
                }

        // Request Humidity Measurement
        noError = SHT1x_Measure_Start( spin, dpin, SHT1xMeaRh );
        if (!noError) {
                printf("Measure Start Error2\n");
                return;
                }

        // Read Humidity measurement
        noError = SHT1x_Get_Measure_Value( spin, dpin, (unsigned short int*) &humi_val.i );
        if (!noError) {
                printf("Measure Value Error2\n");
                return;
                }

        // Convert intergers to float and calculate true values
        temp_val.f = (float)temp_val.i;
        humi_val.f = (float)humi_val.i;

        // Calculate Temperature and Humidity
        SHT1x_Calc(&humi_val.f, &temp_val.f);

        //Print the Temperature to the console
        printf("Temperature: %0.2f%cC  ",temp_val.f,0x00B0);

        //Print the Humidity to the console
        printf("Humidity: %0.2f%%\n",humi_val.f);

}
int main ()
{
        //Initialise the Raspberry Pi GPIO
        if(wiringPiSetup() == -1)
        {
                printf("wiringPi Init Error\n");
                return 1;
        }

        while(1)
        {
                printTempAndHumidity();
                delay(1000);
        }

        return 1;
}
{% endhighlight}

{% highlight c linenos %}
// SHT71 Sensor Test Code
// filename: RPi_SHT1x.h

/*
Raspberry Pi SHT1x communication library.
By:      John Burns (www.john.geek.nz)
Date:    14 August 2012
License: CC BY-SA v3.0 - http://creativecommons.org/licenses/by-sa/3.0/

This is a derivative work based on
        Name: Nice Guy SHT11 library
        By: Daesung Kim
        Date: 04/04/2011
        Source: http://www.theniceguy.net/2722
*/

#ifndef RPI_SHT1x_H_
#define RPI_SHT1x_H_

// Includes
#include <wiringPi.h>
#include <stdio.h>

// Defines
#define TRUE    1
#define FALSE   0

#define SHT1x_DELAY delayMicroseconds(2)

/* Definitions of all known SHT1x commands */
#define SHT1x_MEAS_T    0x03                    // Start measuring of temperature.
#define SHT1x_MEAS_RH   0x05                    // Start measuring of humidity.
#define SHT1x_STATUS_R  0x07                    // Read status register.
#define SHT1x_STATUS_W  0x06                    // Write status register.
#define SHT1x_RESET     0x1E                    // Perform a sensor soft reset.
/* Definitions of all known SHT1x commands */
#define SHT1x_MEAS_T    0x03                    // Start measuring of temperature.
#define SHT1x_MEAS_RH   0x05                    // Start measuring of humidity.
#define SHT1x_STATUS_R  0x07                    // Read status register.
#define SHT1x_STATUS_W  0x06                    // Write status register.
#define SHT1x_RESET     0x1E                    // Perform a sensor soft reset.

/* Enum to select between temperature and humidity measuring */
typedef enum _SHT1xMeasureType {
        SHT1xMeaT       = SHT1x_MEAS_T,         // Temperature
        SHT1xMeaRh      = SHT1x_MEAS_RH         // Humidity
} SHT1xMeasureType;

typedef union 
{
        unsigned short int i;
        float f;
} value;

/* Public Functions ----------------------------------------------------------- */
void SHT1x_Transmission_Start( int spin, int dpin );
unsigned char SHT1x_Readbyte( int spin, int dpin, unsigned char sendAck );
unsigned char SHT1x_Sendbyte( int spin, int dpin, unsigned char value );
void SHT1x_InitPins( int spin, int dpin );
unsigned char SHT1x_Measure_Start( int spin, int dpin, SHT1xMeasureType type );
unsigned char SHT1x_Get_Measure_Value(int spin, int dpin, unsigned short int * value );
void SHT1x_Reset(int spin, int dpin);
unsigned char SHT1x_Mirrorbyte(unsigned char value);
void SHT1x_Xrc_check(int pin, unsigned char value);
void SHT1x_Calc(float *p_humidity ,float *p_temperature);
#endif
{% endhighlight}

### Test

컴파일 후 프로그램을 실행한다.
{% highlight shell %}
pi@raspberrypi ~$ gcc -o sht71 testSHT1x.c RPi_SHT.c -lwiringPi
pi@raspberrypi ~$ sudo ./sht71
{% endhighlight %}
