#!/usr/bin/env python2
# requires python2-pyinotify and optionally oxygen-icons

import pyinotify
import pynotify
from os.path import expanduser
from mailbox import MaildirMessage
from email.header import decode_header
# from gtk.gdk import pixbuf_new_from_file

with open(expanduser("~/.mutt/boxlist"), 'r') as f:
    boxes = f.readlines()
boxes = [line.strip('\n') for line in boxes]

pynotify.init('mailbox_notify.py')

# Handling a new mail
# icon = pixbuf_new_from_file("/usr/share/icons/oxygen/32x32/status/mail-unread-new.png")
dec_header = lambda h : ' '.join(unicode(s, e if bool(e) else 'ascii') for s, e in decode_header(h))
def newfile(event):
    fd = open(event.pathname, 'r')
    mail = MaildirMessage(message=fd)
    From = "From: " + dec_header(mail['From'])
    Subject = "Subject: " + dec_header(mail['Subject'])
    n = pynotify.Notification("New mail in "+'/'.join(event.path.split('/')[-3:-1]),
                              From+ "\n"+ Subject)
    fd.close()
    # n.set_icon_from_pixbuf(icon)
    n.set_timeout(12000)
    n.show()

wm = pyinotify.WatchManager()
notifier = pyinotify.Notifier(wm, newfile)

for box in boxes:
    wm.add_watch(expanduser("~/.mutt/mail/")+box+"/new", pyinotify.IN_CREATE | pyinotify.IN_MOVED_TO)

notifier.loop()
