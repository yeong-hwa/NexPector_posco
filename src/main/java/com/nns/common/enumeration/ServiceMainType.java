package com.nns.common.enumeration;

public enum ServiceMainType {
	NexFlow(0),
	NeoVoice(1),
	NeoFAX(2),
	NeoAchive(3);

 	final int code;

	private ServiceMainType(int code) {
		this.code = code;
	}

	public int getCode() {
		return this.code;
	}
}
