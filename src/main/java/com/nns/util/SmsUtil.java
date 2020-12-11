/*****************************************************************************
 * Copyright(c) 2016 NEONEXSOFT. All rights reserved.
 * This software is the proprietary information of NEONEXSOFT. 
 *****************************************************************************/
package com.nns.util;

/**
 * 
 * @version 1.0
 * @author mistarpeo
 * @since 2016. 6. 7.
 * @see
 *
 * <pre>
 * << Modification Information >>
 *    Date	         Name          	       Desc
 * ----------      --------    ---------------------------
 *  2016. 6. 7.   chosg78
 *
 * </pre>
 */

public class SmsUtil {

	public static String str2hexStr(String strstr,String charset) {
		byte[] ba = null;
		try {
			ba = strstr.getBytes(charset);
		} catch (Exception e) {
			e.printStackTrace();
		}
        if (ba == null || ba.length == 0) {
            return null;
        }

        StringBuffer sb = new StringBuffer(ba.length * 2);
        String hexNumber;
        for (int x = 0; x < ba.length; x++) {
            hexNumber = "0" + Integer.toHexString(0xff & ba[x]);

            sb.append(hexNumber.substring(hexNumber.length() - 2));
        }
        return sb.toString();
    }

	
	public static String hexStr2Str(String hexStr,String charset) {
        byte bts[] = new byte[hexStr.length() / 2];
        for (int i = 0; i < bts.length; i++) {
            bts[i] = (byte) Integer.parseInt(hexStr.substring(2 * i, 2 * i + 2),16);
        }
         String rtnStr = "";
        try {
        	rtnStr = new String(bts,charset);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rtnStr;
    }

	public static void main(String[] args) {
		
		String msg = "SMS테스크(Test is berry good!!!!)"; 
		String str2hexStr = str2hexStr(msg, "UTF-8");
		System.err.println(str2hexStr);
		
	}
}
