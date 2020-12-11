package com.nns.nexpector.admin.action;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.LogUtils;

@Controller
@RequestMapping("/admin/http_info")
public class AdminHttpInfoController {

	/** Logger */
	private static Logger logger = LoggerFactory.getLogger(AdminHttpInfoController.class);

	@Autowired
	private CommonServices service;
	@Autowired
	private View json;

	@RequestMapping("insert")
	public View insert(ModelMap map, @RequestParam Map param) {
		
		logger.debug(LogUtils.mapToString(param));
		
		try {
			service.getInsData("http_info.insert_data", param);
			map.put("RSLT", 1);

		} catch (SQLException se) {
			map.put("RSLT", -10000);
			map.put("ERRCODE", se.getErrorCode());
			map.put("ERRMSG", se.getMessage());
		} catch (Exception e) {
			map.put("RSLT", -1);
			map.put("ERRCODE", -1);
			map.put("ERRMSG", e.getMessage());
			e.printStackTrace();
		}
		return json;
	}

	@RequestMapping("update")
	public View update(ModelMap map, @RequestParam Map param) {
		
		logger.debug(LogUtils.mapToString(param));
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		try {
			service.getInsData("http_info.update_data", param);
			map.put("RSLT", 1);

		} catch (SQLException se) {
			map.put("RSLT", -10000);
			map.put("ERRCODE", se.getErrorCode());
			map.put("ERRMSG", se.getMessage());
		} catch (Exception e) {
			map.put("RSLT", -1);
			map.put("ERRCODE", -1);
			map.put("ERRMSG", e.getMessage());
			e.printStackTrace();
		}
		return json;
	}
	
	@RequestMapping("delete")
	public View delete(ModelMap map, @RequestParam Map param) {
		logger.debug(LogUtils.mapToString(param));
		
		try {
			service.getDelData("http_info.delete_data", param);

			map.put("RSLT", 1);
			
		} catch (SQLException se) {
			map.put("RSLT", -10000);
			map.put("ERRCODE", se.getErrorCode());
			map.put("ERRMSG", se.getMessage());
		} catch (Exception e) {
			map.put("RSLT", -1);
			map.put("ERRCODE", -1);
			map.put("ERRMSG", e.getMessage());
			e.printStackTrace();
		}
		return json;
	}
}
