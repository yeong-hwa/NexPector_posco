package com.nns.nexpector.watcher.action;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import com.nns.common.constants.DeviceTypeConstants;
import com.nns.common.constants.SnmpTypeConstants;
import com.nns.common.session.Constant;
import com.nns.common.util.WebUtil;
import com.nns.nexpector.common.service.CommonServices;
import com.nns.nexpector.watcher.vo.ServerDetailTabMenu;
import com.sun.org.apache.xml.internal.security.utils.Base64;

/**
 * @author hanjoonho
 * 감시장비별 상세조회 관련 Controller
 */
@Controller
@RequestMapping("/watcher/server_detail/")
public class WatcherServerDetailController {

    private final static String MENU_LINK_KEY = "menulink";
    private final static String MENU_LINK_MAIN = "M";
    private final static String MENU_LINK_SUB = "S";
    private final static String MENU_LINK_REAL_TIME_ERROR = "E";

    /** Logger */
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private HttpSession session;
    @Autowired
    private View json;

    /** Service CommonServices */
    @Autowired private CommonServices commonServices;

    /**
     * Gets server detail config info.
     *
     * @param param the param
     * @return the server detail config info
     * @throws Exception the exception 
     */
    @RequestMapping("monitoring")
    public ModelAndView getServerDetailConfigInfo(@RequestParam Map<String, String> param) throws Exception {

        String vgName = null;
        int styleCode = 0;
        int snmpManCode = 0;
        int typeCode = 0;
        String typeName = "";
        String server = "N";
        String cmType = null;

        if ( MENU_LINK_MAIN.equals(param.get(MENU_LINK_KEY)) ) { // Main Menu Link 로 넘어왔을 경우

            Map<String, Object> svrListParams = new HashMap<String, Object>();
            svrListParams.put("SESSION_USER_ID", session.getAttribute(Constant.Session.S_USER_ID));
            svrListParams.put("firstRecordIndex", 0);
            svrListParams.put("lastRecordIndex", 1);

            List<Map<String, Object>> svrList = commonServices.getList("server_detail.SvrLstQry2", svrListParams);

            if (!svrList.isEmpty()) {
                Map<String, Object> svr = svrList.get(0);
                styleCode = svr.get("N_STYLE_CODE") == null ? 0 : Integer.parseInt(svr.get("N_STYLE_CODE").toString());
                snmpManCode = svr.get("N_SNMP_MAN_CODE") == null ? 0 : Integer.parseInt(svr.get("N_SNMP_MAN_CODE").toString());
                typeCode = svr.get("N_TYPE_CODE") == null ? 0 : Integer.parseInt(svr.get("N_TYPE_CODE").toString());
                typeName = (String) svr.get("S_TYPE_NAME");
                if (param.get("N_MON_ID") == null) {
                    param.put("N_MON_ID", svr.get("N_MON_ID").toString());
                }
            }
        }
        else { // 실시간 장애현황 Link 로 넘어왔을 경우

            Map<String, Object> monInfo = commonServices.getMap("server_detail.selectMonInfo", param);

            styleCode = Integer.parseInt(String.valueOf(monInfo.get("N_STYLE_CODE")));
            snmpManCode = Integer.parseInt(String.valueOf(monInfo.get("SNMP_MAN_CODE")));
            typeCode = Integer.parseInt(String.valueOf(monInfo.get("N_TYPE_CODE")));
            typeName = String.valueOf(monInfo.get("S_TYPE_NAME"));
        }

        Map<String, Object> serverInfo = Collections.EMPTY_MAP;
        List<ServerDetailTabMenu> tempTabMenu = new ArrayList<ServerDetailTabMenu>();

        if ( !StringUtils.isEmpty(param.get("N_MON_ID")) ) {

            // Server Info 조회
            serverInfo = commonServices.getMap("ServerDetailInfoQry", param);

            Map<String, Object> dataCnt = new HashMap<String, Object>();

            // Default DataCnt
            dataCnt.putAll(commonServices.getMap("ServerDetailDatacnt_Default", param));
            
            // 장비타입 별 DataCnt
            switch (typeCode) {
                case DeviceTypeConstants.CM :
	            	if(snmpManCode == SnmpTypeConstants.AVAYA_CM) {	//AvayaCm
	            		dataCnt.putAll(commonServices.getMap("ServerDetailDatacnt_AvayaCm", param));
	            	} 
	            	else if(snmpManCode == SnmpTypeConstants.CISCO_CM) {	//CiscoCm
	            		dataCnt.putAll(commonServices.getMap("ServerDetailDatacnt_CiscoCm", param));
	            	} 
	            	else {
	            		dataCnt.putAll(commonServices.getMap("ServerDetailDatacnt_AvayaCm", param));
	            	}
                    break;
/*                case 2000 : 
                    dataCnt = commonServices.getMap("ServerDetailDatacnt_VoiceGateway", param);
                    break;*/
                case DeviceTypeConstants.IVR : // IVR
                    dataCnt.putAll(commonServices.getMap("ServerDetailDatacnt_IVR", param));
                    break;
                case DeviceTypeConstants.REC : // REC(녹취)
                    dataCnt.putAll(commonServices.getMap("ServerDetailDatacnt_REC", param));
                    break;
                case DeviceTypeConstants.FAX : // FAX
                    dataCnt.putAll(commonServices.getMap("ServerDetailDatacnt_FAX", param));
                    break;
                default : // 자원(CPU, Memory, DISK)
                	break;
            }
            
            // snmp man code 별로 data cnt 조회
            if (snmpManCode == SnmpTypeConstants.CISCO_SWITCH 
            		|| snmpManCode == SnmpTypeConstants.AVAYA_SWITCH 
            		|| snmpManCode == SnmpTypeConstants.CISCO_VOICE_GATEWAY
            		|| snmpManCode == SnmpTypeConstants.AVAYA_VOICE_GATEWAY
            		|| snmpManCode == SnmpTypeConstants.STANDARD_EQUIPMENT) {
            	dataCnt.putAll(commonServices.getMap("ServerDetailDatacnt_m" + String.format("%02d", snmpManCode), param));
            }
            
            if (dataCnt.get("CNT_RESOURCE") != null
                    && Integer.parseInt(dataCnt.get("CNT_RESOURCE").toString()) > 0) {
                server = "Y"; // 감시장비 상세조회 상단 CPU, MEMORY, DISK Progress Bar 종류
            }

            // Server Detail Tab Menu DB 조회
            ServerDetailTabMenu condition = new ServerDetailTabMenu();
            condition.setStyleCode(styleCode);
            condition.setSnmpManCode(snmpManCode);
            condition.setTypeCode(typeCode);
            condition.setVgName(vgName);
            condition.setCmType(cmType);

            // 기본적으로 자원, 프로세스, 서비스 모든 장비 노출 (Agent 감시)
            List<ServerDetailTabMenu> tabMenu = new ArrayList<ServerDetailTabMenu>();
            tabMenu = commonServices.getList("server_detail.selectServerDetailResourceTabMenu", Collections.EMPTY_MAP);

            // 장비타입 별 Tab Menu 조회
            tabMenu.addAll(commonServices.getList("server_detail.selectServerDetailTabMenu", condition));

            // 기본적으로 장애현황은 모든 장비에 노출한다.
            tabMenu.addAll(commonServices.getList("server_detail.selectServerDetailDefaultTabMenu", Collections.EMPTY_MAP));
            
            // if style_code is 0(agent), DB현황 탭 추가 (20170126 주석처리)
            /*            
             	if (styleCode == ServerStyle.AGENT.getCode()) {
            	tabMenu.addAll(commonServices.getList("server_detail.selectServerDetailDBStatusTabMenu", Collections.EMPTY_MAP));	
			}
             */
            // Data Count 가 존재하면 임시 LIST 에 해당 값을 저장하고 존재하지 않으면 tabMenu 전체 값 저장
            if (!dataCnt.isEmpty())
            {
                for (ServerDetailTabMenu menu : tabMenu)
                {
                    if (dataCnt.get(menu.getTabKey()) != null
                            && Integer.parseInt(dataCnt.get(menu.getTabKey()).toString()) > 0) {
                        tempTabMenu.add(menu);
                    }
                }
            }
            else {
                for (ServerDetailTabMenu menu : tabMenu)
                {
                	if (menu.getTabKey().equals("CNT_RESOURCE") || menu.getTabKey().equals("CNT_FAULT")) {
                		tempTabMenu.add(menu);
                	}
                }
//             	tempTabMenu.addAll(tabMenu);
            }

        }
        
        ModelAndView mav = new ModelAndView("/watcher/server_detail/server_detail_info/server_detail_info");
        mav.addObject("svr_info", serverInfo);
        mav.addObject("tabs", tempTabMenu);
        mav.addObject("server", server);

        mav.addObject("N_MON_ID", param.get("N_MON_ID"));
        mav.addObject("vg_name", vgName);
        mav.addObject("style_code", styleCode);
        mav.addObject("snmp_man_code", snmpManCode);
        mav.addObject("type_code", typeCode);
        mav.addObject("S_TYPE_NAME", typeName);
        return mav;
    }
    
