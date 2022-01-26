code by Robert Alexander
	robert@paperhouse.io
	https://github.com/rta10

This application provides a web-based Twilio bridge for sending and receiving texts messages. When a message containing a valid url is sent to the application, it will capture a screenshot of that page, save the screenshot locally, add the source url and time captured to the description metadata of the image, reply to the original sender with a link to the image, and save the url captured, image link, and time captured to a Google Sheets document (https://docs.google.com/spreadsheets/d/1gSyECzO5QNPkwFYFUbRJkhj6WdfyF3x_SABpisXr7t0/edit#gid=1655516346). Perl and MySQL are required.

To start this application, navigate to its directory, and run
	screen perl run.pl

To stop this application, navigate to its directory, terimate any instances of run.pl, and run
	hypnotoad lawrence.pl -s

This application is written in perl, and requries the folllowing modules:
	Mojolicious
		sudo apt-get install libmojolicious-perl
	DBI
		sudo apt-get install libdbi-perl
	LWP::UserAgent & HTTP::Cookies
		sudo apt-get install libwww-perl
	Digest::MD5
		sudo apt-get install libdigest-md5-perl
	File::Basename
		This should come by default with most perl installations, let me know if anything comes up here
	Image::ExifTool
		sudo apt-get install libexiftool-perl
	Lawrence
		Included with this file

This application also requires apache2, and a valid url and ssl certificate configured according to the example files in apache2_examples/
The headers, proxy, and proxy_http apache2 mods must be enabled.


