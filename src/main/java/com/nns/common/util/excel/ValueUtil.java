package com.nns.common.util.excel;

import java.util.List;
import java.util.Map;

public class ValueUtil {

	private static final String VAL = "VAL";

	@SuppressWarnings("rawtypes")
	public static boolean isEquals(List valList, String data) {
		if (data == null || data.trim().length() == 0) {
			return false;
		}

		if (valList == null || valList.size() == 0) {
			return false;
		}

		Map map = null;
		String tmp = null;
		for (int i = 0; i < valList.size(); i++) {
			map = (Map)valList.get(i);
			if (map.get(VAL) != null) {
				tmp = String.valueOf(map.get(VAL));

				if (data.equals(tmp)) {
					return true;
				}

			}
		}
		return false;
	}

	public static boolean isIpAddress(String data) {
		if (data == null || data.trim().length() == 0) {
			return false;
		}

		if (data.indexOf(" ") != -1) {
			return false;
		}

		String[] array = data.split("[.]");

		if (array.length == 4) {
			for (String num : array) {
				if (!getIpNum(num)) {
					return false;
				}
			}
		}

		return true;
	}

	private static boolean getIpNum(String data) {
		if (data != null) {
			try {
				int num = Integer.parseInt(data);
				if (num >= 0 && num <= 255) {
					return true;
				}
			} catch (Exception e) {
				//
			}
		}
		return false;
	}

	public static boolean isString(String data, int byteSize, boolean nullable) {
		if ((data == null || data.trim().length() == 0) && !nullable) {
			return false;
		}

		if (data != null) {
			if (data.getBytes().length > byteSize) {
				return false;
			}
		}
		return true;
	}

	public static boolean isNumber(String data, int size, boolean nullable) {
		if ((data == null || data.trim().length() == 0) && !nullable) {
			return false;
		}

		if (data != null) {

			try {
				long val = Long.parseLong(data);
				String temp = String.valueOf(val);

				if (temp.length() > size) {
					return false;
				}
			} catch (Exception e) {
				return false;
			}

		}
		return true;
	}

	public static boolean isNumber(String data, int size, boolean nullable, long start, long end) {
		if ((data == null || data.trim().length() == 0) && !nullable) {
			return false;
		}

		if (data != null) {

			try {
				long val = Long.parseLong(data);
				String temp = String.valueOf(val);

				if (temp.length() > size) {
					return false;
				}

				if (start > val && end < val) {
					return false;
				}

			} catch (Exception e) {
				return false;
			}

		}
		return true;
	}

	public static boolean checkPk(List<String> pkList, String key) {
		for (String pk : pkList) {
			if (pk.equals(key)) {
				return false;
			}
		}
		return true;
	}
}
