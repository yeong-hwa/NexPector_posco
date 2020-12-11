package com.nns.nexpector.dashboard.action;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.ComStr;

/**
 * DASHBOARD() SYSTEM 정보 조회 <br>
 * Controller <br>
 *
 */
@Controller
@RequestMapping("/dashboard/*")
public class DashMainSystemController {

	/**
	 * Logger
	 */
	private static Logger logger = LoggerFactory.getLogger(DashMainSystemController.class);

	/**
	 * Service CommonServices
	 */
	@Autowired
	private CommonServices commonServices;
	
	/**
	 * session HttpSession 
	 */
	@Autowired
	private HttpSession sess;

	/**
	 * applicationContext bean
	 */
	@Autowired
	private View jsonView;

	@RequestMapping("/dash_system_info")
	public String getLoginPage(){
		return "/dash/dash_system_info";
	}
	
	private void addParam(Map<String, Object> param)
	{
		param.put("SESSION_USER_ID", sess.getAttribute("S_USER_ID"));
		// param.put("ERR_SEARCH_TYPE", param.get("errSearchType"));
	}

	/**
	 * DASHBOARD SYSTEM 기본 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param res
	 * @return jsonView
	 */
	@SuppressWarnings({ "unchecked" })
	@RequestMapping("/ajax_system_info")
	public View getDefaultInfo(ModelMap modelMap, @RequestParam Map<String, Object> param, HttpServletRequest req, HttpServletResponse res) {
		addParam(param);
		try {
			Map<String, Object>		qry_params = new HashMap<String, Object>();
			
			/* 전국 전화기 현황 */
			List<Map<String, Object>>	almTotalList	= commonServices.getList("jijum.phone_alm_total_list_qry", param);
			modelMap.addAttribute("ALM_TOTAL_LIST", almTotalList);
			
			qry_params.put("PHONE_GUBUN", param.get("PHONE_GUBUN"));
			/* 전화기 장애 현황 */
			List<Map<String, Object>>	callStatusList = commonServices.getList("dash_system.select_system_mid_info", qry_params);
			modelMap.addAttribute("NATIONAL_CALL_STATUS", callStatusList);
			
			/* 시스템 장애 현황 */
			List<Map<String, Object>>	systemErrStatus = commonServices.getList("dash_system.select_system_err_status", qry_params);
			modelMap.addAttribute("SYSTEM_ERR_STATUS", systemErrStatus);
			
			/* 시스템 장애 현황 상세 */
			List<Map<String, Object>>	systemErrList = commonServices.getList("dash_system.select_system_err_list", qry_params);
			modelMap.addAttribute("SYSTEM_ERR_LIST", systemErrList);
			
			/* 주의, 경고, 장애 */
			List<Map<String, Object>>	almErrCountList	= commonServices.getList("dash_system.select_alm_err_count", qry_params);
			modelMap.addAttribute("ALM_ERR_LIST", almErrCountList);
			
			/* 장비 건수 */
			Map<String, Object>	monTotCountMap		= commonServices.getMap("dash_system.select_mon_tot_count", qry_params);
			int nTotCount	= 0;
			if (monTotCountMap != null) {
				nTotCount	= ComStr.toInt(monTotCountMap.get("N_MON_TOT_COUNT"));
			}
			modelMap.addAttribute("MON_TOT_COUNT",	nTotCount);
			
			/* 장비 장애 건수 */
			Map<String, Object>	monErrCountMap		= commonServices.getMap("dash_system.select_mon_err_count", qry_params);
			int nErrCount	= 0;
			if (monErrCountMap != null) {
				nErrCount	= ComStr.toInt(monErrCountMap.get("N_MON_ERR_COUNT"));
			}
			modelMap.addAttribute("MON_ERR_COUNT",	nErrCount);

			/* refresh 주기 */
			param.put("N_INTERVAL_TYPE", 0);
			Map<String, Object>			intervalInfo = commonServices.getMap("dashboard_interval.selectDashboardIntervalData", param);
			if (intervalInfo == null) {
				intervalInfo = new HashMap<String, Object>();
				intervalInfo.put("N_INTERVAL_TIME", 10);
			}
			modelMap.addAttribute("INTERVAL_INFO", intervalInfo);

			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}

	@SuppressWarnings("unchecked")
	@RequestMapping("/get_dash_inter_page_time")
	public View getDashInterPageTime(ModelMap modelMap, @RequestParam Map<String, Object> param, HttpServletRequest req, HttpServletResponse res) {
		try {
			String sessionUserId = (String) param.get("SESSION_USER_ID");
			String sUrl = (String) param.get("S_URL");
			String nIntervalType = (String) param.get("N_INTERVAL_TYPE");
			
			System.out.println("get_dash_inter_page_time sessionUserId : " + sessionUserId);
			System.out.println("get_dash_inter_page_time sUrl : " + sUrl);
			System.out.println("get_dash_inter_page_time nIntervalType : " + nIntervalType);
			
			param.put("SESSION_USER_ID", "SA");
			param.put("S_URL", sUrl);
			param.put("N_INTERVAL_TYPE", Integer.parseInt(nIntervalType));
			
			Map<String, Object> pageInfo = commonServices.getMap("dashboard_interval.selectDashboardInterPageTime", param);
			if(pageInfo == null) {
				pageInfo = new HashMap<String, Object>();
				pageInfo.put("N_PAGE_TIME", 15000);
			}
			
			modelMap.put("PAGE_INFO", pageInfo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		return jsonView;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/set_dash_inter_page_time")
	public View setDashInterPageTime(ModelMap modelMap, @RequestParam Map<String, Object> param, HttpServletRequest req, HttpServletResponse res) {
		try {
			String sessionUserId = (String) param.get("SESSION_USER_ID");
			String sUrl = (String) param.get("S_URL");
			String nIntervalType = (String) param.get("N_INTERVAL_TYPE");
			
			param.put("SESSION_USER_ID", "SA");
			param.put("S_URL", sUrl);
			param.put("N_INTERVAL_TYPE", Integer.parseInt(nIntervalType));
			
			Map<String, Object> pageInfo = commonServices.getMap("dashboard_interval.updateIntervalInfo", param);
			
			if(pageInfo == null) {
				pageInfo = new HashMap<String, Object>();
				pageInfo.put("N_PAGE_TIME", 15000);
			}
			
			modelMap.put("PAGE_INFO", pageInfo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		return jsonView;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/get_dash_inter_refresh_time")
	public View getDashInterRefreshTime(ModelMap modelMap, @RequestParam Map<String, Object> param, HttpServletRequest req, HttpServletResponse res) {
		try {
			String sessionUserId = (String) param.get("SESSION_USER_ID");
			String sUrl = (String) param.get("S_URL");
			String nIntervalType = (String) param.get("N_INTERVAL_TYPE");
			
			System.out.println("get_dash_inter_refresh_time sessionUserId : " + sessionUserId);
			System.out.println("get_dash_inter_refresh_time sUrl : " + sUrl);
			System.out.println("get_dash_inter_refresh_time nIntervalType : " + nIntervalType);
			
			param.put("SESSION_USER_ID", "SA");
			param.put("S_URL", sUrl);
			param.put("N_INTERVAL_TYPE", Integer.parseInt(nIntervalType));
			
			Map<String, Object> pageInfo = commonServices.getMap("dashboard_interval.selectDashboardInterRefreshTime", param);
			if(pageInfo == null) {
				pageInfo = new HashMap<String, Object>();
				pageInfo.put("N_REFRESH_TIME", 5000);
			}
			
			modelMap.put("REFRESH_INFO", pageInfo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		return jsonView;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("/set_dash_inter_refresh_time")
	public View setDashInterRefreshTime(ModelMap modelMap, @RequestParam Map<String, Object> param, HttpServletRequest req, HttpServletResponse res) {
		try {
			String sessionUserId = (String) param.get("SESSION_USER_ID");
			String sUrl = (String) param.get("S_URL");
			String nIntervalType = (String) param.get("N_INTERVAL_TYPE");
			
			param.put("SESSION_USER_ID", "SA");
			param.put("S_URL", sUrl);
			param.put("N_INTERVAL_TYPE", Integer.parseInt(nIntervalType));
			
			Map<String, Object> pageInfo = commonServices.getMap("dashboard_interval.updateRefreshInfo", param);
			
			if(pageInfo == null) {
				pageInfo = new HashMap<String, Object>();
				pageInfo.put("N_REFRESH_TIME", 5000);
			}
			
			modelMap.put("REFRESH_INFO", pageInfo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		return jsonView;
	}
}
