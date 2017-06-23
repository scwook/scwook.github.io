---
layout: post
title: "Control System Studio Web OPI Configuration"
language:
  - en
  - kr
categories: EPICS
---
# 1. Introduction
[WebOPI](https://github.com/ControlSystemStudio/cs-studio/wiki/webopi)는 [Control System Studio](http://controlsystemstudio.org/)(CS-Studio)에서 생성된 Operator Interface(OPI)를 web browser를 통해 제공해주는 도구이다. WebOPI는 기존의 CS-Studio에서 사용되는 Widget 및 Macros, Rules, JavaScript, Python Script등을 지원하므로 별도의 OPI를 만들 필요가 없으며, 따라서 이미 제작된 OPI를 그대로 사용할 수 있다. 또한 Web 기반으로 제공되므로 Local System에 별도의 CS-Studio를 설치할 필요없이 Web Browser로 접속 가능한 기기에서는 언제든지 쉽게 사용할 수 있다. 

WebOPI는 Web application ARchive(WAR)파일로 제공되므로 WAR파일을 Deploy 할 수 있는 Web Application Server가 필요하다. 여기에서는 [Glassfish](https://glassfish.java.net/)와 [Tomcat Server](http://tomcat.apache.org/)를 이용한 WebOPI 구성 방법을 설명하였다.

# 2. System Environments

테스트 환경은 아래와 같으며 Server의 IP주소는 10.1.5.83으로 설정되어 있다.

* Debian Jessie 64bit Kernel 3.16.0
* Glassfish v4.1.1 or Tomcat7
* WebOPI v3.3

# 3. Installation

WebOPI는 아래 Web Page에서 다운 받을 수 있으며 기본 설치 방법은 [WebOPI User Manual](http://htmlpreview.github.io/?https://github.com/ControlSystemStudio/cs-studio/blob/master/applications/opibuilder/opibuilder-plugins/org.csstudio.opibuilder.rap/html/WebOPI.html)을 참고하였다.

[WebOPI Download](http://ics-web.sns.ornl.gov/css/products.html)

# 3.1 Tomcat7

Tomcat이 설치되어 있지 않다면 아래와 같이 Tomcat을 먼저 설치한다.

{% highlight shell%}
root@debian:~# aptitude install tomcat7 tomcat7-admin
{% endhighlight %}

기본 Tomcat 서버포트인 **8080**으로 접속하면 아래와 같이 서버가 작동하는 것을 확인 할 수 있다.

![]()

Web Manager 접속을 위해 **/etc/tomcat7/**에 있는 **tomcat-users.xml**파일에 사용자를 추가해 준다.

<tomcat-users>

  <role rolename="manager-gui"/>
  <user username="scwook" password="1234" roles="manager-gui"/>

</tomcat-users>

사용자 추가 후 tomcat을 재시작 한다.

{% highlight shell %}
root@debian:~# service tomcat7 restart
{% endhighlight %}

Tomcat 서버에 접속 후 **manager webapps**을 누르면 로그인 화면이 나온다. 앞서 추가한 username과 password를 입력하면 Tomcat Web Application Manager로 접속 할 수 있다.

### Deploy


### Configure

### Web Access

# 3.2 Glassfish
Glassfish 설치는 [Glassfish Installation in Debian Jessie]({{site.url}}/linux/2016/05/30/glassfish-installation-in-debian-jessie-kr.html)를 참고한다.

### Deploy

### Configure

### Web Access

