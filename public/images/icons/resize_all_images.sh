#!/bin/bash
for i in *.png; do
    convert "$i" -resize 32x32 "$i";
done