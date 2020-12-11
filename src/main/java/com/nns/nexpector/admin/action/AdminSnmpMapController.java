package com.nns.nexpector.admin.action;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.View;

import com.nns.common.enumeration.DaemonType;
import com.nns.common.enumeration.MonType;
import com.nns.nexpector.common.service.CommonServices;

/**
 * Snmp Map 관리 Controller.
 */
@Controller
@RequestMapping("/admin/snmp_map/")
public class AdminSnmpMapController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private CommonServices service;
    @Autowired
    private View json;
    @Autowired
	private View jsonView2;
    @Autowired
	private HttpSession sess;
    
	private void addParam(Map param)
	{
		param.put("SESSION_USER_ID", sess.getAttribute("S_USER_ID"));
	}
    
	/**
	 * 감시장비 리스트 조회
	 * @param map
	 * @param param
	 * @return
	 */
	@RequestMapping(value = {"equipmentList"}, method = RequestMethod.POST)
	public View getKendoPaginationListData(ModelMap map, @RequestBody Map<String, Object> param){
			addParam(param);
			if (logger.isDebugEnabled()) {
				logger.debug("param :: " + param);
			}
		try {
			if (param.get("skip") != null && !"".equals(param.get("skip"))) {
				param.put("firstRecordIndex", param.get("skip"));
				param.put("lastRecordIndex", param.get("take"));
			}
			List result = service.getList("snmp_map.select_equipmentList", param);
			map.addAttribute("list", result);
		}
		catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView2;
	}
	
	/**
	 * SNMP 감시상세 리스트 조회
	 * @param map
	 * @param param
	 * @return
	 */
	@RequestMapping(value = {"equipmentList_detail"}, method = RequestMethod.POST)
	public View getKendoPaginationListDetailData(ModelMap map, @RequestBody Map<String, Object> param){
		addParam(param);
		if (logger.isDebugEnabled()) {
			logger.debug("select_equipmentList_detail-param :: " + param);
		}
		try {
			if (param.get("skip") != null && !"".equals(param.get("skip"))) {
				param.put("firstRecordIndex", param.get("skip"));
				param.put("lastRecordIndex", param.get("take"));
			}
			List result = service.getList("snmp_map.select_equipmentList_detail", param);
			map.addAttribute("list", result);
		}
		catch (Exception e) {
			HashMap m = new HashMap();
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView2;
	}
    
    /**
     * Insert
     * @param monId
     * @param snmpManCode
     * @param equipmentDetailList
     * @param map
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "insert", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    @Transactional
    public View saveSnmpMap(@RequestParam(value="N_MON_ID", 	   		 required=true)  int[] monId,
    						@RequestParam(value="N_SNMP_MAN_CODE", 		 required=true)  int snmpManCode,
    						@RequestParam(value="EQUIPMENT_DETAIL_LIST", required=true)  String equipmentDetailList,
		                    ModelMap map) throws Exception {
    	
    	HashMap m = new HashMap();
    	int tmp_rslt = 1;
    	
    	try {
    		for (int i = 0; i < monId.length; i++) {
    			
    			HashMap delMap = new HashMap();
    			delMap.put("N_MON_ID", monId[i]);
    			service.getDelData("snmp_map.delete_data", delMap);
    			
        		String[] tmp_arr = equipmentDetailList.split(",");
            	for (int j = 0; j < tmp_arr.length; j++) {
            		String[] tmp_equipmentDetail = tmp_arr[j].split(";");
            		Map tmp_equipmentDetailMap = new HashMap();
            		tmp_equipmentDetailMap.put("N_MON_ID", monId[i]);
            		tmp_equipmentDetailMap.put("N_SNMP_MAN_CODE", snmpManCode);
            		tmp_equipmentDetailMap.put("N_SNMP_MON_CODE", tmp_equipmentDetail[0]);
            		tmp_equipmentDetailMap.put("N_TIMEM", tmp_equipmentDetail[1]);
            		
            		service.getInsData("snmp_map.insert_data", tmp_equipmentDetailMap);
            		
            		/*
            		Map cntMap = service.getMap("snmp_map.select_snmp_data_yn", tmp_equipmentDetailMap);
            		if(Integer.parseInt(cntMap.get("CNT").toString()) > 0) {
            			service.getUpdData("snmp_map.update_data", tmp_equipmentDetailMap);
            		} else {
            			service.getInsData("snmp_map.insert_data", tmp_equipmentDetailMap);
            		}
            		*/
            	}
    		}
    		m.put("RSLT", tmp_rslt);
    		map.addAttribute(m);
    		
		}catch(SQLException se){
			m.put("RSLT", -10000);
			m.put("ERRCODE", se.getErrorCode());
			m.put("ERRMSG", se.getMessage());
			map.addAttribute(m);
		}catch(Exception e){
			m.put("RSLT", -1);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", e.getMessage());
			map.addAttribute(m);
			e.printStackTrace();
		}
    	return jsonView2;
    }
    
    /**
     * Delete
     * @param snmpMapDeleteList
     * @param map
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "delete", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    @Transactional
    public View deleteSnmpMap(@RequestParam(value="SNMP_MAP_DELETE_LIST", required=true)  String snmpMapDeleteList,
		                    ModelMap map) throws Exception {
    	
    	HashMap m = new HashMap();
    	
    	try {
    		String[] tmp_snmpMapDeleteListArr = snmpMapDeleteList.split(",");
    		for (int i = 0; i < tmp_snmpMapDeleteListArr.length; i++) {
    			String[] tmp_snmpMapDeleteArr = tmp_snmpMapDeleteListArr[i].split(";");
        		Map tmp_snmpMapDeleteMap = new HashMap();
        		tmp_snmpMapDeleteMap.put("N_MON_ID", tmp_snmpMapDeleteArr[0]);
        		tmp_snmpMapDeleteMap.put("N_SNMP_MAN_CODE", tmp_snmpMapDeleteArr[1]);
        		tmp_snmpMapDeleteMap.put("N_SNMP_MON_CODE", tmp_snmpMapDeleteArr[2]);
        		
        		service.getDelData("snmp_map.delete_data", tmp_snmpMapDeleteMap);
        		
        		//SNMP장비(Standard Equipment), SNMP감시상세(프로세스 감시 정보) 일 경우 프로세스 등록 테이블 삭제
        		if("12".equals(tmp_snmpMapDeleteMap.get("N_SNMP_MAN_CODE")) && "5".equals(tmp_snmpMapDeleteMap.get("N_SNMP_MON_CODE"))) {
        			service.getDelData("snmp_map.delete_mon_map", tmp_snmpMapDeleteMap);
        		}
    		}
    		m.put("RSLT", 1);
    		map.addAttribute(m);
    		
		}catch(SQLException se){
			m.put("RSLT", -10000);
			m.put("ERRCODE", se.getErrorCode());
			m.put("ERRMSG", se.getMessage());
			map.addAttribute(m);
		}catch(Exception e){
			m.put("RSLT", -1);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", e.getMessage());
			map.addAttribute(m);
			e.printStackTrace();
		}
    	return jsonView2;
    }
    
    /**
     * Update
     * @param monId
     * @param snmpManCode
     * @param snmpMonCode
     * @param timem
     * @param processNames
     * @param map
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "update", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    @Transactional
    public View updateSnmpMap(@RequestParam(value="N_MON_ID", 	   	 required=true)  int monId,
				              @RequestParam(value="N_SNMP_MAN_CODE", required=true)  int snmpManCode,
				              @RequestParam(value="N_SNMP_MON_CODE", required=true)  int snmpMonCode,
				              @RequestParam(value="N_TIMEM", 		 required=true)  int timem,
				              @RequestParam(value="S_MAP_KEY",  required=false) String[] mapKeys,
				              @RequestParam(value="S_PROCESS_NAME",  required=false) String[] processNames,
				              @RequestParam(value="S_ALIAS",  		 required=false) String[] processAliases,
				              ModelMap map) throws Exception {
    	
    	HashMap m = new HashMap();
    	int tmp_rslt = 1;
    	
    	Map<String, Object> params = new HashMap<String, Object>();
    	try {
    		params.put("N_MON_ID", monId);
    		params.put("N_SNMP_MAN_CODE", snmpManCode);
    		params.put("N_SNMP_MON_CODE", snmpMonCode);
    		params.put("N_TIMEM", timem);
    		
    		service.getUpdData("snmp_map.update_data", params);
    		service.getDelData("snmp_map.delete_mon_map", params);
    		service.getInsData("snmp_map.delete_mon_map_alias", params);

    		if (processNames != null && processNames.length > 0)
    		{
    			for (int i = 0; i < processNames.length; i++) 
    			{
    				String mapKey = mapKeys[i];
    				String processName = processNames[i];
    				String processAlias = processAliases[i];
    				
    				// params.put("S_MAP_KEY", createMapKey(i));
    				params.put("S_MAP_KEY", mapKey);
    				params.put("N_MON_TYPE", MonType.PROCESS.getCode());
    				params.put("S_MON_NAME", processName);
    				params.put("S_ALIAS", processAlias);
    				params.put("F_DAEMON", DaemonType.SNMP.getCode());
    				
    				service.getInsData("snmp_map.insert_mon_map", params);
    				service.getInsData("snmp_map.insert_mon_map_alias", params);
				}
    		}
    		
    		m.put("RSLT", tmp_rslt);
    		map.addAttribute(m);
    		
		}catch(SQLException se){
			m.put("RSLT", -10000);
			m.put("ERRCODE", se.getErrorCode());
			m.put("ERRMSG", se.getMessage());
			map.addAttribute(m);
		}catch(Exception e){
			m.put("RSLT", -1);
			m.put("ERRCODE", -1);
			m.put("ERRMSG", e.getMessage());
			map.addAttribute(m);
			e.printStackTrace();
		}
    	return jsonView2;
    }
    
    public String createMapKey(int index) {
    	return "00"+(30000+index);
    }
    
}