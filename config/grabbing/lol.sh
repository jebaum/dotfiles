function uploadImage {
  curl -s -F "image=@$1" -F "key=e7bc144295297c37aa852990570435dc" https://imgur.com/api/upload.xml | grep -E -o "<original_image>(.)*</original_image>" | grep -E -o "http://i.imgur.com/[^<]*"
}

scrot -s "/tmp/shot.png" 
echo -n "hold your horses" | xclip
uploadImage "/tmp/shot.png" | xclip -selection c
rm "/tmp/shot.png"
notify-send "Done"


# 486690f872c678126a2c09a9e196ce1b
