/*                                                                                 
 * Copyright (c) 2011 ZOOIN.NET CO.,LTD. All rights reserved.                         
 *                                                                                 
 * This software is the confidential and proprietary information of ZOOIN.NET CO.,LTD.
 * You shall not disclose such Confidential Information and shall use it           
 * only in accordance with the terms of the license agreement you entered into      
 * with ZOOIN.NET CO.,LTD.                                                            
 */
package com.nns.common;


/**
 *<pre>
 * Project Name : 2ndBoms
 * Class : net.zooin.common.CommonSessionKey.java
 * This is about <code>CommonSessionKey.java</code>.
 *
 *
 * </pre>
 *
 * @Author : fishingday
 * @version: 1.0
 * @since  : JDK1.6  
 * @HISTORY: AUTHOR    		DATE           DESC
 *           fishingday     2007.01.01    CREATE          
 */
public class CommonConfigKey {

	/**
	 * 사이트 ID
	 */
	private static String siteId;

	public static String getSiteId() {
		return siteId;
	}
	
	public void setSiteId(String siteId) {
		CommonConfigKey.siteId = siteId;
	}

}
