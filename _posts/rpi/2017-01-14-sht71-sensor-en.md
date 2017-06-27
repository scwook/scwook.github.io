---
layout: post
title: "SHT71 Sensor Test"
show: true
language:
  - en
  - kr
categories: RaspberryPi
---
SHT71 is a temperature and humidity sensor with small size and low power consumption. Basic specifications of the sensor are as follow and More detailed information can be founded in [SHT7x](https://www.sensirion.com/kr/environmental-sensors/humidity-sensors/pintype-digital-humidity-sensors/).

* Humidity Accuracy [%RH]: ±3
* Temperature [℃]: ±0.4
* Supply Voltage [V]: 2.4 to 5.5
* Interface: Digital SBus (I2C)

In order to test, [WiringPi]({{site.url}}/raspberrypi/2016/05/20/wiringPi-installation-en.html) and [I2C]({{site.url}}/raspberrypi/2017/04/13/i2c-configuration-en.html) are must be configured.

### Component

* Raspberry Pi 2 Model B
* [SHT71](https://www.digikey.com/product-detail/en/sensirion-ag/SHT71/1649-1013-ND/5872295)

![SHT71 Test Circuit]({{site.url}}/images/rpi_sht71_test.png)

### Source Code

All this source code is based on following web site and I modified the code for wiringPi library.

[https://www.john.geek.nz/2012/08/reading-data-from-a-sensirion-sht1x-with-a-raspberry-pi](https://www.john.geek.nz/2012/08/reading-data-from-a-sensirion-sht1x-with-a-raspberry-pi/)

filename: testSHT1x.c

{% highlight c linenos %}
// Compile with: gcc -o testSHT1x ./../bcm2835-1.3/src/bcm2835.c ./RPi_SHT1x.c testSHT1x.c

// Compile with wiringPi: gcc -o sht71 testSHT1x.c RPi_SHT.c -lwiringPi

/*
Raspberry Pi SHT71
Modifyed By:	 Changwook Son
Date:		 04/14/2017

Dependencies: wiringPi v2.44 - http://wiringpi.com/

Sensor: Sensirion SHT71 Temperature and Humidity Sensor interfaced to Raspberry Pi I2C port

///////////////

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

	// Define Clock and Data Pins
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
{% endhighlight %}

filename: RPi_SHT1x.c

{% highlight c linenos %}
/*
Raspberry Pi SHT71
Modifyed By:     Changwook Son
Date:            04/14/2017

Dependencies: wiringPi v2.44 - http://wiringpi.com/

Sensor: Sensirion SHT71 Temperature and Humidity Sensor interfaced to Raspberry Pi I2C port

///////////////

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

#include "RPi_SHT1x.h"

/* Global variables of the SHT1x sensor */
unsigned char SHT1x_crc;
unsigned char SHT1x_status_reg = 0;

void SHT1x_Crc_Check(unsigned char value) 
{
        unsigned char i;

        for (i=8; i; i--)
        {
                if ((SHT1x_crc ^ value) & 0x80)
                {
                        SHT1x_crc «= 1;
                        SHT1x_crc ^= 0x31;
                }
                else
                {
                        SHT1x_crc «= 1;
                }
                value «=1;
        }
}
void SHT1x_InitPins( int spin, int dpin ) 
{
        int RPI_GPIO_SHT1x_SCK = spin;
        int RPI_GPIO_SHT1x_DATA = dpin;

        // SCK line as output but set to low first
                digitalWrite(RPI_GPIO_SHT1x_SCK, LOW);
                pinMode(RPI_GPIO_SHT1x_SCK, OUTPUT);
                digitalWrite(RPI_GPIO_SHT1x_SCK, LOW);

        // DATA to input. External pull up.
        // Set PORT to 0 => pull data line low by setting port as output
                pullUpDnControl(RPI_GPIO_SHT1x_DATA, PUD_OFF);
                digitalWrite(RPI_GPIO_SHT1x_DATA,LOW);
                pinMode(RPI_GPIO_SHT1x_DATA, OUTPUT);
                pullUpDnControl(RPI_GPIO_SHT1x_DATA, PUD_OFF);
                digitalWrite(RPI_GPIO_SHT1x_DATA,LOW);
}
void SHT1x_Reset(int spin, int dpin) 
{
        int RPI_GPIO_SHT1x_SCK = spin;
        int RPI_GPIO_SHT1x_DATA = dpin;

        // Chapter 3.4
        unsigned char i;
        pinMode(RPI_GPIO_SHT1x_DATA, INPUT);
        SHT1x_DELAY;
        for (i=9; i; i--)
        {
                digitalWrite(RPI_GPIO_SHT1x_SCK, HIGH); SHT1x_DELAY;
                digitalWrite(RPI_GPIO_SHT1x_SCK, LOW);  SHT1x_DELAY;
        }
        SHT1x_Transmission_Start(spin, dpin);
        SHT1x_Sendbyte(spin, dpin, SHT1x_RESET);  // Soft reset
}

void SHT1x_Transmission_Start( int spin, int dpin ) 
{
        int RPI_GPIO_SHT1x_SCK = spin;
        int RPI_GPIO_SHT1x_DATA = dpin;

        // Chapter 3.2
        digitalWrite(RPI_GPIO_SHT1x_SCK, HIGH); SHT1x_DELAY;
        digitalWrite(RPI_GPIO_SHT1x_DATA, LOW);
        pinMode(RPI_GPIO_SHT1x_DATA, OUTPUT);   SHT1x_DELAY;
        digitalWrite(RPI_GPIO_SHT1x_SCK, LOW);  SHT1x_DELAY;
        digitalWrite(RPI_GPIO_SHT1x_SCK, HIGH); SHT1x_DELAY;
        pinMode(RPI_GPIO_SHT1x_DATA, INPUT);    SHT1x_DELAY;
        digitalWrite(RPI_GPIO_SHT1x_SCK, LOW);  SHT1x_DELAY;

        // Reset crc calculation. Start value is the content of the status register.
        SHT1x_crc = SHT1x_Mirrorbyte( SHT1x_status_reg & 0x0F );
}

unsigned char SHT1x_Mirrorbyte(unsigned char value) 
{
        unsigned char ret=0, i;

        for (i=0x80; i ; i»=1)
        {
                if(value & 0x01)
                        ret |= i;

                value »= 1;
        }

        return ret;
}
unsigned char SHT1x_Readbyte( int spin, int dpin, unsigned char send_ack ) 
{
        int RPI_GPIO_SHT1x_SCK = spin;
        int RPI_GPIO_SHT1x_DATA = dpin;

        unsigned char mask;
        unsigned char value = 0;

        // SCK is low here !
        for(mask=0x80; mask; mask »= 1 )
        {
                digitalWrite(RPI_GPIO_SHT1x_SCK, HIGH); SHT1x_DELAY;    // SCK hi
                if( digitalRead(RPI_GPIO_SHT1x_DATA) != 0 )     // and read data
                        value |= mask;

                digitalWrite(RPI_GPIO_SHT1x_SCK, LOW);  SHT1x_DELAY; // SCK lo => sensor puts new data
        }

        /* send ACK if required */
        if ( send_ack )
        {
                digitalWrite(RPI_GPIO_SHT1x_DATA, LOW);
                pinMode(RPI_GPIO_SHT1x_DATA, OUTPUT);
                SHT1x_DELAY; // Get DATA line
        }

        digitalWrite(RPI_GPIO_SHT1x_SCK, HIGH); SHT1x_DELAY;    // give a clock pulse
        digitalWrite(RPI_GPIO_SHT1x_SCK, LOW);  SHT1x_DELAY; 

        if ( send_ack )
        {       // Release DATA line
                pinMode(RPI_GPIO_SHT1x_DATA, INPUT);    SHT1x_DELAY; 
        }

        return value;
}
unsigned char SHT1x_Sendbyte( int spin, int dpin, unsigned char value ) 
{
        int RPI_GPIO_SHT1x_SCK = spin;
        int RPI_GPIO_SHT1x_DATA = dpin;

        unsigned char mask;
        unsigned char ack;

        for(mask = 0x80; mask; mask»=1)
        {
                digitalWrite(RPI_GPIO_SHT1x_SCK, LOW);  SHT1x_DELAY;

                if( value & mask )
                {  
                        pinMode(RPI_GPIO_SHT1x_DATA, INPUT);    SHT1x_DELAY;
                }
                else
                {
                        digitalWrite(RPI_GPIO_SHT1x_DATA, LOW);
                        pinMode(RPI_GPIO_SHT1x_DATA, OUTPUT);
                        SHT1x_DELAY;
                }

                digitalWrite(RPI_GPIO_SHT1x_SCK, HIGH); SHT1x_DELAY;  // SCK hi =&qt; sensor reads data
        }
        digitalWrite(RPI_GPIO_SHT1x_SCK, LOW);  SHT1x_DELAY;

        // Release DATA line
        pinMode(RPI_GPIO_SHT1x_DATA, INPUT);    SHT1x_DELAY;
        digitalWrite(RPI_GPIO_SHT1x_SCK, HIGH); SHT1x_DELAY;

        ack = 0;

        if(!digitalRead(RPI_GPIO_SHT1x_DATA))
                ack = 1;

        digitalWrite(RPI_GPIO_SHT1x_SCK, LOW);  SHT1x_DELAY;

        SHT1x_Crc_Check(value);   // crc calculation

        return ack;
}
unsigned char SHT1x_Measure_Start( int spin, int dpin, SHT1xMeasureType type ) 
{
        // send a transmission start and reset crc calculation
        SHT1x_Transmission_Start(spin, dpin);
        // send command. Crc gets updated!
        return SHT1x_Sendbyte( spin, dpin, (unsigned char) type );
}
unsigned char SHT1x_Get_Measure_Value( int spin, int dpin, unsigned short int * value ) 
{
        int RPI_GPIO_SHT1x_SCK = spin;
        int RPI_GPIO_SHT1x_DATA = dpin;

        unsigned char * chPtr = (unsigned char*) value;
        unsigned char checksum;
        unsigned char delay_count=62;  /* delay is 62 * 5ms */

        /* Wait for measurement to complete (DATA pin gets LOW) */
        /* Raise an error after we waited 250ms without success (210ms + 15%) */
        while( digitalRead(RPI_GPIO_SHT1x_DATA) )
        {
                delayMicroseconds(5000);                        // 1 ms not working
        
                delay_count--;
                if (delay_count == 0)
                        return FALSE;
        }

        *(chPtr + 1) = SHT1x_Readbyte( spin, dpin, TRUE );  // read hi byte
        SHT1x_Crc_Check(*(chPtr + 1));                  // crc calculation
        *chPtr = SHT1x_Readbyte( spin, dpin, TRUE );            // read lo byte
        SHT1x_Crc_Check(* chPtr);                       // crc calculation

        checksum = SHT1x_Readbyte( spin, dpin, FALSE );   // crc calculation
        // compare it.
        return SHT1x_Mirrorbyte( checksum ) == SHT1x_crc ? TRUE : FALSE;
}
//----------------------------------------------------------------------------------------
void SHT1x_Calc(float *p_humidity ,float *p_temperature)
//----------------------------------------------------------------------------------------
{
        const float C1=-4.0;                            // for 12 Bit
        const float C2=+0.0405;                         // for 12 Bit
        const float C3=-0.0000028;                      // for 12 Bit
        const float T1=+0.01;                           // for 14 Bit @ 5V
        const float T2=+0.00008;                        // for 14 Bit @ 5V      

        float rh = *p_humidity;                 // rh:      Humidity [Ticks] 12 Bit 
        float t = *p_temperature;                       // t:       Temperature [Ticks] 14 Bit
        float rh_lin;                                   // rh_lin:  Humidity linear
        float rh_true;                                  // rh_true: Temperature compensated humidity
        float t_C;                                      // t_C   :  Temperature [C]

        t_C = t*0.01 - 40;                      // calc. temperature from ticks to [C]
        rh_lin = C3*rh*rh + C2*rh + C1;         // calc. humidity from ticks to [%RH]
        rh_true = (t_C-25)*(T1+T2*rh)+rh_lin;   // calc. temperature compensated humidity [%RH]
        if(rh_true>100) rh_true=100;                    // cut if the value is outside of
        if(rh_true<0.1) rh_true=0.1;                    // the physical possible range
        *p_temperature = t_C;                   // return temperature [C]
        *p_humidity = rh_true;                  // return humidity[%RH]
}
{% endhighlight %}

filename: RPi_SHT1x.h

{% highlight c linenos %}
/*
Raspberry Pi SHT71
Modifyed By:     Changwook Son
Date:            04/14/2017

Dependencies: wiringPi v2.44 - http://wiringpi.com/

Sensor: Sensirion SHT71 Temperature and Humidity Sensor interfaced to Raspberry Pi I2C port

///////////////

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
{% endhighlight %}

### Test

Compile and run the program.

{% highlight console %}
pi@raspberrypi ~$ gcc -o sht71 testSHT1x.c RPi_SHT.c -lwiringPi
pi@raspberrypi ~$ sudo ./sht71
{% endhighlight %}
