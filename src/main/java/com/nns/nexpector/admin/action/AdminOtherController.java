package com.nns.nexpector.admin.action;

import java.io.File;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
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
import org.springframework.web.bind.annotation.PathVariable;
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
import com.nns.common.util.RSACrypt;
import com.nns.common.util.Sha256;
import com.nns.common.util.WebUtil;
import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.ExcelPoiUtil;
import com.nns.util.LogUtils;
import com.sun.org.apache.xml.internal.security.utils.Base64;

@Controller
@RequestMapping("/admin/*")
public class AdminOtherController {

	/** Logger */
	private static Logger logger = LoggerFactory.getLogger(AdminOtherController.class);

	@Autowired
	private CommonServices service;
	@Autowired
	private View jsonView2;
	@Autowired
	private View json;
	@Autowired
	private HttpSession sess;
	@Autowired
	private TransactionTemplate template;
	
    @Autowired
    private SeedCBC seedCBC;
    
    @Value("#{serviceProps['enc.key']}")
    private String encryptKey;
    
    private String charset = "UTF-8";
	
	public static final String UPDATE = "U";

	private void addParam(Map param)
	{
		param.put("SESSION_USER_ID", sess.getAttribute("S_USER_ID"));
	}

	// 이전 비밀번호 사용불가 체크
	private boolean checkPrevPassword(String id, String password) throws Exception {
		Map<String, Object> condition = new HashMap<String, Object>();
		condition.put("S_USER_ID", id);
		condition.put("change_pwd", password);
		Integer count = (Integer) service.getObject("password_his_chk", condition);
		if (count != null && count > 0) {
			return false;
		}
		return true;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("user_menu_change")
	public View getUsermenuChange(ModelMap map, @RequestParam Map param, HttpServletRequest request) {
		try {
			String str = (String)param.get("FLAG");
			String[] menu_lst = ((String)param.get("SELECT_MENU")).split(",");

			param.put("menu_lst", menu_lst);

			String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
			HashMap<String, Object> historyMap = new HashMap<String, Object>();

			historyMap.put("S_USER_ID", S_USER_ID);
			historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.USER_MENU_CHANGE_EVEVT_TYPE);
			historyMap.put("S_TARGET_USER", (String)param.get("S_USER_ID"));

			List<HashMap> list = service.getList("user_menu.getMenuName", param);
			StringBuffer sb = new StringBuffer();

			for (HashMap<String, Object> row : list) {
				sb = sb.append(row.get("S_MENU_NAME"));
				if (list.indexOf(row) != (list.size() - 1)) {
					sb.append(", ");
				}
			}

			if (str.equals("I")) {
				service.getInsData("user_menu.insUserMenu", param);
				historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.USER_MENU_ADD);
				historyMap.put("S_DATA",  sb.toString());
			}
			else if (str.equals("D")) {
				service.getDelData("user_menu.delUserMenu", param);
				historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.USER_MENU_DELETE);
				historyMap.put("S_DATA", sb.toString());
			}

