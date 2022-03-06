#!/usr/bin/perl
# code by Robert Alexander
# robert@paperhouse.io
# https://github.com/mkmothra

use strict;
use warnings;
use DBI;
use File::Basename;
use File::Path 'mkpath';
use lib dirname (__FILE__);
use Lawrence;

while (1) {

	check_queue();
	sleep(1);

}

sub check_queue {

	my $domain = 'https://lawrence.paperhouse.cc/';
	my $dbh = DBI->connect("DBI:mysql:eventbot", 'eventbot', 'C00ldr1nk!!') or die "Could not connect to database";

	my $check_queue = eval { $dbh->prepare('SELECT id, type, us_number, them_number, user, orig_url, filename FROM entries WHERE status = \'QUEUED\' ORDER BY id DESC LIMIT 1') };
		$check_queue->execute();
	my $check_queue_result = $check_queue->fetchrow_hashref;

	if (${$check_queue_result}{id}) {

		my $id = ${$check_queue_result}{id};
		my $type = ${$check_queue_result}{type};
		my $orig_url = ${$check_queue_result}{orig_url};
		my $filename = ${$check_queue_result}{filename};

		if ($type eq 'text') {

			my $us_number = ${$check_queue_result}{us_number};
			my $them_number = ${$check_queue_result}{them_number};

		      my $get_number_info = eval { $dbh->prepare('SELECT * FROM numbers WHERE number = \''.$us_number.'\'') };
		        $get_number_info->execute();
		      my $get_number_info_result = $get_number_info->fetchrow_hashref;
		        my $number_sid = ${$get_number_info_result}{number_sid};
		        my $number_account_sid = ${$get_number_info_result}{account_sid};
		        my $number_auth_token = ${$get_number_info_result}{auth_token};
		        my $number_country = ${$get_number_info_result}{country};
		        my $number_country_code = ${$get_number_info_result}{country_code};

			my $ua = LWP::UserAgent->new;
			    $ua->agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:55.0) Gecko/20100101 Firefox/55.0');
			    $ua->cookie_jar(HTTP::Cookies->new);
			    $ua->timeout(120);

			my $get_screenshot = $ua->get('https://api.apiflash.com/v1/urltoimage?access_key=24853a83b6f6480aa8f388cbbd079e9c&url='.$orig_url.'&format=png&fresh=true&full_page=true&response_type=json');
				my $get_screenshot_string = $get_screenshot->as_string;
					my ($screenshot) = ($get_screenshot_string =~ m/\{\"url\"\:\"(.*?)\"\}/);
						$ua->mirror($screenshot, 'public/'.$filename);

			my $right_now = localtime();
				my @time_parts = split(' ', $right_now);
					my $time_captured = $time_parts[3].' '.$time_parts[1].' '.$time_parts[2].', '.$time_parts[4];

			my $update_time_captured = eval { $dbh->prepare('UPDATE entries SET time_captured = \''.$time_captured.'\' WHERE id = \''.$id.'\'') };
				$update_time_captured->execute();

			Lawrence::meta_info('public/'.$filename, $orig_url, $time_captured);
			Lawrence::send_text($us_number, $them_number, $domain.$filename, $number_account_sid, $number_auth_token);
			Lawrence::update_main_log($dbh, $orig_url, $domain.$filename, $time_captured);

			my $update_queue = eval { $dbh->prepare('UPDATE entries SET status = \'PROCESSED\' WHERE id = \''.$id.'\'') };
				$update_queue->execute();

			print 'Processed '.$orig_url.' to '.$domain.$filename.' submitted via text message'."\n";

		}

		elsif (($type eq 'web') or ($type eq 'api')) {

			my $ua = LWP::UserAgent->new;
			    $ua->agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:55.0) Gecko/20100101 Firefox/55.0');
			    $ua->cookie_jar(HTTP::Cookies->new);
			    $ua->timeout(120);

			my $get_screenshot = $ua->get('https://api.apiflash.com/v1/urltoimage?access_key=24853a83b6f6480aa8f388cbbd079e9c&url='.$orig_url.'&format=png&fresh=true&full_page=true&response_type=json');
				my $get_screenshot_string = $get_screenshot->as_string;
					my ($screenshot) = ($get_screenshot_string =~ m/\{\"url\"\:\"(.*?)\"\}/);
						$ua->mirror($screenshot, 'public/'.$filename);

			my $right_now = localtime();
				my @time_parts = split(' ', $right_now);
					my $time_captured = $time_parts[3].' '.$time_parts[1].' '.$time_parts[2].', '.$time_parts[4];

			my $update_time_captured = eval { $dbh->prepare('UPDATE entries SET time_captured = \''.$time_captured.'\' WHERE id = \''.$id.'\'') };
				$update_time_captured->execute();

			Lawrence::meta_info('public/'.$filename, $orig_url, $time_captured);
			Lawrence::update_main_log($dbh, $orig_url, $domain.$filename, $time_captured);

			my $update_queue = eval { $dbh->prepare('UPDATE entries SET status = \'PROCESSED\' WHERE id = \''.$id.'\'') };
				$update_queue->execute();

			print 'Processed '.$orig_url.' to '.$domain.$filename.' submitted via web portal'."\n";

		}

	}

}


