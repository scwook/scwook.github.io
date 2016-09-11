---
layout: post
title:  "Glassfish Installation in Debian Jessie"
---
Before installation of the glassfish, make sure of java version. the Glassfish V3 need the JDK 1.7.0 and the Glassfish V4 need the JDK 1.8.0.

```shell
scwook@debian:~$ java -version
java version "1.8.0_91"
Java(TM) SE Runtime Environment (build 1.8.0_91-b14)
Java HotSpot(TM) 64-Bit Server VM (build 25.91-b14, mixed mode)
```
If you need to install the new Java, Please refer to `Java Installation in Debian Jessie`

### Glassfish V3

Glassfish V3 can be downloaded from the [Oracle download web page](http://www.oracle.com/technetwork/java/javaee/downloads/index.html).
Run the file as superuser.

```shell
root@debian:/Downloads# bash ogs-3.1.2.2-unix.sh
```
When installation menu show up, Click next.

![Glassfish Installtion Start Up Menu]({{site.url}}/images/glassfish_inst_capture_1.png)
