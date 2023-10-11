#!/usr/bin/env perl
use Mojolicious::Lite;

use Mojo::File;
use Mojo::DOM;
use Mojo::Template;
use Path::Tiny qw(path);

# curl https://www.legislation.gov.uk/new/data.feed --output feed.rss

my $mt     = Mojo::Template->new;
my $output = $mt->render(<<'MAIN');
% my $path = Mojo::File->new('feed.rss');
% my $dom  = Mojo::DOM->new( $path->slurp );
% use Time::Piece;
<div>
  % my $now = localtime;
  Time: <%= $now->hms %>
</div>
<main>
 % for my $entry ( $dom->find('entry')->each ) {
  <article>
    SELF <%= $entry->at("link[rel='self']")->attr('href') %>
    DMT <%= $entry->at( 'ukm|DocumentMainType',
        ukm => 'http://www.legislation.gov.uk/namespaces/metadata' )
      ->attr('Value') %>
      EN TITLE <%= $entry->at('title')->text %>
      SUMMARY <%= $entry->at('summary')->text %>
      
    % if ( length $entry->at('category') ) {
        CAT <%=  $entry->at('category')->attr('term') %>
    % }
    
    UPDATED <%= $entry->at('updated')->text %>
    PUBLISHED <%= $entry->at('published')->text %>
    </article>
% }
  </main>
MAIN

path('output.html')->spew($output);

