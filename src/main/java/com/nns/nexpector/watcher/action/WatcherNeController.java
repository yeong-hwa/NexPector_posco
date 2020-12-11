package com.nns.nexpector.watcher.action;

import com.nns.common.constants.NeoConstants;
import com.nns.common.util.WebUtil;
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
import java.util.List;
import java.util.Map;


/**
 * IVR, REC, FAX info/channel <br>
 * Controller <br>
 *
 */
@Controller
@RequestMapping("/watcher/*")
public class WatcherNeController {

	/**
	 * Logger
	 */
	private static Logger logger = LoggerFactory.getLogger(WatcherNeController.class);

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
	 * 실시간 채널 정보 조회(차트 데이터). <br>
	 * IVR Channel
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/ivr_rec_fax/realtime_chart_main_ivr")
	@Deprecated
	public View getRealtimeChartIvr(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID
			Map result = commonServices.getMap("RealtimeIvrChannel", param);
			modelMap.addAttribute(NeoConstants.REAL_TIME, result);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}

	/**
	 * 실시간 채널 정보 조회(차트 데이터). <br>
	 * REC Channel
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/ivr_rec_fax/realtime_chart_main_rec")
	@Deprecated
	public View getRealtimeChartRec(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID
			Map result = commonServices.getMap("RealtimeRecChannel", param);
			modelMap.addAttribute(NeoConstants.REAL_TIME, result);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}

	/**
	 * 실시간 채널 정보 조회(차트 데이터). <br>
	 * FAX Channel
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/ivr_rec_fax/realtime_chart_main_fax")
	@Deprecated
	public View getRealtimeChartFax(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID
			Map result = commonServices.getMap("RealtimeFaxChannel", param);
			modelMap.addAttribute(NeoConstants.REAL_TIME, result);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}

	/**
	 * 일간 차트 데이터 생성.
	 *
	 * @param map
	 * @return int[]
	 */
	@SuppressWarnings("rawtypes")
	public static int[] toDailyChartData(Map map) {
		int[] resultArr = new int[24];

		if (map == null) {
			return resultArr;
		}

		Object temp = null;
		int data = 0;

		for (int idx = 0; idx < 24; idx++) {
			try {
				temp = map.get("TIME_" + idx);
				if (temp != null) {
					data = Integer.parseInt(String.valueOf(temp));
				} else {
					data = 0;
				}

			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				data = -1;
			}
			resultArr[idx] = data;

		}

		return resultArr;

	}

	/**
	 * 일간 채널 통계 차트 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/ivr_rec_fax/daily_chart_main")
	public View getDailyChartIvr(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : SERVICE, DATATYPE, CALLTYPE, SYSTEMID, SVCDAY

			Map peak = commonServices.getMap("DailyChannelStat", param);
			modelMap.addAttribute(NeoConstants.DAILY_STAT, toDailyChartData(peak));

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}

	/**
	 * IVR 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
//	@SuppressWarnings({ "rawtypes", "unchecked" })
//	@RequestMapping("/server_detail/ivr_rec_fax/ivr_info")
//	public View getIvrInfo(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {
//
//		try {
//			// param : N_MON_ID
//
//			/* 서비스 상태. */
//			param.put("N_MAIN_TYPE", WebUtil.getInteger(param, "SERVICE_MAIN_TYPE"));
//
//			int[] serviceSubTypes = WebUtil.toIntArray(request.getParameterValues("SERVICE_SUB_TYPES[]"));
//			String[] serviceSubNames = request.getParameterValues("SERVICE_SUB_NAMES[]");
//
//			if (serviceSubTypes != null && serviceSubNames != null
//					&& serviceSubTypes.length == serviceSubNames.length) {
//
//				for (int i = 0; i < serviceSubTypes.length; i++) {
//					param.put("N_SUB_TYPE", serviceSubTypes[i]);
//					Map serviceStateMap = commonServices.getMap("ServiceState", param);
//					modelMap.addAttribute(serviceSubNames[i], serviceStateMap);
//				}
//			}
//
//
//			/* 넥스플로우(IVR) 시나리오 정보 조회. */
//			Map ivrScenario = commonServices.getMap("IvrScenario", param);
//			modelMap.addAttribute("IVR_SCENARIO", ivrScenario);
//
//
//			/* 넥스플로우(IVR) 채널 상태 조회. */
//			Map ivrChannelStatus = commonServices.getMap("IvrChannelStatus", param);
//			modelMap.addAttribute("IVR_CHANNEL_STATUS", ivrChannelStatus);
//
//
//			/* 컴포넌트 현황. */
//			param.put("N_MAIN_TYPE", WebUtil.getInteger(param, "COMPONENT_MAIN_TYPE"));
//
//			int[] componentSubTypes = WebUtil.toIntArray(request.getParameterValues("COMPONENT_SUB_TYPES[]"));
//			String[] componentSubNames = request.getParameterValues("COMPONENT_SUB_NAMES[]");
//
//			if (componentSubTypes != null && componentSubNames != null
//					&& componentSubTypes.length == componentSubNames.length) {
//
//				for (int i = 0; i < componentSubTypes.length; i++) {
//					param.put("N_SUB_TYPE", componentSubTypes[i]);
//					Map componentMap = commonServices.getMap("ComponentCount", param);
//					modelMap.addAttribute(componentSubNames[i], componentMap);
//				}
//			}
//
//		} catch(Exception e) {
//			logger.error(e.getMessage(), e);
//		}
//
//		return jsonView;
//
//	}
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("/server_detail/ivr_rec_fax/ivr_info")
	public View getIvrInfo(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID

			/* IVR 채널 상태 조회. */
			Map  IvrChannelStatus = commonServices.getMap("IvrChannelInfoStatus", param);
			modelMap.addAttribute("IVR_CHANNEL_STATUS", IvrChannelStatus);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;
	}

