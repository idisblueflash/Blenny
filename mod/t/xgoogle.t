#! /usr/bin/perl 

BEGIN {
  push(@INC, '..');
}; 

use warnings;
use strict;
use Test::More tests => 4 ; 
use_ok('Xgoogle') or exit ; #载入Xgoolge模块'

my @needs;
push @needs, "g perl";
push @needs, "pdf perl";
push @needs, "doc perl";
push @needs, "xls perl";
push @needs, "ppt perl";
push @needs, "mp3 love";

ok( my $normal_result = Xgoogle::main("g perl"), "google主查找，关键词g perl." );
ok( $normal_result = Xgoogle::main("doc perl"), "google主查找，关键词doc perl." );
ok( $normal_result = Xgoogle::main("s 源代码"), "blenderCN wiki查找，关键词s blender." );
print $normal_result ;

