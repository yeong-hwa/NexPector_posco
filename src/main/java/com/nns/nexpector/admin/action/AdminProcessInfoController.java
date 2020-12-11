package com.nns.nexpector.admin.action;

import java.io.File;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import com.google.common.base.Strings;
import com.neonexsoft.common.crypt.seed.SeedCBC;
import com.nns.common.TransactionTemplate;
import com.nns.common.constants.ChangeHistoryConstants;
import com.nns.common.enumeration.DaemonType;
import com.nns.common.enumeration.MonType;
import com.nns.common.util.RSACrypt;
import com.nns.common.util.Sha256;
import com.nns.common.util.WebUtil;
import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.ExcelPoiUtil;
import com.nns.util.LogUtils;
import com.sun.org.apache.xml.internal.security.utils.Base64;

@Controller
@RequestMapping("/admin/process_info")
public class AdminProcessInfoController {

	/** Logger */
	private static Logger logger = LoggerFactory.getLogger(AdminProcessInfoController.class);

	@Autowired
	private CommonServices service;
	@Autowired
	private View json;
/*	@Autowired
	private View jsonView2;*/
    
    public String createMapKey(int index) {
    	return "00"+(30000+index);
    }
    
	@Transactional
	@RequestMapping("insert")
	public View insert(ModelMap map, @RequestParam Map param,
			@RequestParam(value = "N_MON_ID", required = true) int nMonId,
			@RequestParam(value = "S_DAEMON_LIST", required = false) String daemonList,
			@RequestParam(value = "S_PROCESS_NAME", required = false) String[] processNames,
			@RequestParam(value = "S_ALIAS", required = false) String[] processAliases) {
		
		logger.debug(LogUtils.mapToString(param));
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		String [] daemonArr = daemonList.split(",");
		
		try {
			paramMap.put("N_MON_ID", nMonId);

			service.getDelData("process_info.delete_data", paramMap);

			if (processNames != null && processNames.length > 0) {
				for (int i = 0; i < processNames.length; i++) {
					String processName = processNames[i];
					String processAlias = processAliases[i];

					paramMap.put("S_MAP_KEY", createMapKey(i));
					paramMap.put("S_MON_NAME", processName);
					paramMap.put("S_ALIAS", processAlias);
					paramMap.put("F_DAEMON", daemonArr[i]);

					service.getInsData("process_info.insert_data", paramMap);
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
			service.getDelData("process_info.delete_data", param);

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
