package com.nns.util;

import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

/**
 * 
 * #value-name# �� ����ϴ� ������ �м��Ͽ�, Map���� ���� �Ķ���Ϳ� �����Ѵ�.
 * SimpleQuery�� ����ϱ� ����� ���¿� ������� �����ϰ� �Ѵ�.
 * 
 * 
 * 
 * @author fishingday
 *
 */
public class ParseQuery{
	
	final static public String token = "#";
	final static public String binding = " ? ";
	final static private String PREFIX = "SELECT * FROM (SELECT ROWNUM AS NUM, PAGEQUERY.* FROM ( ";
	final static private String SUFFIX = ") PAGEQUERY ) WHERE NUM < #stop_num# AND NUM >= #start_num#";	
	final static public int DefaultPageSize = 15;
	
	final static private boolean isPrinting =  true;
	
	protected StringBuffer parseSql;
	protected StringBuffer printSql;
	protected String [] param;
		
	public ParseQuery(String sqlstr, Map map) throws Exception{
		parseQuery(sqlstr, map);
	}
	
	/**
	 * ������ �߰��Ͽ� ����¡ ������ �����Ѵ�. (do not use JDBC 2.0)
	 * 
	 * @param sqlstr ����
	 * @param map �Ķ����
	 * @param pageSize �������� ��µ� item ����
	 * @param pageNum ����� ������ ��ȣ
	 * @throws Exception 
	 * @throws IllegalFormatQueryException
	 */
	public ParseQuery(String sqlstr, Map map, int pageSize, int pageNum) throws Exception {
		parseQuery(sqlstr, map, pageSize, pageNum);
	}
	
	
	/**
	 * ������ �߰��Ͽ� ����¡ ������ �����Ѵ�. (do not use JDBC 2.0)
	 * 
	 * @param sqlstr ����
	 * @param map �Ķ����
	 * @param pageSize �������� ��µ� item ����
	 * @param pageNum ����� ������ ��ȣ
	 * @throws Exception 
	 * @throws IllegalFormatQueryException
	 */
	private void parseQuery(String sqlstr, Map map, int pageSize, int pageNum) throws Exception{
		
		// �ϴ� �⺻ ������ ũ��� 15! 0���� ���� �� ���.
		if(pageSize <= 0){
			pageSize = DefaultPageSize;
		}
		
		// pageNum = 1, pageSize = 15 / start_num = 1, end_num = 16
        //	pageNum = 2, pageSize = 15 / start_num = 16, end_num = 31
		// pageNum = 3, pageSize = 15 / start_num = 31, end_num = 46
		int stop_num = ((pageNum + 1)* pageSize) + 1;
		int start_num = stop_num - pageSize;
		
		if(map == null) map = new HashMap();
		
		map.put("start_num", String.valueOf(start_num));
		map.put("stop_num", String.valueOf(stop_num));
		
		parseQuery(new StringBuffer(PREFIX).append(sqlstr).append(SUFFIX).toString(), map);
	}
	
	/**
	 * ������ �м��Ͽ� ���ε� ������ �Ķ���͸�  �����Ѵ�.
	 * 
	 * @param sqlstr ����
	 * @param map �Ķ����
	 * @throws Exception 
	 * @throws IllegalFormatQueryException
	 */
	private void parseQuery(String sqlstr, Map map) throws Exception{
		if(map == null){
			this.parseSql = new StringBuffer(sqlstr);
			this.printSql = parseSql;
		}
		
		Vector v = null;
		for(int pos = sqlstr.indexOf(token);true;){
			int begin = 0, end = 0;
			
			begin = sqlstr.indexOf(token, pos);			
			if(pos < 0 || begin < 0){
				
				if(pos == -1){ // #�� �߰� ���� �ʾҴ�.
					parseSql = new StringBuffer(sqlstr);
					if(isPrinting){
						printSql = new StringBuffer(sqlstr);
					}					
				}else if(pos < sqlstr.length()){ // �Ľ��� �������� ������ ���ڰ� �ִٸ�...
					parseSql.append(sqlstr.substring(pos));
					if(isPrinting){
						printSql.append(sqlstr.substring(pos));
					}	
				}
				
				break;
			}
			end = sqlstr.indexOf(token, begin +1);
			if(end < 0){
				throw new Exception("������ �ùٸ��� �ʾ� �м��� �� ����ϴ�. : " + sqlstr);
			}
			
			if(pos == begin){
				parseSql = new StringBuffer(sqlstr.substring(0, begin));
				parseSql.append(binding);
				String key = sqlstr.substring(begin +1, end);
				v = new Vector();
				
				Object o = map.get(key);
				v.add(o != null ? o : "");
				
				if(isPrinting){
					printSql = new StringBuffer(sqlstr.substring(0, begin));
					printSql.append("'" + map.get(key) + "'");
				}
				
				if(sqlstr.length() >  end+1){
					pos = end+1;
				}else{
					break;
				}
			}else{
				parseSql.append(sqlstr.substring(pos, begin));
				parseSql.append(binding);
				String key = sqlstr.substring(begin +1, end);
				
				Object o = map.get(key);
				v.add(o != null ? o : "");
				
				if(isPrinting){
					printSql.append(sqlstr.substring(pos, begin));
					printSql.append("'" + map.get(key) + "'");
				}
				
				if(sqlstr.length() >  end+1){
					pos = end+1;
				}else{
					break;
				}
			}
		}
		
		
		if(v != null && v.size() > 0){
			param = new String[v.size()];
			v.copyInto(param);
		}
		
		if(isPrinting){
			//System.out.println(parseSql.toString());
			System.out.println(printSql.toString());
		}		
	}

	public String getParseSql() {
		return parseSql.toString();
	}

	public String[] getParam() {
		return param;
	}
	
	public String getParam(int i) {
		return param[i];
	}

	public void setParam(String[] param) {
		this.param = param;
	}
}
