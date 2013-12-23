### Installation

1.  Install [Compass](http://compass-style.org/):

        gem update --system
        gem install compass

2.  Install dependencies:

        make setup

3.  Build:

        make

4.  Install [nginx](http://nginx.com/).

5.  Create a symlink to nginx.conf from wherever nginx sites live. For example:

        ln -s "$(pwd)/nginx.conf" /opt/local/etc/nginx/sites-available/docco.hashify.me

6.  Activate the site if necessary. For example:

        ln -s ../sites-available/docco.hashify.me /opt/local/etc/nginx/sites-enabled/docco.hashify.me

7.  Reload nginx:

        sudo nginx -s reload


### localhost

Hashify uses [CORS](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing)
in its communication with bitly. Though browsers don't allow this on localhost,
one can use <http://lvh.me> for testing (lvh.me resolves to localhost).
