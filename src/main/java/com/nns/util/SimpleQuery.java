package com.nns.util;

import java.io.InputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 
 * Select / Insert / Update / Delete ���� ������ ����� �����ϰ� ���ش�.
 * 
 * 
 * @author Administrator
 *
 */
public class SimpleQuery { 
	private Connection con;
	
	public SimpleQuery( Connection con){
		this.con = con;
	}
	
	/**
	 * insert, update, delete ���� ������ �����Ѵ�. 
	 * 
	 * 
	 * @param sqlstr ����
	 * @param map ���ε��
	 * @return
	 * @throws Exception
	 */
	public int updateQuery(String sqlstr) throws Exception{
		return updateQuery(sqlstr, null);
	}
	public int updateQuery(String sqlstr, Map map) throws Exception{
	    PreparedStatement pstmt = null;
	    int cnt = 0;
	    ParseQuery pq = null;
	    try{
	    	
	    	pq = new ParseQuery(sqlstr, map);
	    	
	        pstmt = con.prepareStatement(pq.getParseSql());
	        
	        if(pq.getParam() != null && pq.getParam().length > 0){
	        	for(int i = 0; i < pq.getParam().length; i++){
	        		pstmt.setString(i +1, pq.getParam(i));
	        	}
	        }
	        
	        cnt = pstmt.executeUpdate();
	        
	    }catch(Exception e){
	    	throw e;
	    }finally{
	        if(pstmt != null) try{pstmt.close();}catch(Exception e){}
	    }
	    return cnt;
	}

	/**
	 * ������ ��� ���� InputStream ���� ��ȯ�Ѵ�.
	 * 
	 * @param sqlstr ����
	 * @return ���
	 * @throws Exception
	 */
	public InputStream AttachFileDownLoad(String sqlstr,Map map) throws Exception{
	    PreparedStatement pstmt = null;
	    ResultSet rst = null;	    
	    InputStream in = null;
	    ParseQuery pq = null;
	    
	    try{
	    	pq = new ParseQuery(sqlstr, map);
	        pstmt = con.prepareStatement(pq.getParseSql());
	        if(pq.getParam() != null && pq.getParam().length > 0){
	        	for(int i = 0; i < pq.getParam().length; i++){
	        		pstmt.setString(i +1, pq.getParam(i));
	        	}
	        }
	        rst = pstmt.executeQuery();
	        if(rst.next()){
		        in = rst.getBinaryStream(1);
	        }
	        
	    }catch(Exception e){
	    	throw e;
	    }finally{
	        if(rst != null) try{rst.close();}catch(Exception e){}
	        if(pstmt != null) try{pstmt.close();}catch(Exception e){}
	    }
	    return in;
	}
		
	/**
	 * ������ ��� ���� Blob ���� ��ȯ�Ѵ�.
	 * 
	 * @param sqlstr ����
	 * @return ���
	 * @throws Exception
	 */
	public Blob fileBlob(String sqlstr) throws Exception{
	    PreparedStatement pstmt = null;
	    ResultSet rst = null;	    
	    Blob rBlob = null;
	    ParseQuery pq = null;
	    Map map = new HashMap();
	    try{
	    	
	        //pstmt = con.prepareStatement(sqlstr);
	    	pq = new ParseQuery(sqlstr, map);
	    	
	        pstmt = con.prepareStatement(pq.getParseSql());
	        if(pq.getParam() != null && pq.getParam().length > 0){
	        	for(int i = 0; i < pq.getParam().length; i++){
	        		pstmt.setString(i +1, pq.getParam(i));
	        	}
	        }
	        rst = pstmt.executeQuery();
	        if(rst.next()){
		        rBlob = rst.getBlob(1);	
	        }
	        
	    }catch(Exception e){
	    	throw e;
	    }finally{
	        if(rst != null) try{rst.close();}catch(Exception e){}
	        if(pstmt != null) try{pstmt.close();}catch(Exception e){}
	    }
	    return rBlob;
	}

