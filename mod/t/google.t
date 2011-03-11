#! /usr/bin/perl 

BEGIN {
  push(@INC, '..');
}; 

use warnings;
use strict;
use Test::More tests => 2 ; 
use_ok('Google') or exit ; 	#载入Goolge模块'

my $keywords 	= "Blender";	#搜索关键词
my $max		= "3"; 		#返回条目数
ok(my @results = Google::search( $keywords, $max ),"测试google返回结果") ;

    my $n = 1;			#初始化结果计数器
    my @re = map { "[" . $n++ . "] $_" } @results; 	#装入特定显示格式
    print join(" ", @re); 	#打印结果，测试用
