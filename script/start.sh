#!/bin/sh
cd /home/dotan/code/allenby || cd /home/yp/dotan/code/Allenby
# load:
perl -Ilib -MAllenby::Model::Slides -le 'Allenby::Model::Slides->new->load_showmetheslides(q{talk.txt})->path(q{slides.json.current})->store;'
# run:
script/allenby daemon
# save:
perl -Ilib -MAllenby::Model::Slides -le 'Allenby::Model::Slides->new->load(q{slides.json.current})->write_showmetheslides(q{talk.txt});'
