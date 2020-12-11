package com.nns.nexpector.watcher.action;

import com.nns.common.session.Constant;
import com.nns.nexpector.common.service.CommonServices;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/watcher/*")
public class WatcherCommonController {

    private static final Logger logger = LoggerFactory.getLogger(WatcherCommonController.class);

    @Autowired
    private CommonServices service;

    @Autowired
    private HttpSession session;

	@Autowired
	private View jsonView;
    
    @RequestMapping(value = "/{path}/{jspName}", method = RequestMethod.GET)
    public ModelAndView goWatcherJspPage(ModelMap map, @PathVariable String path, @PathVariable String jspName, @RequestParam Map param) {
        param.put("SESSION_USER_ID", session.getAttribute(Constant.Session.S_USER_ID));

        String path_name = path.replaceAll("\\.", "/");
        String jspPath = path_name + "/" + jspName;
        logger.debug("jspPath:: " + jspPath + " - " + param);
        try {
            /*
			 * 페이지에 테이블 조회 결과등을 넘기고 싶은 경우
			 * url/go_{jspName} 에 파라메터로 req_data 를 추가
			 * req_data의 값에 대한 형식은
			 * 값이름-쿼리이름;값이름-쿼리이름         =    값과 쿼리이름의 구분자는 ";" 이고, 여러 값이 필요한 경우 구분은  "|" 으로 구분 한다.
			 * 추가 : 쿼리명 뒤에 콜론(:)에 리턴 타입 지정
			 *      기본 List 형태 리턴
			 *      map 인경우 Map 형태로 리턴
			*/
            if (param.get("req_data") != null && !param.get("req_data").toString().equals(""))
            {
                String req_data = param.get("req_data").toString();
                String[] arr_data = req_data.split("\\|");

                for (int i = 0; i < arr_data.length; i++)
                {
                    String[] tmp_arr = arr_data[i].split(";");
                    if (tmp_arr.length == 1)
                    {
                        map.addAttribute(service.getList(tmp_arr[0], param));
                    }
                    else if (tmp_arr.length > 1)
                    {
                        if (tmp_arr[1].indexOf(":") != -1)
                        {
                            String[] qry_arr = tmp_arr[1].split(":");
                            if (qry_arr.length > 1)
                            {
                                if (qry_arr[1].equals("map"))
                                {
                                    Map m = service.getMap(qry_arr[0], param);
                                    logger.debug(tmp_arr[0] + " - " + m);
                                    map.addAttribute(tmp_arr[0], m);
                                }
                                else
                                {
                                    List lst = service.getList(tmp_arr[1], param);
                                    logger.debug(tmp_arr[0] + " - " + lst);
                                    map.addAttribute(tmp_arr[0], lst);
                                }
                            }
                        }
                        else
                        {
                            List lst = service.getList(tmp_arr[1], param);
                            logger.debug(tmp_arr[0] + " - " + lst);
                            map.addAttribute(tmp_arr[0], lst);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new ModelAndView("/watcher/" + jspPath);
    }

    // 실시간 통계 Main
    @RequestMapping(value = "/realtime_stats/component/center_total", method = RequestMethod.GET)
    public ModelAndView goRealTimeMain(@RequestParam Map param) throws Exception {
    	int groupCode;
    	if(param.get("N_GROUP_CODE") == null || Integer.parseInt((String) param.get("N_GROUP_CODE")) == 0){
    		groupCode = -1;
    	}
    	else{
            groupCode = Integer.parseInt((String) param.get("N_GROUP_CODE"));
    	}

        int typeCode = param.get("N_TYPE_CODE") == null ||  Integer.parseInt((String) param.get("N_TYPE_CODE")) == 0
                ? -1
                : Integer.parseInt((String) param.get("N_TYPE_CODE"));

        String groupName = null;
        if ( param.get("page") != null && "detail".equals(param.get("page")) ) {
            groupName = (String) service.getObject("common.selectGroupCodeName", groupCode);
        }

        ModelAndView mav = new ModelAndView("/watcher/realtime_stats/component/center_total");
        mav.addObject("tree_data", service.getList("watcher_main.TreeSvrGroupQry", Collections.EMPTY_MAP));
        mav.addObject("N_GROUP_CODE", groupCode);
        mav.addObject("N_TYPE_CODE", typeCode);
        mav.addObject("page", param.get("page"));
        mav.addObject("S_GROUP_NAME", groupName);

        return mav;
    }
    
    // 실시간 통계 Main
    @RequestMapping(value = "/realtime_stats/component/center_detail", method = RequestMethod.GET)
    public ModelAndView goRealTimeMonDetail(@RequestParam Map param) throws Exception {
    	int groupCode;
    	if(param.get("N_GROUP_CODE") == null || Integer.parseInt((String) param.get("N_GROUP_CODE")) == 0){
    		groupCode = -1;
    	}
    	else{
            groupCode = Integer.parseInt((String) param.get("N_GROUP_CODE"));
    	}

        int typeCode = param.get("N_TYPE_CODE") == null ||  Integer.parseInt((String) param.get("N_TYPE_CODE")) == 0
                ? -1
                : Integer.parseInt((String) param.get("N_TYPE_CODE"));

        String groupName = null;
        groupName = (String) service.getObject("common.selectGroupCodeName", groupCode);

        ModelAndView mav = new ModelAndView("/watcher/realtime_stats/component/center_detail");
        mav.addObject("tree_data", service.getList("watcher_main.TreeSvrGroupQry", Collections.EMPTY_MAP));
        mav.addObject("N_GROUP_CODE", groupCode);
        mav.addObject("N_TYPE_CODE", typeCode);
        mav.addObject("page", param.get("page"));
        mav.addObject("S_GROUP_NAME", groupName);

        return mav;
    }
    
    // 실시간 통계 Main
    @RequestMapping(value = "/realtime_stats/component/center_chart", method = RequestMethod.GET)
    public ModelAndView goRealTimeCenterDetail(@RequestParam Map param) throws Exception {
    	int groupCode;
    	if(param.get("N_GROUP_CODE") == null || Integer.parseInt((String) param.get("N_GROUP_CODE")) == 0){
    		groupCode = -1;
    	}
    	else{
            groupCode = Integer.parseInt((String) param.get("N_GROUP_CODE"));
    	}

        int typeCode = param.get("N_TYPE_CODE") == null ||  Integer.parseInt((String) param.get("N_TYPE_CODE")) == 0
                ? -1
                : Integer.parseInt((String) param.get("N_TYPE_CODE"));

        String groupName = null;
        groupName = (String) service.getObject("common.selectGroupCodeName", groupCode);

        ModelAndView mav = new ModelAndView("/watcher/realtime_stats/component/center_chart");
        mav.addObject("tree_data", service.getList("watcher_main.TreeSvrGroupQry", Collections.EMPTY_MAP));
        mav.addObject("N_GROUP_CODE", groupCode);
        mav.addObject("N_TYPE_CODE", typeCode);
        mav.addObject("page", param.get("page"));
        mav.addObject("S_GROUP_NAME", groupName);

        return mav;
    }
    
    @RequestMapping(value = "/realtime_stats/component/center_call", method = RequestMethod.GET)
    public ModelAndView goRealTimeCenterCall(@RequestParam Map param) throws Exception {

    	int groupCode;
    	if(param.get("N_GROUP_CODE") == null || Integer.parseInt((String) param.get("N_GROUP_CODE")) == 0){
    		groupCode = -1;
    	}
    	else{
            groupCode = Integer.parseInt((String) param.get("N_GROUP_CODE"));
    	}

        int typeCode = param.get("N_TYPE_CODE") == null ||  Integer.parseInt((String) param.get("N_TYPE_CODE")) == 0
                ? -1
                : Integer.parseInt((String) param.get("N_TYPE_CODE"));

        String groupName = null;
        groupName = (String) service.getObject("common.selectGroupCodeName", groupCode);

        ModelAndView mav = new ModelAndView("/watcher/realtime_stats/component/center_call");
        mav.addObject("tree_data", service.getList("watcher_main.TreeSvrGroupQry", Collections.EMPTY_MAP));
        mav.addObject("N_GROUP_CODE", groupCode);
        mav.addObject("N_TYPE_CODE", typeCode);
        mav.addObject("page", param.get("page"));
        mav.addObject("S_GROUP_NAME", groupName);

        return mav;
    }

    @RequestMapping(value = "/realtime_stats/component/jijum_phone", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView goRealTimeJijumPhone(@RequestParam Map param) throws Exception {
    	

   	int groupCode;
    	if(param.get("N_GROUP_CODE") == null || param.get("N_GROUP_CODE") == "" || Integer.parseInt((String) param.get("N_GROUP_CODE")) == 0){
    		groupCode = -1;
    	}
    	else{
            groupCode = Integer.parseInt((String) param.get("N_GROUP_CODE"));
    	}

        int typeCode = param.get("N_TYPE_CODE") == null ||  Integer.parseInt((String) param.get("N_TYPE_CODE")) == 0
                ? -1
                : Integer.parseInt((String) param.get("N_TYPE_CODE"));

        String groupName = null;
        groupName = (String) service.getObject("common.selectGroupCodeName", groupCode);

        ModelAndView mav = new ModelAndView("/watcher/realtime_stats/component/jijum_phone");
        mav.addObject("tree_data", service.getList("watcher_main.TreeSvrGroupQry", Collections.EMPTY_MAP));
        mav.addObject("N_GROUP_CODE", groupCode);
        mav.addObject("N_TYPE_CODE", typeCode);
        mav.addObject("page", param.get("page"));
        mav.addObject("S_GROUP_NAME", groupName);

        return mav;
    }

	@RequestMapping("/service_stats")
	public View getServiceStats(ModelMap modelMap, @RequestParam Map<String, Object> param) throws Exception {
		
		modelMap.put("pbxServiceCurrentUse", service.getMap("realtime_status.centerPbxServiceCurrentUseInfo", null));
		modelMap.put("pbxServiceCurrentMaxUse", service.getMap("realtime_status.centerPbxServiceCurrentMaxUseInfo", null));
		
		modelMap.put("pbxServiceAvgUse", service.getMap("realtime_status.centerPbxServiceAvgUseInfo", null));
		modelMap.put("pbxServiceAvgMaxUse", service.getMap("realtime_status.centerPbxServiceAvgMaxUseInfo", null));
		modelMap.put("pbxServiceCurrentMaxUse", service.getMap("realtime_status.centerPbxServiceCurrentMaxUseInfo", null));
		
		modelMap.put("dashServiceCurrentUse", service.getMap("realtime_status.centerCurrentServiceUseInfo", null));
		modelMap.put("dashServiceAvgUse", service.getMap("realtime_status.centerAvgServiceUseInfo", null));
		
		modelMap.put("callCurrentUse", service.getMap("realtime_status.centerCallCurrentUseInfo", null));
		modelMap.put("callAvgUse", service.getMap("realtime_status.centerCallAvgUseInfo", null));
		
		modelMap.put("recCurrentUse", service.getMap("realtime_status.centerRecCurrentUseInfo", null));
		modelMap.put("recAvgUse", service.getMap("realtime_status.centerRecAvgUseInfo", null));
		
		modelMap.put("cmsCurrentUse", service.getMap("realtime_status.centerCmsCurrentUseInfo", null));
		modelMap.put("cmsAvgUse", service.getMap("realtime_status.centerCmsAvgUseInfo", null));
		
		return jsonView;
	}
}
