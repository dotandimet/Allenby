#!/usr/bin/env perl

use strict;
use warnings;

use File::Basename 'dirname';
use File::Spec;

use lib join '/', File::Spec->splitdir(dirname(__FILE__)), 'lib';
use lib join '/', File::Spec->splitdir(dirname(__FILE__)), '..', 'lib';

use Allenby::Model::Slides;
my ($in) = shift;
die "Please provide an input file argument" unless ($in);
open(my $fh, $in) || die "$! when reading input file $in\n";
my ($out) = shift || 'import.json';
my @s = do { local $/; split(/\n===\n/, <$fh>) };
my $a = Allenby::Model::Slides->new(path => $out);
$a->add({ text => $_ }) for (@s);
$a->store;
print "Wrote ", scalar @s , " slides into file $out\n";
