package com.nns.common.session;

import java.util.HashMap;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.nns.common.constants.ChangeHistoryConstants;
import com.nns.common.constants.LoginStateConstant;
import com.nns.common.util.WebUtil;
import com.nns.nexpector.common.service.CommonServices;

public class SessionListener implements HttpSessionListener {

	private static final Logger logger = LoggerFactory.getLogger(SessionListener.class);
	
	@Autowired
	private CommonServices service;

	@Override
	public void sessionCreated(HttpSessionEvent se) {
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {	
		try {
			String S_USER_ID = (String)se.getSession().getAttribute("S_USER_ID");

			String ipAddress = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes())
					.getRequest().getRemoteAddr();
			
			HashMap<String, Object> historyMap = new HashMap<String, Object>();
			
			historyMap.put("S_USER_ID", S_USER_ID);
			historyMap.put("S_TARGE_USER", S_USER_ID);
			historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.LOGIN_LOGOUT_EVEVT_TYPE);
			historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.LOGOUT_EVENT_DATA);
			historyMap.put("S_DATA", S_USER_ID + " | IP Address: " + ipAddress);
			
	       	HashMap<String, Object> loginStateMap = new HashMap<String, Object>();
	       	
	    	loginStateMap.put("S_USER_ID", S_USER_ID);
	    	loginStateMap.put("N_STATE", LoginStateConstant.LOGOUT);
	    	
			service.getInsData("change_history.insert_history", historyMap);
			service.getUpdData("user_state.update_login_state", loginStateMap);

		} catch (Exception e) {
			logger.error(e.getMessage());
		}

	}
}
