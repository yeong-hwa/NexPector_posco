package com.nns.common.enumeration;

public enum LoginFailType {
    FAIL(-1),
    NOT_ID(101),
    ID_ROCK(102),
    PERIOD_EXCESS(103),
    PERIOD_PREVIOUS(104),
    LONGTIME_LOGIN(105),
	NOT_ALLOWED_IP(106);
	
    final int code;

    private LoginFailType(int code) {
        this.code = code;
    }

    public int getCode() {
        return this.code;
    }
}
