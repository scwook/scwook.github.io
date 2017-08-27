---
layout: post
title: "ChannelFinder Installation Guide"
show: true
language:
  - en
  - kr
categories: EPICS
---

# 1. Introduction

# 2. Requirements

For the ChannelFinder configuration

* [Java SE 8]()
* [Elasticsearch 1.7.3](https://www.elastic.co/products/elasticsearch)
* Glassfish 4.1.2
* ChannelFinder Web Application 3.0.1
* [Python Client Library](https://github.com/ChannelFinder/pyCFClient)
* [Record Synchronizer Server](https://github.com/ChannelFinder/recsync)

For the EPICS client configuration and test

* [EPICS 3.14.12.5]()
* [Record Synchronizer Client](https://github.com/ChannelFinder/recsync)
* [CS-Studio v4.4.2]()

# 3. Server Installation

### 3.1 Requirements Package

설치에 앞서 필요한 기본 Package를 설치한다.

<pre>
root@debian~# aptitude update
root@debian~# aptitude install git curl python-setuptools python-twisted python-nose
</pre>

### 3.2 Java

ChannelFinder는 3.0.1버전을 기준으로 JDK8 이상만 지원하고 있다. 만약 설치된 Java의 버전이 맞지 않을 경우 [Java Installation in Debian Jessie](({{site.url}}/linux/2016/05/25/Java-installation-in-debian-jessie-kr.html))를 참고하여 JDK8 이상으로 설치하도록 한다.

<pre>
scwook@debian:~/Download$ java -version
java version "1.8.0_60"
Java(TM) SE Runtime Environment (build 1.8.0_60-b27)
Java HotSpot(TM) 64-Bit Server VM (build 25.60-b23, mixed mode)
</pre>

### 3.3 Elasticsearch

Elasticsearch는 [Download Page]() 또는 wget을 통해 다운 받을 수 있다.

<pre>
root@debian:~# wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.7.3.deb 
</pre>

**dpkg** 명령으로 다운받은 Debian Package 파일을 설치한다.

<pre>
root@debian:~# dpkg -i --force-confnew elasticsearch-1.7.3.deb
</pre>

설치가 완료되면 */etc/elasticsearch/elasticsearch.yml* 파일과 */etc/elasticsearch/indexed.yml* 파일에 'script.inline: on' 설정을 추가한다.

<pre>
root@debian:~# echo "script.inline: on" | tee -a /etc/elasticsearch/elasticsearch.yml
root@debian:~# echo "script.inline: on" | tee -a /etc/elasticsearch/indexed.yml
</pre>

설정이 완료되면 서버를 실행 한다.

<pre>
root@debian:~# /etc/init.d/elasticsearch start
</pre>

ChannelFinder를 위한 Index와 Field를 생성한다. 

<pre>
scwook@debian:~$ git clone https://github.com/ChannelFinder/ChannelFinderService.git
scwook@debian:~$ bash ChannelFinder/channelfinder/src/main/resources/mapping_definitions.sh
</pre>

**curl** 명령으로 생성된 Index와 Field를 확인할 수 있다.

<pre>
scwook@debian:~$ curl -XGET http://localhost:9200/channelfinder
{"channelfinder":{"aliases":{},"mappings":{"channel":{"properties":{"name":{"type":"string","analyzer":"whitespace"},"owner":{"type":"string","analyzer":"whitespace"},"properties":{"type":"nested","include_in_parent":true,"properties":{"name":{"type":"string","analyzer":"whitespace"},"owner":{"type":"string"},"value":{"type":"string","analyzer":"whitespace"}}},"script":{"type":"string"},"tags":{"type":"nested","include_in_parent":true,"properties":{"name":{"type":"string","analyzer":"whitespace"},"owner":{"type":"string","analyzer":"whitespace"}}}}}},"settings":{"index":{"creation_date":"1499317774205","number_of_shards":"5","number_of_replicas":"1","version":{"created":"1070399"},"uuid":"4PY7DDuqRnCVTJFApOM01A"}},"warmers":{}}}
</pre>

### 3.4 Glassfish
Glassfish 설치는 [Glassfish Installation in Debian Jessie](/linux/2016/05/30/glassfish-installation-in-debian-jessie-kr.html) 를 참고한다.

*Common Tasks - Configurations - Server-config - Security - Realms* 메뉴에서 *New* 버튼을 눌러 다음과 같이 설정한다.

* Name: channelfinder
* Class Name: com.sun.enterprise.security.auth.realm.file.FileRealm
* JAAS Context: fileRealm
* Key File: ${com.sun.aas.instanceRoot}/config/cf_keyfile

![Create New Realm for ChannelFinder]({{site.url}}/images/glassfish_channelfinder_realms.png)

앞서 생성한 *channelfinder* 를 선택한 후 *Manage Users* 버튼을 눌러 사용자를 추가한다.

* User ID: scwook
* Group List: cf-admins

Deploy를 위한 ChannelFinder Web Application 파일은 [ChannelFinder Download Page]( https://sourceforge.net/projects/channelfinder/files/ChannelFinder/ChannelFinder-3.0.1.tar.gz/download)에서 받을 수 있다.

<pre>
scwook@debian:~$ wget https://sourceforge.net/projects/channelfinder/files/ChannelFinder/ChannelFinder-3.0.1.tar.gz/
scwook@debian:~$ tar xvf ChannelFinder-3.0.1.tar.gz
scwook@debian:~$ ls ChannelFinder/war
ChannelFinder.war
</pre>

*Common Tasks - Applications* 를 선택한 후 Web Application 파일을 Deploy 한다.

![Deploy ChannelFinder Web Application]({{site.url}}/images/glassfish_channelfinder_deploy.png)

성공적으로 Deploy가 완료되면 아래와 같이 ChannelFinder Web Site를 확인 할 수 있다.

![ChannelFinder Embedded Web Site]({{site.url}}/images/channelfinder_server_web_page.png)

### 3.5 Python Client Library

git으로 부터 ChannelFinder를 사용하기 위한 Python Client Library를 받은 후 설치한다.

<pre>
root@debian:~$ git clone https://github.com/ChannelFinder/pyCFClient
root@debian:~$ cd pyCFClient
root@debian:/pyCFClient# python setup.py build
root@debian:/pyCFClient# python setup.py install
</pre>

*channelfinderapi.conf* 파일을 */etc* 폴더 아래에 생성한 후 Glassfish에 등록된 ChannelFinder 사용자 정보와 주소를 추가한다.

<pre>
[DEFAULT]
BaseURL=https://localhost:8181/ChannelFinder
username=scwook
password=1234
</pre>

### 3.6 Record Synchronizer Server

Record Synchronizer는 현재 작동중인 IOC의 Record정보를 Server로 정송하는 Client와 Client로 부터 받은 모든 Record 리스트를 Database로 Upload하는 Server로 구성되어 있다.

Server는 Python기반 네트워크 엔진인 Twisted로 작동하며, 실행 방법은 아래와 같다.

<pre>
scwook@debian:~$ git clone https://github.com/ChannelFinder/recsync
scwook@debian:~$ cd recsync/server
scwook@debian:~/recsync/server$ twistd -r poll -n recceiver -f cf.conf
Removing stale pidfile /home/scwook/service-module/channelfinder/recsync/server/twistd.pid
2017-06-30 17:09:44+0900 [-] Log opened.
2017-06-30 17:09:44+0900 [-] twistd 14.0.2 (/usr/bin/python 2.7.9) starting up.
2017-06-30 17:09:44+0900 [-] reactor class: twisted.internet.pollreactor.PollReactor.
2017-06-30 17:09:44+0900 [-] Starting
2017-06-30 17:09:44+0900 [-] CastFactory starting on 55254
2017-06-30 17:09:44+0900 [-] Starting factory <recceiver.recast.CastFactory instance at 0x7f3ed7243638>
2017-06-30 17:09:44+0900 [-] CastFactory starting on 36055
2017-06-30 17:09:44+0900 [-] listening on IPv4Address(TCP, '0.0.0.0', 36055)
2017-06-30 17:09:44+0900 [-] Announcer starting on 48050
2017-06-30 17:09:44+0900 [-] Starting protocol <recceiver.announce.Announcer instance at 0x7f3ed4f99f38>
</pre>

# 4. Client Installation
*recsync/client* 폴더로 이동 후 *configuration/RELEASE* 파일에 EPICS Base 위치를 지정한다.

<pre>
TEMPLATE_TOP=$(EPICS_BASE)/templates/makeBaseApp/top

<span class="insert">EPICS_BASE=/home/scwook/epics/R3.12.14.5/base</span>
</pre>

Debug Build를 해재하기 위해 *configuration/CONFIG_SITE* 파일에 TARGET ARCHS를 주석 처리한다.

<pre>
<span class="insert">#CROSS_COMPILER_TARGET_ARCHS = $(EPICS_HOST_ARCH)-debug</span>
</pre>
 
iocBoot/iocdemo/Makefile 파일에 ARCH를 현재 사용중인 OS의 Architecture로 변경한다. Architecture는 **uname -sm** 명령으로 확인 할 수 있다.

<pre>
scwook@debian:~/ChannelFinder/recsync/client$ uname -sm
Linux x86_64
</pre>

<pre>
TOP = ../..
include $(TOP)/configure/CONFIG
<span class="insert">ARCH = linux-x86_64</span>
TARGETS = envPaths
include $(TOP)/configure/RULES.ioc
</pre>

상위 폴더에서 make 실행을 통해 castApp과 demoApp을 build 한다.

<pre>
scwook@debian:~/ChannelFinder/recsync/client$ make
</pre>

Build가 완료되면 *lib* 폴더 아래에 reccaster library가 생성된다. 기본적으로 현재 사용중인 EPICS IOC에 reccaster library를 추가하면 자동으로 Record 정보가 Server로 전송되고 ChannelFinder를 통해 검색할 수 있다.
<pre>
scwook@debian:~/ChannelFinder/recsync/client$ ls lib/linux-x86_64/
libreccaster.a  libreccaster.so  libreccaster.so.0
</pre>

기본적인 테스트는 *iocBoot/iocdemo/st.cmd* 파일을 실행하면 된다.

<pre>
scwook@debian:~/ChannelFinder/recsync/client$ cd iocBoot/iocdemo
scwook@debian:~/ChannelFinder/recsync/client/iocBoot/iocdemo$ ./st.cmd
</pre>


아래는 새로운 IOC를 생성한 후 reccaster library를 추가하는 방법에 대해 설명하였다. 

HOME 아래 *cfTest* 폴더를 만들고 **makeBaseApp.pl** 스크립트로 기본 IOC Application을 생성한다.
<pre>
scwook@debian:~$ mkdir cfTest && cd cfTest
scwook@debian:~/cfTest$ makeBaseApp.pl -t ioc cfTest
scwook@debian:~/cfTest$ makeBaseApp.pl -i -t ioc cfTest
Using target architecture linux-x86_64 (only one available)
The following applications are available:
    cfTest
What application should the IOC(s) boot?
The default uses the IOC's name, even if not listed above.
Application name? cfTest
</pre>

*cfTestApp/src/Makefile*에 reccaster dbd와 library를 추가한다.

<pre>
TOP=../..

include $(TOP)/configure/CONFIG

<span class="insert">USR_DBDFLAGS += -I/home/scwook/ChannelFinder/recsync/client/dbd
reccaster_DIR += /home/scwook/ChannelFinder/recsync/client/lib/linux-x86_64</span>

PROD_IOC = cfTest
# cfTest.dbd will be created and installed
DBD += cfTest.dbd

# cfTest.dbd will be made up from these files:
cfTest_DBD += base.dbd

# Include dbd files from all support applications:
<span class="insert">cfTest_DBD += reccaster.dbd</span>

# Add all the support libraries needed by this IOC
<span class="insert">cfTest_LIBS += reccaster</span>

# cfTest_registerRecordDeviceDriver.cpp derives from cfTest.dbd
cfTest_SRCS += cfTest_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
cfTest_SRCS_DEFAULT += cfTestMain.cpp
cfTest_SRCS_vxWorks += -nil-

# Finally link to the EPICS Base libraries
cfTest_LIBS += $(EPICS_BASE_IOC_LIBS)

include $(TOP)/configure/RULES
</pre>

테스트를 위해 *cfTestApp/Db* 아래에 cfTest.db 파일을 만들고 아래와 같은 Record를 추가한다.

<pre>
record(bi, "CF:bi")
{
  field(DESC, "bi Example")
  field(INP, "0")
  field(PINI, "YES")
}

record(ai, "CF:ai")
{
  field(DESC, "ai Example")
  field(INP, "3.1415")
  field(PINI, "YES")
}

record(calc, "CF:calc")
{
  field(DESC, "calc Example")
  field(SCAN, "1 second")
  field(CALC, "RNDM")
}
</pre>

*Db* 아래에 있는 Makefile에 앞서 생성한 cfTest.db 파일을 추가한다.
 
<pre>
TOP=../..
include $(TOP)/configure/CONFIG

<span class="insert">DB += test.db</span>

include $(TOP)/configure/RULES
</pre>

TOP 폴더로 이동 후 make를 실행한다.

<pre>
scwook@debian:~/cfTest$ make
</pre>

*iocBoot/ioccfTest* 아래에 있는 st.cmd 파일에 앞서 생성한 cfTest.db 파일을 추가한다.

<pre>
#!../../bin/linux-x86_64/cfTest

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/cfTest.dbd"
cfTest_registerRecordDeviceDriver pdbbase

## Load record instances
<span class="insert">dbLoadRecords("db/test.db")</span>

cd "${TOP}/iocBoot/${IOC}"
iocInit
</pre>

st.cmd 파일을 실행한다.

<pre>
scwook@debian:~/cfTest/iocBoot/ioccfTest$ chmod +x st.cmd
scwook@debian:~/cfTest/iocBoot/ioccfTest$ ./st.cmd
</pre>

![ChannelFinder Web Access]({{site.url}}/images/channelfinder_web_channels.png)

![CS-Studio ChannelFinder Configuration]({{site.url}}/images/channelfinder_css_config.png)

![CS-Studio Channel Viewer]({{site.rul}}/images/channelfinder_css_channelviewer.png)

<br />
<hr>

# Toubleshooting

<span class="problem">Problem 1</span>
