package MCT::Model::User;

use Mojo::Base 'MCT::Model';

my @valid = qw/name username email/;
my %valid; @valid{@valid} = (1)x@valid;

sub get {
  my ($self, $username, $cb) = @_;
  $self->_query(<<'  SQL', $username, $cb);
    SELECT name, username, email
    FROM users
    WHERE username=?
  SQL
}

sub create {
  my ($self, $user, $cb) = @_;
  my @values = @{$user}{qw/name username email/};
  $self->_query(<<'  SQL', @values, $cb);
    INSERT INTO users (name, username, email)
    VALUES (?, ?, ?)
  SQL
}

sub update {
  my ($self, $username, $data, $cb) = @_;
  my @cols = grep { exists $valid{$_} } keys %$data;
  my $cols = join ', ', map { "$_=?" } @cols;
  my @values = @{$data}{@cols};
  $self->_query(<<"  SQL", @values, $username, $cb);
    UPDATE users
    SET $cols
    WHERE username=?
  SQL
}

1;

