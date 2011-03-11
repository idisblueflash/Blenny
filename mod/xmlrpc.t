#!/usr/bin/perl 

use strict;
use warnings;
use Test::More tests => 5 ;

use_ok('Frontier::Client') ;
use_ok('Data::Dumper');
my $server =Frontier::Client->new('url' => 'http://wiki.blendercn.org/lib/exe/xmlrpc.php') ; #通过url定义一个客户端 
isa_ok ($server ,'Frontier::Client');


# 登录测试
my $method = 'dokuwiki.login';
my @args = ('blenny','xxxxxx');
ok (my $result = $server->call($method, @args),'登录wiki');
# $result->value ; #显示是否登录成功，1成功，0失败。
#print Dumper($result);  #测试，查看结果的数据结构

# 查询测试
$method = 'dokuwiki.search';
my @search_keys = ('ray','Source');
ok (my $result = $server->call($method, @search_keys),'搜索数据');

print Dumper($result);  #测试，查看结果的数据结构

#显示搜索结果
print $result->{'snippet'} ; #显示片断简介
