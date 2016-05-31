#!/bin/bash

dir=/home/pi/app/audio
dev=$(echo $DEVNAME |cut -d'/' -f3)

mkdir -p $dir/$dev