	/**
	 * IVR 채널 조회.(table data)
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/ivr_rec_fax/ivr_channel")
	public View getIvrChannel(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID, SORT_COLUMN, SORT_ORDER
			String sortColumn = WebUtil.getMapToStr(param, NeoConstants.SORT_COLUMN, null);
			String sortOrder = WebUtil.getMapToStr(param, NeoConstants.SORT_ORDER, null);

			if (sortColumn == null || sortColumn.isEmpty() ||
					sortOrder == null || sortOrder.isEmpty()) {
				modelMap.addAttribute(NeoConstants.SORT_COLUMN, "");
				modelMap.addAttribute(NeoConstants.SORT_ORDER, "");
			} else {
				modelMap.addAttribute(NeoConstants.SORT_COLUMN, sortColumn);
				modelMap.addAttribute(NeoConstants.SORT_ORDER, sortOrder);
			}

			List list = commonServices.getList("DetailIvrChannel", param);
			modelMap.addAttribute(NeoConstants.GRID, list);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}

	/**
	 * REC 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("/server_detail/ivr_rec_fax/rec_info")
	public View getRecInfo(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID

			/* 서비스 상태. */
			param.put("N_MAIN_TYPE", WebUtil.getInteger(param, "SERVICE_MAIN_TYPE"));

			int[] serviceSubTypes = WebUtil.toIntArray(request.getParameterValues("SERVICE_SUB_TYPES[]"));
			String[] serviceSubNames = request.getParameterValues("SERVICE_SUB_NAMES[]");

			if (serviceSubTypes != null && serviceSubNames != null
					&& serviceSubTypes.length == serviceSubNames.length) {

				for (int i = 0; i < serviceSubTypes.length; i++) {
					param.put("N_SUB_TYPE", serviceSubTypes[i]);
					Map serviceStateMap = commonServices.getMap("ServiceState", param);
					modelMap.addAttribute(serviceSubNames[i], serviceStateMap);
				}
			}


			/* 네오보이스(REC) 채널 상태 조회. */
			Map recChannelStatus = commonServices.getMap("RecChannelStatus", param);
			modelMap.addAttribute("REC_CHANNEL_STATUS", recChannelStatus);


			/* 컴포넌트 현황. */
			param.put("N_MAIN_TYPE", WebUtil.getInteger(param, "COMPONENT_MAIN_TYPE"));

			int[] componentSubTypes = WebUtil.toIntArray(request.getParameterValues("COMPONENT_SUB_TYPES[]"));
			String[] componentSubNames = request.getParameterValues("COMPONENT_SUB_NAMES[]");

