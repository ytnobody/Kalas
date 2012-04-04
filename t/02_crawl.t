use strict;
use Test::More;
use Kalas;

my @urls = qw(
    http://www.google.com/
    http://cpan.org/
    http://www.yahoo.co.jp/
    http://metacpan.org/
    http://twitter.com/
);

my $k = Kalas->new( 
    max_threads => 3,
    requests_par_thread => 2,
    agent_params => {
        timeout => 60,
    },
);

$k->crawl( @urls );

my @res_list = map { $_->join } $k->coros;
my $title_fetcher = qr/<title>(.+)<\/title>/sim;

for my $res ( @res_list ) {
    diag explain $res->content =~ $title_fetcher;
    isa_ok $res, 'Furl::Response';
}

done_testing;
