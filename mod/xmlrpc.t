#!/usr/bin/perl 

use strict;
use warnings;
use Test::More 'no_plan' ;
use Test::LongString;
use utf8;

use_ok('Frontier::Client') ;
use_ok('Data::Dumper');
my $server =Frontier::Client->new('url' => 'http://wiki.blendercn.org/lib/exe/xmlrpc.php') ; #通过url定义一个客户端 
isa_ok ($server ,'Frontier::Client');


# 参数预设
my $blendercnWiki = "http://wiki.blendercn.org/";
# 登录测试
my $method = 'dokuwiki.login';
my @args = ('blenny','xxxxxx');
ok (my $result = $server->call($method, @args),'登录wiki');
# $result->value ; #显示是否登录成功，1成功，0失败。
#print Dumper($result);  #测试，查看结果的数据结构

# 查询测试
$method = 'dokuwiki.search';
my @search_keys = ('ray','Source');
ok (my $founds = $server->call($method, @search_keys),'搜索数据');
my @recorders = @{$founds};
#显示搜索结果
ok (print Dumper(@recorders),'array?') ;
#ok (print ($recorders[0]{snippet}),'hash?') ;

my $namespace = $recorders[0]{id} ;
print "id is : $namespace\n";

# 替换id为全部内容 
$method = 'wiki.getPage';
 @search_keys = ($namespace);
ok ($founds = $server->call($method, @search_keys),'取得该页');
#显示搜索结果
#ok (print $founds,'array?') ;

my @lines = split (/\n/,$founds);
my $title = $lines[0] ;
my $snippet= $lines[2] ;

is($title , "====== 计算raySource的方法 ======",'取得标题');
is($snippet, "刚刚搞来了blender 2.49 的部分源代码，里面找到了算法",'取得概述');

#过虑标题的======
$title =~ s/======//g;
is($title , " 计算raySource的方法 ",'清理标题');

#替换spacename成为具体link
$namespace =~ s/:/\//g;
is($namespace,'faq/algorithm/raysource','替换namespace');
my $wordlink = $blendercnWiki . $namespace ;
print "link:$wordlink\n";

#整理输出格式
my $report = "1.[$title] $snippet... $wordlink\n";
print $report;






