#!/bin/sh


for file in *.svg; do
	base=${file%.*}
	echo $base;
	inkscape -z -e ${base}.png -w 1024 ${base}.svg
done

