#! /usr/bin/perl 

BEGIN {
  push(@INC, '..');
}; 



use warnings;
use strict;
use Test::More qw(no_plan);
BEGIN { use_ok('Xgoogle'); }

my @needs;
push @needs, "g perl";
push @needs, "pdf perl";
push @needs, "doc perl";
push @needs, "xls perl";
push @needs, "ppt perl";
push @needs, "mp3 love";

foreach my $var (@needs) {
    ok( print &Xgoogle::main($var), "main xgoogle\n" );
}
