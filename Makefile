install:
	- git submodule init
	- git submodule update
	- cp -rv ./fonts/* ~/.fonts/
	- cp ./config/fg42.user.el ${HOME}/.fg42.el
	- echo "#! /bin/sh" > ./fg42
	- echo "export FG42_HOME=${HOME}/src/FG42" >> ./fg42
	- echo 'emacs --name FG42 --no-site-file --no-site-lisp --no-splash --title FG42 -l $FG42_HOME/fg42-config.el "$$@"' >> ./fg42
	- sudo ln -s `pwd`/fg42 /usr/local/bin/fg42
	- sudo mkdir -p /usr/share/fg42/
	- sudo cp -rv ./share/* /usr/share/fg42/
	- echo "Make sure to install external dependencies of FG42. For more info checkout README.md"
