package com.nns.util.makeHandler;

import com.nns.util.GenCodeFileMain;

import java.io.*;
import java.util.List;
import java.util.Map;

public class MakeDAOHandler implements Handler{ 
	
	public void make(List list) throws IOException {
		System.out.println("Create Data Access Object Begin!!");
		int makefileCnt = 0;
		
		String chkPath = "";
		String nameSpace = "";
		
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
			path += "/baseDao";
			nameSpace = path.substring(29, path.length()).replace("/", ".") + ".model." + getCamal((String) mt.get("TABLE_NAME"), true);
			
			File createDir = new File(path);
			
			if (!createDir.exists()){
				createDir.mkdirs();
			}
			
			String objType = getCamal((String) mt.get("TABLE_NAME"), true);
			
			File file = new File(path, objType + "BaseDao.java");
			if(file.exists()){
				file.delete();
			}
			file.createNewFile();
			
			PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(file)));
			StringBuffer sb = new StringBuffer();
			
			sb.append("package com.neonex.boms").append(pakname).append(".baseDao;\n\n");
			
			sb.append("\n");
			sb.append("import java.util.List;\n");
			sb.append("\n");

			sb.append("import java.util.Map;\n");
			sb.append("import org.springframework.beans.factory.annotation.Autowired;\n");
			sb.append("import org.springframework.stereotype.Component;\n");
			sb.append("import org.springframework.orm.ibatis.SqlMapClientTemplate;\n\n");
			
			sb.append("@Component\n");
			sb.append("public class ").append(objType).append("BaseDao").append("{").append("\n\n");
			
			sb.append("\t@Autowired\n");
			sb.append("\tprotected SqlMapClientTemplate sqlMapClientTemplate;\n\n");
			
			
			sb.append("\tpublic Map get(Map inMap) { \n");
			sb.append("\t\treturn (Map)sqlMapClientTemplate.queryForObject(\"boms").append(pakname).append(".").append(objType).append(".get\", inMap);\n");
			sb.append("\t}\n\n");

			sb.append("\tpublic List ").append("forList(Map inMap) { \n");
			sb.append("\t\treturn ").append("sqlMapClientTemplate.queryForList(\"boms").append(pakname).append(".").append(objType).append(".forList\", inMap);\n");
			sb.append("\t}\n\n");

			sb.append("\tpublic int ").append("update(Map inMap) { \n");
			sb.append("\t\treturn ").append("sqlMapClientTemplate.update(\"boms").append(pakname).append(".").append(objType).append(".update\", inMap);\n");
			sb.append("\t}\n\n");
			
			sb.append("\tpublic Map insert(Map inMap) { \n");
			sb.append("\t\treturn (Map)sqlMapClientTemplate.insert(\"boms").append(pakname).append(".").append(objType).append(".insert\", inMap);\n");
			sb.append("\t}\n\n");

			sb.append("\tpublic int ").append("delete(Map inMap) { \n");
			sb.append("\t\treturn ").append("sqlMapClientTemplate.update(\"boms").append(pakname).append(".").append(objType).append(".delete\", inMap);\n");
			sb.append("\t}\n");

						
			sb.append("}").append("\n").append("\n");
			out.println(sb.toString());
			out.flush();
			System.out.println("Create File (" + ++makefileCnt + "): " + path + "/" +file.getName());
			out.close();
		}

		System.out.println("Create Data Access Object Finished!!");
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
