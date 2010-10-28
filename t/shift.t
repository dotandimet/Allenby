#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 6;

use_ok('Allenby::Model::Slides');

my $show = Allenby::Model::Slides->new(path => 'slides.json')->load();
is($show->count, 3, 'number of slides in file');
like($show->at(1)->text, qr/Mojolicious/, 'first slide');
like($show->at(2)->text, qr/Dotan/, 'second slide');
like($show->at(3)->text, qr/MVC/, 'third slide');
#$show->at(2)->before(1);
$show->reorder([2,1,3]);
like($show->at(1)->text, qr/Dotan/, 'moved 2nd to before 1st slide');

