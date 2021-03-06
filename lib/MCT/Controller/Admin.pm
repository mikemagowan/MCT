package MCT::Controller::Admin;

use Mojo::Base 'Mojolicious::Controller';

sub authorize {
  my $c = shift;
  my $uid = $c->session('uid') || -1;

  $c->delay(
    sub { $c->stash('conference')->has_role({id => $uid}, 'admin', shift->begin); },
    sub {
      my ($delay, $err, $has_role) = @_;
      die $err if $err;
      return $c->continue if $has_role;
      return $c->redirect_to('user.profile');
    },
  );
}

sub presentations {
  my $c = shift;

  $c->delay(
    sub { $c->stash('conference')->presentations(shift->begin); },
    sub {
      my ($delay, $err, $presentations) = @_;
      die $err if $err;
      $c->render(presentations => $presentations);
    },
  );
}

sub purchases {
  my $c = shift;

  $c->delay(
    sub { $c->stash('conference')->purchases(shift->begin); },
    sub {
      my ($delay, $err, $purchases) = @_;
      die $err if $err;
      $c->render(purchases => $purchases);
    },
  );
}

sub users {
  my $c = shift;

  $c->delay(
    sub { $c->stash('conference')->users(shift->begin); },
    sub {
      my ($delay, $err, $users) = @_;
      die $err if $err;
      $c->render(users => $users);
    },
  );
}

1;
