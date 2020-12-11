package com.nns.nexpector.admin.action;

import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.LogUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.View;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

/**
 * Trunk Name 관리 Controller.
 */
@Controller
@RequestMapping("/admin/trunk_name/")
public class AdminTrunkNameController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private CommonServices service;
	@Autowired
	private View jsonView2;

	@RequestMapping(value = "insert", method = RequestMethod.POST)
	@ResponseStatus(value = HttpStatus.OK)
	@Transactional
	public View insert(ModelMap map, @RequestParam("N_TRUNK_NUMBER") Integer[] trunkNumbers, @RequestParam("S_TRUNK_NAME") String[] trunkNames, @RequestParam("N_MON_ID") int nMonId ) throws Exception {
		HashMap m = new HashMap();
		try {
			if (logger.isDebugEnabled()) {
				logger.debug("N_MON_ID : {}", nMonId);

				for (int i = 0 ; i < trunkNumbers.length ; i++) {
					logger.debug("N_TRUNK_NUMBER[{}] : {}", i, trunkNumbers);
					logger.debug("S_TRUNK_NAME[{}] : {}", i, trunkNames);
				}
			}

			Map<String, Object> params = new HashMap<String, Object>();
			params.put("N_MON_ID", nMonId);

			// Insert
			for (int i = 0 ; i < trunkNumbers.length ; i++) {
				params.put("S_TRUNK_NAME", trunkNames[i]);
				params.put("N_TRUNK_NUMBER", trunkNumbers[i]);
				logger.debug("params: {}", params);
				
				service.getInsData("trunk_name.insert_data", params);
			}

			m.put("RSLT", 1);
		} catch (Exception e) {
			m.put("RSLT", -9999);
			logger.error(e.getMessage(), e);
		}
		map.addAttribute(m);
		
		return jsonView2;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "update")
	public View update(ModelMap map, @RequestParam HashMap<String, Object> params) throws Exception {
		@SuppressWarnings("rawtypes")
		HashMap m = new HashMap();
		try {
			if (logger.isDebugEnabled()) {
				logger.debug("parameter : {}", params);
			}
			m.put("RSLT", service.getUpdData("trunk_name.update_data", params));
		} catch (Exception e) {
			m.put("RSLT", -9999);
			logger.error(e.getMessage(), e);
		}
		map.addAttribute(m);

		return jsonView2;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("delete")
	@Transactional
	public View jobwork_delete(ModelMap map, @RequestParam Map param, HttpServletRequest req) {
		HashMap m = new HashMap();

		try {
			String trunkNameDeleteList = (String)param.get("TRUNK_NAME_DELETE_LIST");
			String[] trunkNameDeleteListArr = trunkNameDeleteList.split(",");
			for (int i = 0 ; i < trunkNameDeleteListArr.length ; i++) {
				Map tmp_trunkNameDeleteMap = new HashMap();

				String[] trunkNameDeleteParamsStr = trunkNameDeleteListArr[i].split("::");

				tmp_trunkNameDeleteMap.put("S_TRUNK_NAME", trunkNameDeleteParamsStr[0]);
				tmp_trunkNameDeleteMap.put("N_TRUNK_NUMBER", trunkNameDeleteParamsStr[1]);
				tmp_trunkNameDeleteMap.put("N_MON_ID", trunkNameDeleteParamsStr[2]);

				service.getDelData("trunk_name.delete_data", tmp_trunkNameDeleteMap);
			}

			m.put("RSLT", 1);
			map.addAttribute(m);
		} catch (Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}
	
	@RequestMapping(value="duplicationCheck")
	public View duplicationCheck(ModelMap map, @RequestParam("N_TRUNK_NUMBER") Integer[] trunkNumbers, @RequestParam("S_TRUNK_NAME") String[] trunkNames, @RequestParam("N_MON_ID") int nMonId ) throws Exception {
		HashMap m = new HashMap();
		try {
			if (logger.isDebugEnabled()) {
				logger.debug("N_MON_ID : {}", nMonId);

				for (int i = 0 ; i < trunkNumbers.length ; i++) {
					logger.debug("N_TRUNK_NUMBER[{}] : {}", i, trunkNumbers);
					logger.debug("S_TRUNK_NAME[{}] : {}", i, trunkNames);
				}
			}

			Map<String, Object> params = new HashMap<String, Object>();
			params.put("N_MON_ID", nMonId);

			// duplication check
			for (int i = 0 ; i < trunkNumbers.length ; i++) {
				params.put("S_TRUNK_NAME", trunkNames[i]);
				params.put("N_TRUNK_NUMBER", trunkNumbers[i]);
				logger.debug("params: {}", params);
				Map checkInfo = service.getMap("trunk_name.duplicationCheck", params);
				Integer cnt = Integer.parseInt(String.valueOf(checkInfo.get("CNT")));
				if (cnt > 0) {
					m.put("CNT", cnt);
					m.put("N_TRUNK_NUMBER", trunkNumbers[i]);
					map.addAttribute(m);
					
					return jsonView2;
				}
			}
			m.put("RSLT", 1);
		} catch (Exception e) {
			m.put("RSLT", -9999);
			logger.error(e.getMessage(), e);
		}
		map.addAttribute(m);
		
		return jsonView2;
	}
}
