using Toybox.Math;
using Toybox.Time as Time;
using Toybox.System as S;
using Toybox.Graphics as G;

module MoonUtils{

    function mod (a ,b) {
        var fc = 0.0000001;
        if (b ==0) { return 0; }
        return ((a/b - Math.floor(a/b + fc)) *b).toFloat();
    }

    function julianDate (year, month, day, hour, min, UT, dst) {
        var pr=0d;
        if (dst==1) {pr=1/24.0d;}
        //note SUBTRACTION of UT which is correct for this direction of the conversion
        var JDN= ((367l*(year) - Math.floor(7l*(year + Math.floor((month+9l )/12l))/4l)) + Math.floor(275l*(month)/9l) + (day + 1721013.5d - UT/24.0d ) );
        var JD= (JDN + (hour)/24.0d + min/1440.0d - pr); //(hour)/24 + (min)/1440; in this case  noon (hr12, min0)
        return JD;

    }

    //public function synodicMonthLength_days(now_info, timeZoneOffset_sec, dst ) {
    //    if (timeZoneOffset_sec == null) {timeZoneOffset_sec = 0;}
    //    if (dst == null) {dst = 0;}
    //
    //    var JD = julianDate (now_info.year, now_info.month, now_info.day, now_info.hour, now_info.min, timeZoneOffset_sec/3600, dst);
    //    var T = (JD - 2451545.0)/36525f;
    //
    //    return 29.5305888531f + 0.00000021621f* T - 3.64E-10 * T*T;
    //}

    function lunarPhase (d) {

        var now = S.getClockTime();
        var time_now = Time.now();
        var now_info = Time.Gregorian.info(time_now, Time.FORMAT_SHORT);

        var utcHour = now_info.hour - (now.timeZoneOffset / 3600);

        //var sml_days  = synodicMonthLength_days(now_info, now.timeZoneOffset, now.dst );
        var sml_days = 29.5305888531;
        var base_JD = julianDate (2025, 1, 29 , 12, 36, 0, 0);
        //var current_JD = julianDate (now_info.year, now_info.month, now_info.day, now_info.hour, now_info.min, now.timeZoneOffset/3600, now.dst);
        var current_JD = julianDate (now_info.year, now_info.month, now_info.day + d, utcHour, now_info.min, 0, 0);

        var difference = current_JD - base_JD;
        var lunar_day = mod (difference, sml_days);
        var lunar_phase = lunar_day/sml_days;

        return lunar_phase;
    }

    function drawMoon(dc, dca, x, y) {
        var moon = MoonUtils.lunarPhase(0);
        var iconIndex = Math.round(moon * 8).toNumber() % 8;

        var moonGroup = dca.getGroup(:moon);
        
        var icon = dca.icon(moonGroup[iconIndex]);
        icon.setLocation(x, y);
        icon.setColor(G.COLOR_WHITE);
        icon.draw(dc);
    }
}