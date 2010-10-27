package Allenby;

use strict;
use warnings;

use base 'Mojolicious';
use Allenby::Model::Slides;

# This method will run once at server start
sub startup {
    my $self = shift;

    # Routes
    my $r = $self->routes;

    # Default route
    $r->route('/:controller/:action/:id')->to('example#welcome', id => 1);

    my $path = File::Spec->catpath($self->home, 'slides.json');
    $self->defaults(show => Allenby::Model::Slides->new()->load($path));

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
