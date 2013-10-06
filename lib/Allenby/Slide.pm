package Allenby::Slide;
use Allenby::Model::Slides;

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub shows {
	my ($self) = @_;
	$self->render('shows' => [ keys %{$self->app->talks} ]);
}

sub show {
	my ($self) = @_;
	my ($talk) = $self->stash('talk');
	my $style = $self->stash('style') || 'my';
	my $show = $self->app->talks->{$talk}->slides; 
  my $template =
    ($style eq 'dz')     ? 'slide/dzslides'
    : ($style eq 'reveal') ? 'slide/reveal'
    :                        'slide/show';
	$self->render(template => $template, show => $show);
}

1;
