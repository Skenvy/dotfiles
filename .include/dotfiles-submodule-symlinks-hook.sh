#!/bin/bash

# Set CLOBBER_CHECKEDIN_ROOT_IGNORELIST so that these files will be left as they
# are in this repo, and not copied out of the submodule. This example includes
# the install.sh, which is required if you're using the provided install.sh, but
# not strictly necessary if you're customising your setup more. This example
# also includes ignoring the three vs code settings, as they are added to this
# base as an example, but should only be kept in this list if you are keeping
# a different version in your copy of this base branch than the version you're
# also keeping in your fork of this repo's main branch. We also ignore LICENSE,
# so that the same CC-BY-SA can be checked in in main, home, and this base.
CLOBBER_CHECKEDIN_ROOT_IGNORELIST=(
"LICENSE"
"install.sh"
".config/Code/User/settings.json"
"Library/Application Support/Code/User/settings.json"
"AppData/Roaming/Code/User/settings.json"
)
