#!/bin/bash

UPDATES=$(checkupdates | wc -l)

if [[ "${UPDATES}" == "0" ]]; then
  echo -n "No new packages"
elif [[ "${UPDATES}" == "1" ]]; then
  echo -n "1 new package"
else
  echo -n "${UPDATES} new packages"
fi


