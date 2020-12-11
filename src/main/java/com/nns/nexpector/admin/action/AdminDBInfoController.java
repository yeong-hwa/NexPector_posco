/*****************************************************************************
 * Copyright(c) 2016 NEONEXSOFT. All rights reserved.
 * This software is the proprietary information of NEONEXSOFT. 
 *****************************************************************************/
package com.nns.nexpector.admin.action;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import com.neonexsoft.common.crypt.seed.SeedCBC;
import com.nns.common.util.WebUtil;
import com.nns.nexpector.common.service.CommonServices;
import com.sun.org.apache.xml.internal.security.utils.Base64;

/**
 * Trunk 관리 컨트롤러
 * @version 1.0
 * @author chosg78
 * @since 2016. 5. 26.
 * @see
 *
 * <pre>
 * << Modification Information >>
 *    Date	         Name          	       Desc
 * ----------      --------    ---------------------------
 *  2016. 5. 26.   chosg78
 *
 * </pre>
 */

@Controller
@RequestMapping("/admin/db_info/")
public class AdminDBInfoController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private CommonServices service;
    @Autowired
    private View json;
    @Autowired
    private SeedCBC seedCBC;
    
    @Value("#{serviceProps['enc.key']}")
    private String encryptKey;
    
    private String charset = "UTF-8";
    
    /**
     * Insert view.
     *
     * @param params the params
     * @return the view
     */
    @RequestMapping(value = "insert", method = RequestMethod.POST)
    public View insert(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
        logger.debug("등록");

        try {
	        String pwd = (String)params.get("S_PWD");
	        
	        if (pwd != null && !("".equals(pwd))) { // check null String
	        	byte[] result = seedCBC.encrypt(encryptKey.getBytes(charset), WebUtil.makeCbcKey(encryptKey.getBytes(charset)), pwd.getBytes(charset), 0, pwd.getBytes(charset).length);
	        	
	        	String resultStr = Base64.encode(result);
	        	
	        	params.put("S_PWD", resultStr);  // override password param
	        }
        
        	service.getInsData("db_info.insert_data", params);
        	map.addAttribute("RSLT", 1);
        } catch(Exception e) {
            logger.error(e.getMessage());
			map.addAttribute("RSLT", -9999);
        }

		return json;
    }

    /**
     * Update view.
     *
     * @return the view
     */
    @RequestMapping(value = "update", method = RequestMethod.POST)
    public View update(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
    	logger.debug("수정");
    	
        try {
	        String pwd = (String)params.get("S_PWD");
	        
	        if (pwd != null && !("".equals(pwd))) { // check null String
	        	byte[] result = seedCBC.encrypt(encryptKey.getBytes(charset), WebUtil.makeCbcKey(encryptKey.getBytes(charset)), pwd.getBytes(charset), 0, pwd.getBytes(charset).length);
	        	
	        	String resultStr = Base64.encode(result);
	        	
	        	params.put("S_PWD", resultStr);  // override password param
	        }
	        
        	service.getUpdData("db_info.update_data", params);
        	map.addAttribute("RSLT", 1);
        } catch(Exception e) {
        	logger.error(e.getMessage());
			map.addAttribute("RSLT", -9999);
        }
        
        return json;
    }

    /**
     * Delete view.
     *
     * @return the view
     */
    @RequestMapping(value = "delete", method = RequestMethod.POST)
    public View delete(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
        logger.debug("삭제");

        try {
        	service.getDelData("db_info.delete_data", params);
        	map.addAttribute("RSLT", 1);
        } catch(Exception e) {
            logger.error(e.getMessage());
            map.addAttribute("RSLT", -9999);
        }
		
        return json;
    }
}
