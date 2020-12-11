/*
 * Copyright (c) 2011 ZOOIN.NET CO.,LTD. All rights reserved.
 *
 * This software is the confidential and proprietary information of ZOOIN.NET CO.,LTD.
 * You shall not disclose such Confidential Information and shall use it
 * only in accordance with the terms of the license agreement you entered into
 * with ZOOIN.NET CO.,LTD.
 */
package com.nns.common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
*<pre>
* Project Name : gimjeSE
* Class : com.neonex.common.AuthCheckInterceptor.java
* This is about <code>AuthCheckInterceptor.java</code>.
*
*
* </pre>
*
* @Author : KUD
* @version: 1.0
* @since : JDK1.6
* @HISTORY: AUTHOR DATE DESC
* KUD 2013. 1. 14. CREATE
*/
public class AuthCheckInterceptor extends HandlerInterceptorAdapter {

	private static final Logger logger = LoggerFactory.getLogger(AuthCheckInterceptor.class);

	private boolean chkURL(String chk_url)
	{
		String[] pass_url = {
			"/login.htm"				//로그인 화면
			, "/session_err.htm"		//세션 에러 체크 화면
			, "/main.htm"				//로그인 처리 프로세스
			// , "/dashboard_network_info.htm"	// 대쉬보드 네트워크 현황
			// , "/dashboard_system_info.htm"		// 대쉬보드 시스템 현황
			, "/dashboard_call_info.htm"			// 대쉬보드 콜현황
			, "/dashboard/network_info.htm"	// 대쉬보드 네트워크 현황
			, "/dashboard/dashboard_network_info.htm"	// 대쉬보드 네트워크 현황"
			, "/dashboard/system_info.htm"		// 대쉬보드 시스템 현황
			, "/dashboard/call_info.htm"			// 대쉬보드 콜현황
			, "/network.htm"	// 대쉬보드 네트워크 현황
			, "/system.htm"		// 대쉬보드 시스템 현황
			, "/call.htm"			// 대쉬보드 콜현황
			, "/error_alram"   // 대쉬보드 알람

			, "/board_network.htm"
			, "/board_system.htm"
			, "/board_call.htm"
			, "/board_network_data.htm"
			, "/board_system_data.htm"
			, "/board_call_data.htm"
			
			, "/outsource_in.htm"			// 대쉬보드 통합외주상담센터 InBound
			, "/outsource_out.htm"			// 대쉬보드 통합외주상담센터 OutBound
			, "/crm_in.htm"			// 대쉬보드 고객만족센터상담센터 OutBound
			, "/crm_out.htm"			// 대쉬보드 고객만족센터상담센터 OutBound
			, "/itms_in.htm"			// 대쉬보드 ITMS상담센터 OutBound
			, "/itms_out.htm"			// 대쉬보드 ITMS상담센터 OutBound

			, "/cpu.htm"			// cpu chart
			, "/mem.htm"			// mem chart
			, "/disk.htm"			// disk chart

			, "/password/change.htm" // 비밀번호 변경
			, "/sms/view.htm"

	};

		for(int i=0;i<pass_url.length;i++)
		{
			if(chk_url.indexOf(pass_url[i]) > -1)
				return true;
		}

		return false;
	}

	@SuppressWarnings("unchecked")
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		try{
			//세션 체크 하지 않을 url
			if(chkURL(request.getRequestURI()))
			{
/*				if(request.getSession().getAttribute("S_USER_ID") == null)
					request.getSession().setAttribute("S_USER_ID", "posuser");*/
				return true;
			}

			//세션 체크
			if(request.getSession().getAttribute("S_USER_ID") == null)
			{
				RequestDispatcher requestdispatcher = request.getRequestDispatcher("/session_err.htm");
				requestdispatcher.forward(request, response);
				return false;

				/*if(request.getServletPath().indexOf("/admin/") > -1) {
					request.setAttribute("admin", "admin");
					RequestDispatcher requestdispatcher = request.getRequestDispatcher("/session_err.htm");
	                requestdispatcher.forward(request, response);
					return false;
				}
				else
				{
					//response.sendRedirect(request.getContextPath()+"/login.htm");
					response.sendRedirect(request.getContextPath()+"/session_err.htm");
					return false;
				}*/
			}
		}catch(Exception e){
			e.printStackTrace();
		}

