#!/usr/bin/perl

# fixes weird bug w initial logins that i'll patch soon

use strict;
use warnings;
use LWP::UserAgent;
use LWP::Protocol::https;
use HTTP::Cookies;

while (1) {
	check_login();
	sleep(300);
}

sub check_login {

	my $ua = LWP::UserAgent->new();
		$ua->agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:55.0) Gecko/20100101 Firefox/55.0');
		$ua->cookie_jar(HTTP::Cookies->new);
		$ua->timeout(10);

	$ua->get('https://lawrence.paperhouse.cc/');

	my $login = $ua->post(
		'https://lawrence.paperhouse.cc/login',
		Accept => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
		Content_Type => 'multipart/form-data',
		Content => ['user' => 'nano', 'pass' => 'Nanolawrence100!']
		);

	my $get_portal = $ua->get('https://lawrence.paperhouse.cc/portal');
		my $portal_string = $get_portal->as_string;

	if ($portal_string =~ m/Howdy\,/) {
		print 'Paperhouse login test successful'."\n";
	}

	else {
		print 'Login failure detected, restarting the Paperhouse application...'."\n";
		print `hypnotoad lawrence.pl -s`;
		print "\n";
		print 'Paperhouse turned off'."\n";
		print `hypnotoad lawrence.pl`;
		print "\n";
		print `hypnotoad lawrence.pl`;
		print "\n";
		print 'Paperhouse successfully restarted!'."\n";
	}

}



