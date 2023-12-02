#!/bin/bash

echo -n "Please input the name of the debian/raspbian version you would like to upgrade to: "
read newrelease
echo "the debian/raspbian version you would like to upgrade to is:" $newrelease
echo "please double check the spelling against the required version you are trying to upgrade too and hit ENTER"
read input 

echo -n "is the inputted debian/raspbian version you input correct? [y/n]?"
read yesorno

flag="true"
while [ $flag == "true" ]
do
    if [ "$yesorno" == "yes" ] || [ "$yesorno" == "y" ]
    then
        flag="false"
        echo "success"
	debianRelease=$(cat /etc/os-release | grep CODENAME | awk -F = '{print $2}')
	echo "your debian release is" $debianRelease
        echo -n "Do you want to upgrade from" $debianRelease "to" $newrelease": "
        read yesorno
        reposToChange=$(grep -Rl $debianRelease /etc/apt)
        flag2=true
	while [ $flag2 == "true" ]
        do
	if [ "$yesorno" == "yes" ] || [ "$yesorno" == "y" ]
	then	
            for aFile in ${reposToChange[@]}
	    do
		    echo "backing up $aFile"
		    cp $aFile $aFile.bak
		    echo "changing $aFile"
		    sed -i "s/$debianRelease/$newrelease/g" $aFile
		    echo "$aFile changed" 
	    done
	    flag2=false
        elif [ "$yesorno" == "no" ] || [ "$yesorno" == "n" ]
	then
            exit
	else
            echo "please try again" 
	fi
        done
    elif [ "$yesorno" == "no" ] || [ "$yesorno" == "n" ]
    then
        exit
    else
        echo "please try again"	    
    fi
done
