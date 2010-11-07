package Allenby::Slide;
use Allenby::Model::Slides;

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub get_slide {
    my ($self) = @_;
    my $id = $self->param('id');
    return unless ($id);
    my $slide = $self->stash('show')->at($id);
    $self->stash(slide => $slide);
    return $id;
};

sub show {
    my ($self) = @_;
    $self->get_slide() || die "No slide found";
};

sub edit {
    my ($self) = @_;
    $self->stash(slide => Allenby::Model::Slide->new) unless ($self->get_slide());
};

sub save {
    my ($self) = @_;
    my $id = $self->get_slide;
    my $slide = ($id) ?  $self->stash('slide')
                      :  Allenby::Model::Slide->new();
    my ($text) = $self->param('text');
    my ($notes) = $self->param('notes');
    my ($label) = $self->param('label');
    $slide->text($text);
    $slide->notes($notes);
    $slide->label($label);
    if (!$id) {
         $id = $self->stash('show')->add($slide);
    }
    $self->stash('show')->store();
    $self->redirect_to('show', id => $id);
};

sub reorder {
    my ($self) = shift;
    my $order = $self->param('order');
    $order = Mojo::JSON->decode($order);
    $self->stash('show')->reorder($order);
    my @new = map { $_->pos } @{$self->stash('show')->slides};
    $self->stash('show')->store();
    $self->render(json => { success => 1 , order => \@new });
};





1;
