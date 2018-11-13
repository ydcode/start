#!/bin/bash


Input_Domain()
{
    username="bounce"
    domain="google.com"
    subDomain="mail"

    read -p "Enter Domain Name: " domain
    domain=`echo ${domain}|tr -d ' /'`
    
    read -p "Enter Sub Domain Name: " subDomain
    subDomain=`echo ${subDomain}|tr -d ' /'`
}


Init_Server()
{
	setenforce 0
	getenforce
	sed -i 's/enforcing/disabled/g' /etc/selinux/config
	systemctl stop firewalld.service
	systemctl disable firewalld.service
	firewall-cmd --state
	
	yum remove sendmail
	yum -y install epel-release postfix dovecot
}

Postfix_Conf(){
	postconf -e myhostname=$subDomain.$domain
	postconf -e mydomain=$domain
	postconf -e myorigin='$mydomain'
	postconf -e inet_protocols=ipv4
	postconf -e inet_interfaces=all
	postconf -e mydestination=localhost
	
	touch /etc/postfix/virtual_mailbox_map
	echo $username@$domain $domain/$username/ >> /etc/postfix/virtual_mailbox_map
	postmap /etc/postfix/virtual_mailbox_map
	
	mkdir -p /var/mail/vhosts

	postconf virtual_mailbox_domains=$domain
	postconf virtual_mailbox_base=/var/mail/vhosts
	postconf virtual_mailbox_maps=hash:/etc/postfix/virtual_mailbox_map
	postconf virtual_minimum_uid=100
	postconf virtual_uid_maps=static:5000
	postconf virtual_gid_maps=static:5000


	groupadd -g 5000 vmail
	useradd -g vmail -u 5000 vmail -d /var/mail

	mkdir -p  /var/mail/vhosts/$domain/$username

	chown -R vmail:vmail /var/mail
	chown -R vmail:vmail /var/mail/*

	postconf -e smtpd_sasl_type=dovecot
	postconf -e smtpd_sasl_path=private/auth
	postconf -e smtpd_sasl_auth_enable=yes
	postconf -e smtpd_sasl_security_options=noanonymous
	postconf -e smtpd_sasl_local_domain='$myhostname'
	postconf -e smtpd_recipient_restrictions="permit_sasl_authenticated, permit_mynetworks, reject_unauth_destination"

	postconf bounce_queue_lifetime=300s
	postconf broken_sasl_auth_clients=yes
	postconf maximal_queue_lifetime=300s
	postconf maximal_backoff_time=300s


}


Postfix_Conf()
{
	sed -i '/^mail_location =.*/s/^/#/g' /etc/dovecot/conf.d/10-mail.conf 
	echo "mail_location = maildir:/var/mail/vhosts/%d/%n" >> /etc/dovecot/conf.d/10-mail.conf

	touch /etc/dovecot/virtual_user_list
	echo $username@$domain:{plain}firstpassword >> /etc/dovecot/virtual_user_list
	
	sed -i '/\!include auth-system\.conf\.ext/s/^/#/g' /etc/dovecot/conf.d/10-auth.conf
	sed -i '/\!include auth-passwdfile\.conf\.ext/s/^#//g' /etc/dovecot/conf.d/10-auth.conf

	sed -i '/^mail_privileged_group =.*/s/^/#/g' /etc/dovecot/conf.d/10-mail.conf
	echo "mail_privileged_group = mail" >> /etc/dovecot/conf.d/10-mail.conf

	sed -i '/^disable_plaintext_auth =.*/s/^/#/g' /etc/dovecot/conf.d/10-auth.conf
	echo "disable_plaintext_auth = no" >> /etc/dovecot/conf.d/10-auth.conf

	sed -i '/^auth_mechanisms =.*/s/^/#/g' /etc/dovecot/conf.d/10-auth.conf
	echo "auth_mechanisms = plain login" >> /etc/dovecot/conf.d/10-auth.conf


	auth10="
	passdb {
	  driver = passwd-file
	  args = username_format=%u /etc/dovecot/virtual_user_list
	}
	userdb {
	  driver = static
	  args = uid=vmail gid=vmail home=/var/mail/vhosts/%d/%n
	}
	"
	echo $auth10 > /etc/dovecot/conf.d/10-mail.conf

}






# SSH_DIR=$HOME
SSH_DIR="/root"

#if [ -e "/usr/bin/sw_vers" ]; then #mac os
#	SSH_DIR="/private/var/root"
#else
#	SSH_DIR="~"
#fi

    


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





