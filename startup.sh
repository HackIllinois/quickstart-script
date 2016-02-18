echo "Welcome to the HackIllinois Installer"
echo "Please choose a framework to get started with:"
echo "    1). Node.JS"
echo "    2). Ruby on Rails"
echo "    3). Django"
echo "    4). Flask"
echo "    5). Android Studio"
echo "    6). Arduino"
echo "Enter your choice: "

read choice

echo "Please choose a name for your app: "

read appName

curl "http://104.131.25.125/script?s=${choice}&appName=${appName}" &

pkg_mgr_APT=$(which apt-get)
pkg_mgr_YUM=$(which yum)
pkg_mgr_EMG=$(which emerge)
pkg_mgr_PAC=$(which pacman)

# No color bold
bold=$(tput bold)
normal=$(tput sgr0)

red=$(tput setaf 1)
blue=$(tput setaf 6)


sysName=$(uname)

if [ "${sysName}" == "Darwin" ]; then
	#Basic Dependencies
	echo "Checking if Homebrew is installed..."
	hbrew_check=$(which brew)
	if [ "${hbrew_check}" == "" ]; then
		echo "Homebrew not found, installing..."
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	echo "Checking if wget is installed..."
	wget_check=$(which wget)
	if [ "${wget_check}" == "" ]; then
		echo "Installing wget..."
		brew install wget
	fi

	#Install the chosen framework
	if [ "${choice}" == "1" ]; then
		brew install node
		brew upgrade node
		echo "Installing Grunt-CLI (Needs root)..."
		sudo npm install -g grunt-cli
	elif [ "${choice}" == "2" ]; then
		brew install rbenv ruby-build
		yes|sudo gem install rails -v 4.2.4
		rbenv rehash
		rails -v
        rails new "$appName"
        cd "$appName"
        rake db:create
        echo "${blue}Your project is now ready! Type in ${bold}rails server${normal} to start your server.${normal}"
        echo "${blue}You can then visit ${bold}http://localhost:3000${normal}${blue} to view your new website.${normal}"
	elif [ "${choice}" == "3" ]; then
		echo "${bold}NOTE:${normal} The Python 2.X version of Django will be installed"
		sudo easy_install pip
		sudo pip install django
		django-admin startproject "$appName"
		cd "$appName"
		echo "${blue}Your project is now ready! Type in ${bold}python manage.py runserver${normal} ${blue}to start your server.${normal}"
		echo "${blue}You can then visit ${bold}http://127.0.0.1:8000/${normal}${blue} to view your new website.${normal}"
	elif [ "${choice}" == "4" ]; then
		echo "${bold}NOTE:${normal} The Python 2.X version of Flask will be installed"
		sudo easy_install pip
		sudo pip install flask
        touch "flask_quick_start.py"
        echo "from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World!'

if __name__ == '__main__':
    app.run()" > flask_quick_start.py
    echo "${blue}Your project is now ready! Type in ${bold}python flask_quick_start.py${normal} ${blue}to start your server.${normal}"
    echo "${blue}You can then visit ${bold}http://127.0.0.1:5000/${normal}${blue} to view your new website.${normal}"
	elif [ "${choice}" == "5" ]; then
		wget "https://dl.google.com/dl/android/studio/ide-zips/1.5.1.0/android-studio-ide-141.2456560-mac.zip" -O "Android-Studio.zip"
		unzip Android-Studio.zip
		mv "Android Studio.app" "/Applications/Android Studio.app"
        echo "${blue}Android Studio is now installed! Run it from the Applications folder!${normal}"
	elif [ "${choice}" == "6" ]; then
		wget "https://www.arduino.cc/download.php?f=/arduino-nightly-macosx.zip" -O "Arduino-Mac-HackIllinois.zip"
		unzip "Arduino-Mac-HackIllinois.zip"
		mv "Arduino.app" "/Applications/Arduino.app"
        open "/Applications/Arduino.app"
        echo "${blue}The Arduino IDE is now installed! Run it from the Applications folder!${normal}"
	fi
