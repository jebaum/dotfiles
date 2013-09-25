#!/bin/bash

CONFPATH=${HOME}/.imgup.conf
AUTH_TOKEN='x'
REFRESH_TOKEN='x'
DZEN_OPTS=" -bg #102210 -fg white -xs 1 -ta l -fn 6x12 -p -u -y -1"

# rewrite stored token.  call with no args to clear it
function update_tokens() {
  AUTH_TOKEN="$1"
  REFRESH_TOKEN="$2"
  cat > ${CONFPATH} <<-EOF
# Conf file for ${CONFPATH}
export APP_ID="c0a8d35f2378812"
export APP_SECRET="60be9fe195fb2360256644af2b8a5fcf7ea6a92e"
export AUTH_TOKEN="$AUTH_TOKEN"
export REFRESH_TOKEN="$REFRESH_TOKEN"
EOF
}

# check dependecies
for dep in zenity jshon scrot ; do
  which $dep &>/dev/null
  if [ $? -gt 0 ] ; then
    echo Missing dependency: $dep 1>&2
    exit 1
  fi
done

# write a default imgup.conf
if [ ! -f ${CONFPATH} ] ; then
  update_tokens
fi
  
source ${CONFPATH}

function auth_pin() {
  for browser in sensible-browser firefox google-chome chromium galeon epiphany ; do
    if [ -x "/usr/bin/$browser" ] ; then
      break
    fi
  done

  url="https://api.imgur.com/oauth2/authorize?client_id=${APP_ID}&response_type=pin&state=auth"
  "/usr/bin/$browser" "$url" &>/dev/null &
  pin=$(zenity --entry --title 'Imgur Authentication' --text="Please log into imgur, grant access, and paste the pin code here.  \n$url")

  #read pin
  response=$(curl -s -d "client_id=${APP_ID}&client_secret=${APP_SECRET}&grant_type=pin&pin=${pin}" https://api.imgur.com/oauth2/token)
  if [[ "$response" == *Invalid* ]] ; then
    echo 'Invalid pin' 1>&2
    exit 
  fi

  echo $response
}

# try to auth.  uses latest token, refresh token, and finally requests pin
function auth() {
  AUTH_TOKEN=$1
  REFRESH_TOKEN=$2

  # auth with current token.  if they work, keep them
  response=`curl -s -X GET https://api.imgur.com/3/account/me/albums/ --header "Authorization: Bearer ${AUTH_TOKEN}"` # actually just gets albums.  using this to ping
  #if [[ "$response" =~ '"status":200' ]] ; then
  if [[ $(echo $response | jshon -e status) == 200 ]] ; then
    echo $AUTH_TOKEN $REFRESH_TOKEN 
    return
  fi

  # try refreshing
  response=`curl -s -d "client_id=${APP_ID}&client_secret=${APP_SECRET}&grant_type=refresh_token&refresh_token=${REFRESH_TOKEN}"  https://api.imgur.com/oauth2/token`

  # enter pin
  #if [[ "$response" != *access_token* ]] ; then
  if [[ $(echo $response | jshon -Q -e success) == 'false' ]] ; then
    response=$(auth_pin)
  fi

  AUTH_TOKEN=$(echo $response | jshon -e access_token)
  REFRESH_TOKEN=$(echo $response | jshon -e refresh_token)

  echo $AUTH_TOKEN $REFRESH_TOKEN 
}

# try to auth.  if there's a change in refresh tokens, rewrite conf file
AUTH_RESPONSE=$(auth $AUTH_TOKEN $REFRESH_TOKEN)
if [[ "$AUTH_RESPONSE" != "$AUTH_TOKEN $REFRESH_TOKEN" ]] ; then
  update_tokens $AUTH_RESPONSE
  source ${CONFPATH}
fi

#By now auth_token should be useful
IMAGE="/tmp/screenshot-$(date +'%F.%T').png"
echo "Screenshot -> Imgur: Click a window or drag a selection." | dzen2 $DZEN_OPTS &
PID=$!
scrot -s $IMAGE
if [ $? -eq 0 ] ; then
  kill $PID
  echo "Uploading..." | dzen2 $DZEN_OPTS &
  PID=$!

  response=`curl -s -X POST --header "Authorization: Bearer ${AUTH_TOKEN}" -F "image=@${IMAGE}" https://api.imgur.com/3/image`
  id=$(echo $response | jshon -e data -e id | tr -d '"')
  if [ "$id" != "" ] ; then
    #firefox http://imgur.com/$id &
    #echo "![screenshot](http://imgur.com/$id.png)"
    echo "http://imgur.com/${id}.png" | xclip
    notify-send -t 1500 "http://imgur.com/${id}.png"
  fi
fi

kill $PID
