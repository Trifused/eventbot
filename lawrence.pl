#!/usr/bin/perl
# code by Robert Alexander
# robert@paperhouse.io
# https://github.com/mkmothra

use strict;
use warnings;
use Mojolicious::Lite;
use DBI;
use IO::Socket;
use IO::Socket::SSL;
use LWP::UserAgent;
use HTTP::Cookies;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use File::Basename;
use lib dirname (__FILE__);
use Lawrence;

# --------------------------------------------------

my $dbh = DBI->connect("DBI:mysql:eventbot", 'eventbot', 'C00ldr1nk!!') or die "Could not connect to database";
my $domain = 'https://lawrence.paperhouse.cc/';

# --------------------------------------------------

get '/' => sub {

  my $self = shift;

} => 'index';

# --------------------------------------------------

get '/twilio' => sub {

  my $self = shift;
  $self->render(template => 'twilio');

} => 'twilio';

post '/twilio' => sub {

  my $self = shift;

  my $MessageSid = $self->param('MessageSid');
  my $SmsSid = $self->param('SmsSid');
  my $AccountSid = $self->param('AccountSid');
  my $MessagingServiceSid = $self->param('MessagingServiceSid');
  my $From = $self->param('From');
  my $To = $self->param('To');
  my $Body = $self->param('Body');
  my $NumMedia = $self->param('NumMedia');

  if ($Body =~ m/^http/) {

  my $us = $To;
  my $them = $From;
  my $filename = Lawrence::name_file().'.png';

  my $add_to_queue = eval { $dbh->prepare('INSERT INTO entries (type, us_number, them_number, orig_url, filename, status) VALUES (\'text\', \''.$us.'\', \''.$them.'\', \''.$Body.'\', \''.$filename.'\', \'QUEUED\')') };
    $add_to_queue->execute();

  }

  else { }

} => 'twilio';

# --------------------------------------------------

get '/login' => sub {

  my $self = shift;

  if ($self->session('loggedin')) {
    $self->redirect_to('/portal');
  }

  else {
    $self->render(template => 'login');
  }

} => 'login';

post '/login' => sub {

  my $self = shift;

  my $user = $self->param('user');
  my $pass = md5_hex($self->param('pass'));

  my $get_password = eval { $dbh->prepare('SELECT pass FROM users WHERE user = \''.$user.'\'') };
    $get_password->execute();
  my $result = $get_password->fetchrow_hashref;
  my $password = ${$result}{pass};

  if ($password eq $pass) {
    $self->session('loggedin' => $user);
    $self->redirect_to('/portal');
  }

  else {
    $self->redirect_to('/login');
  }

} => 'login';

# --------------------------------------------------

any '/logout' => sub {

  my $self = shift;

  if ($self->session('loggedin')) {

    $self->session(expires => 1);
    $self->redirect_to('/');

  }

  else {

    $self->redirect_to('/');

  }

} => 'logout';


# --------------------------------------------------

any '/portal' => sub {

  my $self = shift;

  if ($self->session('loggedin')) {

    my $error = '';
      if ($self->param('error')) {
        $error = $self->param('error');
      }

    my $success = '';
      if ($self->param('success')) {
        $success = $self->param('success');
      }

    my $get_recent_submissions = eval { $dbh->prepare('SELECT type, them_number, user, orig_url, filename, time_captured, status FROM entries ORDER BY id DESC LIMIT 25;') };
      $get_recent_submissions->execute();
    my $recent_submissions = $get_recent_submissions->fetchall_arrayref;

    $self->stash(user => $self->session('loggedin'), error => $error, success => $success, domain => $domain, recent_submissions => $recent_submissions);
    $self->render(template => 'portal');
    
  }

  else {

    $self->redirect_to('/login');

  }

} => 'portal';

# --------------------------------------------------

post '/portal/submit' => sub {

  my $self = shift;

  if ($self->session('loggedin')) {

    if ($self->param('url')) {

      my $orig_url = $self->param('url');
      my $filename = Lawrence::name_file().'.png';

    my $add_to_queue = eval { $dbh->prepare('INSERT INTO entries (type, user, orig_url, filename, status) VALUES (\'web\', \''.$self->session('loggedin').'\', \''.$orig_url.'\', \''.$filename.'\', \'QUEUED\')') };
      $add_to_queue->execute();

    $self->redirect_to('/portal?success=Url queued');

    }

    else {

      $self->redirect_to('/portal?error=No valid url');

    }

  }

  else {

    $self->redirect_to('/login');

  }

} => 'portalsubmit';

