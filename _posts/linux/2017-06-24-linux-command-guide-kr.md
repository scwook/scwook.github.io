---
layout: post
title: "Linux Configuration Guide"
language:
  - en
  - kr
categories: Linux
---

아래 명령 및 설정은 리눅스 데비안 기반으로 작성되었다.

1. [DVD에 iso 이미지 파일 굽기](#1)
2. [Network Manager 사용](#2)
3. [Glusterfs Configuration](#3)
4. [SAMBA Configuration](#4)
5. [FTP Configuration](#5)
6. [Debian 설치할 때 HDD가 안보일 때](#6)
7. [자동 로그인 설정](#7)
8. [VirtualBox Guest Addtion 설치](#8)
9. [두 PC간 전송속도 테스트](#9)
10. [여러 이미지 파일을 하나의 영상파일로 결합](#10)
11. [Tomcat 기본 포트 변경](#11)
12. [HDD 자동 마운트](#12)

<br />

### <a name="1"></a>1. DVD에 iso 이미지 파일 굽기

growisofs 설치

<pre>
root@debian:~# aptitude install growisofs
</pre>

이미지 파일 이름이 my_image.iso일 경우 아래와 같이 실행

<pre>
root@debian:~# growisofs -Z /dev/dvdrw=my_image.iso
</pre>

<br />

### <a name="2"></a>2. Network Manager 사용

[https://wiki.debian.org/NetworkManager](https://wiki.debian.org/NetworkManager)

다음 2가지 경우에 Network Manager가 작동하지 않는다.

 - /etc/network/interfaces 파일에 Network 관련 설정이 되어 있을 때
 - /etc/NetworkManager/NetworkManager.conf 파일에 managed 값이 false로 되어 있을 때

Network Manager를 사용하기 위해 /etc/network/interfaces 파일에 다음과 같이 기본 설정으로 변경한다.

<pre>
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
</pre>

/etc/NetworkManager/NetworkManager.conf 파일의 managed 값을 true로 변경한다.

<pre>
[main]
plugins=ifupdown,keyfile

[ifupdown]
<span class="insert>managed=true</span>
</pre>

Network Manager를 재시작 한다.

<pre>
root@debian:~# /etc/init.d/network-namager restart
</pre>

<br />

### <a name="3"></a>3. Glusterfs Configuration

Server 설정

<pre>
root@debian:~# aptitude install glusterNetfs-server
root@debian:~# gluster volume create glusterfs transport tcp 192.168.1.100:/home/scwook force
root@debian:~# gluster volume start glusterfs
</pre>

Client 설정

<pre>
root@debian:~# aptitude install glusterfs-client
root@debian:~# mount -t glusterfs 192.168.1.100:/glusterfs /mnt/glusterfs
</pre>

<br />

### <a name="4"></a>4. SAMBA Configuration

<pre>
root@debian:~# aptitude install samba
</pre>

/etc/samba/smb.conf 파일에 다음 추가

<pre>
[global]
<span class="insert">security = user</span>

<span class="insert">
[share]
comment = my samba server
path = /home/scwook
writable = yes
valid user = scwook
browseable = no
</span>
</pre>

samba 사용자 추가

<pre>
root@debian:~# smbpasswd -a scwook
</pre>

서비스 재시작

<pre>
root@debian:~# service smbd restart
</pre>

또는 

<pre>
root@debian:~# service samba restart
</pre>

<br />

### <a name="5"></a>5. FPT Configuration

<pre>
root@debian:~# aptitude install vsftpd
</pre>

설정 파일은 /etc/vsftpd.conf 이며, 기본 FTP 접근 폴더는 사용자 Home 폴더 이다.
기본 폴더를 바꾸고 싶으면 사용자 Home 폴더 자체를 바꿔야 하며, /etc/passwd 에 사용자 Home폴더가 명시되어 있다.

FTP는 보안상 이유로 Symbolic Link를 허용하지 않는다. 예를 들어 USB 마운트 폴더를 다음과 같이 Home 폴더에 링크한 경우

<pre>
scwook@debian:~$ ln -s /media/scwook/my-usb /home/scwook/my-usb-link
</pre>

FTP로 접속하면 my-usb-link에 접속 할 수 없다. 해결 방법은 Link가 아니라 다음과 같이 Directory Mount로 한다.

<pre>
root@debian:~# mount -o bind /media/scwook/usb /home/scwook/usb-link
</pre>

<br />

### <a name="6"></a>6. Debian 설치시 HDD가 안보일 때

Debian Linux 설치시 장착된 HDD가 보이지 않을 경우 다음과 같이 해결할 수 있다.
해결할 수 있는 한 가지 방법은 Live CD를 이용하는 것이다.
Debian Download Page에서 Live 이미지를 다운 받은 후 [Live CD](https://www.debian.org/CD/live/)를 준비한다.
Live CD로 부팅 한 후 dmraid 명령으로 HDD를 인식시킨다.

<pre>
grub> sudo su
grub> fdisk -l
gru> dmraid -E -r /dev/sdx
</pre>

sdx는 인식되지 않는 HDD로 fdisk 명령으로 확인 할 수 있다. 재부팅 후 다시 설치하면 HDD가 정상적으로 보인다.

<br />

### <a name="7"></a>7. Linux Auto Login

[https://wiki.debian.org/LightDM](https://wiki.debian.org/LightDM)

/etc/lightdm/lightdm.conf 에 다음과 같이 user와 timeout 값을 설정 한다.

<pre>
autologin-user = scwook
autologin-user-timeout = 0
</pre>

<br />

### <a name="8"></a>8. VirtualBox Guest Addition 설치

Guest Additions를 설치하기 위해서는 기본적인 빌드 툴과 Linux Hearder 파일이 설치되어 있어야 한다.

<pre>
root@debian:~# aptitude update
root@debian:~# aptitude install build-essential linux-headers-3.15.0-4-amd64
</pre>

Virtual OS를 실행 시킨 후 VirtualBox 메뉴에 있는 Devices-Insert Guest Addtions CD image... 를 실행 한다.
바탕화면에 VBOXADDITIONS_5.1.6_110634 CD가 생성되면 더블 클릭 또는 마우스 오른쪽 버튼을 눌러 Mount Volume를 실행한다.
/media/cdrom 폴더에 있는 VBoxLinuxAdditions.run 파일을 실행한다.

<pre>
root@debian:/media/cdrom# bash VBoxLinuxAdditions.run
</pre> 

설치 후 재부팅 하면 Guest Additions이 적용된다.

<br />

### <a name="9"></a>9. PC간 네트워크 속도 테스트

iperf 툴을 이용하면 Client 에서 Server로 연결되는 네트워크 속도 테스트를 할 수 있다.

<pre>
root@debian:~# aptitude install iperf
</pre>

Server 설정

<pre>
scwook@debian:~$ iperf -s
</pre>

Client 설정

<pre>
scwook@debian:~$ iperf -c 192.168.1.100
</pre>

<br />

### <a name="10"></a>10. 여러개의 이미지 파일을 하나의 영상파일로 변환

- mencoder를 이용하는 방법(Jessie 부터 지원 안됨)

<pre>
scwook@debian:~$ mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=16/10:vbitrate=8000000 -vf scale=640:480 -o my-video.avi -mf type=jpeg:fps=24 mf://@my-images/stills.txt
</pre>

stills.txt 는 이미지 리스트 이며 이미지가 my-images 폴더에 있을 경우 리스트는 다음과 같이 생성 할 수 있다.

<pre>
scwook@debian:~$ ls --color=never my-images/*.jpg > my-images/stills.txt
</pre>

- ffmpeg를 이용하는 방법

<pre>
scwook@debian:~$ ffmpeg -framerate 25 -pattern_type glob -i "my-images/*.jpg" -c:v libx264 my-video.mp4
</pre>

여러개의 영상파일을 하나의 영상파일로 만들경우 다음과 같이 하면 된다. video-list.txt는 합성 할 video 리스트이다.

<pre>
scwook@debian:~$ ffmpeg -f concat -i video-list.txt -c copy composite-video.mp4
</pre>

<br />

### <a name="11"></a>11. Tomcat 기본 포트 변경

Edit server.xml and change port="8080" to "80"

sudo vi /var/lib/tomcat7/conf/server.xml

<Connector connectionTimeout="20000" port="8080" protocol="HTTP/1.1" redirectPort="8443"/>

<br />

### <a name="12"></a>12. HDD 자동 마운트

부팅시 HDD를 자동 마운트는 다음과 같이 장착된 HDD의 UUDI를 /etc/fstab에 설정 하면 된다.

<pre>
root@debian:~# blkid
/dev/sda1: UUID="B0C5-32A0" TYPE="vfat" PARTUUID="17bed623-4047-4759-b8a2-80dd57124947"
/dev/sda2: UUID="fae32454-b1ae-4233-b894-e8df79b5c068" TYPE="ext4" PARTUUID="b4636c3f-725b-4667-9fbd-1a997ec7ae19"
/dev/sda3: UUID="965b761c-8482-4414-823b-c164206acd3a" TYPE="swap" PARTUUID="7061b5ea-dd0c-4240-b68f-7d467b720d13"
/dev/sdb5: UUID="c76ec547-f7c4-4166-bf66-fbe8b5df6f27" TYPE="ext4" PARTUUID="e53200c1-05"
</pre>

/etc/fstab에 아래와 같이 추가한다.

<pre>
UUID=c76ec547-f7c4-4166-bf66-fbe8b5df6f27 /media/scwook ext4 defaults 0 0
</pre>

<br />

### 13. X server 사용자 설정

<pre>
root@debian:~# dpkg-reconfigure x11-common
</pre>

또는 /etc/X11/Xwrapper.config 파일에 다음 추가

<pre>
allowed_users=anybody
</pre>
