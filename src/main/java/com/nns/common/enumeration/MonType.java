package com.nns.common.enumeration;

public enum MonType {
	CPU(0),
	MEMORY(1),
	DISK(2),
	PROCESS(3);
	
 	final int code;

	private MonType(int code) {
		this.code = code;
	}

	public int getCode() {
		return this.code;
	}
}