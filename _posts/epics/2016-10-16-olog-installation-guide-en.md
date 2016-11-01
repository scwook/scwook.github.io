---
layout: post
title: "Olog Installation Guide"
show: true
language:
  - en
  - kr
categories: EPICS
---
This post describe how to install and configure the Olog which is logbook system used in particle accelerator facility.

# 1. Introduction
[Olog(Operator Log)](http://olog.github.io/2.2.7-SNAPSHOT/) is a Web Application Log System using REST(Representational State Transfer). Specially the Olog can be used with the [CS-Studio](http://controlsystemstudio.org/) which is the [EIPCS](http://www.aps.anl.gov/epics/) based control and monitoring tool. 

# 2. System Requirements
Olog is distributed a WAR(Web application ARchiver) file and need following system environments.

* Java 6 or Java 7 
* MySql Server
* Web Application Server(Glassfish3 or Apache Tomcat)

In this post, the test system is as follow. All servers are installed in a one PC and its IP address is 10.1.5.88.

* Debian Jessie 64bit Kernel 3.16.0
* Glassfish v3.1.2.2
* MySql Server 5.5
* Olog Service v2.2.6
* Olog Web Client v0.5-beta
* CS-Studio v4.3.2

# 3. Requirements Package Installation

# 3.1 Java
Currently, The Olog Service based version 2.2.6 support only the Java JDK 6 or 7. If your system doesn't satisfy these Java version, Please refer to the [Java Installation in Debian Jessie]({{site.url}}/linux/2016/05/25/Java-installation-in-debian-jessie-kr.html) post to install a new Java version. 

{% highlight shell %}
scwook@debian:~/Download$ java -version
java version "1.7.0_80"
Java(TM) SE Runtime Environment (build 1.7.0_80-b15)
Java HotSpot(TM) 64-Bit Server VM (build 24.80-b11, mixed mode)
{% endhighlight %}

# 3.2 MySql Server
MySql Server can be installed by using `aptitude` command. If you are using OS other than Linux, you have to install MySql Server form [MySql Download Page](http://www.mysql.com/downloads)

{% highlight shell %}
root@debian:~# aptitude install mysql-server-5.5
{% endhighlight %}

Configure default root password and click Ok button.

![MySql root password setting]({{site.url}}/images/mysql_install_passwd_setting.png)

### Create Database
The structure of the Olog database is as follows.

![Olog Database Schema]({{site.url}}/images/olog_db_schema.png)

In order to create the database, Login to MySql Server.

{% highlight shell %}
scwook@debain:~$ mysql -u root -p
Enter password: 
{% endhighlight %}

The Olog database and table can be create by using the MySql query command or you can use [Olog Scheme Script]({{site.url}}/archive/olog_scheme.sql) script file.

{% highlight shell %}
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
Currently, The Olog Service based version 2.2.6 support only the Glassfish v3. If you need to install the Glassfish, Please refer to the [Glassfish Installation in Debian Jessie](/linux/2016/05/30/glassfish-installation-in-debian-jessie-kr.html) post.

### MySql Connector J
To use Java based the Olog Service with MySql, JDBC(Java Database Connectivity) API is required. MySql Connector Java can be downloaded in [MySql Download](https://dev.mysql.com/downloads/connector/j/) page. On the website, download a TAR Archive file.

![Download MySql Connector J]({{site.url}}/images/mysql_connectorJ_download.png)

Uncompress file and copy `mysql-connector-java-5.1.38-bin.jar` to glassfish library directory.

{% highlight shell %}
root@debain:~/Downloads# tar xvf mysql-connector-java-5.1.38.tar.gz
root@debain:~/Downloads# cd mysql-connector-java-5.1.38
root@debain:~/Downloads# cp mysql-connector-java-5.1.38-bin.jar /opt/glassfish3/glassfish/lib
{% endhighlight %}

### Crate JDBC Connection Pool
On the Glassfish Server, Select Common Task - Resources - JDBC - JDBC Connection Pool
Click New button and set up properties as following. 

* Pool Name: OlogPool
* Resource Type: javax.sql.ConnectionPoolDataSource
* Datasource Classname:  com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource

![Crate Olog JDBC Connection Pool]({{site.url}}/images/glassfish_olog_jdbc_connection_pool.png)

Add Name and Value properties in the Additional Properties menu.

* Name: databaseName, Value: olog
* Name: serverName, Value: localhost
* Name: user, Value: root [mysql user name]
* Name: password, Value: 1234 [mysql root password] 

![Olog Connection Pool Properties]({{site.url}}/images/glassfish_olog_connection_pool_properties.png)

### Crate JDBC Resource
Select Common Tasks - Resources - JDBC - JDBC Resources
Click New button and set up JNDL and Pool names.

* JNDL Name: jdbc/olog
* Pool Name: OlogPool

![Crate Olog JDBC Resources]({{site.url}}/images/glassfish_olog_jdbc_resources.png)

### Crate Realm
Select Common Tasks - Configurations - Server-config - Security - Realms
Click New button and set up properties as following. 

* Name: olog
* Class Name: com.sun.enterprise.security.auth.realm.file.FileRealm
* JAAS Context: fileRealm
* Key File: ${com.sun.aas.instanceRoot}/config/olog_keyfile

![Crate Realms]({{site.url}}/images/glassfish_olog_realms.png)

### Add User
Olog Service consist of two user group which are olog-logs and olog-admins. These two group have write permission in commonly and only olog-admins group can manage Logbook and Tag lists. 

To add new users, select Common Tasks - Configurations - Server-config - Security - Realms - olog.
Click the Manage Users and add user informations.

* User ID: [user ID to use Olog Service]
* Group List: [olog-admins or olog-logs]

![Add Olog User]({{site.url}}/images/glassfish_olog_add_user.png)

# 3.3 Olog Service

### Download
Olog Service file can be found in [Olog Web Page](https://sourceforge.net/projects/olog/files). In case of Linux OS, can more easily download by using `wget` command.

{% highlight shell %}
scwook@debian:~/Downloads$ wget https://sourceforge.net/projects/olog/files/Rel_2-2-6/Olog_2-2-6.tar.gz
{% endhighlight %}

Uncompress the file.

{% highlight shell %}
scwook@debian:~/Downloads$ tar xvf Olog_2-2-6.tar.gz
scwook@debian:~/Downloads$ ls
OlogAPI-2.2.6.jar          OlogAPI-2.2.6-sources.jar
OlogAPI-2.2.6-javadoc.jar  olog-service-2.2.6.war
{% endhighlight %}

### Deploy
Select Common Tasks - Applications.
Click Deploy button and select olog-service war file.

* Location: olog-service-2.2.6.war
* Type: Web Application
* Context Root: olog
* Application Name: olog-service-2.2.6

![Olog Service Deploy]({{site.url}}/images/glassfish_olog_service_deploy.png)

# 3.5 Olog Web Client
In order to use the Olog Service, basically, the Web Client tool is provided. In this post will show how to make log entry by using the Web Client and CS-Studio.
  
### Web Client
Download the [Olog Web Client](https://github.com/Olog/logbook/releases) on the website or by using `wget` command.

{% highlight shell %}
scwook@debain:~/Downloads# wget https://github.com/Olog/logbook/archive/v0.5-beta.tar.gz
scwook@debain:~/Downloads# tar xvf v0.5-beta.tar.gz
{% endhighlight %}

Open the configuration.js file located at /Olog/public_html/static/js and change the serviceurl to the Olog Service address.

{% highlight shell %}
scwook@debain:~/Downloads# cd logbook-0.5-beta/Olog/public_html/static/js
scwook@debian:~/Downloads/logbook-0.5-beta/Olog/public_html/static/js$ vi configuration.js
{% endhighlight %}

{% highlight shell %}
// For accessing the REST service
var serviceurl = "https://10.1.5.88:8181/Olog/resources/";
{% endhighlight %}

Run index.html file with a web browser.

{% highlight shell %}
scwook@debian:~\$ firefox logbook-0.5-beta\Olog\index.html
{% endhighlight %}

![Web Client v0.5 beta]({{site.url}}/images/olog_web_client.png)

### CS-Studio Client
[Control System Studio(CS-Studio)](http://controlsystemstudio.org/) is an Eclipse-based collection of tools to monitor and operate large scale control systems. If you are using site-specific CS-Studio such as the RAON CS-Studio, it must be included the Olog Entry Module or you can make your own CS-Studio from source code. Please refer to [CS-Studio git repository](https://github.com/ControlSystemStudio) to get source code and build procedure. 

Open Edit-Preferences and enter the Olog Service URL. If you want to assign default user, Check use authentication and enter username and password. Click the apply button and restart the CS-Studio.
 
![CS-Studio Olog Settings]({{site.url}}/images/css_olog_settings.png)

You can write log entry in Log Entry Menu. Open CSS-Utilities - Create Log Entry. Enter User Name and Password and write your log.

![CS-Studio Log Entry]({{site.url}}/images/css_log_entry.png)

