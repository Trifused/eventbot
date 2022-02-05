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

      my $get_number_info = eval { $dbh->prepare('SELECT * FROM numbers WHERE number = \''.$us.'\'') };
        $get_number_info->execute();
      my $result = $get_number_info->fetchrow_hashref;
        my $number = ${$result}{number};
        my $number_sid = ${$result}{number_sid};
        my $number_account_sid = ${$result}{account_sid};
        my $number_auth_token = ${$result}{auth_token};
        my $number_country = ${$result}{country};
        my $number_country_code = ${$result}{country_code};

	my $ua = LWP::UserAgent->new;
	    $ua->agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:55.0) Gecko/20100101 Firefox/55.0');
	    $ua->cookie_jar(HTTP::Cookies->new);
	    $ua->timeout(120);

	my $get_screenshot = $ua->get('https://api.apiflash.com/v1/urltoimage?access_key=24853a83b6f6480aa8f388cbbd079e9c&url='.$Body.'&format=png&fresh=true&full_page=true&response_type=json');
		my $get_screenshot_string = $get_screenshot->as_string;
			my ($screenshot) = ($get_screenshot_string =~ m/\{\"url\"\:\"(.*?)\"\}/);
			my $file_name = Lawrence::name_file().'.png';
				$ua->mirror($screenshot, 'public/'.$file_name);

	Lawrence::meta_info('public/'.$file_name, $Body);
	Lawrence::send_text($us, $them, $domain.$file_name, $number_account_sid, $number_auth_token);
	Lawrence::update_main_log($dbh, $Body, $domain.$file_name);

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

any '/portal' => sub {

  my $self = shift;

  if ($self->session('loggedin')) {

    $self->stash(user => $self->session('loggedin'));
    $self->render(template => 'portal');
    
  }

  else {
    $self->redirect_to('/login');
  }

} => 'portal';

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

