#!/bin/sh
# Performs necessary search&replace operations after h2pas conversion occurs
# Petr Kozelka (C) 2002

for fn in $* ; do
  echo $fn
  sed -f $LIBXML2_PAS/headers/utils/afterconv.sed $fn >$fn.new
  diff $fn $fn.new >$fn.diff
#  mv $fn $fn.bak
#  mv $fn.new $fn
done