	/**
	 * ������ ��� ���� Object ���� ��ȯ�Ѵ�.
	 * 
	 * @param sqlstr ����
	 * @return ���
	 * @throws Exception
	 */
	public byte[] selectQuerybyte(String sqlstr) throws Exception{
	    PreparedStatement pstmt = null;
	    ResultSet rst = null;	    
	    byte abyte0[] = null;
	    ParseQuery pq = null;
	    Map map = new HashMap();
	    try{
	    	
	        //pstmt = con.prepareStatement(sqlstr);
	    	pq = new ParseQuery(sqlstr, map);
	    	
	        pstmt = con.prepareStatement(pq.getParseSql());
	        if(pq.getParam() != null && pq.getParam().length > 0){
	        	for(int i = 0; i < pq.getParam().length; i++){
	        		pstmt.setString(i +1, pq.getParam(i));
	        	}
	        }
	        
	        rst = pstmt.executeQuery();
	        if(rst.next()){
	        	// abyte0 = (byte[])rst.getObject(1);
	        	abyte0 = rst.getBytes(1);
	        }
	        
	    }catch(Exception e){
	    	throw e;
	    }finally{
	        if(rst != null) try{rst.close();}catch(Exception e){}
	        if(pstmt != null) try{pstmt.close();}catch(Exception e){}
	    }
	    return abyte0;
	}
	/**
	 * ������ ��� ���� String ���� ��ȯ�Ѵ�.
	 * 
	 * @param sqlstr ����
	 * @return ���
	 * @throws Exception
	 */
	public String selectQueryString(String sqlstr, Map map) throws Exception{
	    PreparedStatement pstmt = null;
	    ResultSet rst = null;	    
	    String rmap = null;
	    ParseQuery pq = null;
	    //Map map = new HashMap();
	    try{
	    	
	        //pstmt = con.prepareStatement(sqlstr);
	    	pq = new ParseQuery(sqlstr, map);
	    	
	        pstmt = con.prepareStatement(pq.getParseSql());
	        if(pq.getParam() != null && pq.getParam().length > 0){
	        	for(int i = 0; i < pq.getParam().length; i++){
	        		pstmt.setString(i +1, pq.getParam(i));
	        	}
	        }
	        
	        rst = pstmt.executeQuery();
	        if(rst.next()){
		        rmap = rst.getString(1);	
	        }
	        
	    }catch(Exception e){
	    	throw e;
	    }finally{
	        if(rst != null) try{rst.close();}catch(Exception e){}
	        if(pstmt != null) try{pstmt.close();}catch(Exception e){}
	    }
	    return rmap;
	}

	public String selectQueryString(String sqlstr) throws Exception{
	    return selectQueryString(sqlstr,null);
	}
	/**
	 * ������ ��� ���� Map���� ��ȯ�Ѵ�.
	 * 
	 * @param sqlstr ����
	 * @param map ���ε��
	 * @return ���
	 * @throws Exception 
	 * @throws Exception
	 */
	public Map selectQueryMap(String sqlstr) throws Exception{
		return selectQueryMap(sqlstr, null);
	}
	public Map selectQueryMap(String sqlstr, Map map) throws Exception{
	    PreparedStatement pstmt = null;
	    ResultSet rst = null;	    
	    Map rmap = null;
	    ParseQuery pq = null;
	    try{
	    	pq = new ParseQuery(sqlstr, map);
	    	
	        pstmt = con.prepareStatement(pq.getParseSql());
	        
	        if(pq.getParam() != null && pq.getParam().length > 0){
	        	for(int i = 0; i < pq.getParam().length; i++){
	        		pstmt.setString(i +1, pq.getParam(i));
	        	}
	        }
	        
	        rst = pstmt.executeQuery();
	        rmap = getMap(rst);	
	        
	    }catch(Exception e){
	    	throw e;
	    }finally{
	        if(rst != null) try{rst.close();}catch(Exception e){}
	        if(pstmt != null) try{pstmt.close();}catch(Exception e){}
	    }
	    return rmap;
	}
	
	
	/**
	 * ������ ��� ���� List���� ��ȯ�Ѵ�.
	 * 
	 * @param sqlstr ����
	 * @return ���
	 * @throws Exception
	 */
	public List selectQueryList(String sqlstr) throws Exception{
	    PreparedStatement pstmt = null;
	    ResultSet rst = null;	    
	    List rlist = null;
	    ParseQuery pq = null;
	    try{
	    	Map map = new HashMap();
	        //pstmt = con.prepareStatement(sqlstr);
	    	pq = new ParseQuery(sqlstr, map);
	    	
	        pstmt = con.prepareStatement(pq.getParseSql());
	        if(pq.getParam() != null && pq.getParam().length > 0){
	        	for(int i = 0; i < pq.getParam().length; i++){
	        		pstmt.setString(i +1, pq.getParam(i));
	        	}
	        }
	        rst = pstmt.executeQuery();
	        
	        rlist = getList(rst);	
	        
	    }catch(Exception e){
	    	throw e;
	    }finally{
	        if(rst != null) try{rst.close();}catch(Exception e){}
	        if(pstmt != null) try{pstmt.close();}catch(Exception e){}
	    }
	    return rlist;
	}
	
