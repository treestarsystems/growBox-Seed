#!/bin/bash

#For growBox-Seed (Simple Install Script)
#Purpose - Initial system install script..
#Inputs  - Take in predifined options from console.
#Action  - Prep server/client by downloading the required
#	   system binaries then clone repo and finally
#	   setup the run setup script.
#Status  - Requires final testing and gpio access test.

#If username or password are blank then one is provided. Need something to catch errors. Although the log is the lazy way.

gbRootRepo='https://github.com/treestarsystems/growBox-Root.git'
gbStemRepo='https://github.com/treestarsystems/growBox-Stem.git'
gbBranchRepo='https://github.com/treestarsystems/growBox-Branch.git'
gbFlowerRepo='https://github.com/treestarsystems/growBox-Flower.git'
gbSoilRepo='https://github.com/treestarsystems/growBox-Soil.git'
gbPetalRepo='https://github.com/treestarsystems/growBox-Petal.git'
gbSeedLog="growBox-Seed.log"

#This takes the repo. Split it into and add its part to an array
#Finally referencing the last item then chopping off from the "." on
function genrandom {
	date +%s | sha256sum | base64 | head -c $1 ; echo
}

#Returns projects full name Ex: growBox-Root
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

#gen_user_name <project>
function gen_user_name {
	strip_dash="${1##*-}"
	tolower=$(sed -e 's/\(.*\)/\L\1/' <<< "gb$strip_dash$(genrandom 5)")
	echo $tolower$random
}

function do_user_create {
	if ["$user_name" == ''] || ["$password" == '']
		then
			user_name=$(sed -e 's/\(.*\)/\L\1/' <<<$(gen_user_name $project))
			password=$(genrandom 20)
	fi
	#Add user to system
	useradd -d $gbSeedDir/$project -s /bin/bash -U $user_name
	echo -e "$password\n$password" | passwd $user_name
	chown -R $user_name:$user_name $gbSeedDir/$project
	echo Username: $user_name
	echo Password: $password
}

function do_user_create_only {
	if ["$user_name" == ''] || ["$password" == '']
		then
			user_name=$(sed -e 's/\(.*\)/\L\1/' <<<$(gen_user_name $project))
			password=$(genrandom 20)
	fi
	#Add user to system
	useradd -s /bin/bash -U $user_name
	echo -e "$password\n$password" | passwd $user_name
	echo Username: $user_name
	echo Password: $password
}

function do_system_dependencies {
	echo "Installing system dependencies"
	SKIP_WARNING=1 rpi-update
	apt update
	apt -y upgrade
	apt install -y nodejs nmap whois rsync screen git build-essential npm nano
	npm install pm2 -g
}

function do_system_dependencies_soil {
	echo "Installing Soil system dependencies"
	apt update
	apt -y upgrade
	apt-get install -y zfsutils-linux nfs-kernel-server ifenslave ifupdown resolvconf gdisk
	rm /etc/netplan/01-netcfg.yaml
}

function do_system_dependencies_petal {
	echo "Installing Petal system dependencies"
	apt update
	apt -y upgrade
	apt install -y uv4l uv4l-raspicam uv4l-raspicam-extras uv4l-server uv4l-uvc uv4l-xscreen uv4l-mjpegstream uv4l-dummy uv4l-webrtc uv4l-xmpp-bridge
}

function do_config_edit_basic {
	#Add config options to the /boot/config.txt
	echo -e '\n#Temp Sensor Edit\ndtoverlay=w1-gpio\n\n#Disable Warning Overlays and allow turbo mode\navoid_warnings=2\n' >> /boot/config.txt
}

function do_config_edit_petal {
	#Add config options to the /boot/config.txt
	echo -e "\nstart_x=1\ngpu_mem=128\ndisable_camera_led=1" >> /boot/config.txt
	sed -i "s/nopreview = no/nopreview = yes/g" /etc/uv4l/uv4l-raspicam.conf
}

#Needs a lot of work to get right but I will use the work done with postReceive.
function do_pm2conf {
	echo -e "" > /root/ecosystem.config.js
}

function do_root {
	project=$(do_parse_project $gbRootRepo)
	echo "Installing Root Role"
	echo "Add Mongo and Node repos then apt update/upgrade"
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
	echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" |  tee /etc/apt/sources.list.d/mongodb-org-4.0.list
	curl -sL https://deb.nodesource.com/setup_11.x |  -E bash -
	do_system_dependencies
	apt install -y mongodb-org
	mkdir $gbSeedDir
	cd $gbSeedDir
	git clone $gbRootRepo
	cd $gbSeedDir/$project
	npm install
	do_user_create
	#Needs a lot of work to get right but I will use the work done with postReceive.
#	do_pm2conf
#	pm2 /root/ecosystem.config.js
#	pm2 startup
}

