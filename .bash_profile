################################################################################
# Some installation scripts will write to this file. If this file exists, it
# will be read and executed by the bash login shell, and the subsequent profile
# files, ~/.bash_login and ~/.profile (the generic sh profile) will be ignored.
# To prevent some installation writing to and creating any of these files and
# obfuscating an unintended profile change, keep this file, the first profile
# file checked for, and source the other two profile files here, plus the rc.
# https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
################################################################################

source-existing-file() { if [ -f "$1" ]; then source "$1"; fi; }

# Pre-hook
source-existing-file ~/.include/.pre/.bash_profile

# Profiles
source-existing-file ~/.bash_login
source-existing-file ~/.profile

# rc
# Using ubuntu's /etc/skel/.profile as our ~/.profile already sources ~/.bashrc
# source-existing-file ~/.bashrc

# Post-hook
source-existing-file ~/.include/.post/.bash_profile
