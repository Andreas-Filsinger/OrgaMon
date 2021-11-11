I modified nginx slightly to created a "real world HTTP2 log". The log contains uncrypted data, TLS1.3 encryption is done by openSSL 1.1.1. To test the OrgaMon-HTTP2 Server i can playback whats on the FRAME-Level.

My Steps to do this:

* Take one of your "Raspberry Pi 3"s
* get the newest Version of the nginx-Build Script. https://github.com/MatthewVance/nginx-build
* add the line "--with-debug"
* run it (this takes 20 Minutes)
* modify "ngx_event_openssl.c" like i did
* in "nginx"-Path do make
* in "nginx"-Path do make install
* use a special /etc/nginx/nginx.conf to run nginx developer friendly
* get your private+public+cert ready "orgamon.com" in my case (i did it by by Let's encrypt, http://wiki.orgamon.org/index.php5/Linux.nginx). 
* run /usr/sbin/nginx from command line
* connect to your "Raspi" from outside by using firefox>=63
* See whats in "error.log" is happening

So you get your first "Hello World" data, unencrypted HTTP2-FRAMES

SSL_read: 148
 < 505249202a20485454502f322e300d0a<br>
 < 0d0a534d0d0a0d0a0000120400000000<br>
 < 00000100010000000400020000000500<br>
 < 00400000000408000000000000bf0001<br>
 < 00000502000000000300000000c80000<br>
 < 05020000000005000000006400000502<br>
 < 00000000070000000000000005020000<br>
 < 00000900000007000000050200000000<br>
 < 0b000000030000000502000000000d00<br>
 < 000000f0<br>
 
SSL_read: 231
< 0000d101250000000f0000000d298204<br>
< 816341883d930e93d4b90f4f877abbd0<br>
< 7f66a281b0dae053fae46aa43f8429a7<br>
< 7a8102e0fb5391aa71afb53cb8d7da96<br>
< 77b8e32b83fb531149d4ec0801000200<br>
< a984d61653f961c6570753b0497ca589<br>
< d34d1f43aeba0c41a4c7a98f33a69a3f<br>
< df9a68fa1d75d0620d263d4c79a68fbe<br>
< d00177febe58f9fbed00177b519390bf<br>
< 45a96e1bbefb4005ddfa2d5f7da002ec<br>
< ff508d9bd9abfa5242cb40d25fa523b3<br>
< 4092b6b9ac1c8558d520a4b6c2ad617b<br>
< 5a54251f810f5887a47e561cc5801f40<br>
< 82497f864d833505b11f000004080000<br>
< 00000f00be0000<br>

 