	/**
	 * ������ ��� ���� List���� ��ȯ�Ѵ�.
	 * 
	 * @param sqlstr ����
	 * @param map ���ε��
	 * @return ���
	 * @throws Exception
	 */
	public List selectQueryList(String sqlstr, Map map) throws Exception{
	    PreparedStatement pstmt = null;
	    ResultSet rst = null;	    
	    List rlist = null;
	    ParseQuery pq = null;
	    try{
	    	
	    	pq = new ParseQuery(sqlstr, map);
	    	
	        pstmt = con.prepareStatement(pq.getParseSql());
	        
	        if(pq.getParam() != null && pq.getParam().length > 0){
	        	for(int i = 0; i < pq.getParam().length; i++){
	        		pstmt.setString(i +1, pq.getParam(i));
	        	}
	        }
	        
	        rst = pstmt.executeQuery();
	        rlist = getList(rst);	
	        
	    }catch(Exception e){
	    	throw e;
	    }finally{
	        if(rst != null) try{rst.close();}catch(Exception e){}
	        if(pstmt != null) try{pstmt.close();}catch(Exception e){}
	    }
	    return rlist;
	}
	
	/**
	 * ������ �߰��Ͽ� ����¡ ������ �����Ѵ�. (do not use JDBC 2.0)
	 * 
	 * @param sqlstr ����
	 * @param map �Ķ����
	 * @param pageSize �������� ��µ� item ����
	 * @param pageNum ����� ������ ��ȣ
	 * @throws Exception
	 */
	public List selectQueryPage(String sqlstr, Map map, int pageSize, int pageNum) throws Exception{
		PreparedStatement pstmt = null;
	    ResultSet rst = null;	    
	    List rlist = null;
	    ParseQuery pq = null;
	    try{
	    	
	    	pq = new ParseQuery(sqlstr, map, pageSize, pageNum);
	    	
	        pstmt = con.prepareStatement(pq.getParseSql());
	        
	        if(pq.getParam() != null && pq.getParam().length > 0){
	        	for(int i = 0; i < pq.getParam().length; i++){
	        		pstmt.setString(i +1, pq.getParam(i));
	        	}
	        }
	        
	        rst = pstmt.executeQuery();
	        rlist = getList(rst);	
	        
	    }catch(Exception e){
	    	throw e;
	    }finally{
	        if(rst != null) try{rst.close();}catch(Exception e){}
	        if(pstmt != null) try{pstmt.close();}catch(Exception e){}
	    }
	    return rlist;
	}
	

