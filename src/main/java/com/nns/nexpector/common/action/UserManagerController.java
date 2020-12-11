package com.nns.nexpector.common.action;

import com.nns.common.constants.LoginStateConstant;
import com.nns.common.util.RSACrypt;
import com.nns.common.util.Sha256;
import com.nns.nexpector.common.service.CommonServices;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/*")
public class UserManagerController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private CommonServices service;
    @Autowired
    private View json;

    @RequestMapping(value = {"admin/password/change", "watcher/password/change"}, method = RequestMethod.POST)
    public View getUpdData(ModelMap map, @RequestParam Map param) {
        try {
            String encryptChangePwd = Sha256.encrypt(RSACrypt.decode(RSACrypt.hexToByteArray(param.get("S_USER_PWD_NEW").toString())));
            String encryptPwd = Sha256.encrypt(RSACrypt.decode(RSACrypt.hexToByteArray(param.get("S_USER_PWD").toString())));
            param.put("change_pwd", encryptChangePwd);
            param.put("S_USER_PWD", encryptPwd);
            param.put("S_ID_LOCK", "N");
            param.put("N_STATE", LoginStateConstant.LOGOUT);
            
            int resultCode;
            if (checkPrevPassword((String) param.get("S_USER_ID"), encryptChangePwd)) {
                String qry_lst = "upd::admin_login.changeUserPassword;del::watcher_login.changePasswordHistory;upd::user_state.update_login_state;";
                resultCode = service.multiTransaction(qry_lst, param);
            }
            else {
                resultCode = -1000;
            }

            map.addAttribute("RSLT", resultCode);
        }
        catch (SQLException se) {
            map.addAttribute("RSLT", -10000);
            map.addAttribute("ERRCODE", se.getErrorCode());
            map.addAttribute("ERRMSG", se.getMessage());
        }
        catch (Exception e) {
            map.addAttribute("RSLT", -1);
            map.addAttribute("ERRCODE", -1);
            map.addAttribute("ERRMSG", e.getMessage());
            logger.error("비밀번호 변경 Error >>", e);
        }

        return json;
    }

    // 이전 비밀번호 사용불가 체크
    private boolean checkPrevPassword(String id, String password) throws Exception {
        Map<String, Object> condition = new HashMap<String, Object>();
        condition.put("S_USER_ID", id);
        condition.put("change_pwd", password);
        Integer count = (Integer) service.getObject("password_his_chk", condition);
        if (count != null && count > 0) {
           return false;
        }
        return true;
    }
}
