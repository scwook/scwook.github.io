---
layout: post
title: "Linux Configuration Guide"
show: true
language:
  - en
  - kr
categories: Linux
---

1. [DVD에 iso 이미지 파일 굽기](#1)
2. [Network Manager 사용](#2)
3. [Glusterfs Configuration](#3)
4. [SAMBA Configuration](#4)
5. [FTP Configuration](#5)
6. [Debian 설치할 때 HDD가 안보일 때](#6)
7. [자동 로그인 설정](#7)
8. [Virtual Box Guest Addtion 설치](#8)
9. [두 PC간 전송속도 테스트](#9)
10. [여러 이미지 파일을 하나의 영상파일로 결합](#10)
11. [Tomcat 8080포트 80으로 변경](#11)
12. [HDD 자동 마운트](#12)

<br />

### <a name="1"></a>1. DVD에 iso 이미지 파일 굽기

{% highlight shell %}
root@debian:~# aptitude install growisofs
{% endhighlight shell %}

DVD를 넣고 아래 명령 실행

{% highlight shell %}
root@debian:~# growisofs -Z /dev/dvdrw=image.iso
{% endhighlight shell %}

<br />

### <a name="2"></a>2. Network Manager 사용

[https://wiki.debian.org/NetworkManager](https://wiki.debian.org/NetworkManager)

다음 2가지 경우에 Network Manager가 작동하지 않는다.

 - /etc/network/interfaces 파일에 Network 관련 설정이 되어 있을 때
 - /etc/NetworkManager/NetworkManager.conf 파일에 managed 값이 false로 되어 있을 때

/etc/network/interfaces 파일에 다음과 같이 기본 설정으로 변경한다.

{% highlight shell %}
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
{% endhighlight %}

/etc/NetworkManager/NetworkManager.conf 파일의 managed 값을 true로 변경한다.

{% highlight shell %}
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true
{% endhighlight %}

Network Manager 재시작

{% highlight shell %}
root@debian:~# /etc/init.d/network-namager restart
{% endhighlight %}

<br />

### <a name="3"></a>3. Glusterfs Configuration

Server 설정

{% highlight shell %}
root@debian:~# aptitude install glusterNetfs-server
root@debian:~# gluster volume create glusterfs transport tcp 10.1.5.90:/home/scwook force
root@debian:~# gluster volume start glusterfs
{% endhighlight %}

Client 설정

{% highlight shell %}
root@debian:~# aptitude install glusterfs-client
root@debian:~# mount -t glusterfs 10.1.5.90:/glusterfs /mnt/glusterfs
{% endhighlight %}

<br />

### <a name="4"></a>4. SAMBA Configuration

{% highlight shell %}
root@debian:~# aptitude install samba
{% endhighlight %}

/etc/samba/smb.conf 파일에 다음 추가

{% highlight shell %}
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

{% highlight shell %}
root@debian:~# smbpasswd -a scwook
{% endhighlight %}

서비스 재시작

{% highlight shell %}
root@debian:~# service smbd restart
{% endhighlight %}

또는 

{% highlight shell %}
root@debian:~# service samba restart
{% endhighlight %}

<br />

### <a name="5"></a>5. FPT Configuration

{% highlight shell %}
root@debian:~# aptitude install vsftpd
{% endhighlight %}

설정 파일 위치: /etc/vsftpd.conf
별다른 설정은 필요 없음

기본 FTP 접근 폴더는 사용자 Home 폴더
기본 폴더를 바꾸고 싶으면 사용자 Home 폴더 자체를 바꿔야 함
사용자 Home 폴더는 /etc/passwd에 명시되어 있음

Symbolic link 문제
FTP는 보안상 이유로 Symbolic Link를 허용하지 않음
예를 들어 USB 마운트 폴더를 다음과 같이  Home 폴더에 링크한 경우

ln -s /media/scwook/usb /home/scwook/usb-link

FTP로 접속하면 usb-link에 접속 할 수 없음

해결 방법은 Link가 아니라 다음과 같이 Directory Mount로 한다.
mount -o bind /media/scwook/usb /home/scwook/usb-link

<br />

### <a name="6"></a>6. Debian 설치시 HDD가 안보일 때

Live CD 또는 인식안되는 HDD를 다른 Linux에 마운트 한 후
sudo su
fdisk -l
dmraid -E -r /dev/sdx -> 인식안되는 HDD

재부팅 후 다시 설치하면 인식됨

<br />

### <a name="7"></a>7. Linux Auto Login

[https://wiki.debian.org/LightDM](https://wiki.debian.org/LightDM)

/etc/lightdm/lightdm.conf 에 다음 값을 주석해제 하고 설정한다.

{% highlight shell %}
autologin-user = scwook
autologin-user-timeout = 0
{% endhighlight %}

<br />

### <a name="8"></a>8. VirtualBox Guest Addition 설치

<br />

### <a name="9"></a>9. PC간 네트워크 속도 테스트

{% highlight shell %}
root@debian:~# aptitude install iperf
{% endhighlight %}

Server(ip: 10.1.5.83)
iperf -s

Client
iperf -c 10.1.5.83

<br />

### <a name="10"></a>10. 여러개의 이미지 파일을 하나의 영상파일로 변환

mencoder 사용(Jessie 부터 지원 안됨)

mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/10:vbitrate=8000000 -vf scale=640:480 -o $CAM_FOLDER/$DATE.avi -mf type=jpeg:fps=24 mf://@$IMG_DIR/stills.txt

stills.txt 는 이미지 리스트 
폴더에 있는 이미지 리스트는 다음과 같이 생성
ls --color=never $IMG_DIR/*.jpg > $IMG_DIR/stills.txt

ffmpeg 사용

ffmpeg -framerate 25 -pattern_type glob -i "$DIR*.jpg" -c:v libx264 $FILENAME.mp4

여러개의 영상파일을 하나의 영상파일로 묶기

ffmpeg -f concat -i $MOVELIST_NAME.txt -c copy $CURRENT_DIR_NAME.mp4

MOVELIST_NAME.txt는 영상파일 리스트
영상파일 리스트는 다음과 같이 생성

<br />

### <a name="11"></a>11. Tomcat 기본 포트 변경

Edit server.xml and change port="8080" to "80"

sudo vi /var/lib/tomcat7/conf/server.xml

<Connector connectionTimeout="20000" port="8080" protocol="HTTP/1.1" redirectPort="8443"/>

<br />

### <a name="12"></a>12. HDD 자동 마운트

UUID 확인
{% highlight shell %}
root@debian:~# blkid
/dev/sda1: UUID="B0C5-32A0" TYPE="vfat" PARTUUID="17bed623-4047-4759-b8a2-80dd57124947"
/dev/sda2: UUID="fae32454-b1ae-4233-b894-e8df79b5c068" TYPE="ext4" PARTUUID="b4636c3f-725b-4667-9fbd-1a997ec7ae19"
/dev/sda3: UUID="965b761c-8482-4414-823b-c164206acd3a" TYPE="swap" PARTUUID="7061b5ea-dd0c-4240-b68f-7d467b720d13"
/dev/sdb5: UUID="c76ec547-f7c4-4166-bf66-fbe8b5df6f27" TYPE="ext4" PARTUUID="e53200c1-05"
{% endhighlight %}

/etc/fstab에 설정

{% highlight shell %}
UUID=c76ec547-f7c4-4166-bf66-fbe8b5df6f27 /media/scwook       ext4  defaults   0       0
{% endhighlight %}

<br />

### 13. X server 사용자 설정

{% highlight shell %}
root@debian:~# dpkg-reconfigure x11-common
{% endhighlight %}

또는 /etc/X11/Xwrapper.config 파일에 다음 추가
allowed_users=anybody


