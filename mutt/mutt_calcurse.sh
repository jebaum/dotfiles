#!/bin/bash
#
# Import text/calendar files from mutt
# to calcurse.
# requires uudeview
# http://hentenaar.com/keeping-track-of-meetings-with-mutt-calcurse
# TODO file issue with calcurse, see if location data can be imported from ics files?

# Make sure calcurse is running
# if [ ! -f "$HOME/.calcurse/.calcurse.pid" ]; then
	# exit 1
# fi

# Extract the attachments
TEMPDIR=$(mktemp -d add-to-calcurse.XXXXXXXX)
cat "$@" | uudeview -i -m -n -q -p $TEMPDIR - > /dev/null 2>&1

# Add the calendar file (last attachment) to calcurse

# Caveat: The only downside to this is that it assumes that the calendar file
# will be the last MIME attachment. That won't hold true for all cases I can
# imagine, but in this case it works fine. Since the attachments never have any
# attachments other than a body and the calendar file, and neither have a name,
# uudeview just names them "UNKNOWN.nnn" where n corresponds to the order in
# which they're found in the message.

FILE=$(ls $TEMPDIR | sort -r | head -1)
calcurse -i "$TEMPDIR/$FILE" > /dev/null 2>&1

# Remove the temporary dir and trigger a reload in calcurse
rm -rf $TEMPDIR > /dev/null 2>&1
kill -USR1 `cat $HOME/.calcurse/.calcurse.pid` > /dev/null 2>&1
