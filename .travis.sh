#!/bin/sh
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

# test trr
cat > test.el <<-EOF
(add-to-list 'load-path "/usr/local/share/emacs/${EMACS_VER}/site-lisp/emu")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/trr22")
(require 'trr)
(print (TRR:trainer-menu-buffer))
EOF
result=`emacs -batch -l test.el | tr -d '\n'`
if [ "$result" != '"Type & Menu"' ]; then
  exit 1
fi

