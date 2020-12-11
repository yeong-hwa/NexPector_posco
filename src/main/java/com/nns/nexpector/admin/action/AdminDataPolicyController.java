package com.nns.nexpector.admin.action;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.View;

import com.nns.nexpector.common.service.CommonServices;

/**
 * 관리자 - 데이터 보관 정책 Controller
 */
@Controller
@RequestMapping("/admin/data/policy/")
public class AdminDataPolicyController {

	private Logger logger = LoggerFactory.getLogger(this.getClass());
	private final String mapperName = "data_policy";
    
    @Autowired
    private View json;

    @Autowired
    private CommonServices service;

    /**
     * Insert view.
     *
     * @param params the params
     * @return the view
     */
    @SuppressWarnings("unchecked")
	@RequestMapping(value = "insert", method = RequestMethod.POST)
    public View insert(@RequestBody Map<String, Object> params) throws Exception {
    	logger.debug("-> data policy 등록");
    	
        try {
            for (Map<String, Object> m : (List<Map<String, Object>>) params.get("models")) {
            	
            	// Map key and value print
                for (String mapkey : m.keySet()){
                	logger.debug("-> data policy 등록: " + "key:"+mapkey+",value:"+m.get(mapkey));
                 }
                service.getInsData(mapperName + ".insert_data", m);
            	
            }
        } catch(Exception e) {
            logger.error(e.getMessage());
            throw e;
        }

        return json;
    }

    /**
     * Update view.
     *
     * @return the view
     */
    @SuppressWarnings("unchecked")
	@RequestMapping(value = "update", method = RequestMethod.PUT)
    public View update(@RequestBody Map<String, Object> params) throws Exception {

    	logger.debug("-> data policy 수정");

        try {
            for (Map<String, Object> m : (List<Map<String, Object>>) params.get("models")) {
            	
            	// Map key and value print
                for (String mapkey : m.keySet()){
                	logger.debug("-> data policy 수정: " + "key:"+mapkey+",value:"+m.get(mapkey));
                 }
                
                service.getUpdData(mapperName + ".update_data", m);
            }
        } catch(Exception e) {
            logger.error(e.getMessage());
            throw e;
        }

        return json;
    }

    /**
     * Delete view.
     *
     * @return the view
     */
    @SuppressWarnings("unchecked")
	@RequestMapping(value = "delete", method = RequestMethod.DELETE)
    public View delete(@RequestBody Map<String, Object> params) throws Exception {

    	logger.debug("-> data policy 삭제");
    	
        try {
            for (Map<String, Object> m : (List<Map<String, Object>>) params.get("models")) {
            	
                // Map key and value print
                for (String mapkey : m.keySet()){
                	logger.debug("-> data policy 삭제: " + "key:"+mapkey+",value:"+m.get(mapkey));
                 }
                
                service.getDelData(mapperName + ".delete_data", m);
            }
        } catch(Exception e) {
            logger.error(e.getMessage());
            throw e;
        }

        return json;
    }
}
