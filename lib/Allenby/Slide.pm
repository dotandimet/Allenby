package Allenby::Slide;
use Allenby::Model::Slides;

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub shows {
  my ($self) = @_;
  my $slide = $self->render(
      'shows' => {
          map { $_ => $self->app->talks->{$_}->title }
            keys %{$self->app->talks}
      },
      'designs' => [keys $self->app->designs],
      template => 'slide/shows', partial => 1
  );
  my $show = [ $slide ];
  my $style = $self->stash('style') || 'mine';
  my $template = "$style/main";
  $self->render(template => $template, show => $show);
}

sub show {
  my ($self) = @_;
  my ($talk) = $self->stash('talk');
  my $show = $self->app->talks->{$talk}->slides;
  my $style = $self->stash('style') || 'mine';
  my $template = "$style/main";
  $self->render(template => $template, show => $show);
}

sub choose {
  my ($self) = @_;
  my $talk = $self->param('talk');
  my $style = $self->param('style');
  $self->redirect_to('show', talk => $talk, style => $style);
}


1;
