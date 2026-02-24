import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Attention;

using Toybox.Math;
using Toybox.Time;
using Toybox.System as S;
using Toybox.Graphics as G;
using ColorsUtils as C;
using TinyFont as TF;

module BirthdayUtils {

 const BIRTH = {  
        1 =>  {}, // Enero
        2 =>  { 22 => ["nana"]}, // Febrero
        3 =>  { 11 => ["july"]}, // Marzo
        4 =>  {}, // Abril 
        5 =>  { 16 => ["rocio"]}, // Mayo
        6 =>  {}, // Junio
        7 =>  {}, // Julio
        8 =>  { 9 => ["julio"]}, // Agosto
        9 =>  {}, // Septiembre
        10 => { 19 => ["oihane"]}, // Octubre
        11 => { 23 => ["raquel"]}, // Noviembre
        12 => {} // Diciembre
    };

    function getBirthday(dc, timeData, cx, cy, dca) as String? {
        var month = timeData[:dateShort].month;
        var m = BIRTH[month] as Dictionary<Number, Array<String>>;
        if (m == null) { return null; }
    
        var d = m[timeData[:dateShort].day];
        if (d == null) { return null; }
    
        var birthIcon = dca.icon(:birth);
        birthIcon.locY = cy - 95;
        birthIcon.locX = cx - 70;
        birthIcon.draw(dc);

        if (d instanceof Array) {
            var s = "";
            for (var i = 0; i < d.size(); i++) {
                if (i > 0) { s += " "; }
                s += d[i];
            }
            return s;
        }
    
        return d;
    }
}