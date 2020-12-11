package com.nns.nexpector.admin;

import com.nns.common.session.Constant;
import com.nns.common.util.WebUtil;
import com.nns.nexpector.common.service.CommonServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.ServletRequestUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class Menu {

    @Autowired
    private CommonServices service;

    public void setAdminLeftMenu(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();

        // 관리자 페이지 Menu 조회
        if ( !WebUtil.isWatcherUrl(request) ) {

            int selectedMenuCode =
                    request.getParameter("menuCode") == null
                            ? getDefaultSelectedMenuCode(request)
                            : ServletRequestUtils.getIntParameter(request, "menuCode");
            selectedMenuCode = selectedMenuCode % 1000000 == 0 ? selectedMenuCode + 1 : selectedMenuCode;

            List<Map<String, String>> menu_lst = (List) session.getAttribute(Constant.Session.ALL_MENU_KEY);
            if (menu_lst == null || menu_lst.isEmpty()) {
                menu_lst = service.getList("UserMenu", session.getAttribute(Constant.Session.S_USER_ID));
                session.setAttribute(Constant.Session.ALL_MENU_KEY, menu_lst);
            }

            // 상위 메뉴코드 파라미터가 존재면 Session 에 상위 메뉴코드를 담아두었다가 등록 수정 시에 들어올때는
            // 상위 메뉴코드 파라미터가 존재하지 않으므로 그때 사용하기 위함
            if (request.getParameter("upperMenuCode") != null) {
                session.setAttribute(Constant.Session.SELECTED_UPPER_MENU_CODE,
                        ServletRequestUtils.getIntParameter(request, "upperMenuCode"));
            }

            ArrayList l_menu = new ArrayList();
            ArrayList m_menu = new ArrayList();

            for (int i = 0; i < menu_lst.size(); i++) {
                HashMap<String, Object> m = (HashMap) menu_lst.get(i);
                int menuCode = Integer.parseInt(String.valueOf(m.get("N_MENU_CODE")));
                if (menuCode % 1000000 == 0) {
                    l_menu.add(m);
                }
                else {
                    int requestParamUpperCode;
                    int upperMenuCode = Integer.parseInt(String.valueOf(m.get("PARENT_MENU")));

                    if (request.getParameter("upperMenuCode") == null) {
                        requestParamUpperCode = session.getAttribute(Constant.Session.SELECTED_UPPER_MENU_CODE) == null
                                                    ? 1000000
                                                    : (Integer) session.getAttribute(Constant.Session.SELECTED_UPPER_MENU_CODE);
                    } else {
                        requestParamUpperCode = ServletRequestUtils.getIntParameter(request, "upperMenuCode");
                    }

                    if (upperMenuCode == requestParamUpperCode) {
                        m_menu.add(m);
                    }
                }
            }

            session.setAttribute(Constant.Session.MAIN_MENU_KEY, l_menu);
            session.setAttribute(Constant.Session.SUB_MENU_KEY, m_menu);
            session.setAttribute(Constant.Session.SELECTED_MENU_CODE, selectedMenuCode);
        }
    }

    private int getDefaultSelectedMenuCode(HttpServletRequest request) {
        HttpSession session = request.getSession();
        // 테이블에 등록되어있는 메뉴 URL 외에 URL 이 들어올 시에 ex) insert, update 등
        // menuCode 가 안넘어오기때문에 이전 등록되어있던 menuCode 가 적용되도록 처리
        // 좌측 Sub Menu 선택로직 때문
        return session.getAttribute(Constant.Session.SELECTED_MENU_CODE) == null || request.getRequestURI().indexOf("user_info.retrieve.htm") > -1
                ? 1000000
                : (Integer) session.getAttribute(Constant.Session.SELECTED_MENU_CODE);

    }
}
