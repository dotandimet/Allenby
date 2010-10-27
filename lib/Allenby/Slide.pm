package Allenby::Slide;
use Allenby::Model::Slides;

use strict;
use warnings;

use base 'Mojolicious::Controller';
# This action will render a template
sub show {
    my ($self) = @_;
    my $id = $self->param('id');
    my $slide = $self->stash('show')->at($id);
    $self->stash(slide => $slide);
};

sub edit {
    my ($self) = @_;
    my $id = $self->param('id');
    my $slide = $self->stash('show')->at($id);
    $self->stash(slide => $slide);
}

1;
