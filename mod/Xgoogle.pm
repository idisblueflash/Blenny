package Xgoogle;
# 调用Google.pm 用来实现一些扩展的查询功能。
# 查询方式参见下面的例子
use warnings;
use strict;
use Google;

sub main() {
    my $msg      = shift;
    my $default_max = 2;
    my $max = "";
    my $keywords = "";
    my $filetype = "";
    if ( $msg =~ /^[g?](\d*) (.*)/i ) {
        $max      = $1 || $default_max;
        $keywords = $2;
    }
    elsif ( $msg =~ /^[s?](\d*) (.*)/i ) {
        $max      = $1 || $default_max;
        $keywords = $2;
	$filetype = " site:wiki.blendercn.org" ;
    }
    elsif ( $msg =~ /^pdf(\d*) (.*)/i ) {
        $max      = $1 || $default_max;
        $keywords = $2;
        $filetype = " filetype:pdf ";
    }
    elsif ( $msg =~ /^doc(\d*) (.*)/i ) {
        $max      = $1 || $default_max;
        $keywords = $2;
        $filetype = " filetype:doc ";
    }
    elsif ( $msg =~ /^xls(\d*) (.*)/i ) {
        $max      = $1 || $default_max;
        $keywords = $2;
        $filetype = " filetype:xls ";
    }
    elsif ( $msg =~ /^ppt(\d*) (.*)/i ) {
        $max      = $1 || $default_max;
        $keywords = $2;
        $filetype = " filetype:ppt ";
    }
    elsif ( $msg =~ /^mp3(\d*) (.*)/i ) {
        $max      = $1 || $default_max;
        $keywords = $2;
        $filetype = " filetype:mp3 ";
    }
    $keywords = $keywords . $filetype;
    my @results = Google::search( $keywords, $max );
    my $n = 1;
    my @re = map { "[" . $n++ . "] $_" } @results;
    return join(" ", @re);
}
1;
