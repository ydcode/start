#!/bin/bash

Echo_Yellow()
{
  echo $(Color_Text "$1" "33")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}


Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m"
}

Input_Repo_Name()
{
    username="ydcode"
    repoName="google.com"
    read -p "Enter your repo name: " repoName
    repoName=`echo ${repoName}|tr -d ' /'`
    shortRepoName=`echo ${repoName}|tr -d ' '`
    shortRepoName=`echo ${shortRepoName}|tr -d '.'`

    Check_Repo_Name_Right
}



Check_Repo_Name_Right()
{
	Echo_Yellow "${repoName}  Right ?"
	read -p "[Y/n]: Y " repoNameRight

    case "${repoNameRight}" in
    [yY][eE][sS]|[yY])
        Echo_Green "You will Add Repo:: ${repoName} "
        repoNameRight="y"
        ;;
    [nN][oO]|[nN])
        echo "No Repo Param"
        repoNameRight="n"
        ;;
    *)
        echo "No input,Right, will add Repo: ${repoName}."
        repoNameRight="y"
    esac

    if [ "${repoNameRight}" = "y" ]; then
       Echo_Green "Right"
    else
        Input_Repo
    fi
}


Init_Git_Config()
{
	if [ ! -d "/root/.ssh" ]; then
	  mkdir "/root/.ssh"
	fi

	if [ ! -e "/root/.ssh/config" ]; then
		touch /root/.ssh/config
	fi
}

Add_Git_Key()
{
    Init_Git_Config

    if [ -e "/root/.ssh/id_rsa_${shortRepoName}" ]; then
        rm -rf /root/.ssh/id_rsa_${shortRepoName}*
    fi
    ssh-keygen -t rsa -P "" -C "abcdefghijklmnopqrstuvwxyz" -f /root/.ssh/id_rsa_${shortRepoName}

    if grep -q "com${shortRepoName}" "/root/.ssh/config"; then #条目已存在
        Echo_Green "Git config Item exists"
    else
        echo "Host github.com${shortRepoName}" >> /root/.ssh/config
        echo "User git" >> /root/.ssh/config
        echo "HostName github.com" >> /root/.ssh/config
        echo "IdentityFile /root/.ssh/id_rsa_${shortRepoName}" >> /root/.ssh/config
        echo " " >> /root/.ssh/config
    fi

    cat /root/.ssh/config

    Echo_Green "-----------------------------------------------------------"
    cat /root/.ssh/id_rsa_${shortRepoName}.pub
    Echo_Green "-----------------------------------------------------------"

    Echo_Yellow " 1.Add Above to repo: ${repoName}"
    Echo_Yellow " 2.git clone git@github.com${shortRepoName}:${username}/${repoName}.git"
    Echo_Green "-----------------------------------------------------------"
}


Input_Repo_Name
Add_Git_Key





