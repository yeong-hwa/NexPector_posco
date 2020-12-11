package com.nns.util.makeHandler;

import com.nns.util.GenCodeFileMain;

import java.io.*;
import java.util.List;
import java.util.Map;

public class MakeVOHandler implements Handler{ 
	
	public void make(List list) throws IOException {
		System.out.println("Create Value Object Begin!!");
		int makefileCnt = 0;
		String chkPath = "";
		
		for(int i = 0; i < list.size(); i++){ // 테이블 목록...
			List l = (List) list.get(i);
			Map mt = (Map)l.get(0);
			String path = GenCodeFileMain.ProjectPath + "src/main/java/net/zooin/boms";
			String tabName = (String)mt.get("TABLE_NAME");
			
			chkPath = tabName.substring(0, 2);
			String pakname = null; 
			
			if ("CM".equals(chkPath)){
				path += "/common";
				pakname = ".common";
			} else if ("EQ".equals(chkPath)){
				path += "/equipment";
				pakname = ".equipment";
			} else if ("CH".equals(chkPath)){
				path += "/channel";
				pakname = ".channel";
			} else {
				path += "/mobile";
				pakname = ".mobile";
			}
			path += "/model";
			
			File createDir = new File(path);
			
			if (!createDir.exists()){
				createDir.mkdirs();
			}
			
			String tableName = getCamal((String) mt.get("TABLE_NAME"), true);
			
			File file = new File(path, tableName + ".java");
			if(file.exists()){
				file.delete();
			}
			file.createNewFile();
			PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(file)));
			StringBuffer sb = new StringBuffer();
			
			sb.append("package com.neonex.boms").append(pakname).append(".model;\n\n");
			
			sb.append("import java.util.Date;\n");
			sb.append("import com.neonex.common.BaseObject;\n");
			sb.append("\n");
			sb.append("public class ").append(tableName).append(" extends BaseObject {").append("\n\n");
			for(int j = 0; j < l.size(); j++){
				Map m = (Map)l.get(j);
				sb.append("\tprivate ").append(getType((String) m.get("DATA_TYPE"))).append(" ").append(getCamal((String) m.get("COLUMN_NAME"), false)).append(";\n");
			}
			
			sb.append("\n");
			for(int j = 0; j < l.size(); j++){
				Map m = (Map)l.get(j);
				sb.append("\tpublic void set").append(getCamal((String) m.get("COLUMN_NAME"), true))
				.append("(").append(getType((String) m.get("DATA_TYPE"))).append(" ").append(getCamal((String) m.get("COLUMN_NAME"), false)).append("){").append("\n")
				.append("\t\tthis.").append(getCamal((String) m.get("COLUMN_NAME"), false)).append(" = ").append(getCamal((String) m.get("COLUMN_NAME"), false)).append(";\n")
				.append("\t}").append("\n");
			}
			
			sb.append("\n");
			for(int j = 0; j < l.size(); j++){
				Map m = (Map)l.get(j);
				sb.append("\tpublic ").append(getType((String) m.get("DATA_TYPE"))).append(" get").append(getCamal((String) m.get("COLUMN_NAME"), true)).append("(){").append("\n")
				.append("\t\treturn this.").append(getCamal((String) m.get("COLUMN_NAME"), false)).append(";\n")
				.append("\t}").append("\n");
			}
			sb.append("}").append("\n").append("\n");
			out.println(sb.toString());
			out.flush();
			System.out.println("Create File (" + ++makefileCnt + "): " + path + "/" +file.getName());
			out.close();
		}
		System.out.println("Create Value Object Finished!!");
	}

	private Object getType(String type) {
		String ret = null;
		
		if("VARCHAR2".equals(type)){
			ret = "String";
		}else if("CHAR".equals(type)){
			ret = "String";
		}else if("NUMBER".equals(type)){
			ret = "Long";
		}else if("DATE".equals(type)){
			ret = "Date";
		}else{
			ret = "";
		}
		return ret;
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
