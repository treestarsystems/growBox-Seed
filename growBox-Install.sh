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
gbInstallLog=growBox-Install.log

#This takes the repo. Split it into and add its part to an array
#Finally referencing the last item then chopping off from the . on

function genrandom {
	date +%s | sha256sum | base64 | head -c $1 ; echo
}

function do_parse_project {
	array=()
	IFS='/'
	read -ra ADDR <<< "$1"
	for i in "${ADDR[@]}";
	do
		array+=("$i")
	done
	echo "${array[-1]%.*}"
}

# gen_user_name <project>
function gen_user_name {
	strip_dash="${1##*-}"
	tolower=$(sed -e 's/\(.*\)/\L\1/' <<< "gb$strip_dash$(genrandom 5)")
	echo $tolower$random
}

function do_root {
#	echo "Installing Root system dependencies"
#	echo "Add Mongo and Node repos then apt update/upgrade"
#	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 > ./gbInstallLog 2>&1
#	echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list > ./gbInstallLog 2>&1
#	curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash - > ./gbInstallLog 2>&1
#	apt update > ./$gbInstallLog-$project 2>&1
#	apt -y upgrade > ./$gbInstallLog-$project 2>&1
#	sudo apt install -y mongodb-org nodejs nmap whois rsync screen minicom git > ./$gbInstallLog 2>&1
#	cd /opt
#	git clone $gbRootRepo > ./$gbInstallLog-$project 2>&1
	project=$(do_parse_project $gbRootRepo)
#	cd /opt/$project
#	npm install

	#If username or password are blank then one is provided. Need something to catch errors. Although the log is the lazy way.
	if [$user_name == ''] || [$password == '']
		then
			user_name=$(gen_user_name $project)
			password=$(genrandom 20)
	fi

	echo $user_name $password
}

function do_stem {
	echo "Installing Root system dependencies"
	project=$(do_parse_project $gbStemRepo)
#	apt update > ./$gbInstallLog-$project 2>&1
#	apt -y upgrade > ./$gbInstallLog-$project 2>&1
#	sudo apt install -y mongodb-org nodejs nmap whois rsync screen minicom git > ./$gbInstallLog 2>&1
#	cd /opt
#	git clone $gbStemRepo > ./$gbInstallLog-$project 2>&1
#	cd /opt/$project
#	npm install
}

function do_branch {
	echo "Branch"
	project=$(do_parse_project $gbBranchRepo)
#	apt update > ./$gbInstallLog-$project 2>&1
#	apt -y upgrade > ./$gbInstallLog-$project 2>&1
#	cd /opt
#	git clone $gbBranchRepo > ./$gbInstallLog-$project 2>&1
#	cd /opt/$project
#	npm install
}

function do_flower {
	echo "Flower"
	project=$(do_parse_folder $gbFlowerRepo)
#	apt update > ./$gbInstallLog-$project 2>&1
#	apt -y upgrade > ./$gbInstallLog-$project 2>&1
#	cd /opt
#	git clone $gbFlowerRepo > ./$gbInstallLog-$project 2>&1
#	cd /opt/$project
#	npm install
}

function do_all {
	echo "All"
	array=($gbRootRepo $gbStemRepo $gbBranchRepo $gbFlowerRepo)
	for i in "${array[@]}";
        do
		project=$(do_parse_project $i)
#		apt update > ./$gbInstallLog-all 2>&1
#		apt -y upgrade > ./$gbInstallLog-all 2>&1
#		cd /opt
#		git clone $i > ./$gbInstallLog-all 2>&1
#		cd /opt/$project
#		npm install
        done

}

function do_help {
        echo "Help Menu"
        echo -e "\n\033[0;33msudo ./growBox-Install.sh -iu -ofsk\e[0m\n"
        echo "Usage:"
        echo "  Primary Options:"
        echo "  -h: This Help Menu"
        echo -e "  -i: Install the necessry binaries and edit system files \n      to prepare the system for the desired application.\n      *Implies -u"
        echo -e "  -u: Creates user account and modifies the system files to\n      allow that user access to GPIO pins."
        echo ""
        echo "  Secondary Options:"
        echo "  -r <username> <password-for-user>: Install growBox-Root role"
        echo "  -s <username> <password-for-user>: Install growBox-Stem role"
        echo "  -b <username> <password-for-user>: Install growBox-Branch role"
        echo "  -f <username> <password-for-user>: Install growBox-Flower role"
        echo "  -a <username> <password-for-user>: Install all growBox roles"
        echo ""
        echo "Ex:"
        echo -e "\033[0;33msudo ./growBox-Install.sh -i -b growboxuser password\e[0m"
        echo " - Will install all the system and app dependencies for a Branch device."
        echo "   Requires that a username and password be entered."
        echo ""
        echo -e "\033[0;33msudo ./growBox-Install.sh -u growboxuser password\e[0m"
        echo " - Will create a user named <username> <password-for-user>"
        echo "   Requires that a username and password be entered."
}

function do_options {
case $secondary in
	-r )
		do_root
		;;
	-s )
		do_stem
		;;
	-b )
		do_branch
		;;
	-f )
		do_flower
		;;
	-a )
		do_all
		;;
	"" )
		echo -e "\033[0;31mRequires a Secondary Option\e[0m" 1>&2
		echo "roku_controller.sh -h: For Help Menu"
		exit 1
		;;
	* )
		echo -e "\033[0;31mInvalid Secondary Option: $secondary \e[0m" 1>&2
		echo "roku_controller.sh -h: For Help Menu"
		exit 1
		;;
esac
}

function do_options {
case $secondary in
	-r )
		do_root $user_name $password
		;;
	-s )
		do_stem $user_name $password
		;;
	-b )
		do_branch $user_name $password
		;;
	-f )
		do_flower $user_name $password
		;;
	-a )
		do_all $user_name $password
		;;
	"" )
		echo -e "\033[0;31mRequires a Secondary Option\e[0m" 1>&2
		echo "sudo ./growBox-Install.sh -h: For Help Menu"
		exit 1
		;;
	* )
		echo -e "\033[0;31mInvalid Secondary Option: $secondary \e[0m" 1>&2
		echo "sudo ./growBox-Install.sh -h: For Help Menu"
		exit 1
		;;
esac
}


primary=$1; shift
case $primary in
	-h )
		do_help
		exit 0
		;;

	-i )
		secondary=$1; shift
		user_name=$1
		password=$2
		do_options

		shift $((OPTIND -1))
		;;
	-u )
		secondary=$1; shift
		user_name=$1
		password=$2
		do_options

		shift $((OPTIND -1))
		;;
esac
