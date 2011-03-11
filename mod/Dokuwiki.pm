package Dokuwiki;
# dokuwiki的功能模块，目前可以通过Frontier::Client查询

use strict;
use warnings;

use Frontier::Client;
use Data::Dumper;

#isa_ok( $server, 'Frontier::Client' );

# 参数预设
my $blendercnWiki = "http://wiki.blendercn.org/";

# 登录测试
#my $method = 'dokuwiki.login';
#my @args = ( 'blenny', 'xxxxxx' );
#ok( my $result = $server->call( $method, @args ), '登录wiki' );

# $result->value ; #显示是否登录成功，1成功，0失败。
#print Dumper($result);  #测试，查看结果的数据结构

#print &search_wiki('blender');

# 查询测试
sub search_wiki {
    my $keys        = shift;
    my @search_keys = split( /\ /, $keys );
    my $method      = 'dokuwiki.search';
    my $server      = Frontier::Client->new(
        'url' => 'http://wiki.blendercn.org/lib/exe/xmlrpc.php' )
      ;    #通过url定义一个客户端
    my $founds = $server->call( $method, @search_keys );    # '搜索数据' );
    my @recorders = @{$founds};

    #显示搜索结果
    #ok( print Dumper(@recorders), 'array?' );

    #ok (print ($recorders[0]{snippet}),'hash?') ;

    my $namespace = $recorders[0]{id};

    #print "id is : $namespace\n";

    #循环显示每个结果
    my @reports;
    foreach my $found (@recorders) {
        push @reports, &handle_namespace( $found->{id} );
    }
    my $n = 1;                                #定义结果序号的起始位置
    my @re = map { $n++ . ".$_\0" } @reports;
    return join( "", @re );
}

sub handle_namespace {
    my $namespace = shift;
    my $server    = Frontier::Client->new(
        'url' => 'http://wiki.blendercn.org/lib/exe/xmlrpc.php' )
      ;                                       #通过url定义一个客户端

    # 替换id为全部内容
    my $method      = 'wiki.getPage';
    my @search_keys = ($namespace);
    my $founds = $server->call( $method, @search_keys );    # '取得该页' );

    #显示搜索结果
    #ok (print $founds,'array?') ;

    return handel_detail( $founds, $namespace );

}

sub handel_detail {
    my $founds    = shift;
    my $namespace = shift;
    my @lines     = split( /\n/, $founds );
    my $title     = $lines[0];
    my $snippet   = $lines[2];

#    isnt( $title, "====== 计算raySource的方法 ======", '取得标题' );
#   isnt( $snippet,"刚刚搞来了blender 2.49 的部分源代码，里面找到了算法",        '取得概述'    );

    #过虑标题的======
    $title =~ s/=//g;

    #    isnt( $title, " 计算raySource的方法 ", '清理标题' );

    #替换spacename成为具体link
    $namespace =~ s/:/\//g;

    #   isnt( $namespace, 'faq/algorithm/raysource', '替换namespace' );
    my $wordlink = $blendercnWiki . $namespace;

    #   print "link:$wordlink\n";

    #整理输出格式
    my $report = "[$title] $snippet... $wordlink\n";

    #    print $report;
    return $report;
}

1;
