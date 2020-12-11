package com.nns.nexpector.admin.action;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

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
@RequestMapping("/admin/service_info")
public class AdminServiceInfoController {

	/** Logger */
	private static Logger logger = LoggerFactory.getLogger(AdminServiceInfoController.class);

	@Autowired
	private CommonServices service;
	@Autowired
	private View json;
/*	@Autowired
	private View jsonView2;*/
    
    public String createMapKey(int index) {
    	return "00"+(40000+index);
    }
    
	@Transactional
	@RequestMapping("insert")
	public View insert(ModelMap map, @RequestParam Map param,
			@RequestParam(value = "N_MON_ID", required = true) int nMonId,
			@RequestParam(value = "S_DAEMON_LIST", required = false) String daemonList,
			@RequestParam(value = "S_SERVICE_NAME", required = false) String[] serviceNames,
			@RequestParam(value = "S_ALIAS", required = false) String[] serviceAliases) {
		
		logger.debug(LogUtils.mapToString(param));
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String [] daemonArr = daemonList.split(",");
		
		try {
			paramMap.put("N_MON_ID", nMonId);

			service.getDelData("service_info.delete_data", paramMap);

			if (serviceNames != null && serviceNames.length > 0) {
				for (int i = 0; i < serviceNames.length; i++) {
					String processName = serviceNames[i];
					String processAlias = serviceAliases[i];

					paramMap.put("S_MAP_KEY", createMapKey(i));
					paramMap.put("S_MON_NAME", processName);
					paramMap.put("S_ALIAS", processAlias);
					paramMap.put("F_DAEMON", daemonArr[i]);

					service.getInsData("service_info.insert_data", paramMap);
				}
			}

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
	public View insert(ModelMap map, @RequestParam Map param) {
		logger.debug(LogUtils.mapToString(param));
		
		try {
			service.getDelData("service_info.delete_data", param);

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
