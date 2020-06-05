#!/bin/bash

UPDATES=$(checkupdates | wc -l)

if [[ "${UPDATES}" == "0" ]]; then
  echo -n "No new packages"
  exit
elif [[ "${UPDATES}" == "1" ]]; then
  echo -n "1 new package"
  exit
else
  echo -n "${UPDATES} new packages"
  exit
fi

echo -n "No new packages"


