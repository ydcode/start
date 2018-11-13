#!/bin/bash



Dovecot_Conf()
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

	sed -i '/^protocols =.*/s/^/#/g' /etc/dovecot/dovecot.conf
	echo "protocols = imap" >> /etc/dovecot/dovecot.conf

	sed -i '/^listen =.*/s/^/#/g' /etc/dovecot/dovecot.conf
	echo "listen = *" >> /etc/dovecot/dovecot.conf

	
	sed -i '/^ssl =.*/s/^/#/g' /etc/dovecot/conf.d/10-ssl.conf
	echo "ssl = no" >> /etc/dovecot/conf.d/10-ssl.conf


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
	
	Dovecot_Conf
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
	
	Postfix_Conf
}


Input_Domain()
{
    username="bounce"
    domain="google.com"
    subDomain="mail"

    read -p "Enter Domain Name: " domain
    domain=`echo ${domain}|tr -d ' /'`
    
    read -p "Enter Sub Domain Name: " subDomain
    subDomain=`echo ${subDomain}|tr -d ' /'`
    
    Init_Server
}





Check_Domain_Right()
{
	echo "${domain}  Right ?"
	read -p "[Y/n]: Y " domainRight

	case "${domainRight}" in
	[yY][eE][sS]|[yY])
		echo "You will Add Domain:: ${domainRight} "
		domainRight="y"
	;;
	[nN][oO]|[nN])
		echo "No Domain"
		domainRight="n"
	;;
	*)
        echo "No input,Right, will add Domain: ${domain}."
        domainRight="y"
    esac

    if [ "${domainRight}" = "y" ]; then
       echo "Right, will add Domain: ${domain}."
    else
        Input_Domain
    fi
}



Input_Domain


systemctl start postfix && systemctl enable postfix
netstat -anlpt






