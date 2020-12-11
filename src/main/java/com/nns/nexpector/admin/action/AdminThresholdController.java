package com.nns.nexpector.admin.action;

import java.net.URLDecoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestBindingException;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import com.nns.common.TransactionTemplate;
import com.nns.common.constants.ChangeHistoryConstants;
import com.nns.nexpector.common.service.CommonServices;
import com.nns.util.LogUtils;

@Controller
public class AdminThresholdController {

    private static final Logger logger = LoggerFactory.getLogger(AdminThresholdController.class);

    @Autowired
    private CommonServices service;
    @Autowired
    private TransactionTemplate template;
    @Autowired
    private View json;

    public static final int SERVER_TYPE_CM = 1000;
    public static final int SERVER_TYPE_CTI_EMANAGER  = 2222; // CTI 랑 다른거임..
    public static final int SERVER_TYPE_IVR  = 3000;
    public static final int SERVER_TYPE_TEMPERATURE_HUMIDITY  = 9002;
    public static final int SERVER_TYPE_SENSOR  = 9003;
    public static final int SERVER_TYPE_DB  = 9000;

    public static final int ALARM_TYPE_COMMON = 10001;
    public static final int[] ALARM_CODE_COMMON = {0, 1, 2, 3, 4};

    public static final int ALARM_TYPE_CM = 16001;
    public static final int ALARM_CODE_TRAFFIC_TRUNK = 5;
    public static final int ALARM_CODE_TRAFFIC_TRUNK_GROUP = 6;
    public static final int[] ALARM_CODE_CM = {1, 2, 3, 4, 5, 6};

    public static final int ALARM_TYPE_TEMPERATURE_HUMIDITY = 22001;
    public static final int[] ALARM_CODE_TEMPERATURE_HUMIDITY = {16, 17};

    public static final int ALARM_TYPE_SENSOR_INDEX1 = 22011;
    public static final int[] ALARM_CODE_SENSOR_INDEX1 = {1, 2};

    public static final int ALARM_TYPE_SENSOR_INDEX2 = 22012;
    public static final int[] ALARM_CODE_SENSOR_INDEX2 = {1, 2};

    public static final int ALARM_TYPE_SENSOR_INDEX3 = 22013;
    public static final int[] ALARM_CODE_SENSOR_INDEX3 = {1, 2};

    public static final int ALARM_TYPE_DB = 24001;
    public static final int[] ALARM_CODE_DB = {3};

    public static final int ALARM_TYPE_CTI_EMANAGER = 25001;
    public static final int ALARM_CODE_ABANDONED_THRESHOLD = 2;
    public static final int[] ALARM_CODE_CTI_EMANAGER = {2};

    public static final int ALARM_TYPE_IVR = 26001;
    public static final int ALARM_CODE_IVR_APP_THRESHOLD = 0;
    public static final int[] ALARM_CODE_IVR = {0};

