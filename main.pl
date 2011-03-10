#!/usr/bin/perl
# This is a simple IRC bot that just rot13 encrypts public messages.
# It responds to "rot13 <text to encrypt>".
# This demo programm is from: http://poe.perl.org/?POE_Cookbook/IRC_Bots

use warnings;
use strict;
use POE;
use POE::Component::IRC;
sub CHANNEL () { "#blendercn" }

# Create the component that will represent an IRC network.
# 创建一个组件来代表一个IRC网络
my ($irc) = POE::Component::IRC->spawn();

# Create the bot session.  The new() call specifies the events the bot
# knows about and the functions that will handle those events.
# 创建一个机器人会话。 new() 调用机器人所知的特殊的事件和函数，这些用于后期的处理。
POE::Session->create(
  inline_states => {
    _start     => \&bot_start,
    irc_001    => \&on_connect,
    irc_public => \&on_public,
  },
);

# The bot session has started.  Register this bot with the "Blenny"
# IRC component.  Select a nickname.  Connect to a server.
# 机器人会话开始了。 用"Blenny"来注册这个机器人的IRC组件。
# 选择一个昵称。连接到服务器。
sub bot_start {
  $irc->yield(register => "all");
  my $nick = 'usepoe' . $$ % 1000;
  $irc->yield(
    connect => {
      Nick     => $nick,
      Username => 'Blenny',
      Ircname  => 'POE::Component::IRC cookbook bot',
      Server   => 'irc.freenode.net',
      Port     => '6667',
    }
  );
}

# The bot has successfully connected to a server.  Join a channel.
# 机器人成功连接到了服务器。加入一个频道。
sub on_connect {
  $irc->yield(join => CHANNEL);
}

# The bot has received a public message.  Parse it for commands, and
# respond to interesting things.
# 机器人收到了一条公共信息。 按照命令格式分析信息，回复有用的内容。
sub on_public {
  my ($kernel, $who, $where, $msg) = @_[KERNEL, ARG0, ARG1, ARG2];
  my $nick    = (split /!/, $who)[0];
  my $channel = $where->[0];
  my $ts      = scalar localtime;
  print " [$ts] <$nick:$channel> $msg\n";
  if (my ($rot13) = $msg =~ /^rot13 (.+)/) {
    $rot13 =~ tr[a-zA-Z][n-za-mN-ZA-M];

    # Send a response back to the server.
    # 给服务器发送一个响应。
    $irc->yield(privmsg => CHANNEL, $rot13);
  }
}

# Run the bot until it is done.
# 当所有事情都处理完毕，运行机器人
$poe_kernel->run();
exit 0;
