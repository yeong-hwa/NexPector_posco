/*                                                                                 
 * Copyright (c) 2011 ZOOIN.NET CO.,LTD. All rights reserved.                         
 *                                                                                 
 * This software is the confidential and proprietary information of ZOOIN.NET CO.,LTD.
 * You shall not disclose such Confidential Information and shall use it           
 * only in accordance with the terms of the license agreement you entered into      
 * with ZOOIN.NET CO.,LTD.                                                            
 */
package com.nns.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * �Խ����� Dispatch �� �̸�, ��� <BR>
 *           
 * @author       fishingday
 * @version      1.0                   
 * @since        JDK1.4  
 * @HISTORY      : AUTHOR         DATE             DESC
 *                 fishingday     2009. 08. 12     CREATE          
 */

public class OralceAssistantUtil{
	private String driver = "oracle.jdbc.driver.OracleDriver";
	private String user;
	private String pwd;
	private String tnsname;
	
	private long timeOut = 10L * 60L * 1000L;
	private String cmdExp = "EXP";
	private String cmdImp = "IMP";
	
	private StringBuffer executeLogs = new StringBuffer();
	
	public OralceAssistantUtil(String user, String pwd, String tnsname){
		this.user		= user;
		this.pwd		= pwd;
		this.tnsname	= tnsname;
	}
	
//	/**
//	 * Export
//	 * 
//	 * @param dmpFileName
//	 * @return
//	 * @throws IOException 
//	 * @throws IOException 
//	 * @throws IOException 
//	 * @throws IOException
//	 * @throws InterruptedException
//	 */
//	public int exp(String dmpFileName, int exitMin) throws IOException{
//		
//		if(exitMin > 0){
//			this.timeOut	= ((long)exitMin) * 60L * 1000L;
//		}
//		
//		executeLogs.append(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss ").format(new Date(System.currentTimeMillis()))).append("\n");
//		executeLogs.append("-Start Export Process").append("\n");
//		String exportString = "'BOMS'/##_PWD_##@##_TNSNAME_## BUFFER=4096 FILE=##_FILE_## FULL=N OWNER='BOMS' GRANTS=Y";
//		String param = exportString.replaceAll("'BOMS'", this.user)
//								  .replaceAll("##_PWD_##", this.pwd)
//								  .replaceAll("##_TNSNAME_##", this.tnsname)
//								  .replaceAll("##_FILE_##", dmpFileName);
//		
//		DefaultExecutor executor = new DefaultExecutor();
//		ExecuteWatchdog watchdog = new ExecuteWatchdog(this.timeOut);
//        ByteArrayOutputStream baos = new ByteArrayOutputStream();
//        PumpStreamHandler streamHandler = new PumpStreamHandler(baos);
//        executor.setWatchdog(watchdog);
//        executor.setStreamHandler(streamHandler);
//        CommandLine commandLine = CommandLine.parse(this.cmdExp);
//        commandLine.addArguments(param);
//        
//        int exitCode = 1;
//        try {
//			exitCode = executor.execute(commandLine);
//			if (executor.isFailure(exitCode) && watchdog.killedProcess()) {
//	        	System.out.println("watcher killed the process!");
//	        }
//		} catch (ExecuteException e) {
//			executeLogs.append(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date(System.currentTimeMillis()))).append("\n");
//			executeLogs.append(e.getMessage()).append("\n");
//			exitCode = e.getExitValue();
//		}
//		executeLogs.append(new String(baos.toByteArray())).append("\n");
//        executeLogs.append(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date(System.currentTimeMillis()))).append("\n");
//        executeLogs.append("-End Export Process, Exit Code : ").append(exitCode).append("\n");
//        return exitCode;
//    }
//	
//	/**
//	 * Import
//	 * 
//	 * @param dmpFileName
//	 * @return
//	 * @throws IOException 
//	 * @throws IOException
//	 */
//	public int imp(String dmpFileName, int exitMin) throws IOException{
//		
//		if(exitMin > 0){
//			this.timeOut	= ((long)exitMin) * 60L * 1000L;
//		}
//		
//		executeLogs.append(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss ").format(new Date(System.currentTimeMillis()))).append("\n");
//		executeLogs.append("Start Import Process").append("\n");
//		String importString = "'BOMS'/##_PWD_##@##_TNSNAME_## BUFFER=8192 FILE=##_FILE_## GRANTS=Y IGNORE=N ROWS=Y FULL=Y";
//		String param = importString.replaceAll("'BOMS'", this.user)
//								  .replaceAll("##_PWD_##", this.pwd)
//								  .replaceAll("##_TNSNAME_##", this.tnsname)
//								  .replaceAll("##_FILE_##", dmpFileName);
//		
//		DefaultExecutor executor = new DefaultExecutor();
//		ExecuteWatchdog watchdog = new ExecuteWatchdog(this.timeOut);
//        ByteArrayOutputStream baos = new ByteArrayOutputStream();
//        PumpStreamHandler streamHandler = new PumpStreamHandler(baos);
//        executor.setWatchdog(watchdog);
//        executor.setStreamHandler(streamHandler);
//        CommandLine commandLine = CommandLine.parse(this.cmdImp);
//        commandLine.addArguments(param);
//        
//        int exitCode = 1;
//        try {
//			exitCode = executor.execute(commandLine);
//			if (executor.isFailure(exitCode) && watchdog.killedProcess()) {
//	        	System.out.println("watcher killed the process!");
//	        }
//		} catch (ExecuteException e) {
//			executeLogs.append(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date(System.currentTimeMillis()))).append("\n");
//			executeLogs.append(e.getMessage()).append("\n");
//			exitCode = e.getExitValue();
//		}
//        executeLogs.append(new String(baos.toByteArray())).append("\n");
//        executeLogs.append(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date(System.currentTimeMillis()))).append("\n");
//        executeLogs.append("End Import Process, Exit Code : ").append(exitCode).append("\n");
//
//        return exitCode;
//	}
	
