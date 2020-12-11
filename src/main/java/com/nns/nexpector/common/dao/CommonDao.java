
package com.nns.nexpector.common.dao;

import org.apache.ibatis.jdbc.SqlRunner;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * com.nns.gimjeSE.common.dao
 * CommonDao.java
 * </pre>
 *
 * @author	: yongpal
 * @Date	: 2013. 2. 4.
 * @Version	:
 * @category :
 */
@Repository
@SuppressWarnings("unchecked")
public class CommonDao {

	@SuppressWarnings("unused")
	private Logger logger;

	@Autowired
	private SqlSession mapper;

	@Autowired
	private SqlSessionFactory sf;

	public SqlSessionFactory getSqlSessionFactory() {
		return sf;
	}

	public void setSqlSessionFactory(SqlSessionFactory sf) {
		this.sf = sf;
	}

	/**
	 *
	 */
	public CommonDao() {
		// TODO Auto-generated constructor stub
		logger = LoggerFactory.getLogger(CommonDao.class);
	}

	public List getTestSelect() throws SQLException {
		// TODO Auto-generated method stub
//		return (List)sqlMapClient.queryForList("monitor.select");
		return mapper.selectList("monitor.select");

	}

	public List getSelectList(String qry_name, Map param) throws Exception {
		// TODO Auto-generated method stub
		return mapper.selectList(qry_name, param);
	}

	public List getSelectList(String qry_name, Object param) {
		return mapper.selectList(qry_name, param);
	}

	public Map getSelectOne(String qry_name, Map param) throws Exception {
		// TODO Auto-generated method stub
		return (Map)mapper.selectOne(qry_name, param);
	}

	public Object getSelectOne(String qry_name, Object param) {
		return mapper.selectOne(qry_name, param);
	}

	public Map getPageSelectList(String qry_name, Map param) throws Exception
	{
		SqlSession session = null;
		StringBuffer page_qry = new StringBuffer();
		StringBuffer cnt_qry = new StringBuffer();

		Object[] page_param = null;
		Object[] cnt_param = null;

		Map result_map = new HashMap();
		try{
			MappedStatement prefix_ms = mapper.getConfiguration().getMappedStatement("page_prefix");
			MappedStatement qry_ms = mapper.getConfiguration().getMappedStatement(qry_name);
			MappedStatement suffix_ms = mapper.getConfiguration().getMappedStatement("page_suffix");

			List pre_param = prefix_ms.getBoundSql(param).getParameterMappings();
			List qry_param = qry_ms.getBoundSql(param).getParameterMappings();
			List suf_param = suffix_ms.getBoundSql(param).getParameterMappings();

			page_param = new Object[pre_param.size()+suf_param.size()+qry_param.size()];

			int arr_num = 0;
			for(int i=0;i<pre_param.size();i++)
			{
				String key = ((ParameterMapping)pre_param.get(i)).getProperty();
				page_param[arr_num++] = param.get(key);
			}

			for(int i=0;i<qry_param.size();i++)
			{
				String key = ((ParameterMapping)qry_param.get(i)).getProperty();
				page_param[arr_num++] = param.get(key);
			}

			for(int i=0;i<suf_param.size();i++)
			{
				String key = ((ParameterMapping)suf_param.get(i)).getProperty();
				page_param[arr_num++] = param.get(key);
			}

			page_qry.append(prefix_ms.getBoundSql(param).getSql());
			page_qry.append(qry_ms.getBoundSql(param).getSql());
			page_qry.append(suffix_ms.getBoundSql(param).getSql());

			prefix_ms = mapper.getConfiguration().getMappedStatement("cnt_prefix");
			qry_ms = mapper.getConfiguration().getMappedStatement(qry_name);
			suffix_ms = mapper.getConfiguration().getMappedStatement("cnt_suffix");

			pre_param = prefix_ms.getBoundSql(param).getParameterMappings();
			qry_param = qry_ms.getBoundSql(param).getParameterMappings();
			suf_param = suffix_ms.getBoundSql(param).getParameterMappings();

			cnt_param = new Object[pre_param.size()+suf_param.size()+qry_param.size()];

			arr_num = 0;
			for(int i=0;i<pre_param.size();i++)
			{
				String key = ((ParameterMapping)pre_param.get(i)).getProperty();

				cnt_param[arr_num++] = param.get(key);
			}

			for(int i=0;i<qry_param.size();i++)
			{
				String key = ((ParameterMapping)qry_param.get(i)).getProperty();

				cnt_param[arr_num++] = param.get(key);
			}

			for(int i=0;i<suf_param.size();i++)
			{
				String key = ((ParameterMapping)suf_param.get(i)).getProperty();

				cnt_param[arr_num++] = param.get(key);
			}

			cnt_qry.append(prefix_ms.getBoundSql(param).getSql());
			cnt_qry.append(qry_ms.getBoundSql(param).getSql());
			cnt_qry.append(suffix_ms.getBoundSql(param).getSql());

			session = sf.openSession();
			SqlRunner sr = new SqlRunner(session.getConnection());

			result_map.put("data", sr.selectAll(page_qry.toString(), page_param));
			result_map.put("cnt", ((Map)sr.selectOne(cnt_qry.toString(), cnt_param)).get("CNT").toString());

		}catch(SQLException se){
			se.printStackTrace();
			String tmp = "";

			for(int i=0;i<page_param.length;i++)
			{
				if(page_param[0] != null)
					tmp += page_param[0].toString() + ((i==page_param.length-1)?"":", ");
			}
			logger.error("Fail Param : " + tmp);
			logger.error("Fail Query : " + page_qry.toString());

			tmp = "";
			for(int i=0;i<cnt_param.length;i++)
			{
				if(cnt_param[0] != null)
					tmp += cnt_param[0].toString() + ((i==cnt_param.length-1)?"":", ");
			}
			logger.error("Fail Param : " + tmp);
			logger.error("Fail Query : " + cnt_qry.toString());
			throw se;
		}catch(IllegalArgumentException ie){
			ie.printStackTrace();
			logger.error("Fail query_name : " + qry_name);
			throw ie;
		}catch(Exception e){
			e.printStackTrace();
			logger.error("Fail query_name : " + qry_name);
			logger.error("Fail Param : " + param);
			throw e;
		}finally{
			if(session != null) session.close();
		}

		return result_map;
	}


