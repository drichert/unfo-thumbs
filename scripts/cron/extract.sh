#!/bin/bash

extract_len=5

source_dir=$(find /media/ -mindepth 1 -maxdepth 1 -not -empty -type d -name "usb*" |sort -R |head -1)
source_file=$(find $source_dir -name "*.wav" -o -name "*.aif" -o -name "*.aiff" -o -name "*.mp3" -o -name "*.ogg" |sort -R |head -1)
duration=$(soxi -D "$source_file")

is_long_sample=$(bc <<< "$duration > $extract_len")

if [ "$is_long_sample" = "1" ]; then
  max=$(bc <<< "scale=2; $duration - $extract_len")
  start=$(perl -e "print sprintf('%.2f', rand($max))")
else
  start=0
fi

extracted="/tmp/$RANDOM-$(basename "$source_file")"

sox "$source_file" "$extracted" trim $start $extract_len

device_name=$(df |grep $source_dir |cut -d' ' -f1 |cut -d'/' -f3)
output_dir=/home/pi/app/audio/$device_name

cd $output_dir && aubiocut "$extracted" -q -c
echo $extracted >> /home/pi/logs/extract.log

rm "$extracted"
