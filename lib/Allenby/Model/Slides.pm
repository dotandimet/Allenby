package Allenby::Model::Slides;

use warnings;
use strict;

use Mojo::Base '-base';

use Text::Markdown 'markdown';

has ['path', 'text', 'slides']; 

sub load {
	my $self = shift;
	my $path = ($_[1]) ? shift : $self->path;
  if (defined $path && -r $path) {
		open my $file, "<:encoding(UTF-8)", $path
      or die "Can't read slides from path: $!";
    my $slurp = do { local $/; <$file> };
		$self->text($slurp);
		my $html	= markdown $self->text;
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
		my @slides = split(/\<hr\s*\/\>/, "$dom");
		$self->slides(\@slides);
  }
}

1;