    // 임계치 목록 조회
    @RequestMapping("/admin/searchThresholdType")
    public View getAlarmTypeList(ModelMap map, @RequestParam("N_TYPE_CODE") int typeCode){
        Map<String, Object> params = new HashMap<String, Object>();
        try {
            params.put("N_ALM_TYPE", ALARM_TYPE_COMMON);
            params.put("almCodes", ALARM_CODE_COMMON);
            List<Map<String, Object>> result = service.getList("critical_value.thresholdAlmCodes", params);

            switch (typeCode) {
                case SERVER_TYPE_CM :
                    params.put("N_ALM_TYPE", ALARM_TYPE_CM);
                    params.put("almCodes", ALARM_CODE_CM);
                    result.addAll(service.getList("critical_value.thresholdAlmCodes", params));
                    break;
                case SERVER_TYPE_TEMPERATURE_HUMIDITY :
                    params.put("N_ALM_TYPE", ALARM_TYPE_TEMPERATURE_HUMIDITY);
                    params.put("almCodes", ALARM_CODE_TEMPERATURE_HUMIDITY);
                    result.addAll(service.getList("critical_value.thresholdAlmCodes", params));
                    break;
                case SERVER_TYPE_SENSOR :
                    params.put("N_ALM_TYPE", ALARM_TYPE_SENSOR_INDEX1);
                    params.put("almCodes", ALARM_CODE_SENSOR_INDEX1);
                    result.addAll(service.getList("critical_value.thresholdAlmCodes", params));
                    params.put("N_ALM_TYPE", ALARM_TYPE_SENSOR_INDEX2);
                    params.put("almCodes", ALARM_CODE_SENSOR_INDEX2);
                    result.addAll(service.getList("critical_value.thresholdAlmCodes", params));
                    params.put("N_ALM_TYPE", ALARM_TYPE_SENSOR_INDEX3);
                    params.put("almCodes", ALARM_CODE_SENSOR_INDEX3);
                    result.addAll(service.getList("critical_value.thresholdAlmCodes", params));
                    break;
                case SERVER_TYPE_DB :
                    params.put("N_ALM_TYPE", ALARM_TYPE_DB);
                    params.put("almCodes", ALARM_CODE_DB);
                    result.addAll(service.getList("critical_value.thresholdAlmCodes", params));
                    break;
                case SERVER_TYPE_CTI_EMANAGER :
                    params.put("N_ALM_TYPE", ALARM_TYPE_CTI_EMANAGER);
                    params.put("almCodes", ALARM_CODE_CTI_EMANAGER);
                    result.addAll(service.getList("critical_value.thresholdAlmCodes", params));
                    break;
                case SERVER_TYPE_IVR :
                    params.put("N_ALM_TYPE", ALARM_TYPE_IVR);
                    params.put("almCodes", ALARM_CODE_IVR);
                    result.addAll(service.getList("critical_value.thresholdAlmCodes", params));
                    break;
                default :
                    break;
            }

            map.addAttribute("list", result);
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

    // 임계치 등록
    @Transactional
    @RequestMapping("/admin/saveThreshold")
    public View saveThreshold(ModelMap map,
                              final HttpServletRequest request,
                              @RequestParam("N_MON_ID") final int[] monIds,
                              @RequestParam final Map params) throws SQLException {

        if (logger.isDebugEnabled()) {
            logger.debug("parameter : {}", LogUtils.mapToString(params));
        }

        try {
            params.put("svr_lst", monIds);

            String sqlId = "critical_value.insert_threshold_data";

            if ( isTrafficTrunk(request) ) {
                sqlId = "critical_value.insert_traffic_trunk_threshold_data";
            } else if ( isAbandonedThreshold(request) ) {
                sqlId = "critical_value.insert_abandoned_threshold_data";
            } else if ( isIvrAppThreshold(request) ) {
                sqlId = "critical_value.insert_ivr_app_threshold_data";
            }

            service.getInsData(sqlId, params);

            // Agent 관련 임계치만 등록 하면 되지만 현재는 임시로 전체 임계치에 모두 등록
            params.put("N_FROM", 6);
            params.put("N_TO", 1);
            params.put("N_COMMAND", 100);

            service.getInsData("critical_value.thresholdInsViewToProcess", params);

            map.addAttribute("RSLT", 1);

            String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
            HashMap<String, Object> historyMap = new HashMap<String, Object>();
            
            String modIdsStr = Arrays.toString(monIds);
            modIdsStr = modIdsStr.replace("[", "");
            modIdsStr = modIdsStr.replace("]", "");
            
            historyMap.put("S_USER_ID", S_USER_ID);
            historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.THRESHOLD_INFO_CHANGE_EVENT_TYPE);
            historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.THRESHOLD_INFO_ADD);
            historyMap.put("S_DATA", modIdsStr);
            
           	service.getInsData("change_history.insert_history", historyMap);

        }
        catch(Exception e) {
            map.addAttribute("RSLT", -9999);
            logger.error("request parameter:" + LogUtils.mapToString(params));
            logger.error(e.getMessage(), e);
        }

    	
        
        return json;
    }

