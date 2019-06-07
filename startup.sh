#!/bin/sh

cd /home/vagrant
su postgres -c 'pg_ctl start -D /var/lib/postgres/data'

sudo -u postgres -i createuser --superuser root
sudo -u postgres -i createuser --superuser vagrant
createdb cpp_doc

cd /home/vagrant/django-cpp-doc-0.1.0
python setup.py install

cd /home/vagrant/const-checker-experiments-0.1.0
python manage.py migrate

cd /home/vagrant
psql cpp_doc -c '\i /home/vagrant/const-checker-0.1.1/sql/functions.sql'

sudo -u vagrant -i /bin/sh
