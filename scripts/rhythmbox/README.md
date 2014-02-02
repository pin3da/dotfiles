Script to remove the duplicate songs in rhythmbox.

I wrote this code to play around javascript and nodejs, i hope it would be useful for someone besides me.


# Preparation

If you have installed nodejs just run.

    $ npm install

else, install [nodejs](http://nodejs.org/) and back to the previous step.

# Usage

    $ node app.js path_to_rhythmdb.xml

Usually the path to rhythmdb.xml is ~/.local/share/rhythmbox, but it
could change in some pc.

Then a file 'non\_rep.xml' will be created in your /tmp, copy it and replace your rhythmdb.xml (make a backup before if you want).

Enjoy :D

_______
Developed by Manuel Pineda.