    // 임계치 수정
    @Transactional
    @RequestMapping("/admin/modifyThreshold")
    public View modifyThreshold(ModelMap map,
                              final HttpServletRequest request,
                              @RequestParam Map params) throws SQLException {

        if (logger.isDebugEnabled()) {
            logger.debug("parameter : {}", LogUtils.mapToString(params));
        }

        String [] svr_lst = new String[]{(String) params.get("N_MON_ID")};
        
        try {

            String sqlId = "critical_value.update_threshold_data";

            if ( isTrafficTrunk(request) ) {
                sqlId = "critical_value.update_traffic_trunk_threshold_data";
            } else if ( isAbandonedThreshold(request) ) {
                sqlId = "critical_value.update_abandoned_threshold_data";
            } else if ( isIvrAppThreshold(request) ) {
                sqlId = "critical_value.update_ivr_app_threshold_data";
            }

            service.getInsData(sqlId, params);
            params.put("svr_lst", svr_lst);

            // Agent 관련 임계치만 등록 하면 되지만 현재는 임시로 전체 임계치에 모두 등록
            params.put("N_FROM", 6);
            params.put("N_TO", 1);
            params.put("N_COMMAND", 100);

            service.getInsData("critical_value.thresholdInsViewToProcess", params);

            map.addAttribute("RSLT", 1);
            
            String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
            HashMap<String, Object> historyMap = new HashMap<String, Object>();
            
            String modIdsStr = Arrays.toString(svr_lst);
            modIdsStr = modIdsStr.replace("[", "");
            modIdsStr = modIdsStr.replace("]", "");
            
            historyMap.put("S_USER_ID", S_USER_ID);
            historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.THRESHOLD_INFO_CHANGE_EVENT_TYPE);
            historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.THRESHOLD_INFO_MODIFY);
            historyMap.put("S_DATA", modIdsStr);
            
