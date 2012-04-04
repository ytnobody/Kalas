use strict;
use Test::More;
use Kalas;

my $k = Kalas->new;
isa_ok $k, 'Kalas';
is $k->max_threads, 4, 'Default max_threads = 4';
is $k->requests_par_thread, 10, 'Default requests_par_thread = 10';

done_testing;
