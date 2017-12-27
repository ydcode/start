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
	if [ ! -d "$HOME/.ssh" ]; then
	  mkdir "$HOME/.ssh"
	fi

	if [ ! -e "$HOME/.ssh/config" ]; then
		touch $HOME/.ssh/config
	fi
}

Add_Git_Key()
{
    Init_Git_Config

    if [ -e "$HOME/.ssh/id_rsa_${shortRepoName}" ]; then
        rm -rf $HOME/.ssh/id_rsa_${shortRepoName}*
    fi
    ssh-keygen -t rsa -P "" -C "abcdefghijklmnopqrstuvwxyz" -f $HOME/.ssh/id_rsa_${shortRepoName}

    if grep -q "com${shortRepoName}" "$HOME/.ssh/config"; then #条目已存在
        Echo_Green "Git config Item exists"
    else
        echo "Host github.com${shortRepoName}" >> $HOME/.ssh/config
        echo "User git" >> $HOME/.ssh/config
        echo "HostName github.com" >> $HOME/.ssh/config
        echo "IdentityFile $HOME/.ssh/id_rsa_${shortRepoName}" >> $HOME/.ssh/config
        echo " " >> $HOME/.ssh/config
    fi

	chown $USER ~/.ssh/config
	chmod 644 ~/.ssh/config

    cat $HOME/.ssh/config

    Echo_Green "-----------------------------------------------------------"
    cat $HOME/.ssh/id_rsa_${shortRepoName}.pub
    Echo_Green "-----------------------------------------------------------"

    Echo_Yellow " 1.Add Above to repo: ${repoName}"
    Echo_Yellow " 2.git clone git@github.com${shortRepoName}:${username}/${repoName}.git"
    Echo_Green "-----------------------------------------------------------"
}


Input_Repo_Name
Add_Git_Key





