use Mojo::Base -strict;
use Test::Mojo;
use Test::More;

plan skip_all => 'set TEST_ONLINE'
  unless $ENV{MCT_DATABASE_DSN} = $ENV{TEST_ONLINE};

$ENV{MCT_MOCK} = 1;
my $t = Test::Mojo->new('MCT');

$t->app->migrations->migrate(0)->migrate;
$t->app->model->conference(name => 'Testing Profile Conf', country => 'SE')->save(sub {});

$t->get_ok('/user/connect?code=42')->status_is(302);
$t->get_ok('/testing-profile-conf/profile')->status_is(200)->text_is('title', 'Testing Profile Conf - Profile')
  ->element_exists('img[src^="https://avatars.githubusercontent.com/u/45729"]')
  ->element_exists('input[name="name"][value="John Doe"]')
  ->element_exists('input[name="email"][value="john@example.com"]')
  ->element_exists('input[name="address"][value="Gotham City"]')
  ->element_exists('input[name="zip"][value=""]')
  ->element_exists('input[name="city"][value=""]')
  ->element_exists('select[name="country"]')
  ->element_exists('select[name="t_shirt_size"]')
  ->element_exists('input[name="web_page"][value="http://mojolicio.us"]');

my %profile = (
  name => 'Bruce Wayne',
  email => 'bruce@wayneindustries.com',
  username => 'bruce',
  address => 'Batcave',
  zip => '123',
  city => 'Gotham City',
  country => 'US',
  t_shirt_size => 'M',
  web_page => 'http://en.wikipedia.org/wiki/Wayne_Enterprises',
  avatar_url => 'https://gravatar.com/avatar/b850d96978b5b07e2e523b81db30c26b',
);

$t->post_ok('/testing-profile-conf/profile', form => \%profile)->status_is(200)
  ->element_exists('img[src^="https://gravatar.com/avatar/b850d96978b5b07e2e523b81db30c26b"]')
  ->element_exists('input[name="name"][value="Bruce Wayne"]')
  ->element_exists('input[name="email"][value="bruce@wayneindustries.com"]')
  ->element_exists('input[name="address"][value="Batcave"]')
  ->element_exists('input[name="zip"][value="123"]')
  ->element_exists('input[name="city"][value="Gotham City"]')
  ->element_exists('select[name="country"] option[value="US"][selected]')
  ->element_exists('select[name="t_shirt_size"]')
  ->element_exists('input[name="web_page"][value="http://en.wikipedia.org/wiki/Wayne_Enterprises"]');

done_testing;