# --------------------------------------------------

get '/portal/all' => sub {

  my $self = shift;

  if ($self->session('loggedin')) {

    my $get_all_submissions = eval { $dbh->prepare('SELECT type, them_number, user, orig_url, filename, time_captured, status FROM entries ORDER BY id DESC') };
      $get_all_submissions->execute();
    my $all_submissions = $get_all_submissions->fetchall_arrayref;

    $self->stash(domain => $domain, all_submissions => $all_submissions);
    $self->render(template => 'portalall');

  }

  else {

    $self->redirect_to('/login?redirect=/portal/all');

  }

} => 'portalall';

# --------------------------------------------------

get '/portal/users' => sub {

  my $self = shift;

  if ($self->session('loggedin')) {

    my $error = $self->param('error');
    my $success = $self->param('success');

    my $get_users = eval { $dbh->prepare('SELECT id, user FROM users') };
      $get_users->execute();
    my $get_users_result = $get_users->fetchall_arrayref;

    $self->stash(get_users_result => $get_users_result, error => $error, success => $success);
    $self->render(template => 'portalusers');

  }

  else {

    $self->redirect_to('/login');

  }

} => 'portalusers';

# --------------------------------------------------

get '/portal/users/edit' => sub {

  my $self = shift;

  if ($self->session('loggedin')) {

    if (($self->param('action')) and ($self->param('id'))) {

      my $action = $self->param('action');
      my $user_id = $self->param('id');
      my $error = $self->param('error');
      my $token = '';

      my $get_user_name = eval { $dbh->prepare('SELECT user FROM users WHERE id = '.$user_id) };
        $get_user_name->execute();
      my $get_user_name_result = $get_user_name->fetchrow_hashref;
        my $user_name = ${$get_user_name_result}{user};

      if ($user_name) {

        if ($action eq 'delete') {

          my $check_for_delete_token = eval { $dbh->prepare('SELECT token FROM tokens WHERE user = \''.$self->session('loggedin').'\'') };
            $check_for_delete_token->execute;
          my $check_for_delete_token_result = $check_for_delete_token->fetchrow_hashref;

          if (${$check_for_delete_token_result}{token}) {

            my $delete_old_token = eval { $dbh->prepare('DELETE FROM tokens WHERE user = \''.$self->session('loggedin').'\'') };
              $delete_old_token->execute();

          }

          $token = Lawrence::gen_token();

          my $update_token = eval { $dbh->prepare('INSERT INTO tokens (type, user, token) VALUES (\'delete\', \''.$self->session('loggedin').'\', \''.$token.'\')') };
            $update_token->execute();

        }

        $self->stash(action => $action, user_id => $user_id, user_name => $user_name, error => $error, token => $token);
        $self->render(template => 'portalusersedit');

      }

      else {

        $self->redirect_to('/portal/users/edit?action='.$action.'&id='.$user_id);

      }

    }

    else {

      $self->redirect_to('/portal/users');

    }

  }

  else {

    $self->redirect_to('/login');

  }

} => 'portalusersedit';

