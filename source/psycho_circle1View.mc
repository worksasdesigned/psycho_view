using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;

class psycho_circle1View extends Ui.WatchFace {

var fast_updates = true;  // check if user looks at his fenix3 is set in onhide() at the end of source code
var breite, hoehe, device_settings;
var prim_color = Gfx.COLOR_RED;  // primary color
var sec_color = Gfx.COLOR_DK_RED; // secondary color
var pic_steps, pic_way, pic_kcal;
var fenix_purble = 0x5500AA ; // fenix PURBLE is not Gfx.COLOR_PURBLE Arrg! Thx Garmin!
 

hidden var COLORS = [
        Gfx.COLOR_WHITE,
        Gfx.COLOR_DK_GRAY,
        Gfx.COLOR_RED,
        Gfx.COLOR_GREEN,
        Gfx.COLOR_PINK,
        Gfx.COLOR_YELLOW,
        Gfx.COLOR_BLUE,
        Gfx.COLOR_LT_GRAY,        
        Gfx.COLOR_BLACK,
        Gfx.COLOR_DK_RED,
        Gfx.COLOR_DK_GREEN,
        fenix_purble,
        Gfx.COLOR_ORANGE,       
        Gfx.COLOR_DK_BLUE
        ];

var radius, breite, hoehe, i, j, k, l;
 
