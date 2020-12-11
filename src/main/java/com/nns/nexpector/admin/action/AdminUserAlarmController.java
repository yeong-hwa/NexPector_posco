package com.nns.nexpector.admin.action;

import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.LogUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
public class AdminUserAlarmController {

    private static final Logger logger = LoggerFactory.getLogger(AdminUserAlarmController.class);

    @Autowired
    private CommonServices service;
    @Autowired
    private View json;
    @Autowired
    private HttpSession sess;

    @RequestMapping("/admin/searchAlarmCode")
    public View getAlarmTypeList(ModelMap map, @RequestParam("N_ALM_TYPE[]") String[] alarmTypes){
        Map<String, Object> params = new HashMap<String, Object>();
        try {
            params.put("alarmTypes", alarmTypes);
            map.addAttribute("list", service.getList("common.almcode", params));
        }
        catch(Exception e) {
            HashMap m = new HashMap();
            m.put("RSLT", -9999);
            map.addAttribute(m);
            logger.error("request parameter:" + LogUtils.mapToString(params));
            logger.error(e.getMessage(), e);
        }

        return json;
    }
}
