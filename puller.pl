#!/usr/bin/env perl
use Mojolicious::Lite;

use Mojo::File;
use Mojo::DOM;
use Mojo::Template;

# curl https://www.legislation.gov.uk/new/data.feed --output feed.rss

my $path = Mojo::File->new('feed.rss');
my $dom  = Mojo::DOM->new( $path->slurp );

my $mt = Mojo::Template->new;
say $mt->render(<<'MAIN');
% use Time::Piece;
<div>
  % my $now = localtime;
  Time: <%= $now->hms %>
</div>
MAIN

for my $entry ( $dom->find('entry')->each ) {

    #   say $entry->at("id")->text;
    say $entry->at("link[rel='self']")->attr('href');
    say $entry->at( 'ukm|DocumentMainType',
        ukm => 'http://www.legislation.gov.uk/namespaces/metadata' )
      ->attr('Value');

    #   say $entry->at('title')->text; # check for welsh
    #   say $entry->at('summary')->text;

    if ( length $entry->at('category') ) {
        say $entry->at('category')->attr('term');
    }

    #   say $entry->at('updated')->text;
    #   say $entry->at('published')->text;
    say "";
}
