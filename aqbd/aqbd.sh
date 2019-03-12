#!/bin/sh
#
# AqBanking Daemon Pre Startup Script
#

# Debug-Modus einschalten im Problemfall
#
#export AQHBCI_LOGLEVEL=debug
export AQHBCI_LOGLEVEL=info
export AQBANKING_LOGLEVEL=info

#
# Lock-Verzeichnis aufraeumen
#
rm /root/.aqbanking/settings6/users/*.lck*

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

exit 0
