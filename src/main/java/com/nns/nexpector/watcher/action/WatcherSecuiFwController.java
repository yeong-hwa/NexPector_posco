package com.nns.nexpector.watcher.action;

import com.nns.nexpector.common.service.CommonServices;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;


/**
 * SECUI FW 정보 조회 <br>
 * Controller <br>
 *
 */
@Controller
@RequestMapping("/watcher/*")
public class WatcherSecuiFwController {

	/**
	 * Logger
	 */
	private static Logger logger = LoggerFactory.getLogger(WatcherSecuiFwController.class);

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
	 * SECUI FW TRAP INFO 조회.
	 *
	 * @param modelMap
	 * @param param
	 * @param res
	 */
	@SuppressWarnings({ "rawtypes" })
	@RequestMapping("/server_detail/secui_fw/trap_info")
	public ModelAndView getIpsiInfo(ModelMap modelMap, @RequestParam Map param, HttpServletResponse res) {

		try {
			res.setHeader("Pragma", "No-cache");
			res.setDateHeader("Expires", -1);
			res.setHeader("Cache-Control", "no-cache");

			// data
			List list = commonServices.getList("SecuiFwTrapInfoLstQry", param);
			modelMap.addAttribute("data", list);

			// page_totalcnt
			Map map = commonServices.getMap("SecuiFwTrapInfoCntQry", param);
			modelMap.addAttribute("page_totalcnt", map);

		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/watcher/server_detail/secui_fw/trap_info");

	}

}
