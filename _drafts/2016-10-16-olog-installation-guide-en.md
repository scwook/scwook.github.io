---
layout: post
title: "Olog Installation Guide"
show: true
language:
  - en
  - kr
categories: EPICS
---

# 1. Introduction

This is a `highlight`

# 2. Requirements

* Debian Jessie 64bit(or 32bit) Kenel 3.16.0
* Glassfish v3.1.2.2
* MySql 5.5
* Olog Service v2.2.6
* Olog Web Client v0.5-beta

# 3.Installation

# 3.1 MySql

MySql은 Debian 기본 Package에 포함되어 있으며 `aptitude` 명령으로 설치 할 수 있다.

{% hightlight shell %}
root@debian:~# aptitude install mysql-server-5.5
{% endhighlight %}

MySql에서 사용할 root 비밀번호를 설정하고 Ok를 누른다.

[MySql root password setting]({{site.url}}/images/mysql_install_passwd_setting.png)

### Create Database
Olog 사용을 위한 MySql Database Table은 다음과 같다.

* attributes
* entries
* logbooks
* logs
* logs_attributes
* logs_logbooks
* properties
* schema_version
* subscriptions

Database 생성을 위해 MySql에 로그인 한 후 Database를 생성한다.

{% hightlight shell %}
scwook@debain:~$ mysql -u root -p
Enter password: 

mysql> source /home/scwook/Downloads/olog_scheme.sql;
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| olog               |
| performance_schema |
+--------------------+
3 rows in set (0.00 sec)

mysql> use olog;
mysql> show tables;
+-----------------+
| Tables_in_olog  |
+-----------------+
| attributes      |
| entries         |
| logbooks        |
| logs            |
| logs_attributes |
| logs_logbooks   |
| properties      |
| schema_version  |
| subscriptions   |
+-----------------+
9 rows in set (0.00 sec)

mysql> exit
{% endhighlight %}

# 3.2 Glassfish
Glassfish 설치는 [Glassfish Installation in Debian Jessie](/linux/2016/05/30/glassfish-installation-in-debian-jessie-kr.html) 포트스를 참고한다. 현재 Olog Service는 버전 2.2.6 기준으로 Glassfish v3 이하만 지원한다.

### MySql Connector J
Java 기반의 Olog Service와 MySql을 연동하기 위해서는 JDBC(Java Database Connectivity) AIP가 필요하다. MySql Connector Java는 [MySql Download](https://dev.mysql.com/downloads/connector/j/) 홈페이지에서 받을 수 있다. 홈페이지 접속 후 TAR Archive 파일을 다운 받는다.

![Download MySql Connector J]({{site.url}}/images/mysql_connectorJ_download.png)

다운 받은 파일의 압축을 해제하고 `mysql-connector-java-5.1.38-bin.jar` 파일을 glassfish library 폴더에 복사한다.

{% hightlight shell %}
root@debain:~/Downloads# tar xvf mysql-connector-java-5.1.38.tar.gz
root@debain:~/Downloads# cd mysql-connector-java-5.1.38
root@debain:~/Downloads# cp mysql-connector-java-5.1.38-bin.jar /opt/glassfish3/glassfish/lib
{% endhighlight %}

### JDBC Connection Pool 생성
Glassfish 서버에 접속 후 Common Task - Resources - JDBC - JDBC Connection Pool 메뉴를 선택한다.
New 버튼을 눌러 다음과 같이 설정한다.

* Pool Name: OlogPool
* Resource Type: javax.sql.ConnectionPoolDataSource
* Datasource Classname:  com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource

![Crate Olog JDBC Connection Pool]({{site.url}}/images/glassfish_olog_jdbc_connection_pool.png)

Additional Properties에 다음 속성을 추가한다.

* databaseName - olog
* serverName - localhost
* user - root
* password - [mysql root password] 

![Olog Connection Pool Properties]({{site.url}}/images/glassfish_olog_connection_pool_properties.png)

### JDBC Resource 생성
Common Tasks - Resources - JDBC - JDBC Resources 메뉴를 선택한다.
New 버튼을 눌러 다음과 같이 설정한다.

* JNDL Name: jdbc/olog
* Pool Name: OlogPool

![Crate Olog JDBC Resources]({{site.url}}/images/glassfish_olog_jdbc_resources.png)

### Realm 추가
Common Tasks - Configurations - Server-config - Security - Realms 메뉴를 선택한다.
New 버튼을 눌러 다음과 같이 설정한다.

* Name: olog
* Class Name: com.sun.enterprise.security.auth.realm.file.FileRealm
* JAAS Context: fileRealm
* Key File: ${com.sun.aas.instanceRoot}/config/olog_keyfile

![Crate Realms]({{site.url}}/images/glassfish_olog_realms.png)

### 사용자 추가
Olog Service는 olog-admins 그룹과 olog-logs 그룹으로 구별되어 있다. olog-admins 그룹은 기본적인 Log작성 외에 Logbook 및 Tag 생성 및 삭제를 할 수 있으며, olog-logs 그룹은 일반 사용자로서 Log 작성 권한만 가지고 있다. 사용자 추가를 위해 Common Tasks - Configurations - Server-config - Security - Realms - olog 선택한다.

Manage Users를 클릭하고 사용자를 추가한다.

* User ID: [사용자 ID]
* Group List: [olog-admins 또는 olog-logs]

![Add Olog User]({{site.url}}/images/glassfish_olog_add_user.png)

# 3.3 Olog Service

### Download
Olog Service 파일은 [Olog Web Page](https://sourceforge.net/projects/olog/files)에서 다운 받을 수 있다. Linux의 경우 `wget` 명령을 사용하여 다음과 같이 다운 받을 수 있다.

{% highlight shell %}
scwook@debian:~/Downloads$ wget https://sourceforge.net/projects/olog/files/Rel_2-2-6/Olog_2-2-6.tar.gz
{% endhighlight %}

다운받은 파일의 압축을 해제한다.

{% highlight shell %}
scwook@debian:~/Downloads$ tar xvf Olog_2-2-6.tar.gz
scwook@debian:~/Downloads$ ls
OlogAPI-2.2.6.jar          OlogAPI-2.2.6-sources.jar
OlogAPI-2.2.6-javadoc.jar  olog-service-2.2.6.war
{% endhighlight %}

### Deploy
Common Tasks - Applications 메뉴를 선택한다.
Deploy 버튼을 눌러 다음과 같이 설정한다.

* Location: olog-service-2.2.6.war
* Type: Web Application
* Context Root: olog
* Application Name: olog-service-2.2.6

![Olog Service Deploy]({{site.url}}/images/glassfish_olog_service_deploy.png)

# 3.4 Olog Web Client

This is a [link]({{site.url}}/raspberrypi/2016/05/20/wiringPi-installation-en.html)

This is a ![Image]({{site.url}}/images/image.png)

{% hightlight c linenos %}
This is a code block with line numbers
{% endhighlight %}

{% hightlight shell %}
This is a code block without line numbers
{% endhighlight %}

Toubleshooting
==============

### A. JDBC Connection Pools Error
JDBC Connection Pools 생성시 다음과 같은 에러가 발생할 경우 `crate-jdbc-connection-pool` shell 명령으로 생성한다.




### B. Touble Title
