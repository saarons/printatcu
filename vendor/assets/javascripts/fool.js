/**
 *   Fool.js (by @idiot)
 *   I pity the user.
 */
 
(function($) {

  $.fn.prefixCSS = function(prop, val) {
    var prefixes = ['Webkit', 'Moz', 'Ms', 'O'],
      obj = {};
    
    for(var i in prefixes) {
      obj[prefixes[i] + (prop.charAt(0).toUpperCase() + prop.substr(1))] = val;
    }
    
    return this.css(obj);
  };
  
  //  Don't be a dick.
  $.fool = function(options) {
    var iframe = '<iframe width="560" height="315" src="https://www.youtube.com/embed/*?fs=1&autoplay=1&loop=1" style="position: absolute; left: -999em; top: -999em; visibility: hidden; -webkit-user-select: none; -webkit-user-drag: none;" frameborder="0" allowfullscreen></iframe>',
    
      //  Our good king, Rick Astley
      rick = 'oHg5SJYRHA0',
      
      //  A list of the annoying videos
      videos = ['DksSPZTZES0', 'gRNgPBh54pU', 'AOAtz8xWM0w', 'bHzHlSLhtmM'],
      
      //  Baby, let's make our move
      moves = {
      
        //  Show a random youtube video and hide it
        hiddenVideos: function(url) {
          //  Grab a random video
          var video = url ? url : videos[Math.round((Math.random() * (videos.length - 1)))];
          
          return this.append(iframe.replace('*', video));
        },
        
        //  I've dropped a lot of pranks, but I'm never going to give you up.
        rick: function() {
          return moves.hiddenVideos.call(body, rick);
        },
        
        //  Hide random elements on hover
        vanishingElements: function() {
          return $('h1,h2,h3,p,div:not(.timber),input,header,footer,section').hover(function() {
            if(Math.random() > .75) {
              $(this).css('opacity', $(this).css('opacity') == 0 ? 1 : 0);
            }
          });
        },
        
        fallingScrollbar: function() {
        
          $('.timber').fadeOut(200, function() {
            $(this).remove();
          });
        
          var h = $(window).height() + 30,
            html = '<div class="timber" style="-webkit-transform-origin:50% 100%;-moz-transform-origin:50% 100%;-ms-transform-origin:50% 100%;-o-transform-origin:50% 100%;transform-origin:50% 100%;-webkit-transition:-webkit-transform .8s;-moz-transition:-moz-transform .8s;-ms-transition:-ms-transform .8s;-o-transition:-o-transform .8s;transition:transform .8s;position:fixed;right:0;bottom:0;overflow:scroll;width:14px;height:' + h + 'px">' + new Array(80).join('<br>') + '</div>',
            
            me = this.css('overflow', 'hidden').append(html),
            rot = 'rotate(-100deg)';
          
          setTimeout(function() {
            me.children('.timber').prefixCSS('transition', '.8s').css({
              right: -23,
              bottom: 7,
            });
          }, 250);
        },
        
        questionTime: function() {
          var q = ['Are ya ready, kids?', 'I can\'t hear ya!', 'Ohhhhh, who lives in a pineapple under the sea?', 'Absorbent and yellow and pourous is he', 'If nautical nonsense be somethin\' ya wish.', 'Then drop on the deck and flop like a fish.'],
            a = 'Spongebob Squarepants. Spongebob Squarepants.';
            
          for(var i in q) {
            window.prompt(q[i]);
          }
          
          for(var t = 0; t < 4; t++) {
            alert(a);
          }
        },
        
        //  I can hack a site!
        h4xx0r: function() {
          this[0].contentEditable = true;
          return document.designMode = 'on';
        },
        
        //  This probably won't work with the falling scrollbar.
        upsideDown: function() {
          body.attr('style', '-webkit-transform: rotate(180deg); -moz-transform: rotate(180deg); -ms-transform: rotate(180deg); -o-transform: rotate(180deg); transform: rotate(180deg); filter: progid:DXImageTransform.Microsoft.Matrix(M11=-1, M12=-1.2246063538223773e-16, M21=1.2246063538223773e-16, M22=-1, sizingMethod=\'auto expand\'); zoom: 1;');
        },
        
        //  A bit crooked, but a lot of fun
        wonky: function() {
          body.attr('style', '-webkit-transform: rotate(-.7deg);-moz-transform: rotate(-.7deg); -ms-transform:rotate(-.7deg); -o-transform:rotate(-.7deg); transform: rotate(-.7deg); filter: progid:DXImageTransform.Microsoft.Matrix(M11=0.999925369660452,M12=0.012217000835247169,M21=-0.012217000835247169,M22=0.999925369660452,sizingMethod=\'auto expand\'); zoom: 1;');
        },
        
        //  flashes the screen on and off
        flash: function() {
          var fade = function() {
              body.delay(250).animate({opacity: 0}, 1).delay(250).animate({opacity: 1}, 1, fade);
            };
            
          fade();
        },
        
        //  might not work
        crashAndBurn: function() {
          for(i = 0; i <= 0e10; i++) {
            $.fool('crashAndBurn');
          }
        },
        
        //  make a shutter descend unto the screen
        shutter: function() {
          var shutter = body.append('<div id="shutter" />').children('#shutter');
          
          shutter.css({
            position: 'fixed',
            left: 0,
            top: 0,
            right: 0,
            bottom: '100%',
            
            background: '#000'
          }).animate({
            bottom: 0
          }, 500);
        },
        
        //  simple
        unclickable: function() {
          //  twitter.com/#!/idiot/status/180261881460690945
          body.attr('style', 'pointer-events: none; -webkit-user-select: none; -moz-user-select: none; cursor: wait;');
        }
      },
      
      body = $('body');
    
    //  Check we've got options 
    if(options) {
      //  Are we calling multiple options
      if(typeof options == 'object') {
        for(i in options) {
          if(options[i] != false && moves[i]) {
            moves[i].call(body);
          }
        }
      } else {
        //  Assume string
        if(moves[options]) {
          moves[options].call(body);
        }
      }
    } else { //  If not, call in Mr. Astley
      return moves['rick'].call(body);
    }
  };

})(jQuery);