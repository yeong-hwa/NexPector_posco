package com.nns.common.util.excel;

import com.nns.nexpector.common.dao.CommonDao;
import com.nns.nexpector.common.service.CommonServices;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import java.util.List;
import java.util.Map;

public class AdminFileDao {

	public static void insertIpPhone(CommonServices commonServices, List<Map<String, String>> listData) throws Exception {

		CommonDao dao = commonServices.getDao();
		SqlSessionFactory sf = dao.getSqlSessionFactory();

		SqlSession session = null;
		try {
			session = sf.openSession();
			session.getConnection().setAutoCommit(false);

			session.delete("ipphone_file_delete");

			for (int i = 0; i < listData.size(); i++) {
				session.insert("ipphone_file_import", listData.get(i));
			}

			session.commit();

		} catch (Exception e) {
			session.rollback();
			throw e;

		} finally {
			session.getConnection().setAutoCommit(true);
			if (session != null) {
				session.close();
			}
		}
	}
	
	public static void insertJijum(CommonServices commonServices, List<Map<String, String>> listData) throws Exception {

		CommonDao dao = commonServices.getDao();
		SqlSessionFactory sf = dao.getSqlSessionFactory();

		SqlSession session = null;
		try {
			session = sf.openSession();
			session.getConnection().setAutoCommit(false);

			session.delete("jijum_file_delete");

			for (int i = 0; i < listData.size(); i++) {
				session.insert("jijum_file_import", listData.get(i));
			}

			session.commit();

		} catch (Exception e) {
			session.rollback();
			throw e;

		} finally {
			session.getConnection().setAutoCommit(true);
			if (session != null) {
				session.close();
			}
		}
	}
}