            try {
            	service.getInsData("change_history.insert_history", historyMap);
            } catch (Exception e) {
            	logger.error(e.getMessage());
            } 
        }
        catch(Exception e) {
            map.addAttribute("RSLT", -9999);
            logger.error("request parameter:" + LogUtils.mapToString(params));
            logger.error(e.getMessage(), e);
        }
     
        return json;
    }

    // 임계치 삭제
    @Transactional
    @RequestMapping("/admin/removeThreshold")
    public View removeThreshold(ModelMap map,
                              HttpServletRequest request,
                              @RequestParam("DEL_KEY") String[] delKeys,
                              @RequestParam Map params) throws SQLException {

        if (logger.isDebugEnabled()) {
            logger.debug("parameter : {}", LogUtils.mapToString(params));
        }

        List <String> delThresholdInfo = new ArrayList<String>();

        try {
            for (String str : delKeys) {

                ObjectMapper om = new ObjectMapper();
                Map<String, String> delParams =
                        om.readValue(URLDecoder.decode(str, "UTF-8"), new TypeReference<Map<String, String>>(){});

                /*Type type = new TypeToken<Map<String, String>>(){}.getType();
                Map<String, String> map = new Gson().fromJson(URLDecoder.decode(str, "UTF-8"), type);*/

                String sqlId = "critical_value.delete_threshold_data";

                if (Integer.parseInt(delParams.get("N_ALM_TYPE")) == ALARM_TYPE_CM &&
                        Integer.parseInt(delParams.get("N_ALM_CODE")) == ALARM_CODE_TRAFFIC_TRUNK) {
                    sqlId = "critical_value.delete_traffic_trunk_threshold_data";
                }
                delThresholdInfo.add(delParams.get("N_MON_ID")); 
                service.getDelData(sqlId, delParams);
            }

            map.addAttribute("RSLT", 1);

            String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
            HashMap<String, Object> historyMap = new HashMap<String, Object>();
            
            String delThresholdStr = delThresholdInfo.toString();
            delThresholdStr = delThresholdStr.replace("[", "");
            delThresholdStr = delThresholdStr.replace("]", "");
            
            historyMap.put("S_USER_ID", S_USER_ID);
            historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.THRESHOLD_INFO_CHANGE_EVENT_TYPE);
            historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.THRESHOLD_INFO_DELETE);
            historyMap.put("S_DATA", delThresholdStr);
            
            try {
            	service.getInsData("change_history.insert_history", historyMap);
            } catch (Exception e) {
            	logger.error(e.getMessage());
            }
        }
        catch(Exception e) {
            map.addAttribute("RSLT", -9999);
            logger.error("request parameter:" + LogUtils.mapToString(params));
            logger.error(e.getMessage(), e);
        }

        
        return json;
    }

    // 임계치 시간 중복 체크
    @RequestMapping("/admin/duplicateThresholdTime")
    public View duplicateThresholdTime(ModelMap map,
                                       HttpServletRequest request,
                                       @RequestParam("N_MON_ID") int[] monIds,
                                       @RequestParam Map params) throws SQLException {

        if (logger.isDebugEnabled()) {
            logger.debug("parameter : {}", LogUtils.mapToString(params));
        }

        try {
            params.put("svr_lst", monIds);
            params.put("time", Integer.parseInt(((String) params.get("S_START_TIME")).replace(":", ""))); // 00:00

            List<Map<String, Object>> list;

            if ( isTrafficTrunk(request) ) {
                list = service.getList("critical_value.duplicateTrafficTrunkThresholdTime", params);
            }
            else {
                list = service.getList("critical_value.duplicateThresholdTime", params);
            }

            List<String> duplicateMonName = new ArrayList<String>();
            for (Map<String, Object> m : list) {
                int count = Integer.parseInt(String.valueOf(m.get("CNT")));
                if (count > 0) {
                    duplicateMonName.add((String) m.get("S_MON_NAME"));
                }
            }

            map.addAttribute("RSLT", 1);
            map.addAttribute("count", duplicateMonName.size());
            map.addAttribute("names", StringUtils.join(duplicateMonName.iterator(), ", "));
        }
        catch(Exception e) {


            map.addAttribute("RSLT", -9999);
            logger.error("request parameter:" + LogUtils.mapToString(params));
            logger.error(e.getMessage(), e);
        }

        return json;
    }

    // Traffic Trunk 임계치 초과 알람코드 여부
    private boolean isTrafficTrunk(HttpServletRequest request) throws ServletRequestBindingException {
        return ServletRequestUtils.getIntParameter(request, "N_ALM_TYPE") == ALARM_TYPE_CM
                && (ServletRequestUtils.getIntParameter(request, "N_ALM_CODE") == ALARM_CODE_TRAFFIC_TRUNK ||
                        ServletRequestUtils.getIntParameter(request, "N_ALM_CODE") == ALARM_CODE_TRAFFIC_TRUNK_GROUP);
    }

    // CTI E-Manager 포기율 증가 알람코드 여부
    private boolean isAbandonedThreshold(HttpServletRequest request) throws ServletRequestBindingException {
        return ServletRequestUtils.getIntParameter(request, "N_ALM_TYPE") == ALARM_TYPE_CTI_EMANAGER
                && ServletRequestUtils.getIntParameter(request, "N_ALM_CODE") == ALARM_CODE_ABANDONED_THRESHOLD;
    }

    // IVR-MPP 시나리오 사용량 임계치 초과 알람코드 여부
    private boolean isIvrAppThreshold(HttpServletRequest request) throws ServletRequestBindingException {
        return ServletRequestUtils.getIntParameter(request, "N_ALM_TYPE") == ALARM_TYPE_IVR
                && ServletRequestUtils.getIntParameter(request, "N_ALM_CODE") == ALARM_CODE_IVR_APP_THRESHOLD;
    }
}
