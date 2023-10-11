#!/usr/bin/env perl
use Mojolicious::Lite;

use Mojo::File;
use Mojo::DOM;
use Mojo::Template;
use Path::Tiny qw(path);

# curl https://www.legislation.gov.uk/new/data.feed --output feed.rss

my $mt     = Mojo::Template->new;
my $output = $mt->render(<<'HTML');
% my $path = Mojo::File->new('feed.rss');
% my $dom  = Mojo::DOM->new( $path->slurp );
% use Time::Piece;
<!DOCTYPE html>
<html lang="en-GB">
	<head>
		<meta name="format-detection" content="telephone=no">
		<meta name="format-detection" content="date=no">
		<meta name="viewport" content="width=device-width">
		<meta charset="UTF-8">
		<title>New legislation</title>
		<style>
			body {
				max-width: 60ch;
				padding: 1em;
				line-height: 1.4;
				font-size: 1.2em;
				margin: auto;
			}
			h1, h2 {
			font-weight:normal;
			margin-bottom:0;
			}
			article {
			padding:0.5em 0;
			}
		</style>
	</head>
<body>
<header>
  % my $now = localtime;
  Time: <%= $now->hms %>
  <h1>header</h1>
</header>
<main>
 % for my $entry ( $dom->find('entry')->each ) {
  <article>
  <p><strong><%= $entry->at('title')->text %></strong></p>
  <a href="<%= $entry->at("link[rel='self']")->attr('href') %>"><%= $entry->at("link[rel='self']")->attr('href') %></a>
    
      
    % if ( length $entry->at('summary')->text ) {
<br>
    <q><%= $entry->at('summary')->text %></q>
        % }
    
    <li>Document type: <%= $entry->at( 'ukm|DocumentMainType',
        ukm => 'http://www.legislation.gov.uk/namespaces/metadata' )
      ->attr('Value') %>
      
      
    % if ( length $entry->at('category') ) {
        <li>Category: <%=  $entry->at('category')->attr('term') %>
    % }
        <p>Published: <time class='published'><%= $entry->at('published')->text %></time></p>

    <p>Updated: <time class='updated'><%= $entry->at('updated')->text %></time></p>
    </article>
% }
  </main>
  <footer></footer>
  </body>
  </html>
HTML

path('output.html')->spew($output);

