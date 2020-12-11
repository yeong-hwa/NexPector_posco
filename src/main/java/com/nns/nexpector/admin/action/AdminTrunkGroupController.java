package com.nns.nexpector.admin.action;

import com.nns.nexpector.common.service.CommonServices;
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

import java.util.HashMap;
import java.util.Map;

/**
 * Trunk Group 관리 Controller.
 */
@Controller
@RequestMapping("/admin/trunk_group/")
public class AdminTrunkGroupController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private CommonServices service;
    @Autowired
    private View json;

    /**
     * Save void.
     *
     * @param dialingName the dialing name
     * @param company the company
     * @param center the center
     * @param monIds the mon ids
     * @param trunkGrpNumbers the trunk grp numbers
     * @throws Exception the exception
     */
    @RequestMapping(value = "insert", method = RequestMethod.POST)
    @ResponseStatus(value = HttpStatus.OK)
    @Transactional
    public void save(@RequestParam("S_DIALING_NAME")    String dialingName,
    				 @RequestParam("N_GROUP_CODE")    	String groupCode,
                     //@RequestParam("S_COMPANY")         String company,
                     //@RequestParam("S_CENTER")          String center,
                     @RequestParam("N_MON_ID")          int[] monIds,
                     @RequestParam("N_TRUNK_GROUP_NUM") int[] trunkGrpNumbers) throws Exception {

        // Debug
        if (logger.isDebugEnabled())
        {
            logger.debug("S_DIALING_NAME : {}", dialingName);
            logger.debug("N_GROUP_CODE : {}", 	groupCode);

            for (int i = 0; i < monIds.length; i++)
            {
                int monId           = monIds[i];
                int trunkGrpNumber  = trunkGrpNumbers[i];

                logger.debug("N_MON_ID[{}] : {}",           i, monId);
                logger.debug("N_TRUNK_GROUP_NUM[{}] : {}",  i, trunkGrpNumber);
            }
        }

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("S_DIALING_NAME",    dialingName);
        params.put("S_COMPANY",    		groupCode);
        //params.put("S_COMPANY",         company);
        //params.put("S_CENTER",          center);

        // Dialing Type Insert
        service.getInsData("trunk_group_info.insertDialingType", params);

        if (logger.isDebugEnabled())
        {
            logger.debug("dialingNumber : {}", params.get("N_DIALING_CODE"));
        }

        // Dialing Info Insert
        for (int i = 0; i < monIds.length; i++)
        {
            params.put("N_MON_ID",      monIds[i]);
            params.put("N_GROUP_NUM",   trunkGrpNumbers[i]);

            service.getInsData("trunk_group_info.insertDialingInfo", params);
        }
    }

    /**
     * Update void.
     *
     * @param dialingCode the dialing code
     * @param dialingName the dialing name
     * @param company the company
     * @param center the center
     * @param monIds the mon ids
     * @param trunkGrpNumbers the trunk grp numbers
     * @throws Exception the exception
     */
    @RequestMapping(value = "update", method = RequestMethod.PUT)
    @ResponseStatus(value = HttpStatus.OK)
    @Transactional
    public void update(@RequestParam("N_DIALING_CODE")      String dialingCode,
                       @RequestParam("S_DIALING_NAME")      String dialingName,
                       @RequestParam("N_GROUP_CODE")    	String groupCode,
                       //@RequestParam("S_COMPANY")           String company,
                       //@RequestParam("S_CENTER")            String center,
                       @RequestParam("N_MON_ID")            int[] monIds,
                       @RequestParam("N_TRUNK_GROUP_NUM")   int[] trunkGrpNumbers) throws Exception {

        if (logger.isDebugEnabled())
        {
            logger.debug("N_DIALING_CODE : {}", dialingCode);
            logger.debug("S_DIALING_NAME : {}", dialingName);
            logger.debug("N_GROUP_CODE : {}",   groupCode);
            //logger.debug("S_CENTER : {}",       center);

            for (int i = 0; i < monIds.length; i++)
            {
                int monId           = monIds[i];
                int trunkGrpNumber  = trunkGrpNumbers[i];

                logger.debug("N_MON_ID[{}] : {}",           i, monId);
                logger.debug("N_TRUNK_GROUP_NUM[{}] : {}",  i, trunkGrpNumber);
            }
        }

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("N_DIALING_CODE",    dialingCode);
        params.put("S_DIALING_NAME",    dialingName);
        params.put("S_COMPANY",         groupCode);
        //params.put("S_CENTER",          center);

        // Dialing Type Update
        service.getUpdData("trunk_group_info.updateDialingType", params);

        // Dialing Info Delete
        service.getDelData("trunk_group_info.deleteDialingInfo", params);

        // Dialing Info Insert
        for (int i = 0; i < monIds.length; i++)
        {
            params.put("N_MON_ID",      monIds[i]);
            params.put("N_GROUP_NUM",   trunkGrpNumbers[i]);

            service.getInsData("trunk_group_info.insertDialingInfo", params);
        }
    }

    /**
     * Delete void.
     *
     * @param dialingCode the dialing code
     */
    @RequestMapping(value = "delete", method = RequestMethod.DELETE)
    @ResponseStatus(value = HttpStatus.OK)
    @Transactional
    public void delete(@RequestParam("N_DIALING_CODE") int dialingCode) throws Exception {
    	

        Map<String, Object> condition = new HashMap<String, Object>();
        condition.put("N_DIALING_CODE", dialingCode);
        service.getDelData("trunk_group_info.deleteDialingType", condition);
        service.getDelData("trunk_group_info.deleteDialingInfo", condition);
    }
}
