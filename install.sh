#!/usr/bin/env sh

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
  # download trr
  wget https://trr22.googlecode.com/files/trr22_0.99-5.tar.gz
  tar zxf trr22_0.99-5.tar.gz

  cd trr22-0.99

  # install & use nkf
  if ! [ -f /usr/bin/nkf ]; then
    sudo apt-get install nkf
  fi
  sudo nkf -w --overwrite CONTENTS

  # translate Japanese to English
  sed -i "s/ふつう/Normal/g" CONTENTS
  sed -i "s/やや難/Hard/g" CONTENTS
  sed -i "s/やや何/Hard/g" CONTENTS
  sed -i "s/推奨/Recommend/g" CONTENTS
  sed -i "s/安定してる/Stable/g" CONTENTS
  sed -i "s/見出しが多い/Lots_of_headers/g" CONTENTS
  sed -i "s/日本国憲法/Japan_Constitution/g" CONTENTS
  sed -i "s/合衆国憲法/USA_Constitution/g" CONTENTS
  sed -i "s/C言語/C_programs/g" CONTENTS
  sed -i "s/括弧が多い/Lots_of_parentheses/g" CONTENTS
  sed -i "s/Java言語/Java_programs/g" CONTENTS
  sed -i "s/いくつかの記号/Some_symbols/g" CONTENTS
  sed -i "s/Python言語/Python_programs/g" CONTENTS
  # wrong text filename
  sed -i "s/EmacsLisp/Elisp_programs/g" CONTENTS

  # change Makefile
  sed -i "s/japanese = t/japanese = nil/g" Makefile

  cp ../apel-10.8/*.el .
  make clean
  MAKE_FLAGS="installer=${USER}
              TRRDIR=/var/lib/trr22
              LISPDIR=/usr/share/emacs/site-lisp/trr22
              INFODIR=/usr/share/info
              BINDIR=/usr/share/emacs/site-lisp/trr22
              SED=/bin/sed GREP=/bin/grep"
  make all ${MAKE_FLAGS}
  sudo make install ${MAKE_FLAGS}
  sudo cp -r record /var/lib/trr22/
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


# add trr and apel lisp files to lisp-path
cat <<-EOF

    Okay, the installation was successfully ended.
    Finally, please add lines below to your emacs config file. (ex. ~/.emacs.d/init.el or ~/.emacs)

    (add-to-list 'load-path "/usr/share/emacs/site-lisp/trr22")
    (add-to-list 'load-path "/usr/local/share/emacs/${EMACS_VER}/site-lisp/emu")
    (autoload 'trr "/usr/share/emacs/site-lisp/trr22/trr" nil t)

    Now you can play trr on your emacs by "M-x trr".

EOF
