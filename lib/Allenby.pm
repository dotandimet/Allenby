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
    
    my $rs = $r->route('/slide/:id', id => qr/(\d+)/)
               ->to(controller => 'slide', action => 'show');
    $rs->route('/')->name('show'); # default action
    # other actions
    $rs->route('/edit')->to(action => 'edit')->name('edit');
    $rs->route('/copy')->to(action => 'copy')->name('copy');
    $rs->route('/cut')->to(action => 'cut')->name('cut');
    
    # different route - no slide id required:
    $r->route('/slide/')->to('slide#sorter')->name('sorter');
    $r->route('/slide/reorder')->via('post')->to('slide#reorder')->name('reorder');
    $r->route('/slide/add')->to('slide#edit');
    $r->route('/slide/save')->to('slide#save')->name('save');

    $r->route('/')->to(cb => sub { shift->redirect_to('sorter'); });

    # Load the Model:
    my $presentation = Allenby::Model::Slides->new();
    my $path = File::Spec->catpath($self->home, 'slides.json');
    my $backuppath = File::Spec->catpath($self->home, 'slides.json.current');
    if (!-e $backuppath) {
        $presentation->load($path);
        $presentation->path($backuppath); 
    }
    else {
        $presentation->load($backuppath);
    }
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