    @RequestMapping(value = "resourceUsingHistory", method = RequestMethod.GET)
    public View getResourceUsingHistory(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
        params.put("TARGET_MONTH", params.get("N_DATE_HOUR").toString().substring(4, 6));
        
        map.addAttribute("list", commonServices.getList("server_detail.resourceUsingHistoryQry", params));
        map.addAttribute("RSLT", 1);

        return json;
    }
    
    @RequestMapping(value = "resourceUsingProcessTopHistoryQry", method = RequestMethod.GET)
    public View getResourceUsingProcessTopHistoryQry(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
        params.put("TARGET_MONTH", params.get("N_DATE_TIME").toString().substring(4, 6));
        
        map.addAttribute("list", commonServices.getList("server_detail.resourceUsingProcessTopHistoryQry", params));
        map.addAttribute("RSLT", 1);
        
        return json;
    }
    
    @RequestMapping(value = "switchTrafficUsingHistory", method = RequestMethod.GET)
    public View getSwitchUsingTrafficHistory(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
        params.put("TARGET_MONTH", params.get("N_DAY").toString().substring(4, 6));
        
        map.addAttribute("list", commonServices.getList("snmp_m04.switchTrafficUsingHistoryQry", params));
        map.addAttribute("avg_info", commonServices.getMap("snmp_m04.switchTrafficUsingAvgQry", params));
        map.addAttribute("max_info", commonServices.getMap("snmp_m04.switchTrafficUsingMaxQry", params));
        map.addAttribute("RSLT", 1);

        return json;
    }
    
