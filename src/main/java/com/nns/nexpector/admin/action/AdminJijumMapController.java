package com.nns.nexpector.admin.action;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

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

import com.nns.nexpector.common.service.CommonServices;

/**
 * jijum Map 관리 Controller.
 */
@Controller
@RequestMapping("/admin/jijum_map/")
public class AdminJijumMapController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private CommonServices service;
    @Autowired
    private View json;
    @Autowired
	private View jsonView2;
    @Autowired
	private HttpSession sess;
    
    /**
     * Delete
     * @param jijumMapDeleteList
     * @param map
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "delete", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    @Transactional
    public View deletejijumMap(@RequestParam(value="JIJUM_DELETE_LIST", required=true)  String jijumMapDeleteList,
		                    ModelMap map) throws Exception {
    	
    	HashMap m = new HashMap();
    	
    	try {
    		String[] tmp_jijumMapDeleteListArr = jijumMapDeleteList.split(",");
    		for (int i = 0; i < tmp_jijumMapDeleteListArr.length; i++) {
    			String[] tmp_jijumMapDeleteArr = tmp_jijumMapDeleteListArr[i].split(";");
        		Map params = new HashMap();
        		params.put("S_IP_ADDRESS", tmp_jijumMapDeleteArr[0]);
        		
        		service.getDelData("jijum.delete_data", params);
        		
        		//alm data delete
        		service.getDelData("jijum.del_alm_histroy_phone", params);        		
        		service.getDelData("jijum.del_alm_phone", params);

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