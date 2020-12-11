package com.nns.nexpector.admin.action;

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
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;


/**
 * 대시보드 네트워크 구성 관리
 *
 */
@Controller
@RequestMapping("/admin/*")
public class AdminDashboardController {

	/**
	 * Logger
	 */
	private static Logger logger = LoggerFactory.getLogger(AdminDashboardController.class);

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

	@Autowired
	private View jsonView2;


	/**
	 * 대시보드 네트워크 구성 정보 업데이트.
	 *
	 * @param modelMap
	 * @param param
	 * @param request
	 * @return jsonView
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("/dashboard_network_mgt/update")
	public View updateNetworkConfig(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

		HashMap m = new HashMap();
		try {

			try {
				if (param.get("N_MON_ID") == null || param.get("N_MON_ID").toString().isEmpty()) {
					commonServices.getDelData("dashboard_network.delete_mapping", param);
				}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}

			try {
				if (param.get("N_MON_ID") != null && !param.get("N_MON_ID").toString().isEmpty()) {

					Map cntMap = commonServices.getMap("dashboard_network.count_mapping", param);
					int cnt = Integer.parseInt(cntMap.get("CNT").toString());
					if (cnt > 0) {
						m.put("RSLT", -999);
						modelMap.addAttribute(m);
						return jsonView2;
					} else {
						commonServices.getUpdData("dashboard_network.merge_data", param);
					}
				}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}

			m.put("RSLT", commonServices.getUpdData("dashboard_network.update_data", param));
			modelMap.addAttribute(m);

		} catch(SQLException e) {
			m.put("RSLT", -10000);
			m.put("ERRCODE", e.getErrorCode());
			m.put("ERRMSG", e.getMessage());
			modelMap.addAttribute(m);

			logger.error(e.getMessage(), e);

		} catch(Exception e) {
			m.put("RSLT", -1);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", e.getMessage());
			modelMap.addAttribute(m);

			logger.error(e.getMessage(), e);
		}

		return jsonView2;

	}
}