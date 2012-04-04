use inc::Module::Install;
name 'Kalas';
all_from 'lib/Kalas.pm';

requires 'Coro';
requires 'Coro::Semaphore';
requires 'FurlX::Coro';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
