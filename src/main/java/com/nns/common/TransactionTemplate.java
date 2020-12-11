package com.nns.common;

import com.nns.nexpector.common.dao.CommonDao;
import com.nns.nexpector.common.service.CommonServices;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.stereotype.Component;

@Component
public class TransactionTemplate {

    public void template(CommonServices service, Process process) throws Exception {
        CommonDao dao = service.getDao();
        SqlSessionFactory sf = dao.getSqlSessionFactory();
        SqlSession session = null;

        try {
            session = sf.openSession();
            session.getConnection().setAutoCommit(false);

            process.execute(session);

            session.commit();
        }
        catch(Exception e) {
            session.rollback();
            throw e;
        }
        finally {
            session.getConnection().setAutoCommit(true);
            if (session != null) {
                session.close();
            }
        }
    }


}
