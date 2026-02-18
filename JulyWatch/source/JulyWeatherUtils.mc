import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

using Toybox.Math;
using Toybox.Time as T;
using Toybox.System as S;
using Toybox.Weather as W;
using Toybox.Graphics as G;
using Toybox.Lang as L;

module WeatherUtils{

    function isNight(){
        var h = S.getClockTime().hour;
        return (h < 8 || h >= 21);
    }

    public function weatherIcon (dc, condition, dca, x, y, color) {
        var night = isNight();

        var wGroup = dca.getGroup(:weather);
        var icon= dca.icon(wGroup[0]);

        switch (condition) {
            // 🌩 TORMENTA
            case W.CONDITION_THUNDERSTORMS:
            case W.CONDITION_SCATTERED_THUNDERSTORMS:
            case W.CONDITION_CHANCE_OF_THUNDERSTORMS:
                icon= night ? dca.icon(wGroup[1]) : dca.icon(wGroup[10]); // Luna y sol rayo
                break;
            // 🌧 LLUVIA
            case W.CONDITION_RAIN:
            case W.CONDITION_LIGHT_RAIN:
            case W.CONDITION_HEAVY_RAIN:
            case W.CONDITION_SHOWERS:
            case W.CONDITION_LIGHT_SHOWERS:
            case W.CONDITION_HEAVY_SHOWERS:
            case W.CONDITION_SCATTERED_SHOWERS:
            case W.CONDITION_DRIZZLE:
            case W.CONDITION_FREEZING_RAIN:
                icon= night ? dca.icon(wGroup[3]) : dca.icon(wGroup[12]);
                break;
            // ❄ NIEVE
            case W.CONDITION_SNOW:
            case W.CONDITION_LIGHT_SNOW:
            case W.CONDITION_HEAVY_SNOW:
            case W.CONDITION_FLURRIES:
            case W.CONDITION_SLEET:
            case W.CONDITION_ICE_SNOW:
            case W.CONDITION_LIGHT_RAIN_SNOW:
            case W.CONDITION_HEAVY_RAIN_SNOW:
                icon= night ? dca.icon(wGroup[4]) : dca.icon(wGroup[13]);
                break;
            // 🌧❄ AGUA-NIEVE
            case W.CONDITION_RAIN_SNOW:
                icon= dca.icon(wGroup[19]);
                break;
            // 🌫 NIEBLA / BRUMA / POLVO
            case W.CONDITION_FOG:
            case W.CONDITION_MIST:
            case W.CONDITION_HAZY:
            case W.CONDITION_DUST:
            case W.CONDITION_SMOKE:
            case W.CONDITION_SAND:
            case W.CONDITION_SANDSTORM:
            case W.CONDITION_VOLCANIC_ASH:
                icon= dca.icon(wGroup[17]);
                break;
            // 💨 VIENTO
            case W.CONDITION_WINDY:
            case W.CONDITION_SQUALL:
                icon= dca.icon(wGroup[18]);
                break;
            // ☁ NUBLADO
            case W.CONDITION_CLOUDY:
            case W.CONDITION_MOSTLY_CLOUDY:
            case W.CONDITION_THIN_CLOUDS:
                icon= night ? dca.icon(wGroup[7]) : dca.icon(wGroup[9]);
                break;
            // 🌤 PARCIALMENTE NUBES
            case W.CONDITION_PARTLY_CLOUDY:
            case W.CONDITION_PARTLY_CLEAR:
            case W.CONDITION_MOSTLY_CLEAR:
            case W.CONDITION_FAIR:
                icon= night ? dca.icon(wGroup[6]) : dca.icon(wGroup[14]);
                break;
            // ☀ DESPEJADO
            case W.CONDITION_CLEAR:
                icon= night ? dca.icon(wGroup[5]) : dca.icon(wGroup[15]);
                break;
            default:
                icon= night ? dca.icon(wGroup[5]) : dca.icon(wGroup[15]);
    
        } 

        icon.setLocation(x, y);
        icon.setColor(color);
        icon.draw(dc);
    }

