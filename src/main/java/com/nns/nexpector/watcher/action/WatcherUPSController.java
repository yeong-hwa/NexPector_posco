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
 * UPS 정보 조회 기능 <br>
 * Controller <br>
 *
 */
@Controller
@RequestMapping("/watcher/*")
public class WatcherUPSController {

	/**
	 * Logger
	 */
	private static Logger logger = LoggerFactory.getLogger(WatcherUPSController.class);

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
	 * UPS 상태 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/ups/ups_status")
	public View getUpsStatus(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

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
	 * UPS 정보 조회. <br>
	 * Battery, Input, Output, Bypass 정보 <br>
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/ups/ups_info")
	public View getUpsInfo(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		try {
			// param : N_MON_ID

			// UPS battery.
			Map upsBatteryMap = commonServices.getMap("getUpsBattery", param);
			modelMap.addAttribute("UPS_BATTERY", upsBatteryMap);

			// UPS input.
			Map upsInputMap = commonServices.getMap("getUpsInput", param);
			modelMap.addAttribute("UPS_INPUT", upsInputMap);

			// UPS output.
			Map upsOutputMap = commonServices.getMap("getUpsOutput", param);
			modelMap.addAttribute("UPS_OUTPUT", upsOutputMap);

			// UPS test.
			Map upsBypassMap = commonServices.getMap("getUpsTest", param);
			modelMap.addAttribute("UPS_TEST", upsBypassMap);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonView;

	}

}
