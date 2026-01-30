import Toybox.Lang;

using Toybox.Time;
using Toybox.System;

module TimeUtils {

    // Get day of week symbol
    function getDaySymbol(dayOfWeek as Number) as Symbol {
        return {
            1 => :Sunday,
            2 => :Monday,
            3 => :Tuesday,
            4 => :Wednesday,
            5 => :Thursday,
            6 => :Friday,
            7 => :Saturday
        }[dayOfWeek];
    }

    // Get current time data
    function getTimeData() {
        var clock = System.getClockTime();
        var now   = Time.now();

        return {
            :hour => clock.hour,
            :min  => clock.min,
            :sec  => clock.sec,
            :date => Time.Gregorian.info(now, Time.FORMAT_MEDIUM),
            :dateShort => Time.Gregorian.info(now, Time.FORMAT_SHORT)
        };
    }
}
