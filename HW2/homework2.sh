#!/bin/bash
DEF_SHELL=/bin/bash

#Checking existence of the file
if [ ! -n "$1" ] 
then
	echo "ERROR: No file given!!!!"
	exit 1
fi

if [ ! -f $1 ]
then
	echo "ERROR: File does not exist"
	exit 1
fi

IFS=$'\n'
for str in `cat $1`
do
IFS=' '
	#processing one field "user:groups:hash:homedir:uid:shell:description"
	user=`echo $str | cut -d: -f1`
	grps=`echo $str | cut -d: -f2`
	hash=`echo $str | cut -d: -f3`
	homedir=`echo $str | cut -d: -f4`
	uid=`echo $str | cut -d: -f5`
	shell=`echo $str | cut -d: -f6`
	desc=`echo $str | cut -d: -f7`

	#checking if some args are empty
	if [ -z $user ]
	then
		echo "ERROR: The empty name of user in " $str
		exit 1
	fi
	if [ -z $hash ]
	then
		echo "ERROR: The empty hash in " $str
		exit 1
	fi
	if [ -z $homedir ]
	then
		echo "WARNING: No home directory given to $user. Using default value: /home/$user"
		homedir="/home/$user"
	fi
	if [ ! $uid -ge 0 ] # test if $uid is natural number
	then
		echo "ERROR: No UID in " $str
		exit 1
	fi
	if [ -z $shell ]
	then
		echo "WARNING: No shell specified, using $DEF_SHELL in $str"
		$shell="/bin/bash"
	fi

	#creating some groups of they don't exist
	for grp in `echo $grps | sed 's/\,/\ /g'`
	do
		#checking the existense of the current group
		getent group $grp > /dev/null
		if [ $? -eq 2 ]
		then
			groupadd $grp
		fi
	done

	getent passwd $user > /dev/null
	#actions taken if the user already exist
	if [ $? -eq 0 ]
	then
		echo "WARNING: User $user already exists => its password could vary from given to script"
		if [ -n "$grps" ]
		then
			usermod -a -G $grps $user
		fi
		continue #go away, we have nothing to do
	fi
	
	#actions taken if the user doesn't exist yet
	args=""
	if [ -n "$hash" ]
	then
		args="$args -p $hash"
	fi
	if [ -n "$homedir" ]
	then
		args="$args -d $homedir"
	fi
	if [ -n "$grps" ]
	then
		args="$args -G $grps"
	fi
	if [ -n "$uid" ]
	then
		args="$args -u $uid"
	fi
	if [ -n "$shell" ]
	then
		args="$args -s $shell"
	fi
	if [ -n "$desc" ]
	then
		desc_f=" -c "
	fi
	useradd $args $desc_f "$desc" $user
done