function do_stem {
	project=$(do_parse_project $gbStemRepo)
	echo "Installing Stem Role"
	do_system_dependencies
	do_config_edit_basic
	mkdir $gbSeedDir
	cd $gbSeedDir
	git clone $gbStemRepo
	cd $gbSeedDir/$project
	npm install
	do_user_create
	#Needs a lot of work to get right but I will use the work done with postReceive.
#	do_pm2conf
#	pm2 /root/ecosystem.config.js
#	pm2 startup
}

function do_branch {
	project=$(do_parse_project $gbBranchRepo)
	echo "Installing Branch Role"
	do_system_dependencies
	do_config_edit_basic
	mkdir $gbSeedDir
	cd $gbSeedDir
	git clone $gbBranchRepo
	cd $gbSeedDir/$project
	npm install
	do_user_create
	#Needs a lot of work to get right but I will use the work done with postReceive.
#	do_pm2conf
#	pm2 /root/ecosystem.config.js
#	pm2 startup
}

function do_flower {
	project=$(do_parse_project $gbFlowerRepo)
	echo "Installing Flower Role"
	do_system_dependencies
	do_config_edit_basic
	mkdir $gbSeedDir
	cd $gbSeedDir
	git clone $gbFlowerRepo
	cd $gbSeedDir/$project
	npm install
	do_user_create
	#Needs a lot of work to get right but I will use the work done with postReceive.
#	do_pm2conf
#	pm2 /root/ecosystem.config.js
#	pm2 startup
}

function do_soil {
	project=$(do_parse_project $gbSoilRepo)
	echo "Installing Soil Role"
	do_system_dependencies
	do_system_dependencies_soil
}

function do_petal {
	project=$(do_parse_project $gbPetalRepo)
	echo "Installing Petal Role"
	do_config_edit_basic
	curl http://www.linux-projects.org/listing/uv4l_repo/lpkey.asc | sudo apt-key add -
	echo "deb http://www.linux-projects.org/listing/uv4l_repo/raspbian/stretch stretch main" >> /etc/apt/sources.list
	do_system_dependencies
	do_config_edit_petal
	mkdir $gbSeedDir
	cd $gbSeedDir
	git clone $gbPetalRepo
	cd $gbSeedDir/$project
	npm install
	do_user_create
	#Needs a lot of work to get right but I will use the work done with postReceive.
#	do_pm2conf
#	pm2 /root/ecosystem.config.js
#	pm2 startup
}

function do_all {
	echo "Installing All Roles"
	do_system_dependencies
	array=($gbRootRepo $gbStemRepo $gbBranchRepo $gbFlowerRepo $gbSoil $gbPetal)
	for i in "${array[@]}";
        do
		project=$(do_parse_project $i)
		echo "Now cloninging $project"
		mkdir $gbSeedDir
		cd $gbSeedDir
		git clone $i
		cd $gbSeedDir/$project
		npm install
		if ["$project" != 'growBox-Root'] || ["$project" != 'growBox-Soil']
			then
				do_config_edit_basic
		fi
		if ["$project" == 'growBox-Petal']
			then
				do_config_edit_petal
		fi
		do_pm2conf
        done

	#This is a bit different than the other create user functions since a project isnt used.
	if ["$user_name" == ''] || ["$password" == '']
		then
			user_name=gb$(sed -e 's/\(.*\)/\L\1/' <<<$(genrandom 10))
			password=$(genrandom 20)
	fi
	#Add user to system
	useradd -d $gbSeedDir/$project -s /bin/bash -U $user_name
	echo -e "$password\n$password" | passwd $user_name
	chown -R $user_name:$user_name $gbSeedDir/$project

	echo Username: $user_name
	echo Password: $password
#	pm2 /root/ecosystem.config.js
#	pm2 startup
}

