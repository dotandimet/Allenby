$(
    function(){
        $('.sorter').sortable();
        $('.sorter').disableSelection();
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
