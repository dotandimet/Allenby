package Allenby;

use strict;
use warnings;

use Mojo::Base 'Mojolicious';

use Allenby::Model::Slides;
use File::Basename qw(basename dirname);
use FIle::Spec;

has 'talks' => sub { {} };
has 'talk_dirs' => sub { [] };

# This method will run once at server start
sub startup {
    my $self = shift;
		my $conf = $self->plugin('Config');
		if ($conf->{talk_dirs}
				&& ref $conf->{talk_dirs} eq 'ARRAY') {
			foreach my $dir (@{$conf->{talk_dirs}}) {
				push @{ $self->talk_dirs }, $dir if (-d $dir);
			}
		}
    $self->log->debug('loading talks from: ', $self->home, " : ", glob($self->home . '/*.mkd'));
 	foreach my $talk (map { glob($_ . '/*.mkd') } @{ $self->talk_dirs } ) {
		$self->log->debug("loading $talk");
		my $name = basename($talk, '.mkd');
		$self->log->debug("talk name is $name");
		my $slideshow =
			Allenby::Model::Slides->new(path => $talk)->load();
		$self->talks->{$name} = $slideshow;
	  $self->log->debug("talk $name is called ", $slideshow->title,
		 " and has ", $slideshow->count , " slides");
		my $extras_dir = File::Spec->catdir(dirname($talk), $name);
		if (-d $extras_dir) {
			push @{$self->static->paths}, $extras_dir;
		}
	}

  # Routes
  my $r = $self->routes;

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
