package com.nns.common;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

import com.nns.nexpector.common.service.CommonServices;

public class QuartzJob extends QuartzJobBean {

	// @Autowired doesn`t work in QuartzJobBean	
	private CommonServices service;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Override
	protected void executeInternal(JobExecutionContext arg0) throws JobExecutionException {
		try {
		    ApplicationContext applicationContext = (ApplicationContext) arg0.getScheduler().getContext().get("applicationContext");
		    service = applicationContext.getBean(CommonServices.class);

		    Integer cntOldTbAlm = 0;
		    Integer cntOldTbAlmHistory = 0;
		    Integer cntOldTbMonAccrueResource = 0;
		    Integer cntOldTbCliPbxTrafficTrunkAvg = 0;
		    
		    for (; (cntOldTbAlm = (Integer) service.getObject("batch.cntTbAlm", null)) > 0;) {
		    	logger.debug("old TB_ALM data deleted count: " + cntOldTbAlm);
		    	service.getDelData("batch.deleteTbAlm", null);
		    }

		    for (; (cntOldTbAlmHistory = (Integer) service.getObject("batch.cntTbAlmHistory", null)) > 0;) {
		    	logger.debug("old TB_ALM_HISTORY data deleted count: " + cntOldTbAlmHistory);
		    	service.getDelData("batch.deleteTbAlmHistory", null);
		    }

		    for (; (cntOldTbMonAccrueResource = (Integer) service.getObject("batch.cntTbMonAccrueResource", null)) > 0;) {
		    	logger.debug("old TB_MON_ACCRUE_RESOURCE data deleted count: " + cntOldTbMonAccrueResource);
		    	service.getDelData("batch.deleteTbMonAccrueResource", null);
		    }
		    
		    for (; (cntOldTbCliPbxTrafficTrunkAvg = (Integer) service.getObject("batch.cntTbCliPbxTrafficTrunkAvg", null)) > 0;) {
		    	logger.debug("old TB_CLI_PBX_TRAFFIC_TRUNK_AVG data deleted count: " + cntOldTbCliPbxTrafficTrunkAvg);
		    	service.getDelData("batch.deleteTbCliPbxTrafficTrunkAvg", null);
		    }
		    
		} catch (Exception e) {
			logger.debug("alarm data delete fail");
			e.printStackTrace();
		}
	}

}
