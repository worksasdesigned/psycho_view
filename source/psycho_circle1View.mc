using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class psycho_circle1View extends Ui.WatchFace {
var fast_updates;
hidden var COLORS = [
        Gfx.COLOR_WHITE,
        Gfx.COLOR_DK_GRAY,
        Gfx.COLOR_RED,
        Gfx.COLOR_GREEN,
        Gfx.COLOR_YELLOW,
        Gfx.COLOR_PINK,
        Gfx.COLOR_BLUE,
        Gfx.COLOR_LT_GRAY,        
        Gfx.COLOR_BLACK,
        Gfx.COLOR_DK_RED,
        Gfx.COLOR_DK_GREEN,
        Gfx.COLOR_ORANGE,
        Gfx.COLOR_PURPLE,
        Gfx.COLOR_DK_BLUE
        ];

var radius, breite, hoehe, i, j, k, l;
 
    //! Load your resources here
    function onLayout(dc) {
		 radius = dc.getWidth() /2;
		 breite = dc.getWidth(); 
		 hoehe  = dc.getHeight();
               k = 0;		 
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        dc.setColor(COLORS[3],  COLORS[3]);
        dc.fillCircle(breite, hoehe, radius)  ;  
        // Get and show the current time
         i = radius;
         k++;
         l = 0; 
         while ( i > 0)
		  {
		    l++;  // jeder Kreis + 1
		    if (i < (radius/3*2)){ 
		      j = 7 + (l + k) % 7 ;   // zähler
            }
            else{
              j = (l + k) % 7;   // zähler
            }
		    dc.setColor(COLORS[j],  COLORS[j]);   
		    i = i - 1;
            dc.fillCircle(breite/2, hoehe/2, i);
		  }
		  
		  
		var clockTime = Sys.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%.2d")]);
        dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_TRANSPARENT) ;
        dc.drawText(breite/2, hoehe/2, Gfx.FONT_NUMBER_THAI_HOT  , timeString.toString(), Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
       
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
            fast_updates = true;
            Ui.requestUpdate();
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
            fast_updates = false;
            Ui.requestUpdate(); 
    }

}
