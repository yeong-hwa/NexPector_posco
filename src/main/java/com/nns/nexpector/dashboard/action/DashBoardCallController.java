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
import javax.servlet.http.HttpSession;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * DASHBOARD CALL 정보 조회 <br>
 * Controller <br>
 *
 */
@Controller
@RequestMapping("/dashboard/*")
public class DashBoardCallController {

	/**
	 * Logger
	 */
	private static Logger logger = LoggerFactory.getLogger(DashBoardCallController.class);

	/**
	 * Service CommonServices
	 */
	@Autowired
	private CommonServices commonServices;

	/**
	 * applicationContext bean
	 */
	@Autowired
	private View jsonView;
	
	/**
	 * session HttpSession 
	 */
	@Autowired
	private HttpSession sess;
	
	private void addParam(Map<String, Object> param)
	{
		param.put("SESSION_USER_ID", sess.getAttribute("S_USER_ID"));
	}
	
	@RequestMapping("call")
	public String getLoginPage(){
		return "/dashboard/dashboard_call_info";
	}
	
	// chart 통합외주상담센터
	@RequestMapping("outsource_in")
	public String getChartOutInPage(){
		return "/dashboard/chart/outsource_in";
	}
	
	// chart 통합외주상담센터
	@RequestMapping("crm_in")
	public String getChartCrmInPage(){
		return "/dashboard/chart/crm_in";
	}
	
	// chart 통합외주상담센터
	@RequestMapping("itms_in")
	public String getChartItmsInPage(){
		return "/dashboard/chart/itms_in";
	}
	
	// chart 통합외주상담센터
	@RequestMapping("outsource_out")
	public String getChartOutOutPage(){
		return "/dashboard/chart/outsource_out";
	}
	
	// chart 통합외주상담센터
	@RequestMapping("crm_out")
	public String getChartCrmOutPage(){
		return "/dashboard/chart/crm_out";
	}
	
	// chart 통합외주상담센터
	@RequestMapping("itms_out")
	public String getChartItmsOutPage(){
		return "/dashboard/chart/itms_out";
	}
	
	/**
	 * DASHBOARD SYSTEM 기본 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "unchecked" })
	@RequestMapping("/dashboard_call_info")
	public View callPage(ModelMap modelMap, @RequestParam Map<String, Object> param, HttpServletRequest request) {
		addParam(param);
		getRequestInfo(request, param);
		try {
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
			Date now = new Date();
			String cur_day = format.format(now);

			// 콜통계 (전체, INBOUND, OUTBOUND - 실시간(본점, 영업점), 누적(본점, 영업점))
			List<Map<String, Object>> dashboardCallStatis = commonServices.getList("dashboardCallStatis", param);
			modelMap.addAttribute("DASHBOARD_CALL_STATIS", dashboardCallStatis);
			
            // 스킬 현황 Top 5
            List<Map<String, Object>> skillTop = commonServices.getList("dashboardSkillTop", param);
            modelMap.addAttribute("SKILL_TOP", skillTop);
            
            // IVR 시나리오 Top 5
            List<Map<String, Object>> ivrTop = commonServices.getList("dashboardIvrTop", param);
            modelMap.addAttribute("IVR_TOP", ivrTop);
            
            // 서울역 센터 콜 현황
            List<Map<String, Object>> seoulCallIncrease = commonServices.getList("dashboardSeoulCallIncrease", param);
            modelMap.addAttribute("SEOUL_CALL_INCREASE", seoulCallIncrease);
            
            // Trunk Top 5
            List<Map<String, Object>> trunkTop = commonServices.getList("dashboardTrunkTop", param);
            modelMap.addAttribute("TRUNK_TOP", trunkTop);
            
            // 시스템 현황
            List<Map<String, Object>> systemErrorStatus = commonServices.getList("dashboardSystemErrorStatus", param);
            modelMap.addAttribute("CALL_SYSTEM_ERROR_STATUS", systemErrorStatus);
            /*
			// 본점 시간별 콜 추이
			param.put("GROUP_TYPE", "HQ");
			List<Map<String, Object>> dashboardTimeCallIncrease = commonServices.getList("dashboardTimeCallIncrease", param);
			modelMap.addAttribute("DASHBOARD_TIMECALL_INCREASE", dashboardTimeCallIncrease);
			
			// 영업점 시간별 콜 추이
			param.put("GROUP_TYPE", "NHQ");
			List<Map<String, Object>> dashboardJumTimeCallIncrease = commonServices.getList("dashboardTimeCallIncrease", param);
			modelMap.addAttribute("DASHBOARD_JUM_TIMECALL_INCREASE", dashboardJumTimeCallIncrease);
			
			// 쿨러스터별 콜 추이(본점)
			param.put("N_CLUSTER", "1");
			List<Map<String, Object>> dashboardClusterCallIncrease1 = commonServices.getList("dashboardClusterCallIncrease", param);
			modelMap.addAttribute("DASHBOARD_CLUSTER_CALL1", dashboardClusterCallIncrease1);
			
			// 쿨러스터별 콜 추이(영업점1)
			param.put("N_CLUSTER", "2");
			List<Map<String, Object>> dashboardClusterCallIncrease2 = commonServices.getList("dashboardClusterCallIncrease", param);
			modelMap.addAttribute("DASHBOARD_CLUSTER_CALL2", dashboardClusterCallIncrease2);
			
			// 쿨러스터별 콜 추이(영업점2)
			param.put("N_CLUSTER", "3");
			List<Map<String, Object>> dashboardClusterCallIncrease3 = commonServices.getList("dashboardClusterCallIncrease", param);
			modelMap.addAttribute("DASHBOARD_CLUSTER_CALL3", dashboardClusterCallIncrease3);
			
			// 쿨러스터별 콜 추이(SME)
			param.put("N_CLUSTER", "0");
			List<Map<String, Object>> dashboardClusterCallIncrease4 = commonServices.getList("dashboardClusterCallIncrease", param);
			modelMap.addAttribute("DASHBOARD_CLUSTER_CALL4", dashboardClusterCallIncrease4);
			
			// 본점 부서별 콜 TOP10 (SUM, INBOUND, OUTBOUND, 녹취)
			param.put("GROUP_TYPE", "DEPT");	
			List<Map<String, Object>> dashboardDeptCallTop10 = commonServices.getList("dashboardCallTop10", param);
			modelMap.addAttribute("DASHBOARD_DEPT_CALLTOP10", dashboardDeptCallTop10);
			
			// 영업점 지점별 콜 TOP10(SUM, INBOUND, OUTBOUND, 녹취)
			param.put("GROUP_TYPE", "JUM");
			List<Map<String, Object>> dashboardJumCallTop10 = commonServices.getList("dashboardCallTop10", param);
			modelMap.addAttribute("DASHBOARD_JUM_CALLTOP10", dashboardJumCallTop10);
			
			// 전일대비 콜 증감 추이 (시간별)
			param.put("S_CUR_DT", cur_day);
			List<Map<String, Object>> dashboardCallIncrease = commonServices.getList("dashboardCallIncrease", param);
			modelMap.addAttribute("DASHBOARD_CALL_INCREASE", dashboardCallIncrease);
			*/

