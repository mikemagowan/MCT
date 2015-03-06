use Mojo::Base -strict;
use Test::Mojo;
use Test::More;

plan skip_all => 'set TEST_ONLINE'
  unless $ENV{MCT_DATABASE_DSN} = $ENV{TEST_ONLINE};

my $t = Test::Mojo->new('MCT');

$t->get_ok('/')->status_is(302)->header_is(Location => '/2015');
$t->get_ok('/2015/conduct')->status_is(200);
$t->get_ok('/2015/travel')->status_is(200);

done_testing;
