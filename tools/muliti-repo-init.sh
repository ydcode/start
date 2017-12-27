#!/bin/bash


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





SSH_DIR="/root"

if [ -e "/usr/bin/sw_vers" ]; then #mac os
	SSH_DIR="/root"
else
	SSH_DIR="/private/var/root"
fi

    


Check_Repo_Name_Right()
{
	echo "${repoName}  Right ?"
	read -p "[Y/n]: Y " repoNameRight

    case "${repoNameRight}" in
    [yY][eE][sS]|[yY])
        echo "You will Add Repo:: ${repoName} "
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
       echo "Right"
    else
        Input_Repo
    fi
}


Init_Git_Config()
{
	if [ ! -d "$SSH_DIR/.ssh" ]; then
	  mkdir "$SSH_DIR/.ssh"
	fi

	if [ ! -e "$SSH_DIR/.ssh/config" ]; then
		touch $SSH_DIR/.ssh/config
	fi
}

Add_Git_Key()
{
    Init_Git_Config

    if [ -e "$SSH_DIR/.ssh/id_rsa_${shortRepoName}" ]; then
        rm -rf $SSH_DIR/.ssh/id_rsa_${shortRepoName}*
    fi
    ssh-keygen -t rsa -P "" -C "abcdefghijklmnopqrstuvwxyz" -f $SSH_DIR/.ssh/id_rsa_${shortRepoName}

    if grep -q "com${shortRepoName}" "$SSH_DIR/.ssh/config"; then #条目已存在
        echo "Git config Item exists"
    else
        echo "Host github.com${shortRepoName}" >> $SSH_DIR/.ssh/config
        echo "User git" >> $SSH_DIR/.ssh/config
        echo "HostName github.com" >> $SSH_DIR/.ssh/config
        echo "IdentityFile $SSH_DIR/.ssh/id_rsa_${shortRepoName}" >> $SSH_DIR/.ssh/config
        echo " " >> $SSH_DIR/.ssh/config
    fi

	chown $USER ~/.ssh/config
	chmod 644 ~/.ssh/config

    cat $SSH_DIR/.ssh/config

    echo "-----------------------------------------------------------"
    cat $SSH_DIR/.ssh/id_rsa_${shortRepoName}.pub
    echo "-----------------------------------------------------------"

    echo " 1.Add Above to repo: ${repoName}"
    echo " 2.git clone git@github.com${shortRepoName}:${username}/${repoName}.git"
    echo "-----------------------------------------------------------"
}


Input_Repo_Name
Add_Git_Key





