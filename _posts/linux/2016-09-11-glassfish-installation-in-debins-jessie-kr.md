---
layout: post
title:  "Glassfish Installation in Debian Jessie"
language:
  - en
  - kr
categories: Linux
draft: true
---
Before installation of the glassfish, make sure of java version. the Glassfish V3 need the JDK 1.7.0 and the Glassfish V4 need the JDK 1.8.0.

~~~
scwook@debian:~$ java -version
java version "1.8.0_91"
Java(TM) SE Runtime Environment (build 1.8.0_91-b14)
Java HotSpot(TM) 64-Bit Server VM (build 25.91-b14, mixed mode)
~~~
If you need to install the new Java, Please refer to `Java Installation in Debian Jessie`

Glassfish V3
-------------
Glassfish V3 can be downloaded from the [Oracle download web page](http://www.oracle.com/technetwork/java/javaee/downloads/index.html).
Run the file as superuser.

~~~
root@debian:/Downloads# bash ogs-3.1.2.2-unix.sh
~~~
When installation menu show up, Click next.

![Glassfish Installtion Start Up Menu]({{site.url}}/images/glassfish_inst_capture_1.png)

Select the Typical Installation and click next.

![Glassfish Installtion Select Type]({{site.url}}/images/glassfish_inst_capture_2.png)

Change the Installation Directory to /opt/glassfish3 and click next.

![Glassfish Installtion Select Install Directory]({{site.url}}/images/glassfish_inst_capture_3.png)

Check the Install Update Tool and Enable Update Tool. This is options. You don't have to select options if you want.

![Glassfish Installtion Select Options]({{site.url}}/images/glassfish_inst_capture_4.png)

Click next to start installation.

![Glassfish Installtion Ready To Install]({{site.url}}/images/glassfish_inst_capture_5.png)

After finish installation, Domain Info menu show up. Set the administrator password and leave the default settings. Click next.

![Glassfish Installtion Domain Info]({{site.url}}/images/glassfish_inst_capture_6.png)

Installation is completed. Click exit.

![Glassfish Installtion Summary]({{site.url}}/images/glassfish_inst_capture_7.png)

In order to test, Try pointing your browser to localhost or server ip address.

http://localhost:4848 or http://[Server IP Address]:4848

### Glassfish V4

Glassfish V4 can be downloaded form the [Glassfish Download Page](https://glassfish.java.net/download.html).

![Glassfish V4 Download Page]({{site.url}}/images/glassfishv4_web_page_capture.png)

Extract the zip file and run the glassfish demon.

~~~
root@debian:~# unzip glassfish-4.1.1.zip -d /opt/
root@debian:~# cd /opt/glassfish4/bin/
root@debian:/opt/glassfish4/bin# ./asadmin start-domain
Waiting for domain1 to start ...
Successfully started the domain : domain1
domain  Location: /opt/glassfish4/glassfish/domains/domain1
Log File: /opt/glassfish4/glassfish/domains/domain1/logs/server.log
Admin Port: 4848
Command start-domain executed successfully.
~~~
In order to test, Try pointing your browser to localhost or server ip address.

http://localhost:4848 or http://[Server IP Address]:4848

The admin password can be modified by change-admin-password command.

~~~
root@debian:/opt/glassfish4/bin# ./asadmin change-admin-password
Enter admin user name [default: admin]>admin

Enter the admin password> [Just remain empty]
Enter the new admin password> [New Password] 
Enter the new admin password again> [New Password]
~~~

* * *

Touble Shooting
===============

Problem
--------
If the following error message show up when you try to access to glassfish server remotely.

![Glassfish V4 Download Page]({{site.url}}/images/glassfish_remote_login.png)

Solution
--------
Enable the Secure Admin Access.

~~~
root@debian:/opt/glassfish4/bin# ./asadmin enable-secure-admin
Enter admin user name>  admin
Enter admin password for user "admin"> 
You must restart all running servers for the change in secure admin to take effect.
Command enable-secure-admin executed successfully.
root@debian:/opt/glassfish4/bin# ./asadmin stop-domain
Waiting for the domain to stop .
Command stop-domain executed successfully.
root@debian:/opt/glassfish4/bin# ./asadmin start-domain
Waiting for domain1 to start ....
Successfully started the domain : domain1
domain  Location: /opt/glassfish4/glassfish/domains/domain1
Log File: /opt/glassfish4/glassfish/domains/domain1/logs/server.log
Admin Port: 4848
Command start-domain executed successfully.
root@debian:/opt/glassfish4/bin# 
~~~

Problem
-------
If following error message show up when you try the start-domain.

~~~
Waiting for domain1 to start .Error starting domain domain1.
The server exited prematurely with exit code 1.
Before it died, it produced the following output:
Launching GlassFish on Felix platform

ERROR: Error parsing system bundle export statement: org.osgi.framework; version=1.6.0, org.osgi.framework.launch; version=1.0.0, org.osgi.framework.wiring; version=1.0.0, org.osgi.framework.startlevel; version=1.0.0, org.osgi.framework.hooks.bundle; version=1.0.0, org.osgi.framework.hooks.resolver; version=1.0.0, org.osgi.framework.hooks.service; version=1.1.0, org.osgi.framework.hooks.weaving; version=1.0.0, org.osgi.service.packageadmin; version=1.2.0, org.osgi.service.startlevel; version=1.1.0, org.osgi.service.url; version=1.0.0, org.osgi.util.tracker; version=1.5.0, , org.glassfish.embeddable;org.glassfish.embeddable.spi;version=3.1.1 (org.osgi.framework.BundleException: Exported package names cannot be zero length.)

ERROR: Bundle jaxb-api [1] Error starting file:/opt/glassfish3/glassfish/modules/endorsed/jaxb-api-osgi.jar (org.osgi.framework.BundleException: Unresolved constraint in bundle jaxb-api [1]: Unable to resolve 1.0: missing requirement [1.0] osgi.wiring.package; (osgi.wiring.package=javax.activation))

ERROR: Bundle org.glassfish.metro.webservices-api-osgi [3] Error starting file:/opt/glassfish3/glassfish/modules/endorsed/webservices-api-osgi.jar (org.osgi.framework.BundleException: Unresolved constraint in bundle org.glassfish.metro.webservices-api-osgi [3]: Unable to resolve 3.0: missing requirement [3.0] osgi.wiring.package; (&(osgi.wiring.package=javax.xml.bind)(version>=2.2.0)) [caused by: Unable to resolve 1.0: missing requirement [1.0] osgi.wiring.package; (osgi.wiring.package=javax.activation)])

ERROR: Bundle org.glassfish.hk2.osgi-adapter [57] Error starting file:/opt/glassfish3/glassfish/modules/osgi-adapter.jar (org.osgi.framework.BundleException: Unresolved constraint in bundle org.glassfish.hk2.osgi-adapter [57]: Unable to resolve 57.0: missing requirement [57.0] osgi.wiring.package; (&(osgi.wiring.package=com.sun.enterprise.module)(version>=1.1.0)) [caused by: Unable to resolve 35.0: missing requirement [35.0] osgi.wiring.package; (&(osgi.wiring.package=org.jvnet.hk2.config)(version>=1.1.0)) [caused by: Unable to resolve 8.0: missing requirement [8.0] osgi.wiring.package; (osgi.wiring.package=javax.management)]])

ERROR: Bundle org.glassfish.main.core.glassfish [164] Error starting file:/opt/glassfish3/glassfish/modules/glassfish.jar (org.osgi.framework.BundleException: Activator start error in bundle org.glassfish.main.core.glassfish [164].)

Java HotSpot(TM) 64-Bit Server VM warning: ignoring option MaxPermSize=192m; support was removed in 8.0

Java HotSpot(TM) 64-Bit Server VM warning: ignoring option PermSize=64m; support was removed in 8.0
~~~

Solution
--------
Check Java Version
~~~
scwook@debian:~$ java -version
java version "1.8.0_60"
Java(TM) SE Runtime Environment (build 1.8.0_60-b27)
Java HotSpot(TM) 64-Bit Server VM (build 25.60-b23, mixed mode)
~~~
Glassfish V3 -> JDK 1.7
Glassfish V4 -> JDK 1.8

Problem
-------
If you have face the problem for JAVA_HOME PATH error.
~~~
Could not locate a suitable jar utility.
Please ensure that you have Java 6 or newer installed on your system and accessible in your PATH or by setting JAVA_HOME
~~~

Solution
--------
There are two solutions.
1. Point to JAVA_HOME path manually.
~~~
root@debian:~# export JAVA_HOME=/opt/jdk1.7.0_79
~~~
2. Install the java-wrapper package.
~~~
root@debian:~# aptitude install java-wrappers
~~~
