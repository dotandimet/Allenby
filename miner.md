# Miner
## Miner framework as a replacement for CGI

* * *
## Class File 

### lib/Miner/MyPage.pm


    package Miner::MyPage;
    use base 'Miner::Base';
    sub say_hello { return "Hello"; }
    1;

* * *
## Template File 

### lib/Miner/MyPage.tt

    [% self.say_hello() %]

* * *
## URL

Your new page should be accessible at the URL 

    cgi/miner.fcgi?_state=MyPage

you can add that link to other templates or to the common page wrapper.

* * *

## Multiple pages from the same class
# _action


action method dispatch

You can use the same class to deliver multiple pages - the parameter **_action** will be used to determine which method of your class will be triggered:

* * *

## Class File 

    # lib/Miner/MyPages.pm

    package Miner::MyPages;
    use base 'Miner::Base';

    my $answer;
    sub say_something { return $answer; }
    sub say_hello { $answer = "Hello"; }
    sub say_goodbye { $answer = "Goodbye"; }

    1;

* * *

## Template File

     #lib/Miner/MyPages.tt
     [% self.say_something() %]


* * *
## URLs

     cgi/miner.fcgi?_state=MyPages&_action=say_hello -- displays "Hello"
     cgi/miner.fcgi?_state=MyPages&_action=say_goodbye -- displays "Goodbye"

