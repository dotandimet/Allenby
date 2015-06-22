package Allenby::Command::export;
use Mojo::Base 'Mojolicious::Command';
use Getopt::Long qw(GetOptionsFromArray);
use Mojo::Util qw(tablify md5_sum);
use Mojo::Path;

# Short description
has description => 'Export slideshow HTML and dependencies';

# Short usage message
has usage => <<EOF;
Usage: APPLICATION export [OPTIONS]

Options:
-s, --show  name of slideshow
-d, --design name of theme
-l, --list  list available slideshows
EOF

sub run {
  my ($self, @args) = @_;
  my ($show, $list) = (undef, undef);
  my $design = 'deck.js';
  GetOptionsFromArray(\@args,
        "show=s" => \$show,
        "design=s" => \$design,
        "list"   => \$list)
  or die $self->usage();

  if ($list) {
    print tablify [
          map { [ $_ => $self->app->talks->{$_}->title ] }
            keys %{$self->app->talks}
          ];
  }
  elsif ($show) {
    if ($self->app->talks->{$show}) {
      print "Exporting talk $show\n";
      my $url = $self->app->url_for('choose');
      print $url;
      my $tx = $self->app->ua->max_redirects(3)->post($url, form => { talk => $show, style => $design });
      my $real_url = $tx->req->url;
      my $page = $tx->res->body;
      print "URL: $real_url\n";
      print "$page\n";
      my $styles = $tx->res->dom->find('link[rel=stylesheet]')->map('attr', 'href');
      my $scripts = $tx->res->dom->find('script')->map('attr', 'src')->grep(sub { defined $_ }); # some script tags have no source
      my $images = $tx->res->dom->find('img')->map('attr', 'src');
      print "Styles:\n";
      print map { "\t$_\n" } @$styles;
      print "Scripts:\n";
      print map { "\t$_\n" } @$scripts;
      print "Images:\n";
      print map { "\t$_\n" } @$images;
      $self->create_rel_dir('exports') unless (-d './exports');
      my $version = md5_sum $page;
      $self->write_rel_file("exports/$version/index.html", $page);
      foreach my $path ($styles->each, $scripts->each, $images->each) {
        my $url = $real_url->clone;
        $url->path->merge($path);
        print "Path: $path $url\n";
        $self->write_rel_file("exports/$version/$path",
        $self->app->ua->get($url)->res->body ) if ($path);
      }
      print "Done - check exports/$version for the show\n";
      }
  }
  else {
    die $self->usage();
  }
};

1;
