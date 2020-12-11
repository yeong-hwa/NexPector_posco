package com.nns.util;

import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

public class DateUtils {

    /************************************************
     *메서드명 : getCalcDate<p>
     *메서드 기능 : 원하는 시점의 날짜를 찾는다.<p>
     *PARAM : string <p>
     * getCalcDate(0,1) :오늘<p>
     * getCalcDate(1,1) :년, -1(1년전 오늘),-2(2년전 오늘)<p>
     * getCalcDate(2,1) :개월, -1(1개월전 오늘),-2(2개월전 오늘), 1(1개월후 오늘)<p>
     * getCalcDate(3 or 4 or 8,1) :주, -1(일주일전 같은요일), 1(1주일후 같은요일)<p>
     * getCalcDate(5 or 6 or 7,1) :하루, -1(오늘부터 하루전), 1(오늘부터 하루후)<p>
     * getCalcDate(9,1) :12시간, -1(12시간전) 1(12시간후) 2(24시간후)<p>
     *PARAM date_type : 출력을 원하는 날짜형식<p>
     *RETURN VALUE : string <p>
     *************************************************/
    public static Date getCalcDate(int y, int z, Date date) throws Exception {
        Calendar cal = Calendar.getInstance(Locale.KOREAN);
        cal.setTime(date);
        TimeZone timezone = cal.getTimeZone();
        timezone = timezone.getTimeZone("Asia/Seoul");
        cal = Calendar.getInstance(timezone);

        cal.add(y, z);
        Date currentTime = cal.getTime();
        return currentTime;
    }
}