	public int getInsData(String qry_name, Map param) throws Exception
	{
		return mapper.insert(qry_name, param);
	}

	public int getUpdData(String qry_name, Map param) throws Exception
	{
		return mapper.update(qry_name, param);
	}

	public int getDelData(String qry_name, Map param) throws Exception
	{
		return mapper.delete(qry_name, param);
	}

	public int MultiTransaction(String qry_lst, Map param) throws Exception
	{
		SqlSession session = null;
		int rslt = -1;
		try{
			session = sf.openSession();
			session.getConnection().setAutoCommit(false);
			String[] tmp_arr1 = qry_lst.split(";");

			for(int i=0;i<tmp_arr1.length;i++)
			{
				if(tmp_arr1[i] == null) continue;
				String[] tmp_arr2 = tmp_arr1[i].split("::");

				if(tmp_arr2 == null) continue;
				if(tmp_arr2.length == 0) continue;

				if(tmp_arr2.length == 1)
				{
					session.update(tmp_arr2[0], param);
				}
				else if(tmp_arr2.length > 1)
				{
					if(tmp_arr2[0].equals("ins")){
						if(tmp_arr2[1].length() > 0) session.insert(tmp_arr2[1], param);
					}
					if(tmp_arr2[0].equals("upd")){
						if(tmp_arr2[1].length() > 0) session.update(tmp_arr2[1], param);
					}
					if(tmp_arr2[0].equals("del")){
						if(tmp_arr2[1].length() > 0) session.delete(tmp_arr2[1], param);
					}
				}
			}
			rslt = 1;
			session.commit();
		}catch(Exception e){
			rslt = -1;
			session.rollback();
			throw e;
		}finally{
			session.getConnection().setAutoCommit(true);
			if(session != null) session.close();
		}

		return rslt;
	}
}
