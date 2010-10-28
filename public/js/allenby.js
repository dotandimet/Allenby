$(
    function(){
        $('.sorter').sortable( { stop: function(event, ui) {
                                        var new_order = $('.sorter').sortable('toArray');
                                        $.post('/slide-reorder', 
                                            { "order" : '[' + new_order.join(',') + ']' },
                                            function(data){ 
                                                alert(data);
                                                // reorder ids once reordered
                                                // on the server
                                                var i = 1;
                                                $('.sorter li').each(function(){
                                                     $(this).attr('id', i++);
                                                });
                                            } );
                                    } } ).disableSelection();
        $('.sorter .slide').dblclick( function() {
                var id = $(this).attr('id');
                window.location = '/slide/' + id;
        } );
        $('.toolbar a').hover( function(){ $(this).addClass('ui-state-hover'); },
                               function(){ $(this).removeClass('ui-state-hover'); } ); 
        if ($('.toolbar a').length > 1) {
            $(document).keyup(function(event){
                if(event.keyCode == '13') {
                   event.preventDefault();
                }
                if (event.which == '32' // space
                    || event.which == '39' // -> right arrow
                    || event.which == '40' // Y down arrow
                    ) {
                         event.preventDefault();
                        window.location = $('a:contains(next)').attr('href');
                        return false;
                    }
                if (event.which == '37' // <- left arrow
                    || event.which == '38' // up arrow
                    ) {
                        event.preventDefault();
                        window.location = $('a:contains(prev)').attr('href');
                        return false;
                    }
            });
        }
   }
);
