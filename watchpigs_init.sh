#!/bin/bash

set -eu

trap trap_err ERR

function trap_err {
  echo Some error occured. Aborted.
}


function __load_config {
  if [[ ! -f $1 ]]; then
    echo No such file $1.
    echo File $1 must be stored in `pwd`
    [ ! : ]
  fi

  if ! . $1 ; then
    echo failed to load external shell script file.
    # TODO: auto suggest
    [ ! : ]
  fi
}


function watchpigs_init {
  __load_config ./config

  if ! git --version ; then
    echo git not installed
    [ ! : ]
  fi

  cp -f ./.gitignore ${GIT_DIRECTORY}

  if ! cd ${GIT_DIRECTORY}; then
    echo cant cd T_T
    [ ! : ]
  fi

  set +eu

  git init

  git config --unset user.name
  git config --unset user.email
  git config user.name ${GIT_NAME}
  git config user.email ${GIT_EMAIL}

  git remote remove origin
  git remote add origin ${GIT_URL}

  set -eu
}

# if called directly
if [[ $_ != $0 ]]; then
    watchpigs_init $@
fi


unset -f __load_config
unset -f trap_err
