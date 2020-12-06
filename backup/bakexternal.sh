#!/bin/bash

BAND=0
OPTIONS="-avK --delete --force --ignore-errors --copy-unsafe-links"

DEST=/srv/mnt/$BAND/srv
echo $DEST
mkdir $DEST
chmod 777 $DEST
rsync $OPTIONS localhost::srv/ $DEST
touch $DEST

