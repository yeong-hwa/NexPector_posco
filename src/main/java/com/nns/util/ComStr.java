/**
 * version : 1.3
 * update  : 2018.03.02
 */
package com.nns.util;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

public class ComStr {

	/**
	 * String 형변환
	 * @param oSrc
	 * @return
	 */
	public static String toStr(Object oSrc) {
		if (oSrc == null)
			return "";

		if (oSrc instanceof String)
			return (String) oSrc;

		return oSrc.toString();
	}

	/**
	 * Integer 형변환
	 * @param oSrc
	 * @param nDefVal
	 * @return
	 */
	public static int toInt(Object oSrc, int nDefVal) {
		if (oSrc == null)
			return nDefVal;

		if (oSrc instanceof Integer)
			return (Integer) oSrc;

		if (oSrc instanceof Double) {
			return ((Double) oSrc).intValue();
		}

		if (oSrc instanceof Float) {
			return ((Float) oSrc).intValue();
		}

		int 	retValue = nDefVal;

		try {
			String sTarget = oSrc.toString();
			retValue = Integer.parseInt(sTarget.trim());
		} catch (NumberFormatException e) { retValue = nDefVal; }

		return retValue;
	}

	/**
	 * Long 형변환
	 * @param oSrc
	 * @param nDefVal
	 * @return
	 */
	public static long toLong(Object oSrc, long nDefVal) {
		if (oSrc == null)
			return nDefVal;

		if (oSrc instanceof Integer)
			return ((Integer) oSrc).longValue();

		if (oSrc instanceof Long)
			return (Long) oSrc;

		if (oSrc instanceof Double) {
			return ((Double) oSrc).intValue();
		}

		if (oSrc instanceof Float) {
			return ((Float) oSrc).intValue();
		}

		long 	retValue = nDefVal;

		try {
			String sTarget = oSrc.toString();
			retValue = Long.parseLong(sTarget.trim());
		} catch (NumberFormatException e) { retValue = nDefVal; }

		return retValue;
	}

	/**
	 * Float 형변환
	 * @param oSrc
	 * @param nDefVal
	 * @return
	 */
	public static float toFloat(Object oSrc, float nDefVal) {
		if (oSrc == null)
			return nDefVal;

		if (oSrc instanceof String) {
			float 	retValue = nDefVal;

			try {
				retValue = Float.parseFloat(((String) oSrc).trim());
			} catch (Exception e) { retValue = nDefVal; }

			return retValue;
		}

		if (oSrc instanceof Integer) {
			return ((Integer) oSrc).floatValue();
		}
		if (oSrc instanceof Double) {
			return ((Double) oSrc).floatValue();
		}
		if (oSrc instanceof Float) {
			return ((Float) oSrc).floatValue();
		}

		float 	retValue = nDefVal;

		try {
			retValue = Float.parseFloat(oSrc.toString());
		} catch (Exception e) { retValue = nDefVal; }

		return retValue;
	}

	/**
	 * Integer 형변환
	 * @param oSrc
	 * @return
	 */
	public static int toInt(Object oSrc) {
		return toInt(oSrc, 0);
	}

	/**
	 * Long 형변환
	 * @param oSrc
	 * @return
	 */
	public static long toLong(Object oSrc) {
		return toLong(oSrc, 0);
	}

	/**
	 * String 크기 반환
	 * @param sSrc
	 * @return
	 */
	public static int getLength(String sSrc) {
		if (sSrc == null)
			return 0;
		return sSrc.length();
	}

	/**
	 * String 비어 있는지 검사하는 함수
	 * @param sSrc
	 * @return
	 */
	public static boolean isEmpty(String sSrc) {
		if (sSrc == null)
			return true;
		return sSrc.isEmpty();
	}

	/**
	 * String 비어 있는지 검사하는 함수
	 * @param oSrc
	 * @return
	 */
	public static boolean isEmpty(Object oSrc) {
		if (oSrc == null) {
			return true;
		}
		if (oSrc instanceof String) {
			return ((String) oSrc).isEmpty();
		}
		return false;
	}

	public static String toStr(HashMap<String,Object> map) {
		StringBuilder		sb = new StringBuilder();
		Set<String>			keys = map.keySet();
		Iterator<String>	iter = keys.iterator();
		while ( iter.hasNext() ) {
			String	key = iter.next();
			if (sb.length() > 0) {
				sb.append("\n");
			}
			sb.append(key);
			sb.append("=");
			sb.append(map.get(key));
		}
		return sb.toString();
	}
	public static String toStr(List<HashMap<String,Object>> list) {
		StringBuilder		sb = new StringBuilder();
		Iterator<HashMap<String,Object>>	iter = list.iterator();
		int					ncnt = 0;
		while ( iter.hasNext() ) {
			HashMap<String,Object>	data = iter.next();
			sb.append("LIST: " + ncnt + " >>>>>>>>\n");
			appendString(sb, data);
			ncnt ++;
		}
		return sb.toString();
	}
	private static void appendString(StringBuilder sb, HashMap<String,Object> map) {
		Set<String>			keys = map.keySet();
		Iterator<String>	iter = keys.iterator();
		while ( iter.hasNext() ) {
			String	key = iter.next();
			if (sb.length() > 0) {
				sb.append("\n");
			}
			sb.append("  " + key);
			sb.append("=");
			sb.append(map.get(key));
		}
	}
}
