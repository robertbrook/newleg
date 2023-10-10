#!/usr/bin/env perl
use Modern::Perl;
use Mojolicious::Lite;

use Mojo::File;

# curl https://www.legislation.gov.uk/new/data.feed --output feed.rss

my $path = Mojo::File->new('feed.rss');
say $path->slurp;