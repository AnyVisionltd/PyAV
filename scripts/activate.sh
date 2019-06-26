#!/bin/bash

# Make sure this is sourced.
if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
    echo This must be sourced.
    exit 1
fi

export PYAV_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."; pwd)"

if [[ "$TRAVIS" ]]; then
    PYAV_LIBRARY=$LIBRARY
fi

if [[ ! "$PYAV_LIBRARY" ]]; then

    # Pull from command line argument.
    if [[ "$1" ]]; then
        PYAV_LIBRARY="$1"
    else
        PYAV_LIBRARY=ffmpeg-4.1.3
        echo "No \$PYAV_LIBRARY set; defaulting to $PYAV_LIBRARY"
    fi
fi
export PYAV_LIBRARY
_lib_parts=(${PYAV_LIBRARY//-/ })
if [[ ${#_lib_parts[@]} != 2 ]]; then
    echo "Malformed \$PYAV_LIBRARY: \"$PYAV_LIBRARY\""
    exit 1
fi
export PYAV_LIBRARY_NAME=${_lib_parts[0]}
export PYAV_LIBRARY_VERSION=${_lib_parts[1]}
export PYAV_PYTHON=python
export PYAV_PIP=pip

# Just a flag so that we know this was supposedly run.
export _PYAV_ACTIVATED=1

if [[ ! "$PYAV_LIBRARY_BUILD_ROOT" && -d /vagrant ]]; then
    # On Vagrant, building the library in the shared directory causes some
    # problems, so we move it to the user's home.
    PYAV_LIBRARY_ROOT="/home/vagrant/vendor"
fi
export PYAV_LIBRARY_ROOT="${PYAV_LIBRARY_ROOT-$PYAV_ROOT/vendor}"
export PYAV_LIBRARY_BUILD="${PYAV_LIBRARY_BUILD-$PYAV_LIBRARY_ROOT/build}"
export PYAV_LIBRARY_PREFIX="$PYAV_LIBRARY_BUILD/$PYAV_LIBRARY"

export PATH="$PYAV_LIBRARY_PREFIX/bin:$PATH"
export PYTHONPATH="$PYAV_ROOT:$PYTHONPATH"
export PKG_CONFIG_PATH="$PYAV_LIBRARY_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
export LD_LIBRARY_PATH="$PYAV_LIBRARY_PREFIX/lib:$LD_LIBRARY_PATH"
export DYLD_LIBRARY_PATH="$PYAV_LIBRARY_PREFIX/lib:$DYLD_LIBRARY_PATH"
