package Allenby::Model::Slides;

package Allenby::Model::Slide;
use base 'Mojo::Base';
use warnings;
use strict;

__PACKAGE__->attr([qw(text notes label)] => sub { '' });
__PACKAGE__->attr(comments => sub { [] });
__PACKAGE__->attr(set => undef);

sub add {
    my ($self, $slide) = shift;
    $self->slides
}

sub hashref {
    my ($self) = @_;
    return { text => $self->text, notes => $self->notes, label => $self->label
    };
}

package Allenby::Model::Slides;
use base 'Mojo::Base';
use Mojo::JSON;
use Carp qw(croak);
use Scalar::Util qw(blessed);
__PACKAGE__->attr(slides => sub { [] });
__PACKAGE__->attr(json => sub { Mojo::JSON->new() });

sub load {
    my ($self, $str) = @_;

    my $arr = $self->json->decode($str);
    croak "Error parsing: ", $self->json->error 
        if ($self->json->error);
    foreach my $h (@$arr) {
        my $s = Allenby::Model::Slide->new(%$h);
        push @{$self->slides}, $s;
    }
}

sub store {
    my ($self) = @_;
    my $arr = [];
    foreach my $s (@{$self->slides}) {
        push @$arr, $s->hashref;
    }
    my $str = $self->json->encode($arr);
    croak "Error writing: ", $self->json->error if ($self->json->error);
    return $str;
}

sub first {
    my ($self) = @_;
    return $self->slides->[0];
}

sub last {
    my ($self) = @_;
    return $self->slides->[-1];
}

sub count {
    my ($self) = @_;
    return scalar @{$self->slides};
}

sub at {
    my ($self, $pos) = @_;
    my $slides = $self->slides;
    my $i = $pos - 1; # position => index
    croak "$pos is either not a number or out of bounds"
        if ($i < 0 || $i > $#$slides);
    return $slides->[$i] if ($slides->[$i]);
}

sub add {
    my ($self, @args) = @_;
    my $slide;
    if (ref $args[0]) {
        if (blessed($args[0]) && $args[0]->isa('Allenby::Model::Slide')) {
            $slide = $args[0];
        }
        if (ref $args[0] eq 'HASH') {
            $slide = Allenby::Model::Slide->new(%{$args[0]});
        }
    }
    elsif (@args % 2 == 0) {
        $slide = Allenby::Model::Slide->new(@args);
    }
    else {
        croak "Can't add slide from @args\n";
    }
    push @{$self->slides}, $slide;
}

1;

