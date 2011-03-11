#! /usr/bin/perl 

BEGIN {
  push(@INC, '..');
}; 



use warnings;
use strict;
use Test::More tests => 2 ; 
use_ok('Xgoogle') or exit ; #载入Xgoolge模块'

my @needs;
push @needs, "g perl";
push @needs, "pdf perl";
push @needs, "doc perl";
push @needs, "xls perl";
push @needs, "ppt perl";
push @needs, "mp3 love";

my $normal_result = Xgoogle->main('g perl');
ok( print $normal_result, "google主查找，关键词g perl." );
