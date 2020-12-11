package com.nns.nexpector.dashboard.action;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
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

/**
 * DASHBOARD SYSTEM 정보 조회 <br>
 * Controller <br>
 *
 */
@Controller
@RequestMapping("/dashboard/*")
public class DashBoardNetworkController {

	/**
	 * Logger
	 */
	private static Logger logger = LoggerFactory.getLogger(DashBoardNetworkController.class);

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

	@RequestMapping("dashboard_network_info")
	public String getLoginPage(){
		return "/dashboard/dashboard_network_info";
	}
	
	private void addParam(Map<String, Object> param)
	{
		param.put("SESSION_USER_ID", sess.getAttribute("S_USER_ID"));
        param.put("ERR_SEARCH_TYPE", param.get("errSearchType"));
	}

	@SuppressWarnings({ "unchecked" })
	@RequestMapping("/network_info")
	public View callSystemPage(ModelMap modelMap, @RequestParam Map<String, Object> param, HttpServletRequest request) {
		addParam(param);
		// getRequestInfo(request, param);
		try {
            // 시스템 장비 현황
            List<Map<String, Object>> systemDiagram = commonServices.getList("dashboardMap", param);
            modelMap.addAttribute("NETWORK_MAP", systemDiagram);
            
			/* 사용률 Top10 (CPU) */
			param.put("N_MON_TYPE", 0);
			List<Map<String, Object>> cpuChartTop10 = commonServices.getList("NetworkUsingTop10Qty", param);
			modelMap.addAttribute("CPU_USING_RATIO",cpuChartTop10);
			
			/* 사용률 Top10 (Memory) */
			param.put("N_MON_TYPE", 1);
			List<Map<String, Object>> memoryChartTop10 = commonServices.getList("NetworkUsingTop10Qty", param);
			modelMap.addAttribute("MEMORY_USING_RATIO",memoryChartTop10);

			/* 사용률 Top10 (Disk) */
			param.put("N_MON_TYPE", 2);
			List<Map<String, Object>> diskChartTop10 = commonServices.getList("NetworkUsingTop10Qty", param);
			modelMap.addAttribute("DISK_USING_RATIO",diskChartTop10);
            
            // Error 현황
            List<Map<String, Object>> systemErrorStatus = commonServices.getList("dashboardSystemErrorStatus", param);
            modelMap.addAttribute("NETWORK_ERROR_STATUS", systemErrorStatus);

			List<Map<String, Object>> intervalInfo = commonServices.getList("selectDashboardIntervalQry", param);
			modelMap.addAttribute("INTERVAL_INFO", intervalInfo);

			List<Map<String, Object>> snmpManagerCheckInfo = commonServices.getList("selectSnmpManagerCheckQry", param);
			modelMap.addAttribute("SNMPMANAGER_CHECK", snmpManagerCheckInfo);
				
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;
	}
	
/*	private void getRequestInfo(HttpServletRequest req, Map<String, Object> param) {
		String url = req.getRequestURI();
		param.put("S_URL", url);
    }*/
}
