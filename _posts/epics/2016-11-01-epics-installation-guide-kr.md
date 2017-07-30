---
layout: post
title: "EPICS Installation Guide"
language:
  - en
  - kr
categories: EPICS
---
이 포스트에서는 Linux 및 Windows, macOS에서 EPICS를 설치하는 방법에 대해 기술하였다.

# 1. Introduction


# 2. Installation

### 3.1 Linux

Linux에서 EPICS를 설치하기 위한 환경은 다음과 같다.

* Linux Debian Wheezy or Jessie
* EPICS base R3.14.12 or R3.15.1
* Requirement Package: libreadline-dev 

EPICS base에 필요한 기본 Package를 설치한다.

<pre>
root@debian:~# aptitude install libreadline-dev
</pre>

EPICS는 [EPICS Base ](http://www.aps.anl.gov/epics/base/R3-14/12.php)에서 받을 수 있다. 다운받은 파일의 압축을 해제하고 make를 실행한다.

<pre>
scwook@debian:~/Downloads$ tar xvf baseR3.14.12.5.tar.gz -C ~/
scwook@debian:~/Downloads$ cd ~/base-3.14.12.5
scwook@debian:~/base-3.14.12.15$ make
</pre>

Home폴더의 .bashrc 파일에 아래와 같이 EPICS PATH 설정을 한다.

<pre>
export PATH=$PATH:/home/scwook/base-3.14.12.15/bin/linux-x86_64
</pre>

IOC 테스트는 [EPICS IOC Test](#1)를 참고한다.

### 3.2 Windows

* Windows7 or Windows10
* EPICS base R3.14.12 or R3.15.1
* 7-zip(http://www.7-zip.org/download.html)
* Perl for Windows(ActiveState)(https://www.activestate.com/activeperl/downloads)
* Minimalist GNU for Windows(MinGW)(http://www.mingw.org/wiki/Getting_Started)


<pre>
C:\Users\scwook>cd Downloads\base-3.14.12.5
C:\Users\scwook\Downloads\base-3.14.12.5> make
</pre>
### 3.3 iOS

Mac 환경에서 EPICS설치는 기본적으로 Linux와 동일 하다.

* OS X Yosemite or macOS Sierra
* EPICS base R3.14.12 or R3.15.1

EPICS는 [EPICS Base ](http://www.aps.anl.gov/epics/base/R3-14/12.php)에서 받을 수 있다. 다운받
은 파일의 압축을 해제하고 make를 실행한다.

<pre>
scwook-iMac:Downloads scwook$ tar xvf baseR3.14.12.5.tar.gz -C ~/
scwook-iMac:Downloads scwook$ cd ~/base-3.14.12.5
scwook-iMac:base-3.14.12.5 scwook$ make
</pre>

Home폴더의 .bash_profile에 아래와 같이 EPICS PATH 설정을 한다.

<pre>
export PATH=$PATH:/Users/ctrluser/base-3.14.12.5/bin/darwin-x86
</pre>

IOC 테스트는 [EPICS IOC Test](#1)를 참고한다.

# <a name="1"></a>3. EPICS IOC Test

EPICS IOC를 테스트하기 위해 아래와 같이 test.db 파일에 Random 값을 계산하는 calc Record를 만든다.

<pre>
record(calc, "My-FirstRecord") {
  field(SCAN, "1 second")
  field(CALC, "RNDM")
  field(PREC, "3")
}
</pre>

**softIoc** 명령으로 test.db를 Load하고 IOC를 실행한다.

<pre>
scwook@debian:~$ softIoc -d test.db
Starting iocInit
############################################################################
## EPICS R3.14.12.5 $Date: Tue 2015-03-24 09:57:35 -0500$
## EPICS Base built Sep 23 2015
############################################################################
iocRun: All initialization complete
epics>
</pre>

Record 값은 **caget** 명령으로 확인 할 수 있다.

<pre>
scwook@debian:~$ caget My-FirstRecord
My-FirstRecord                 0.881773
</pre>

또는 IOC Shell에서 **dbpr** 명령으로 읽을 수 있다.

<pre>
epics> dbpr My-FirstRecord
A: 0                ASG:                B: 0                C: 0                
CALC: RNDM          D: 0                DESC:               DISA: 0             
DISP: 0             DISV: 1             E: 0                F: 0                
G: 0                H: 0                I: 0                J: 0                
K: 0                L: 0                NAME: My-FirstRecord                    
SEVR: NO_ALARM      STAT: NO_ALARM      TPRO: 0             
VAL: 0.29761196307317              
</pre>
<br />
<hr>

# Toubleshooting

# A. Touble Title

# B. Touble Title