    function drawWeather(dc,weathericons, x, y, color){
        var condition = W.getCurrentConditions().condition;
        WeatherUtils.weatherIcon(dc, condition, weathericons, x, y, color);
    }

    function temp() as String{
        var condition = W.getCurrentConditions();
        var temp = condition.temperature;
        var st = temp.format("%.1f");

        var DEG = "\u00B0";
        if(temp){
           return st + DEG + "";
        }

        return "-";
    }
     
}

//  0 "lunFog"   
//  1 "lunRayo"  
//  2 "lunNiebla"
//  3 "lunLluvia"
//  4 "lunNieve" 
//  5 "lun"      
//  6 "lunPNub"  
//  7 "lunNub"   
//  8 "solFog"   
//  9 "solNub"   
//  10 "solRayo"  
//  11 "solNiebla"
//  12 "solLluvia"
//  13 "solNieve" 
//  14 "solPNub"  
//  15 "sol"      
//  16 "Nuves"    
//  17 "Niebla"   
//  18 "Viento"   
//  19 "AguaNieve"

// CONDITION_CLEAR	0	
// CONDITION_PARTLY_CLOUDY	1	
// CONDITION_MOSTLY_CLOUDY	2	
// CONDITION_RAIN	3	
// CONDITION_SNOW	4	
// CONDITION_WINDY	5	
// CONDITION_THUNDERSTORMS	6	
// CONDITION_WINTRY_MIX	7	
// CONDITION_FOG	8	
// CONDITION_HAZY	9	
// CONDITION_HAIL	10	
// CONDITION_SCATTERED_SHOWERS	11	
// CONDITION_SCATTERED_THUNDERSTORMS	12	
// CONDITION_UNKNOWN_PRECIPITATION	13	
// CONDITION_LIGHT_RAIN	14	
// CONDITION_HEAVY_RAIN	15	
// CONDITION_LIGHT_SNOW	16	
// CONDITION_HEAVY_SNOW	17	
// CONDITION_LIGHT_RAIN_SNOW	18	
// CONDITION_HEAVY_RAIN_SNOW	19	
// CONDITION_CLOUDY	20	
// CONDITION_RAIN_SNOW	21	
// CONDITION_PARTLY_CLEAR	22	
// CONDITION_MOSTLY_CLEAR	23	
// CONDITION_LIGHT_SHOWERS	24	
// CONDITION_SHOWERS	25	
// CONDITION_HEAVY_SHOWERS	26	
// CONDITION_CHANCE_OF_SHOWERS	27	
// CONDITION_CHANCE_OF_THUNDERSTORMS	28	
// CONDITION_MIST	29	
// CONDITION_DUST	30	
// CONDITION_DRIZZLE	31	
// CONDITION_TORNADO	32	
// CONDITION_SMOKE	33	
// CONDITION_ICE	34	
// CONDITION_SAND	35	
// CONDITION_SQUALL	36	 
// CONDITION_SANDSTORM	37	
// CONDITION_VOLCANIC_ASH	38	 
// CONDITION_HAZE	39	 
// CONDITION_FAIR	40	
// CONDITION_HURRICANE	41	 
// CONDITION_TROPICAL_STORM	42	
// CONDITION_CHANCE_OF_SNOW	43	
// CONDITION_CHANCE_OF_RAIN_SNOW	44	
// CONDITION_CLOUDY_CHANCE_OF_RAIN	45	
// CONDITION_CLOUDY_CHANCE_OF_SNOW	46	
// CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW	47	 
// CONDITION_FLURRIES	48	
// CONDITION_FREEZING_RAIN	49	
// CONDITION_SLEET	50	
// CONDITION_ICE_SNOW	51	
// CONDITION_THIN_CLOUDS	52	
// CONDITION_UNKNOWN	53