post '/portal/users/edit' => sub {

  my $self = shift;

  if ($self->session('loggedin')) {

    if ($self->param('user_action')) {

      my $action = $self->param('user_action');
      my $user_id = $self->param('user_id');

      if ($action eq 'updatepw') {

        my $new_pass = md5_hex($self->param('pass'));
        my $new_pass_repeat = md5_hex($self->param('pass_repeat'));

        if ($new_pass eq $new_pass_repeat) {

          my $get_current_pass = eval { $dbh->prepare('SELECT pass FROM users WHERE id = '.$user_id) };
            $get_current_pass->execute();
          my $get_current_pass_result = $get_current_pass->fetchrow_hashref;
            my $current_pass = ${$get_current_pass_result}{pass};

          if ($new_pass ne $current_pass) {

            my $update_pass = eval { $dbh->prepare('UPDATE users SET pass = \''.$new_pass.'\' WHERE id = '.$user_id) };
              $update_pass->execute();

            $self->redirect_to('/portal/users?success=Password updated');

          }

          else {

            $self->redirect_to('/portal/users/edit?action=updatepw&id='.$user_id.'&error=Password already in use');            

          }

        }

        else {

          $self->redirect_to('/portal/users/edit?action=updatepw&id='.$user_id.'&error=Passwords do not match');

        }

      }

      elsif ($action eq 'delete') {

        my $token = $self->param('user_token');
        my $get_delete_token = eval { $dbh->prepare('SELECT token FROM tokens WHERE user = \''.$self->session('loggedin').'\'') };
          $get_delete_token->execute();
        my $get_delete_token_response = $get_delete_token->fetchrow_hashref;

        if ($token eq ${$get_delete_token_response}{token}) {

          my $delete_user = eval { $dbh->prepare('DELETE FROM users WHERE id = '.$user_id) };
            $delete_user->execute();
          my $delete_old_token = eval { $dbh->prepare('DELETE FROM tokens WHERE user = \''.$self->session('loggedin').'\'') };
            $delete_old_token->execute();

          $self->redirect_to('/portal/users?success=User deleted');

        }

        else {

          $self->redirect_to('/portal/users?error=Invalid token%2C please try again');

        }

      }

      elsif ($action eq 'add') {

        my $user_name = $self->param('user_name');
        my $pass = md5_hex($self->param('pass'));

        my $check_user_name = eval { $dbh->prepare('SELECT id FROM users WHERE user = \''.$user_name.'\'') };
          $check_user_name->execute();
        my $check_user_name_response = $check_user_name->fetchrow_hashref;

        if (!${$check_user_name_response}{id}) {

          my $add_user = eval { $dbh->prepare('INSERT INTO users (user, pass) VALUES (\''.$user_name.'\', \''.$pass.'\')') };
            $add_user->execute();

          $self->redirect_to('/portal/users?success=User added');

        }

        else {

          $self->redirect_to('/portal/users?error=Username already in use');

        }

      }

    }

    else {

      $self->redirect_to('/portal/users/edit?error=No valid action specified');

    }

  }

  else {

    $self->redirect_to('/login');

  }


} => '/portal/users/edit';


# --------------------------------------------------

post '/portal/curl' => sub {

  my $self = shift;

  if (($self->param('user')) and ($self->param('pass')) and ($self->param('url'))) {

    my $check_user = eval { $dbh->prepare('SELECT pass FROM users WHERE user = \''.$self->param('user').'\'') };
      $check_user->execute();
    my $check_user_result = $check_user->fetchrow_hashref;

    if (md5_hex($self->param('pass')) eq ${$check_user_result}{pass}) {

      if ($self->param('url') =~ m/^http/) {

        my $filename = Lawrence::name_file().'.png';

        my $add_to_queue = eval { $dbh->prepare('INSERT INTO entries (type, user, orig_url, filename, status) VALUES (\'api\', \''.$self->param('user').'\', \''.$self->param('url').'\', \''.$filename.'\', \'QUEUED\')') };
          $add_to_queue->execute();

        $self->render(text => 'STATUS: 200 SUCCESS!'."\n\n".'Stored Url:'."\n".$domain.$filename."\n");

      }

      else {

        $self->render(text => 'STATUS: ERROR!'."\n\n".'No valid url detected!'."\n");

      }

    }

    else {

      $self->render(text => 'STATUS: ERROR!'."\n\n".'Invalid login!'."\n");

    }

  }

} => 'portalcurl';

# --------------------------------------------------

app->config(
    hypnotoad => {
        listen => ['http://127.0.0.1:8031/'],
        proxy  => 1,
    },
);

app->secrets(['Paperhouse app for Lawrence from Upwork']);
app->start;

# --------------------------------------------------

__DATA__

@@ index.html.ep
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <title>Index</title>
    <link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800&#038;subset=latin,latin-ext' type='text/css' media='all'>
  </head>
  <body>
  <div class="main-content" id="main-content">
    <h1>It's working</h1>
    </div>
  </body>
</html>

