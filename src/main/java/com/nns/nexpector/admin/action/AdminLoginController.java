package com.nns.nexpector.admin.action;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

//import com.nns.manager.service.CommonServices;

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
@RequestMapping("/admin/*")
public class AdminLoginController {
	
	/*private Logger log = Logger.getLogger(getClass());
	
	@Autowired
	private CommonServices service;
	
	@RequestMapping("login")
	public String getLoginPage(){
		return "/admin/login";
	}
	
	@RequestMapping("logout")
	public String getLogoutPage(HttpServletRequest req){
		req.getSession().invalidate();
		return "/admin/login";
	}
	
	@RequestMapping("/main")
	public ModelAndView getMainPage(@RequestParam Map param, HttpServletRequest req){
		ModelAndView mv; //new ModelAndView("redirect:/accept/main.htm");
		try {
			param.put("S_USER_PWD", Sha256.encrypt(RSACrypt.decode(RSACrypt.hexToByteArray(param.get("S_USER_PWD").toString()))));
//			param.put("S_USER_PWD", RSACrypt.decode(RSACrypt.hexToByteArray(param.get("S_USER_PWD").toString())));
			Map data = service.getMap("adminLoginQry", param);

			if (data == null) {
				Map tmp_m = new HashMap();
				tmp_m.put("result", "fail");
				tmp_m.put("S_USER_ID", param.get("S_USER_ID"));
				mv = new ModelAndView("/admin/login", tmp_m);

				return mv;
			} else if (data.get("S_USER_ID") == null) {
				Map tmp_m = new HashMap();
				tmp_m.put("result", "fail");
				tmp_m.put("S_USER_ID", param.get("S_USER_ID"));
				mv = new ModelAndView("/admin/login", tmp_m);

				return mv;
			}

			Date afterThreeMonth = DateUtils.getCalcDate(2, 3, (Date) data.get("D_PASSWORD_CHANGE"));
			int compare = new Date().compareTo(afterThreeMonth);
			if (compare > 0) {
				Map tmp_m = new HashMap();
				tmp_m.put("result", "fail");
				tmp_m.put("code", "1000");
				tmp_m.put("S_USER_ID", data.get("S_USER_ID"));
				tmp_m.put("S_USER_NAME", data.get("S_USER_NAME"));
				mv = new ModelAndView("/admin/login", tmp_m);

				return mv;
			}

			HttpSession session = req.getSession();

			session.setAttribute("S_USER_ID", data.get("S_USER_ID"));
			session.setAttribute("S_USER_NAME", data.get("S_USER_NAME"));
			session.setAttribute("S_USER_PWD", data.get("S_USER_PWD"));
			session.setAttribute("N_PER_CODE", data.get("N_PER_CODE"));
			session.setAttribute("N_GROUP_CODE", data.get("N_GROUP_CODE"));

			List menu_lst = service.getList("UserMenu", param);

			ArrayList l_menu = new ArrayList();
			ArrayList m_menu = new ArrayList();

			for (int i = 0; i < menu_lst.size(); i++) {
				HashMap<String, String> m = (HashMap) menu_lst.get(i);

				if (Integer.parseInt(String.valueOf(m.get("N_MENU_CODE"))) % 1000000 == 0) {
					l_menu.add(m);
				} else {
					m_menu.add(m);
				}
			}

			session.setAttribute("l_menu", l_menu);
			session.setAttribute("m_menu", m_menu);

			mv = new ModelAndView("/admin/prgm/main");
		}
		catch (Exception e) {
			e.printStackTrace();

			Map tmp_m = new HashMap();
			tmp_m.put("result", "fail");
			mv = new ModelAndView("/admin/login", tmp_m);
		}


		return mv;
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
