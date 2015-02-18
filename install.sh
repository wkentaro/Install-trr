#!/bin/sh

# install emacs
if ! [ -f /usr/bin/emacs ]; then
    sudo apt-get install emacs
fi

# get ubuntu version
UBUNTU_VER=`lsb_release -r | awk '{print $0 = substr($0, 10)}'`
if [ "$UBUNTU_VER" = "14.04" ]; then
  EMACS_VER="24.3"
elif [ "$UBUNTU_VER" = "12.04" ]; then
  EMACS_VER="23.3"
else
  echo "Unsupported os version."
  return
fi

# install apel
wget http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz
tar zxf apel-10.8.tar.gz
if ! [ -f /usr/local/share/emacs/${EMACS_VER}/site-lisp/emu/poe.el ]; then
    cd apel-10.8
    make clean
    make
    sudo make install
    cd ..
fi

# install trr
if ! [ -d /usr/share/emacs/site-lisp/trr22 ]; then
    MAKE_FLAGS="installer=${USER}
                TRRDIR=/var/lib/trr22
                LISPDIR=/usr/share/emacs/site-lisp/trr22
                INFODIR=/usr/share/info BINDIR=/usr/share/emacs/site-lisp/trr22
                SED=/bin/sed GREP=/bin/grep"
    wget https://trr22.googlecode.com/files/trr22_0.99-5.tar.gz
    tar zxf trr22_0.99-5.tar.gz
    cd trr22-0.99
    cp ../apel-10.8/*.el .
    make clean
    make all ${MAKE_FLAGS}
    sudo make install ${MAKE_FLAGS}
else
    echo """
    TRR is already installed.
    To use trr on emacs, please add lines below to your emacs config file. (ex. ~/.emacs.d/init.el or ~/.emacs)

    (add-to-list 'load-path "/usr/share/emacs/site-lisp/trr22")
    (add-to-list 'load-path "/usr/local/share/emacs/${EMACS_VER}/site-lisp/emu")
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
    (add-to-list 'load-path "/usr/local/share/emacs/${EMACS_VER}/site-lisp/emu")
    (autoload 'trr "/usr/share/emacs/site-lisp/trr22/trr" nil t)

    Now you can play trr on your emacs by "M-x trr".

EOF
