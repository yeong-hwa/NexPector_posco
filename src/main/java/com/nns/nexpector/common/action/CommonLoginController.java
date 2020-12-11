package com.nns.nexpector.common.action;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.nns.common.constants.ChangeHistoryConstants;
import com.nns.common.constants.LoginStateConstant;
import com.nns.common.enumeration.LoginFailType;
import com.nns.common.session.Constant;
import com.nns.common.util.RSACrypt;
import com.nns.common.util.Sha256;
import com.nns.common.util.WebUtil;
import com.nns.nexpector.admin.Menu;
import com.nns.nexpector.common.service.CommonServices;

@Controller
@RequestMapping("/*")
public class CommonLoginController {

    private static final Logger logger = LoggerFactory.getLogger(CommonLoginController.class);

    @Autowired
    private CommonServices service;
    @Autowired
    private Menu menu;
    
    private boolean isWatcherUrl(HttpServletRequest request) {
        if (request.getRequestURI().indexOf("/watcher/") > -1) {
            return true;
        }
        return false;
    }

    @RequestMapping(value = "/login")
    public String getLoginPage(ModelMap map, HttpServletRequest request){
        /*if (WebUtil.isWatcherUrl(request)) {
            map.addAttribute("path", "watcher");
        } else {
            map.addAttribute("path", "admin");
        }*/
        return "/login";
    }

	@RequestMapping(value = {"/watcher/logout", "/admin/logout"})
    public String getLogoutPage(ModelMap map, HttpServletRequest request){

    	String S_USER_ID = (String)request.getSession().getAttribute("S_USER_ID");
		String ipAddress = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes())
				.getRequest().getRemoteAddr();
		HashMap<String, Object> historyMap = new HashMap<String, Object>();
    	
