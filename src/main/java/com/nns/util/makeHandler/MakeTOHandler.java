package com.nns.util.makeHandler;

import com.nns.util.GenCodeFileMain;

import java.io.*;
import java.util.List;
import java.util.Map;

public class MakeTOHandler implements Handler{ 
	
	public void make(List list) throws IOException {
		System.out.println("Create Junit Test Source file Begin!!");
		int makefileCnt = 0;
		
		String chkPath = "";
		
		for(int i = 0; i < list.size(); i++){ // 테이블 목록...
			List l = (List) list.get(i);
			Map mt = (Map)l.get(0);
			String path = GenCodeFileMain.ProjectPath + "src/test/java/net/zooin/boms";
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
			
			path += "/junit/baseDao";
			
			File createDir = new File(path);
			
			if (!createDir.exists()){
				createDir.mkdirs();
			}
			
			String tableName = getCamal((String) mt.get("TABLE_NAME"), true);
			String tableParam = getCamal((String)mt.get("TABLE_NAME"), false);
			
			
			File file = new File(path, tableName + "BaseDaoTest.java");
			if(file.exists()){
				file.delete();
			}
			file.createNewFile();
			PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(file)));
			StringBuffer sb = new StringBuffer();
			
			String pkgPath = path.substring(14, path.length()).replace("/", ".");
			
			sb.append("package com.neonex.boms").append(pakname).append(".junit.baseDao;\n\n");
			
			sb.append("import static org.junit.Assert.*;\n")
			.append("import static org.junit.Assert.assertEquals;\n")
			.append("import org.apache.commons.logging.Log;\n")
			.append("import org.apache.commons.logging.LogFactory;\n")
			.append("import java.util.HashMap;\n")
			.append("import java.util.Map;\n")
			.append("import org.junit.*;\n")
			.append("import org.junit.runner.RunWith;\n")
			.append("import java.util.Date;\n")
			.append("import org.springframework.beans.factory.annotation.Autowired;\n")
			.append("import org.springframework.jdbc.core.JdbcTemplate;\n")
			.append("import org.springframework.test.context.ContextConfiguration;\n")
			.append("import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;\n\n")
			//.append("import com.neonex.boms").append(pakname).append(".model.").append(tableName).append(";\n")
			.append("import com.neonex.boms").append(pakname).append(".baseDao.").append(tableName).append("BaseDao;\n\n");
						
			sb.append("@RunWith(SpringJUnit4ClassRunner.class)\n");
			sb.append("@ContextConfiguration(locations={\n");
			//안에 해당하는 xml 파일 내용 추가해야 함.
			sb.append("\t\t\"classpath:dao-config.xml\"\n");
			sb.append("})\n\n");
			
			sb.append("public class ").append(tableName).append("BaseDaoTest").append("{").append("\n\n");		
			
			sb.append("\tprotected final Log logger = LogFactory.getLog(getClass());\n\n");
			sb.append("\t@Autowired\n").append("\tprotected ").append(tableName).append("BaseDao ").append(tableParam).append("Dao").append(";\n\n");
			sb.append("\tprotected Map inMap = new HashMap();\n\n");
			sb.append("\t@Autowired\n").append("\tprivate JdbcTemplate jdbcTemplate;\n\n");

			sb.append("\tDate date = new Date();\n\n");
			
			sb.append("\t@Before\n").append("\tpublic void setUp() throws Exception {\n\n");
//			//setUp()내용을 추가해야 함.
//			
//			sb.append("\t\t").append(tableParam).append(" = new ").append(tableName).append("();\n");
//			for(int j = 0; j < l.size(); j++){
//				Map m = (Map)l.get(j);
//				String colName = getCamal((String)m.get("COLUMN_NAME"), true);
//				String dataType = (String) getType((String)m.get("DATA_TYPE"));
//				
//				if("String".equals(dataType)){
//					sb.append("\t\t" + tableParam + ".set" + colName + "(\"1\");\n");
//				} else if("long".equals(dataType)){
//					sb.append("\t\t" + tableParam + ".set" + colName + "(10L);\n");
//				} else {
//					sb.append("\t\t" + tableParam + ".set" + colName + "(date);\n");
//				}
//			}
			sb.append("\t}\n\n");
			
			sb.append("\t@After\n").append("\tpublic void tearDown() throws Exception {\n\t");
			//tearDown()내용을 추가해야 함.
			sb.append("}\n\n");
			
			sb.append("\t@Test\n");
			sb.append("\tpublic void insertTest() throws Exception {\n");
			sb.append("\t\t").append(tableParam).append("Dao.insert(inMap);\n");
			sb.append("\t}\n\n");
			
			sb.append("\t@Test\n");
			sb.append("\tpublic void getTest() throws Exception {\n");
			sb.append("\t\t").append(tableParam).append("Dao.get(inMap);\n");
			sb.append("\t}\n\n");
			
			sb.append("\t@Test\n");
			sb.append("\tpublic void updateTest() throws Exception {\n");
			sb.append("\t\t").append(tableParam).append("Dao.update(inMap);\n");
			sb.append("\t}\n\n");
			
			sb.append("\t@Test\n");
			sb.append("\tpublic void forListTest() throws Exception {\n");
			sb.append("\t\t").append(tableParam).append("Dao.forList(inMap);\n");
			sb.append("\t}\n\n");
			
			
			sb.append("\t@Test\n");
			sb.append("\tpublic void deleteTest() throws Exception {\n");
			sb.append("\t\t").append(tableParam).append("Dao.delete(inMap);\n");
			sb.append("\t}\n\n");
			
			sb.append("}").append("\n").append("\n");
			out.println(sb.toString());
			out.flush();
			System.out.println("Create File (" + ++makefileCnt + ") : " + path + "/" +file.getName());
			out.close();
		}
		System.out.println("Create JUnit Testing Source Finished!!");
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
	
	private Object getType(String type) {
		String ret = null;
		
		if("VARCHAR2".equals(type)){
			ret = "String";
		}else if("CHAR".equals(type)){
			ret = "String";
		}else if("NUMBER".equals(type)){
			ret = "long";
		}else if("DATE".equals(type)){
			ret = "Date";
		}else{
			ret = "";
		}
		return ret;
	}
}
