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
6. [Invisible HDD when install debian](#6)
7. [Auto Login Configuration](#7)
8. [VirtualBox Guest Addation Installation](#8)
9. [Network Speed Test between two PCs](#9)
10. [Combine one video file form a number of images](#10)
11. [Modify Tomcat default port](#11)
12. [HDD Auto Mount](#12)

<br />

### <a name="1"></a>1. Write iso image on DVD

Install growisofs

<pre>
root@debian:~# aptitude install growisofs
</pre>

If image file name is my_image.iso, you can use following command.

<pre>
root@debian:~# growisofs -Z /dev/dvdrw=my_image.iso
</pre>

<br />

### <a name="2"></a>2. Using Network Manager

[https://wiki.debian.org/NetworkManager](https://wiki.debian.org/NetworkManager)

In case of following two conditions, Network Manager doesn't work.

 - When declared any network configuration in /etc/network/interfaces file
 - When namaged valus is set false in /etc/NetworkManager/NetworkManager.conf file

To use Network Manager, recovery default value in /etc/network/interfaces file.

<pre>
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
</pre>

And change managed value to true.

<pre>
[main]
plugins=ifupdown,keyfile

[ifupdown]
<span class="insert">managed=true</span>
</pre>

Restart Network Manager.

<pre>
root@debian:~# /etc/init.d/network-namager restart
</pre>

<br />

### <a name="3"></a>3. Glusterfs Configuration

Server Configuration

<pre>
root@debian:~# aptitude install glusterNetfs-server
root@debian:~# gluster volume create glusterfs transport tcp 192.168.1.100:/home/scwook force
root@debian:~# gluster volume start glusterfs
</pre>

Client Configuration

<pre>
root@debian:~# aptitude install glusterfs-client
root@debian:~# mount -t glusterfs 192.168.1.100:/glusterfs /mnt/glusterfs
</pre>

<br />

### <a name="4"></a>4. SAMBA Configuration

<pre>
root@debian:~# aptitude install samba
</pre>

Insert following lines in /etc/samba/smb.conf file.

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

Add samba user.

<pre>
root@debian:~# smbpasswd -a scwook
</pre>

Restart service.

<pre>
root@debian:~# service smbd restart
</pre>

or

<pre>
root@debian:~# service samba restart
</pre>

<br />

### <a name="5"></a>5. FPT Configuration

<pre>
root@debian:~# aptitude install vsftpd
</pre>

FPT configuration file is /etc/vsftpd.conf and default access folder is user home folder.
If you want to change default folder, you have to change user home folder and it is specified in /etc/passwd file.

Because of security, FTP server does not allow symbolic link. For example, a my-usb-link is linked to USB mount folder

<pre>
scwook@debian:~$ ln -s /media/scwook/my-usb /home/scwook/my-usb-link
</pre>

you can't see any files of USB when you access my-usb-link via FTP.
One solution is using Directory Mount as follows

<pre>
root@debian:~# mount -o bind /media/scwook/usb /home/scwook/usb-link
</pre>

<br />

### <a name="6"></a>6. Invisible HDD when install debian

When you install debian linux, sometime you can't see HDD which is mounted HDD on your PC.
One solution is using Live CD. Form [Debian Download Page](https://www.debian.org/CD/live/), prepare a live CD.

<pre>
grub> sudo su
grub> fdisk -l
grub> dmraid -E -r /dev/sdx
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
