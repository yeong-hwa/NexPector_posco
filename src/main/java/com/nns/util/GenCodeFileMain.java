/*                                                                                 
 * Copyright (c) 2011 ZOOIN.NET CO.,LTD. All rights reserved.                         
 *                                                                                 
 * This software is the confidential and proprietary information of ZOOIN.NET CO.,LTD.
 * You shall not disclose such Confidential Information and shall use it           
 * only in accordance with the terms of the license agreement you entered into      
 * with ZOOIN.NET CO.,LTD.                                                            
 */
package com.nns.util;

import com.nns.util.makeHandler.Handler;
import com.nns.util.makeHandler.MakeDAOHandler;
import com.nns.util.makeHandler.MakeSQLHandler;
import com.nns.util.makeHandler.MakeTOHandler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 
 * @author udkim
 * 
 */

public class GenCodeFileMain {
	
	final static public String ProjectPath = "D:/workspace/2ndBoms/";

	/*
	 * 
	 */
	public List getAllData(){
		// 디비 접속
		
		String user = "BOMS";
		String pwd = "BOMS";
		String tnsname = "ORCL";
		
		OralceAssistantUtil oau = new OralceAssistantUtil(user, pwd, tnsname);
		
		List list = new ArrayList();
		
		try {
			list = oau.tablesInfo("192.168.10.104", "1521", tnsname);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return parseDataToTable(list);
		
	}
	
	/*
	 * 
	 */
	
	public List parseDataToTable(List list){
		
		Map tableMap = new HashMap(); // 이건 테이블별로 담아 줄것..
		for(int i = 0; i < list.size(); i++){
			Map colMap = (Map) list.get(i); // 각 컬럼 데이터를 한땀 한땀 가져 온다.
			
			String tableName = (String)colMap.get("TABLE_NAME"); // 구분할 테이블 이름을 가져 오고..
			List tableList = (List) tableMap.get(tableName); // 테이블을 모아 놓은 Map 에서 목록이 있는 보고..
			
			if(tableList == null){ // 없으면 새로 만들어 주고...
				tableList = new ArrayList();
				tableMap.put(tableName, tableList);
			}
			tableList.add(colMap); // 테이블별 목록에 컬럼을 넣어 주고..
		}
		
		// 테이블 별로 목록을 만들어 준다.
		List lstTable = new ArrayList(tableMap.values());
		return lstTable;
		
	}
	
	public static void main(String[] args) throws IOException {
		
		GenCodeFileMain gbc = new GenCodeFileMain();
		List list = new ArrayList();
		
		list = gbc.getAllData();
		
		Handler makeDaoHandler = new MakeDAOHandler();
		makeDaoHandler.make(list);
		
		Handler makeSqlHandler = new MakeSQLHandler();
		makeSqlHandler.make(list);
		
		Handler makeToHandler = new MakeTOHandler();
		makeToHandler.make(list);
		
//		Handler makeVoHandler = new MakeVOHandler();
//		makeVoHandler.make(list);
		
	}
}