			List<Map<String, Object>> intervalInfo = commonServices.getList("selectDashboardIntervalQry", param);
			modelMap.addAttribute("INTERVAL_INFO", intervalInfo);

			List<Map<String, Object>> snmpManagerCheckInfo = commonServices.getList("selectSnmpManagerCheckQry", param);
			modelMap.addAttribute("SNMPMANAGER_CHECK", snmpManagerCheckInfo);
			
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;
	}
	
	/**
	 * DASHBOARD SYSTEM 통합외주상담센터 인바운드 CHART 대입 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/chart/outsource_in")
	public View chartOutSourceInPage(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {
		try {
			// 통합외주상담센터 인바운드 정보 조회
			List outsourceIn = commonServices.getList("chartOutSourceIn", param);
			modelMap.addAttribute("OUTSOURCE_IN", outsourceIn);


		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}
	
	/**
	 * DASHBOARD SYSTEM 통합외주상담센터 아웃바운드 CHART 대입 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/chart/outsource_out")
	public View chartOutSourceOutPage(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {
		try {
			// 통합외주상담센터 아웃바운드 정보 조회
			List outsourceOut = commonServices.getList("chartOutSourceOut", param);
			modelMap.addAttribute("OUTSOURCE_OUT", outsourceOut);


		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}
	
	/**
	 * DASHBOARD SYSTEM 고객만족상담센터 인바운드 CHART 대입 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/chart/crm_in")
	public View chartCrmInPage(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {
		try {
			// 고객만족상담센터 인바운드 정보 조회
			List crmIn = commonServices.getList("chartCrmIn", param);
			modelMap.addAttribute("CRM_IN", crmIn);


		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}
	
	/**
	 * DASHBOARD SYSTEM 고객만족상담센터 아웃바운드 CHART 대입 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/chart/crm_out")
	public View chartCrmOutPage(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {
		try {
			// 고객만족상담센터 아웃바운드 정보 조회
			List crmOut = commonServices.getList("chartCrmOut", param);
			modelMap.addAttribute("CRM_OUT", crmOut);


		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}
	
	/**
	 * DASHBOARD SYSTEM ITMS상담센터 인바운드 CHART 대입 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/chart/itms_in")
	public View chartItmsInPage(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {
		try {
			// ITMS 상담센터 인바운드 정보 조회
			List itmsIn = commonServices.getList("chartItmsIn", param);
			modelMap.addAttribute("ITMS_IN", itmsIn);


		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}
	
	/**
	 * DASHBOARD SYSTEM ITMS상담센터 아웃바운드 CHART 대입 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/chart/itms_out")
	public View chartItmsOutPage(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {
		try {
			// ITMS 상담센터 아웃바운드 정보 조회
			List itmsOut = commonServices.getList("chartItmsOut", param);
			modelMap.addAttribute("ITMS_OUT", itmsOut);


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