	/**
	 * ����� ������ TABLE, VIEW, FUNCTION, PROCEDURE, SEQUENCE Drop �Ѵ�.
	 * 
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws ClassNotFoundException
	 */
	public boolean dropDataBase() throws InstantiationException, IllegalAccessException, ClassNotFoundException{
		executeLogs.append(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss ").format(new Date(System.currentTimeMillis()))).append("\n");
		executeLogs.append("- Start Drop Object Process").append("\n");
		
		boolean retVal = false;
		Connection conn = null;
		Statement stmt = null;
		String sqlstr = "SELECT 'DROP TABLE ' || TABLE_NAME || ' CASCADE CONSTRAINTS' CMD  " +
						"  FROM USER_ALL_TABLES " +
						"UNION ALL   " +
						"SELECT 'DROP ' || OBJECT_TYPE || ' ' || OBJECT_NAME CMD " +
						"  FROM USER_OBJECTS " +
						" WHERE OBJECT_TYPE IN ('VIEW', 'FUNCTION', 'PROCEDURE', 'SEQUENCE') " +
						"ORDER BY CMD ";
		Class.forName(driver).newInstance();
		try{
			conn = DriverManager.getConnection("jdbc:oracle:oci8:@" + this.tnsname, this.user, this.pwd);
			stmt = conn.createStatement();
			ResultSet r = stmt.executeQuery(sqlstr);
			List dropCmdList = new ArrayList();
			for(;r.next();){
				dropCmdList.add(r.getString(1));
			}
			r.close();
			stmt.close();			
			
			if(dropCmdList != null && dropCmdList.size() > 0){
				stmt = conn.createStatement();
				for(int i = 0; i < dropCmdList.size(); i ++){
					String cmd = (String) dropCmdList.get(i);
					executeLogs.append("Excute Query : ").append(cmd).append("\n");
					stmt.executeQuery(cmd);
				}
			}
			retVal = true;
		}catch(Exception e){
			executeLogs.append("Exception : ").append(e.getMessage()).append("\n");
		}finally{
			if(stmt != null){ try {stmt.close();} catch (Exception e){}}
			if(conn != null){ try {conn.close();} catch (Exception e){}}
	        executeLogs.append(new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date(System.currentTimeMillis()))).append("\n");
	        executeLogs.append("- End Drop Object Process").append("\n");
		}
		return retVal;
	}
	