		historyMap.put("S_USER_ID", S_USER_ID);
    	historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.LOGIN_LOGOUT_EVEVT_TYPE);
    	historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.LOGOUT_EVENT_DATA);
    	historyMap.put("S_DATA", S_USER_ID + " | IP Address: " + ipAddress);
    	
       	HashMap<String, Object> loginStateMap = new HashMap<String, Object>();
       	
    	loginStateMap.put("S_USER_ID", S_USER_ID);
    	loginStateMap.put("N_STATE", LoginStateConstant.LOGOUT);
    	
    	try {
			service.getInsData("change_history.insert_history", historyMap);
			service.getUpdData("user_state.update_login_state", loginStateMap);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
    	
    	request.getSession().invalidate();

    	if (isWatcherUrl(request)) {
            map.addAttribute("path", "watcher");
        } else {
            map.addAttribute("path", "admin");
        }
        return "/login";
    }

    @RequestMapping(value = {"/admin/main", "/watcher/main"})
    public String getMainPage(ModelMap map, @RequestParam Map param, HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        String viewPage = "/login";

        try {
            param.put("S_USER_PWD", Sha256.encrypt(RSACrypt.decode(RSACrypt.hexToByteArray(param.get("S_USER_PWD").toString()))));

            if (isWatcherUrl(request)) {
                map.addAttribute("path", "watcher");
            } else {
                map.addAttribute("path", "admin");
            }
            Map data = service.getMap("watcher_login.loginQry", param);
            map.addAttribute("S_USER_ID", param.get("S_USER_ID"));
            
            if (data == null || data.isEmpty()) {
                service.getUpdData("watcher_login.loginFail", param);
                
                Map loginFailInfo = service.getMap("watcher_login.pwd_fail_info", param);
                // 비밀번호 실패 횟수 초과 시 ID 잠금 (ID_LOCK: Y)
                if (!(param.get("S_USER_ID").equals("SA")) && loginFailInfo.get("SET_PWD_FAIL_LOCK").equals("Y")) {  
                	param.put("S_ID_LOCK", "Y"); 
                	service.getUpdData("watcher_login.user_lock", param);
                }
                map.addAttribute("LOGIN_RESULT", LoginFailType.NOT_ID.getCode());
                return viewPage;
            }
            else {
            	// 미로그인 기간 초과 시 ID 잠금 (ID_LOCK: L)
            	if (!(data.get("S_USER_ID").equals("SA")) && data.get("SET_LOGNTIME_LOGIN").equals("Y")) {
                	param.put("S_ID_LOCK", "L"); 
                	service.getUpdData("watcher_login.user_lock", param);
                	
                	map.addAttribute("LOGIN_RESULT", LoginFailType.ID_ROCK.getCode());
                	return viewPage;
            	}
            	
            	String idLock = (String) data.get("S_ID_LOCK");
            	if (idLock == null) { idLock = "N";}
            	
                if (data.get("S_USER_ID").equals("SA")) { // SA 계정은 처리 안함.
                }
                else if (idLock.equals("Y") || idLock.equals("L")) { // Y: 비밀번호 초과, L: 미로그인 기간 초과
                    // session.setAttribute("LOGIN_RESULT", "<script>alert('계정이 잠긴 상태 입니다.\\n담당자에 문의 하여 주십시오.');</script>");
                    // 20160713 huni1067 추가
                    /*if(data.get("LOCK_DATE").equals("N")){ // 계정이 잠긴후 10분후에만 로그인 할 수 있다.
                        map.addAttribute("LOGIN_RESULT", LoginFailType.ID_ROCK.getCode());
                        return viewPage;
                    }*/

                    map.addAttribute("LOGIN_RESULT", LoginFailType.ID_ROCK.getCode());
                    return viewPage;
                }
                else if (idLock.equals("C")) { // C: 미로그인 기간 초과 후 계정 잠금 해제 시 비밀번호 변경 팝업 오픈
                    // session.setAttribute("LOGIN_RESULT", "<script>alert('계정이 잠긴 상태 입니다.\\n담당자에 문의 하여 주십시오.');</script>");
                    
                    map.addAttribute("LOGIN_RESULT", LoginFailType.LONGTIME_LOGIN.getCode());
                    return viewPage;
                }
                else if (data.get("PWD_CHG").equals("Y")) {
                	// session.setAttribute("LOGIN_RESULT", "<script>alert('비빌번호 사용 기간이 초과 되었습니다.\\n비밀번호를 변경하여 주십시오.'); window.open('./go_change_password.htm','pwd_change','width=400, height=400, location=no', true);</script>");
                    map.addAttribute("LOGIN_RESULT", LoginFailType.PERIOD_EXCESS.getCode());
                    return viewPage;
                }
                else if (data.get("PWD_CHG").equals("C")) { // 계정블럭 해제 후, 미로그인 기간 초과 시 비밀번호 변경 팝업창
                	// session.setAttribute("LOGIN_RESULT", "<script>if(confirm('곧 비밀번호 사용 기간이 만료 됩니다.\\n비밀번호를 변경하시겠습니까?')){ window.open('./go_change_password.htm','pwd_change','width=400, height=400, location=no', true); }</script>");
                    map.addAttribute("LOGIN_RESULT", LoginFailType.PERIOD_PREVIOUS.getCode());
                }

                // 계정에 등록된 IP만 로그인 허용(SA 제외)
                if (data.get("IP_CHECK").equals("Y") && !data.get("S_USER_ID").equals("SA")) { 
                	String loginIp = request.getHeader("X-FORWARDED-FOR");
                	
                	if (loginIp == null || "".equals(loginIp)) {
                		loginIp = request.getRemoteAddr();
                	}
                	
                	String userIp = (String)data.get("S_ACCESS_IP");

                	if (!loginIp.equals(userIp)) {
                		map.addAttribute("LOGIN_RESULT", LoginFailType.NOT_ALLOWED_IP.getCode());
                		return viewPage;
                	}
                }
                
                service.getUpdData("watcher_login.loginSucc", param);
            }

            session.setAttribute(Constant.Session.S_USER_ID, data.get("S_USER_ID"));
            session.setAttribute(Constant.Session.S_USER_NAME, data.get("S_USER_NAME"));
            session.setAttribute(Constant.Session.N_PER_CODE, data.get("N_PER_CODE"));
            session.setAttribute(Constant.Session.N_GROUP_CODE, data.get("N_GROUP_CODE"));
            session.setAttribute(Constant.Session.LOGIN_DT, data.get("LOGIN_DT"));
            session.setAttribute(Constant.Session.COMPO_LST, service.getList("watcher_login.usr_component", param));
            session.setAttribute(Constant.Session.BROWSER_TYPE, param.get("browser_type"));

            // 20160713 huni1067 추가
            session.setAttribute(Constant.Session.LOGIN_CNT, data.get("LOGIN_CNT"));

//			List tmp_lst = service.getList("usr_monlist", param);
//			HashMap m = new HashMap();
//			for(int i=0;i<tmp_lst.size();i++)
//			{
//				String tmp_str = ((HashMap)tmp_lst.get(i)).get("N_MON_ID").toString();
//
//				m.put(tmp_str, tmp_str);
//			}
//
//			session.setAttribute("USER_MON_LST", m);

        }
        catch (Exception e) {
        	// session.setAttribute("LOGIN_RESULT", "<script>alert('로그인에 실패하였습니다');</script>");
            // session.setAttribute("LOGIN_RESULT", LoginFailType.FAIL.getCode());
            //map.addAttribute("login_fail", "1");
            //mv = new ModelAndView("/login_"+CommonConfigKey.getSiteId());

            logger.error("request parameter(USER ID):" + param.get("S_USER_ID"));
            logger.error(e.getMessage(), e);
        }

        String S_USER_ID = (String)session.getAttribute("S_USER_ID");
		String ipAddress = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes())
				.getRequest().getRemoteAddr();
		
    	HashMap<String, Object> historyMap = new HashMap<String, Object>();

    	historyMap.put("S_USER_ID", S_USER_ID);
    	historyMap.put("N_EVENT_TYPE", ChangeHistoryConstants.LOGIN_LOGOUT_EVEVT_TYPE);
    	historyMap.put("S_EVENT_NAME", ChangeHistoryConstants.LOGIN_EVENT_DATA);
    	historyMap.put("S_DATA", S_USER_ID + " | IP Address: " + ipAddress);
        
    	HashMap<String, Object> loginStateMap = new HashMap<String, Object>();
    	
    	loginStateMap.put("S_USER_ID", S_USER_ID);
    	loginStateMap.put("N_STATE", LoginStateConstant.LOGIN);
    	
    	try {
			service.getInsData("change_history.insert_history", historyMap);
			service.getUpdData("user_state.update_login_state", loginStateMap);

		} catch (Exception e) {
			logger.error(e.getMessage());
		}
    	
        if (isWatcherUrl(request)) {
            return "redirect:/watcher/realtime_stats/component/center_total.htm";
        	//return "redirect:/dashboard/dash_system_info.htm";
        }
        return "/admin/prgm/main";
    }

    /*@RequestMapping("/admin/top")
    public String getTopPage(){
        return "/admin/prgm/top";
    }

    @RequestMapping("/admin/left")
    public String getLeftPage(HttpServletRequest request) throws Exception {
        setAdminLeftMenu(request);
        return "/admin/prgm/left";
    }*/

    @RequestMapping(value = {"/watcher/main/switch", "/admin/main/switch"}, method = {RequestMethod.GET, RequestMethod.POST})
    public String switchMainPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (WebUtil.isWatcherUrl(request)) {
            //return "redirect:/watcher/realtime_stats/component/jijum_phone.htm";-01
        	return "redirect:/watcher/realtime_stats/component/center_total.htm";
        }
        
        menu.setAdminLeftMenu(request);
        List<Map<String, String>> menu_lst = (List) request.getSession().getAttribute(Constant.Session.ALL_MENU_KEY);
        
        if (menu_lst.size() > 0) {
        	return "redirect:/admin/go_prgm.user.user_info.retrieve.htm?menuCode=1000000&upperMenuCode=1000000";
        }
        return "redirect:/admin/go_prgm.user.user_info.empty.htm";
    }
}
