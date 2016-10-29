---
layout: post
title:  "Glassfish Installation in Debian Jessie"
language:
  - en
  - kr
categories: Linux
---
Glassfish를 설치하기전 Java 버전을 먼저 확인한다. Glassfish V3의 경우 JDK 1.7 버전을 Glassfish V4의 경우 JDK 1.8 버전을 필요로 한다.

{% highlight shell %}
scwook@debian:~$ java -version
java version "1.8.0_91"
Java(TM) SE Runtime Environment (build 1.8.0_91-b14)
Java HotSpot(TM) 64-Bit Server VM (build 25.91-b14, mixed mode)
{% endhighlight shell %}

새 버전의 Java를 설치해야 할 경우 [Java Installation in Debian Jessie](/linux/2016/05/25/Java-installation-in-debian-jessie-kr.html) 포스트를 참고한다.

Glassfish V3
-------------
Glassfish V3는 [Oracle download web page](http://www.oracle.com/technetwork/java/javaee/downloads/index.html)에서 다운받을 수 있다.
다운 받을 파일을 superuser로 실행한다.

{% highlight shell %}
root@debian:/Downloads# bash ogs-3.1.2.2-unix.sh
{% endhighlight shell %}

설치 메뉴가 나타나면 next를 누른다.

![Glassfish Installtion Start Up Menu]({{site.url}}/images/glassfish_inst_capture_1.png)

Typical Installation을 선택하고 Next를 누른다.

![Glassfish Installtion Select Type]({{site.url}}/images/glassfish_inst_capture_2.png)

설치 경로를 /opt/glassfish3로 변경한 후 Next를 누른다.

![Glassfish Installtion Select Install Directory]({{site.url}}/images/glassfish_inst_capture_3.png)

Install Update Tool과 Enable Update Tool를 선택한다. Update Tool설치에 대한 옵션이므로 꼭 선택할 필요는 없다.

![Glassfish Installtion Select Options]({{site.url}}/images/glassfish_inst_capture_4.png)

Install 버튼을 누르고 설치를 시작한다.

![Glassfish Installtion Ready To Install]({{site.url}}/images/glassfish_inst_capture_5.png)

설치가 끝난 후 Domain Info 메뉴가 나타난다. 관리자 비밀번호만 설정하고 나머지는 기본 설정으로 둔다. 설정이 완료되었으면 Next를 누른다.

![Glassfish Installtion Domain Info]({{site.url}}/images/glassfish_inst_capture_6.png)

Exit를 눌러 모든 설치를 완료한다.

![Glassfish Installtion Summary]({{site.url}}/images/glassfish_inst_capture_7.png)

테스트를 위해 웹 브라우저를 실행한 후 주소창에 localhost 또는 서버 ip 주소를 넣고 접속한다.

http://localhost:4848 or http://[Server IP Address]:4848

### Glassfish V4

Glassfish V4는 [Glassfish Download Page](https://glassfish.java.net/download.html)에서 다운받을 수 있다.

![Glassfish V4 Download Page]({{site.url}}/images/glassfishv4_web_page_capture.png)

다운받은 파일의 압축을 해제한 후 glassfish demon을 실행한다.

{% highlight shell %}
root@debian:~# unzip glassfish-4.1.1.zip -d /opt/
root@debian:~# cd /opt/glassfish4/bin/
root@debian:/opt/glassfish4/bin# ./asadmin start-domain
Waiting for domain1 to start ...
Successfully started the domain : domain1
domain  Location: /opt/glassfish4/glassfish/domains/domain1
Log File: /opt/glassfish4/glassfish/domains/domain1/logs/server.log
Admin Port: 4848
Command start-domain executed successfully.
{% endhighlight shell %}

테스트를 위해 웹 브라우저를 실행한 후 주소창에 localhost 또는 서버 ip 주소를 넣고 접속한다.

http://localhost:4848 or http://[Server IP Address]:4848

관리자 비밀번호는 `change-admin-password` 명령어로 설정할 수 있다.

{% highlight shell %}
root@debian:/opt/glassfish4/bin# ./asadmin change-admin-password
Enter admin user name [default: admin]>admin

Enter the admin password> [Just remain empty]
Enter the new admin password> [New Password] 
Enter the new admin password again> [New Password]
{% endhighlight shell %}

Toubleshooting
==============

### Problem 1
원격에서 서버로 접속할 때 다음과 같은 에러 메세지가 나올경우
If the following error message show up when you try to access to glassfish server remotely.

![Glassfish V4 Download Page]({{site.url}}/images/glassfish_remote_login.png)

Secure Admin Access를 활성화 한다.

{% highlight shell %}
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
{% endhighlight shell %}

### Problem 2
`start-domain`을 실행할 때 다음과 같은 에러메세지가 나올 경우

{% highlight shell %}
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
{% endhighlight shell %}

Java Version을 확인한다.

{% highlight shell %}
scwook@debian:~$ java -version
java version "1.8.0_60"
Java(TM) SE Runtime Environment (build 1.8.0_60-b27)
Java HotSpot(TM) 64-Bit Server VM (build 25.60-b23, mixed mode)
{% endhighlight shell %}

* Glassfish V3 -> JDK 1.7
* Glassfish V4 -> JDK 1.8

### Problem 3
JAVA_HOME PATH 에러가 발생할 경우

{% highlight shell %}
Could not locate a suitable jar utility.
Please ensure that you have Java 6 or newer installed on your system and accessible in your PATH or by setting JAVA_HOME
{% endhighlight shell %}

2가지 해결방법이 있다.

* JAVA_HOME 경로를 직접 지정해 준다.
{% highlight shell %}root@debian:~# export JAVA_HOME=/opt/jdk1.7.0_79{% endhighlight shell %}
* java-wrapper package를 설치한다.
{% highlight shell %}root@debian:~# aptitude install java-wrappers{% endhighlight shell %}

