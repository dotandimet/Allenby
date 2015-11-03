# Testing in Unity

---



---

    ls $UNITY_ROOT/tests

123 files of varying age.
Mostly for developer checking that their module is working.

---

    less tests/openbab.pl
    #!/evogene/software/bin/perl

    #!/usr/bin/perl

    use Chemistry::OpenBabel;

    my $obMol = new Chemistry::OpenBabel::OBMol;
    my $obConversion = new Chemistry::OpenBabel::OBConversion;
    $obConversion->SetInAndOutFormats("smi", "mdl");
    $obConversion->ReadString($obMol, "C1=CC=CS1");

---

# Perl Testing Culture

## **Automated** testing of code.

---

    perl t/20-ci-miner.t
    ok 1 - miner main page (productions)
    ok 2 - 'result list' isa 'HTTP::Response'
    ok 3 - cluster results page
    ok 4 - An object of class 'HTTP::Response' isa 'HTTP::Response'
    ok 5 - cluster page
    1..5

---

    perl t/01-demo.t
    1..2
    ok 1 - Unity Root is defined
    not ok 2 - Unity root is lweb
    #   Failed test 'Unity root is lweb'
    #   at t/01-demo.t line 5.
    #          got: '/home/users/bioinf/dotan/work/unity'
    #     expected: '/evogene/unity/sites/lweb'

---

# TAP
## Test Anything Protocol

---

### t/01-demo.t

    use Test::More tests => 2;

    ok(defined $ENV{'UNITY_ROOT'}, 'Unity Root is defined');
    is ($ENV{'UNITY_ROOT'}, '/evogene/unity/sites/lweb', 'Unity root is lweb');

---

## Test::More

  - Standard Perl Testing module
  - Simple testing functions that produce **TAP** output:
      - ok
      - is
      - like
      - cmp_ok
      - is_deeply
      - isnt, unlike, can_ok, isa_ok, require_ok
  - Other modules provide more specialized tests.

---

## Declaring up front how many tests should be run:

    use Test::More tests => 34;
    ...

---

## Not bothering:

    use Test::More;
    ...
    done_testing();

---

## Running all the tests

### prove

In Perl modules, if you have a makefile:

    make test

Otherwise,

    prove

Or, to run only specific tests:

    prove t/20-ci-miner.t t/umdt.t

---

`prove` output summarizes the tests run in each file and their success/failure
status:

        prove t/20-ci-miner.t t/umdt.t 
        t/20-ci-miner.t .. ok   
        t/umdt.t ......... ok   
        All tests successful.
        Files=2, Tests=9, 25 wallclock secs ( 0.03 usr  0.01 sys +  9.79 cusr  1.55 csys = 11.38 CPU)
        Result: PASS

---

## Test Types

  - Does the code work?
    - Continous Integration: did we break something
    - Debugging: Tests for edge cases
  - Is the code "good"
    - code style, correctness, best practices
    - shared standards, consistency

---

## Basic Code Tests

  - `t/00-compile.t`: Does everything compile without Errors?
  - `20-ci-miner.t`: Basic test of Athlete pages (Productions, ResultList,
    Cluster page) - do they load without errors with normal input.
  - `56-monitor.t`: Experiment with loading and running tests from monitor
    script.

---

## Compile Test:

    prove t/00-compile.t 
    t/00-compile.t .. # 
    # If you run "prove" the script will only check the files that were changed in the last 24 hours.
    # If you'd like to check all the 1220 files you need to set UNITY_TESTING to some true value. For example:
    # UNITY_TESTING=1 prove
    # This time we are checking 2 files.
    t/00-compile.t .. 1/3 # Elapsed time: 2
    t/00-compile.t .. ok   
    All tests successful.
    Files=1, Tests=3,  3 wallclock secs ( 0.03 usr  0.01 sys +  2.96 cusr  0.45 csys =  3.45 CPU)
    Result: PASS

---

## Compile Test

  - Checks all modules in lib (or lastest changed)
  - Has skip list
  - Tests run in parallel for speed (no nice progress, but fast).

---

## Code Niceness Tests

  - `t/95-tidyall.t`: code formatting checks
  - `t/96-perl-critic.t`: does code conform to good/best practices?

---

## Nice and Tidy

  - `perltidy` is a program for nicely formatting your code.
  - `.perltidyrc` is its configuration file, tweak rules (line length, parens
    tightness, tabs vs. spaces...)
  - `tidyall` is a program for running `perltidy` or other formatters on
    various files.
  - `.tidyallrc` is *its* configuration file, defines what formatters to run
    on what files.
  - SO, `t/95-tidyall.t` checks that `tidyall` was run.

---

    prove t/95-tidyall.t 
    t/95-tidyall.t .. 1/12 # [checked] t/01-demo.t
    # *** needs tidying

    #   Failed test 't/01-demo.t'
    #   at t/95-tidyall.t line 7.
    # *** needs tidying
    # Looks like you failed 1 test of 12.
    t/95-tidyall.t .. Dubious, test returned 1 (wstat 256, 0x100)
    Failed 1/12 subtests 

    Test Summary Report
    -------------------
    t/95-tidyall.t (Wstat: 256 Tests: 12 Failed: 1)
      Failed test:  3
      Non-zero exit status: 1
    Files=1, Tests=12,  1 wallclock secs ( 0.04 usr  0.00 sys +  0.38 cusr  0.05 csys =  0.47 CPU)
    Result: FAIL
    dotan@boots:unity master$ tidyall -a
    [tidied]  t/01-demo.t
    dotan@boots:unity master$ prove t/95-tidyall.t 
    t/95-tidyall.t .. ok     
    All tests successful.
    Files=1, Tests=12,  1 wallclock secs ( 0.04 usr  0.01 sys +  0.26 cusr  0.03 csys =  0.34 CPU)
    Result: PASS

---

## Perl Critic

  - `perlcritic` is a program that checks the code for best practices, such as
    use strict. Each test it runs is called a **Policy**.
  - `.perlcriticrc` is the configuration file defining what policies to apply and what to ignore, and how to format the warnings.
  - `t/96-perlcritic.t` checks that all files (in lib, except those in a *huge* skip list) pass perlcritic.

---

# IDEAL

## Run prove on each commit (git hook)

---

## Issues

  - Enforcing perlcritic and perltidy policies
      - In future
      - On old code
  - Issues fixing existing code
      - Adding `use strict` can reveal bugs by dying at runtime
      - We need more tests before we can do this refactoring?
  - Does the current (and incoming) regime support this extensive work?

