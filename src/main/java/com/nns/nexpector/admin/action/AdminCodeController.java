package com.nns.nexpector.admin.action;

import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.LogUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import java.util.Map;

/**
 * 관리자 Code 관리 Controller
 */
@Controller
@RequestMapping("/admin/code/")
public class AdminCodeController {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

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
    @RequestMapping(value = "insert", method = RequestMethod.POST)
    public View insert(@RequestParam Map params) throws Exception {

        if (logger.isDebugEnabled()) {
            logger.debug("parameter : {}", LogUtils.mapToString(params));
        }

        try {
            service.getInsData("code_info.insert_data", params);
        } catch(Exception e) {
            logger.error("request parameter: {}", LogUtils.mapToString(params));
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
    public View update(@RequestParam Map params) throws Exception {

        if (logger.isDebugEnabled()) {
            logger.debug("parameter : {}", LogUtils.mapToString(params));
        }

        try {
            service.getInsData("code_info.update_data", params);
        } catch(Exception e) {
            logger.error("request parameter: {}", LogUtils.mapToString(params));
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
    public View delete(@RequestParam Map params) throws Exception {

        if (logger.isDebugEnabled()) {
            logger.debug("parameter : {}", LogUtils.mapToString(params));
        }

        try {
            service.getInsData("code_info.delete_data", params);
        } catch(Exception e) {
            logger.error("request parameter: {}", LogUtils.mapToString(params));
            logger.error(e.getMessage());
            throw e;
        }

        return json;
    }
}
