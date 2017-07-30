---
layout: post
title: "EPICS Installation Guide"
show: true
language:
  - en
  - kr
categories: EPICS
---
This post describe how to install the EPICS based on Linux, Windows and iOS.

# 1. Introduction

This is a `highlight`

This is a [link]({{site.url}}/raspberrypi/2016/05/20/wiringPi-installation-en.html)

# 3. Installation

### 3.1 Linux

Linux에서 EPICS를 설치하기 위한 환경은 다음과 같다.

* Linux Debian Wheezy or Jessie
* EPICS base R3.14.12 or R3.15.1
* Requirement Package: libreadline-dev 

EPICS base에 필요한 기본 Package를 설치한다.

{% highlight shell %}
root@debian:~# aptitude install libreadline-dev
{% endhighlight %}

EPICS는 [EPICS Base ](http://www.aps.anl.gov/epics/base/R3-14/12.php)에서 받을 수 있다. 다운받은 파일의 압축을 해제하고 make를 실행한다.

{% highlight shell %}
scwook@debian:~/Downloads$ tar xvf baseR3.14.12.5.tar.gz -C ~/
scwook@debian:~/Downloads$ cd ~/base-3.14.12.5
scwook@debian:~/base-3.14.12.15$ make
{% endhighlight %}

### 3.2 Windows

### 3.3 iOS

This is a ![Image]({{site.url}}/images/image.png)

{% highlight c linenos %}
This is a code block with line numbers
{% endhighlight %}

{% highlight shell %}
This is a code block without line numbers
{% endhighlight %}

Toubleshooting
==============

# A. Touble Title

# B. Touble Title
