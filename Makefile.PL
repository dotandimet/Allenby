use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  VERSION   => '0.01',
  PREREQ_PM => {'Mojolicious' => '6.28',
                'Text::Markdown' => '*' },
  test      => {TESTS => 't/*.t'}
);
