$( function(){
        $('.sorter').sortable( { stop: function(event, ui) {
                                        var new_order = $('.sorter').sortable('toArray');
                                        $.post('/slide/reorder', 
                                            { "order" : '[' + new_order.join(',') + ']' },
                                            function(data){ 
                                                var i = 1;
                                                $('.sorter li').each(function(){
                                                     $(this).attr('id', i++);
                                                });
                                            } );
                                    } } ).disableSelection();
        $('.sorter .slide').dblclick( function() {
                var id = $(this).attr('id');
                window.location = '/slide/' + id;
        } )
        .click( function() {
         $(this).addClass('selected')
         .siblings().each(function(){ $(this).removeClass('selected'); });
        });
        $('.toolbar a').hover( function(){ $(this).addClass('ui-state-hover'); },
                               function(){ $(this).removeClass('ui-state-hover'); } ); 
        if ($('.toolbar a').length > 1) {
            $(document).keyup(function(event){
                if(event.keyCode == '13') {
                   event.preventDefault();
                }
                if (event.which == '32' // space
                    || event.which == '39' // -> right arrow
                    // || event.which == '40' // Y down arrow
                    ) {
                         event.preventDefault();
                        window.location = $('a:contains(next)').attr('href');
                        return false;
                    }
                if (event.which == '37' // <- left arrow
                   // || event.which == '38' // up arrow
                    ) {
                        event.preventDefault();
                        window.location = $('a:contains(prev)').attr('href');
                        return false;
                    }
            });
        };
        if (window.Animations) {
            var $slide = $('.slide');
            var slide_label = $slide.attr('id');
            if (window.Animations[slide_label]) {
                var slide_animation = Animations[slide_label];
                $slide.click( slide_animation );
            }
        };
       $('.toolbar a:contains(copy)').click(function(event){
            event.preventDefault();
            var $selected = $('.sorter .slide.selected');
            var pos = $selected.attr('id');
            var text = $selected.html();
            $.post('/slide/add', { 'text': text, notes: '', label: '' },
            function(){ 
                alert(pos + "\n" + text);
                // $selected.clone().appendTo($selected);
            });
       });
        
});
