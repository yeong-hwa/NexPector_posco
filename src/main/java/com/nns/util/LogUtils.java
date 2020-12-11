package com.nns.util;

import java.util.Map;

public class LogUtils {

    public static String mapToString(Map<String, Object> map) {
        StringBuilder stringBuilder = new StringBuilder();

        stringBuilder.append("{");
        for (String key : map.keySet()) {
            if (stringBuilder.length() > 1) {
                stringBuilder.append(", ");
            }
            String value;
            if (map.get(key) instanceof String) {
                value = (String) map.get(key);
            }
            else if (map.get(key) instanceof String[]) {
                StringBuilder sb = new StringBuilder();
                sb.append("[");
                for (String str : (String[]) map.get(key)) {
                    if (sb.length() > 1) {
                        sb.append(",");
                    }
                    sb.append(str);
                }
                sb.append("]");
                value = sb.toString();
            }
            else if (map.get(key) instanceof int[]) {
                StringBuilder sb = new StringBuilder();
                sb.append("[");
                for (int str : (int[]) map.get(key)) {
                    if (sb.length() > 1) {
                        sb.append(",");
                    }
                    sb.append(str);
                }
                sb.append("]");
                value = sb.toString();
            }
            else {
                value = map.get(key).toString();
            }

            stringBuilder.append((key));
            stringBuilder.append("=");
            stringBuilder.append(value);
        }
        stringBuilder.append("}");

        return stringBuilder.toString();
    }
}
