---
layout: post
title:  "Java Installation in Debian Jessie"
language:
  - en
  - kr
categories: Linux
---
**update-alternatives** 명령을 사용하면 새 버전의 Java를 설치할 수 있다. 우선, 현재 Java 버전을 먼저 확인한다.

<pre>
scwook@debian:~$ java -version
openjdk version "1.8.0_72-internal"
OpenJDK Runtime Environment (build 1.8.0_72-internal-b15)
OpenJDK 64-Bit Server VM (build 25.72-b15, mixed mode)
</pre>


[Oracle download web page](http://www.oracle.com/technetwork/java/javase/downloads/index.html)에서 설치하고자 하는 Java를 다운받은 후 압축을 해재 한다.

<pre>
root@debian:~/Download# tar xvf jdk-8u91-linux-x64.tar.gz -C /opt/
</pre>

`--install` 옵션으로 새 버전의 Java를 설치한다.

<pre>
root@debian:~/Download# update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_91/bin/java 1500
root@debian:~/Download# update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_91/bin/javac 1500
</pre>

`--config` 옵션으로 설치된 Java 버전으로 변경한다.

<pre>
root@debian:~/Download# update-alternatives --config java
There are 2 choices for the alternative java (providing /usr/bin/java).
  Selection    Path                                            Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1069      auto mode
  1            /opt/jdk1.8.0_91/bin/java                        1         manual mode
  2            /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1069      manual mode
Press enter to keep the current choice[*], or type selection number: 1
</pre>

이제 새로운 Java로 변경된 것을 확인 할 수 있다.

<pre>
root@debian:~/Download# java -version
java version "1.8.0_91"
Java(TM) SE Runtime Environment (build 1.8.0_91-b14)

Java HotSpot(TM) 64-Bit Server VM (build 25.91-b14, mixed mode)
</pre>
