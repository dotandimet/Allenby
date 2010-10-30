package Allenby::Slide;
use Allenby::Model::Slides;

use strict;
use warnings;

use base 'Mojolicious::Controller';
# This action will render a template
sub show {
    my ($self) = @_;
    my $id = $self->param('id') || 1;
    my $slide = $self->stash('show')->at($id);
    $self->stash(slide => $slide);
};

sub edit {
    my ($self) = @_;
    my ($id, $slide);
    if ($self->param('id')) {
        $id = $self->param('id');
        $slide = $self->stash('show')->at($id);
    }
    else {
        $slide = Allenby::Model::Slide->new();
    }
    if (lc $self->req->method() eq 'post') {
        my ($text) = $self->param('text');
        my ($notes) = $self->param('notes');
        my ($label) = $self->param('label');
        $slide->text($text);
        $slide->notes($notes);
        $slide->label($label);
        if (!$id) {
            $self->stash('show')->add($slide);
        }
        $self->stash('show')->store();
        $self->redirect_to('show', id => $id);
    }
    $self->stash(slide => $slide);

};

sub reorder {
    my ($self) = shift;
    my $order = $self->param('order');
    $order = Mojo::JSON->decode($order);
    $self->stash('show')->reorder($order);
    my @new = map { $_->pos } @{$self->stash('show')->slides};
    $self->stash('show')->store();
    $self->render(json => { success => 1 , order => \@new });
}

1;
