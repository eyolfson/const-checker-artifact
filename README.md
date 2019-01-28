# const Checker Artifact

The accompanying artifact for our ICSE 2019 paper.

## Overview

For ease of use we provide a virtual machine using Vagrant. Our software should
work with a standard Linux install. However, our experiments use the Arch
distribution's build scripts. Note that there are some rare cases were our
numbers do not match our paper under submission, we will correct this in the
camera-ready version.

## Virtual Machine Setup

We use [Vagrant](https://www.vagrantup.com/) to manage our virtual machine and
recommend the [VirtualBox](https://www.virtualbox.org/) provider. Please
download and install both before continuing.

We recommend the virtual machine runs with 4 virtual CPUs and 4 GB of memory. If
your system can handle more, open the `Vagrantfile` in this directory and
increase `vb.cpus` and `vb.memory`. Please ensure port 8000 on your machine is
not in use.

To start the virtual machine run the following command:
`vagrant up --provider=virtualbox`. This should setup and provision the virtual
machine with all our software and required libraries. In the rare case the
provision fails, run `vagrant destroy` and retry the previous command. Note that
the source code of the experiments is not downloaded at this stage. We only
download experiment source when you build the experiment's software.

Connect to the virtual machine with: `vagrant ssh`. From this point onwards all
commands listed need to be run within the virtual machine.

## Running the Experiments

Our paper contains 7 software projects. All of the code is in the
`const-checker-experiments-0.1.0` directory under the home directory. Running
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

    # fish 2.5.0

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
      -  http://localhost:8000/package/fish/2.5.0/decl/1316 function_autoload_t
      -  http://localhost:8000/package/fish/2.5.0/decl/673 test_expressions::test_parser
      -  http://localhost:8000/package/fish/2.5.0/decl/1066 lru_cache_t::iterator
      -  http://localhost:8000/package/fish/2.5.0/decl/1088 autoload_t
      -  http://localhost:8000/package/fish/2.5.0/decl/1466 completion_autoload_t

    ## Figure 4
      - non-const methods: 60%
        -  easily const-able: 10%
      - const methods: 40%
        - easily const-able: 52%

    ## Table VIII
      - # non-trivial classes: 29
      - % immutable classes (developer-written): 0%
      - % unannotated classes (developer-written): 21%

This matches the results in the paper. You may notice there are some links under
Table III-VII, these are for manual inspection. To get the lines of code (LOC)
counts run the following:
`cd /home/vagrant/const-checker-experiments-0.1.0/fish/2.5.0` followed by
`cloc .`. The next section covers how to use the web server. Note that for
larger projects we sample 20 classes instead. The sampling is random, and
we provide the classes we manually inspected for LLVM, OpenCV, and Protobuf in the
"Sampled Classes" section of this document.

## Using the Web Server

We recommend a second connection to the virtual machine, again using `vagrant ssh`,
for the web server, so it can be available for you to browse the results. After
connecting to the virtual machine please run the following commands:

    cd /home/vagrant/const-checker-experiments-0.1.0
    python manage.py runserver 0.0.0.0:8000

You should now be able to open your web browser on your host machine and
navigate to `http://localhost:8000/`. You should be greeted with a welcome home
page and be able to browse the results. Each method has a location link that
forwards you to the code listing on GitHub.

## Adding Additional Experiments

Adding more experiments is easy. We used the Arch Linux distribution's build system
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

## Sampled Classes

Below are the 20 classes we sampled from LLVM, OpenCV, and Protobuf. For each
class we denote if a class is "Immutable" or "All-mutating" in square brackets,
if there are no square brackets the class is neither. These sampled classes
correspond to what we used in Table III (LLVM), Table IV (OpenCV), and Table V
(Protobuf).

Reviewers may double check our manual classifications by starting the web server
and navigating to the same classes. For convenience we provide a script to get a
link for a specified class. As an example if you want to review
`llvm::TypeBasedAAResult` in LLVM, use the following commands:
`cd /home/vagrant/const-checker-experiments-0.1.0`, then
`scripts/get-link.py llvm 4.0.0 llvm::TypeBasedAAResult`. These commands will
generate a link for you to copy into the address bar of your web browser and
explore.

### LLVM

#### Immutable

- (anonymous namespace)::ObjCAtSyncChecker [Immutable]
- (anonymous namespace)::VforkChecker [Immutable]
- llvm::NoFolder [Immutable]
- llvm::SparcFrameLowering [Immutable]
- (anonymous namespace)::ExplodedGraphViewer [Immutable]
- clang::ast_type_traits::DynTypedNode [Immutable]
- llvm::DIELabel [Immutable]
- clang::driver::tools::nacltools::AssemblerARM [Immutable]
- clang::CFGBaseDtor [Immutable]
- clang::driver::tools::wasm::Linker [Immutable]
- clang::FrontendInputFile [Immutable]
- llvm::DIEEntry [Immutable]
- llvm::object::COFFSymbolRef [Immutable]
- llvm::LanaiSelectionDAGInfo [Immutable]
- clang::Expr::Classification [Immutable]
- (anonymous namespace)::NSAutoreleasePoolChecker [Immutable]
- llvm::ARM::WinEH::RuntimeFunction [Immutable]
- clang::BuiltinType [Immutable]
- llvm::SIFrameLowering [Immutable]
- clang::consumed::PropagationInfo [Immutable]

#### Unannotated

- clang::CodeGen::InstrProfStats
- clang::MultiplexConsumer [Immutable]
- clang::CodeGenerator
- (anonymous namespace)::CGNVCUDARuntime
- JITLoaderGDB
- llvm::ProfileSummaryInfo
- (anonymous namespace)::OMPClauseProfiler
- clang::format::WhitespaceManager [All-mutating]
- llvm::TypeBasedAAResult [Immutable]
- (anonymous namespace)::AddToDriver [All-mutating]
- clang::CodeGen::ConstantInitBuilder::AggregateBuilderBase [All-mutating]
- llvm::safestack::StackColoring
- lldb::SBPlatformShellCommand
- SystemRuntimeMacOSX
- BinaryFileHandler
- llvm::support::detail::packed_endian_specific_integral [All-mutating]
- clang::move::(anonymous namespace)::FindAllIncludes [All-mutating]
- llvm::CodeViewDebug [All-mutating]
- (anonymous namespace)::FloatExprEvaluator [All-mutating]
- llvm::pdb::TypedefDumper [All-mutating]

### OpenCV

#### Immutable

- google::protobuf::util::converter::(anonymous namespace)::TypeInfoForTypeResolver
- cv::VMin [Immutable]
- cv::MatOp_GEMM [Immutable]
- cv::Sum_SIMD [Immutable]
- cv::MatOp_Cmp [Immutable]
- cv::Acc_SIMD [Immutable]
- cv::cuda::DeviceInfo [Immutable]
- google::protobuf::internal::StringPiecePod [Immutable]
- cv::VAdd [Immutable]
- google::protobuf::RepeatedFieldRef [Immutable]
- cv::StdMatAllocator [Immutable]
- cv::VSub [Immutable]
- cv::MatOp_Bin [Immutable]
- cv::VMax [Immutable]
- cv::_InputOutputArray
- cv::cvtScale_SIMD [Immutable]
- cv::_InputArray [Immutable]
- google::protobuf::TextFormat::FieldValuePrinter [Immutable]
- cv::_OutputArray [Immutable]
- google::protobuf::internal::RepeatedPtrFieldStringAccessor [Immutable]

#### Unannotated

- cv::RMByteStream
- cv::text::OCRBeamSearchDecoder
- CvPriorityQueueFloat [All-mutating]
- cv::randpattern::RandomPatternCornerFinder
- cv::multicalib::MultiCameraCalibration
- cv::IppMorphTrait
- cv::Cloning [All-mutating]
- VocData
- cv::detail::SurfFeaturesFinder [All-mutating]
- cv::KAZEFeatures
- google::protobuf::io::FileOutputStream::CopyingFileOutputStream
- google::protobuf::util::(anonymous namespace)::StatusErrorListener
- cvflann::squareDistance
- google::protobuf::io::FileInputStream::CopyingFileInputStream
- cv::text::OCRHMMDecoder
- cv::detail::OrbFeaturesFinder [All-mutating]
- cv::videostab::VideoFileSource
- google::protobuf::io::(anonymous namespace)::CommentCollector [All-mutating]
- cv::AviMjpegStream
- cv::tld::TrackerTLDImpl::Nexpert

### Protobuf

#### Immutable

- google::protobuf::compiler::cpp::MessageOneofFieldGenerator [Immutable]
- google::protobuf::compiler::javanano::PrimitiveOneofFieldGenerator [Immutable]
- google::protobuf::internal::StringPiecePod [Immutable]
- google::protobuf::compiler::java::RepeatedImmutableLazyMessageFieldLiteGenerator [Immutable]
- google::protobuf::compiler::javanano::PrimitiveFieldGenerator [Immutable]
- google::protobuf::RepeatedFieldRef [Immutable]
- google::protobuf::compiler::javanano::MapFieldGenerator [Immutable]
- google::protobuf::compiler::java::RepeatedImmutableEnumFieldGenerator [Immutable]
- google::protobuf::compiler::java::RepeatedImmutablePrimitiveFieldLiteGenerator [Immutable]
- google::protobuf::compiler::java::ImmutableStringFieldGenerator [Immutable]
- google::protobuf::util::converter::(anonymous namespace)::TypeInfoForTypeResolver
- google::protobuf::compiler::java::RepeatedImmutableEnumFieldLiteGenerator [Immutable]
- google::protobuf::compiler::cpp::PrimitiveOneofFieldGenerator [Immutable]
- google::protobuf::compiler::java::ImmutableMapFieldGenerator [Immutable]
- google::protobuf::compiler::java::ImmutableMessageOneofFieldGenerator [Immutable]
- google::protobuf::compiler::java::ImmutableMapFieldLiteGenerator [Immutable]
- google::protobuf::compiler::javanano::AccessorPrimitiveFieldGenerator [Immutable]
- google::protobuf::compiler::java::ImmutableLazyMessageFieldLiteGenerator [Immutable]
- google::protobuf::compiler::cpp::RepeatedStringFieldGenerator [Immutable]
- google::protobuf::internal::MapFieldAccessor [Immutable]

#### Unannotated

- google::protobuf::compiler::cpp::EnumGenerator [Immutable]
- google::protobuf::io::(anonymous namespace)::CommentCollector [All-mutating]
- google::protobuf::compiler::csharp::PrimitiveFieldGenerator [Immutable]
- google::protobuf::internal::LazyDescriptor [All-mutating]
- google::protobuf::compiler::csharp::MapFieldGenerator
- google::protobuf::compiler::CommandLineInterface [All-mutating]
- google::protobuf::compiler::java::ImmutableMessageLiteGenerator [Immutable]
- google::protobuf::compiler::java::FileGenerator [Immutable]
- google::protobuf::util::converter::testing::TypeInfoTestHelper
- google::protobuf::compiler::csharp::EnumFieldGenerator [Immutable]
- google::protobuf::compiler::csharp::MessageOneofFieldGenerator [Immutable]
- google::protobuf::io::FileInputStream::CopyingFileInputStream
- google::protobuf::util::MessageDifferencer::StreamReporter [All-mutating]
- google::protobuf::util::(anonymous namespace)::StatusErrorListener
- google::protobuf::io::FileOutputStream::CopyingFileOutputStream
- google::protobuf::SimpleDescriptorDatabase::DescriptorIndex
- google::protobuf::compiler::csharp::MessageFieldGenerator [Immutable]
- google::protobuf::compiler::cpp::MessageGenerator [Immutable]
- google::protobuf::compiler::javanano::FileGenerator [Immutable]
- google::protobuf::compiler::csharp::WrapperOneofFieldGenerator [Immutable]

## Example Calculations

Table VIII presents estimated percentages of immutable classes and
all-mutating classes for LLVM, OpenCV, and Protobuf, and actual
percentages for fish, Mosh, Ninja, and libsequence. Table IX presents
estimated percentages of immmutable methods across all of our benchmarks.

As an example of the computation for Table IX, consider fish.
Figure 4 shows that 40% of its methods are const-qualified,
while 60% are not. The easily const-able analysis found that 10%
of the non-const-qualified methods were const-able, which
thus accounts for 40% + 60% * 10% = 46% of methods, as seen
in Table IX.

[PATRICK TODO]
We need examples and numbers for "% immutable classes (estimated)" and
"% all-mutating classes (estimated)" in Table VIII.
We also need an example calculation for Table IX.

## Corrections for Camera-Ready Version

While recomputing our estimates we noticed some discrepancies
between the results in the paper and those generated by our artifact.
We will correct the camera-ready version of the paper.

- In Table III, the "Unannotated" row of the "Immutable" column should be
  2 (of 20), and 8 should instead be in the "All-mutating" column of the same
  row (consistent with the caption).
- The calculations for LLVM in Section IV subsection A are wrong, instead of
  15% it should be 10%.
- In Table VIII, the fish "% unannotated classes (developer-written)" should be
  21, the corresponding estimated column is correct.

We'll update all numbers that depend on these.

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

## Manually Inspected Classes

For completeness this section shows the remaining classes we manually inspected
for Table VI and VII. Similarly to the sampled classes we denote if a class is
"Immutable" or "All-mutating" in square brackets, if there are no square
brackets the class is neither.

### fish

#### Unannotated

- test_expressions::test_parser [All-mutating]
- function_autoload_t
- completion_autoload_t
- autoload_t
- lru_cache_t::iterator
- scoped_rwlock [All-mutating]

### Ninja

#### Unannotated

- Lexer
- (anonymous namespace)::DryRunCommandRunner

### libsequence

#### Immutable

- Sequence::shortestPath [Immutable]
- Sequence::FST [Immutable]
- Sequence::PolySIM [Immutable]
- Sequence::PolySNP [Immutable]
- Sequence::Comeron95 [Immutable]
- Sequence::Sites [Immutable]
- Sequence::coalsim::sfs_times [Immutable]
- Sequence::RedundancyCom95 [Immutable]
