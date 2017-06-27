---
layout: post
title: "Olog Installation Guide"
language:
  - en
  - kr
categories: EPICS
---
# 1. Introduction
[Olog(Operator Log)](http://olog.github.io/2.2.7-SNAPSHOT/)는 Java 기반의 Web Application Log 시스템으로
REST 방식을 사용하는 Log Tool이다. 특히 Olog는 [EIPCS](http://www.aps.anl.gov/epics/) 기반 제어시스템 도구인 [CS-Studio](http://controlsystemstudio.org/)와 연동하여 사용할 수 있다.

# 2. System Requirements
Olog는 WAR(Web application ARchiver)파일로 제공되며 다음 시스템 환경을 필요로 한다.

* Java 6 또는 Java 7
* MySql Server
* Web Application Server(Glassfish3 또는 Apache Tomcat)

여기에서 진행된 테스트 환경은 다음과 같다. 모든 서버는 하나의 PC에 설치되어 있으며 IP주소는 10.1.5.88로 설정되어 있다.

* Debian Jessie 64bit Kernel 3.16.0
* Glassfish v3.1.2.2
* MySql Server 5.5
* Olog Service v2.2.6
* Olog Web Client v0.5-beta
* CS-Studio v4.3.2

# 3. Requirements Package Installation

# 3.1 Java
현재 사용가능한 Java는 Olog Service v2.2.6을 기준으로 JDK 7버전 이하만 지원하고 있다. 만약 설치된 Java의 버전이 맞지 않을 경우 [Java Installation in Debian Jessie]({{site.url}}/linux/2016/05/25/Java-installation-in-debian-jessie-kr.html)를 참고하여 새로운 Java를 설치하기 바란다.

{% highlight console %}
scwook@debian:~/Download$ java -version
java version "1.7.0_80"
Java(TM) SE Runtime Environment (build 1.7.0_80-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.80-b11, mixed mode)
{% endhighlight %}

# 3.2 MySql Server
MySql Server는 `aptitude` 명령으로 간단히 설치 할 수 있다. Linux 이외의 OS를 사용하는 경우 [MySql Download Page](http://www.mysql.com/downloads)에서 설치파일을 다운받아 설치한다.

{% highlight console %}
root@debian:~# aptitude install mysql-server-5.5
{% endhighlight %}

MySql에서 사용할 root 비밀번호를 설정하고 Ok를 누른다.

![MySql root password setting]({{site.url}}/images/mysql_install_passwd_setting.png)

### Create Database
Olog의 Database 구조는 다음과 같다.

![Olog Database Schema]({{site.url}}/images/olog_db_schema.png)

Database 생성을 위해 MySql에 로그인 한다.

{% highlight console %}
scwook@debain:~$ mysql -u root -p
Enter password: 
{% endhighlight %}

Database 및 Table 생성은 MySql Query명령을 통해 직접 만들 수 있지만 [Olog Scheme Script]({{site.url}}/archive/olog_scheme.sql)파일을 실행하면 간단히 만들 수 있다.

{% highlight console %}
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

# 3.3 Glassfish
Glassfish 설치는 [Glassfish Installation in Debian Jessie](/linux/2016/05/30/glassfish-installation-in-debian-jessie-kr.html) 포트스를 참고한다. 현재 Olog Service는 버전 2.2.6 기준으로 Glassfish v3 이하만 지원한다.

### MySql Connector J
Java 기반의 Olog Service와 MySql을 연동하기 위해서는 JDBC(Java Database Connectivity) API가 필요하다. MySql Connector Java는 [MySql Download](https://dev.mysql.com/downloads/connector/j/) 홈페이지에서 받을 수 있다. 홈페이지 접속 후 TAR Archive 파일을 다운 받는다.

![Download MySql Connector J]({{site.url}}/images/mysql_connectorJ_download.png)

다운 받은 파일의 압축을 해제하고 `mysql-connector-java-5.1.38-bin.jar` 파일을 glassfish library 폴더에 복사한다.

{% highlight console %}
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

Additional Properties에 있는 Name과 Value값을 다음과 같이 추가한다.

* Name: databaseName, Value: olog
* Name: serverName, Value: localhost
* Name: user, Value: root [mysql user name]
* Name: password, Value: 1234 [mysql root password] 

![Olog Connection Pool Properties]({{site.url}}/images/glassfish_olog_connection_pool_properties.png)

### JDBC Resource 생성
Common Tasks - Resources - JDBC - JDBC Resources 메뉴를 선택한다.
New 버튼을 눌러 다음과 같이 설정한다.

* JNDL Name: jdbc/olog
* Pool Name: OlogPool

![Crate Olog JDBC Resources]({{site.url}}/images/glassfish_olog_jdbc_resources.png)

### Realm 생성
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

{% highlight console %}
scwook@debian:~/Downloads$ wget https://sourceforge.net/projects/olog/files/Rel_2-2-6/Olog_2-2-6.tar.gz
{% endhighlight %}

다운받은 파일의 압축을 해제한다.

{% highlight console %}
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

# 3.5 Olog Web Client
Olog는 기본적으로 Web Client Tool을 제공하고 있다. 여기서는 Olog Web Client와 CS-Studio에 있는 Log Entry Tool을 이용한 Log작성법에 대해 설명하였다.

### Web Client
[Olog Web Client Download Page](https://github.com/Olog/logbook/releases)또는 `wget`명령으로 최신 버전의 Client를 다운 받은 후 압축을 해제한다.

{% highlight console %}
scwook@debain:~/Downloads# wget https://github.com/Olog/logbook/archive/v0.5-beta.tar.gz
scwook@debain:~/Downloads# tar xvf v0.5-beta.tar.gz
{% endhighlight %}

Olog/public_html/static/configuration.js 파일을 열어 serviceurl값을 Olog Service 주소로 설정한다.

{% highlight console %}
scwook@debain:~/Downloads# cd logbook-0.5-beta/Olog/public_html/static/js
scwook@debian:~/Downloads/logbook-0.5-beta/Olog/public_html/static/js$ vi configuration.js
{% endhighlight %}

{% highlight console %}
// For accessing the REST service
var serviceurl = "https://10.1.5.88:8181/Olog/resources/";
{% endhighlight %}

접속은 Web Browser를 이용하여 index.html 파일을 열면 된다.

{% highlight console %}
scwook@debian:~\$ firefox logbook-0.5-beta\Olog\index.html
{% endhighlight %}

![Web Client v0.5 beta]({{site.url}}/images/olog_web_client.png)

### CS-Studio Client
Edit-Preferences를 실행한다. Preferences창에서 CSS Core-Logbook을 선택한 후 Olog Service 주소를 입력 한다. 기본 Log작성 사용자를 설정하고 싶은 경우 Olog에 등록된 사용자와 비밀번호를 username과 password에 입력한다. Apply 버튼을 누른 후 CS-Studio를 재시작 한다.

![CS-Studio Olog Settings]({{site.url}}/images/css_olog_settings.png)

로그 작성은 Log Entry 메뉴에서 할 수 있다. CSS-Utilities-Create Log Entry를 실행한다. Olog 사용자와 비밀번호를 입력하고 Log를 작성한다.

![CS-Studio Log Entry]({{site.url}}/images/css_log_entry.png)

