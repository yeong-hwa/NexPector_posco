package com.nns.nexpector.admin.action;

import java.sql.SQLException;
import java.util.ArrayList;
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

import com.nns.nexpector.common.service.CommonServices;

/**
 * Snmp Map 관리 Controller.
 */
@Controller
@RequestMapping("/admin/vg_e1_map/")
public class AdminVGE1MapController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private CommonServices service;
    @Autowired
    private View json;
    @Autowired
	private View jsonView2;
    @Autowired
	private HttpSession sess;
    
	private void addParam(Map<String, Object> param)
	{
		param.put("SESSION_USER_ID", sess.getAttribute("S_USER_ID"));
	}
    
	/**
	 * 장비 리스트 조회
	 * @param map
	 * @param param
	 * @return
	 */
	@RequestMapping(value = {"equipmentList"}, method = RequestMethod.POST)
	public View getKendoPaginationListData(ModelMap map, @RequestBody Map<String, Object> param){
		addParam(param);
		HashMap<String, Object> m = new HashMap<String, Object>();
		try {
			if (param.get("skip") != null && !"".equals(param.get("skip"))) {
				param.put("firstRecordIndex", param.get("skip"));
				param.put("lastRecordIndex", param.get("take"));
			}
			@SuppressWarnings("unchecked")
			List<HashMap<String, Object>> result = service.getList("vg_e1_map.select_equipmentList", param);
			map.addAttribute("list", result);
		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView2;
	}
	
	/**
	 * VG 장비 E1 Port 지점 맵핑
	 * @param map
	 * @param param
	 * @return
	 */
	@RequestMapping(value = {"equipmentE1List"}, method = RequestMethod.POST)
	public View getKendoPaginationListDetailData(ModelMap map, @RequestBody Map<String, Object> param){
		addParam(param);
		HashMap<String, Object> m = new HashMap<String, Object>();
		try {
			if (param.get("skip") != null && !"".equals(param.get("skip"))) {
				param.put("firstRecordIndex", param.get("skip"));
				param.put("lastRecordIndex", param.get("take"));
			}
			@SuppressWarnings("unchecked")
			List<HashMap<String, Object>> result = service.getList("vg_e1_map.select_equipmentE1List", param);
			map.addAttribute("list", result);
		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView2;
	}
	
	/**
	 * DEPT 정보 조회
	 * @param map
	 * @param param
	 * @return
	 */
	@RequestMapping(value = {"comboOrgInfo"}, method = RequestMethod.POST)
	public View getOrgInfo(ModelMap map){
		HashMap<String, Object> m = new HashMap<String, Object>();
		
		try {
			Map<String, Object> param = new HashMap<String, Object>();
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> result = service.getList("vg_e1_map.select_comboOrgInfo", param);
			map.addAttribute("list", result);
		}
		catch (Exception e) {
			m.put("RSLT", -9999);
			map.addAttribute(m);
			e.printStackTrace();
		}

		return jsonView2;
	}
    
    /**
     * Insert
     * @param vge1MapSaveList
     * @param map
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "save", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    @Transactional
    public View saveSnmpMap(@RequestParam(value="EQUIPMENT_VGE1_LIST", required=true)  String vge1MapSaveList, ModelMap map) throws Exception {
    	HashMap<String, Object> m = new HashMap<String, Object>();
    	int tmp_rslt = 1;
    	try {
    		List<HashMap<String, Object>> deleteList = new ArrayList<HashMap<String, Object>>();
        	List<HashMap<String, Object>> saveList = new ArrayList<HashMap<String, Object>>();
        	
        	String[] data = vge1MapSaveList.split(",");
        	for(String row : data){
        		String[] rowdata = row.split(";");
        		if(rowdata[2] == null || rowdata[2] == ""){
        			HashMap<String, Object> deleteMap = new HashMap<String, Object>();
        			deleteMap.put("N_MON_ID", rowdata[0]);
        			deleteMap.put("N_INDEX" , rowdata[1]);
        			deleteList.add(deleteMap);
        		}
        		else {
        			HashMap<String, Object> saveMap = new HashMap<String, Object>();
        			saveMap.put("N_MON_ID", rowdata[0]);
        			saveMap.put("N_INDEX" , rowdata[1]);
        			saveMap.put("JUM_CODE", rowdata[2]);
        			saveList.add(saveMap);
        		}
        	}
        	
        	if(deleteList.size() > 0){
        		for(HashMap<String, Object> deletedata : deleteList){
        			service.getInsData("vg_e1_map.delete_vg_e1_mapping", deletedata);
        		}
        	}
        	if(saveList.size() > 0){
        		for(HashMap<String, Object> savedata : saveList){
        			service.getInsData("vg_e1_map.save_vg_e1_mapping", savedata);
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
     * @param vge1MapDeleteList
     * @param map
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "delete", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    @Transactional
    public View deleteVge1Map(@RequestParam(value="VGE1_MAP_DELETE_LIST", required=true)  String vge1MapDeleteList,
		                    ModelMap map) throws Exception {
    	
    	HashMap<String, Object> m = new HashMap<String, Object>();
    	HashMap<String, Object> deleteMap = new HashMap<String, Object>();
    	List<HashMap<String, Object>> deleteList = new ArrayList<HashMap<String, Object>>();
    	try {
    		String[] tmp_vge1MapDeleteListArr = vge1MapDeleteList.split(",");
    		for (String rowData : tmp_vge1MapDeleteListArr) {
    			String[] deleteData = rowData.split(";");
    			HashMap<String, Object> temp_deleteMap = new HashMap<String, Object>();
    			temp_deleteMap.put("N_MON_ID", deleteData[0]);
    			temp_deleteMap.put("N_INDEX", deleteData[1]);
        		deleteList.add(temp_deleteMap);
    		}
    		
    		//VG 장비 E1 Port 지점 MAPPING 삭제
    		if(deleteList.size() > 0){
        		for(HashMap<String, Object> deletedata : deleteList){
        			service.getInsData("vg_e1_map.delete_vg_e1_mapping", deletedata);
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
    
}