pacman-key --init
pacman-key --populate archlinux
echo -e '\n[eyl]\nSigLevel = Required\nServer = https://eyl.io/media/aur/$arch' >> /etc/pacman.conf
pacman-key -r 3245467889B6B0C31B668D764D47368BD660A1C7
pacman-key --lsign-key 3245467889B6B0C31B668D764D47368BD660A1C7

pacman -Syu --noconfirm
pacman -S base-devel bc bear clang cmake doxygen git htop llvm postgresql python python-django python-psycopg2 wget --noconfirm

sudo -u postgres -i initdb -D /var/lib/postgres/data
systemctl enable postgresql
systemctl start postgresql
sudo -u postgres -i createuser --superuser vagrant
sudo -u vagrant -i createdb cpp_doc

sudo -u vagrant -i wget http://laforge.cs.uwaterloo.ca/const-checker-0.1.0.tar.gz
sudo -u vagrant -i tar xzf /home/vagrant/const-checker-0.1.0.tar.gz
sudo -u vagrant -i bash -c 'mkdir /home/vagrant/const-checker-0.1.0/build && cd /home/vagrant/const-checker-0.1.0/build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make'
bash -c 'cd /home/vagrant/const-checker-0.1.0/build && make install'
sudo -u vagrant -i psql cpp_doc -c '\i /home/vagrant/const-checker-0.1.0/sql/functions.sql'

sudo -u vagrant -i wget http://laforge.cs.uwaterloo.ca/django-cpp-doc-0.1.0.tar.gz
sudo -u vagrant -i tar xzf /home/vagrant/django-cpp-doc-0.1.0.tar.gz
bash -c 'cd /home/vagrant/django-cpp-doc-0.1.0 && python setup.py install'

sudo -u vagrant -i wget http://laforge.cs.uwaterloo.ca/const-checker-experiments-0.1.0.tar.gz
sudo -u vagrant -i tar xzf /home/vagrant/const-checker-experiments-0.1.0.tar.gz
sudo -u vagrant -i bash -c 'cd /home/vagrant/const-checker-experiments-0.1.0 && python manage.py migrate'
