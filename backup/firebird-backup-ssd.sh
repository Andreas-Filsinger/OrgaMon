#!/bin/bash
#
# /etc/backup-firebird
#
# (c) 2014 Andreas Filsinger
#
#

ANZAHL_BAENDER=2

# BAND=$((($(date +%s)/86400)%$ANZAHL_BAENDER))-$(date +%H)
#
# Bei obigem Befehl war das Problem, dass um 0 Uhr noch der
# "alte" Tag im Ergebnisstring angegeben wurde, also
# 3-23
# 3-00
# 4-01
# Mein Ziel ist eine verständlichere Reihenfolge, also
# 3-23
# 4-00
# 4-01
# Ich will dem Datum also etwas über den Zaun helfen
# Ich hoffe das hat nichts mit Schaltsekunden zu tun.
# Oder mit Sommerzeit oder sonstigem schwer kalkulierbarem
# Zeug
#

BAND=$(((($(date +%s)+1)/86400)%$ANZAHL_BAENDER))-$(date +%H)

echo $BAND $(date)

rm /srv/smb/fdb/$BAND.fbak
gbak -B -V -USER SYSDBA -PASSWORD *** fkrueger.fdb /srv/firebird/$BAND.fbak

echo $(date)
