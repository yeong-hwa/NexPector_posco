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

public enum DBtype {

	ORACLE(0),
	MSSQL(1),
	SYBASE(2),
	Tibero(3),
	TCPIP(4),
	SQLCLIENT(5);

 	final int code;

	private DBtype(int code) {
		this.code = code;
	}

	public int getCode() {
		return this.code;
	}
}
