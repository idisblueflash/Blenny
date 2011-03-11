#!/usr/bin/perl 

#外部引用模块
use strict;
use warnings;
use Test::More qw(no_plan);
use Net::IRC;
use Time::HiRes;
use Encode;
#全局参数
my $gbkon = 1;    #是否使用GBK说话　，　０　采用UTF-8

#irc连接参数设置
#my $server = shift || '210.51.190.228';
#my $server = shift || 'irc.beyondyou.com';
my $server = shift || 'irc.bdwater.com';
#my $server = shift || 'irc.linuxfire.com.cn';

# Multiple channels may be separated by ':' characters.
#my $channel = shift || "#info:#blendermaster:#BlenderCN";
my $channel = shift
  || "#peele:#blendercn:#info";
#  . togbk("极夜") . ":#"
#  . togbk("等闲") . ":#"
#  . togbk("我爱我家");

my $nick       = shift || "Peele";
my $ircname    = shift || "Peele";
my $port       = shift || 6667;
my $howvocal   = shift || 10;       # percentage of the time it talks publically
my $reInterval = shift || 2;        # how often to dice, for a certen man.

my @ignore    = ( 'dpkg', 'apt', '||' );    # other bots and idiots to ignore

my $verbose   = 1;
my $gift      = 5;

#on stop me, Catch ctrl-c properly and stop me.
$SIG{TERM} = sub {
    exit;
};
$SIG{INT} = $SIG{TERM};

#Set ignore me up.
push @ignore, $nick;

#irc 初始化/连接
my $greet = "hi";

my $irc  = Net::IRC->new;
my $conn = $irc->newconn(
    Nick    => $nick,
    Server  => $server,
    Port    => $port,
    Ircname => $ircname,
);

$conn->add_handler( '376', \&on_connect ); # 376 = end of MOTD: we're connected.
$conn->add_handler( 'msg', \&on_msg );
$conn->add_handler( 'public', \&on_public );
$conn->add_global_handler( 'disconnect', \&on_disconnect );# on disconnect ,reconnect

#$irc->start;
while (1) {
    $irc->do_one_loop();
}


sub on_connect {

#irc首次连接时的动作
    my $self = shift;
    my $chan;

    foreach my $chan ( split( /:/, $channel ) ) {
        print "Joining $chan..\n" if $verbose;
        $self->join($chan);

        # Say hi (or something vaguely along those lines).
        print "<$nick> $greet\n";
        #$self->privmsg( $chan, $greet );

    }

}

sub on_public {
    #当用户和info在public chat的情况

    #传递状态数据
    my $self  = shift;
    my $event = shift;
    my $from  = $event->nick;
    my $chan  = join ( " ",$event->to);
    my $msg   = join ( "\n",$event->args);
    my $userhost = $event->host;

    $from = toutf($from);
    $chan = toutf($chan);
    $msg  = toutf($msg);

    print "Peele.msg:$msg\n";

    $msg = &ascii_save_char($msg);
    print "Peele.msg_save:$msg\n";
    
    #send the msg to poster
    my $re = qx{perl mod/poster.pl "$from" "$userhost" "$chan" "$msg"};
    my @reply = split (/\n/,$re);
    
    foreach (@reply){
            my ($chan,$user,$re) = split (/,,/,$_);
            if($re ne "\n"){
                print "chan=$chan, user=$user, re=$re\n\n";
                $self->privmsg( &togbk($chan),  &togbk($re));
            }
    }

    #working...

    #filter the ignore names
    return if grep { $from eq $_ } @ignore;




}

sub on_msg {
    #当用户和info在小窗私聊的情况

    #传递状态数据
    my $self  = shift;
    my $event = shift;
    my $from  = $event->nick;
    my $chan  = $event->to;

    #print "get You: $event->args\n";
    #return if grep { $from eq $_ } @ignore;

}

sub on_disconnect {

    #{{{当连接丢失时候,重新连接irc
    #Reconnect to the server when we die.
    my ( $self, $event ) = @_;

    print "Disconnected from ", $event->from(), " (", ( $event->args() )[0],
      "). Attempting to reconnect...\n";
    $self->connect();
}

#======================Functions===================================
sub toutf {

    #{{{ utf8<==>gbk 字符转化函数
    #my $re = encode( "utf8", decode( "gb18030", $_[0] ) );
    my $re = encode( "utf8", decode( "GBK", $_[0] ) );
    return $re;
}

sub togbk {

    #my $re = encode( "utf8", decode( "GBK", $_[0] ) );
    my $re = shift;
    if ($gbkon) {
        $re = encode( "GBK", decode( "utf8", $re ) );
    }
    else {
    }
    return $re;
}



sub ascii_save_char() {
    my $msg = shift;
    if ( $msg =~ m/\0/ ) {
        ok( $msg =~ s/\0//g );
    }

    if ( $msg =~ m/\$/ ) {
        ok( $msg =~ s/\$/\\\$/g );
    }
    elsif ( $msg =~ m/\`/ ) {
        ok( $msg =~ s/\`/\\\`/g );
    }
    elsif ( $msg =~ m/\"/ ) {
        ok( $msg =~ s/\"/\\\"/g );
    }
    elsif ( $msg =~ m/\\/ ) {
        ok( $msg =~ s/\\/\\\\/g );
    }
    return $msg;
}