	public int selectQueryPageTotCnt(String sqlstr, Map map) throws Exception {
		PreparedStatement pstmt = null;
	    ResultSet rst = null;
	    ParseQuery pq = null;
	    int totCnt = 0;
	    try{
	    	
	    	String transSql = null;
	    		if(sqlstr.indexOf("/*+") > 0){
	    			transSql = sqlstr.substring(0, sqlstr.indexOf("*/") + 2);
	    		}else{
	    			transSql = "SELECT ";
	    		}
	    		
	    		transSql = transSql + " COUNT(*) as TOT_COUNT " + sqlstr.substring(sqlstr.toUpperCase().indexOf("FROM"));
	    	
	    	pq = new ParseQuery(transSql, map);
	    	
	        pstmt = con.prepareStatement(pq.getParseSql());
	        
	        if(pq.getParam() != null && pq.getParam().length > 0){
	        	for(int i = 0; i < pq.getParam().length; i++){
	        		pstmt.setString(i +1, pq.getParam(i));
	        	}
	        }
	        
	        rst = pstmt.executeQuery();
	        totCnt = getTotalCnt(rst);	
	        
	    }catch(Exception e){
	    	throw e;
	    }finally{
	        if(rst != null) try{rst.close();}catch(Exception e){}
	        if(pstmt != null) try{pstmt.close();}catch(Exception e){}
	    }
		return totCnt;
	}
	
	/**
	 * ��ȸ�� result�� �÷����� ã�� �´�.
	 * 
	 * @param meta ��Ÿ������
	 * @return �÷��̸�
	 * @throws java.sql.SQLException
	 */
	public String [] getResultSetMetaData(ResultSetMetaData meta) throws SQLException{
		String [] colNames = null;

		if(meta != null && meta.getColumnCount() > 0){
			colNames = new String[meta.getColumnCount()];
			for(int i = 0; i < meta.getColumnCount(); i++){
				colNames[i] = meta.getColumnName(i +1);
			}
		}

		return 	colNames;
	}

	/**
	 * ���� ��� List�� ��� ��ȯ�Ѵ�.
	 * �÷��� Map�� Map��
	 *
	 * @param rst
	 * @return
	 * @throws java.sql.SQLException
	 */
	public List getList(ResultSet rst) throws SQLException{
		List result = null;
		if(rst != null){
			result = new ArrayList();
	        String [] colNames = null;

	        while(rst.next()){

	        	if(colNames == null){
	        		ResultSetMetaData meta = rst.getMetaData();
	        		colNames = getResultSetMetaData(meta);
	        	}

	        	Map m = new HashMap();
	        	for(int i = 0; i < colNames.length; i++){
	        		m.put(colNames[i], rst.getString(colNames[i]) != null ? rst.getString(colNames[i]) : "");
	        	}
	        	result.add(m);
	        }
		}
		return result;
	}


	/**
	 * ���� ��� List�� ��� ��ȯ�Ѵ�.
	 * �÷��� Map�� Map��
	 *
	 * @param rst
	 * @return
	 * @throws java.sql.SQLException
	 */
	public int getTotalCnt(ResultSet rst) throws SQLException{
		int totCnt = 0;
		if(rst != null){
	        while(rst.next()){
	        	totCnt = rst.getInt(1);
	        }
		}
		return totCnt;
	}


	/**
	 * ���� ��� Map�� ��ȯ�Ѵ�.
	 * ���� ��� ��ȯ�ϴ� ��츸 ��ȿ�ϴ�.
	 *
	 * @param rst
	 * @return
	 * @throws java.sql.SQLException
	 */
	public Map getMap(ResultSet rst) throws SQLException{
		Map result = null;
		if(rst != null){
	        String [] colNames = null;
	        
	        if(rst.next()){
	        	if(colNames == null){
	        		ResultSetMetaData meta = rst.getMetaData();
	        		colNames = getResultSetMetaData(meta);
	        	}
	        	
	        	result = new HashMap();
	        	for(int i = 0; i < colNames.length; i++){
	        		result.put(colNames[i], rst.getString(colNames[i]) != null ? rst.getString(colNames[i]) : "");    		
	        	}
	        }
		}
		return result;
	}
}


