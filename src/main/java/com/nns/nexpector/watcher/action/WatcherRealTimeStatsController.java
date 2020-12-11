package com.nns.nexpector.watcher.action;

import com.nns.common.session.Constant;
import com.nns.nexpector.common.service.CommonServices;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Watcher 실시간 통계 Controller
 */
@Controller
public class WatcherRealTimeStatsController {

    private static final Logger logger = LoggerFactory.getLogger(WatcherRealTimeStatsController.class);

    @Autowired
    private CommonServices service;

    @Autowired
    private HttpSession session;

    @Autowired
    private View jsonView;

    @RequestMapping(value = "/ajax/watcher/realtime_stats/component/component_screen.htm", method = RequestMethod.GET)
    public String componentScreen(Model model, @RequestParam Map param) throws Exception {

        String jspPath = "/watcher/realtime_stats/component/component_screen";

        param.put("SESSION_USER_ID", session.getAttribute(Constant.Session.S_USER_ID));

        // Server Group List
        model.addAttribute("svrlst", service.getList("compoSvrGrpLstQry", param));
        // Server Style List
        model.addAttribute("svr_style", service.getList("compo_svr_style", param));
        // Server Type List
        model.addAttribute("svr_type", service.getList("compo_svr_type", param));

        return jspPath;
    }

    /**
     * 콜 통계 조회
     *
     * @param modelMap
     * @param param
     * @param request
     * @return jsonView
     */
    @SuppressWarnings({ "rawtypes" })
    @RequestMapping("/watcher/realtime_stats/component/component_screen/searchCallStatus")
    public View searchCallStatus(ModelMap modelMap, @RequestParam Map param, HttpServletRequest request) {

        try {
            HashMap result = (HashMap)service.getObject("searchCallStatus", param);
            modelMap.addAttribute("info", result);

        } catch(Exception e) {
            logger.error(e.getMessage(), e);
        }

        return jsonView;

    }
}
