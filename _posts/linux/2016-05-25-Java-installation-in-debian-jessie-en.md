---
layout: post
title: "Java Installation in Debian Jessie"
show: true
language:
  - en
  - kr
categories: Linux
---
Using **update-alternatives** command, you can add new Java version in the Jessie. First, check current Java version.

<pre>
scwook@debian:~$ java -version
openjdk version "1.8.0_72-internal"
OpenJDK Runtime Environment (build 1.8.0_72-internal-b15)
OpenJDK 64-Bit Server VM (build 25.72-b15, mixed mode)
</pre>

Download new Java version form the [Oracle download web page](http://www.oracle.com/technetwork/java/javase/downloads/index.html) and uncompressing.

<pre>
root@debian:~/Download# tar xvf jdk-8u91-linux-x64.tar.gz -C /opt/
</pre>

Register new Java with `--install` option

<pre>
root@debian:~/Download# update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_91/bin/java 1500
root@debian:~/Download# update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_91/bin/javac 1500
</pre>

Change Java version with `--config` option

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

Now you have new Java.

<pre>
root@debian:~/Download# java -version
java version "1.8.0_91"
Java(TM) SE Runtime Environment (build 1.8.0_91-b14)

Java HotSpot(TM) 64-Bit Server VM (build 25.91-b14, mixed mode)
</pre>
