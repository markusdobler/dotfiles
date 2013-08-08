#!/usr/bin/python2.5

import sys
import os
import errno
import mailbox
import mimetypes
import re
import email.header as header

try:
    mbox = sys.argv[1]
except IndexError:
    sys.stderr.write('usage: %s mbox\n' % sys.argv[0])
    sys.exit(1)

basedir = '%s-attachments' % mbox
try:
    os.mkdir(basedir)
except OSError, e:
    sys.stderr.write("Error creating directory '%s': %s" % (basedir, e))
    sys.exit(2)

for message in mailbox.mbox(mbox):
    date = message['Date']
    date = re.search(r'(\d+) (\w+) (\d+)( [0-9:/-]+)?', date)
    date = date.expand(r'\1. \2 \3\4')
    fields = 'Subject', 'To', 'From', 'Date'
    fields = dict((f, header.decode_header(message[f])[0][0]) for f in fields)
    print fields
    path = "%s - %s"%(date, fields['Subject'])
    path = path.decode('latin1', 'ignore')
    path = re.sub('[/:]', '.', path)
    directory = os.path.join(basedir, path)
    try:
	os.mkdir(directory)
    except OSError, e:
	if e.errno <> errno.EEXIST:
	    raise

    counter = 1
    for part in message.walk():
	if part.get_content_maintype() == 'multipart':
	    continue
	payload = part.get_payload(decode=True)
	if payload is None:
	    continue
	filename = part.get_filename()
	if not filename:
	    if counter == 1:
		filename = 'text.txt'
		headers = ""
		headers = "\n".join(": ".join(f) for f in fields.items())
		payload = headers + "\n\n" + payload
	    else:
		ext = mimetypes.guess_extension(part.get_content_type())
		if not ext:
		    ext = '.bin'
		filename = 'part-%03d%s' % (counter, ext)
	counter += 1
	fp = open(os.path.join(directory, filename), 'wb')
	fp.write(payload)
	fp.close()
