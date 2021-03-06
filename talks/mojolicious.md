# Mojolicious
## Duct Tape for the HTML5 Web

Dotan Dimet 

`dotan@corky.net`
`dotan@evogene.com`

***
# Duct Tape
* The Internet is a series of tubes
* ... stuck together with perl
![](/maruitzio-cattelan-duct-tape.jpg)

***

* browser and server talk in HTTP
* browser renders text (HTML) into page/form UI
***

### HTTP

* TCP/IP
* Text-based
* Stateless
* Connect, Request, Response, Close
* Request is one of GET, POST (PUT, DELETE).
* Your script eats (input) shoots (output) and leaves (exit)
***

### HTML

* links, forms
* images, tables
* it's all text
* a page is a collection of links

#### HTML 4

* Javascript  DOM  CSS  XMLHTTPRequest (AJAX)

#### HTML 5

* New form elements, CSS transitions and animations
* Canvas! SVG! Video! Audio! Offline!
* Websockets! (\*)
***

### Perl Has the Tools
* CGI 
* LWP (web client)
### But they are old and crufty


***

### Mojolicious

* A web application framework
* Created by Sebastian Reidel (He did it before)
* No dependencies beyond core modules
* Easy to install and to port
* Potentially targeting PHP developers and Perl6

***

* built on top of Mojo
* Mojo includes all the goodies needed to build a web framework
* such as an async HTTP 1.1 compliant stack 
* RFC driven development
* Test driven development
* Its own web server, client, cookies, url objects, file handling...

***

* The framework takes away the hard and boring parts of the task
* What's the difference between a framework and a library?
***

### A framework provides _structure_
* external structure - the API or UI I expose to the world
* Internal structure - how I structure my code
***

### External Structure - the URL

#### Square:

    myapp.cgi?foo=baz&bar=42

Same as 

    myapp.cgi?bar=42&foo=baz

#### Cool:

    /myapp/bar/42

Distinct from

    /myapp/42/bar



***
Sample Mojolicious(::Lite) app

    mojo generate lite_app myapp

    #!/usr/bin/env perl
    
    use Mojolicious::Lite;
   
    get '/' => 'index';
    
    get '/:groovy' => sub {
        my $self = shift;
        $self->render(text => $self->param('groovy'), layout => 'funky');
    };
    
    app->start;
    __DATA__
    
    @@ index.html.ep
    % layout 'funky';
    Yea baby!
    
    @@ layouts/funky.html.ep
    <!doctype html><html>
        <head><title>Funky!</title></head>
        <body><%== content %></body>
    </html>

***

Sample Mojolicious(::Lite) app

* Has 2 entry points:
* GET `/`
* GET `/anythingelse`
* Default action: render a template (output a page)
* Call render() explicitly to render something else
* `'/:groovy'` => a capture; anything except / or . and is available as a param and in the stash (global hash).
***
### Dispatching and Routes
* Dispatching = what code to run when.
* Mojolicious dispatches via **routes**
* What to do when a given URL is asked for.
* Usually the answer is: run this method (_action_) of that class
* (_controller_) and render this template.
***
### Routes
Default route for a mojolicious (not lite) application:
    sub startup {
     my $self = shift;
 
     # Routes
     my $r = $self->routes;

     # Default route
     $r->route('/:controller/:action/:id')->to('example#welcome', id => 1);
    }
`example#welcome` is short for:
    ->to(controller => 'example', action => 'welcome');

Could well be the only route you need.

***
### DIY Routes

You can explicitly set all your routes:

    $r->route('/slide/')->to('slide#sorter')->name('sorter');

    $r->route('/slide/reorder')->via('post')->to('slide#reorder')->name('reorder');
    $r->route('/slide/add')->to('slide#edit');
    $r->route('/slide/save')->to('slide#save')->name('save');

    $r->route('/')->to(cb => sub { shift->redirect_to('sorter'); });

***
### Waypoints
The action specified by a route is referred to as an endpoint.
You can also set up branching routes using `waypoint`.

     my $rs = $r->waypoint('/slide/:id', id => qr/(\d+)/)
               ->to(controller => 'slide', action => 'show')
               ->name('show');
    $rs->route('/edit')->to(action => 'edit')->name('edit');
    $rs->route('/copy')->to(action => 'copy')->name('copy');
    $rs->route('/cut')->to(action => 'cut')->name('cut');

These match 

   /slide/3      : controller => slide, action => show, id => 3
   /slide/3/edit : controller => slide, action => edit, id => 3
   /slide/3/copy : controller => slide, action => copy, id => 3

There are also bridges - code that will execute (and which must return true)
before dispatching further (useful for authentication).

***

I'll talk about rendering and templates in a bit, but first

    $self->render(...)

Who is this `$self` you refer to?
***

* A Mojolicious application has a single **application** class, a subclass of `Mojolicious`
* Mojolicious::Lite helpfully lets you access it through the `app()` function it imports.

    app->start(); # formerly, this was called shagadelic...

* A Mojolicious application can have many **controller** classes
* which are all subclasses of `Mojolicious::Controller`.
* The `$self` in `$self->render(...)` is a Mojolicious::Controller.
***

***
# Controller stuff:
* Mojo::Transaction object containing Request and Response objects - representing the message received and the message being sent in response:

    my $params = $self->tx->req->params->to_hash;
    # can also do $self->req->... directly

* Stash object - global hash, used to pass values to templates

    my $arg = $self->stash('foo');
    $self->stash('color' => 'green');

*** param() method - shortcut to get params
# Template Rendering

Template is either named explicitly in the route, or explicitly passed as a
parameter to the render() call, or is derived from controller and action
names.

Format is either argument or in file name

***

Dispatching:
***

    // myapp.cgi
    use CGI;
    my $req = CGI->new;
    if ($req->param('foo') eq 'baz') {
        my ($id) = $req->param('bar');
        doBaz($id);
    }
    elsif ($req->param('foo') eq 'burt') {
    ...
***

My first vim power tip: %
(bracket bouncing through the spaghetti code)
***

Rendering:
***

Mojolicious
New Web Framework from Sebastian Reidel
* Sebastian was the chief maintainer of Maypole (Class::DBI+Template-Toolkit+mod_perl)
* Wanted to make radical changes
* => Got booted
* Started [Catalyst](http://www.catalystframework.org/)
* Wanted to make radical changes
* => Got booted
* Went to work on other things
worked with [Ruby on Rails](http://rubyonrails.org)
* => Brought back Mojolicious
***

Originally called Mojo
Mojo is the foundation of Mojolicious
Mojo is a complete HTTP 1.1 Implementation
RFC driven development
Test driven development
***

Mojolicious is super focused
What it is concerned with is what to do when a given URL is asked for
Usually the answer is: run this method of that class and render this template.
***

Dotan Dimet

דותן דימט

Programming Perl for 10 years

*Christ. That's long.*
***

Caveats
***

![Romantically Apocalyptic](/blastwave1.jpg)



[yko: *Sometimes sri reminds me captain from Romantically Apocalyptic*](http://irclog.perlgeek.de/mojo/2010-07-14#i_2552055)
***

![part 2](/blastwave2.jpg)
***

