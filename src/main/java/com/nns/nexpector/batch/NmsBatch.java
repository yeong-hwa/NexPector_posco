package com.nns.nexpector.batch;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

import java.sql.SQLException;

public class NmsBatch extends QuartzJobBean {

    /** Logger */
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    private static final String APPLICATION_CONTEXT_KEY = "applicationContext";

    @Override
    protected void executeInternal(JobExecutionContext context) throws JobExecutionException {
        ApplicationContext appCtx;
        try {
            appCtx = getApplicationContext(context);
        } catch (Exception e) {
            logger.error("Error!!", e);
            return;
        }
        SqlSession session;
        SqlSessionFactory sf = (SqlSessionFactory) appCtx.getBean("sqlSessionFactory");
        session = sf.openSession();
        try {
            session.getConnection().setAutoCommit(false);

            if ((Integer) session.selectOne("batch.selectEmpTempCount") > 0) {
                session.delete("batch.deleteEmpInfo");
                session.update("batch.insertEmpInfo");
                session.delete("batch.deleteEmpTemp");
            }

            if ((Integer) session.selectOne("batch.selectOrgTempCount") > 0) {
                session.delete("batch.deleteOrgInfo");
                session.update("batch.insertOrgInfo");
                session.delete("batch.deleteOrgTemp");
            }

            session.commit();
        } catch(Exception e) {
            logger.error("Emp Batch Error!!", e);
            session.rollback();
        } finally{
            try {
                session.getConnection().setAutoCommit(true);
            } catch (SQLException e) {} finally {
                if(session != null) session.close();
            }
        }

        logger.info("Emp, Org Info Job Schedule Success!!");
    }

    private ApplicationContext getApplicationContext(JobExecutionContext context ) throws Exception {
        ApplicationContext appCtx;
        appCtx = (ApplicationContext)context.getScheduler().getContext().get(APPLICATION_CONTEXT_KEY);
        if (appCtx == null) {
            throw new JobExecutionException(
                    "No application context available in scheduler context for key \"" + APPLICATION_CONTEXT_KEY + "\"");
        }
        return appCtx;
    }
}
