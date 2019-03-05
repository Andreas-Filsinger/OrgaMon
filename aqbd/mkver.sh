
systemctl stop aqbd
cp ./.libs/abtest /srv/aqb/aqb
systemctl start aqbd