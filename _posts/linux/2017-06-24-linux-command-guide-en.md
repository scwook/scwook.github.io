---
layout: post
title: "Linux Configuration Guide"
show: true
language:
  - en
  - kr
categories: Linux
---

Following command and configuration is based on debian linux.

1. [Write iso image on DVD](#1)
2. [Using Network Manager](#2)
3. [Glusterfs Configuration](#3)
4. [SAMBA Configuration](#4)
5. [FTP Configuration](#5)
6. [Invisible HDD while installation for debian](#6)
7. [Auto Login Configuration](#7)
8. [VirtualBox Guest Addation Installation](#8)
9. [Network Speed Test between two PCs](#9)
10. [Combine one video file form a number of images](#10)
11. [Modify Tomcat default port](#11)
12. [HDD Auto Mount](#12)

<br />

### <a name="1"></a>1. Write iso image on DVD

Install growisofs

{% highlight console %}
root@debian:~# aptitude install growisofs
{% endhighlight %}


{% highlight console %}
root@debian:~# growisofs -Z /dev/dvdrw=my_image.iso
{% endhighlight %}

<br />

### <a name="2"></a>2. Network Manager 사용

[https://wiki.debian.org/NetworkManager](https://wiki.debian.org/NetworkManager)

다음 2가지 경우에 Network Manager가 작동하지 않는다.

 - /etc/network/interfaces 파일에 Network 관련 설정이 되어 있을 때
 - /etc/NetworkManager/NetworkManager.conf 파일에 managed 값이 false로 되어 있을 때

/etc/network/interfaces 파일에 다음과 같이 기본 설정으로 변경한다.

{% highlight cfg %}
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
{% endhighlight %}

/etc/NetworkManager/NetworkManager.conf 파일의 managed 값을 true로 변경한다.

{% highlight cfg %}
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true
{% endhighlight %}

Network Manager를 재시작 한다.

{% highlight console %}
root@debian:~# /etc/init.d/network-namager restart
{% endhighlight %}

<br />

### <a name="3"></a>3. Glusterfs Configuration

Server 설정

{% highlight console %}
root@debian:~# aptitude install glusterNetfs-server
root@debian:~# gluster volume create glusterfs transport tcp 192.168.1.100:/home/scwook force
root@debian:~# gluster volume start glusterfs
{% endhighlight %}

Client 설정

{% highlight console %}
root@debian:~# aptitude install glusterfs-client
root@debian:~# mount -t glusterfs 192.168.1.100:/glusterfs /mnt/glusterfs
{% endhighlight %}

<br />

### <a name="4"></a>4. SAMBA Configuration

{% highlight console %}
root@debian:~# aptitude install samba
{% endhighlight %}

/etc/samba/smb.conf 파일에 다음 추가

{% highlight cfg %}
[global]
security = user

[share]
comment = my samba server
path = /home/scwook
writable = yes
valid user = scwook
browseable = no
{% endhighlight %}

samba 사용자 추가

{% highlight console %}
root@debian:~# smbpasswd -a scwook
{% endhighlight %}

서비스 재시작

{% highlight console %}
root@debian:~# service smbd restart
{% endhighlight %}

또는 

{% highlight console %}
root@debian:~# service samba restart
{% endhighlight %}

<br />

### <a name="5"></a>5. FPT Configuration

{% highlight console %}
root@debian:~# aptitude install vsftpd
{% endhighlight %}

설정 파일은 /etc/vsftpd.conf 이며, 기본 FTP 접근 폴더는 사용자 Home 폴더 이다.
기본 폴더를 바꾸고 싶으면 사용자 Home 폴더 자체를 바꿔야 하며, /etc/passwd 에 사용자 Home폴더가 명시되어 있다.

FTP는 보안상 이유로 Symbolic Link를 허용하지 않는다. 예를 들어 USB 마운트 폴더를 다음과 같이 Home 폴더에 링크한 경우

{% highlight console %}
scwook@debian:~$ ln -s /media/scwook/my-usb /home/scwook/my-usb-link
{% endhighlight %}

FTP로 접속하면 my-usb-link에 접속 할 수 없다. 해결 방법은 Link가 아니라 다음과 같이 Directory Mount로 한다.

{% highlight console %}
root@debian:~# mount -o bind /media/scwook/usb /home/scwook/usb-link
{% endhighlight %}

<br />

### <a name="6"></a>6. Debian 설치시 HDD가 안보일 때

Debian Linux 설치시 장착된 HDD가 보이지 않을 경우 다음과 같이 해결할 수 있다.
Debian Download Page에서 Live 이미지를 다운 받은 후 [Live CD](#1)를 준비한다.
Live CD로 부팅 한 후 dmraid 명령으로 HDD를 인식시킨다.

{% highlight console %}
$ sudo su
$ fdisk -l
$ dmraid -E -r /dev/sdx
{% endhighlight %}

sdx는 인식되지 않는 HDD로 fdisk 명령으로 확인 할 수 있다. 재부팅 후 다시 설치하면 HDD가 정상적으로 보인다.

<br />

### <a name="7"></a>7. Linux Auto Login

[https://wiki.debian.org/LightDM](https://wiki.debian.org/LightDM)

/etc/lightdm/lightdm.conf 에 다음과 같이 user와 timeout 값을 설정 한다.

{% highlight cfg %}
autologin-user = scwook
autologin-user-timeout = 0
{% endhighlight %}

<br />

### <a name="8"></a>8. VirtualBox Guest Addition 설치

Guest Additions를 설치하기 위해서는 기본적인 빌드 툴과 Linux Hearder 파일이 설치되어 있어야 한다.

{% highlight console %}
root@debian:~# aptitude update
root@debian:~# aptitude install build-essential linux-headers-3.15.0-4-amd64
{% endhighlight %}

Virtual OS를 실행 시킨 후 VirtualBox 메뉴에 있는 Devices-Insert Guest Addtions CD image... 를 실행 한다.
바탕화면에 VBOXADDITIONS_5.1.6_110634 CD가 생성되면 더블 클릭 또는 마우스 오른쪽 버튼을 눌러 Mount Volume를 실행한다.
/media/cdrom 폴더에 있는 VBoxLinuxAdditions.run 파일을 실행한다.

{% highlight console %}
root@debian:/media/cdrom# bash VBoxLinuxAdditions.run
{% endhighlight %} 

설치 후 재부팅 하면 Guest Additions이 적용된다.

<br />

### <a name="9"></a>9. PC간 네트워크 속도 테스트

iperf 툴을 이용하면 Client 에서 Server로 연결되는 네트워크 속도 테스트를 할 수 있다.

{% highlight console %}
root@debian:~# aptitude install iperf
{% endhighlight %}

Server 설정

{% highlight console %}
scwook@debian:~$ iperf -s
{% endhighlight %}

Client 설정

{% highlight console %}
scwook@debian:~$ iperf -c 192.168.1.100
{% endhighlight %}

<br />

### <a name="10"></a>10. 여러개의 이미지 파일을 하나의 영상파일로 변환

- mencoder를 이용하는 방법(Jessie 부터 지원 안됨)

{% highlight console %}
scwook@debian:~$ mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/10:vbitrate=8000000 -vf scale=640:480 -o my-video.avi -mf type=jpeg:fps=24 mf://@my-images/stills.txt
{% endhighlight %}

stills.txt 는 이미지 리스트 이며 이미지가 my-images 폴더에 있을 경우 리스트는 다음과 같이 생성 할 수 있다.

{% highlight console %}
scwook@debian:~$ ls --color=never my-images/*.jpg > my-images/stills.txt
{% endhighlight %}

- ffmpeg를 이용하는 방법

{% highlight console %}
scwook@debian:~$ ffmpeg -framerate 25 -pattern_type glob -i "my-images/*.jpg" -c:v libx264 my-video.mp4
{% endhighlight %}

여러개의 영상파일을 하나의 영상파일로 만들경우 다음과 같이 하면 된다. video-list.txt는 합성 할 video 리스트이다.

{% highlight console %}
scwook@debian:~$ ffmpeg -f concat -i video-list.txt -c copy composite-video.mp4
{% endhighlight %}

<br />

### <a name="11"></a>11. Tomcat 기본 포트 변경

Edit server.xml and change port="8080" to "80"

sudo vi /var/lib/tomcat7/conf/server.xml

<Connector connectionTimeout="20000" port="8080" protocol="HTTP/1.1" redirectPort="8443"/>

<br />

### <a name="12"></a>12. HDD 자동 마운트

부팅시 HDD를 자동 마운트는 다음과 같이 장착된 HDD의 UUDI를 /etc/fstab에 설정 하면 된다.

{% highlight console %}
root@debian:~# blkid
/dev/sda1: UUID="B0C5-32A0" TYPE="vfat" PARTUUID="17bed623-4047-4759-b8a2-80dd57124947"
/dev/sda2: UUID="fae32454-b1ae-4233-b894-e8df79b5c068" TYPE="ext4" PARTUUID="b4636c3f-725b-4667-9fbd-1a997ec7ae19"
/dev/sda3: UUID="965b761c-8482-4414-823b-c164206acd3a" TYPE="swap" PARTUUID="7061b5ea-dd0c-4240-b68f-7d467b720d13"
/dev/sdb5: UUID="c76ec547-f7c4-4166-bf66-fbe8b5df6f27" TYPE="ext4" PARTUUID="e53200c1-05"
{% endhighlight %}

/etc/fstab에 아래와 같이 추가한다.

{% highlight cfg %}
UUID=c76ec547-f7c4-4166-bf66-fbe8b5df6f27 /media/scwook ext4 defaults 0 0
{% endhighlight %}

<br />

### 13. X server 사용자 설정

{% highlight console %}
root@debian:~# dpkg-reconfigure x11-common
{% endhighlight %}

또는 /etc/X11/Xwrapper.config 파일에 다음 추가

{% highlight cfg %}
allowed_users=anybody
{% endhighlight %}
