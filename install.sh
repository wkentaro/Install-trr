#!/bin/sh

# install emacs
sudo apt-get install emacs23

# install apel
wget http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz
tar zxvf apel-10.8.tar.gz
cd apel-10.8
make
sudo make install
cd ..

# install trr
wget https://trr22.googlecode.com/files/trr22_0.99-5.tar.gz
tar zxvf trr22_0.99-5.tar.gz
cd trr22-0.99
cp ../apel-10.8/*.el .
make all
sudo make install

# install & use nkf
sudo apt-get install nkf
sudo nkf -w --overwrite /var/lib/trr22/CONTENTS

# add score file
sudo touch /var/lib/trr22/record/SCORE-IC

# add trr and apel lisp files to lisp-path
cat <<-EOF
--
Okay, the installation was successfully ended.
Finally, please add lines below to your emacs config file. (ex. ~/.emacs.d/init.el or ~/.emacs)

(add-to-list 'load-path "/usr/share/emacs/site-lisp/trr22")
(add-to-list 'load-path "/usr/local/share/emacs/23.3/site-lisp/emu")
(autoload 'trr "/usr/share/emacs/site-lisp/trr22/trr" nil t)

Now you can play trr on your emacs by "M-x trr".
EOF
