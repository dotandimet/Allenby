$( function(){
			window.current = 0;
			window.last = $('.slide').size();
			set_slide();
			function set_slide() {
				window.current = parseInt(document.location.hash.substr(1)) || 0;
				$('div.slide.show').removeClass('show').addClass('hide');
				$('div.slide:eq(' + window.current + ')').removeClass('hide').addClass('show');

			};
           $(document).keyup(function(event){
							console.log(event.which);
                if(event.keyCode == '13') {
                   event.preventDefault();
                }
                if (event.which == '32' // space
                    || event.which == '39' // -> right arrow
                    // || event.which == '40' // Y down arrow
                    ) {
                         event.preventDefault();
												var next = (current < last) ? current+1 : 0;												 
                       window.location = '#' + next;
											 set_slide();
                       return false;
                    }
                if (event.which == '37' // <- left arrow
                   // || event.which == '38' // up arrow
                    ) {
                        event.preventDefault();
												var prev = (current > 0) ? current-1 : last;
                        window.location = '#' + prev;
											 set_slide();
                        return false;
                    }
            });
	prettyPrint();
});
