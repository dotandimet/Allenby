package Allenby;

use strict;
use warnings;

use Mojo::Base 'Mojolicious';

use Allenby::Model::Slides;
use File::Basename qw(basename dirname);
use File::Spec;

has 'talks' => sub { {} };
has 'talk_dirs' => sub { [] };
has 'designs' => sub { {} };
has 'design_dirs' => sub { [] };

# This method will run once at server start
sub startup {
    my $self = shift;
    my $conf = $self->plugin('Config');
    if ($conf->{design_dirs}
        && ref $conf->{design_dirs} eq 'ARRAY') {
      foreach my $dir (@{$conf->{design_dirs}}) {
        push @{ $self->design_dirs }, $dir if (-d $dir);
      }
    }

    if ($conf->{talk_dirs}
        && ref $conf->{talk_dirs} eq 'ARRAY') {
      foreach my $dir (@{$conf->{talk_dirs}}) {
        push @{ $self->talk_dirs }, $dir if (-d $dir);
      }
    }

    # add designs
    for my $design_dir (@{$self->{design_dirs}}) {
      push @{$self->renderer->paths}, $design_dir;
      my @design_paths = grep { -d $_ } glob("$design_dir/*");
      my $designs = map { basename($_) } @design_paths;
      map { $self->designs->{basename($_)} = $_ } @design_paths;
      push @{$self->static->paths}, map { File::Spec->catdir($_, 'public') } @design_paths;
    }
    $self->log->debug("Designs:", $self->dumper($self->designs));
    # add talks
    $self->log->debug('loading talks from: ', $self->home, " : ", glob($self->home . '/*.md'));
   foreach my $talk (map { glob($_ . '/*.md') } @{ $self->talk_dirs } ) {
    $self->log->debug("loading $talk");
    my $name = basename($talk, '.md');
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
   my $demos_file = File::Spec->catfile(dirname($talk), 'demos.conf');
   if (-r $demos_file) {
    
  }
  }

  # Routes
  my $r = $self->routes;

  $r->route('/(#style)/')->via('get')->to('slide#shows', style => 'mine')->name('shows');
  $r->route('/(#style)/(:talk)')->to('slide#show')->name('show');
  $r->route('/')->via('post')->to('slide#choose')->name('choose');

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
