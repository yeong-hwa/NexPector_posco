package com.nns.util.makeHandler;

import com.nns.util.GenCodeFileMain;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class MakeSQLHandler implements Handler{ 

	public void make(List list) throws IOException {
		System.out.println("Create SqlMap file Begin!!");
		int makefileCnt = 0;
		String chkPath = "";
		
		List listForParam = list;
		
		for(int i = 0; i < list.size(); i++){
			List l = (List) list.get(i);
			Map mt = (Map)l.get(0);
			String path = "src/main/resources/net/zooin/boms";
			String tabName = (String)mt.get("TABLE_NAME");
			String nameSpace = "";
			
			chkPath = tabName.substring(0, 2);
			String prefix = null;
			if ("CM".equals(chkPath)){
				path += "/common";
				prefix = ".common.";
			} else if ("EQ".equals(chkPath)){
				path += "/equipment";
				prefix = ".equipment.";
			} else if ("CH".equals(chkPath)){
				path += "/channel";
				prefix = ".channel.";
			} else {
				path += "/mobile";
				prefix = ".mobile.";
			}
			nameSpace = path.substring(29, path.length()).replace("/", ".").toLowerCase() + ".model." + getCamal((String) mt.get("TABLE_NAME"), true);
			path += "/baseSqlmap";
			
			File createDir = new File(path);
			
			if (!createDir.exists()){
				createDir.mkdirs();
			}
			String tableName = getCamal((String) mt.get("TABLE_NAME"), true);
			
			File file = new File(path, tableName + "BaseQuery.xml");
			
			if(file.exists()){
				file.delete();
			}
			file.createNewFile();
			
			PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(file)));
			StringBuffer sb = new StringBuffer();
			
			sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
			sb.append("<!DOCTYPE sqlMap PUBLIC \"-//ibatis.apache.org//DTD SQL Map 2.0//EN\" \"http://ibatis.apache.org/dtd/sql-map-2.dtd\">\n");
			sb.append("<sqlMap namespace=\"boms").append(prefix).append(getCamal((String) mt.get("TABLE_NAME"), true)).append("\">\n\n");
			
			// select
			sb.append("\t<select id=\"get\" parameterClass=\"map\" resultClass=\"hashmap\">\n");
			sb.append("\t\tSELECT ");
			for(int j = 0; j < l.size(); j++){
				Map colMap = (Map) l.get(j);
				if(j > 0){
					sb.append(", ");
				}
				sb.append(colMap.get("COLUMN_NAME"));
			}
			sb.append("\n");
			sb.append("\t\t  FROM ").append((String) mt.get("TABLE_NAME")).append("\n");
			int pk = 0;
			for(int j = 0; j < l.size(); j++){
				Map colMap = (Map) l.get(j);				
				if(("".equals(colMap.get("IDX_NM")))) continue;
				
				if(pk > 0){
					sb.append("\t\t   AND ");
				}else{
					sb.append("\t\t WHERE ");
				}
				sb.append(colMap.get("COLUMN_NAME")).append(" = #").append(colMap.get("COLUMN_NAME")).append("#");
				sb.append("\n");
				pk++;
			}
			sb.append("\t</select>\n\n");
			
			// list
			sb.append("\t<select id=\"forList\" parameterClass=\"map\" resultClass=\"hashmap\">\n");
			sb.append("\t\tSELECT ");
			for(int j = 0; j < l.size(); j++){
				Map colMap = (Map) l.get(j);
				if(j > 0){
					sb.append(", ");
				}
				sb.append(colMap.get("COLUMN_NAME"));
			}
			sb.append("\n");
			sb.append("\t\t  FROM ").append((String) mt.get("TABLE_NAME")).append("\n");
			sb.append("\t\t WHERE 1 = 1 \n");
			for(int j = 0; j < l.size(); j++){
				Map colMap = (Map) l.get(j);
				
				if("CRE_DT".equals(colMap.get("COLUMN_NAME")) || "UPD_DT".equals(colMap.get("COLUMN_NAME"))) continue;
				
				sb.append("\t\t   <isNotEmpty property=\"").append(colMap.get("COLUMN_NAME")).append("\">\n");
				sb.append("\t\t   AND ").append(colMap.get("COLUMN_NAME")).append(" = #").append(colMap.get("COLUMN_NAME")).append("#\n");
				sb.append("\t\t   </isNotEmpty>\n");
			}
			sb.append("\t</select>\n\n");

			// update
			sb.append("\t<update id=\"update\" parameterClass=\"map\">\n");
			sb.append("\t\tUPDATE ").append((String) mt.get("TABLE_NAME")).append(" SET\n");
			for(int j = 0; j < l.size(); j++){
				Map colMap = (Map) l.get(j);
				
				if("CRE_DT".equals(colMap.get("COLUMN_NAME")) || "UPD_DT".equals(colMap.get("COLUMN_NAME")) || "USE_YN".equals(colMap.get("COLUMN_NAME")) ||
						"CREATOR_SEQ".equals(colMap.get("COLUMN_NAME")) || "UPDATOR_SEQ".equals(colMap.get("COLUMN_NAME"))
						) continue;
				
				if((!"".equals(colMap.get("IDX_NM")))) continue;
				
				sb.append("\t\t\t   <isNotEmpty property=\"").append(colMap.get("COLUMN_NAME")).append("\">\n");
				sb.append("\t\t\t   ").append(colMap.get("COLUMN_NAME")).append(" = #").append(colMap.get("COLUMN_NAME")).append("#,\n");
				sb.append("\t\t\t   </isNotEmpty>\n");
			}
			sb.append("\t\t\t   UPDATOR_SEQ = #WORKER_SEQ#,\n");
			sb.append("\t\t\t   UPD_DT = NOW()\n");
			pk = 0;
			for(int j = 0; j < l.size(); j++){
				Map colMap = (Map) l.get(j);				
				if(("".equals(colMap.get("IDX_NM")))) continue;
				
				if(pk > 0){
					sb.append("\t\t   AND ");
				}else{
					sb.append("\t\t WHERE ");
				}
				sb.append(colMap.get("COLUMN_NAME")).append(" = #").append(colMap.get("COLUMN_NAME")).append("#");
				sb.append("\n");
				pk++;
			}
			sb.append("\t</update>\n\n");
			
			// insert
			sb.append("\t<insert id=\"insert\" parameterClass=\"map\">\n");
			sb.append("\t\tINSERT INTO ").append((String) mt.get("TABLE_NAME")).append("\n");
			sb.append("\t\t\t(\n");
			for(int j = 0; j < l.size(); j++){
				Map colMap = (Map) l.get(j);
				if("CRE_DT".equals(colMap.get("COLUMN_NAME")) || "UPD_DT".equals(colMap.get("COLUMN_NAME")) || "USE_YN".equals(colMap.get("COLUMN_NAME")) ||
						"CREATOR_SEQ".equals(colMap.get("COLUMN_NAME")) || "UPDATOR_SEQ".equals(colMap.get("COLUMN_NAME"))
						) continue;
				
				sb.append("\t\t\t\t<isNotEmpty property=\"").append(colMap.get("COLUMN_NAME")).append("\">\n");
				sb.append("\t\t\t\t").append(colMap.get("COLUMN_NAME")).append(",\n");
				sb.append("\t\t\t\t</isNotEmpty>\n");
			}
			sb.append("\t\t\t\tUSE_YN,\n");
			sb.append("\t\t\t\tCREATOR_SEQ,\n");
			sb.append("\t\t\t\tCRE_DT\n");
			sb.append("\t\t\t)\n");
			sb.append("\t\tVALUES\n");
			sb.append("\t\t\t(\n");
			for(int j = 0; j < l.size(); j++){
				Map colMap = (Map) l.get(j);
				if("CRE_DT".equals(colMap.get("COLUMN_NAME")) || "UPD_DT".equals(colMap.get("COLUMN_NAME")) || "USE_YN".equals(colMap.get("COLUMN_NAME")) ||
						"CREATOR_SEQ".equals(colMap.get("COLUMN_NAME")) || "UPDATOR_SEQ".equals(colMap.get("COLUMN_NAME"))
						) continue;
				
				sb.append("\t\t\t\t<isNotEmpty property=\"").append(colMap.get("COLUMN_NAME")).append("\">\n");
				sb.append("\t\t\t\t#").append(colMap.get("COLUMN_NAME")).append("#,\n");
				sb.append("\t\t\t\t</isNotEmpty>\n");
			}
			sb.append("\t\t\t\t'Y',\n");
			sb.append("\t\t\t\t#WORKER_SEQ#,\n");
			sb.append("\t\t\t\tNOW()\n");
			sb.append("\t\t\t)\n");
			sb.append("\t</insert>\n\n");
			
			// delete
			sb.append("\t<update id=\"delete\" parameterClass=\"map\">\n");
			sb.append("\t\tUPDATE ").append((String) mt.get("TABLE_NAME")).append(" SET\n");
			sb.append("\t\t\t   USE_YN = 'N',\n");
			sb.append("\t\t\t   UPDATOR_SEQ = #WORKER_SEQ#,\n");
			sb.append("\t\t\t   UPD_DT = NOW()\n");
			pk = 0;
			for(int j = 0; j < l.size(); j++){
				Map colMap = (Map) l.get(j);				
				if(("".equals(colMap.get("IDX_NM")))) continue;
				
				if(pk > 0){
					sb.append("\t\t   AND ");
				}else{
					sb.append("\t\t WHERE ");
				}
				sb.append(colMap.get("COLUMN_NAME")).append(" = #").append(colMap.get("COLUMN_NAME")).append("#");
				sb.append("\n");
				pk++;
			}
			sb.append("\t</update>\n");
			sb.append("</sqlMap>\n");
			
			out.println(sb);
			out.flush();
			System.out.println("Create File (" + ++makefileCnt + "): " + path + "/" +file.getName());
			out.close();
		}
		
		makeSqlMapConfig(listForParam);
		System.out.println("Create SqlMap file Finished!!");
	}

	private void makeSqlMapConfig(List list) throws IOException {
		// 목록 정렬
		Map sortMap = new TreeMap();
		for(int i = 0; i < list.size(); i++){
			List l = (List) list.get(i);
			
			sortMap.put(((Map)l.get(0)).get("TABLE_NAME"), l);
		}
		list = new ArrayList(sortMap.values());
		
		
		
		// 코드 잰...
		String filePath = GenCodeFileMain.ProjectPath + "src/main/resources";
		String nameSpace = "";
		String nameSpaceSorting = "";
		String chkPath = "";
		
		File file = new File(filePath, "sql-map-base-config.xml");
		
		if(file.exists()){
			file.delete();
		}
		file.createNewFile();
		
		PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(file)));
		StringBuffer sb = new StringBuffer();
		
		sb.append("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
		sb.append("<!DOCTYPE sqlMapConfig PUBLIC \"-//iBATIS.com//DTD SQL Map Config 2.0//EN\" \"http://www.ibatis.com/dtd/sql-map-config-2.dtd\">\n");
		sb.append("<sqlMapConfig>\n");
		sb.append("\t<settings useStatementNamespaces=\"true\" />\n");
		
		for(int i = 0; i < list.size(); i++){
			String path = "src/main/resources/net/zooin/boms";
			List l = (List) list.get(i);
			Map mt = (Map)l.get(0);
			String tabName = (String)mt.get("TABLE_NAME");
			String objName = getCamal(tabName, true);
			
			chkPath = tabName.substring(0, 2);
			
			if ("CM".equals(chkPath)){
				path += "/common";
			} else if ("EQ".equals(chkPath)){
				path += "/equipment";
			} else if ("CH".equals(chkPath)){
				path += "/channel";
			} else {
				path += "/mobile";
			}
			
			path += "/baseSqlmap/";
			nameSpace = path.substring(29, path.length()).replace("/", ".") + objName;
			
			sb.append("\t\t<sqlMap resource=\"" + "net/zooin/" + nameSpace.replace(".", "/") + "BaseQuery.xml\"/>\n");
			
		}
		sb.append("</sqlMapConfig>\n");
		out.println(sb);
		out.flush();
		System.out.println("Create File : " + filePath + "/" +file.getName());
		out.close();
		System.out.println("Make SqlMap Config File Finished!!");
	}

	private String getCamal(String name, boolean isFirst) {
		String [] names = name.split("_");
		
		StringBuffer sb = new StringBuffer();
		for(int i = 0; i < names.length; i++){
			if(names[i].length() < 1) continue;
			if(isFirst || i > 0){
				sb.append(names[i].substring(0, 1));
				sb.append(names[i].substring(1).toLowerCase());
			}else{
				sb.append(names[i].toLowerCase());
			}
		}
		
		return sb.toString();
	}

}
