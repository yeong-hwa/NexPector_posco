package com.nns.nexpector.dashboard.action;

import com.nns.nexpector.common.service.CommonServices;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * DASHBOARD SYSTEM 정보 조회 <br>
 * Controller <br>
 *
 */
@Controller
@RequestMapping("/dashboard/*")
public class DashBoardSystemController {

	/**
	 * Logger
	 */
	private static Logger logger = LoggerFactory.getLogger(DashBoardSystemController.class);

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

	@RequestMapping("/dashboard_system_info")
	public String getLoginPage(){
		return "/dashboard/dashboard_system_info";
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
	@RequestMapping("/system_info")
	public View getDefaultInfo(ModelMap modelMap, @RequestParam Map<String, Object> param, HttpServletRequest req, HttpServletResponse res) {
		addParam(param);
        // getRequestInfo(req, param);
		try {
			/* 사용률 Top10 (CPU) */
			param.put("N_MON_TYPE", 0);
			List<Map<String, Object>> cpuChartTop10 = commonServices.getList("SystemUsingTop10Qty", param);
			modelMap.addAttribute("CPU_USING_RATIO",cpuChartTop10);
			
			/* 사용률 Top10 (Memory) */
			param.put("N_MON_TYPE", 1);
			List<Map<String, Object>> memoryChartTop10 = commonServices.getList("SystemUsingTop10Qty", param);
			modelMap.addAttribute("MEMORY_USING_RATIO",memoryChartTop10);

			/* 사용률 Top10 (Disk) */
			param.put("N_MON_TYPE", 2);
			List<Map<String, Object>> diskChartTop10 = commonServices.getList("SystemUsingTop10Qty", param);
			modelMap.addAttribute("DISK_USING_RATIO",diskChartTop10);
			
			/* SYSTEM 장애 리스트 */
			List<Map<String, Object>> osErrorLst = commonServices.getList("SystemErrorQry", param);
			modelMap.addAttribute("SYSTEM_ERRORLST",osErrorLst);
			
			/* 콜 현황 */
			modelMap.put("pbxServiceCurrentUse", commonServices.getMap("realtime_status.centerPbxServiceCurrentUseInfo", null));
			modelMap.put("pbxServiceAvgUse", commonServices.getMap("realtime_status.centerPbxServiceAvgUseInfo", null));
			modelMap.put("pbxServiceCurrentMaxUse", commonServices.getMap("realtime_status.centerPbxServiceCurrentMaxUseInfo", null));
			
			modelMap.put("dashServiceCurrentUse", commonServices.getMap("realtime_status.centerCurrentServiceUseInfo", null));
			modelMap.put("dashServiceAvgUse", commonServices.getMap("realtime_status.centerAvgServiceUseInfo", null));
			
			modelMap.put("callCurrentUse", commonServices.getMap("realtime_status.centerCallCurrentUseInfo", null));
			modelMap.put("callAvgUse", commonServices.getMap("realtime_status.centerCallAvgUseInfo", null));
			
			modelMap.put("recCurrentUse", commonServices.getMap("realtime_status.centerRecCurrentUseInfo", null));
			modelMap.put("recAvgUse", commonServices.getMap("realtime_status.centerRecAvgUseInfo", null));
			
			modelMap.addAttribute("centerConnect", commonServices.getMap("realtime_status.centerConnectInfo", null));

			/* SYSTEM 전체 장비 개수 */
			modelMap.addAttribute("SYSTEM_TOTAL_CNT", commonServices.getMap("SystemTotalCntQry", param));
			/* SYSTEM 장비 개수 */
			modelMap.addAttribute("SYSTEM_MON_CNT", commonServices.getList("SystemTypeMonCntQry", param));
			/* SYTEM 알람 개수 */
			modelMap.addAttribute("SYSTEM_ALM_CNT", commonServices.getList("SystemTypeAlmCntQry", param));
			/* refresh 주기 */
			List<Map<String, Object>> intervalInfo = commonServices.getList("selectDashboardIntervalQry", param);
			modelMap.addAttribute("INTERVAL_INFO", intervalInfo);
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}

	private void getRequestInfo(HttpServletRequest req, Map<String, Object> param) {
		String url = req.getRequestURI();
		param.put("S_URL", url);
    }
}
