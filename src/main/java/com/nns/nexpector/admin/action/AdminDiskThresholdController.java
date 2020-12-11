package com.nns.nexpector.admin.action;

import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.LogUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import java.util.List;
import java.util.Map;

/**
 * 관리자 Menu 관리 Controller
 */
@Controller
@RequestMapping("/admin/disk_threshold/")
public class AdminDiskThresholdController {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private View json;

    @Autowired
    private CommonServices service;

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
                service.getUpdData("disk_threshold.update_data", m);
            }
        } catch(Exception e) {
            logger.error(e.getMessage());
            throw e;
        }

        return json;
    }
}
