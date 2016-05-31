#!/bin/bash

dir=/home/pi/app/audio
dev=$(echo $DEVNAME |cut -d'/' -f3)

rm -rf $dir/$dev
