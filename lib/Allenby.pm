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
    
    $r->route('/slide/:id')->to('slide#show')->name('show');
    $r->route('/slide/')->to('slide#sorter')->name('sorter');

    $r->route('/slide-reorder')->via('post')->to('slide#reorder')->name('reorder');
    $r->route('/slide/:id/edit')->to('slide#edit')->name('edit');
    $r->route('/slide-add')->to('slide#edit')->name('edit');

    $r->route('/')->to(cb => sub { shift->redirect_to('sorter'); });

    my $path = File::Spec->catpath($self->home, 'slides.json');
    my $presentation = Allenby::Model::Slides->new()->load($path);
    $presentation->path('slides.json.current'); 
    $self->defaults(show => $presentation);

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
