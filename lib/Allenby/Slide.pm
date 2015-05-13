package Allenby::Slide;
use Allenby::Model::Slides;

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub shows {
  my ($self) = @_;
  my $slide = $self->render_to_string(
      'shows' => {
          map { $_ => $self->app->talks->{$_}->title }
            keys %{$self->app->talks}
      },
      'designs' => [keys %{$self->app->designs}],
      template => 'slide/shows'
  );
  my $show = [ $slide ];
  my $style = $self->session('style') || $self->stash('style') || 'mine';
  my $template = "$style/main";
  $self->render(template => "mine/main", show => $show, title => 'slide listing');
}

sub show {
  my ($self) = @_;
  my ($talk) = $self->stash('talk');
  my $show = $self->app->talks->{$talk}->slides;
  my $style = $self->session('style') || $self->stash('style') || 'mine';
  my $template = "$style/main";
  $self->render(template => $template, show => $show, title => $self->app->talks->{$talk}->title);
}

sub choose {
  my ($self) = @_;
  my $talk = $self->param('talk');
  my $style = $self->param('style');
  $self->session(style => $style);
  $self->redirect_to('show', talk => $talk);
}


1;
