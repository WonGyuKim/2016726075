#!/bin/bash

print_file_type()
{
	type=$1
	if [ "$type" = "d" ]
	then
		echo [34m"file type : 디 렉 토 리"[0m
	elif [ "$type" = "-" ]
	then
		echo [0m"file type : 일 반 파 일"[0m
	else
		echo [32m"file type : 특 수 파 일"[0m
	fi
}

print_file_data()
{
	local file=$1
	local type=$2
	 count=$3
	local directory=$4
	
	size=`stat $file | sed -n '2p' | cut -f 4 -d' '`
	time=`stat $file | sed -n '6p' | cut -f 2-4 -d' '`
	permission=`stat $file | sed -n '4p' | cut -c 10-13`
	abs_path=`find $directory -name $file`
	rtv_path=`find . -name $file`
	
	echo "[$count] : $i"
	echo "====================INFORMATION===================="
	print_file_type $type
	echo "file size : $size"
	echo "creation time : $time"
	echo "permission : $permission"
	echo "absolute path : $abs_path"
	echo "relative path : $rtv_path"
	echo ""

	count=`expr $count + 1`
}

print_file_type_undir()
{
	type=$1
	if [ "$type" = "d" ]
	then
		echo [34m"	file type : 디 렉 토 리"[0m
	elif [ "$type" = "-" ]
	then
		echo [0m"	file type : 일 반 파 일"[0m
	else
		echo [32m"	file type : 특 수 파 일"[0m
	fi
}

print_file_data_undir()
{
	local file=$1
	local type=$2
	 count=$3
	local directory=$4
	
	local size=`stat $file | sed -n '2p' | cut -f 4 -d' '`
	local time=`stat $file | sed -n '6p' | cut -f 2-4 -d' '`
	local permission=`stat $file | sed -n '4p' | cut -c 10-13`
	local abs_path=`find $directory -name $file`
	local rtv_path=`find . -name $file`
	
	echo "	[$count] : $i"
	echo "	====================INFORMATION===================="
	print_file_type_undir $type
	echo "	file size : $size"
	echo "	creation time : $time"
	echo "	permission : $permission"
	echo "	absolute path : $abs_path"
	echo "	relative path : $rtv_path"
	echo ""

	count=`expr $count + 1`
}

print_tree()
{
local directory=$1

local count=1
local check_type=0

while [ $check_type -lt 3 ]
do
	for i in $(ls)
	do
	type=`ls -dl $i | cut -c 1`
	
	if [ $check_type -eq 0 ]
	then
		if [ "$type" = "d" ]
		then
			print_file_data $i $type $count $directory
			if [ `ls "$i" | wc -l` -ne 0 ]
			then
			cd "$i"
			echo "$undir"
			print_under_dir `pwd`
			cd ..
			fi			
		fi
	elif [ $check_type -eq 1 ]
	then
		if [ "$type" = "-" ]
		then
			print_file_data $i $type $count $directory
		fi
	else 
		if [ "$type" != "d" -a $type != "-" ]
		then
			print_file_data $i $type $count $directory
		fi
	fi

	done

check_type=`expr $check_type + 1`
done
}

print_under_dir()
{
local under_dir=$1

local count=1
local check_type=0

while [ $check_type -lt 3 ]
do
	for i in $(ls)
	do
	type=`ls -dl $i | cut -c 1`
	
	if [ $check_type -eq 0 ]
	then
		if [ "$type" = "d" ]
		then
		print_file_data_undir $i $type $count $directory
		fi
	elif [ $check_type -eq 1 ]
	then
		if [ "$type" = "-" ]
		then
		print_file_data_undir $i $type $count $directory
		fi
	else 
		if [ "$type" != "d" -a $type != "-" ]
		then
		print_file_data_undir $i $type $count $directory
		fi
	fi

	done

check_type=`expr $check_type + 1`
done
}

directory=`pwd`
print_tree $directory
