#!/bin/bash

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

for str in `cat $1`
do
	#processing one field "user:groups:pass:homedir"
	user=`echo $str | cut -d: -f1`
	grps=`echo $str | cut -d: -f2`
	pass=`echo $str | cut -d: -f3`
	homedir=`echo $str | cut -d: -f4`

	#checking if some args are empty
	if [ -z $user ]
	then
		echo "ERROR: The empty name of user in " $str
		exit 1
	fi
	if [ -z $pass ]
	then
		echo "ERROR: The empty pass in " $str
		exit 1
	fi
	if [ -z $homedir ]
	then
		echo "WARNING: No home directory given to $user. Using default value: /home/$user"
		homedir="/home/$user"
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
	if [ -n "$pass" ]
	then
		args=$args" -p $(openssl passwd -1 $pass)"
	fi
	if [ -n "$homedir" ]
	then
		args=$args" -d $homedir"
	fi
	if [ -n "$grps" ]
	then
		args=$args" -G $grps"
	fi
	useradd $args $user

done

echo "Don't forget to delete $1 in order to avoid passwords leakage"

