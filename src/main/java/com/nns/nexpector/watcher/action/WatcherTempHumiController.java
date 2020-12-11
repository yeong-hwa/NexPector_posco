package com.nns.nexpector.watcher.action;

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
import java.util.Map;


/**
 * Thermo-Hygrostat Information <br>
 * Controller <br>
 *
 */
@Controller
@RequestMapping("/watcher/*")
public class WatcherTempHumiController {

	/**
	 * Logger
	 */
	private static Logger logger = LoggerFactory.getLogger(WatcherTempHumiController.class);

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
	 * 항온항습 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/temp_humidity/temp_humidity_info")
	public View getThermoHygrostatInfo(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID

			// 현재 상태.
			Map currentStatusMap = commonServices.getMap("getCurrentStatus", param);
			modelMap.addAttribute("CURRENT_STATUS", currentStatusMap);

			// 운전 상태.
			Map operationStatusMap = commonServices.getMap("getOperationStatus", param);
			modelMap.addAttribute("OPERATION_STATUS", operationStatusMap);

			// 경보 상태.
			Map alarmStatusMap = commonServices.getMap("getAlarmStatus", param);
			modelMap.addAttribute("ALARM_STATUS", alarmStatusMap);


		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}

}
