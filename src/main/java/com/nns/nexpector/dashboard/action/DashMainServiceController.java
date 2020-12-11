package com.nns.nexpector.dashboard.action;

import java.util.ArrayList;
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

/**
 * DASHBOARD() SYSTEM 정보 조회 <br>
 * Controller <br>
 *
 */
@Controller
@RequestMapping("/dashboard/*")
public class DashMainServiceController {

	/**
	 * Logger
	 */
	private static Logger logger = LoggerFactory.getLogger(DashMainServiceController.class);

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

	@RequestMapping("/dash_service_info")
	public String dashServiceInfo(){
		return "/dash/dash_service_info";
	}
	
	private void addParam(Map<String, Object> param)
	{
		param.put("SESSION_USER_ID", sess.getAttribute("S_USER_ID"));
	}

	/**
	 * DASHBOARD SERVICE 기본 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param res
	 * @return jsonView
	 */
	@SuppressWarnings({ "unchecked" })
	@RequestMapping("/ajax_service_info")
	public View getAjaxServiceInfo(ModelMap modelMap, @RequestParam Map<String, Object> param, HttpServletRequest req, HttpServletResponse res) {
		addParam(param);
		try {
			Map<String, Object>		qry_params = new HashMap<String, Object>();

			/* VG 실시간 사용현황 (본사·콜센터) */
			qry_params.put("N_TYPE_CODE", 8000);
			Map<String, Object> 		vgRealtimeUseBonsa = commonServices.getMap("dash_service.vgRealtimeUseState", qry_params);
			modelMap.addAttribute("VG_REALTIME_USE_BONSA", vgRealtimeUseBonsa);
			
			/* VG 실시간 사용현황 (지점) */
			qry_params.put("N_TYPE_CODE", 8500);
			Map<String, Object> 		vgRealtimeUseJijum = commonServices.getMap("dash_service.vgRealtimeUseState", qry_params);
			modelMap.addAttribute("VG_REALTIME_USE_JIJUM", vgRealtimeUseJijum);
			
			/* VG 실시간 사용현황 (본사·콜센터) - BAR */
			qry_params.put("N_TYPE_CODE", 8000);
			List<Map<String, Object>>	vgRtcntUseBonsa = commonServices.getList("dash_service.vgRealtimeUseCount", qry_params);
			modelMap.addAttribute("VG_RTCNT_USE_BONSA", vgRtcntUseBonsa);
			/* VG 실시간 사용현황 (지점) - BAR */
			qry_params.put("N_TYPE_CODE", 8500);
			List<Map<String, Object>>	vgRtcntUseJijum = commonServices.getList("dash_service.vgRealtimeUseCount", qry_params);
			modelMap.addAttribute("VG_RTCNT_USE_JIJUM", vgRtcntUseJijum);

			/* 실시간 IN·OUT 현황 (본사·콜센터) */
			qry_params.put("CLUSTER_TYPE", "BONSA");
			Map<String, Object>			callAccrueBonsa = commonServices.getMap("dash_service.callRealtimeAccrueState", qry_params);
			modelMap.addAttribute("CALL_REALTIME_ACCRUE_BONSA", callAccrueBonsa);
			
			/* 실시간 IN·OUT 현황 (지점) */
			qry_params.put("CLUSTER_TYPE", "JIJUM");
			Map<String, Object>			callAccrueJijum = commonServices.getMap("dash_service.callRealtimeAccrueState", qry_params);
			modelMap.addAttribute("CALL_REALTIME_ACCRUE_JIJUM", callAccrueJijum);

			/* 콜센터 대표번호별 인입현황 () */
			qry_params.put("NUM_LIST", makeNumList(param.get("NUM_LIST")));
			List<Map<String, Object>> 	callDaepyoIncallState = commonServices.getList("dash_service.callDaepyoIncallState", qry_params);
			modelMap.addAttribute("CALL_DAEPYO_INCALL_STATE", callDaepyoIncallState);

			/* 콜사용 현황 (PEAK) */
			List<Map<String, Object>> 	callUsePeakGroup = commonServices.getList("dash_service.callUsePeakGroup", null);
			modelMap.addAttribute("CALL_USE_PEAK_GROUP", callUsePeakGroup);

			/* 콜 누적 현황 */
			List<Map<String, Object>> 	callNowSummaryState = commonServices.getList("dash_service.callNowSummaryState", null);
			modelMap.addAttribute("CALL_NOW_SUMMARY_STATE", callNowSummaryState);

			qry_params.clear();
			/* 콜 현황 (전체) */
			List<Map<String, Object>> 	callTotSummaryState = commonServices.getList("dash_service.callTotSummaryState", null);
			modelMap.addAttribute("CALL_TOT_SUMMARY_STATE", callTotSummaryState);

			/* 콜 현황 (월:일별) */
			qry_params.put("DAY_TYPE", "NOW");
			List<Map<String, Object>> 	callMonthSummaryList = commonServices.getList("dash_service.callMonthSummaryList", qry_params);
			modelMap.addAttribute("CALL_MONTH_SUMMARY_LIST", callMonthSummaryList);

			/* 콜 현황 (기타정보) */
			Map<String, Object>			callExtraInfo = commonServices.getMap("dash_service.callExtraInfo", qry_params);
			modelMap.addAttribute("CALL_EXTRA_INFO", callExtraInfo);

			/* refresh 주기 */
			param.put("N_INTERVAL_TYPE", 0);
			Map<String, Object>			intervalInfo = commonServices.getMap("dashboard_interval.selectDashboardIntervalData", param);
			if (intervalInfo == null) {
				intervalInfo = new HashMap<String, Object>();
				intervalInfo.put("N_INTERVAL_TIME", 5);
			}
			modelMap.addAttribute("INTERVAL_INFO", intervalInfo);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("/ajax_call_summary_list")
	public View getAjaxCallSummaryList(ModelMap modelMap, @RequestParam Map<String, Object> param, HttpServletRequest req, HttpServletResponse res) {
		try {
			String		schDate = param.get("SCH_DATE").toString();
			/* 콜 현황 (월:일별) */
			param.put("DAY_TYPE", 	"DATE");
			param.put("DATE_START", schDate+"01");
			param.put("DATE_END", 	schDate+"31");
			List<Map<String, Object>> 	callMonthSummaryList = commonServices.getList("dash_service.callMonthSummaryList", param);
			modelMap.addAttribute("CALL_MONTH_SUMMARY_LIST", callMonthSummaryList);

			/* 콜 현황 (기타정보) */
			Map<String, Object>			callExtraInfo = commonServices.getMap("dash_service.callExtraInfo2", param);
			modelMap.addAttribute("CALL_EXTRA_INFO", callExtraInfo);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;
	}
	
	private List<String> makeNumList(Object nums) {
		List<String>	aryList = new ArrayList<String>();

		if (nums == null) {
			return aryList;
		}
		String	aNums[] = nums.toString().split(",");
		for (int i = 0; i < aNums.length; i ++) {
			aryList.add(aNums[i].trim());
		}
		return aryList;
	}
}
