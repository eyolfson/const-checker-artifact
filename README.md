# const Checker Artifact

The accompanying artifact for ICSE 2019.

## Starting the Virtual Machine

    vagrant up --provider=virtualbox
    vagrant ssh

## Starting the Web Server

As the vagrant user:

    cd /home/vagrant/const-checker-experiments-0.1.0
    python manage.py runserver 0.0.0.0:8000

## Packages

### fish

#### Running

    cd /home/vagrant/const-checker-experiments-0.1.0/fish/2.5.0
    makepkg
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py fish 2.5.0

### libsequence

#### Running

    cd /home/vagrant/const-checker-experiments-0.1.0/libsequence/1.8.7
    makepkg
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py libsequence 1.8.7

### LLVM

#### Running

    cd /home/vagrant/const-checker-experiments-0.1.0/llvm/4.0.0
    makepkg --skippgpcheck
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py llvm 4.0.0

### Mosh

#### Running

    cd /home/vagrant/const-checker-experiments-0.1.0/mosh/1.2.6
    makepkg
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py mosh 1.2.6

### Ninja

#### Running

    cd /home/vagrant/const-checker-experiments-0.1.0/ninja/1.7.2
    makepkg
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py ninja 1.7.2

### OpenCV

#### Running

    cd /home/vagrant/const-checker-experiments-0.1.0/opencv/3.2.0
    makepkg
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py opencv 3.2.0

### Protobuf

#### Running

    cd /home/vagrant/const-checker-experiments-0.1.0/protobuf/3.3.1
    makepkg --skipchecksums
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py protobuf 3.3.1