#!/bin/bash


#For growBox-Install (Simple Install Script)
#Purpose - Initial system install script..
#Inputs  - Take in predifined options from console.
#Action  - Prep server/client by downloading the required 
#	  system binaries then clone repo and finally 
#	  setup the run setup script.
#Status  - Developing / Incomplete.

gbRootRepo='https://github.com/mjnshosting/growBox-Root.git'
gbStemRepo='https://github.com/mjnshosting/growBox-Stem.git'
gbBranchRepo='https://github.com/mjnshosting/growBox-Branch.git'
gbFlowerRepo='https://github.com/mjnshosting/growBox-Flower.git'


function do_help {
        echo "Help Menu"
        echo -e "\ngrowBox-Install.sh -iu -ofsk\n"
        echo "Usage:"
        echo "  Primary Options:"
        echo "  -h: This Help Menu"
        echo -e "  -i: Install the necessry binaries and edit system files \n      to prepare the system for the desired application.\n      *Implies -u"
        echo -e "  -u: Creates user account and modifies the system files to\n      allow that user access to GPIO pins."
        echo "  -d: Single device. -d 192.168.1.3"
        echo ""
        echo "  Secondary Options:"
        echo "  -r <username> <password-for-user>: Install growBox-Root role"
        echo "  -s <username> <password-for-user>: Install growBox-Stem role"
        echo "  -b <username> <password-for-user>: Install growBox-Branch role"
        echo "  -f <username> <password-for-user>: Install growBox-Flower role"
        echo "  -a <username> <password-for-user>: Install all growBox roles"
        echo ""
        echo "Ex:"
        echo -e "\033[0;33mgrowBox-Install.sh -i -b growboxuser password\e[0m"
        echo " - Will install all the system and app dependencies for a Branch device."
        echo "   Requires that a username and password be entered."
        echo ""
        echo -e "\033[0;33mgrowBox-Install.sh -u growboxuser password\e[0m"
        echo " - Will create a user named <username> <password-for-user>"
        echo "   Requires that a username and password be entered."
}

primary=$1; shift
case $primary in
	-h )
		do_help
		exit 0
		;;
esac
