package Allenby;

use strict;
use warnings;

use Mojo::Base 'Mojolicious';

use Allenby::Model::Slides;
use Mojo::File qw(path);
use Mojo::Util qw(encode);

has 'talks' => sub { {} };
has 'talk_dirs' => sub { [] };
has 'designs' => sub { {} };
has 'design_dirs' => sub { [] };

# This method will run once at server start
sub startup {
    my $self = shift;
    my $conf = $self->plugin('Config');
    $self->commands->namespaces([ 'Allenby::Command', 'Mojolicious::Command' ]);
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
      my @design_paths = path("$design_dir")->list({ dir => 1 })->grep(sub { -d $_ } )->each();
      map { $self->designs->{$_->basename()} = $_ } @design_paths;
      push @{$self->static->paths}, map { File::Spec->catdir($_, 'public') } @design_paths;
    }
    #$self->log->debug("Designs:", $self->dumper($self->designs));
    # add talks
    #$self->log->debug('loading talks from: ', $self->home, " : ", glob($self->home . '/*.md'));
   foreach my $talk (map { path($_) } map { glob($_ . '/*.md') } @{ $self->talk_dirs } ) {
    #$self->log->debug("loading $talk");
    my $name = $talk->basename('.md');
    #$self->log->debug("talk name is $name");
    my $slideshow =
      Allenby::Model::Slides->new(path => $talk->to_string());
    $self->talks->{$name} = $slideshow;
    #$self->log->debug("talk $name is called ", $slideshow->title,
    # " and has ", $slideshow->count , " slides");
    my $extras_dir = $talk->dirname()->child($name);
    if (-d $extras_dir) {
      push @{$self->static->paths}, $extras_dir;
    }
   my $demos_file = $talk->dirname()->child('demos.conf');
   if (-r $demos_file) {
    
  }
  }

  # Routes
  my $r = $self->routes;

  $r->get('/')->to('slide#shows', style => 'mine')->name('shows');
  $r->any('/<:talk>')->to('slide#show')->name('show');
  $r->post('/')->to('slide#choose')->name('choose');

    $self->helper( button => sub {
        my $c = shift;
        my ($text, $href) = @_;
        my @classes = qw(ui-button ui-widget
            ui-state-default ui-corner-all
           ui-button-text-only);
        qq{<a href="$href" role="button" class="@classes">}
        . qq{<span class="ui-button-text">$text</span></a>};
    } );

#   $self->hook(after_render => sub {
#     my ($c, $output, $format) = @_;
#       if ($format eq 'html') {
#         $$output = encode 'UTF-8', Mojo::DOM->new($$output)->at('body')->prepend('<div><h1>CONTROL</h1></div>')->root->to_string;
#       }
#       });

}

1;