			service.getInsData("change_history.insert_history", historyMap);

		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);

			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}


	@RequestMapping("user_insert")
	public View admin_user_insert(ModelMap map, @RequestParam Map param, HttpServletRequest request) {

		jsonView2 = adminUserInsertAndUpdate(map, param, "ins::user_info.insert_data;del::user_info.delAgent2;ins::user_info.insAgent2;", request, false);

		return jsonView2;
	}


	@RequestMapping("user_update")
	public View admin_user_update(ModelMap map, @RequestParam Map param, HttpServletRequest request) {

		jsonView2 = adminUserInsertAndUpdate(map, param, "upd::user_info.update_data;del::user_info.delAgent2;ins::user_info.insAgent2;", request, true);

		return jsonView2;
	}

	@RequestMapping("user_detail")
	public View getUserDetail(ModelMap map, @RequestParam Map param){
		
		try {
			HashMap userDetailMap = (HashMap) service.getMap("user_info.user_detail", param);
			List<HashMap> smsList = service.getList("user_info.sms_list", param);
			
			StringBuilder sb = new StringBuilder();
			for (HashMap sms : smsList) {
				String str = (String) sms.get("SMS_NO");

				if (sb.length() > 0)
					sb.append(",");

				sb.append(str);
			}
			userDetailMap.put("S_SMS_NO2" , sb.toString());
			
			System.out.println("userDetailMap: " + userDetailMap);
			map.addAttribute(userDetailMap);			
			
		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);

			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}
	
	private View adminUserInsertAndUpdate(ModelMap map, @RequestParam Map param, String query, HttpServletRequest request, boolean isUpdate) {
		try {
			if (param.get("S_SMS_NO_LIST") != null && !param.get("S_SMS_NO_LIST").equals("")) {
				String[] tmp_arr = param.get("S_SMS_NO_LIST").toString().split(",");
				List lst = new ArrayList();
				for (int i = 0; i < tmp_arr.length; i++) {
					String[] tmp_sms = tmp_arr[i].split(";");
					Map m = new HashMap();
					if (tmp_sms.length > 1) {
						m.put("S_SMS_NAME", tmp_sms[0]);
						m.put("S_SMS_NO", tmp_sms[1]);
						m.put("N_INDEX", i);
					}
					else if (tmp_sms.length == 1) {
						m.put("S_SMS_NO", tmp_sms[0]);
					}
					lst.add(m);
				}
				param.put("sms_list", lst);
			}

			boolean checkPassword = true;
			// 비밀번호가 공백이면 암호화 처리를 하지않고 업데이트 하지 않는다.
			if (param.get("S_USER_PWD") != null && !"".equals(param.get("S_USER_PWD").toString())) {
				String password = Sha256.encrypt(RSACrypt.decode(RSACrypt.hexToByteArray(param.get("S_USER_PWD").toString())));
				param.put("S_USER_PWD", password);

				checkPassword = checkPrevPassword(param.get("S_USER_ID").toString(), password);
			}

			if (checkPassword) {
				Map rslt_m = new HashMap();
				if (service.multiTransaction(query, param) > 0) {
					rslt_m.put("RSLT", 1);
					map.addAttribute(rslt_m);
					
					String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
					HashMap<String, Object> historyMap = new HashMap<String, Object>();
			
					historyMap.put("S_USER_ID", S_USER_ID);
					historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.USER_INFO_CHANGE_EVENT_TYPE);
					
					if (isUpdate) 
						historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.USER_INFO_MODIFY);
					else
						historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.USER_INFO_ADD);
					
					historyMap.put("S_TARGET_USER", (String)param.get("S_USER_ID"));
					historyMap.put("S_DATA", (String)param.get("S_USER_ID"));

					try {
						service.getInsData("change_history.insert_history", historyMap);
					} catch (Exception e) {
						logger.error(e.getMessage());
					}
				}
				else {
					rslt_m.put("RSLT", -1);
					map.addAttribute(rslt_m);
				}
			}
			else {
				HashMap m = new HashMap();
				m.put("RSLT", -1000);
				map.addAttribute(m);
			}
		}
		catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);

			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping("user_delete")
	public View admin_user_delete(ModelMap map, @RequestParam Map param, HttpServletRequest request) {
		try {
			if (param.get("S_SMS_NO_LIST") != null && !param.get("S_SMS_NO_LIST").equals("")) {
				String[] tmp_arr = param.get("S_SMS_NO_LIST").toString().split(",");
				List lst = new ArrayList();
				for (int i = 0 ; i < tmp_arr.length ; i++) {
					String[] tmp_sms = tmp_arr[i].split(";");
					Map m = new HashMap();
					if (tmp_sms.length > 1) {
						m.put("S_SMS_NAME", tmp_sms[0]);
						m.put("S_SMS_NO", tmp_sms[1]);
					}
					else if (tmp_sms.length == 1) {
						m.put("S_SMS_NO", tmp_sms[0]);
					}
					lst.add(m);
				}
				param.put("sms_list", lst);
			}

			String qry_lst = "del::user_info.delete_data;del::user_info.delAgent2;";

			Map rslt_m = new HashMap();
			if (service.multiTransaction(qry_lst, param) > 0) {
				rslt_m.put("RSLT", "1");
				map.addAttribute(rslt_m);

				String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
				HashMap<String, Object> historyMap = new HashMap<String, Object>();
				
				historyMap.put("S_USER_ID", S_USER_ID);
				historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.USER_INFO_CHANGE_EVENT_TYPE);
				historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.USER_INFO_DELETE);
				historyMap.put("S_TARGET_USER", (String)param.get("S_USER_ID"));
				historyMap.put("S_DATA", (String)param.get("S_USER_ID"));
			
				service.getInsData("change_history.insert_history", historyMap);
			}
			else {
				rslt_m.put("RSLT", "-1");
				map.addAttribute(rslt_m);
			}
		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);

			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}


	@RequestMapping("system_svr_group_img_change")
	public ModelAndView getSystemSvrGroupImgChange(ModelMap map, @RequestParam Map param, HttpServletRequest req, HttpServletResponse res){
		try {
			res.setContentType("text/plain");
			if (req instanceof MultipartHttpServletRequest) {
				MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) req;
				MultipartFile imgFile = multipartRequest.getFile("S_IMAGE_URL");
				File tmp_f = new File(req.getSession().getServletContext().getRealPath("/")+"upload/");
				if(!tmp_f.exists()) tmp_f.mkdir();
				imgFile.transferTo(new File(req.getSession().getServletContext().getRealPath("/")+"upload/"+imgFile.getOriginalFilename()));
				param.put("S_IMAGE_URL", req.getContextPath() + "/upload/" + imgFile.getOriginalFilename());

				service.getDelData("svr_group_img.delete_data", param);
				service.getInsData("svr_group_img.insert_data", param);

				map.addAttribute("RSLT", 1);
			}

		} catch (Exception e) {
			map.addAttribute("RSLT", -9999);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return new ModelAndView("/admin/prgm/system/svr_group_img/insert");
	}

	/*
	public static String outPrint(Map param, String name) {
		StringBuffer sb = new StringBuffer();
		String nl = "\n";
		sb.append(name + nl);

		Set set = param.keySet();
		Iterator iter = set.iterator();

		while(iter.hasNext()) {
			String key = (String)iter.next();
			sb.append("key : " + key + " , " + param.get(key) + nl);
		}
		sb.append("end." + nl);

		return sb.toString();

	}
	*/

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("insert_mon_info")
	public View insert_mon_info(ModelMap map, @RequestParam Map param, HttpServletRequest request) {

		// logger.debug(outPrint(param, "INSERT_MON_INFO"));

		HashMap m = new HashMap();

		try {

			service.getDelData("mon_info.delSnmpInfo", param);
			service.getDelData("mon_info.delIcmpInfo1", param);
			service.getDelData("mon_info.delIcmpInfo2", param);

			service.getInsData("mon_info.insert_data", param);

			// N_STYLE_CODE : SNMP
			if (param.get("N_STYLE_CODE").equals("2")) {

				// SNMP v1/v2/v3 default
				service.getInsData("mon_info.insSnmpInfo", param);
				if (param.get("N_SNMP_VERSION").equals("3")) {
					logger.debug("snmp v3 info: "+param.toString());
					
					// SNMP v3 security information
					// delete data
					service.getDelData("mon_info.delSnmpv3SecurityInfo", param);
					service.getDelData("mon_info.delTrapSecurityInfo", param);
					
					logger.debug("------- "
							+ ",N_AUTH_CODE: "+param.get("N_PRIV_CODE")
							+ ",N_PRIV_CODE: "+param.get("N_PRIV_CODE")
							+ ",total: "+param.toString()
							);
					// insert data
					service.getInsData("mon_info.insSnmpv3SecurityInfo", param);
					service.getInsData("mon_info.insTrapSecurityInfo", param);
				}
				else { // none
					logger.debug("default snmp info ~~~");
				}

				// INSERT TB_INS_COMMAND
				HashMap his_param = new HashMap();

				his_param.put("N_TO", "4");
				his_param.put("N_COMMAND", "300");
				his_param.put("N_SID", param.get("N_MON_ID"));
				his_param.put("S_VALUE", "");

				service.getInsData("insViewToProcess", his_param);

			}

			// N_STYLE_CODE : ICMP
			if (param.get("N_STYLE_CODE").equals("1")) {

				service.getInsData("mon_info.insIcmpInfo1", param);
				service.getInsData("mon_info.insIcmpInfo2", param);

				// INSERT TB_INS_COMMAND
				HashMap his_param = new HashMap();

				his_param.put("N_TO", "3");
				his_param.put("N_COMMAND", "200");
				his_param.put("N_SID", param.get("N_MON_ID"));
				his_param.put("S_VALUE", param.get("S_MON_IP"));

				service.getInsData("insViewToProcess", his_param);

			}

			// Add 14.06.10
			// N_STYLE_CODE : Agent
			if (param.get("N_STYLE_CODE").equals("0")) {

				// INSERT TB_INS_COMMAND
				HashMap his_param = new HashMap();

				his_param.put("N_TO", "1");
				his_param.put("N_COMMAND", "101");
				his_param.put("N_SID", param.get("N_MON_ID"));
				his_param.put("S_VALUE", "");

				service.getInsData("insViewToProcess", his_param);

			}

			//service.getDelData("mon_info.delUserMenu", param);
			m.put("RSLT", 1);
			map.addAttribute(m);

		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", e.getMessage());
			map.addAttribute(m);

			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
		HashMap<String, Object> historyMap = new HashMap<String, Object>();
		
		historyMap.put("S_USER_ID", S_USER_ID);
		historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.MON_INFO_CHANGE_EVENT_TYPE);
		historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.MON_INFO_ADD);
		historyMap.put("S_TARGET_USER", (String)param.get("S_USER_ID"));
		historyMap.put("S_DATA", (String)param.get("N_MON_ID"));

		try {
			service.getInsData("change_history.insert_history", historyMap);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
		
		return jsonView2;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("update_mon_info")
	public View update_mon_info(ModelMap map, @RequestParam Map param, HttpServletRequest request) {

		// logger.debug(outPrint(param, "UPDATE_MON_INFO"));

		HashMap m = new HashMap();

		try {
			Map orgData = service.getMap("mon_info.detail_info", param);

			param.put("DELETE_YN", service.getDelData("mon_info.delSnmpInfo", param));

			int tmp_cnt = service.getDelData("mon_info.delIcmpInfo1", param);
			tmp_cnt += service.getDelData("mon_info.delIcmpInfo2", param);
			param.put("DELETE_YN2", tmp_cnt);

			service.getUpdData("mon_info.update_data", param);

			// N_STYLE_CODE : SNMP
			if (param.get("N_STYLE_CODE").equals("2")) {

				service.getInsData("mon_info.insSnmpInfo", param);
				
				if (param.get("N_SNMP_VERSION").equals("3")) {
					logger.debug("snmp v3 info: "+param.toString());
					
					// SNMP v3 security information
					// delete data
					service.getDelData("mon_info.delSnmpv3SecurityInfo", param);
					service.getDelData("mon_info.delTrapSecurityInfo", param);
					
					logger.debug("------- "
							+ ",N_AUTH_CODE: "+param.get("N_PRIV_CODE")
							+ ",N_PRIV_CODE: "+param.get("N_PRIV_CODE")
							+ ",total: "+param.toString()
							);
					// insert data
					service.getInsData("mon_info.insSnmpv3SecurityInfo", param);
					service.getInsData("mon_info.insTrapSecurityInfo", param);
				}

				// INSERT TB_INS_COMMAND
				HashMap his_param = new HashMap();

				his_param.put("N_TO", "4");
				if (param.get("DELETE_YN") != null && (Integer)param.get("DELETE_YN") > 0) {

					his_param.put("N_COMMAND", "302");

				} else {

					his_param.put("N_COMMAND", "300");

				}

				his_param.put("N_SID", param.get("N_MON_ID"));
				his_param.put("S_VALUE", "");

				service.getInsData("insViewToProcess", his_param);

				if (param.get("DELETE_YN2") != null && (Integer)param.get("DELETE_YN2") > 0) {

					// INSERT TB_INS_COMMAND
					HashMap his_param2 = new HashMap();

					his_param2.put("N_TO", "3");
					his_param2.put("N_COMMAND", "201");
					his_param2.put("N_SID", param.get("N_MON_ID"));
					his_param2.put("S_VALUE", param.get("S_MON_IP"));

					service.getInsData("insViewToProcess", his_param2);

				}

				if (orgData != null && orgData.get("N_MON_ID") != null) {
					// 이전 값이 Agent 이면
					if (orgData.get("N_STYLE_CODE").toString().equals("0")) {
						// INSERT TB_INS_COMMAND
						HashMap his_param2 = new HashMap();

						his_param2.put("N_TO", "1");
						his_param2.put("N_COMMAND", "103");
						his_param2.put("N_SID", param.get("N_MON_ID"));
						his_param2.put("S_VALUE", "");

						service.getInsData("insViewToProcess", his_param2);
					}
				}


			// N_STYLE_CODE : ICMP
			} else if (param.get("N_STYLE_CODE").equals("1")) {

				service.getInsData("mon_info.insIcmpInfo1", param);
				service.getInsData("mon_info.insIcmpInfo2", param);

				// INSERT TB_INS_COMMAND
				HashMap his_param = new HashMap();

				his_param.put("N_TO", "3");
				if (param.get("DELETE_YN2") != null && (Integer)param.get("DELETE_YN2") > 0) {

					his_param.put("N_COMMAND", "202");

				} else {

					his_param.put("N_COMMAND", "200");

				}
				his_param.put("N_SID", param.get("N_MON_ID"));
				his_param.put("S_VALUE", param.get("S_MON_IP"));

				service.getInsData("insViewToProcess", his_param);

				if (param.get("DELETE_YN") != null && (Integer)param.get("DELETE_YN") > 0) {

					// INSERT TB_INS_COMMAND
					HashMap his_param2 = new HashMap();

					his_param2.put("N_TO", "4");
					his_param2.put("N_COMMAND", "301");
					his_param2.put("N_SID", param.get("N_MON_ID"));
					his_param2.put("S_VALUE", "");

					service.getInsData("insViewToProcess", his_param2);
				}

				if (orgData != null && orgData.get("N_MON_ID") != null) {
					// 이전 값이 Agent 이면
					if (orgData.get("N_STYLE_CODE").toString().equals("0")) {
						// INSERT TB_INS_COMMAND
						HashMap his_param2 = new HashMap();

						his_param2.put("N_TO", "1");
						his_param2.put("N_COMMAND", "103");
						his_param2.put("N_SID", param.get("N_MON_ID"));
						his_param2.put("S_VALUE", "");

						service.getInsData("insViewToProcess", his_param2);
					}
				}

			// Add 14.06.10
			// N_STYLE_CODE : Agent
			} else if (param.get("N_STYLE_CODE").equals("0")) {


				if (orgData != null && orgData.get("N_MON_ID") != null) {
					// 이전 값이 Agent 이면 update
					if (orgData.get("N_STYLE_CODE").toString().equals("0")) {

						// INSERT TB_INS_COMMAND
						HashMap his_param2 = new HashMap();
						his_param2.put("N_TO", "1");
						his_param2.put("N_COMMAND", "102");
						his_param2.put("N_SID", param.get("N_MON_ID"));
						his_param2.put("S_VALUE", "");

						service.getInsData("insViewToProcess", his_param2);

					} else {

						// INSERT TB_INS_COMMAND
						HashMap his_param2 = new HashMap();

						his_param2.put("N_TO", "1");
						his_param2.put("N_COMMAND", "101");
						his_param2.put("N_SID", param.get("N_MON_ID"));
						his_param2.put("S_VALUE", "");

						service.getInsData("insViewToProcess", his_param2);
					}
				}


				if (param.get("DELETE_YN") != null && (Integer)param.get("DELETE_YN") > 0) {

					// INSERT TB_INS_COMMAND
					HashMap his_param = new HashMap();

					his_param.put("N_TO", "4");
					his_param.put("N_COMMAND", "301");
					his_param.put("N_SID", param.get("N_MON_ID"));
					his_param.put("S_VALUE", "");

					service.getInsData("insViewToProcess", his_param);
				}

				if (param.get("DELETE_YN2") != null && (Integer)param.get("DELETE_YN2") > 0) {

					// INSERT TB_INS_COMMAND
					HashMap his_param = new HashMap();

					his_param.put("N_TO", "3");
					his_param.put("N_COMMAND", "201");
					his_param.put("N_SID", param.get("N_MON_ID"));
					his_param.put("S_VALUE", param.get("S_MON_IP"));

					service.getInsData("insViewToProcess", his_param);
				}

			} else {

				if (param.get("DELETE_YN") != null && (Integer)param.get("DELETE_YN") > 0) {

					// INSERT TB_INS_COMMAND
					HashMap his_param = new HashMap();

					his_param.put("N_TO", "4");
					his_param.put("N_COMMAND", "301");
					his_param.put("N_SID", param.get("N_MON_ID"));
					his_param.put("S_VALUE", "");

					service.getInsData("insViewToProcess", his_param);
				}

				if (param.get("DELETE_YN2") != null && (Integer)param.get("DELETE_YN2") > 0) {

					// INSERT TB_INS_COMMAND
					HashMap his_param = new HashMap();

					his_param.put("N_TO", "3");
					his_param.put("N_COMMAND", "201");
					his_param.put("N_SID", param.get("N_MON_ID"));
					his_param.put("S_VALUE", param.get("S_MON_IP"));

					service.getInsData("insViewToProcess", his_param);
				}

				if (orgData != null && orgData.get("N_MON_ID") != null) {
					// 이전 값이 Agent 이면
					if (orgData.get("N_STYLE_CODE").toString().equals("0")) {
						// INSERT TB_INS_COMMAND
						HashMap his_param2 = new HashMap();

						his_param2.put("N_TO", "1");
						his_param2.put("N_COMMAND", "103");
						his_param2.put("N_SID", param.get("N_MON_ID"));
						his_param2.put("S_VALUE", "");

						service.getInsData("insViewToProcess", his_param2);
					}
				}
			}

			//service.getDelData("mon_info.delUserMenu", param);
			m.put("RSLT", 1);
			map.addAttribute(m);

			String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
			HashMap<String, Object> historyMap = new HashMap<String, Object>();
			
			historyMap.put("S_USER_ID", S_USER_ID);
			historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.MON_INFO_CHANGE_EVENT_TYPE);
			historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.MON_INFO_MODIFY);
			historyMap.put("S_TARGET_USER", (String)param.get("S_USER_ID"));
			historyMap.put("S_DATA", (String)param.get("N_MON_ID"));
			
			service.getInsData("change_history.insert_history", historyMap);
		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", e.getMessage());
			map.addAttribute(m);

			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}
		
		return jsonView2;
	}


	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("delete_mon_info")
	@Transactional
	public View delete_mon_info(@RequestParam(value="MON_INFO_DELETE_LIST", required=true) String monInfoDeleteList,
							ModelMap map, HttpServletRequest request) throws Exception {

		HashMap m = new HashMap();
		List<String> monInfoList = new ArrayList<String>();
		
		try {
			String[] tmp_monInfoDeleteListArr = monInfoDeleteList.split(",");
			for (int i = 0; i < tmp_monInfoDeleteListArr.length; i++) {
				String[] tmp_monInfoDeleteArr = tmp_monInfoDeleteListArr[i].split(";");
	    		Map tmp_monInfoDeleteMap = new HashMap();
	    		tmp_monInfoDeleteMap.put("N_MON_ID", tmp_monInfoDeleteArr[0]);
	    		tmp_monInfoDeleteMap.put("S_MON_IP", tmp_monInfoDeleteArr[1]);
	    		monInfoList.add(tmp_monInfoDeleteArr[0]);
	    		
	    		Map data = service.getMap("mon_info.detail_info", tmp_monInfoDeleteMap);
	    		service.getDelData("mon_info.delSnmpInfo", tmp_monInfoDeleteMap);
				service.getDelData("mon_info.delIcmpInfo1", tmp_monInfoDeleteMap);
				service.getDelData("mon_info.delIcmpInfo2", tmp_monInfoDeleteMap);
				service.getDelData("mon_info.delCriticalValue", tmp_monInfoDeleteMap);
				
				/* mon_id와 관련 된 테이블들을 삭제(지우지 않으면 데이터가 꼬임) == START == */
				service.getDelData("mon_info_delete.delAbandonedThreshold", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delAlm", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delAlmGenLegend", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delAlmHistory", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delAlmLink", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delAlmSendHistory", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delAlmSendInfo", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delAlmWorkMon", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCliDbNetbackupMedia", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCliDbNetbackupStatus", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCliDbNetbackupStatus2", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCliDbNetbackupTpconf", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCliIvrListSessions", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCliPbxCapacity", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCliPbxTrafficTrunk", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCliPbxTrafficTrunkAvg", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCliScriptInfo", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCliServerInfo", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCliTrunkDialingInfo", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delComponent", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCtiChannel", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCtiChannelDayAvg", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCtiChannelDayPeak", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delCtiChannelHistory", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delDbInfo", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delFax3SumDoc", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delFax3SumQueue", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delFaxChannel", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delFaxChannelDayAvg", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delFaxChannelDayPeak", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delFaxChannelHistory", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delInsAgentInfo", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delIvrAppThreshold", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delIvrChannel", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delIvrChannelDayAvg", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delIvrChannelDayPeak", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delIvrChannelHistory", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonAccessInfo", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonAccrueProcess", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonAccrueResource", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonAccrueResourceAvg", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonAccrueService", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonCallAccrueHour", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonContactList", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonCtiChannel", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonFax3Channel", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonIcmpInfo", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonIcmpRes", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonIvrChannel", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonIvrScenario", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonMap", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonRealProcess", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonRealResource", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonRealService", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonVrsChannel", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delNetMapping", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delNetNodeInfo", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delPbxChannel", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delPbxChannelDayAvg", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delPbxChannelDayPeak", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delPbxChannelHistory", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delPbxTrunkThreshold", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delRecChannel", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delRecChannelDayAvg", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delRecChannelDayPeak", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delRecChannelHistory", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delRecDbBackupcheck", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delService", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpv3SecurityInfo", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpAlmMap", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpInfo", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpMap", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Alarm", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01AlarmCnt", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Board", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Default", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Health", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Hunt", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Huntlist", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM01Ipphone", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Ipphonedata", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Ipsi", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01NowAlarm", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Occupancy", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Phone", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Pnload", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Restart", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Trunk", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Update", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM01Version", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02Cti", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02Default", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02Ext", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02Gk", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02Gw", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02H323", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02Media", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02Nic", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02Phone", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02Sip", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02Sw", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02Trunk", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM02Vm", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM03Default", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM03Dsp", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM03E1Accrue", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM03E1Status", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM03EnvFan", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM03EnvPower", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM03EnvTemp", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM03EnvVolt", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM03If", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM03Isdn", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM03Vaif", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM04Default", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM04If", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM04TrafficDay", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM04TrafficMonth", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM04TrafficYear", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM05Ccm", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM05Ch", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM05Default", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM05If", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM05Lcm", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM05Loc", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM05Slot", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM06Default", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM06If", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM06TrafficDay", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM06TrafficMonth", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM06TrafficYear", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM07Default", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM07If", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM07TrafficDay", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM07TrafficMonth", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM07TrafficYear", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM08Default", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09Battery", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09Bypass", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09BypassEntry", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09BypassTotal", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09Default", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09Input", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09InEntry", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09InTotal", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09Output", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09OutEntry", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09OutTotal", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09Rating", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM09Test", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM09Ups", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM10Alarm", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM10AlarmStatus", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM10Default", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM10NowStatus", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM10Operation", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM10OperStatus", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM11Default", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM11IfStatus", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM11PacketsDay", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM11PacketsHour", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM11PacketsMonth", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM11PacketsRaw", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM12Default", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM12IfStatus", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM12PacketsDay", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM12PacketsHour", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM12PacketsMonth", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delSnmpRealM12PacketsRaw", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSnmpRealM13Sensor", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delSvrGroupPosition", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delThreshold", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delTrapAvayaCm", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delTrapFwMf2", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delTrapSecurityInfo", tmp_monInfoDeleteMap);
//				service.getDelData("mon_info_delete.delTrapStdLink", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delUserMonList", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delVgManager", tmp_monInfoDeleteMap);
				service.getDelData("mon_info_delete.delMonInfo", tmp_monInfoDeleteMap);
				/* mon_id와 관련 된 테이블들을 삭제(지우지 않으면 데이터가 꼬임) == END == */
				
				if (data != null && data.get("N_MON_ID") != null) {
					HashMap command = new HashMap();

					// N_STYLE_CODE : SNMP
					if (data.get("N_STYLE_CODE").toString().equals("2")) {

						command.put("N_TO", "4");
						command.put("N_COMMAND", "301");
						command.put("N_SID", data.get("N_MON_ID").toString());
						command.put("S_VALUE", "");
						service.getInsData("insViewToProcess", command);

						// N_STYLE_CODE : ICMP
					} else if (data.get("N_STYLE_CODE").toString().equals("1")) {

						command.put("N_TO", "3");
						command.put("N_COMMAND", "201");
						command.put("N_SID", data.get("N_MON_ID").toString());
						command.put("S_VALUE", data.get("S_MON_IP").toString());
						service.getInsData("insViewToProcess", command);

						// N_STYLE_CODE : Agent
					} else if (data.get("N_STYLE_CODE").toString().equals("0")) {
						command.put("N_TO", "1");
						command.put("N_COMMAND", "103");
						command.put("N_SID", data.get("N_MON_ID").toString());
						command.put("S_VALUE", "");
						service.getInsData("insViewToProcess", command);

					}
				}
			}
			
			
			/* 기존 단건 지우기 로직
			Map data = service.getMap("mon_info.detail_info", param);

			service.getDelData("mon_info.delSnmpInfo", param);
			service.getDelData("mon_info.delIcmpInfo1", param);
			service.getDelData("mon_info.delIcmpInfo2", param);
			service.getDelData("mon_info.delCriticalValue", param);

			// 국세청 대시보드 맵핑 정보 삭제.TB_NET_MAPPING
			//service.getDelData("mon_info.delNetMapping", param);

			service.getDelData("mon_info.delete_data", param);

			if (data != null && data.get("N_MON_ID") != null) {

				HashMap command = new HashMap();

				// N_STYLE_CODE : SNMP
				if (data.get("N_STYLE_CODE").toString().equals("2")) {

					command.put("N_TO", "4");
					command.put("N_COMMAND", "301");
					command.put("N_SID", data.get("N_MON_ID").toString());
					command.put("S_VALUE", "");
					service.getInsData("insViewToProcess", command);

					// N_STYLE_CODE : ICMP
				} else if (data.get("N_STYLE_CODE").toString().equals("1")) {

					command.put("N_TO", "3");
					command.put("N_COMMAND", "201");
					command.put("N_SID", data.get("N_MON_ID").toString());
					command.put("S_VALUE", data.get("S_MON_IP").toString());
					service.getInsData("insViewToProcess", command);

					// N_STYLE_CODE : Agent
				} else if (data.get("N_STYLE_CODE").toString().equals("0")) {
					command.put("N_TO", "1");
					command.put("N_COMMAND", "103");
					command.put("N_SID", data.get("N_MON_ID").toString());
					command.put("S_VALUE", "");
					service.getInsData("insViewToProcess", command);

				}

			}
			*/
			
			m.put("RSLT", 1);
			map.addAttribute(m);
			
			String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
			HashMap<String, Object> historyMap = new HashMap<String, Object>();
			
			String monInfoStr = monInfoList.toString();
			monInfoStr = monInfoStr.replace("[", "");
			monInfoStr = monInfoStr.replace("]", "");
			
			historyMap.put("S_USER_ID", S_USER_ID);
			historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.MON_INFO_CHANGE_EVENT_TYPE);
			historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.MON_INFO_DELETE);
			historyMap.put("S_DATA", monInfoStr);
			
			service.getInsData("change_history.insert_history", historyMap);
		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", e.getMessage());
			map.addAttribute(m);

			//logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}
		
		return jsonView2;
	}


	@SuppressWarnings({ "rawtypes", "unchecked" })
	public ArrayList almMakeParam(String str){
		ArrayList tmp = new ArrayList();
		StringTokenizer tkn = new StringTokenizer(str, ";");
		while(tkn.hasMoreTokens())	{	tmp.add(tkn.nextToken());	}

		return tmp;
	}

	@RequestMapping("reg_user_alarm")
	public View reg_user_alarm(ModelMap map,
									   @RequestParam("USER_ID") String[] users,
									   @RequestParam("SVR_ID") String[] servers,
									   @RequestParam("ALM_RATING_CODE") String[] alarmRatings,
									   @RequestParam("ALM_SEND_CODE") String[] alarmSends,
									   @RequestParam("ALM_TYPE_CODE") String[] alarmTypes,
									   @RequestParam Map<String, Object> params,
									   HttpServletRequest request) {
		try {
			params.put("user_lst", users);
			params.put("svr_lst", servers);
			params.put("alm_rating_lst", alarmRatings);
			params.put("alm_send_lst", alarmSends);

			List tmp = Arrays.asList(alarmTypes);
			List<Map<String, String>> tmp2 = new ArrayList();

			for (int i = 0; i < tmp.size(); i++) {
				Map<String, String> m = new HashMap<String, String>();
				String[] arrStr = ((String) tmp.get(i)).split("-");

				if (arrStr.length == 2) {
					m.put("N_ALM_TYPE", arrStr[0]);
					m.put("N_ALM_CODE", arrStr[1]);
				}
				tmp2.add(m);
			}
			params.put("alm_type_lst", tmp2);

			if (service.getInsData("insAlarm", params) > 0) {
				map.addAttribute("RSLT", 1);
				
				String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
				HashMap<String, Object> historyMap = new HashMap<String, Object>();
				
				String userStr = Arrays.toString(users);
				userStr = userStr.replace("[", "");
				userStr = userStr.replace("]", "");
				
				historyMap.put("S_USER_ID", S_USER_ID);
				historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.ALM_INFO_CHANGE_EVENT_TYPE);
				historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.ALM_INFO_ADD);
				historyMap.put("S_DATA", userStr);
				
				service.getInsData("change_history.insert_history", historyMap);
				
			} else {
				map.addAttribute("RSLT", 0);
			}
		}
		catch (Exception e) {
			map.addAttribute("RSLT", -9999);
			logger.error("request parameter:" + LogUtils.mapToString(params));
			logger.error(e.getMessage(), e);
		}

		return json;
	}

	@RequestMapping("multiRemoveUserAlarm")
	@Transactional
	public View multiRemoveUserAlarm(final ModelMap map, @RequestParam("DEL_KEY") final String[] removeKeys, HttpServletRequest request) throws Exception {

		try {
			Map<String, Object> params = new HashMap<String, Object>();
			List <String> armIdList = new ArrayList<String>();
			
			int removeCount = 0;
			for (String str : removeKeys) {
				String[] args = str.split(";");
				params.put("N_MON_ID", args[0]);
				params.put("N_ALM_TYPE", args[1]);
				params.put("N_ALM_CODE", args[2]);
				params.put("OLD_N_ALM_RATING", args[3]);
				params.put("OLD_N_ST_TIME", args[4]);
				params.put("OLD_N_ED_TIME", args[5]);
				params.put("OLD_F_SEND_MONDAY", args[6]);
				params.put("OLD_F_SEND_TUESDAY", args[7]);
				params.put("OLD_F_SEND_WEDNESDAY", args[8]);
				params.put("OLD_F_SEND_THURSDAY", args[9]);
				params.put("OLD_F_SEND_FRIDAY", args[10]);
				params.put("OLD_F_SEND_SATURDAY", args[11]);
				params.put("OLD_F_SEND_SUNDAY", args[12]);
				params.put("S_USER_ID", args[13]);
				params.put("OLD_N_SEND_CODE", args[14]);

				removeCount += service.getDelData("user_alarm.delAlarm", params);
				armIdList.add(args[0]);
			}

			if (removeCount == removeKeys.length) {
				map.addAttribute("RSLT", 1);
				
				String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
				HashMap<String, Object> historyMap = new HashMap<String, Object>();
				
				String armIdStr = armIdList.toString();
				armIdStr = armIdStr.replace("[", "");
				armIdStr = armIdStr.replace("]", "");
				
				historyMap.put("S_USER_ID", S_USER_ID);
				historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.ALM_INFO_CHANGE_EVENT_TYPE);
				historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.ALM_INFO_DELETE);
				historyMap.put("S_DATA", armIdStr);
				
				service.getInsData("change_history.insert_history", historyMap);
				
			} else {
				map.addAttribute("RSLT", 0);
			}
		}
		catch (Exception e) {
			map.addAttribute("RSLT", -9999);
			logger.error("request parameter : {}", StringUtils.join(removeKeys, ", "));
			logger.error("알람 다중 삭제 에러!", e);
			throw e;

		}

		return json;
	}

	@RequestMapping("remove_user_alarm")
	public View removeUserAlarm(ModelMap map, @RequestParam Map param, HttpServletRequest request){
		addParam(param);
		String qry_name = "user_alarm.delAlarm";
		HashMap m = new HashMap();
		
		try {
			m.put("RSLT", service.getDelData(qry_name, param));
			map.addAttribute(m);
			
			String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
			HashMap<String, Object> historyMap = new HashMap<String, Object>();
			
			historyMap.put("S_USER_ID", S_USER_ID);
			historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.ALM_INFO_CHANGE_EVENT_TYPE);
			historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.ALM_INFO_DELETE);
			historyMap.put("S_DATA", (String)param.get("N_MON_ID"));
			
			service.getInsData("change_history.insert_history", historyMap);

		}
		catch(SQLException se) {
			m.put("RSLT", -10000);
			m.put("ERRCODE", se.getErrorCode());
			m.put("ERRMSG", se.getMessage());
			map.addAttribute(m);
			logger.error("qry_name:" + qry_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error("message:" + se.getMessage() + ", code:" + se.getErrorCode(), se);
		}
		catch(Exception e) {
			m.put("RSLT", -1);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", e.getMessage());
			map.addAttribute(m);
			logger.error("qry_name:" + qry_name);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}
	
	@RequestMapping("update_user_alarm")
	public View updateUserAlarm(ModelMap map, @RequestParam Map param, HttpServletRequest request){
		addParam(param);
		String qryName = "user_alarm.updAlarm";
		HashMap m = new HashMap();
		
		try {
			m.put("RSLT", service.getUpdData("user_alarm.updAlarm", param));
			map.addAttribute(m);
			
			String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
			HashMap<String, Object> historyMap = new HashMap<String, Object>();
			
			String armIdStr = (String)param.get("N_MON_ID");
			armIdStr = armIdStr.replace("[", "");
			armIdStr = armIdStr.replace("]", "");
			
			historyMap.put("S_USER_ID", S_USER_ID);
			historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.ALM_INFO_CHANGE_EVENT_TYPE);
			historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.ALM_INFO_MODIFY);
			historyMap.put("S_TARGET_USER", (String)param.get("S_USER_ID"));
			historyMap.put("S_DATA", armIdStr);
			
			service.getInsData("change_history.insert_history", historyMap);
			
		}
		catch(SQLException se) {
			m.put("RSLT", -10000);
			m.put("ERRCODE", se.getErrorCode());
			m.put("ERRMSG", se.getMessage());
			map.addAttribute(m);
			logger.error("qry_name:" + qryName);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error("message:" + se.getMessage() + ", code:" + se.getErrorCode(), se);
		}
		catch(Exception e) {
			m.put("RSLT", -1);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", e.getMessage());
			map.addAttribute(m);
			logger.error("qry_name:" + qryName);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("reg_critical_value")
	public View reg_critical_value(ModelMap map, @RequestParam Map param, HttpServletRequest req){
		try {
			param.put("svr_lst", almMakeParam((String)param.get("SVR_ID")));
			service.getDelData("critical_value.delete_data", param);
			service.getInsData("critical_value.insert_data", param);

			Map data = service.getMap("mon_info.detail_info", param);
			if (data != null && data.get("N_MON_ID") != null) {
				HashMap command = new HashMap();

				// N_STYLE_CODE : SNMP
				if (data.get("N_STYLE_CODE").toString().equals("2")) {

					command.put("N_TO", "4");
					command.put("N_COMMAND", "100");
					command.put("N_SID", data.get("N_MON_ID").toString());
					command.put("S_VALUE", "");
					service.getInsData("insViewToProcess", command);

			    // N_STYLE_CODE : ICMP
				} else if (data.get("N_STYLE_CODE").toString().equals("1")) {

					command.put("N_TO", "3");
					command.put("N_COMMAND", "100");
					command.put("N_SID", data.get("N_MON_ID").toString());
					command.put("S_VALUE", data.get("S_MON_IP").toString());
					service.getInsData("insViewToProcess", command);

			    // N_STYLE_CODE : Agent
				} else {

					command.put("N_TO", "1");
					command.put("N_COMMAND", "100");
					command.put("N_SID", data.get("N_MON_ID").toString());
					command.put("S_VALUE", "");
					service.getInsData("insViewToProcess", command);

				}
			}

			map.addAttribute("RSLT", 1);
		}
		catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("delete_critical_value")
	public View delete_critical_value(ModelMap map, @RequestParam Map param, HttpServletRequest req){
		
		HashMap m = new HashMap();
		
		try {
			param.put("svr_lst", almMakeParam((String)param.get("CRITICAL_VALUE_DELETE_LIST")));
			service.getDelData("critical_value.delete_data", param);
			
			String tmp_criticalValueDelete = (String) param.get("CRITICAL_VALUE_DELETE_LIST");
			String[] tmp_criticalValueDeleteArr = tmp_criticalValueDelete.split(";");
			for (int i = 0; i < tmp_criticalValueDeleteArr.length; i++) {
				param.put("N_MON_ID", tmp_criticalValueDeleteArr[i]);
				Map data = service.getMap("mon_info.detail_info", param);
				
				if (data != null && data.get("N_MON_ID") != null) {
					HashMap command = new HashMap();

					// N_STYLE_CODE : SNMP
					if (data.get("N_STYLE_CODE").toString().equals("2")) {

						command.put("N_TO", "4");
						command.put("N_COMMAND", "100");
						command.put("N_SID", data.get("N_MON_ID").toString());
						command.put("S_VALUE", "");
						service.getInsData("insViewToProcess", command);

				    // N_STYLE_CODE : ICMP
					} else if (data.get("N_STYLE_CODE").toString().equals("1")) {

						command.put("N_TO", "3");
						command.put("N_COMMAND", "100");
						command.put("N_SID", data.get("N_MON_ID").toString());
						command.put("S_VALUE", data.get("S_MON_IP").toString());
						service.getInsData("insViewToProcess", command);

				    // N_STYLE_CODE : Agent
					} else {

						command.put("N_TO", "1");
						command.put("N_COMMAND", "100");
						command.put("N_SID", data.get("N_MON_ID").toString());
						command.put("S_VALUE", "");
						service.getInsData("insViewToProcess", command);

					}
				}
			}
			map.addAttribute("RSLT", 1);
			map.addAttribute(m);
		}
		catch(Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}
		return jsonView2;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("delete_snmp_alarm")
	public View delete_snmp_alarm(ModelMap map, @RequestParam Map param, HttpServletRequest req){
		
		HashMap m = new HashMap();
		
		try {
			String snmpAlarmDeleteList = (String) param.get("SNMP_ALARM_DELETE_LIST");
			String[] snmpAlarmDeleteListArr = snmpAlarmDeleteList.split(",");
			
			for (int i = 0; i < snmpAlarmDeleteListArr.length; i++) {
				String[] tmp_snmpAlarmDeleteArr = snmpAlarmDeleteListArr[i].split(";");
	    		Map tmp_snmpAlarmDeleteMap = new HashMap();
	    		tmp_snmpAlarmDeleteMap.put("N_MON_ID", tmp_snmpAlarmDeleteArr[0]);
	    		tmp_snmpAlarmDeleteMap.put("N_SNMP_MAN_CODE", tmp_snmpAlarmDeleteArr[1]);
	    		tmp_snmpAlarmDeleteMap.put("N_SNMP_MON_CODE", tmp_snmpAlarmDeleteArr[2]);
	    		tmp_snmpAlarmDeleteMap.put("N_SNMP_TYPE_CODE", tmp_snmpAlarmDeleteArr[3]);
	    		tmp_snmpAlarmDeleteMap.put("N_ALM_RATING", tmp_snmpAlarmDeleteArr[4]);
	    		
				service.getDelData("snmp_alarm.delete_data", tmp_snmpAlarmDeleteMap);
			}
			map.addAttribute("RSLT", 1);
			map.addAttribute(m);
		}
		catch(Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}
		return jsonView2;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("reg_rating")
	public View reg_rating_value(ModelMap map, @RequestParam Map param, HttpServletRequest req){
		try {
			service.getDelData("rating.delete_data", param);
			service.getInsData("rating.insert_data", param);

			map.addAttribute("RSLT", 1);
		}
		catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}


	@RequestMapping("ipphone_change")
	public View getIpphoneChange(ModelMap map, @RequestParam Map param){
		try {
			String str = (String)param.get("FLAG");

			String[] menu_lst = ((String)param.get("SELECT_MENU")).split(",");

			param.put("menu_lst", menu_lst);

			if(str.equals("I"))
			{
				service.getInsData("ipphone.insIpphone", param);
			}
			else if(str.equals("D"))
			{
				service.getDelData("ipphone.delIpphone", param);
			}
		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping("ipphone_insert")
	public View admin_ipphone_insert(ModelMap map, @RequestParam Map param){
		try {
			if(param.get("S_SMS_NO_LIST") != null && !param.get("S_SMS_NO_LIST").equals(""))
			{
				String[] tmp_arr = param.get("S_SMS_NO_LIST").toString().split(",");
				List lst = new ArrayList();
				for(int i=0;i<tmp_arr.length;i++)
				{
					String[] tmp_sms = tmp_arr[i].split(";");
					Map m = new HashMap();
					if(tmp_sms.length > 1)
					{
						m.put("S_SMS_NAME", tmp_sms[0]);
						m.put("S_SMS_NO", tmp_sms[1]);
					}
					else if(tmp_sms.length == 1)
					{
						m.put("S_SMS_NO", tmp_sms[0]);
					}
					lst.add(m);
				}
				param.put("sms_list", lst);
			}

			String qry_lst = "ins::user_info.insert_data;del::user_info.delAgent2;ins::user_info.insAgent2;";

			Map rslt_m = new HashMap();
			if(service.multiTransaction(qry_lst, param) > 0)
			{
				rslt_m.put("RSLT", "1");
				map.addAttribute(rslt_m);
			}
			else
			{
				rslt_m.put("RSLT", "-1");
				map.addAttribute(rslt_m);
			}
		}
		catch(Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping("ipphone_update")
	public View admin_ipphone_update(ModelMap map, @RequestParam Map param){
		try {
			if(param.get("S_SMS_NO_LIST") != null && !param.get("S_SMS_NO_LIST").equals(""))
			{
				String[] tmp_arr = param.get("S_SMS_NO_LIST").toString().split(",");
				List lst = new ArrayList();
				for(int i=0;i<tmp_arr.length;i++)
				{
					String[] tmp_sms = tmp_arr[i].split(";");
					Map m = new HashMap();
					if(tmp_sms.length > 1)
					{
						m.put("S_SMS_NAME", tmp_sms[0]);
						m.put("S_SMS_NO", tmp_sms[1]);
					}
					else if(tmp_sms.length == 1)
					{
						m.put("S_SMS_NO", tmp_sms[0]);
					}
					lst.add(m);
				}
				param.put("sms_list", lst);
			}

			String qry_lst = "upd::user_info.update_data;del::user_info.delAgent2;ins::user_info.insAgent2;";

			Map rslt_m = new HashMap();
			if(service.multiTransaction(qry_lst, param) > 0)
			{
				rslt_m.put("RSLT", "1");
				map.addAttribute(rslt_m);
			}
			else
			{
				rslt_m.put("RSLT", "-1");
				map.addAttribute(rslt_m);
			}
		}
		catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping("ipphone_delete")
	public View admin_ipphone_delete(ModelMap map, @RequestParam Map param){
		try {
			if(param.get("S_SMS_NO_LIST") != null && !param.get("S_SMS_NO_LIST").equals(""))
			{
				String[] tmp_arr = param.get("S_SMS_NO_LIST").toString().split(",");
				List lst = new ArrayList();
				for(int i=0;i<tmp_arr.length;i++)
				{
					String[] tmp_sms = tmp_arr[i].split(";");
					Map m = new HashMap();
					if(tmp_sms.length > 1)
					{
						m.put("S_SMS_NAME", tmp_sms[0]);
						m.put("S_SMS_NO", tmp_sms[1]);
					}
					else if(tmp_sms.length == 1)
					{
						m.put("S_SMS_NO", tmp_sms[0]);
					}
					lst.add(m);
				}
				param.put("sms_list", lst);
			}

			String qry_lst = "del::user_info.delete_data;del::user_info.delAgent2;";

			Map rslt_m = new HashMap();
			if(service.multiTransaction(qry_lst, param) > 0)
			{
				rslt_m.put("RSLT", "1");
				map.addAttribute(rslt_m);
			}
			else
			{
				rslt_m.put("RSLT", "-1");
				map.addAttribute(rslt_m);
			}
		}
		catch(Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}
	
	// 작업 관리 등록 추가 2014-12-26 
		@SuppressWarnings({ "unchecked", "rawtypes" })
		@RequestMapping("jobwork_insert")
		public View jobwork_insert(ModelMap map, @RequestParam Map param, HttpServletRequest req){
			try{			

				service.getInsData("jobmanagement.insert_data", param);
				if(param.get("SVR_ID") != null && !param.get("SVR_ID").equals(""))
				{
					String[] tmp_arr = param.get("SVR_ID").toString().split(";");
					List lst = new ArrayList();
					for(int i=0;i<tmp_arr.length;i++)
					{
						Map m = new HashMap();
						m.put("N_MON_ID", tmp_arr[i]);

						lst.add(m);
					}
					param.put("mon_id_list", lst);
				}

				service.multiTransaction("jobmanagement.insert_data_mon", param);
				map.addAttribute("RSLT", 1);
				
			}catch(Exception e){
				HashMap m = new HashMap();
				m.put("RSLT", -9999);
				map.addAttribute(m);
				logger.error("request parameter:" + LogUtils.mapToString(param));
				logger.error(e.getMessage(), e);
			}

			return jsonView2;
		}

		// 작업 관리 수정 추가 2014-12-26 
		@SuppressWarnings({ "unchecked", "rawtypes" })
		@RequestMapping("jobwork_update")
		public View jobwork_update(ModelMap map, @RequestParam Map param, HttpServletRequest req){

			try{			
				service.getInsData("jobmanagement.update_data", param);
				service.getDelData("jobmanagement.delete_data_mon", param);

				if(param.get("SVR_ID") != null && !param.get("SVR_ID").equals(""))
				{
					String[] tmp_arr = param.get("SVR_ID").toString().split(";");
					List lst = new ArrayList();
					for(int i=0;i<tmp_arr.length;i++)
					{
						Map m = new HashMap();
						m.put("N_MON_ID", tmp_arr[i]);

						lst.add(m);
					}
					param.put("mon_id_list", lst);
				}

				service.multiTransaction("jobmanagement.insert_data_mon", param);

				map.addAttribute("RSLT", 1);
				
			}catch(Exception e){
				HashMap m = new HashMap();
				m.put("RSLT", -9999);
				map.addAttribute(m);
				logger.error("request parameter:" + LogUtils.mapToString(param));
				logger.error(e.getMessage(), e);
			}

			return jsonView2;
		}
	
	// 작업 관리 수정 추가 2014-12-26 
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("jobwork_delete")
	public View jobwork_delete(ModelMap map, @RequestParam Map param, HttpServletRequest req){
		
		HashMap m = new HashMap();
		
		try {
			String jobmanagementDeleteList = (String) param.get("JOBMANAGEMENT_DELETE_LIST");
			String[] jobmanagementDeleteListArr = jobmanagementDeleteList.split(",");
			for (int i = 0; i < jobmanagementDeleteListArr.length; i++) {
	    		Map tmp_jobmanagementDeleteMap = new HashMap();
	    		tmp_jobmanagementDeleteMap.put("S_WORK_KEY", jobmanagementDeleteListArr[i]);
	    		service.getDelData("jobmanagement.delete_data", tmp_jobmanagementDeleteMap);	    		
				service.getDelData("jobmanagement.delete_data_mon", tmp_jobmanagementDeleteMap);			
			}
			/*
			service.getInsData("jobmanagement.delete_data", param);
			service.getInsData("jobmanagement.delete_data_mon", param);
			*/
			m.put("RSLT", 1);
			map.addAttribute(m);
		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		} 

		return jsonView2;
	}
	
	// ipphonne 관리 엑셀로 일괄 DB 등록
		@SuppressWarnings({ "unchecked", "rawtypes" })
		@RequestMapping("/ipphone_excel_insert")
		public ModelAndView ipphone_excel_insert(ModelMap map, @RequestParam Map param, HttpServletRequest req, HttpServletResponse res){
			try {
				if (req instanceof MultipartHttpServletRequest) {
					MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) req;
					
					MultipartFile excelFile = multipartRequest.getFile("f_excel");
					String[] KeyArrayIdxItem = {"N_MON_ID", "N_MON_NAME", "S_IPADDRESS", "S_EXT_NUM", "S_NAME", "S_COMMUNITY", "N_SNMP_VER", "N_PORT", "S_TYPE", "N_GROUP", "N_GROUP_NAME"}; // 키로쓸 명
					int rslt = 0;
					String isYn = "N";
					int errorLine = 0;
					Map dul_chk = new HashMap();
					Map dul_cnt = new HashMap();
					int dul_int = 0;
					
					// error 시 내용 
					String error = "";
									
					if(excelFile != null && !excelFile.isEmpty()){
						ExcelPoiUtil XlsReadUtil = new ExcelPoiUtil();
						String excel_f_name = excelFile.getOriginalFilename();
						if(excel_f_name.substring(excel_f_name.lastIndexOf(".")).equals(".xlsx"))
						{
							List lst = XlsReadUtil.getList2Map_xlsx(excelFile.getInputStream(), KeyArrayIdxItem, 1);
							
							for(int i=0;i<lst.size();i++)
							{
								Map tmp_param = (Map)lst.get(i);
								
								// 비교 set 생성
								Set set = tmp_param.keySet();
								Object []obj = set.toArray();
								
								for(int j=0;j<obj.length;j++){
									String key = (String)obj[j];
									String compara = (String)tmp_param.get(key);
									
									// null 및 공백 체크
									if(compara.equals(null) || compara.equals("")){
										errorLine = i + 2;
										error = errorLine+"행 cell을 확인 하셔야 합니다.";
										isYn = "Y";
										rslt = 9999;
										
									}
									// 중복 체크
									else {
										dul_chk.put(key, compara);
										dul_cnt = service.getMap("ipphone.exceldul_chk", tmp_param);
										
										dul_int = (Integer)dul_cnt.get("CNT");
										System.out.println("중복 체크 CNT ====="+dul_int);
									}
								}
								
								if(isYn.equals("N")){
									// 최종 인서트 실행
									rslt += service.getInsData("ipphone.insipphoneExcel", tmp_param);
								}
							}
						}
						else if(excel_f_name.substring(excel_f_name.lastIndexOf(".")).equals(".xls"))
						{
							List lst = XlsReadUtil.getList2Map_xls(excelFile.getInputStream(), KeyArrayIdxItem, 1);
							
							for(int i=0;i<lst.size();i++)
							{
								Map tmp_param = (Map)lst.get(i);
								
								// 비교 set 생성
								Set set = tmp_param.keySet();
								Object []obj = set.toArray();
								
								for(int j=0;j<obj.length;j++){
									String key = (String)obj[j];
									String compara = (String)tmp_param.get(key);
									
									// null 체크 및 공백 체크
									if(compara.equals(null) || compara.equals("")){
										errorLine = i + 2;
										error = errorLine+"행에 cell을 확인 하셔야 합니다.";
										isYn = "Y";
										rslt = 9999;
										
									}
									// 중복 체크
									else {
										dul_chk.put(key, compara);
										dul_cnt = service.getMap("ipphone.exceldul_chk", tmp_param);
										
										dul_int = (Integer)dul_cnt.get("CNT");
										System.out.println("중복 체크 CNT ====="+dul_int);
										if(dul_int <= 1){
											isYn = "Y";
											errorLine = i + 2;
											error = errorLine+"행에 중복된 cell을 확인 하셔야 합니다.";
										}
									}
								}
								
								if(isYn.equals("N")){
									// 최종 인서트 실행
									rslt += service.getInsData("ipphone.insipphoneExcel", tmp_param);
								}
								
							}
						}
						else
						{
							rslt = -1001;
						}
						
						map.addAttribute("RSLT", rslt);
						map.addAttribute("CONTENT", error);
					}
				}
			}
			catch (Exception e) {
				HashMap m = new HashMap();
				m.put("RSLT", -9999);
				map.addAttribute(m);
				logger.error("request parameter:" + LogUtils.mapToString(param));
				logger.error(e.getMessage(), e);
			}

			return new ModelAndView("/admin/prgm/mon/ipphone/retrieve");
		}

	@RequestMapping("/registerUserServerInfo")
	@Transactional
	public View registerUserServerInfo(@RequestParam(value="N_MON_ID", required=false) final String[] monIds, @RequestParam final Map params,
									   ModelMap map, HttpServletRequest req) throws SQLException {
		try {

			if (logger.isDebugEnabled()) {
				logger.debug("parameter : {}", LogUtils.mapToString(params));
			}
			params.put("N_MON_ID", monIds);
			if (monIds != null && monIds.length > 0) {
				if (params.get("ALL_CHECK") != null && "Y".equals(params.get("ALL_CHECK"))) { // 전체체크
					service.getInsData("user_mon.insUserMon_all", params);
				} else { // 일부 체크
					service.getDelData("user_mon.delUserMon", params);
					service.getInsData("user_mon.insUserMon", params);
				}
			}
			else { // 전체체크 해제
				service.getDelData("user_mon.delUserMon", params);
			}

			map.addAttribute("RSLT", 1);
		}
		catch(Exception e) {
			map.addAttribute("RSLT", -9999);
			logger.error("request parameter:" + LogUtils.mapToString(params));
			logger.error(e.getMessage(), e);
		}

		return json;
	}
	
	@RequestMapping("menu_insert")
	public View menu_insert(ModelMap map, @RequestParam Map param, HttpServletRequest req){

		HashMap m = new HashMap();

		try {
			if(param.get("updateFlag").equals("U")){
				service.getInsData("menu_info.update_data", param);
			}else if(!param.get("updateFlag").equals("U")){
				service.getInsData("menu_info.insert_data", param);
			}
			m.put("RSLT", 1);
			map.addAttribute(m);
		}
		catch (Exception e){
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping("menu_delete")
	public View menu_delete(ModelMap map, @RequestParam Map param, HttpServletRequest req){

		HashMap m = new HashMap();

		try {
			service.getDelData("menu_info.delete_data", param);
			m.put("RSLT", 1);
			map.addAttribute(m);
		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}
	
	@RequestMapping("svr_group_insert")
	public View svr_group_insert(ModelMap map, @RequestParam Map param, HttpServletRequest request){

		HashMap m = new HashMap();
		String flag = (String) param.get("updateFlag");
		
		String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
		HashMap<String, Object> historyMap = new HashMap<String, Object>();    	
		
		historyMap.put("S_USER_ID", S_USER_ID);
		historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.SERVER_GROUP_CODE_CHANGE_EVENT_TYPE);
		historyMap.put("S_DATA", (String)param.get("N_GROUP_CODE"));

		try {
			if (flag.equals("U")) {
				service.getInsData("svr_group.update_data", param);
				historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.SERVER_GROUP_CODE_MODIFY);
			} else if (!param.get("updateFlag").equals("U")) {
				service.getInsData("svr_group.insert_data", param);
				historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.SERVER_GROUP_CODE_ADD);
			}
			m.put("RSLT", 1);
			map.addAttribute(m);

			service.getInsData("change_history.insert_history", historyMap);
			
		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error(e.getMessage(), e);
		}

		logger.error("request parameter:" + LogUtils.mapToString(param));
		
		return jsonView2;
	}

	@RequestMapping("svr_group_delete")
	public View svr_group_delete(ModelMap map, @RequestParam Map param, HttpServletRequest request){

		HashMap m = new HashMap();

		try {
			service.getDelData("svr_group.delete_data", param);
			m.put("RSLT", 1);
			map.addAttribute(m);

			String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
			HashMap<String, Object> historyMap = new HashMap<String, Object>();
			
			historyMap.put("S_USER_ID", S_USER_ID);
			historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.SERVER_GROUP_CODE_CHANGE_EVENT_TYPE);
			historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.SERVER_GROUP_CODE_DELETE);
			historyMap.put("S_DATA", (String)param.get("N_GROUP_CODE"));
			service.getInsData("change_history.insert_history", historyMap);

		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}
	
	@RequestMapping("svr_type_insert")
	public View svr_type_insert(ModelMap map, @RequestParam Map param, HttpServletRequest req){

		HashMap m = new HashMap();

		try {
			if (param.get("updateFlag").equals("U")) {
				service.getInsData("svr_type.update_data", param);
			} else if (!param.get("updateFlag").equals("U")) {
				service.getInsData("svr_type.insert_data", param);
			}
			m.put("RSLT", 1);
			map.addAttribute(m);
		}
		catch (Exception e) {

			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping("svr_type_delete")
	public View svr_type_delete(ModelMap map, @RequestParam Map param, HttpServletRequest req){

		HashMap m = new HashMap();

		try {
			service.getDelData("svr_type.delete_data", param);
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
	
	@RequestMapping("svr_style_insert")
	public View svr_style_insert(ModelMap map, @RequestParam Map param, HttpServletRequest req){

		HashMap m = new HashMap();

		try {
			if (param.get("updateFlag").equals("U")) {
				service.getInsData("svr_style.update_data", param);
			} else if (!param.get("updateFlag").equals("U")) {
				service.getInsData("svr_style.insert_data", param);
			}
			m.put("RSLT", 1);
			map.addAttribute(m);
		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@RequestMapping("svr_style_delete")
	public View svr_style_delete(ModelMap map, @RequestParam Map param, HttpServletRequest req){

		HashMap m = new HashMap();

		try {
			service.getDelData("svr_style.delete_data", param);
			m.put("RSLT", 1);
			map.addAttribute(m);
		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Transactional
	@RequestMapping("excel_mon_info")
	public View excel_mon_info(ModelMap map, HttpServletRequest req, HttpServletResponse res, MultipartHttpServletRequest mReq) {
		
		HashMap m = new HashMap();
		String[] rowValues = null;
        List<String[]> rowValList = new ArrayList<String[]>();
        int errLine = 0;
        
		try {
			Iterator<String> iter = mReq.getFileNames();
			while(iter.hasNext()){
	            String excelFileName = iter.next();
	            MultipartFile mFile = mReq.getFile(excelFileName);
	            
	            if(mFile.getOriginalFilename().endsWith("xls")) {
	            	logger.debug("======== xls =========");
		            //파일을 읽기위해 엑셀파일을 가져온다 
					//FileInputStream fis=new FileInputStream(file);
					HSSFWorkbook workbook=new HSSFWorkbook(mFile.getInputStream());
					int rowindex=0;
					int columnindex=0;
					//시트 수 (첫번째에만 존재하므로 0을 준다)
					//만약 각 시트를 읽기위해서는 FOR문을 한번더 돌려준다
					HSSFSheet sheet=workbook.getSheetAt(0);
					//행의 수
					int rows=sheet.getPhysicalNumberOfRows();
					for(rowindex=1;rowindex<rows;rowindex++){
					    //행을 읽는다
					    HSSFRow row=sheet.getRow(rowindex);
					    if(row !=null){
					        //셀의 수
					        //int cells=row.getPhysicalNumberOfCells();
					        //int cells=sheet.getRow(0).getPhysicalNumberOfCells();
					        int cells=24;	//excel 컬럼 추가시 증가해 주세요
					        rowValues = new String[cells];				        
					        for(columnindex=0;columnindex<cells;columnindex++){
					            //셀값을 읽는다
					            HSSFCell cell=row.getCell(columnindex);
					            String value="";
					            //셀이 빈값일경우를 위한 널체크
					            if(cell==null){
					                //continue;
					            	value = ""; 
					            }else{
					                //타입별로 내용 읽기
					                switch (cell.getCellType()){
					                case HSSFCell.CELL_TYPE_FORMULA:
					                    value=cell.getCellFormula();
					                    break;
					                case HSSFCell.CELL_TYPE_NUMERIC:
					                    value=cell.getNumericCellValue()+"";
					                    value= value.substring(0, value.indexOf("."));
					                    break;
					                case HSSFCell.CELL_TYPE_STRING:
					                    value=cell.getStringCellValue()+"";
					                    break;
					                case HSSFCell.CELL_TYPE_BLANK:
					                    value=cell.getBooleanCellValue()+"";
					                    break;
					                case HSSFCell.CELL_TYPE_ERROR:
					                    value=cell.getErrorCellValue()+"";
					                    break;
					                }
					            }
					            rowValues[columnindex] = value;
					        }
					        rowValList.add(rowValues);
					    }
					}
	            	
	            } else if (mFile.getOriginalFilename().endsWith("xlsx")) {
	            	logger.debug("======== xlsx =========");
	            	//파일을 읽기위해 엑셀파일을 가져온다 
	            	//FileInputStream fis=new FileInputStream("D:\\test.xlsx");
	            	XSSFWorkbook workbook=new XSSFWorkbook(mFile.getInputStream());
	            	int rowindex=0;
	            	int columnindex=0;
	            	//시트 수 (첫번째에만 존재하므로 0을 준다)
	            	//만약 각 시트를 읽기위해서는 FOR문을 한번더 돌려준다
	            	XSSFSheet sheet=workbook.getSheetAt(0);
	            	//행의 수
	            	int rows=sheet.getPhysicalNumberOfRows();
	            	for(rowindex=1;rowindex<rows;rowindex++){
	            	    //행을읽는다
	            	    XSSFRow row=sheet.getRow(rowindex);
	            	    if(row !=null){
	            	        //셀의 수
	            	        //int cells=row.getPhysicalNumberOfCells();
	            	        //int cells=sheet.getRow(0).getPhysicalNumberOfCells();
	            	        int cells=24;	//excel 컬럼 추가시 증가해 주세요
	            	        rowValues = new String[cells];
	            	        for(columnindex=0;columnindex<cells;columnindex++){
	            	            //셀값을 읽는다
	            	        	
	            	        	System.out.println(columnindex +" 번째 셀값 ::::: " + row.getCell(columnindex));
	            	        	
	            	            XSSFCell cell=row.getCell(columnindex);
	            	            String value="";
	            	            //셀이 빈값일경우를 위한 널체크
	            	            if(cell==null){
	            	                //continue;
	            	                value = "";
	            	            }else{
	            	                //타입별로 내용 읽기
	            	                switch (cell.getCellType()){
	            	                case XSSFCell.CELL_TYPE_FORMULA:
	            	                    value=cell.getCellFormula();
	            	                    break;
	            	                case XSSFCell.CELL_TYPE_NUMERIC:
	            	                    value=cell.getNumericCellValue()+"";
	            	                    value= value.substring(0, value.indexOf("."));
	            	                    break;
	            	                case XSSFCell.CELL_TYPE_STRING:
	            	                    value=cell.getStringCellValue()+"";
	            	                    break;
	            	                case XSSFCell.CELL_TYPE_BLANK:
	            	                    value=cell.getBooleanCellValue()+"";
	            	                    break;
	            	                case XSSFCell.CELL_TYPE_ERROR:
	            	                    value=cell.getErrorCellValue()+"";
	            	                    break;
	            	                }
	            	            }
	            	            rowValues[columnindex] = value;
	            	        }
	            	        rowValList.add(rowValues);
	            	    }
	            	}
	            }
	        }
			
			for (int i = 0; i < rowValList.size(); i++) {
				errLine = i;
				Map pMap = new HashMap();
				String[] listVal = new String[rowValList.get(i).length];
				listVal = rowValList.get(i);
				
				pMap.put("N_STYLE_CODE", listVal[0]);	//감시타입
				pMap.put("N_MON_ID", listVal[1]);		//장비ID
				pMap.put("S_MON_NAME", listVal[2]);		//장비명
				pMap.put("S_MON_IP", listVal[3]);		//장비IP
				pMap.put("N_GROUP_CODE", listVal[4]);	//그룹명
				pMap.put("N_TYPE_CODE", listVal[5]);	//감시종류
				pMap.put("S_CM_TYPE", listVal[6]);		//감시종류(ICMP일 경우만)
				pMap.put("S_DESC", listVal[7]);			//기타정보
				pMap.put("N_RACK_ID", "");
				pMap.put("N_RACK_LOCATION", "");
				pMap.put("N_RACK_UNIT", "");
				pMap.put("N_DASHBOARD_MON_TYPE", "");
				
				service.getDelData("mon_info.delSnmpInfo", pMap);
				service.getDelData("mon_info.delIcmpInfo1", pMap);
				service.getDelData("mon_info.delIcmpInfo2", pMap);
				service.getInsData("mon_info.insert_data", pMap);
				
				// N_STYLE_CODE : Agent
				if (pMap.get("N_STYLE_CODE").equals("0")) {

					// INSERT TB_INS_COMMAND
					HashMap his_param = new HashMap();

					his_param.put("N_TO", "1");
					his_param.put("N_COMMAND", "101");
					his_param.put("N_SID", pMap.get("N_MON_ID"));
					his_param.put("S_VALUE", "");

					service.getInsData("insViewToProcess", his_param);
				}
				
				// N_STYLE_CODE : ICMP
				if (pMap.get("N_STYLE_CODE").equals("1")) {
					
					pMap.put("S_ICMP_NAME", listVal[8]);	//ICMP명칭
					pMap.put("N_CHECK_TIME", listVal[9]);	//체크주기(초)
					pMap.put("N_RES_TIME", listVal[10]);		//응답시간(ms)
					pMap.put("N_TIME_OUT", listVal[11]);	//TimeOut(ms)
					pMap.put("N_ALM_CNT", listVal[12]);		//장애인식카운트
					pMap.put("N_ALM_RAT", listVal[13]);		//장애등급

					service.getInsData("mon_info.insIcmpInfo1", pMap);
					service.getInsData("mon_info.insIcmpInfo2", pMap);

					// INSERT TB_INS_COMMAND
					HashMap his_param = new HashMap();

					his_param.put("N_TO", "3");
					his_param.put("N_COMMAND", "200");
					his_param.put("N_SID", pMap.get("N_MON_ID"));
					his_param.put("S_VALUE", pMap.get("S_MON_IP"));

					service.getInsData("insViewToProcess", his_param);
				}
				
				// N_STYLE_CODE : SNMP
				if (pMap.get("N_STYLE_CODE").equals("2")) {
					
					pMap.put("N_SNMP_MAN_CODE", listVal[14]);	//SNMP장비
					pMap.put("N_SNMP_PORT", listVal[15]);		//SNMP Port
					pMap.put("N_SNMP_VERSION", listVal[16]);	//SNMP Version
					pMap.put("S_SNMP_COMMUNITY", listVal[17]);	//SNMP Community

					// SNMP v1/v2/v3 default
					service.getInsData("mon_info.insSnmpInfo", pMap);
					if (pMap.get("N_SNMP_VERSION").equals("3")) {
						logger.debug("snmp v3 info: "+pMap.toString());
						
						pMap.put("S_SECURITY_NAME", listVal[18]);	//Security Name
						pMap.put("S_AUTH_PASS", listVal[19]);		//인증 암호화 비밀번호
						pMap.put("N_AUTH_CODE", listVal[20]);		//인증 암호화 코드
						pMap.put("S_PRIV_PASS", listVal[21]);		//사설 암호화 비밀번호
						pMap.put("N_PRIV_CODE", listVal[22]);		//사설 암호화 코드
						pMap.put("S_ENGINE_ID", listVal[23]);		//엔진 ID
						
						// SNMP v3 security information
						// delete data
						service.getDelData("mon_info.delSnmpv3SecurityInfo", pMap);
						service.getDelData("mon_info.delTrapSecurityInfo", pMap);
						
						logger.debug("------- "
								+ ",N_AUTH_CODE: "+pMap.get("N_PRIV_CODE")
								+ ",N_PRIV_CODE: "+pMap.get("N_PRIV_CODE")
								+ ",total: "+pMap.toString()
								);
						// insert data
						service.getInsData("mon_info.insSnmpv3SecurityInfo", pMap);
						service.getInsData("mon_info.insTrapSecurityInfo", pMap);
					}
					else { // none
						logger.debug("default snmp info ~~~");
					}

					// INSERT TB_INS_COMMAND
					HashMap his_param = new HashMap();

					his_param.put("N_TO", "4");
					his_param.put("N_COMMAND", "300");
					his_param.put("N_SID", pMap.get("N_MON_ID"));
					his_param.put("S_VALUE", "");

					service.getInsData("insViewToProcess", his_param);
				}
			}
			m.put("RSLT", 1);
			map.addAttribute(m);
		}
		catch (Exception e) {
			
			int viewErrLine = errLine +2;
			
			m.put("RSLT", -9999);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", "엑셀파일의 에러가 발생한 줄은 "+ viewErrLine + " 번째 입니다." + e.getMessage());
			map.addAttribute(m);

			logger.error(e.getMessage(), e);
		}

		//return new ModelAndView("/admin/prgm/mon/mon_info/retrieve");
		return jsonView2;
	}
	
	@RequestMapping("cli_server_info_insert")
	public View cli_server_info_insert(ModelMap map, HttpServletRequest req,
									   @RequestParam Map param,
									   @RequestParam(value = "updateFlag", required = true) String updateFlag) {

		try {
			if (UPDATE.equals(updateFlag)) {
				service.getInsData("cli_info.update_server_data", param);
			} else {
				service.getInsData("cli_info.insert_server_data", param);
			}

			map.addAttribute("RSLT", 1);

		} catch (Exception e) {

			map.addAttribute("RSLT", -9999);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return json;
	}
	
	@RequestMapping("cli_info_delete")
	@Transactional
	public View cli_info_delete(ModelMap map,
								@RequestParam Map<String, Object> params,
								@RequestParam(value = "MON_ID", required = true) final int monId,
								@RequestParam(value = "SCRIPT_ID", required = false) final String scriptId) {

		try {
			// scriptId 가 존재 하면 Script 정보만 삭제
			// 존재하지 않으면 Server 정보와 Script 정보 모두 삭제

			Map<String, Object> condition = new HashMap<String, Object>();
			condition.put("MON_ID", monId);
			condition.put("SCRIPT_ID", scriptId);

			service.getDelData("cli_info.delete_script_data", condition);

			if (Strings.isNullOrEmpty(scriptId)) {
				service.getInsData("cli_info.delete_server_data", condition);
			}

			map.addAttribute("RSLT", 1);

		} catch(Exception e) {

			map.addAttribute("RSLT", -9999);
			logger.error("request parameter:" + LogUtils.mapToString(params));
			logger.error(e.getMessage(), e);
		}

		return json;
	}
	
	@RequestMapping("cli_script_info_insert")
	@Transactional
	public View cli_script_info_insert(ModelMap map, HttpServletRequest req,
									   @RequestParam Map param,
									   @RequestParam(value = "updateFlag", required = true) String updateFlag) {

		try {
			
	        String pwd = (String)param.get("USER_PW");
	        
	        if (pwd != null && !("".equals(pwd))) { // check null String
	        	byte[] result = seedCBC.encrypt(encryptKey.getBytes(charset), WebUtil.makeCbcKey(encryptKey.getBytes(charset)), pwd.getBytes(charset), 0, pwd.getBytes(charset).length);
	        	
	        	String resultStr = Base64.encode(result);
	        	
	        	param.put("USER_PW", resultStr);  // override password param
	        }
			
			if (UPDATE.equals(updateFlag)) {
				service.getInsData("cli_info.update_script_data", param);
			} else {
				service.getInsData("cli_info.insert_script_data", param);
			}

			map.addAttribute("RSLT", 1);

		} catch (Exception e) {

			map.addAttribute("RSLT", -9999);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return json;
	}
	
	@RequestMapping("snmp_info_insert")
	@Transactional
	public View snmp_info_insert(ModelMap map, HttpServletRequest req,
									   @RequestParam Map param,
									   @RequestParam(value = "updateFlag", required = true) String updateFlag) {

		try {
			if (UPDATE.equals(updateFlag)) {
				service.getInsData("snmp_info.update_data", param);
			} else {
				service.getInsData("snmp_info.insert_data", param);
			}

			map.addAttribute("RSLT", 1);

		} catch (Exception e) {

			map.addAttribute("RSLT", -9999);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return json;
	}
	
	@RequestMapping("snmp_info_delete")
	@Transactional
	public View snmp_info_delete(ModelMap map,
								@RequestParam Map<String, Object> params,
								@RequestParam(value = "N_MON_ID", required = false) final int monId,
								@RequestParam(value = "OLD_N_SNMP_MAN_CODE", required = false) final int oldSnmpManCode,
								@RequestParam(value = "OLD_S_SNMP_IP", required = false) final String oldSnmpIp) {

		try {
			Map<String, Object> condition = new HashMap<String, Object>();
			condition.put("N_MON_ID", monId);
			condition.put("OLD_N_SNMP_MAN_CODE", oldSnmpManCode);
			condition.put("OLD_S_SNMP_IP", oldSnmpIp);

			service.getDelData("snmp_info.delete_date", condition);

			map.addAttribute("RSLT", 1);

		} catch(Exception e) {

			map.addAttribute("RSLT", -9999);
			logger.error("request parameter:" + LogUtils.mapToString(params));
			logger.error(e.getMessage(), e);
		}

		return json;
	}
	
	@RequestMapping("user_unlock")
	public View userUnlock(ModelMap map, @RequestParam Map param){
		HashMap m = new HashMap();
		try {
			Map userLockInfo = service.getMap("user_info.userLockInfo", param);
			
			if (userLockInfo.get("S_ID_LOCK").equals("Y")) {
				param.put("S_ID_LOCK", "N");
			} else if (userLockInfo.get("S_ID_LOCK").equals("L")) {
				param.put("S_ID_LOCK", "C");
			} else {
				param.put("S_ID_LOCK", "N");
			}
			service.getUpdData("user_info.update_userUnlock", param);
			service.getUpdData("user_info.update_userLoginUpdateTime", param);
			m.put("RSLT", 1);
			map.addAttribute(m);
		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			logger.error("request parameter:" + LogUtils.mapToString(param));
			logger.error(e.getMessage(), e);
		}

		return jsonView2;
	}
}
