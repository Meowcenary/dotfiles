# This was taken from: https://crawl.develz.org/wiki/doku.php

====== Setting Up dgamelaunch and WebTiles ======
WORK IN PROGRESS -- Last edited by ZiBuDo 4/15/2016 [Build on Ubuntu 14.04]

This document describes how to set up an official Crawl server with support for webtiles and console, automatic updates,
Sequell/scoring integration, and public ttyrecs.  If you just want to run a webtiles server for friends and coworkers, the process is much simpler: see [[http://s-z.org/neil/git/?p=crawl.git;a=blob;f=crawl-ref/source/webserver/README|webserver/README]] in the Crawl source.

For debugging issues related to this setup or a running server, see [[maintaining_dgamelaunch_and_webtiles|maintaining dgamelaunch and webtiles]].

0. Create the users 'crawl' and 'crawl-dev', with their associated user groups. The former will be used for running crawl, and the latter for administering it.

sudo adduser crawl
	note uid and guid
sudo adduser crawl-dev
	note uid and guid
sudo usermod -G root -a crawl
sudo usermod -G root -a crawl-dev
sudo usermod -G www-data -a crawl
sudo usermod -G www-data -a crawl-dev
sudo usermod -G crawl -a root
sudo usermod -G crawl -a www-data
sudo usermod -G crawl-dev -a root
sudo usermod -G crawl-dev -a www-data
sudo visudo
	add crawl   ALL=(ALL:ALL) ALL
	and crawl-dev  ALL=(ALL:ALL) ALL

These groups and permissions will save a lot of headaches

1. Set up a chroot in /home/crawl/DGL/ .  On Debian-like systems you can do:

    ~# debootstrap stable /home/crawl/DGL/
Note: Ubuntu users should change 'stable' to match their build env (e.g. 'precise' for 12.04; 'trusty' for 14.04)

2. Install some prerequisites into the chroot.  Besides the base system that debootstrap installed, you need the libraries for running crawl, bzip2 for compressing save backups, the sqlite3 binary for interfacing with the user and version databases, locales, terminal definitions, and a minimal install of python (because character codecs are loaded at runtime). For Debian* systems:

   ~# sudo chroot /home/crawl/DGL/
	this creates the environment which crawl will run in
	After running this then install packages as root of the chroot
	~#sudo apt-get install install bzip2 python-minimal \
					ncurses-term locales-all sqlite3 \
					libpcre3 liblua5.1-0
	~#sudo locale-gen en_US.UTF-8
	~#sudo dpkg-reconfigure locales
	~#sudo adduser crawl
	~#sudo adduser crawl-dev
	Change uid and guid to match the previous uid and guid
	~#usermod -u NEW_UID your_username
	~#groupmod -g <NEW_GID> <groupname>
	~#exit

* Ubuntu is similar: ~# chroot /home/crawl/DGL apt-get ...

A Note on graphics compression:
If you're interested in reducing bandwidth at the expense of a little bit of rebuild time, you can install advancecomp and pngcrush on the host system.
The makefile will automatically detect those and use them to optimise/recompress the tilesheets


3. Various programs running in the chroot will need /proc and /dev/pts, so mount those.  It's probably best to add them to your system's fstab so they're mounted on boot.  You can **either** mount the filesystems directly:

    # Option 1: direct mount
    proc      /home/crawl/DGL/proc       proc    defaults        0       0
    devpts    /home/crawl/DGL/dev/pts    devpts  defaults        0       0

**or** use a bind mount to duplicate the host directories into the chroot:

    # Option 2: bind mount
    /proc       /home/crawl/DGL/proc     none    bind            0       0
    /dev/pts    /home/crawl/DGL/dev/pts  none    bind            0       0

Either way, these lines should come after the existing entries for your host system's /proc and /dev/pts.  Now you should be able to mount them with just the name.

    ~# mount /home/crawl/DGL/proc
    ~# mount /home/crawl/DGL/dev/pts

NOTE: Root can trivially escape a chroot using /proc/1/cwd !

You'll also need to make sure your 'crawl' user can write to /dev/ptmx inside the chroot:

   ~# chmod 666 /home/crawl/DGL/dev/ptmx

4. Make the directories /home/crawl-dev/logs and /home/crawl-dev/run, owned by and writable by crawl-dev.  Unless noted otherwise, subsequent commands should be run by user crawl-dev.
	~# su crawl-dev
	~# mkdir /home/crawl-dev/logs
	~# mkdir /home/crawl-dev/run

5. Check out the cszo branch of dgamelaunch and dgamelaunch-config.  You might also want a copy of Sizzell if you intent to announce milestones and games in IRC.

# TODO: publish dgamelaunch and sizzell branches

    ~$ git clone -b szorg git://github.com/neilmoore/dgamelaunch.git
    ~$ git clone -b szorg git://github.com/neilmoore/dgamelaunch-config.git
    ~$ git clone git://github.com/neilmoore/sizzell.git

6. Build dgamelaunch; copy the binary into /usr/local/sbin/ on your main system, and the ee and virus binaries into /bin on the chroot.

    ~$ cd dgamelaunch
    -$ git checkout szorg
    -$ ./autogen.sh --enable-debugfile --enable-sqlite --enable-shmem
If gcc can't be found just sudo apt-get install build-essential
Any missing file install dependencies
Yacc: sudo apt-get install bison

Edit the Makefile and add -pthread to LIBS=
   ~$	sudo make VIRUS=1
   ~$	sudo make install
   ~$	sudo cp ee virus /home/crawl/DGL/bin
copy the binary into /usr/local/sbin/ on your main system, and the ee and virus binaries into /bin on the chroot.

7. (As root) Give crawl-dev permissions to run  'dgl' binary with sudo without a password.  We'll also need permissions for a few additional scripts, as well as webtiles.

    ~# visudo
    crawl-dev ALL=(root) NOPASSWD: /home/crawl-dev/dgamelaunch-config/bin/dgl, /home/crawl/DGL/sbin/install-trunk.sh, /home/crawl/DGL/sbin/install-stable.sh, /etc/init.d/webtiles, /home/crawl/DGL/sbin/remove-trunks.sh

8. Check out branch "szorg" of dgamelaunch-config and look over the various configuration files.  You may wish to change directory names etc.

    ~$ cd dgamelaunch-config
    -$ view dgl-manage.conf crawl-git.conf dgamelaunch.conf config.py

You might want to remove the entries for rfk, atc, and boggle.  If you do, also edit the menus under chroot/data/menus/
You definitely need to change the uid= and gid= lines in config.py (the webtiles config) to match the numeric IDs of the 'crawl' user. Likewise shed_uid and shed_gid in dgamelaunch.conf.
edit config.py
	Edit ip addresses, ssl certs, server names, which game modes you want to support, and run on port 8080 for non-ssl, make sure uid and guid of crawl user too!
	Setting up SSL, assuming you know cert files, bundles or appending them as a .pem, and private server key
		create directory www/crawl_ssl in the chroot
		stores files there and point to /var/www/crawl_ssl/file in ssl options
edit crawl-git.conf
	change the gitourious link to this link: https://github.com/crawl/crawl.git
edit dgamelaunch.conf
	server name, shed_guid and shed_uid to be aligned with crawl
edit dgl-manage.conf
	edit DGL_SERVER and uid to match crawl

	exit crawl-dev

9. Make the needed directories.  There are a bunch, and I've probably forgotten some, but at the very least you need the following under the chroot /home/crawl/DGL/ .  They should all be writable by user 'crawl', and the morgues, ttyrecs, and rcfiles should probably be readable by your web server.

DO NOT chown the whole chroot: various programs and directories inside the chroot need to be owned by root or other users.

     crawl-master
     crawl-master/webserver/
     crawl-master/webserver/run/
     crawl-master/webserver/sockets/
     crawl-master/webserver/templates/
     dgldir/data/
     dgldir/dumps/
     dgldir/morgue/
     dgldir/rcfiles/
     dgldir/ttyrec/
     dgldir/data/menus/
     dgldir/inprogress/

Ensure that user crawl has write access to /var/mail so that console messages can be sent.

Also create the file "dgamelaunch" directly under the chroot; it will be used as a shared memory key. Contents don't matter.
(if you want debug messages, also create the file dgldebug.log and make it writable for crawl. Warning, the file has a reputation of not being incredibly useful.)

Create the following set of directories for each crawl version you will support:

     dgldir/inprogress/crawl-git-sprint/
     dgldir/inprogress/crawl-git-tut/
     dgldir/inprogress/crawl-git-zotdef/
     dgldir/inprogress/crawl-git/
     dgldir/rcfiles/crawl-git/
     dgldir/data/crawl-git-settings/

     dgldir/inprogress/crawl-13-sprint/
     dgldir/inprogress/crawl-13-tut/
     dgldir/inprogress/crawl-13-zotdef/
     dgldir/inprogress/crawl-13/
     dgldir/rcfiles/crawl-0.13/
     dgldir/data/crawl-0.13-settings/

     [etc.]
	 Code to execute:
		su crawl
		cd ~
		cd DGL

		sudo mkdir crawl-master
		sudo mkdir crawl-master/webserver/
		sudo mkdir crawl-master/webserver/run/
		sudo mkdir crawl-master/webserver/sockets/
		sudo mkdir crawl-master/webserver/templates/
		sudo mkdir dgldir
		sudo mkdir dgldir/data/
		sudo mkdir dgldir/dumps/
		sudo mkdir dgldir/morgue/
		sudo mkdir dgldir/rcfiles/
		sudo mkdir dgldir/ttyrec/
		sudo mkdir dgldir/data/menus/
		sudo mkdir dgldir/inprogress/

		sudo mkdir dgldir/inprogress/crawl-git-sprint/
		sudo mkdir dgldir/inprogress/crawl-git-tut/
		sudo mkdir dgldir/inprogress/crawl-git-zotdef/
		sudo mkdir dgldir/inprogress/crawl-git/
		sudo mkdir dgldir/rcfiles/crawl-git/
		sudo mkdir dgldir/data/crawl-git-settings/

		sudo mkdir dgldir/inprogress/crawl-17-sprint/
		sudo mkdir dgldir/inprogress/crawl-17-tut/
		sudo mkdir dgldir/inprogress/crawl-17-zotdef/
		sudo mkdir dgldir/inprogress/crawl-17/
		sudo mkdir dgldir/rcfiles/crawl-0.17/
		sudo mkdir dgldir/data/crawl-0.17-settings/

		sudo chown -R crawl:crawl crawl-master
		sudo chown -R crawl:crawl crawl-master/*
		sudo chown -R crawl:crawl dgldir
		sudo chown -R crawl:crawl dgldir/*

		sudo nano /home/crawl/DGL/dgamelaunch

9.5 Create the crawl versions database and the save and data directories for trunk:

     ~$ sudo /home/crawl-dev/dgamelaunch-config/bin/dgl create-versions-db
     ~$ sudo /home/crawl-dev/dgamelaunch-config/bin/dgl create-crawl-gamedir

and copy the resulting crawl-git directory for each other version you will support:

     ~$ sudo cp -a /home/crawl/DGL/crawl-master/{crawl-git,crawl-0.13}
     ~$ sudo cp -a /home/crawl/DGL/crawl-master/{crawl-git,crawl-0.12}
     ~$ sudo cp -a /home/crawl/DGL/crawl-master/{crawl-git,crawl-0.11}

10. Publish the configs into the chroot (and the dgamelaunch config into /etc).

    ~$ sudo /home/crawl-dev/dgamelaunch-config/bin/dgl publish --confirm

11. Try installing your crawl versions (run as user crawl-dev):

    ~$ /home/crawl-dev/dgamelaunch-config/bin/dgl update-stable 0.13
    ~$ /home/crawl-dev/dgamelaunch-config/bin/dgl update-stable 0.12
    ~$ /home/crawl-dev/dgamelaunch-config/bin/dgl update-stable 0.11
    ~$ /home/crawl-dev/dgamelaunch-config/bin/dgl update-trunk

At the very least you must run update-trunk, because that is responsible for installing the webtiles server.
You probably want to set up a cronjob to run this once a day. if so, you will need to ensure your host has locales set correctly for webtiles to run. Webtiles require an UTF-8 locale.

    ~# sudo update-locale LANG=en_US.UTF-8

I add this line to the beginning, so I have a log of all
updates:
       exec >> /home/crawl-dev/logs/update.log 2>&1

11.2 Currently, you will need to copy and edit the html files from the git repo to the templates directory in the chroot

	~$ sudo cp /home/crawl-dev/dgamelaunch-config/crawl-build/crawl-git-repository/crawl-ref/source/webserver/templates/*.html /home/crawl/DGL/crawl-master/webserver/templates/
	exit crawl user

12. Set up symlinks in /var/www/ for people to access morgues, ttyrecs, etc. As root (or someone with access to that directory):

        login as a user with access to /var/www/
	We create a folder in here named crawl
	in /var/www/crawl, create sym links
	~# sudo ln -s /home/crawl/DGL/dgldir/morgue/
	~# sudo ln -s /home/crawl/DGL/dgldir/rcfiles/
	~# sudo ln -s /home/crawl/DGL/dgldir/ttyrec/

12.5. Some stuff for your Apache config.  Note that auth-save-downloader.pl and trigger-rebuild.pl are installed into /usr/lib/cgi-bin by the 'dgl publish' command.  You'll need to enable mod-rewrite if that is not already enabled. On Debian:
      ~# a2enmod rewrite
      ~# service apache2 reload

	login as a user with access to /var/www/
	We create a folder in here named crawl
	in /var/www/crawl, create sym links
		 ~#sudo ln -s /home/crawl/DGL/dgldir/morgue/
		 ~#sudo ln -s /home/crawl/DGL/dgldir/rcfiles/
		 ~#sudo ln -s /home/crawl/DGL/dgldir/ttyrec/

~Apache Configuration in full~

  <VirtualHost *:80>
  ServerName crawl.yoursite.org
  DocumentRoot /var/www/crawl
  RewriteEngine on

  ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
  <Directory "/usr/lib/cgi-bin">
      AllowOverride None
      Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
      Order allow,deny
      Allow from all
  </Directory>
    # Make an alias /saves/ that passes HTTP authentication information and
  # the save file name to auth-save-downloader.
  RewriteCond %{HTTP:Authorization} ^(.+)
  RewriteRule ^/saves/(.*)$ /cgi-bin/auth-save-downloader.pl?file=$1 [PT,E=HTTP_AUTHORIZATION:%1]
  RewriteRule ^/saves/(.*)$ /cgi-bin/auth-save-downloader.pl?file=$1 [PT]

  # Make an alias /rebuild/ that passes HTTP authentication information to
  # the rebuild trigger.
  RewriteCond %{HTTP:Authorization} ^(.+)
  RewriteRule ^/rebuild(/(.*))?$ /cgi-bin/trigger-rebuild.pl?v=$2 [PT,E=HTTP_AUTHORIZATION:%1]
  RewriteRule ^/rebuild(/(.*))?$ /cgi-bin/trigger-rebuild.pl?v=$2 [PT]

  RewriteCond %{REQUEST_URI} ^/ttyrec/([^/]*)/(.*\.ttyrec)
  RewriteCond /var/www/%{REQUEST_FILENAME} !-f
  RewriteRule ^/ttyrec/([^/]*)/(.*\.ttyrec)$ /ttyrec/$1/$2.bz2
  RewriteRule ^/crawl - [L]
  RewriteRule ^/crawl/morgue - [L]
  RewriteRule ^/crawl/rcfiles - [L]
  RewriteRule ^/crawl/ttyrec - [L]
  RewriteRule ^/crawl/meta - [L]

  # Turn off compression for /rebuild so we can see compile messages in real time.
  SetEnvIfNoCase Request_URI ^/rebuild(/.*)?$ no-gzip dont-vary

  RewriteRule ^/(.*) http://crawl.yoursite.org:8080/$1
  </VirtualHost>

  <VirtualHost *:80>
  ServerName www.yoursite.org
  Redirect / http://crawl.yoursite.org:8080
  </VirtualHost>

   Listen 8081
   <VirtualHost *:8081>
	ServerAdmin admin@yoursite.org

	DocumentRoot /var/www/crawl
	ServerName yoursite.org
	ServerAlias crawl.yoursite.org www.yoursite.org

	SSLEngine on

	SSLCertificateFile	/var/www/crawl_ssl/.crt
	SSLCertificateKeyFile /var/www/crawl_ssl/server.key
	SSLCertificateChainFile /var/www/crawl_ssl/.ca-bundle

	<FilesMatch "\.(cgi|shtml|phtml|php)$">
			SSLOptions +StdEnvVars
	</FilesMatch>
	<Directory /usr/lib/cgi-bin>
			SSLOptions +StdEnvVars
	</Directory>


	BrowserMatch "MSIE [2-6]" \
			nokeepalive ssl-unclean-shutdown \
			downgrade-1.0 force-response-1.0
	# MSIE 7 and newer should be able to use keepalive
	BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown

       </VirtualHost>

Note: to access ssl the url will show the port such as https://crawl.yoursite.org:8081
Also when configuring config.py make sure ssl port is set to which ever port ur virtual host is for apache ssl
If you are already running ssl, then change it from 443 because it will be already bound

	~# sudo service apache2 reload

12.6 Start Webtiles via:

    ~# /etc/init.d/webtiles start
Troubleshooting Notes:
-Tornado error:
File "/usr/local/lib/python2.7/dist-packages/tornado-3.0.1-py2.7.egg/tornado/httpserver.py", line 153, in __init__
TypeError: __init__() got an unexpected keyword argument 'connection_timeout'

Need to install edlothiol's patch for Tornado. As crawl-dev, from /home/crawl-dev:

    ~$ fetch git://github.com/flodiebold/tornado.git into /home/crawl-dev/tornado
    ~$ git checkout http-timeouts-2.4
    ~$ python setup.py build

NOTE from johnstein: "/etc/init.d/webtiles sets PYTHONPATH for this, so you shouldn't need to install this, but I wasn't able to make it work and needed to ~# python setup.py install"
NOTE from ZiBuDo: Troubleshoot with  sudo tail -f /home/crawl/DGL/crawl-master/webserver/run/webtiles.log
	If latin1 encoding error: edit the final file in the trace and change 'latin1' to 'UTF-8'
	If ascii encoding error: edit the files in the trace to have "from encodings import ascii" at the top of the file
	If can't bind the websocket: make sure its trying on port 8080 and that crawl has proper permissions in the folders you created

NOTE from espais: I have had an issue with dgamelaunch/WebTiles on Ubuntu 16.04 where the mounting procedure and permissions get trounced upon rebooting.  To resolve this I added the following to /etc/rc.local (before exit 0)

    # unmount and remount pts/proc
    umount /home/crawl/DGL/dev/pts
    umount /home/crawl/DGL/proc
    mount /home/crawl/DGL/dev/pts
    mount /home/crawl/DGL/proc
    # fix ptmx permissions
    chmod 666 /home/crawl/DGL/dev/ptmx
    # restart webtiles -- webtiles restart doesn't seem to work very well
    /etc/init.d/webtiles stop
    /etc/init.d/webtiles start

    exit 0 # normally already in /etc/rc.local

13. I'm sure there's more...  launching the inotify watcher, crontabs for compressing ttyrecs, cleaning out old trunks, making logfiles and milestones available over the web, setting up an ssh user, set up a dgl-status script in cgi-bin, forwarding port 80 requests to 8080 for webtiles, etc.

13.1 To create the user database, either run webtiles, or do:
    ~$ sqlite3 /home/crawl/DGL/dgldir/dgamelaunch.db
    sqlite3> CREATE TABLE dglusers (id integer primary key, username text, email text, env text, password text, flags integer);
	sqlite3> .quit;

13.2 For ttyrec compression (these files are huge, even when compressed), make sure you have the program lsof on the host, and run from a cron job (via sudo as crawl-dev):
    #! /bin/bash
    exec >>/home/crawl-dev/logs/compress-ttyrecs.log 2>&1
    /home/crawl-dev/dgamelaunch-config/bin/dgl compress-ttyrecs

13.3 For cleaning out old Trunk versions, run the following script from a cron job (as crawl-dev)
    #! /bin/bash
    exec >>/home/crawl-dev/logs/clean-trunks.log 2>&1

    DGL=/home/crawl-dev/dgamelaunch-config/bin/dgl

    # tail -n +6 to skip the header and, more importantly, the most recent
    # trunk version.
    readarray -t to_del < <(
        $DGL remove-trunks -v | tail -n +6 | awk '$6==0 { sub(".*g","",$4); print $4 }'
    )

    if (( ${#to_del[@]} )); then
        echo -n "Cleaning trunks at "
        date;
        $DGL remove-trunks "${to_del[@]}"
        echo done.
        echo
    fi

13.4 Note that your ssh user should have /usr/local/sbin/dgamelaunch as their shell, and should have forwarding (particularly TCP forwarding) disabled. You could use the following at the end of your /etc/ssh/sshd_config (note that "Match" affects all options until the next "Match" or the end of the file).

    Match User terminal
     AllowAgentForwarding no
     AllowTcpForwarding no
     X11Forwarding no
     PasswordAuthentication yes  # only if you want to allow passwords

13.5 Set up this dgl-status script in your cgi-bin with 755 permissions and root ownership (for debian/ubuntu, this is located at /usr/lib/cgi-bin). This script creates an easy-to-parse list of all the players.
    #! /bin/sh

    echo Content-type: text/plain
    echo
    umask 0022
    exec /usr/local/sbin/dgamelaunch -s
send the URL to Wensley (on IRC freenode, ##crawl-dev, !tell Wensley the-url/cgi-bin/dgl-status)

13.6 Launch the inotify watcher which is necessary to populate the "current location" field in DGL. The watcher has a dependency on the Linux/Inotify2.pm Perl module.
    ~$ sudo /home/crawl-dev/dgamelaunch-config/bin/dgl crawl-inotify-dglwhere

Note: If you add new inprogress directories (for new game versions) you'll need to find and kill that daemon then restart it


13.7 If you want your milestones, logfiles, and scores to be cacheable for stats, you will need to publish those files.
Create symlinks for each file and put them in the appropriate folders in /var/www. Suggested directory structure:
    /var/www/crawl/meta/git/
    /var/www/crawl/meta/0.13/
    /var/www/crawl/meta/0.23/
    etc

with symlinks to each milestone, logfile, and score file (you will need to individually link each score file for each sprint map).

    ~$ ls -lt /var/www/crawl/meta/git/
    meta/git:
    total 8
    lrwxrwxrwx 1 root root 52 Jan  3 18:31 logfile -> /home/crawl/DGL/crawl-master/crawl-git/saves/logfile
    lrwxrwxrwx 1 root root 59 Jan  3 18:31 logfile-sprint -> /home/crawl/DGL/crawl-master/crawl-git/saves/logfile-sprint
    lrwxrwxrwx 1 root root 59 Jan  3 18:31 logfile-zotdef -> /home/crawl/DGL/crawl-master/crawl-git/saves/logfile-zotdef
    lrwxrwxrwx 1 root root 55 Jan  3 18:31 milestones -> /home/crawl/DGL/crawl-master/crawl-git/saves/milestones
    lrwxrwxrwx 1 root root 62 Jan  3 18:31 milestones-sprint -> /home/crawl/DGL/crawl-master/crawl-git/saves/milestones-sprint
    lrwxrwxrwx 1 root root 62 Jan  3 18:31 milestones-zotdef -> /home/crawl/DGL/crawl-master/crawl-git/saves/milestones-zotdef
    lrwxrwxrwx 1 root root 51 Jan  3 18:31 scores -> /home/crawl/DGL/crawl-master/crawl-git/saves/scores
    lrwxrwxrwx 1 root root 58 Jan  3 18:31 scores-sprint -> /home/crawl/DGL/crawl-master/crawl-git/saves/scores-sprint
    lrwxrwxrwx 1 root root 58 Jan  3 18:31 scores-zotdef -> /home/crawl/DGL/crawl-master/crawl-git/saves/scores-zotdef

It's recommended to also publish your rcfiles, morgue files, and ttyrec files.
    ~$ ls -lt /var/www/crawl
    total 12
    drwxr-xr-x 2 root root 4096 Jan  5 00:55 keys
    -rw-r--r-- 1 root root  348 Jan  4 19:31 default.asp
    drwxr-xr-x 4 root root 4096 Jan  3 18:33 meta
    lrwxrwxrwx 1 root root   30 Jan  2 01:33 ttyrec -> /home/crawl/DGL/dgldir/ttyrec/
    lrwxrwxrwx 1 root root   31 Jan  2 01:33 rcfiles -> /home/crawl/DGL/dgldir/rcfiles/
    lrwxrwxrwx 1 root root   30 Jan  2 01:31 morgue -> /home/crawl/DGL/dgldir/morgue/

	sudo mkdir /var/www/crawl/meta/git/
	sudo mkdir /var/www/crawl/meta/0.17/

	Do this in /var/www/crawl/meta/git

	sudo ln -s /home/crawl/DGL/crawl-master/crawl-git/saves/logfile
	sudo ln -s /home/crawl/DGL/crawl-master/crawl-git/saves/logfile-sprint
	sudo ln -s /home/crawl/DGL/crawl-master/crawl-git/saves/logfile-zotdef
	sudo ln -s /home/crawl/DGL/crawl-master/crawl-git/saves/milestones
	sudo ln -s /home/crawl/DGL/crawl-master/crawl-git/saves/milestones-sprint
	sudo ln -s /home/crawl/DGL/crawl-master/crawl-git/saves/milestones-zotdef
	sudo ln -s /home/crawl/DGL/crawl-master/crawl-git/saves/scores
	sudo ln -s /home/crawl/DGL/crawl-master/crawl-git/saves/scores-sprint
	sudo ln -s /home/crawl/DGL/crawl-master/crawl-git/saves/scores-zotdef

13.8 to automatically make apache redirect webtiles requests for port 80 to 8080 (where webtiles runs by default) do the following (for ubunutu):
This was noted in the full apache config above
Create the following config file:
    ~# sudo vi /etc/apache2/conf.d/mysite

    <VirtualHost *:80>
    ServerName crawl.mysite.org
    DocumentRoot /var/www/
    RewriteEngine on
    RewriteRule ^/crawl - [L]
    RewriteRule ^/crawl/morgue - [L]
    RewriteRule ^/crawl/rcfiles - [L]
    RewriteRule ^/crawl/ttyrec - [L]
    RewriteRule ^/crawl/meta - [L]
    RewriteRule ^/(.*) http://crawl.mysite.org:8080/$1
    </VirtualHost>

Edit DocumentRoot and the RewriteRules for the morgues, rcfiles, ttyrecs, and milestones/logs/scores as required

then restart apache

    ~# sudo service apache2 reload

13.9 To add admins to the server (allows access to backup saves and wizmode!):
    ~# sudo /home/crawl-dev/dgamelaunch-config/bin/dgl admin add <name>

14. **Security note:** As long as crawl-dev has write permissions to the dgl script and its subdirectories, they can easily use their sudo access to run arbitrary commands.  If they can edit and publish the dgamelaunch or webtiles config , they can trick the server into running arbitrary commands as arbitrary users.

If you want to give users the ability to manage crawl without giving them complete root access, move the whole /home/crawl-dev/dgamelaunch-bin directory to a system-wide location like /usr/local/lib, make it writable only by root, and update the sudoers entry and the various cron jobs and init scripts.  The crawl-dev user then won't be able to change the server configuration, but will at least be able to use the various management commands (resetting user passwords, etc).
