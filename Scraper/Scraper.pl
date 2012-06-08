#!/usr/bin/perl

use utf8;
use strict;
use DBI;
use WWW::Mechanize;

my $ROOT_URL = "http://reference.roche.com:8080/";
my $GLOSSARY_URL = 'http://reference.roche.com:8080/PoolParty/wiki/SuperGlossary?URI=http%3A%2F%2Freference.roche.com%2FSuperGlossary%2FGlossaries&lang=en';

my $dbh = DBI->connect("dbi:SQLite:db.sqlite", '', '') or die 'Database connection failed.';

sub scrapeDictionaries($) {
	my ($m) = @_;
	$m->get($GLOSSARY_URL);
	my $html = $m->content;
	my $tv = 'Konzept auf oberster Ebene';
#	my $tv = 'Top Concepts';	
	$html =~ /$tv\<\/h4\>\<hr\/\>.*?\<ul\>(.*?)\<\/ul\>.*?\<\/li\>/s;
	$html = $1;
	my @matches = $html =~ /\<li class=\"propertyvalue\"\>.*?\<a href=\"(.*?)\"\>(.*?)\<\/a\>/gs;
	while (@matches) {
		my $url = shift @matches;
		$url =~ s/&amp;/&/g;
		my $text = shift @matches;
		
		my $sth = $dbh->prepare("SELECT * FROM dicts WHERE name = ?");
		$sth->bind_param(1, $text);
		$sth->execute;
		my $h = $sth->fetchall_arrayref;
		unless (@$h) {
			print "Adding dictionary '$text'...\n";
			my $sth = $dbh->prepare("INSERT INTO dicts (name, url) VALUES (?, ?)");
			$sth->bind_param(1, $text);
			$sth->bind_param(2, $ROOT_URL . $url);
			$sth->execute;
			$sth->finish;
		}
	}
}

sub scrapeCategory($$) {
	my ($m, $chs) = @_;
	$m->get($chs->{url});
	my $terms = [];
	my $tv = 'Untergeordnete Konzepte';
#	my $tv = 'Narrower Concepts';
	my $html = $m->content;
	$html =~ /$tv\<\/h4\>.*?\<hr\/\>.*?\<ul\>(.*?)\<\/ul\>.*?\<\/li\>/s;
	$html = $1;
	my @matches = $html =~ /\<a href=\"(.*?)\">(.*?)\<\/a\>/gs;
	while (@matches) {
		my $url = shift @matches;
		$url =~ s/&amp;/&/g;
		my $text = shift @matches;
		my $sth = $dbh->prepare("SELECT * FROM terms WHERE name = ? AND dict_id = ?");
		$sth->bind_param(1, $chs->{name});
		$sth->bind_param(2, $chs->{dict_id});
		$sth->execute;
		my $h = $sth->fetchall_arrayref;
		unless (@$h) {
			print "Adding term '$text'...\n";
			my $sth = $dbh->prepare("INSERT INTO terms (name, url, dict_id) VALUES (?, ?, ?)");
			$sth->bind_param(1, $text);
			$sth->bind_param(2, $ROOT_URL . $url);
			$sth->bind_param(3, $chs->{dict_id});
			$sth->execute;
			$sth->finish;
		}		
	}
}

sub scrapeDefinition($$) {
	my ($m, $ths) = @_;
	$m->get($ths->{url});
	my $html = $m->content;	
	$html =~ /Alternative Namen(.*?)\<h4/gs;
	$html = $1;
	my $def = '';	
	if ($html =~ /_display\"\>(.*?)\<\/span\>/) {
		$def = $1;
	} else {
		$html = $m->content;
		$html =~ /Definitionen(.*?)\<h4/gs;
		$html = $1;
		$html =~ /_display\"\>(.*?)\<\/span\>/;
		$def = $1;
	}
	my $sth = $dbh->prepare("SELECT * FROM defs WHERE term = ? AND dict_id = ?");
	$sth->bind_param(1, $ths->{term});
	$sth->bind_param(2, $ths->{dict_id});
	$sth->execute;
	my $h = $sth->fetchall_arrayref;
	unless (@$h) {	
		print "Adding definition for term '$ths->{term}'...\n";
		my $sth = $dbh->prepare("INSERT INTO defs (text, term, dict_id) VALUES (?, ?, ?)");
		$sth->bind_param(1, $def);
		$sth->bind_param(2, $ths->{term});
		$sth->bind_param(3, $ths->{dict_id});
		$sth->execute;
		$sth->finish;
	}
}

my $opt = $ARGV[0];
my $m = WWW::Mechanize->new(autocheck => 1);

if ($opt eq 'dicts') {
	scrapeDictionaries($m);
} elsif ($opt eq 'terms') {
	my $sth = $dbh->prepare("SELECT * FROM dicts WHERE scraped = 0");
	$sth->execute;
	my $h = $sth->fetchall_arrayref;
	$sth->finish;
	for (@$h) {
		my ($id, $name, $url, undef) = @$_;
		print "Scraping category '$name'\n";
		print "-" x 10 . "\n";
		my $csh = {
			dict_id => $id,
			name => $name,
			url => $url
		};
		scrapeCategory($m, $csh);
		$dbh->do("UPDATE dicts SET scraped = 1 WHERE id = $id");
	}
} elsif ($opt eq 'defs') {
	my $sth = $dbh->prepare("SELECT * FROM terms WHERE scraped = 0 ORDER BY random()");
	$sth->execute;
	my $h = $sth->fetchall_arrayref;
	$sth->finish;
	for (@$h) {
		my ($id, $name, $url, undef, $dict_id) = @$_;
		my $th = {
			term => $name, 
			url => $url,
			dict_id => $dict_id
		};
		scrapeDefinition($m, $th);
		$dbh->do("UPDATE terms SET scraped = 1 WHERE id = $id");
	}
} else {
	die "Unknown option!";
}

$dbh->disconnect;

