FROM archlinux/base

RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    echo -e '\n[eyl]\nSigLevel = Required\nServer = https://eyl.io/media/aur/$arch' >> /etc/pacman.conf && \
    pacman-key -r 3245467889B6B0C31B668D764D47368BD660A1C7 && \
    pacman-key --lsign-key 3245467889B6B0C31B668D764D47368BD660A1C7 && \
    pacman -Syu --noconfirm && \
    pacman -S base-devel bc bear clang cloc cmake doxygen eigen emacs-nox git gtkglext hdf5 htop intel-tbb libdc1394 libutempter llvm mesa ocaml ocaml-ctypes ocaml-findlib openexr perl-io-tty postgresql protobuf python python-django python-numpy python-psycopg2 python-sphinx python2 python2-numpy python2-setuptools re2c swig unzip wget xine-lib --noconfirm

RUN sudo -u postgres -i initdb -D /var/lib/postgres/data && \
    systemctl enable postgresql && \
    mkdir /run/postgresql && \
    chown -R postgres:postgres /run/postgresql

RUN useradd -ms /bin/bash -p 'vagrant' vagrant
WORKDIR /home/vagrant/
RUN wget -nv http://laforge.cs.uwaterloo.ca/django-cpp-doc-0.1.0.tar.gz -O - | tar xz && \
    wget -nv http://laforge.cs.uwaterloo.ca/const-checker-experiments-0.1.0.tar.gz -O - | tar xz && \
    wget -nv https://github.com/eyolfson/const-checker/archive/0.1.1.tar.gz -O const-checker-0.1.1.tar.gz -O - | tar xz

WORKDIR /home/vagrant/django-cpp-doc-0.1.0
RUN python setup.py install

WORKDIR /home/vagrant/const-checker-0.1.1/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && \
    make install

EXPOSE 8000

RUN pacman -S inetutils --noconfirm
RUN pacman -S openssh --noconfirm
RUN chown vagrant -R /home/vagrant

WORKDIR /home/vagrant/const-checker-experiments-0.1.0
COPY startup.sh /home/vagrant/
ENTRYPOINT ["/bin/sh", "/home/vagrant/startup.sh"]
