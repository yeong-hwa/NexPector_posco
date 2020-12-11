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

@Controller
@RequestMapping("/admin/vdn_info/")
public class AdminVdnInfoController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private CommonServices service;
    @Autowired
    private View json;
    
    /**
     * Insert view.
     *
     * @param params the params
     * @return the view
     */
    @RequestMapping(value = "insert", method = RequestMethod.POST)
    public View insert(@RequestBody Map<String, Object> params) throws Exception {

        logger.debug("등록");

        try {
            for (Map<String, Object> m : (List<Map<String, Object>>) params.get("models")) {
                service.getInsData("vdn_info.insert_data", m);
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
    @RequestMapping(value = "update", method = RequestMethod.PUT)
    public View update(@RequestBody Map<String, Object> params) throws Exception {

        logger.debug("수정");

        try {
            for (Map<String, Object> m : (List<Map<String, Object>>) params.get("models")) {
                service.getUpdData("vdn_info.update_data", m);
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
    @RequestMapping(value = "delete", method = RequestMethod.DELETE)
    public View delete(@RequestBody Map<String, Object> params) throws Exception {

        logger.debug("삭제");

        try {
            for (Map<String, Object> m : (List<Map<String, Object>>) params.get("models")) {
                service.getDelData("vdn_info.delete_data", m);
            }
        } catch(Exception e) {
            logger.error(e.getMessage());
            throw e;
        }

        return json;
    }
}