else
	curl_check=$(which curl)
	#Install curl if not installed
	if [ "${curl_check}" == "" ]; then
		if [ "${pkg_mgr_APT}" != "" ]; then
			sudo apt-get install curl
		elif [ "${pkg_mgr_YUM}" != "" ]; then
			sudo yum -y install curl
		elif [ "${pkg_mgr_EMG}" != "" ]; then
			sudo emerge curl
		elif [ "${pkg_mgr_PAC}" != "" ]; then
			sudo pacman -S curl
		fi
	fi
	if ["${choice}" == "1" ]; then
		if [ "${pkg_mgr_APT}" != "" ]; then
			curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
			sudo apt-get install -y nodejs
			sudo apt-get install -y build-essential
			echo "Installing Grunt-CLI (Needs root)..."
			sudo npm install -g grunt-cli
		elif [ "${pkg_mgr_YUM}" != "" ]; then
			curl --silent --location https://rpm.nodesource.com/setup_5.x | bash -
			sudo yum -y install nodejs
			sudo yum groupinstall 'Development Tools'
			echo "Installing Grunt-CLI (Needs root)..."
			sudo npm install -g grunt-cli
		elif [ "${pkg_mgr_EMG}" != "" ]; then
			sudo emerge nodejs
			echo "Installing Grunt-CLI (Needs root)..."
			sudo npm install -g grunt-cli
		elif [ "${pkg_mgr_PAC}" != "" ]; then
			pacman -S nodejs npm
			echo "Installing Grunt-CLI (Needs root)..."
			sudo npm install -g grunt-cli
		fi
	elif ["${choice}" == "2" ]; then
		if [ "${pkg_mgr_APT}" != "" ]; then
			sudo apt-get install -y ruby-full
			gem install rails
			rails new "$appName"
			cd "$appName"
			echo "Your project is now ready! Type in ${bold}bin/rails server${normal} to start your server."
			echo "You can then visit ${bold}http://localhost:3000${normal} to view your new website."
		elif [ "${pkg_mgr_YUM}" != "" ]; then
			sudo yum -y install ruby
			gem install rails
			rails new "$appName"
			cd "$appName"
			echo "Your project is now ready! Type in ${bold}bin/rails server${normal} to start your server."
			echo "You can then visit ${bold}http://localhost:3000${normal} to view your new website."
		elif [ "${pkg_mgr_EMG}" != "" ]; then
			sudo emerge dev-lang/ruby
			gem install rails
			rails new "$appName"
			cd "$appName"
			echo "Your project is now ready! Type in ${bold}bin/rails server${normal} to start your server."
			echo "You can then visit ${bold}http://localhost:3000${normal} to view your new website."
		elif [ "${pkg_mgr_PAC}" != "" ]; then
			sudo pacman -S ruby
			gem install rails
			rails new "$appName"
			cd "$appName"
			echo "Your project is now ready! Type in ${bold}bin/rails server${normal} to start your server."
			echo "You can then visit ${bold}http://localhost:3000${normal} to view your new website."
		fi
	elif ["${choice}" == "3" ]; then
		if [ "${pkg_mgr_APT}" != "" ]; then
			sudo apt-get install python-setuptools
			echo "${bold}NOTE:${normal} The Python 2.X version of Django will be installed"
			sudo easy_install pip
			sudo pip install django
			mkdir "$appName"
			cd "$appName"
			django-admin startproject "$appName"
			echo "Your project is now ready! Type in ${bold}python manage.py runserver${normal} to start your server."
		echo "You can then visit ${bold}http://127.0.0.1:8000/${normal} to view your new website."
		elif [ "${pkg_mgr_YUM}" != "" ]; then
			sudo yum install python-setuptools
			echo "${bold}NOTE:${normal} The Python 2.X version of Django will be installed"
			sudo easy_install pip
			sudo pip install django
			mkdir "$appName"
			cd "$appName"
			django-admin startproject "$appName"
			echo "Your project is now ready! Type in ${bold}python manage.py runserver${normal} to start your server."
		echo "You can then visit ${bold}http://127.0.0.1:8000/${normal} to view your new website."
		elif [ "${pkg_mgr_EMG}" != "" ]; then
			sudo emerge dev-python/django
			mkdir "$appName"
			cd "$appName"
			django-admin startproject "$appName"
			echo "Your project is now ready! Type in ${bold}python manage.py runserver${normal} to start your server."
		echo "You can then visit ${bold}http://127.0.0.1:8000/${normal} to view your new website."
		elif [ "${pkg_mgr_PAC}" != "" ]; then
			sudo pacman -S python-django
			mkdir "$appName"
			cd "$appName"
			django-admin startproject "$appName"
			echo "Your project is now ready! Type in ${bold}python manage.py runserver${normal} to start your server."
		echo "You can then visit ${bold}http://127.0.0.1:8000/${normal} to view your new website."
		fi
	elif ["${choice}" == "4" ]; then
		if [ "${pkg_mgr_APT}" != "" ]; then
			sudo apt-get install python-setuptools
			echo "${bold}NOTE:${normal} The Python 2.X version of Flask will be installed"
			sudo easy_install pip
			sudo pip install flask
		elif [ "${pkg_mgr_YUM}" != "" ]; then
			sudo yum install python-setuptools
			echo "${bold}NOTE:${normal} The Python 2.X version of Django will be installed"
			sudo easy_install pip
			sudo pip install flask
		elif [ "${pkg_mgr_EMG}" != "" ]; then
			sudo emerge dev-python/flask
		elif [ "${pkg_mgr_PAC}" != "" ]; then
			sudo pacman -S python-flask
		fi
	elif [ "${choice}" == "5" ]; then
		wget "https://dl.google.com/dl/android/studio/ide-zips/1.5.1.0/android-studio-ide-141.2456560-linux.zip" -O "Android-Studio.zip"
		unzip "Android-Studio.zip"
		cd "android-studio/bin"
		./studio.sh
	elif [ "${choice}" == "6" ]; then
		ARCH=$(uname -m)
		if [ "$ARCH" = "i686" ];then
			wget "https://www.arduino.cc/download_handler.php?f=/arduino-1.6.7-linux32.tar.xz" -O "Arduino.tar.xz"
		else
			wget "https://www.arduino.cc/download_handler.php?f=/arduino-1.6.7-linux64.tar.xz" -O "Arduino.tar.xz"
		fi
		tar -xJf "Arduino.tar.xz"
		cd arduino-1.6.7
		./install.sh
	fi
fi

echo "You are good to go! Happy hacking and good luck!"
