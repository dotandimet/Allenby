#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 10;
use Test::Mojo;

use_ok('Allenby');

# Test
my $t = Test::Mojo->new(app => 'Allenby');
$t->get_ok('/slide/add')->status_is(200)->content_type_is('text/html')
  ->element_exists('form[method="post"][action="/slide/save"]', 'form exists')
  ->element_exists('form textarea[name="text"]')
  ->element_exists('form input[name="notes"]')
  ->element_exists('form input[name="label"]');

# content_like(qr/Mojolicious Web Framework/i);

$t = $t->post_form_ok('/slide/save',
        {text => '<p>New Stuff!</p>', notes => '', label => ''}, 'posting form')
    ->status_is(302)->header_like('Location', qr/(\/slide\/(\d+)\/)/,
    'location');
   print "$1 is location\n";
   $t->get_ok($1)
  ->content_type_is('text/html')
  ->element_exists('div.slide');
;