	/**
	 * ����� ������ View & Table ������ ��ȸ�Ѵ�.
	 * 
	 * @param url
	 * @param port
	 * @param sid
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws ClassNotFoundException
	 */
	public List tablesInfo(String url, String port, String sid) throws InstantiationException, IllegalAccessException, ClassNotFoundException{
		String sqlstr = /*"SELECT B.OWNER, A.TYPE,  " +*/
						"SELECT B.TABLE_NAME, " + /*C.COMMENTS TAB_COMT,*/ 
						"       B.COLUMN_ID, B.COLUMN_NAME, " + /*D.COMMENTS COL_COMT, */
						"       B.DATA_TYPE,  " +
						/*"       DECODE(B.DATA_PRECISION, NULL, TO_CHAR(DATA_LENGTH), B.DATA_PRECISION || '.' || B.DATA_SCALE) LEN, " +*/
						/*"       B.DATA_DEFAULT DEF,  " +*/
						/*"       B.NULLABLE NULLS, " +*/
						"       E.IDX_NM " +
						"  FROM (SELECT INDEX_OWNER OWNER, TABLE_NAME, COLUMN_NAME, " +
						"               SUBSTR (MAX(SYS_CONNECT_BY_PATH (IDX_NM, ',')), 2) IDX_NM " +
						"          FROM ( " +
						"                SELECT B.INDEX_OWNER,  " +
						"                       B.TABLE_NAME, " +
						"                       B.COLUMN_NAME, " +
						"                       DECODE(B.INDEX_NAME, NULL, '', B.INDEX_NAME ||'('|| B.COLUMN_POSITION || ' ' || B.DESCEND || ')') IDX_NM, " +
						"                       DENSE_RANK() OVER (PARTITION BY B.INDEX_OWNER, B.TABLE_NAME, B.COLUMN_NAME ORDER BY B.INDEX_NAME) RNK " +
						"                  FROM ALL_IND_COLUMNS B, USER_TABLES A " +
						"                 WHERE B.TABLE_NAME = A.TABLE_NAME " +
						"                   AND B.INDEX_OWNER = UPPER('BOMS') " +
						"               ) A " +
						"         START WITH RNK = 1 " +
						"         CONNECT BY PRIOR RNK = RNK - 1 " +
						"                AND PRIOR INDEX_OWNER = INDEX_OWNER " +
						"                AND PRIOR TABLE_NAME  = TABLE_NAME " +
						"                AND PRIOR COLUMN_NAME = COLUMN_NAME " +
						"          GROUP BY INDEX_OWNER, TABLE_NAME, COLUMN_NAME " +
						"       ) E, " +
						"       ALL_COL_COMMENTS D, " +
						"       ALL_TAB_COMMENTS C, " +
						"       ALL_TAB_COLUMNS B, " +
						"       (SELECT TABLE_NAME AS TABLE_NAME, 'TABLE' AS TYPE " +
						"          FROM USER_TABLES T " +
						"        UNION ALL " +
						"        SELECT VIEW_NAME AS TABLE_NAME, 'VIEW' AS TYPE  " +
						"          FROM USER_VIEWS V " +
						"       ) A  " +
						" WHERE B.TABLE_NAME     = A.TABLE_NAME " +
						"   AND B.OWNER          = UPPER('BOMS') " +
						"   AND C.OWNER          = B.OWNER " +
						"   AND C.TABLE_NAME     = B.TABLE_NAME " +
						"   AND D.OWNER          = B.OWNER " +
						"   AND D.TABLE_NAME     = B.TABLE_NAME " +
						"   AND D.COLUMN_NAME    = B.COLUMN_NAME " +
						"   AND E.OWNER       (+)= B.OWNER " +
						"   AND E.TABLE_NAME  (+)= B.TABLE_NAME " +
						"   AND E.COLUMN_NAME (+)= B.COLUMN_NAME " +
						" ORDER BY B.OWNER, A.TYPE, B.TABLE_NAME, B.COLUMN_ID ".replaceAll("BOMS", this.user);
		Class.forName(driver).newInstance();
		Connection conn = null;
		List tableInfoList = null;
		try{
			conn = DriverManager.getConnection("jdbc:oracle:thin:@" + url +":1521:"+sid, this.user, this.pwd);
			SimpleQuery sq = new SimpleQuery(conn);			
			tableInfoList = sq.selectQueryList(sqlstr);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(conn != null) try{conn.close();}catch(Exception e){}
		}
		return tableInfoList;
	}

	/**
	 * @return the cmdExp
	 */
	public String getCmdExp() {
		return cmdExp;
	}

	/**
	 * @param cmdExp the cmdExp to set
	 */
	public void setCmdExp(String cmdExp) {
		this.cmdExp = cmdExp;
	}

	/**
	 * @return the cmdImp
	 */
	public String getCmdImp() {
		return cmdImp;
	}

	/**
	 * @param cmdImp the cmdImp to set
	 */
	public void setCmdImp(String cmdImp) {
		this.cmdImp = cmdImp;
	}

	/**
	 * @return the timeOut
	 */
	public long getTimeOut() {
		return timeOut;
	}

	/**
	 * @param timeOut the timeOut to set
	 */
	public void setTimeOut(long timeOut) {
		this.timeOut = timeOut;
	}

	/**
	 * @return the driver
	 */
	public String getDriver() {
		return driver;
	}

	/**
	 * @param driver the driver to set
	 */
	public void setDriver(String driver) {
		this.driver = driver;
	}

	/**
	 * @return the pwd
	 */
	public String getPwd() {
		return pwd;
	}

	/**
	 * @param pwd the pwd to set
	 */
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}

	/**
	 * @return the tnsname
	 */
	public String getTnsname() {
		return tnsname;
	}

	/**
	 * @param tnsname the tnsname to set
	 */
	public void setTnsname(String tnsname) {
		this.tnsname = tnsname;
	}

	/**
	 * @return the user
	 */
	public String getUser() {
		return user;
	}

	/**
	 * @param user the user to set
	 */
	public void setUser(String user) {
		this.user = user;
	}
	

	/**
	 * @return the executeLogs
	 */
	public String getExecuteLogs() {
		return this.executeLogs.toString();
	}
	
	public void clearExecuteLogs(){
		this.executeLogs = new StringBuffer();
	}
	
	/**
	 * 
	 * @param args
	 */
	public static void main(String[] args){
//		String path = "C:/tmp/testDump.dmp";
//		OralceAssistantUtil oracle = new OralceAssistantUtil("OKPROJECT2", "OKPROJECT2", "TESTSVR");
//		
//		try{
//			if(oracle.exp(path, 3) == 0){
//				oracle.setUser("OKPROJECT");
//				oracle.setPwd("OKPROJECT");
//				if(oracle.dropDataBase()){
//					oracle.imp(path, 3);
//				}
//			}
//		}catch(Exception e){
//			//
//		}finally{
//			System.out.print(oracle.getExecuteLogs());
//		}
		
	}

}
