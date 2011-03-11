#!/usr/bin/perl 
use lib 'mod/' ;
use strict;
use warnings;
use Xgoogle;
use Url2title;

my($user,$userhost,$chan,$msg) = @ARGV;
#print "user: $user, userhost: $userhost, chan: $chan, msg: $msg\n";



my @result;
    #keyword mod 移除 关键字 模块

    #xgoogle mod
    my $re = &Xgoogle::main($msg); 
    if ($re) {
        my @returns= split (/\0/,$re);
        foreach(@returns){
            push (@result,"$chan,,$user,,$_");
        }
    }

    #url to tilte mod
    my $re = &Url2title::main($msg);
    if ($re) {push (@result,"$chan,,$user,,$re");}
    
$msg = &ascii_save_char($msg);
#mods to plug in
    #show emote
    my $re = qx{perl mod/emote.pl "$msg" "$user"};
    if ($re) {push (@result,"$chan,,$user,,$re");}

    #get currency
    my $re = qx{perl mod/currency.pl "$msg"};
    if ($re) {push (@result,"$chan,,$user,,$re");}


    #sotre in mysql
    my $re = qx{perl mod/store_in_mysql.pl "$user" "$userhost" "$chan" "$msg"};
    if ($re) {push (@result,"$chan,,$user,,$re");}

    #ip to geo_location
    my $re = qx{perl mod/ip.pl "$userhost" "$msg"};
    if ($re) {push (@result,"$chan,,$user,,$re");}
    
    #todo mod
    my $re = qx{perl mod/todo.pl "$msg"};
    if ($re) {push (@result,"$chan,,$user,,$re");}

print map {"$_\n"} @result;



sub ascii_save_char() {
    my $msg = shift;
    if ( $msg =~ m/\0/ ) {
         $msg =~ s/\0//g ;
    }

    if ( $msg =~ m/\$/ ) {
        $msg =~ s/\$/\\\$/g ;
    }
    elsif ( $msg =~ m/\`/ ) {
        $msg =~ s/\`/\\\`/g ;
    }
    elsif ( $msg =~ m/\"/ ) {
         $msg =~ s/\"/\\\"/g ;
    }
    elsif ( $msg =~ m/\\/ ) {
        $msg =~ s/\\/\\\\/g ;
    }
    return $msg;
}
