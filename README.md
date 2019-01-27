# const Checker Artifact

The accompanying artifact for ICSE 2019.

## Overview

For ease of use we provide a virtual machine using Vagrant. Our software should
work with a standard Linux install, however our experiments use a distribution's
build scripts for our experiments.

## Virtual Machine Setup

We use [Vagrant](https://www.vagrantup.com/) to manage our virtual machine and
recommend the [VirtualBox](https://www.virtualbox.org/) provider. Please ensure
to download and install both before continuing.

We recommend the virtual machine runs with 4 virtual CPUs and 4 GB of memory. If
your system can handle more plus open the `Vagrantfile` in this directory and
increase `vb.cpus` and `vb.memory`. Please ensure port 8000 on your machine is
not in use.

To start the virtual machine run the following command:
`vagrant up --provider=virtualbox`. This should setup and provision the virtual
machine with all our software and required libraries. In the rare case the
provision fails run: `vagrant destroy` and retry the previous command. Note that
the source code of the experiments is not downloaded at this stage. We only
download experiment source when you build the experiment's software.

Connect to the virtual machine with: `vagrant ssh`. From this point onwards all
commands listed need to be run within the virtual machine.

## Running the Experiments

Our paper contains 7 software projects, all of the code is in the
`const-checker-experiments-0.1.0` directory within the home directory. Running
an experiment for a software project requires 2 steps: 1) building the project,
and 2) analyzing the project.

We'll use fish as the first example. To build fish, issue the following commands:
`cd /home/vagrant/const-checker-experiments-0.1.0/fish/2.5.0`, and `makepkg`.
This should download the source for fish and build the package. The next step is
to analyze fish with the following commands:
`cd /home/vagrant/const-checker-experiments-0.1.0`, and
`scripts/analyze-package.py fish 2.5.0`.

Now we can collect the results for fish. In the same directory type the
following command: `scripts/results.py fish 2.5.0`. You should get the
output:

    ## Table I
      - Classes: 129
      - Methods: 299

    ## Table II
      - Has methods: 69.0%
        - Immutable: 6.2%
        - Query: 17.8%
        - Mix: 20.9%
        - Throwaway: 8.5%
        - Unannotated: 15.5%
      - Only fields: 31.0%

    ## Table III-VII
      - Immutable & 8 & 0
      - All-mutating & 20 & 6

    ### Immutable

    ### All-mutating
      -  http://localhost:8000/package/fish/2.5.0/decl/66 scoped_rwlock
      -  http://localhost:8000/package/fish/2.5.0/decl/66 scoped_rwlock
      -  http://localhost:8000/package/fish/2.5.0/decl/1316 function_autoload_t
      -  http://localhost:8000/package/fish/2.5.0/decl/1316 function_autoload_t
      -  http://localhost:8000/package/fish/2.5.0/decl/673 test_expressions::test_parser
      -  http://localhost:8000/package/fish/2.5.0/decl/673 test_expressions::test_parser
      -  http://localhost:8000/package/fish/2.5.0/decl/1066 lru_cache_t::iterator
      -  http://localhost:8000/package/fish/2.5.0/decl/1066 lru_cache_t::iterator
      -  http://localhost:8000/package/fish/2.5.0/decl/1088 autoload_t
      -  http://localhost:8000/package/fish/2.5.0/decl/1088 autoload_t
      -  http://localhost:8000/package/fish/2.5.0/decl/1466 completion_autoload_t
      -  http://localhost:8000/package/fish/2.5.0/decl/1466 completion_autoload_t

    ## Figure 4
      - non-const methods: 60%
        -  easily const-able: 10%
      - const methods: 40%
        - easily const-able: 52%

    ## Table VIII
      - # non-trivial classes: 29
      - % immutable classes (developer-written): 0%

This matches the results in the paper. You may notice there are some links under
Table III-VII, these are for manual inspection. The next section covers how to
use the web server. Note that for larger projects we sample 20 classes of each
instead. The sampling is random, and we provide the classes we manually
inspected for LLVM, OpenCV, and Protobuf. [PATRICK TODO]

## Using the Web Server

We recommend a second connect to the virtual machine, again using `vagrant ssh`,
for the web server so it can be available for you to browse the results. After
connecting to the virtual machine please run the following commands:

    cd /home/vagrant/const-checker-experiments-0.1.0
    python manage.py runserver 0.0.0.0:8000

You should now be able to open your web browser on your host machine and
navigate to `http://localhost:8000/`. You should be greeted with a welcome home
page and be able to browse the results. Each method has a location link that
forwards you to the code listing on GitHub.

## Adding Additional Experiments

Adding more experiments is easy. We used the Linux distribution's build system
because we were familiar with it, and knew it worked, but it is not a
requirement.

For each experiment we only require a `NAME` and `VERSION` (e.g. fish and
2.5.0). All source code for the experiment must be in the
`/home/vagrant/const-checker-experiments-0.1.0/NAME/VERSION/src`. Within this
directory our tool only needs a single `compile_commands.json` file to analyze
the project. The easiest way to do this is to prefix the `make` step of building
a project with `bear` (so instead of `make` run `bear make`). After that run
`cd /home/vagrant/const-checker-experiments-0.1.0` and
`scripts/analyze-package.py NAME VERSION` to analyze the package. It should
appear on the website, and you may also run `scripts/results.py NAME VERSION`.

Here is a full listing of commands for an example project from Github:

    cd /home/vagrant/const-checker-experiments-0.1.0
    mkdir -p tinyraytracer/master/src
    cd tinyraytracer/master/src
    git clone https://github.com/ssloy/tinyraytracer.git
    cd tinyraytracer
    cmake .
    bear make
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py tinyraytracer master
    scripts/results.py tinyraytracer master

## All Experiment Commands

This section is a reference for running all the experiments. Only two projects
require additional arguments to their `makepkg` commands. However, we provide
all commands here for reference.

### fish

    cd /home/vagrant/const-checker-experiments-0.1.0/fish/2.5.0
    makepkg
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py fish 2.5.0
    scripts/results.py fish 2.5.0

### libsequence

    cd /home/vagrant/const-checker-experiments-0.1.0/libsequence/1.8.7
    makepkg
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py libsequence 1.8.7
    scripts/results.py libsequence 1.8.7

### LLVM

    cd /home/vagrant/const-checker-experiments-0.1.0/llvm/4.0.0
    makepkg --skippgpcheck
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py llvm 4.0.0
    scripts/results.py llvm 4.0.0

### Mosh

    cd /home/vagrant/const-checker-experiments-0.1.0/mosh/1.2.6
    makepkg
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py mosh 1.2.6
    scripts/results.py mosh 1.2.6

### Ninja

    cd /home/vagrant/const-checker-experiments-0.1.0/ninja/1.7.2
    makepkg
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py ninja 1.7.2
    scripts/results.py ninja 1.7.2

### OpenCV

    cd /home/vagrant/const-checker-experiments-0.1.0/opencv/3.2.0
    makepkg
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py opencv 3.2.0
    scripts/results.py opencv 3.2.0

### Protobuf

    cd /home/vagrant/const-checker-experiments-0.1.0/protobuf/3.3.1
    makepkg --skipchecksums
    cd /home/vagrant/const-checker-experiments-0.1.0
    scripts/analyze-package.py protobuf 3.3.1
    scripts/results.py protobuf 3.3.1
