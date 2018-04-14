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


function watchpigs_commit {
  __load_config ./config

  cd ${GIT_DIRECTORY}

  if ! git --version ; then
    echo git not installed
    [ ! : ]
  fi

  if ! cd ${GIT_DIRECTORY}; then
    echo cant cd T_T
    [ ! : ]
  fi

  git add -A

  if ! git commit -am "`date`" ; then
    echo nothing to push
    [ ! : ]
  else
    git push -f origin master
  fi

}

# if called directly
if [[ $_ != $0 ]]; then
    watchpigs_commit $@
fi


unset -f __load_config
unset -f trap_err
