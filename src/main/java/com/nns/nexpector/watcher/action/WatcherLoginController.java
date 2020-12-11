package com.nns.nexpector.watcher.action;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * <pre>
 * com.nns.watcher.monitor.action
 * MonitoringController.java
 *
 * history :
 * 	2015-05-27 > 미래에셋 통합로그인으로 인해 주석처리 CommonLoginController 로 통합
 * </pre>
 *
 * @author	: yongpal
 * @Date	: 2013. 6. 18.
 * @Version	:
 * @category :
 */
@Controller
@RequestMapping("/watcher/*")
public class WatcherLoginController {

	/*private Logger log = Logger.getLogger(getClass());

	@Autowired
	private CommonServices service;

	@RequestMapping("login")
	public String getLoginPage(){
		return "/login";
	}

	@RequestMapping("logout")
	public String getLogoutPage(HttpServletRequest req){
		req.getSession().invalidate();
		return "/login";
	}

	@RequestMapping("/main")
	public String getMainPage(ModelMap map, @RequestParam Map param, HttpServletRequest req){
		HttpSession session = req.getSession();
		try {
			param.put("S_USER_PWD", Sha256.encrypt(RSACrypt.decode(RSACrypt.hexToByteArray(param.get("S_USER_PWD").toString()))));
//			param.put("S_USER_PWD", RSACrypt.decode(RSACrypt.hexToByteArray(param.get("S_USER_PWD").toString())));

			Map data = service.getMap("watcher_login.loginQry", param);

			if (data == null || data.isEmpty()) {
				service.getUpdData("watcher_login.loginFail", param);

				session.setAttribute("LOGIN_RESULT", "<script>alert('로그인에 실패하였습니다.');</script>");
				return "/login";
			}
			else {
				if (data.get("S_USER_ID").equals("SA")) {
					//SA 계정은 처리 안함.
				}
				else if (data.get("ID_LOCK").equals("Y")) {
					session.setAttribute("LOGIN_RESULT", "<script>alert('계정이 잠긴 상태 입니다.\\n담당자에 문의 하여 주십시오.');</script>");
					return "/login";
				}
				else if (data.get("PWD_CHG").equals("Y")) {
					session.setAttribute("LOGIN_RESULT", "<script>alert('비빌번호 사용 기간이 초과 되었습니다.\\n비밀번호를 변경하여 주십시오.'); window.open('./go_change_password.htm','pwd_change','width=400, height=400, location=no', true);</script>");
					return "/login";
				}
				else if (data.get("PWD_CHG").equals("C")) {
					session.setAttribute("LOGIN_RESULT", "<script>if(confirm('곧 비밀번호 사용 기간이 만료 됩니다.\\n비밀번호를 변경하시겠습니까?')){ window.open('./go_change_password.htm','pwd_change','width=400, height=400, location=no', true); }</script>");
				}
			}

			session.setAttribute(Constant.S_USER_ID, data.get("S_USER_ID"));
			session.setAttribute(Constant.S_USER_NAME, data.get("S_USER_NAME"));
			session.setAttribute(Constant.N_PER_CODE, data.get("N_PER_CODE"));
			session.setAttribute(Constant.N_GROUP_CODE, data.get("N_GROUP_CODE"));
			session.setAttribute(Constant.LOGIN_DT, data.get("LOGIN_DT"));
			session.setAttribute(Constant.COMPO_LST, service.getList("watcher_login.usr_component", param));
			session.setAttribute(Constant.BROWSER_TYPE, param.get("browser_type"));

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
			e.printStackTrace();
			session.setAttribute("LOGIN_RESULT", "<script>alert('로그인에 실패하였습니다');</script>");
			//map.addAttribute("login_fail", "1");
			//mv = new ModelAndView("/login_"+CommonConfigKey.getSiteId());
		}

		return "/watcher/main/main";
	}

	@RequestMapping("top")
	public String getTopPage(){
		return "/admin/prgm/top";
	}

	@RequestMapping("left")
	public String getLeftPage(){
		return "/admin/prgm/left";
	}*/
}
