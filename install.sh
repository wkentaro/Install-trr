#!/bin/sh

# install emacs
if ! [ -f /usr/bin/emacs23 ]; then
    sudo apt-get install emacs23
fi

# install apel
if ! [ -f /usr/local/share/emacs/23.3/site-lisp/emu/poe.el ]; then
    MAKE_FLAGS=installer=${USER} TRRDIR=/var/lib/trr22 LISPDIR=/usr/share/emacs/site-lisp/trr22 INFODIR=/usr/share/info BINDIR=/usr/share/emacs/site-lisp/trr22 SED=/bin/sed GREP=/bin/grep
    wget http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz
    tar zxvf apel-10.8.tar.gz
    cd apel-10.8
    make {$MAKE_FLAGS}
    sudo make install {$MAKE_FLAGS}
    cd ..
fi

# install trr
if ! [ -d /usr/share/emacs/site-lisp/trr22 ]; then
    wget https://trr22.googlecode.com/files/trr22_0.99-5.tar.gz
    tar zxvf trr22_0.99-5.tar.gz
    cd trr22-0.99
    cp ../apel-10.8/*.el .
    make all
    sudo make install
else
    echo """
    TRR is already installed.
    To use trr on emacs, please add lines below to your emacs config file. (ex. ~/.emacs.d/init.el or ~/.emacs)

    (add-to-list 'load-path "/usr/share/emacs/site-lisp/trr22")
    (add-to-list 'load-path "/usr/local/share/emacs/23.3/site-lisp/emu")
    (autoload 'trr "/usr/share/emacs/site-lisp/trr22/trr" nil t)

    Now you can play trr on your emacs by "M-x trr".
    """
    return
fi


# install & use nkf
if ! [ -f /usr/bin/nkf ]; then
    sudo apt-get install nkf
fi
sudo nkf -w --overwrite /var/lib/trr22/CONTENTS

# add score file
sudo touch /var/lib/trr22/record/SCORE-IC

# add trr and apel lisp files to lisp-path
cat <<-EOF

    Okay, the installation was successfully ended.
    Finally, please add lines below to your emacs config file. (ex. ~/.emacs.d/init.el or ~/.emacs)

    (add-to-list 'load-path "/usr/share/emacs/site-lisp/trr22")
    (add-to-list 'load-path "/usr/local/share/emacs/23.3/site-lisp/emu")
    (autoload 'trr "/usr/share/emacs/site-lisp/trr22/trr" nil t)

    Now you can play trr on your emacs by "M-x trr".

EOF
