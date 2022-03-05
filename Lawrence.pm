#!/usr/bin/perl
# code by Robert Alexander
# robert@paperhouse.io
# https://github.com/mkmothra

package Lawrence;

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Cookies;
use DBI;
use Image::ExifTool;

sub gen_token {

	my @characters = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');

	my $token = $characters[rand @characters].$characters[rand @characters].$characters[rand @characters].$characters[rand @characters].$characters[rand @characters].(int(rand(9999999999))+100000);

	return ($token);

}

sub name_file {

	my @characters = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');

	my $file_name = $characters[rand @characters].$characters[rand @characters].$characters[rand @characters].$characters[rand @characters].$characters[rand @characters].(int(rand(9999999999))+100000);

	return ($file_name);

}

sub meta_info  {

	my ($file, $origin_url, $time_captured) = (shift, shift, shift);

	my $exifTool = new Image::ExifTool();
		$exifTool->SetNewValue('Description', 'Captured from '.$origin_url.' at '.$time_captured);
			my $write_info = $exifTool->WriteInfo($file);

}

sub send_text {

	my ($from_number, $to_number, $text_body, $account_id, $auth_token) = (shift, shift, shift, shift, shift);

	my $ua = LWP::UserAgent->new;
		$ua->agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:55.0) Gecko/20100101 Firefox/55.0');
		$ua->cookie_jar(HTTP::Cookies->new);
		$ua->timeout(30);

	my %text_notification = (
		From => $from_number,
		To => $to_number,
		Body => $text_body
		);

	my %credentials = (
		account_id => $account_id,
		auth_token => $auth_token
		);

	my %twilio = (
		api_domain => 'api.twilio.com:443',
		api_realm  => 'Twilio API',
		api_url=> 'https://api.twilio.com/2010-04-01/Accounts/'.$credentials{account_id}.'/Messages'
		);

	$ua->credentials($twilio{api_domain}, $twilio{api_realm}, $credentials{account_id}, $credentials{auth_token});

	my $send_text = $ua->post($twilio{api_url}, \%text_notification);

}

sub send_text_with_media {

	my ($from_number, $to_number, $text_body, $text_media, $account_id, $auth_token) = (shift, shift, shift, shift, shift, shift);

	my $ua = LWP::UserAgent->new;
		$ua->agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:55.0) Gecko/20100101 Firefox/55.0');
		$ua->cookie_jar(HTTP::Cookies->new);
		$ua->timeout(30);

	my %text_notification = (
		From => $from_number,
		To => $to_number,
		Body => $text_body,
		MediaUrl => $text_media
		);

	my %credentials = (
		account_id => $account_id,
		auth_token => $auth_token
		);

	my %twilio = (
		api_domain => 'api.twilio.com:443',
		api_realm  => 'Twilio API',
		api_url=> 'https://api.twilio.com/2010-04-01/Accounts/'.$credentials{account_id}.'/Messages'
		);

	$ua->credentials($twilio{api_domain}, $twilio{api_realm}, $credentials{account_id}, $credentials{auth_token});

	my $send_text = $ua->post($twilio{api_url}, \%text_notification);

}

sub update_main_log {

	my ($dbh, $url_captured, $image_url, $time_captured) = (shift, shift, shift, shift);

	my $ua = LWP::UserAgent->new;
	    $ua->agent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:55.0) Gecko/20100101 Firefox/55.0');
	    $ua->cookie_jar(HTTP::Cookies->new);
	    $ua->timeout(30);

	my $get_spreadsheet = $ua->get('https://docs.google.com/spreadsheets/d/1gSyECzO5QNPkwFYFUbRJkhj6WdfyF3x_SABpisXr7t0/edit');
		my $get_spreadsheet_string = $get_spreadsheet->as_string;
			my ($rev) = ($get_spreadsheet_string =~ m/\"revision\"\:(.*?)\,\"modelVersion\"/);
			my ($sid) = ($get_spreadsheet_string =~ m/\"sid\"\:\"(.*?)\"\,\"revisionhmac\"/);
			my ($token) = ($get_spreadsheet_string =~ m/token\\u003(.*?)\\u0026id/);

	my $get_last_edited_row = eval { $dbh->prepare('SELECT last_edited_row FROM spreadsheets WHERE type = \'main_log\'') };
		$get_last_edited_row->execute();
	my $get_last_edited_row_result = $get_last_edited_row->fetchrow_hashref;
		my $last_edited_row = ${$get_last_edited_row_result}{last_edited_row};
			my @last_edited_row_parts = split('\,', $last_edited_row);
				my $row_to_edit = ($last_edited_row_parts[0]+1).','.($last_edited_row_parts[1]+1);

	my $update_spreadsheet_url_captured = $ua->post(
		'https://docs.google.com/spreadsheets/u/1/d/1gSyECzO5QNPkwFYFUbRJkhj6WdfyF3x_SABpisXr7t0/save?id=1gSyECzO5QNPkwFYFUbRJkhj6WdfyF3x_SABpisXr7t0&sid='.$sid.'&vc=1&c=1&w=1&flr=0&smv=102&token='.$token.'&includes_info_params=true',
		'Host' => 'docs.google.com',
		'Accept' => '*/*',
		'Referer' => 'https://docs.google.com/spreadsheets/d/1gSyECzO5QNPkwFYFUbRJkhj6WdfyF3x_SABpisXr7t0/edit',
		'Content-Type' => 'multipart/form-data',
		'Origin' => 'https://docs.google.com',
		Content => 
		[
		'rev' => $rev,
		'bundles' => '[{"commands":[[21299578,"[[\"1655516346\",'.$row_to_edit.',0,1],[132274236,3,[2,\"'.$url_captured.'\"],null,null,0],[null,[[null,513,[0],null,null,null,null,null,null,null,null,0]]]]"],[21299578,"[[\"1655516346\",'.$row_to_edit.',1,2],[132274236,3,[2,\"'.$image_url.'\"],null,null,0],[null,[[null,513,[0],null,null,null,null,null,null,null,null,0]]]]"],[21299578,"[[\"1655516346\",'.$row_to_edit.',2,3],[132274236,3,[2,\"'.$time_captured.'\"],null,null,0],[null,[[null,513,[0],null,null,null,null,null,null,null,null,0]]]]"]],"sid":"'.$sid.'","reqId":1}]',
		]
		);

	my $update_last_edited_row = eval { $dbh->prepare('UPDATE spreadsheets SET last_edited_row = \''.$row_to_edit.'\' WHERE type = \'main_log\'') };
		$update_last_edited_row->execute();

}

1;
