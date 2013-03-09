# How can we use this MTA data?

This: http://www.mta.info/developers/turnstile.html

Well, you do some stuff with it. Yeah.

Start by downloading all the files. They're about 14 megs each, for a total of about 1.7 gigs:

    wget -r -l 1 -A "turnstile*.txt" -w 12 http://www.mta.info/developers/turnstile.html

This is what those flags do:

-r: recursive
-l 1: one level deep
-A "blah": matching this shell-style pattern
-w 12: waiting 12 seconds between downloads

Then, do some processing. See code.
