#!/usr/bin/env sh
#

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

sudo rm -rf /usr/local/share/emacs/site-lisp/apel
sudo rm -rf /usr/local/share/emacs/${EMACS_VER}/site-lisp/emu
sudo rm -rf /usr/share/emacs/site-lisp/trr22
sudo rm -rf /var/lib/trr22
sudo rm -rf /usr/share/info/trr.info

