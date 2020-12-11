package com.nns.common.enumeration;

public enum DaemonType {
	AGENT("A"),
	CLI("C"),
	SNMP("S");
	
 	final String code;

	private DaemonType(String code) {
		this.code = code;
	}

	public String getCode() {
		return this.code;
	}
}