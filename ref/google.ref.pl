require ("mod/Google.pm"); 
my ($msg) = @ARGV;
$_ = $msg;
if ($msg =~/^[g?](\d*) (.*)/i){
    my $max      = $1 || 2;
    my $keywords = $2;
    my @results = Google::search($keywords,$max);
    my $n=1;
    print map {"[" . $n++ . "] $_\0"} @results;
}
