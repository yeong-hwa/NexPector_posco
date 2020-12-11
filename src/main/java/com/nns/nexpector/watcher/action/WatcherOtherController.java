package com.nns.nexpector.watcher.action;

import com.nns.common.enumeration.MonType;
import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.ExcelPoiUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;


@Controller
@RequestMapping("/watcher/*")
public class WatcherOtherController {
	private static final Logger logger = LoggerFactory.getLogger(WatcherOtherController.class);
	@Autowired
	private CommonServices service;
	@Autowired
	private View jsonView;
	@Autowired
	private View jsonView2;
	@Autowired
	private View json;
	@Autowired
	private HttpSession sess;

	private static Map map_resource = new HashMap();

	private void addParam(Map param)
	{
		param.put("SESSION_USER_ID", sess.getAttribute("S_USER_ID"));
	}

	@RequestMapping("/server_detail/p_s_info")
	public View getSvrProcessServiceInfo(ModelMap map, @RequestParam Map param){
		try{
			map.addAttribute("p_s_info", service.getMap("SvrProcessServiceInfoQry", param));

			List lst = service.getList("ResourceInfoQry", param);

			for(int i=0;i<lst.size();i++)
			{
				Integer monType = (Integer) ((Map)lst.get(i)).get("N_MON_TYPE");
				if(monType.equals(MonType.CPU.getCode())) {
					map.addAttribute("cpu_info", lst.get(i));
				} else if(monType.equals(MonType.MEMORY.getCode())) {
					map.addAttribute("mem_info", lst.get(i));
				} else if(monType.equals(MonType.DISK.getCode())) {
					map.addAttribute("disk_info", lst.get(i));
				}
			}
		}catch(Exception e){
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return json;
	}

	@RequestMapping("/server_detail/realtime_resource_chart_{path_name}")
	public View getRealtimeResource(ModelMap map, @RequestParam Map param, @PathVariable String path_name){
		try{
			String key = "";

			key = (String)param.get("N_MON_ID");
			key += ";" + param.get("S_MAP_KEY");

			List res_lst = (List)map_resource.get(key);

			if(res_lst == null) res_lst = new ArrayList();

			Map result = service.getMap(path_name, param);
			Map m = result == null ? Collections.emptyMap() : result;

			if(res_lst.size() < 10)
			{
				res_lst.add(m.get("N_PER_USE")); // N_NOW_USE
			}
			else
			{
				res_lst.remove(0);
				res_lst.add(m.get("N_PER_USE")); // N_NOW_USE
			}

			map_resource.put(key, res_lst);

			String str = "[";
			List list = res_lst;

			if (list.size() != 10 || list.size() < 10){
				int sizeGap = 10 - list.size();
				for (int i = 0; i < sizeGap; i++){
					str += "0,";
				}
			}

			for (int i = 0; i < list.size(); i++){
				if (i == list.size()-1){
					str += list.get(i);
				} else {
					str += list.get(i)+",";
				}
			}

			map.addAttribute(str+"]");
		}catch(Exception e){
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView2;
	}

	@RequestMapping("/server_detail/icmp_chart_IcmpLstQry2")
	public View getIcmpChartDate(ModelMap map, @RequestParam Map param){
		try{
			String key = "";

			key = (String)param.get("N_MON_ID");
			key += ";" + param.get("S_ICMP_IP");

			List res_lst = (List)map_resource.get(key);

			if(res_lst == null) res_lst = new ArrayList();

			Map result = service.getMap("server_detail.IcmpLstQry2", param);
			Map m = result == null ? Collections.emptyMap() : result;

			if(res_lst.size() < 10)
			{
				res_lst.add(m.get("N_RES_TIME")); // N_NOW_USE
			}
			else
			{
				res_lst.remove(0);
				res_lst.add(m.get("N_RES_TIME")); // N_NOW_USE
			}

			map_resource.put(key, res_lst);

			String str = "[";
			List list = res_lst;

			if (list.size() != 10 || list.size() < 10){
				int sizeGap = 10 - list.size();
				for (int i = 0; i < sizeGap; i++){
					str += "0,";
				}
			}

			for (int i = 0; i < list.size(); i++){
				if (i == list.size()-1){
					str += list.get(i);
				} else {
					str += list.get(i)+",";
				}
			}

			map.addAttribute(str+"]");
		}catch(Exception e){
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView2;
	}
	
	@RequestMapping("/server_detail/accrue_chart_{path_name}")
	public View getAccrueChartData(ModelMap map, @RequestParam Map param, @PathVariable String path_name){
		try{
			Map<String, Object> m = service.getMap(path_name, param);
			String str = "[[";
			if (m != null){
				for(int i=0;i<24;i++)
				{
					String key = "TIME_" + (i<10?("0"+i):i);
					str += m.get(key).toString()+(i==23?"":",");
				}

			} else {
				str += "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
			}

			map.addAttribute((Object)(str+"]]"));
		}catch(Exception e){
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView2;
	}

	@RequestMapping("/main/alarm_status_modify")
	public View getAlarmModify(ModelMap map, @RequestParam Map param, HttpServletRequest req){
		String	ipAddress = (String) param.get("ERROR_S_IP_ADDRESS");
		if (ipAddress != null && ipAddress.length() > 0) {
			return phoneAlarmModify(map, param);
		}

		try{
			int rslt = 0;

			String almKey = (String) param.get("ERROR_S_ALM_KEY");
			String realTimeErrorGroup = (String) param.get("REAL_TIME_ERROR_GROUP");
			
			//monId가 다른 장애복구를 위해 추가
			if(realTimeErrorGroup != null && !realTimeErrorGroup.isEmpty()){
				String[] tmp_arr = realTimeErrorGroup.split(",");
				for (int i = 0; i < tmp_arr.length; i++) {
					String[] tmp_errorGroupArr = tmp_arr[i].split(";");
					param.put("ERROR_N_MON_ID", tmp_errorGroupArr[0]);
					param.put("ERROR_S_ALM_KEY", tmp_errorGroupArr[1]);
					
					rslt += service.getUpdData("almStatusUpdateQry", param);
					rslt += service.getInsData("almHistoryInsertQry", param);
				}
				map.addAttribute("error_detail", "N");
				
			//monId는 같고 다른 S_ALM_KEY를 가진 다중복구를 위해
			} else {	
				if (almKey.indexOf(",") > -1) {
					String[] almKeys = almKey.split(",");
					for (String key : almKeys) {
						param.put("ERROR_S_ALM_KEY", key);
						rslt += service.getUpdData("almStatusUpdateQry", param);
						rslt += service.getInsData("almHistoryInsertQry", param);
					}
				}
				else {
					rslt += service.getUpdData("almStatusUpdateQry", param);
					rslt += service.getInsData("almHistoryInsertQry", param);
				}
				map.addAttribute("error_detail", "Y");
			}

			if(rslt > 0)
			{
				map.addAttribute("reg_ok", "ok");
			}
		}catch(Exception e){
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView;
	}
	public View phoneAlarmModify(ModelMap map, Map param) {
		try {
			int rslt = 0;

			String ipAddress = (String) param.get("ERROR_S_IP_ADDRESS");
			
			if (ipAddress.indexOf(",") > -1) {
				String[] ipAddrs = ipAddress.split(",");
				for (String key : ipAddrs) {
					param.put("ERROR_S_IP_ADDRESS", key);
					rslt += service.getUpdData("almPhoneStatusUpdateQry", param);
					rslt += service.getInsData("almPhoneHistoryInsertQry", param);
				}
			}
			else {
				rslt += service.getUpdData("almPhoneStatusUpdateQry", param);
				rslt += service.getInsData("almPhoneHistoryInsertQry", param);
			}
			map.addAttribute("error_detail", "Y");

			if(rslt > 0)
			{
				map.addAttribute("reg_ok", "ok");
			}
		}catch(Exception e){
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView;
	}

	@RequestMapping("/main/setting_modify")
	public View mainSettingModify(ModelMap map, @RequestParam Map param, HttpServletRequest req){
		try{
			StringTokenizer tok = new StringTokenizer((String)param.get("S_COMPO_ID_LST"),";");

			List lst = new ArrayList();
			int cnt = 0;
			while(tok.hasMoreTokens())
			{
				HashMap m = new HashMap();

				m.put("S_COMPO_ID", tok.nextToken());
				m.put("N_SORT_NUM", cnt++);

				lst.add(m);
			}

			param.put("lst", lst);

			int rslt = 0;
			rslt += service.getDelData("regCompoQry1", param);
			rslt += service.getInsData("regCompoQry2", param);

			if(rslt > 0)
			{
				map.addAttribute("reg_ok", "ok");
			}
			HttpSession session = req.getSession();
			session.setAttribute("userCompoLst", service.getList("userCompoLstQry", param));
		}catch(Exception e){
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView;
	}

	@RequestMapping("/main/alarm_popup_history")
	public View alarmPopupStatusCheck(ModelMap map, @RequestParam Map param, HttpServletRequest request) {
		HttpSession session = request.getSession();
		addParam(param);
		try {
			List errorList = service.getList("checkErrorAlmStatusQry", param);
			if (errorList.size() != 0) {
				map.addAttribute("errorData", errorList);
				map.addAttribute("isError", "Y");
			}
			
			List eventList = service.getList("checkEventAlmStatusQry", param);
			if (eventList.size() != 0) {
				map.addAttribute("eventData", eventList);
				map.addAttribute("isEvent", "Y");
			}
			
			if (errorList.size() == 0 && eventList.size() == 0) {
				List checklist = service.getList("checkSystemTimeQry", param);
				if (checklist.size() != 0) {
					map.addAttribute("checkData", checklist);
					map.addAttribute("isCheck", "Y");
				}
			}
		} catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView2;
	}

	@RequestMapping("/realtime_stats/reg_map_pos")
	public View regMapPos(ModelMap map, @RequestParam Map param, HttpServletRequest req){
		try{
			String str = (String)param.get("DATA");

			str.split(";");

			StringTokenizer tkn = new StringTokenizer(str, ";");

			ArrayList lst = new ArrayList();

			while(tkn.hasMoreTokens())
			{
				String[] tmp = tkn.nextToken().split(",");

				if(tmp.length == 4)
				{
					lst.add("\'" + tmp[0] + "\' A,\'" + tmp[1] + "\' B,\'" + tmp[2] + "\' C,\'" + tmp[3] + "\' D");
				}
			}

			param.put("lst",lst);
			int rslt = 0;

			rslt += service.getDelData("regMapPosQry1", param);
			rslt += service.getDelData("regMapPosQry2", param);

			map.addAttribute(rslt);
		}catch(Exception e){
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView;
	}

	@RequestMapping("/server_detail/vaif_reg_excel")
	public ModelAndView vaifRegExcel(ModelMap map, @RequestParam Map param, HttpServletRequest req, HttpServletResponse res){
		try{
			res.setContentType("text/plain");
			if (req instanceof MultipartHttpServletRequest) {
				MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) req;
				MultipartFile excelFile = multipartRequest.getFile("f_excel");
				String[] KeyArrayIdxItem = {"N_MON_ID", "S_DESC", "S_TEL_NUM", "S_NAME"}; // 키로쓸 명
				int rslt = 0;
				if(excelFile != null && !excelFile.isEmpty()){
					ExcelPoiUtil XlsReadUtil = new ExcelPoiUtil();
					String excel_f_name = excelFile.getOriginalFilename();
					if(excel_f_name.substring(excel_f_name.lastIndexOf(".")).equals(".xlsx"))
					{
						List lst = XlsReadUtil.getList2Map_xlsx(excelFile.getInputStream(), KeyArrayIdxItem, 1);
						for(int i=0;i<lst.size();i++)
						{
							Map tmp_param = (Map)lst.get(i);
							rslt += service.getUpdData("updVaifExcel", tmp_param);
						}
					}
					else if(excel_f_name.substring(excel_f_name.lastIndexOf(".")).equals(".xls"))
					{
						List lst = XlsReadUtil.getList2Map_xls(excelFile.getInputStream(), KeyArrayIdxItem, 1);
						for(int i=0;i<lst.size();i++)
						{
							Map tmp_param = (Map)lst.get(i);
							rslt += service.getUpdData("updVaifExcel", tmp_param);
						}
					}
					else
					{
						rslt = -1001;
					}

					map.addAttribute("RSLT", rslt);
				}
			}
		}catch(Exception e){
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return new ModelAndView("/server_detail/snmp_m03/vaif_reg_excel");
	}

	@RequestMapping("/server_detail/ivr_channel_chart")
	public View getIvrChannelData(ModelMap map, @RequestParam Map param){
		try{
			Map<String, Object> m = service.getMap("IvrChannelDailyQry", param);
			String str = "[[";
			if (m != null){
				for(int i=0;i<24;i++)
				{
					String key = "TIME_" + (i<10?("0"+i):i);
					str += m.get(key).toString()+(i==23?"":",");
				}

			} else {
				str += "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";
			}

			map.addAttribute((Object)(str+"]]"));
		}catch(Exception e){
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView2;
	}
}
