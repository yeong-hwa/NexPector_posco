package com.nns.nexpector.admin.action;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.View;

import com.nns.nexpector.common.service.CommonServices;

/**
 * Server Sub Menu 관리 Controller.
 */
@Controller
@RequestMapping("/admin/server_sub_menu/")
public class AdminServerSubMenuController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private CommonServices service;
    @Autowired
    private View json;

    /**
     * Save void.
     *
     * @param serverTypeCode the server type code
     * @param tabKey the tab key
     * @param tabName the tab name
     * @param tabUrl the tab url
     * @param orderNumber the order number
     * @throws Exception the exception
     */
    @RequestMapping(value = "insert", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    @Transactional
    public void save(@RequestParam("N_TYPE_CODE") int serverTypeCode,
                     @RequestParam("TAB_KEY")     String tabKey,
                     @RequestParam("TAB_NAME")    String tabName,
                     @RequestParam("TAB_URL")     String tabUrl,
                     @RequestParam("ORDER_NUM")   int orderNumber) throws Exception {

        // Debug
        if (logger.isDebugEnabled())
        {
            logger.debug("N_TYPE_CODE : {}", serverTypeCode);
            logger.debug("TAB_KEY : {}",     tabKey);
            logger.debug("TAB_NAME : {}",    tabName);
            logger.debug("TAB_URL : {}",     tabUrl);
            logger.debug("ORDER_NUM : {}",   orderNumber);
        }

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("TAB_KEY",       tabKey);
        params.put("TAB_NAME",      tabName);
        params.put("TAB_URL",       tabUrl);

        service.getInsData("svr_sub_menu_info.insert_server_tab_menu_data", params);

        if (logger.isDebugEnabled())
        {
            logger.debug("SEQ_SVR_TAB_MENU : {}", params.get("SEQ_SVR_TAB_MENU"));
        }

        if (serverTypeCode > 0)
        {
            params.put("N_TYPE_CODE",   serverTypeCode);
            params.put("ORDER_NUM",     orderNumber);

            service.getInsData("svr_sub_menu_info.insert_server_tab_data", params);
        }
    }

    /**
     * Update void.
     *
     * @param seqSvrTabMenu the seq svr tab menu
     * @param serverTypeCode the server type code
     * @param tabKey the tab key
     * @param tabName the tab name
     * @param tabUrl the tab url
     * @param orderNumber the order number
     * @throws Exception the exception
     */
    @RequestMapping(value = "update", method = RequestMethod.PUT)
    @ResponseStatus(value = HttpStatus.OK)
    @Transactional
    public void update(@RequestParam("SEQ_SVR_TAB_MENU") int seqSvrTabMenu,
                       @RequestParam("N_TYPE_CODE")      int serverTypeCode,
                       @RequestParam("TAB_KEY")          String tabKey,
                       @RequestParam("TAB_NAME")         String tabName,
                       @RequestParam("TAB_URL")          String tabUrl,
                       @RequestParam("ORDER_NUM")        int orderNumber) throws Exception {

        // Debug
        if (logger.isDebugEnabled())
        {
            logger.debug("SEQ_SVR_TAB_MENU : {}",   seqSvrTabMenu);
            logger.debug("N_TYPE_CODE : {}",        serverTypeCode);
            logger.debug("TAB_KEY : {}",            tabKey);
            logger.debug("TAB_NAME : {}",           tabName);
            logger.debug("TAB_URL : {}",            tabUrl);
            logger.debug("ORDER_NUM : {}",          orderNumber);
        }

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("SEQ_SVR_TAB_MENU",  seqSvrTabMenu);
        params.put("TAB_KEY",           tabKey);
        params.put("TAB_NAME",          tabName);
        params.put("TAB_URL",           tabUrl);

        service.getUpdData("svr_sub_menu_info.update_server_tab_menu_data", params);

        // Server Type Code 가 존재 하면 TB_SVR_TAB 메뉴를 업데이트하고
        // 존재 하지 않으면 해당 테이블 ROW 삭제
        if (serverTypeCode > 0)
        {
            params.put("N_TYPE_CODE",   serverTypeCode);
            params.put("ORDER_NUM",     orderNumber);

            service.getUpdData("svr_sub_menu_info.update_server_tab_data", params);
        }
        else
        {
            service.getDelData("svr_sub_menu_info.delete_server_tab_data", params);
        }

    }

    /**
     * Delete void.
     *
     * @param seqSvrTabMenu the seq svr tab menu
     * @throws Exception the exception
     */
    @RequestMapping(value = "delete", method = RequestMethod.DELETE)
    @ResponseStatus(value = HttpStatus.OK)
    @Transactional
    public void delete(@RequestParam("SEQ_SVR_TAB_MENU") int seqSvrTabMenu) throws Exception {

        Map<String, Object> condition = new HashMap<String, Object>();
        condition.put("SEQ_SVR_TAB_MENU", seqSvrTabMenu);

        service.getDelData("svr_sub_menu_info.delete_server_tab_data", condition);
        service.getDelData("svr_sub_menu_info.delete_server_tab_menu_data", condition);
    }
}
