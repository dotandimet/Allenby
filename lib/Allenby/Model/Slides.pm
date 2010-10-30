package Allenby::Model::Slides;

package Allenby::Model::Slide;
use base 'Mojo::Base';
use warnings;
use strict;

__PACKAGE__->attr([qw(text notes label)] => sub { '' });
__PACKAGE__->attr(comments => sub { [] });
__PACKAGE__->attr(set => undef);
__PACKAGE__->attr(pos => 0);


sub hashref {
    my ($self) = @_;
    return {
        text  => $self->text,
        notes => $self->notes,
        label => $self->label
    };
}

sub next {
    my ($self) = @_;
    my $next = $self->pos + 1;
    $next = 1 if ($next > $self->set->count);
    return $next;
}

sub prev {
    my ($self) = @_;
    my $prev = $self->pos - 1;
    $prev = $self->set->count if ($prev < 1);
    return $prev;
}

sub before {
    my ($self, $before_this) = @_;
    my $set = $self->set->slides;
    my $idx = $self->pos - 1;
    splice(@$set, $idx, 1); # cut myself out
    splice(@$set, $before_this - 1, 0, $self); # stick myself in
    return $self;
}

package Allenby::Model::Slides;
use base 'Mojo::Base';
use Mojo::JSON;
use Mojo::Asset::File;
use Mojo::ByteStream 'b';
use Carp qw(croak);
use Scalar::Util qw(blessed);
__PACKAGE__->attr(slides => sub { [] });
__PACKAGE__->attr(json => sub { Mojo::JSON->new() });
__PACKAGE__->attr(path => 'slides.json');

sub load {
    my ($self, $path) = @_;
    my $str;
    $self->path($path) if (defined $path && -r $path);
    my $file = Mojo::Asset::File->new(path => $self->path);
    $str = $file->slurp;
    my $arr = $self->json->decode(b($str));
    croak "Error parsing: ", $self->json->error if ($self->json->error);
    my $pos = 1;
    foreach my $s (@$arr) {
        push @{ $self->slides }, 
            Allenby::Model::Slide->new(%$s, set => $self, pos => $pos++);
    }
    return $self;
}

sub store {
    my ($self, $path) = @_;
    $self->path($path) if (defined $path && -r $path);
    my $arr = [];
    push @$arr, $_->hashref for (@{$self->slides});
    my $str = $self->json->encode($arr);
    croak "Error writing: ", $self->json->error if ($self->json->error);
    my $file = Mojo::Asset::File->new();
    $file->add_chunk($str);
    $file->move_to($self->path);
    return $str;
}

sub first {
    my ($self) = @_;
    return $self->at(1);
}

sub last {
    my ($self) = @_;
    return $self->at($self->count);
}

sub count {
    my ($self) = @_;
    return scalar @{$self->slides};
}

sub at {
    my ($self, $pos) = @_;
    my $slides = $self->slides;
    my $i = $pos - 1; # position => index
    croak "$pos is either not a number or out of bounds" if ($i < 0 || $i > $#$slides);
    return $slides->[$i];
}

sub add {
    my ($self, @args) = @_;
    my $slide;
    my %extras = ( set => $self, pos => $self->count );
    if (ref $args[0]) {
        if (blessed($args[0]) && $args[0]->isa('Allenby::Model::Slide')) {
            $slide = $args[0];
            # add extras:
            $slide->set($self);
            $slide->pos($self->count);
        }
        if (ref $args[0] eq 'HASH') {
            $slide = Allenby::Model::Slide->new(%{$args[0]}, %extras);
        }
    }
    elsif (@args % 2 == 0) {
        $slide = Allenby::Model::Slide->new(@args, %extras);
    }
    else {
        croak "Can't add slide from @args\n";
    }
    push @{$self->slides}, $slide;
}

sub reorder {
    my ($self, $neworder) = @_;
    my $i = 1;
    my @arr = map { $self->at($_)->pos($i++) } @$neworder;
    $self->slides(\@arr);
}

1;