    //! Load your resources here
    function onLayout(dc) {
		 radius = dc.getWidth() /2;
		 breite = dc.getWidth(); 
		 hoehe  = dc.getHeight();
         k = 0;
         device_settings = Sys.getDeviceSettings(); // general device settings like 24or12h mode

  		 
               
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
         // clear the screen, just draw a black rectangle
        dc.setColor( Gfx.COLOR_BLACK,  Gfx.COLOR_BLACK);
        dc.fillRectangle(0, 0, breite, hoehe);
        dc.clear();
    
        //READ TIME, DATE and stuff like that
        var clockTime = Sys.getClockTime();
        var dateStrings = Time.Gregorian.info( Time.now(), Time.FORMAT_MEDIUM);
        var dateStrings_s = Time.Gregorian.info( Time.now(), Time.FORMAT_SHORT);
        var hour, min, time, day, sec, month;
        day  = dateStrings.day;
        month  = dateStrings.month;
        min  = clockTime.min;
        hour = clockTime.hour;
        sec  = clockTime.sec;
        
        // READ activity data (steps, movebar level)
        var activity = ActivityMonitor.getInfo();
        var moveBarLevel = activity.moveBarLevel;
        var stepsGoal = activity.stepGoal;
        var stepsLive = activity.steps; 
        var kcal     = activity.calories;
        var km       = activity.distance.toFloat() / 100 / 1000; // distance is saved as cm --> / 100 / 1000 --> km
        var km_txt = "km";            
        if (device_settings.distanceUnits){//is watch set to IMPERIAL-Units?  km--> miles
            km = km.toFloat() * 0.62137;
            km_txt = "mi";
         }
         km = km.format("%2.1f");     // formatting km/mi to 2numbers + 1 digit
                   
        var activproz = stepsLive / stepsGoal.toFloat() * 100; // % of your daily goal achived            
    
    
        dc.setColor(COLORS[3],  COLORS[3]);
        
        dc.fillCircle(breite, hoehe, radius)  ;  
        // Get and show the current time
         i = radius*1.3;
         k++;
         l = 0; 
         while ( i > 0)
		  {
		    l++;  // jeder Kreis + 1
		    if (i < (radius/4*2)){ 
		      j = 7 + (l + k) % 7 ;   // zähler
            }
            else{
              j = (l + k) % 7;   // zähler
            }
		    dc.setColor(COLORS[j],  COLORS[j]);  
            if (l<=15){    		    
		     i = i - (15-l);
		    }else{
		     i = i-1;
		    }
            dc.fillCircle(breite/2, hoehe/2, i);
		  }
		
		
		if( !device_settings.is24Hour ) { // AM/PM if watch is in 12hour Mode --> US
        dc.setColor( Gfx.COLOR_WHITE,  Gfx.COLOR_TRANSPARENT);
           if (hour >= 12) { 
                hour = hour - 12;
                dc.drawText(breite/2+2, hoehe/2 +33 , Gfx.FONT_SMALL , "pm" , Gfx.TEXT_JUSTIFY_CENTER );
                }
            else{  
                dc.drawText(breite/2+5, hoehe/2 +33, Gfx.FONT_SMALL , "am" , Gfx.TEXT_JUSTIFY_CENTER );                
            }
            if (hour == 0) {hour = 12;}    
            hour  = Lang.format("$1$",[hour.format("%2d")]);
            min   = Lang.format("$1$",[min.format("%02d")]); 
        }
        else {            
            hour  = Lang.format("$1$",[hour.format("%02d")]);
            min   = Lang.format("$1$",[min.format("%02d")]);
        }
        // draw hour + minutes + : as letters
        dc.setColor( Gfx.COLOR_WHITE,  Gfx.COLOR_TRANSPARENT);
        dc.drawText(breite/2-5, hoehe/2, Gfx.FONT_NUMBER_THAI_HOT, hour.toString(), Gfx.TEXT_JUSTIFY_RIGHT|Gfx.TEXT_JUSTIFY_VCENTER);
        dc.drawText(breite/2, hoehe/2, Gfx.FONT_NUMBER_THAI_HOT, ":", Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
        dc.drawText(breite/2+5, hoehe/2, Gfx.FONT_NUMBER_THAI_HOT, min.toString(), Gfx.TEXT_JUSTIFY_LEFT|Gfx.TEXT_JUSTIFY_VCENTER);
        dc.drawText(breite/2-4, hoehe/2, Gfx.FONT_NUMBER_THAI_HOT, hour.toString(), Gfx.TEXT_JUSTIFY_RIGHT|Gfx.TEXT_JUSTIFY_VCENTER);
        dc.drawText(breite/2-1, hoehe/2, Gfx.FONT_NUMBER_THAI_HOT, ":", Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
        dc.drawText(breite/2+6, hoehe/2, Gfx.FONT_NUMBER_THAI_HOT, min.toString(), Gfx.TEXT_JUSTIFY_LEFT|Gfx.TEXT_JUSTIFY_VCENTER);
       
        // datum anzeigen
        var datum_print;
        if( !device_settings.is24Hour ){ //MONAT Tag oder TAG  Monat
            datum_print =    dateStrings.month.toString() + " " + dateStrings.day.toString();
        } else {
            datum_print =   dateStrings.day.toString() + " " + dateStrings.month.toString();             
        }     
        
        dc.drawText(dc.getWidth()/2, 195, Gfx.FONT_XTINY, datum_print, Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() /2, 170 , Gfx.FONT_MEDIUM, dateStrings.day_of_week.toString(), Gfx.TEXT_JUSTIFY_CENTER); 
       
         
        if (fast_updates){
            drawsec(dc,7);
            drawbatt(dc, dc.getWidth()/2-15, 20);
        
        }
     
       
    }

            // well - math with sin & cos is quite a long time ago ;-)
    // draws a "moving" second indicator as 5 colored polygons
    function drawsec(dc, rad2){  
            var dateInfo = Time.Gregorian.info( Time.now(), Time.FORMAT_SHORT );
            var sec  = dateInfo.sec;            
            for (var k = 0; k <=59; k++){
            if ( ( k >= ( sec - 4 ) ) && ( k<=sec)){    
                dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
                var kxx,kyy, winkel, slim;
                winkel = 180 +k * -6;
                slim = 2;

                kyy  = 1+hoehe/2 + (hoehe/2 -rad2) * (Math.cos(Math.PI*(winkel)/180)); 
                kxx  = 1+ breite/2 + (breite/2-rad2) * (Math.sin(Math.PI*(winkel)/180));
                if ( k == sec ){dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED); }
                if ( k == sec - 1 ){dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_DK_RED);}
                if ( k == sec - 2 ){dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY);}
                if ( k == sec - 3 ){dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_LT_GRAY);}
                if ( k == sec - 4 ){dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);}    
                 dc.fillCircle(kxx, kyy, 6);
                    
            }  
            }           
                
    }
    
    function drawbatt(dc,batx,baty){
              // Batterie neu
              var batt = Sys.getSystemStats().battery; // get battery status
              batt = batt.toNumber(); // safety first --> set it to integer
              dc.setPenWidth(1);
              batx = batx.toNumber();
              baty = baty.toNumber();
              
              // draw boarder 
              dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE); 
              dc.fillRectangle(batx, baty, 31, 12); // white area BODY
              dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY); 
              dc.fillRectangle(batx + 31, baty +3, 3, 6); //  BOBBL
              dc.drawRectangle(batx, baty, 31, 12); // frame
              //draw green / colored fill-level
               
               if (batt >= 50) { // draw big block if batt > 50%
                dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_GREEN);
                dc.fillRectangle(batx +1, baty+1, 14, 10);
                if (batt >= 60){dc.fillRectangle(batx+16, baty+1, 2, 10);} // add tiny 60% bar
                if (batt >= 70){dc.fillRectangle(batx+19, baty+1, 2, 10);} // add tiny 70% bar
                if (batt >= 80){dc.fillRectangle(batx+22, baty+1, 2, 10);} // add tiny 80% bar
                if (batt >= 90){dc.fillRectangle(batx+25, baty+1, 2, 10);} // add tiny 90% bar
                if (batt >= 100){dc.fillRectangle(batx+1, baty+1, 29, 10); // add 100% bar (covers 60-90% bar)
                   dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
                   dc.drawText(batx+3 ,  baty+4 , Gfx.FONT_XTINY, "100" , Gfx.TEXT_JUSTIFY_LEFT|Gfx.TEXT_JUSTIFY_VCENTER); // write 100% fully charged 
                }
               }else { // battery < 50% switch design 
                dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_DK_GREEN);
                if (batt >= 40){dc.fillRectangle(batx+12, baty+1, 4, 10);}  // add tiny 40% bar green
                dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_YELLOW);
                if (batt >= 30){dc.fillRectangle(batx+8, baty+1, 4, 10);}    // add tiny 30% bar yellow 
                dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_ORANGE);
                if (batt >= 20){dc.fillRectangle(batx+5, baty+1, 4, 10);}   // add tiny 20% bar red
                dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
                if (batt >= 11){dc.fillRectangle(batx+1, baty+1, 4, 10);} // 10% Rest
                else{
                 if (sec %2 == 1){    // blink very second LOW!
                    dc.fillRectangle(batx+1, baty+1, 3, 10);
                 }else{
                   dc.drawText(batx+3 ,  baty+5 , Gfx.FONT_XTINY, "LOW" , Gfx.TEXT_JUSTIFY_LEFT|Gfx.TEXT_JUSTIFY_VCENTER);  
                 }
                }
                if (batt >=11) { // write Batt text between 49% & 11%
                    dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(batx+16 ,  baty+5 , Gfx.FONT_XTINY, batt.toString() , Gfx.TEXT_JUSTIFY_LEFT|Gfx.TEXT_JUSTIFY_VCENTER);
                 } 
                } // End BATT
} // End drawbattfunction    
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
