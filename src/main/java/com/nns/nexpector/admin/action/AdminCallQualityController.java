package com.nns.nexpector.admin.action;

import com.nns.nexpector.common.service.CommonServices;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
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
@RequestMapping("/admin/*")
public class AdminCallQualityController {

    /** Logger */
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private View json;

    @Autowired
    private CommonServices service;

    @Autowired
    private SqlSessionFactory sf;

    @RequestMapping(value = "getCallQualityList", method = RequestMethod.GET)
    public View getCallQualityList(ModelMap map) {

        try {
            map.addAttribute("list", service.getList("call_quality.selectList", null));
        } catch (Exception e) {
            HashMap m = new HashMap();
            m.put("RSLT", -9999);
            map.addAttribute(m);
            logger.error("getCallQualityList Error!!", e);
        }

        return json;
    }

    @RequestMapping(value = "saveCallQuality", method = RequestMethod.POST)
    public View saveCallQuality(ModelMap map, @RequestParam Map param) {
        SqlSession session;
        session = sf.openSession();
        int result = -1;
        Map<String, Object> sqlParam = null;

        try {
            session.getConnection().setAutoCommit(false);
            /*
             * 통화품질 임계치 데이터는 총 9개 항목
             * Lost Packet > Minor - Code(0, 1)
             * Lost Packet > Major - Code(0, 2)
             * Lost Packet > Critical - Code(0, 3)
             * Jitter > Minor - Code(1, 1)
             * Jitter > Major - Code(1, 2)
             * Jitter > Critical - Code(1, 3)
             * Latency > Minor - Code(2, 1)
             * Latency > Major - Code(2, 2)
             * Latency > Critical - Code(2, 3)
             */
            sqlParam = new HashMap<String, Object>();
            String queryId = "call_quality.updateCallQuality";
            sqlParam.put("S_INFO_TYPE", 0);
            sqlParam.put("S_CRITICAL_CODE", 1);
            sqlParam.put("N_START_VAL", defaultNumber(param.get("lostMinorStart")));
            sqlParam.put("N_END_VAL", defaultNumber(param.get("lostMinorEnd")));
            session.update(queryId, sqlParam);

            sqlParam.put("S_CRITICAL_CODE", 2);
            sqlParam.put("N_START_VAL", defaultNumber(param.get("lostMajorStart")));
            sqlParam.put("N_END_VAL", defaultNumber(param.get("lostMajorEnd")));
            session.update(queryId, sqlParam);

            sqlParam.put("S_CRITICAL_CODE", 3);
            sqlParam.put("N_START_VAL", defaultNumber(param.get("lostCriticalStart")));
            sqlParam.put("N_END_VAL", defaultNumber(param.get("lostCriticalEnd")));
            session.update(queryId, sqlParam);

            sqlParam.put("S_INFO_TYPE", 1);
            sqlParam.put("S_CRITICAL_CODE", 1);
            sqlParam.put("N_START_VAL", defaultNumber(param.get("jitterMinorStart")));
            sqlParam.put("N_END_VAL", defaultNumber(param.get("jitterMinorEnd")));
            session.update(queryId, sqlParam);

            sqlParam.put("S_CRITICAL_CODE", 2);
            sqlParam.put("N_START_VAL", defaultNumber(param.get("jitterMajorStart")));
            sqlParam.put("N_END_VAL", defaultNumber(param.get("jitterMajorEnd")));
            session.update(queryId, sqlParam);

            sqlParam.put("S_CRITICAL_CODE", 3);
            sqlParam.put("N_START_VAL", defaultNumber(param.get("jitterCriticalStart")));
            sqlParam.put("N_END_VAL", defaultNumber(param.get("jitterCriticalEnd")));
            session.update(queryId, sqlParam);

            sqlParam.put("S_INFO_TYPE", 2);
            sqlParam.put("S_CRITICAL_CODE", 1);
            sqlParam.put("N_START_VAL", defaultNumber(param.get("latencyMinorStart")));
            sqlParam.put("N_END_VAL", defaultNumber(param.get("latencyMinorEnd")));
            session.update(queryId, sqlParam);

            sqlParam.put("S_CRITICAL_CODE", 2);
            sqlParam.put("N_START_VAL", defaultNumber(param.get("latencyMajorStart")));
            sqlParam.put("N_END_VAL", defaultNumber(param.get("latencyMajorEnd")));
            session.update(queryId, sqlParam);

            sqlParam.put("S_CRITICAL_CODE", 3);
            sqlParam.put("N_START_VAL", defaultNumber(param.get("latencyCriticalStart")));
            sqlParam.put("N_END_VAL", defaultNumber(param.get("latencyCriticalEnd")));
            session.update(queryId, sqlParam);

            result = 1;
            session.commit();
        } catch(Exception e) {
            logger.error("Parameter >> " + sqlParam);
            logger.error("saveCallQuality Error!!", e);
            result = -1;
            session.rollback();
        } finally{
            try {
                session.getConnection().setAutoCommit(true);
            } catch (SQLException e) {} finally {
                if(session != null) session.close();
            }
        }

        map.addAttribute("result", result);
        return json;
    }

    private float defaultNumber(Object str) {
        return NumberUtils.createFloat(StringUtils.defaultString(str == null ? null : String.valueOf(str), "0"));
    }
}