function do_help {
        echo "Help Menu"
        echo -e "\n\033[0;33msudo ./growBox-Seed.sh -iu -rsbfa\e[0m\n"
        echo -e "\033[0;33m ** All logs are written to your user directory ** \e[0m \n"
        echo "Usage:"
        echo "  Primary Options:"
        echo "  -h: This Help Menu"
        echo -e "  -i  <install directory>: Install the necessry binaries and \n      edit system files to prepare the system for the desired\n      application. \033[0;33m*Implies -u\e[0m"
        echo -e "  -u: Creates user account and modifies the system files to\n      allow that user access to GPIO pins."
        echo ""
        echo "  Secondary Options:"
        echo "  -r <username> <password-for-user>: Install growBox-Root role"
        echo "  -s <username> <password-for-user>: Install growBox-Stem role"
        echo "  -b <username> <password-for-user>: Install growBox-Branch role"
        echo "  -f <username> <password-for-user>: Install growBox-Flower role"
        echo "  -d <username> <password-for-user>: Install growBox-Soil role"
        echo "  -p <username> <password-for-user>: Install growBox-Petal role"
        echo "  -a <username> <password-for-user>: Install all growBox roles"
        echo ""
        echo -e "\033[0;33m  ** If a username AND a password is not provided it will be generated for you. ** \e[0m \n"
        echo "Ex:"
        echo -e "\033[0;33msudo ./growBox-Seed.sh -i /opt -b growboxuser password\e[0m"
        echo " - Will install all the system and app dependencies for a Branch device."
        echo "   Requires that a username and password be entered."
        echo ""
        echo -e "\033[0;33msudo ./growBox-Seed.sh -u growboxuser password\e[0m"
        echo " - Will create a user named <username> with password <password-for-user>"
        echo -e "   Requires that a username and password be entered.\n"
}

function do_options {
case $secondary in
	-r )
		echo -e "\n Install directory: $gbSeedDir \n Log file location: ~/$gbSeedLog-root\n\n **Check log file for credentials** \n PLEASE DELETE WHEN DONE!!!\n rm ~/$gbSeedLog-root\n"
		do_root $user_name $password > ~/$gbSeedLog-root 2>&1
		;;
	-s )
		echo -e "\n Install directory: $gbSeedDir \n Log file location: ~/$gbSeedLog-stem\n\n **Check log file for credentials** \n PLEASE DELETE WHEN DONE!!!\n rm ~/$gbSeedLog-stem\n"
		do_stem $user_name $password > ~/$gbSeedLog-stem 2>&1
		;;
	-b )
		echo -e "\n Install directory: $gbSeedDir \n Log file location: ~/$gbSeedLog-branch\n\n **Check log file for credentials** \n PLEASE DELETE WHEN DONE!!!\n rm ~/$gbSeedLog-branch\n"
		do_branch $user_name $password > ~/$gbSeedLog-branch 2>&1
		;;
	-f )
		echo -e "\n Install directory: $gbSeedDir \n Log file location: ~/$gbSeedLog-flower\n\n **Check log file for credentials** \n PLEASE DELETE WHEN DONE!!!\n rm ~/$gbSeedLog-flower\n"
		do_flower $user_name $password > ~/$gbSeedLog-flower 2>&1
 		;;
	-d )
		echo -e "\n Install directory: $gbSeedDir \n Log file location: ~/$gbSeedLog-soil\n\n **Check log file for credentials** \n PLEASE DELETE WHEN DONE!!!\n rm ~/$gbSeedLog-soil\n"
		do_soil $user_name $password > ~/$gbSeedLog-soil 2>&1
 		;;
	-p )
		echo -e "\n Install directory: $gbSeedDir \n Log file location: ~/$gbSeedLog-petal\n\n **Check log file for credentials** \n PLEASE DELETE WHEN DONE!!!\n rm ~/$gbSeedLog-petal\n"
		do_petal $user_name $password > ~/$gbSeedLog-flower 2>&1
 		;;
	-a )
		echo -e "\n Install directory: $gbSeedDir \n Log file location: ~/$gbSeedLog-all\n\n **Check log file for credentials** \n PLEASE DELETE WHEN DONE!!!\n rm ~/$gbSeedLog-all\n"
		do_all $user_name $password > ~/$gbSeedLog-all 2>&1
		;;
	"" )
		echo -e "\033[0;31mRequires a Secondary Option\e[0m" 1>&2
		echo -e "\033[0;33msudo ./growBox-Seed.sh -h: For Help Menu\e[0m"
		exit 1
		;;
	* )
		echo -e "\033[0;31mInvalid Secondary Option: $secondary \e[0m" 1>&2
		echo -e "\033[0;33msudo ./growBox-Seed.sh -h: For Help Menu\e[0m"
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
		gbSeedDir=$1; shift
		secondary=$1; shift
		user_name=$1
		password=$2
		if [ "${secondary}" ]
			then
				do_options
		else
			echo -e "\033[0;31mPlease enter a valid Secondary Option\e[0m"
			exit 1
		fi

		shift $((OPTIND -1))
		;;
	-u )
		secondary=$1; shift
		user_name=$1
		password=$2
		do_user_create_only $user_name $password > ~/$gbSeedLog-adduser 2>&1

		shift $((OPTIND -1))
		;;
	* )
		echo -e "\033[0;31mInvalid Primary Option: $secondary \e[0m" 1>&2
		echo -e "\033[0;33msudo ./growBox-Seed.sh -h: For Help Menu\e[0m"
		exit 1
		;;
esac