			if (componentSubTypes != null && componentSubNames != null
					&& componentSubTypes.length == componentSubNames.length) {

				for (int i = 0; i < componentSubTypes.length; i++) {
					param.put("N_SUB_TYPE", componentSubTypes[i]);
					Map componentMap = commonServices.getMap("ComponentCount", param);
					modelMap.addAttribute(componentSubNames[i], componentMap);
				}
			}

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}


	/**
	 * REC 채널 조회. (table data)
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/ivr_rec_fax/rec_channel")
	public View getRecChannel(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID, SORT_COLUMN, SORT_ORDER
			String sortColumn = WebUtil.getMapToStr(param, NeoConstants.SORT_COLUMN, null);
			String sortOrder = WebUtil.getMapToStr(param, NeoConstants.SORT_ORDER, null);

			if (sortColumn == null || sortColumn.isEmpty() ||
					sortOrder == null || sortOrder.isEmpty()) {
				modelMap.addAttribute(NeoConstants.SORT_COLUMN, "");
				modelMap.addAttribute(NeoConstants.SORT_ORDER, "");
			} else {
				modelMap.addAttribute(NeoConstants.SORT_COLUMN, sortColumn);
				modelMap.addAttribute(NeoConstants.SORT_ORDER, sortOrder);
			}

			List list = commonServices.getList("DetailRecChannel", param);
			modelMap.addAttribute(NeoConstants.GRID, list);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}



	/**
	 * FAX 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("/server_detail/ivr_rec_fax/fax_info")
	public View getFaxInfo(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID

			/* 서비스 상태. */
			param.put("N_MAIN_TYPE", WebUtil.getInteger(param, "SERVICE_MAIN_TYPE"));

			int[] serviceSubTypes = WebUtil.toIntArray(request.getParameterValues("SERVICE_SUB_TYPES[]"));
			String[] serviceSubNames = request.getParameterValues("SERVICE_SUB_NAMES[]");

			if (serviceSubTypes != null && serviceSubNames != null
					&& serviceSubTypes.length == serviceSubNames.length) {

				for (int i = 0; i < serviceSubTypes.length; i++) {
					param.put("N_SUB_TYPE", serviceSubTypes[i]);
					Map serviceStateMap = commonServices.getMap("ServiceState", param);
					modelMap.addAttribute(serviceSubNames[i], serviceStateMap);
				}
			}

			/* 네오팩스 채널 상태 조회. */
			Map faxChannelStatus = commonServices.getMap("FaxChannelStatus", param);
			modelMap.addAttribute("FAX_CHANNEL_STATUS", faxChannelStatus);


			/* 네오팩스 채널 구성 조회. */
			Map faxChannelType = commonServices.getMap("FaxChannelType", param);
			modelMap.addAttribute("FAX_CHANNEL_TYPE", faxChannelType);


			/* 네오팩스 큐 상태 조회. */
			Map queueState = commonServices.getMap("QueueState", param);
			modelMap.addAttribute("QUEUE_STATE", queueState);


			/* 네오팩스 문서 변환 상태 조회. */
			Map faxDocCvt = commonServices.getMap("faxDocCvt", param);
			modelMap.addAttribute("FAX_DOC_CVT", faxDocCvt);


			/* 네오팩스 문서 합성 상태 조회. */
			Map faxDocFod = commonServices.getMap("faxDocFod", param);
			modelMap.addAttribute("FAX_DOC_FOD", faxDocFod);


			/* 컴포넌트 현황. */
			param.put("N_MAIN_TYPE", WebUtil.getInteger(param, "COMPONENT_MAIN_TYPE"));

			int[] componentSubTypes = WebUtil.toIntArray(request.getParameterValues("COMPONENT_SUB_TYPES[]"));
			String[] componentSubNames = request.getParameterValues("COMPONENT_SUB_NAMES[]");

			if (componentSubTypes != null && componentSubNames != null
					&& componentSubTypes.length == componentSubNames.length) {

				for (int i = 0; i < componentSubTypes.length; i++) {
					param.put("N_SUB_TYPE", componentSubTypes[i]);
					Map componentMap = commonServices.getMap("ComponentCount", param);
					modelMap.addAttribute(componentSubNames[i], componentMap);
				}
			}

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}


	/**
	 * FAX 채널 조회. (table data)
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/ivr_rec_fax/fax_channel")
	public View getFaxChannel(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID, SORT_COLUMN, SORT_ORDER
			String sortColumn = WebUtil.getMapToStr(param, NeoConstants.SORT_COLUMN, null);
			String sortOrder = WebUtil.getMapToStr(param, NeoConstants.SORT_ORDER, null);

			if (sortColumn == null || sortColumn.isEmpty() ||
					sortOrder == null || sortOrder.isEmpty()) {
				modelMap.addAttribute(NeoConstants.SORT_COLUMN, "");
				modelMap.addAttribute(NeoConstants.SORT_ORDER, "");
			} else {
				modelMap.addAttribute(NeoConstants.SORT_COLUMN, sortColumn);
				modelMap.addAttribute(NeoConstants.SORT_ORDER, sortOrder);
			}

			List list = commonServices.getList("DetailFaxChannel", param);
			modelMap.addAttribute(NeoConstants.GRID, list);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}



	/**
	 * E1 채널 통계 차트 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/snmp_m03/daily_chart_main")
	public View getDailyChartE1Channel(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : SERVICE, DATATYPE, CALLTYPE, SYSTEMID, SVCDAY
			Map peak = commonServices.getMap("E1DailyChannelStat", param);
			modelMap.addAttribute(NeoConstants.DAILY_STAT, toDailyChartData(peak));

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}

	/**
	 * 채널 사용 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("/server_detail/snmp_m03/e1_channel_info")
	public View getE1ChannelInfo(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID

			/* E1 채널 상태 조회. */
			Map E1ChannelStatus = commonServices.getMap("M03E1ChannelInfoStatus", param);
			modelMap.addAttribute("E1_CHANNEL_STATUS", E1ChannelStatus);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}

	/**
	 * 채널 사용 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/snmp_m03/e1_channel_index")
	public View getE1IndexLst(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID

			/* E1 채널 Index 조회. */
			List E1IndexLst = commonServices.getList("M03E1IndexLstQry", param);
			modelMap.addAttribute("E1_INDEX_LST", E1IndexLst);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}

}
