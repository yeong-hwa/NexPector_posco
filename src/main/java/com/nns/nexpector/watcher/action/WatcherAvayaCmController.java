package com.nns.nexpector.watcher.action;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import com.nns.nexpector.common.service.CommonServices;


/**
 * AVAYA CM 정보 조회 <br>
 * Controller <br>
 *
 */
@Controller
@RequestMapping("/watcher/*")
public class WatcherAvayaCmController {

	/**
	 * Logger
	 */
	private static Logger logger = LoggerFactory.getLogger(WatcherAvayaCmController.class);

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
	 * AVAYA CM 기본 정보 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/avaya_cm/default_info")
	public ModelAndView getDefaultInfo(ModelMap modelMap, @RequestParam Map param, HttpServletResponse res) {

		try {
			res.setHeader("Pragma", "No-cache");
			res.setDateHeader("Expires", -1);
			res.setHeader("Cache-Control", "no-cache");

			Map map = commonServices.getMap("AvayaCmDefaultInfoQry", param);
			modelMap.addAttribute("data", map);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/watcher/server_detail/avaya_cm/default_info");

	}

	/**
	 * AVAYA CM PHONE INFO 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/avaya_cm/phone_info")
	public ModelAndView getPhoneInfo(ModelMap modelMap, @RequestParam Map param, HttpServletResponse res) {

		try {
			res.setHeader("Pragma", "No-cache");
			res.setDateHeader("Expires", -1);
			res.setHeader("Cache-Control", "no-cache");

			// data
			List list = commonServices.getList("AvayaCmPhoneInfoLstQry", param);
			modelMap.addAttribute("data", list);

			// page_totalcnt
			Map map = commonServices.getMap("AvayaCmPhoneInfoCntQry", param);
			modelMap.addAttribute("page_totalcnt", map);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/watcher/server_detail/avaya_cm/phone_info");

	}

	/**
	 * AVAYA CM BOARD INFO 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/avaya_cm/board_info")
	public ModelAndView getBoardInfo(ModelMap modelMap, @RequestParam Map param, HttpServletResponse res) {

		try {
			res.setHeader("Pragma", "No-cache");
			res.setDateHeader("Expires", -1);
			res.setHeader("Cache-Control", "no-cache");

			// data
			List list = commonServices.getList("AvayaCmBoardInfoLstQry", param);
			modelMap.addAttribute("data", list);

			// page_totalcnt
			Map map = commonServices.getMap("AvayaCmBoardInfoCntQry", param);
			modelMap.addAttribute("page_totalcnt", map);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/watcher/server_detail/avaya_cm/board_info");

	}

	/**
	 * AVAYA CM IPSI INFO 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/avaya_cm/ipsi_info")
	public ModelAndView getIpsiInfo(ModelMap modelMap, @RequestParam Map param, HttpServletResponse res) {

		try {
			res.setHeader("Pragma", "No-cache");
			res.setDateHeader("Expires", -1);
			res.setHeader("Cache-Control", "no-cache");

			// data
			List list = commonServices.getList("AvayaCmIpsiInfoLstQry", param);
			modelMap.addAttribute("data", list);

			// page_totalcnt
			Map map = commonServices.getMap("AvayaCmIpsiInfoCntQry", param);
			modelMap.addAttribute("page_totalcnt", map);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/watcher/server_detail/avaya_cm/ipsi_info");

	}

	/**
	 * AVAYA CM TRUNK INFO 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/avaya_cm/trunk_info")
	public ModelAndView getTrunkInfo(ModelMap modelMap, @RequestParam Map param, HttpServletResponse res) {

		try {
			res.setHeader("Pragma", "No-cache");
			res.setDateHeader("Expires", -1);
			res.setHeader("Cache-Control", "no-cache");

			// data
			List list = commonServices.getList("AvayaCmTrunkInfoLstQry", param);
			modelMap.addAttribute("data", list);

			// page_totalcnt
			Map map = commonServices.getMap("AvayaCmTrunkInfoCntQry", param);
			modelMap.addAttribute("page_totalcnt", map);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/watcher/server_detail/avaya_cm/trunk_info");

	}

	/**
	 * AVAYA CM ALARM INFO 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/avaya_cm/alarm_info")
	public ModelAndView getAlarmInfo(ModelMap modelMap, @RequestParam Map param, HttpServletResponse res) {

		try {
			res.setHeader("Pragma", "No-cache");
			res.setDateHeader("Expires", -1);
			res.setHeader("Cache-Control", "no-cache");

			// data
			List list = commonServices.getList("AvayaCmAlarmInfoLstQry", param);
			modelMap.addAttribute("data", list);

			// page_totalcnt
			Map map = commonServices.getMap("AvayaCmAlarmInfoCntQry", param);
			modelMap.addAttribute("page_totalcnt", map);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/watcher/server_detail/avaya_cm/alarm_info");

	}

	/**
	 * AVAYA CM RESTART INFO 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/avaya_cm/restart_info")
	public ModelAndView getRestartInfo(ModelMap modelMap, @RequestParam Map param, HttpServletResponse res) {

		try {
			res.setHeader("Pragma", "No-cache");
			res.setDateHeader("Expires", -1);
			res.setHeader("Cache-Control", "no-cache");

			// data
			List list = commonServices.getList("AvayaCmRestartInfoLstQry", param);
			modelMap.addAttribute("data", list);

			// page_totalcnt
			Map map = commonServices.getMap("AvayaCmRestartInfoCntQry", param);
			modelMap.addAttribute("page_totalcnt", map);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/watcher/server_detail/avaya_cm/restart_info");

	}

	/**
	 * AVAYA CM HUNT INFO 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/avaya_cm/hunt_info")
	public ModelAndView getHuntInfo(ModelMap modelMap, @RequestParam Map param, HttpServletResponse res) {

		try {
			res.setHeader("Pragma", "No-cache");
			res.setDateHeader("Expires", -1);
			res.setHeader("Cache-Control", "no-cache");

			// data
			List list = commonServices.getList("AvayaCmHuntInfoLstQry", param);
			modelMap.addAttribute("data", list);

			// page_totalcnt
			Map map = commonServices.getMap("AvayaCmHuntInfoCntQry", param);
			modelMap.addAttribute("page_totalcnt", map);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/watcher/server_detail/avaya_cm/hunt_info");

	}

}