		return true;


		//String url = request.getRequestURI();

		// 권한 체크에서 자유로운 URL 확인

//		String [] authFreeUrl = CommonConfigKey.getAuthFreeURLs();
//		log.debug(url);
//		if(url.contains("/client/") || url.contains("/mobile/") || url.contains("/kiosk/")){
//			return true;
//		}
//
//		if(authFreeUrl != null && authFreeUrl.length > 0){
//			for(String freeUrl:authFreeUrl){
//				if((CommonConfigKey.getWebPrefix() + freeUrl).equals(url)){
//					return true;
//				}
//			}
//		}
//		return false;

		// 세션이 있는지 확인...
		// 실 서버용
		/*UserDto userDto = (UserDto) WebUtils.getSessionAttribute(request, "USER_OBJ");

		if (userDto == null) { // 사용자 세션이 있는지 확인해 보고...
			// 접근이 제한 되었다고 해줘야 한다.
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
			return false;
		}else{
			// 메뉴에 대한 상세 정보를 넘겨 준다.
			List<MenuDto> menuList =  (List<MenuDto>) WebUtils.getSessionAttribute(request, "USER_MENU");

			if (menuList.size() > 0){
				for (MenuDto menuDto : menuList){
					if ((CommonConfigKey.getWebPrefix() + menuDto.getMenu_path()).equals(url)){
						WebUtils.setSessionAttribute(request, "CURR_MENU_ID", menuDto.getMenu_id());
						WebUtils.setSessionAttribute(request, "CURR_MENU_NM", menuDto.getMenu_nm());
						WebUtils.setSessionAttribute(request, "CURR_ORD", menuDto.getMenu_ord());

						List<MenuDto> subMenuList =  (List<MenuDto>) WebUtils.getSessionAttribute(request, "USER_SUBMENU");
						for(MenuDto subMenuDto : subMenuList){
							if (subMenuDto.getUp_cd().equals(menuDto.getMenu_id()) && subMenuDto.getMenu_ord().equals("1")){
								WebUtils.setSessionAttribute(request, "CURR_SUBMENU_ID", subMenuDto.getMenu_id());
								WebUtils.setSessionAttribute(request, "CURR_SUBMENU_NM", subMenuDto.getMenu_nm());
							}
						}
					}
				}
			}
			return true;
		}*/

		// 개발용
		/*List<MenuDto> menuList =  (List<MenuDto>) WebUtils.getSessionAttribute(request, "USER_MENU");

		if(menuList == null){
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
			return false;
		}

		if (menuList.size() > 0){
			for (MenuDto menuDto : menuList){
				if ((CommonConfigKey.getWebPrefix() + menuDto.getMenu_path()).equals(url)){
					WebUtils.setSessionAttribute(request, "CURR_MENU_ID", menuDto.getMenu_id());
					WebUtils.setSessionAttribute(request, "CURR_MENU_NM", menuDto.getMenu_nm());
					WebUtils.setSessionAttribute(request, "CURR_ORD", menuDto.getMenu_ord());

					List<MenuDto> subMenuList =  (List<MenuDto>) WebUtils.getSessionAttribute(request, "USER_SUBMENU");
					for(MenuDto subMenuDto : subMenuList){
						if (subMenuDto.getUp_cd().equals(menuDto.getMenu_id()) && subMenuDto.getMenu_ord().equals("1")){
							WebUtils.setSessionAttribute(request, "CURR_SUBMENU_ID", subMenuDto.getMenu_id());
							WebUtils.setSessionAttribute(request, "CURR_SUBMENU_NM", subMenuDto.getMenu_nm());
						}
					}
				}
			}
		}*/

		//return true;
	}
}
