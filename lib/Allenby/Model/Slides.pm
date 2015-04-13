package Allenby::Model::Slides;

use warnings;
use strict;

use Text::Markdown 'markdown';
use Mojo::Util qw(slurp decode);

use Mojo::Base '-base';

has 'path';

has text => sub {
  my $self = shift;
  return decode('UTF-8', slurp($self->path));
};

has slides => sub {
  my $self = shift;
  my $html  = markdown $self->text; # text
  my $dom  = Mojo::DOM->new("$html");
    # Rewrite code blocks for syntax highlighting
    $dom->find('pre code')->each(
      sub {
        my $e = shift;
        return if $e->all_text =~ /^\s*\$\s+/m;
        my $attrs = $e->attr;
        my $class = $attrs->{class};
        $attrs->{class} = defined $class ? "$class prettyprint" : 'prettyprint';
      }
    );
  my @slides = split(/\<hr\s*\/*\>/, "$dom");
  return \@slides;
};

has title => sub {
  my $self = shift;
  return (Mojo::DOM->new($self->slides()->[0])->all_text);
};

sub count {
  scalar @{shift->slides};
}

1;
