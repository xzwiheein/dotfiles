#!/bin/bash
if [ $# -eq 0 ];
then 
  echo "Bad Parameters."
  exit
fi
if [ $1 = all -o $1 = tar ];
then
tar Jcvf $2 $3
ccencrypt $2 
fi
if [ $1 = all -o $1 = untar ];
then 
  ccdecrypt $2.cpt
  tar Jxvf $2
fi
if [ $1 = all -o $1 = install ];
then 

sudo apt-get install ccrypt
fi
