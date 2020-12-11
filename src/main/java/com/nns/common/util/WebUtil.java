package com.nns.common.util;

import javax.servlet.http.HttpServletRequest;

import java.util.Arrays;
import java.util.Map;

public class WebUtil {

	/**
	 * Map으로 부터 문자열 반환.
	 *
	 * @param map
	 * @param key
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static String getMapToStr(Map map, String key) {
		if (map == null || key == null) {
			return null;
		}

		Object obj = map.get(key);
		if (obj != null) {
			return String.valueOf(obj);
		}

		return "&nbsp;";
	}

	/**
	 * Map으로 부터 문자열 반환. <br>
	 * Null 이면 기본값 반환.
	 *
	 * @param map
	 * @param key
	 * @param defaultValue
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static String getMapToStr(Map map, String key, String defaultValue) {
		if (map == null || key == null) {
			return null;
		}

		Object obj = map.get(key);
		if (obj != null) {
			return String.valueOf(obj);
		}

		return defaultValue;
	}

	/**
	 * getString
	 *
	 * @param map
	 * @param key
	 * @return String
	 */
	@SuppressWarnings("rawtypes")
	public static String getString(Map map, String key) {
		if (map == null || key == null) {
			return null;
		}

		try {
			Object obj = map.get(key);
			return String.valueOf(obj);
		} catch (Exception e) {
			return null;
		}

	}

	/**
	 * getInteger
	 *
	 * @param map
	 * @param key
	 * @return Integer
	 */
	@SuppressWarnings("rawtypes")
	public static Integer getInteger(Map map, String key) {
		if (map == null || key == null) {
			return null;
		}

		try {
			Object obj = map.get(key);
			return Integer.valueOf(String.valueOf(obj));
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * toIntArray
	 *
	 * @param arr
	 * @return int[]
	 */
	public static int[] toIntArray(String[] arr) {
		if (arr == null) {
			return null;
		}

		try {
			int[] result = new int[arr.length];
			for (int i = 0; i < arr.length; i++) {
				result[i] = Integer.parseInt(arr[i]);
			}

			return result;

		} catch (Exception e) {
			return null;
		}
	}

	public static boolean isWatcherUrl(HttpServletRequest request) {
		if (request.getRequestURI().indexOf("/watcher/") > -1) {
			return true;
		}
		return false;
	}

	public static byte[] makeCbcKey(byte[] bytes) {
		byte[] returnBytes = new byte[bytes.length];
		int divLength = bytes.length / 4;
		
		Arrays.fill(returnBytes, (byte) 0x00);
		System.arraycopy(bytes, divLength * 1, returnBytes, 0, 4);
		System.arraycopy(bytes, divLength * 3, returnBytes, 4, 4);
		System.arraycopy(bytes, divLength * 0, returnBytes, 8, 4);
		System.arraycopy(bytes, divLength * 2, returnBytes, 12, 4);
		
		return returnBytes;
	}
}
