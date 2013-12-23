### Installation

1.  Install dependencies:

        make setup

2.  Build:

        make

3.  Install [nginx](http://nginx.com/).

4.  Create a symlink to nginx.conf from wherever nginx sites live. For example:

        ln -s "$(pwd)/nginx.conf" /opt/local/etc/nginx/sites-available/docco.hashify.me

5.  Activate the site if necessary. For example:

        ln -s ../sites-available/docco.hashify.me /opt/local/etc/nginx/sites-enabled/docco.hashify.me

6.  Reload nginx:

        sudo nginx -s reload


### localhost

Hashify uses [CORS](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing)
in its communication with bitly. Though browsers don't allow this on localhost,
one can use <http://lvh.me> for testing (lvh.me resolves to localhost).
