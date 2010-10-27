#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 6;

use_ok('Allenby::Model::Slides');

my $show = Allenby::Model::Slides->new(path => 'slides.json')->load();
is($show->count, 3, 'number of slides in file');
like($show->first->text, qr/Mojolicious/, 'first slide');
$show->add(text => 'MVC - what is it?', notes => 'mention Catalyst...');
like($show->last->text, qr/MVC/, 'added slide');
$show->add({text => 'bob', notes => 'is your uncle'});
is($show->count, 5, 'number of slides after 2nd ad');
like($show->at(4)->text, qr/MVC/, 'slide by position');
__DATA__
[
{
"text" : "Mojolicious Duct Tape for The HTML5 Web ",
"label" : "intro",
"notes" : "introduce myself"
}
]

