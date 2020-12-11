/*****************************************************************************
 * Copyright(c) 2016 NEONEXSOFT. All rights reserved.
 * This software is the proprietary information of NEONEXSOFT. 
 *****************************************************************************/
package com.nns.common.enumeration;

/**
 * 
 * @version 1.0
 * @author chosg78
 * @since 2016. 4. 28.
 * @see
 *
 * <pre>
 * << Modification Information >>
 *    Date	         Name          	       Desc
 * ----------      --------    ---------------------------
 *  2016. 4. 28.   chosg78
 *
 * </pre>
 */

public enum ServerStyle {

	AGENT(0),
	ICMP(1),
	SNMP(2),
	DEAMON(3),
	DBMS(4);
	
	final int code;
	
	private ServerStyle(int code) {
		this.code = code;
	}
	
	public int getCode() {
		return this.code;
	}
}