    @RequestMapping(value = "switchTrafficUsingDetailHistoryQry", method = RequestMethod.GET)
    public View getSwitchUsingTrafficDetailHistory(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
        params.put("TARGET_MONTH", params.get("N_DAY").toString().substring(4, 6));
        
        map.addAttribute("detail_list", commonServices.getList("snmp_m04.switchTrafficUsingDetailHistoryQry", params));
        map.addAttribute("avg_info", commonServices.getMap("snmp_m04.switchTrafficUsingDetailAvgQry", params));
        map.addAttribute("max_info", commonServices.getMap("snmp_m04.switchTrafficUsingDetailMaxQry", params));        
        map.addAttribute("RSLT", 1);

        return json;
    }
    
    @RequestMapping(value = "ciscovgTrafficUsingHistory", method = RequestMethod.GET)
    public View getCiscoVgUsingTrafficHistory(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
        params.put("TARGET_MONTH", params.get("N_DAY").toString().substring(4, 6));
        
        map.addAttribute("list", commonServices.getList("server_detail.ciscovgTrafficUsingHistoryQry", params));
        map.addAttribute("avg_info", commonServices.getMap("server_detail.ciscovgTrafficUsingAvgQry", params));
        map.addAttribute("max_info", commonServices.getMap("server_detail.ciscovgTrafficUsingMaxQry", params));
        map.addAttribute("RSLT", 1);

        return json;
    }
    
    @RequestMapping(value = "ciscovgTrafficUsingDetailHistoryQry", method = RequestMethod.GET)
    public View getCiscoVgUsingTrafficDetailHistory(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
        params.put("TARGET_MONTH", params.get("N_DAY").toString().substring(4, 6));
        
        map.addAttribute("detail_list", commonServices.getList("server_detail.ciscovgTrafficUsingDetailHistoryQry", params));
        map.addAttribute("avg_info", commonServices.getMap("server_detail.ciscovgTrafficUsingDetailAvgQry", params));
        map.addAttribute("max_info", commonServices.getMap("server_detail.ciscovgTrafficUsingDetailMaxQry", params));
        map.addAttribute("RSLT", 1);

        return json;
    }    
    

    @RequestMapping(value = "ciscovgE1UsingHistoryQry", method = RequestMethod.GET)
    public View getCiscoVgUsingE1DetailHistory(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
        //params.put("TARGET_MONTH", params.get("N_DAY").toString().substring(4, 6));
        
        map.addAttribute("detail_list", commonServices.getList("server_detail.M03E1StatusQry", params));
        map.addAttribute("RSLT", 1);

        return json;
    }    
    
    @RequestMapping(value = "standardTrafficUsingHistory", method = RequestMethod.GET)
    public View getStandardUsingTrafficHistory(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
        params.put("TARGET_MONTH", params.get("N_DAY").toString().substring(4, 6));
        
        map.addAttribute("list", commonServices.getList("server_detail.standardTrafficUsingHistoryQry", params));
        map.addAttribute("avg_info", commonServices.getMap("server_detail.standardTrafficUsingAvgQry", params));
        map.addAttribute("max_info", commonServices.getMap("server_detail.standardTrafficUsingMaxQry", params));
        map.addAttribute("RSLT", 1);

        return json;
    }
    
    @RequestMapping(value = "standardTrafficUsingDetailHistoryQry", method = RequestMethod.GET)
    public View getStandardUsingTrafficDetailHistory(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
        params.put("TARGET_MONTH", params.get("N_DAY").toString().substring(4, 6));
        
        map.addAttribute("detail_list", commonServices.getList("server_detail.standardTrafficUsingDetailHistoryQry", params));
        map.addAttribute("avg_info", commonServices.getMap("server_detail.standardTrafficUsingDetailAvgQry", params));
        map.addAttribute("max_info", commonServices.getMap("server_detail.standardTrafficUsingDetailMaxQry", params));        
        map.addAttribute("RSLT", 1);

        return json;
    }   
    
    @RequestMapping(value = "svrLicenseCheck", method = RequestMethod.GET)
    public View getSvrLicenseCheck(ModelMap map, @RequestParam Map<String, Object> params) throws Exception {
        map.addAttribute("lic_info", commonServices.getList("server_detail.ServerLicenseChkQry", params));
        map.addAttribute("RSLT", 1);        

        return json;
    }      
}
