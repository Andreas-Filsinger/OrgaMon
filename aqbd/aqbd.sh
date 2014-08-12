#!/bin/sh
#
# AqBanking Daemon Start Script
#
VERSION_AKTUELL=aqbanking-5.4.3beta
VERSION_BISHER=aqbanking-5.0.0

# Debug-Modus einschalten im Problemfall
#
#export AQHBCI_LOGLEVEL=debug
export AQHBCI_LOGLEVEL=info
export AQBANKING_LOGLEVEL=info

#
# stoppe ev. bisher aktive Dämonen
#
killproc -v /root/$VERSION_AKTUELL/src/test/.libs/abtest
killproc -v /root/$VERSION_BISHER/src/test/.libs/abtest

#
# Lock-Verzeichnis aufraeumen
#
rm /root/.aqbanking/settings/users/*.lck*

#
# Nicht abgearbeitete Jobs verschieben, da eh Timeout
#
mv /srv/aqb/jobs/* /srv/aqb/error

#
# Ergebnis-Verzeichnisse aufraeumen
#
find /srv/aqb/results/* -atime +14 -exec rm {} \;
find /srv/aqb/logs/* -atime +14 -exec rm {} \;
find /srv/aqb/error/* -atime +14 -exec rm {} \;

#
# Start Protokollieren
#
logger "aqbd-Startup-Script ausgfuehrt!"

#
# Dämon starten
#
startproc -v /root/$VERSION_AKTUELL/src/test/.libs/abtest -D

#