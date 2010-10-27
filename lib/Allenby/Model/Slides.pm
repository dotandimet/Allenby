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
    return { text => $self->text, notes => $self->notes, label => $self->label
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


package Allenby::Model::Slides;
use base 'Mojo::Base';
use Mojo::JSON;
use Mojo::Asset::File;
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
    my $arr = $self->json->decode($str);
    croak "Error parsing: ", $self->json->error if ($self->json->error);
    $self->slides( $arr );
    return $self;
}

sub store {
    my ($self, $path) = @_;
    $self->path($path) if (defined $path && -r $path);
    my $str = $self->json->encode($self->slides);
    croak "Error writing: ", $self->json->error if ($self->json->error);
    my $file = Mojo::Asset::File->new();
    $file->write_chunk($str);
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
    my $h = $slides->[$i];
    return Allenby::Model::Slide->new(%$h, set => $self, pos => $pos);
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
    push @{$self->slides}, $slide->hashref;
}

1;

