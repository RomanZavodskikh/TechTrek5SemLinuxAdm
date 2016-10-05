#!/bin/bash
if [ ! -n "$1" ] 
then
	echo "Give a FILE!!!!"
	exit 1
fi

if [ ! -f $1 ]
then
	echo "File does not exist"
	exit 1
fi

for str in `cat $1`
do
	user=`echo $str | cut -d: -f1`
	grps=`echo $str | cut -d: -f2`
	for grp in `echo $grps | sed 's/\,/\ /g'`
	do
		groupadd $grp
	done
	hash=`echo $str | cut -d: -f3`
	if [ -n "$grps" ]
	then
		useradd -G $grps -p $hash $user
	else
		useradd -p $hash $user
	fi
done

