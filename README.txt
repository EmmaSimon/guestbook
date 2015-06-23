
The guestbook app is written in perl, using the Mojolicious web framework.
It uses DBI to connect to a PostgreSQL database.
It's running at http://jellyfish.software/guestbook from the Hypnotoad web server provided with Mojolicious, on a Raspberry Pi with Debian Wheezy.
Apache is acting as a proxy from port 80 to 8080, where Hypnotoad is listening.
