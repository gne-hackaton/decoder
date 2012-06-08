#!/usr/bin/perl

use strict;
use JSON;
use utf8;
use DBI;
use Redis;

my $redis = Redis->new(server => '10-36-209-202.wifi.gene.com:6379') or die 'Redis connection failed!';
my $dbh = DBI->connect("dbi:SQLite:db.sqlite", "", "") or die 'Database connection failed!';

my $sth = $dbh->prepare("SELECT * FROM dicts");
$sth->execute;
my $dicts = $sth->fetchall_hashref('id');

$sth = $dbh->prepare("SELECT * FROM terms");
$sth->execute;
my $terms = $sth->fetchall_arrayref;
for my $term (@$terms) {
	my ($id, $name, undef, undef, $dict_id) = @$term;
	my $values = [];
	$sth = $dbh->prepare("SELECT * FROM defs WHERE term = ?");
	$sth->bind_param(1, $name);
	$sth->execute;
	my $defs = $sth->fetchall_arrayref;
	for my $def (@$defs) {
		my (undef, $text, undef, $dict_id) = @$def;
		my $v = { 
			def => $text,
			name => $name,
			dict => $$dicts{$dict_id}{name}
		};
		push @$values, $v;
	}
	my $json = encode_json $values;
	$json =~ s/[\[\]]//g;
	print "$name => " . $json;
	print "\n\n";
	$redis->set($name => $json)
}

$dbh->disconnect;

