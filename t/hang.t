#!/usr/bin/env perl

use strict;
use warnings;

use JSON;

my $arr = [
{
"text" => "
Mojolicious

Duct Tape for The HTML5 Web

",
"label" => "first",
"notes" => "introduce topic"
},
{
"text" => "
Dotan Dimet

Programming Perl for 10 years

Christ. That's long.

",
"label" => "intro",
"notes" => "introduce myself"
},
{
"text" => "Always looking for a good web framework.
MVC is <i>Hard</i>
",
}
];

my $json = JSON->new();
$json->pretty(1);
my $str = $json->encode($arr);
print $str;
