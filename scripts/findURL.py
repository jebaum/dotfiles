#!/usr/bin/python3

import re
import sys

# extract a URL from plaintext. regular expressions from these gists:
    # https://gist.github.com/gruber/249502
    # https://gist.github.com/gruber/8891611
def extractURL(s):
    urlMatches = re.findall(r'(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:\'".,<>?«»“”‘’]))', s)
    # TODO this weirdness is because of how findall returns tuples of the results with the above regex. probably a better way
    # https://pymotw.com/2/re/
    url_joined = ''.join(urlMatches[0]) if urlMatches else ''
    return url_joined

# read in data and find where multiline URLs might be
inputText       = [line for line in sys.stdin.readlines()]
maxLength       = len(max(inputText, key=len))
longLineNumbers = [] # line numbers where we might have a URL over two lines

for i, line in enumerate(inputText):
    # if line ends at last possible column in a non space character, and isn't the last line in the input
    if len(line.rstrip(' ')) == maxLength and i < len(inputText) - 1:
        longLineNumbers.append(i) # there may be a cutoff multiline url

    # remove mutt/weechat left sidebar if present
    barPos = inputText[i].find('│', 0, 30) # don't search all the way to the end of the string
    if barPos != -1:
        inputText[i] = inputText[i][(barPos+1):].strip()
    else:
        inputText[i] = inputText[i].strip()

    # TODO attempt to remove nicklist bar in weechat
    #  barPos = inputText[i].find('│')
    #  if barPos != -1:
        #  inputText[i] = inputText[i][:(barPos)].strip()

joinedLines = [] # join lines where we may have URLs on two lines
for i in longLineNumbers:
    joinedLines.append(inputText[i].strip() + inputText[i + 1].strip())

# go through everything that may contain a URL, and see if it does
urls = []
for line in inputText + joinedLines:
    urls.append(extractURL(line))

# reverse sort so that prefixes are immediately after the entry they're a prefix of
# this removes partial URLs if a URL was spread over two lines
urls = list(set(urls)) # remove duplicates
urls.sort()
urls.reverse()
for i in range(0, len(urls) - 1):
    if urls[i].startswith(urls[i+1]):
        urls[i+1] = ''

# TODO also remove postfixes? could just do a substring check to do both at once. or maybe not worth it?

# print everything besides empty strings
#  for url in [s for s in urls if s and not s.startswith('mailto:')]:
    #  print(url)

test = [s for s in urls if s and not s.startswith('mailto:')]
if test:
    for line in test:
        print(line)
else:
    print("NO URLS FOUND")

# TODO maybe don't launch dmenu at all if no urls found?
