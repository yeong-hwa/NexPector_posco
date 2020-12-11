package com.nns.nexpector.common.service;

import com.nns.nexpector.common.dao.CommonDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

;

/**
 * <pre>
 * com.nns.gimjeSE.common.service
 * CommonServices.java
 * </pre>
 *
 * @author	: yongpal
 * @Date		: 2013. 2. 4.
 * @Version	:
 * @category :
 */
@Service
public class CommonServices {

	@Autowired
	private CommonDao dao;

	public CommonDao getDao() {
		return dao;
	}

	public void setDao(CommonDao dao) {
		this.dao = dao;
	}

	private static final Logger logger = LoggerFactory.getLogger(CommonServices.class);

	public List getList(String qry_name, Map param) throws Exception{
		return dao.getSelectList(qry_name, param);
	}

	public List getList(String qry_name, Object param) throws Exception{
		return dao.getSelectList(qry_name, param);
	}

	public Map getMap(String qry_name, Map param) throws Exception{
		return dao.getSelectOne(qry_name, param);
	}

	public Object getObject(String qry_name, Object Param) {
		return dao.getSelectOne(qry_name, Param);
	}

	public Map getPageData(String qry_name, Map param) throws Exception{
		return dao.getPageSelectList(qry_name, param);
	}

	public int getInsData(String qry_name, Map param) throws Exception{
		return dao.getInsData(qry_name, param);
	}

	public int getUpdData(String qry_name, Map param) throws Exception{
		return dao.getUpdData(qry_name, param);
	}

	public int getDelData(String qry_name, Map param) throws Exception{
		return dao.getDelData(qry_name, param);
	}

	public int multiTransaction(String qry_lst, Map param) throws Exception{
		return dao.MultiTransaction(qry_lst, param);
	}
}