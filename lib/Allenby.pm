package Allenby;

use strict;
use warnings;

use Mojo::Base 'Mojolicious';

use Allenby::Model::Slides;
use File::Basename;

has 'talks' => sub { {} };

# This method will run once at server start
sub startup {
    my $self = shift;

    # Routes
    my $r = $self->routes;
    $self->log->debug('loading talks from: ', $self->home, " : ", glob($self->home . '/*.mkd'));
 	foreach my $talk (glob($self->home . '/*.mkd')) {
		$self->log->debug("loading $talk");
		my $name = basename($talk, '.mkd');
		$self->log->debug("talk name is $name");
		$self->talks->{$name} =
			Allenby::Model::Slides->new(path => $talk)->load();
	}
	
	$r->route('/')->to('slide#shows')->name('shows');
	$r->route('/show/(:talk)/(:style)')->to('slide#show')->name('show');

    $self->helper( button => sub { 
        my $c = shift;
        my ($text, $href) = @_;
        my @classes = qw(ui-button ui-widget
            ui-state-default ui-corner-all
           ui-button-text-only);
        qq{<a href="$href" role="button" class="@classes">}
        . qq{<span class="ui-button-text">$text</span></a>};
    } );
}

1;
