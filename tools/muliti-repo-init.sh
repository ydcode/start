#!/bin/bash


Get_Dist_Name()
{
    if grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Amazon Linux AMI" /etc/issue || grep -Eq "Amazon Linux AMI" /etc/*-release; then
        DISTRO='Amazon'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    elif grep -Eqi "Deepin" /etc/issue || grep -Eq "Deepin" /etc/*-release; then
        DISTRO='Deepin'
        PM='apt'
    elif grep -Eqi "Mint" /etc/issue || grep -Eq "Mint" /etc/*-release; then
        DISTRO='Mint'
        PM='apt'
    else
        DISTRO='unknow'
    fi
    Get_OS_Bit
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


echo Get_Dist_Name;



SSH_DIR="$HOME"


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





