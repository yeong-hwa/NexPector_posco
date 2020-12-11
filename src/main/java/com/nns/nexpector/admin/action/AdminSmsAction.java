/*****************************************************************************
 * Copyright(c) 2016 NEONEXSOFT. All rights reserved.
 * This software is the proprietary information of NEONEXSOFT. 
 *****************************************************************************/
package com.nns.nexpector.admin.action;

import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import com.nns.util.SmsUtil;

/**
 * 
 * @version 1.0
 * @author chosg78@neonexsoft.com
 * @since 2016. 6. 7.
 * @see
 *
 * <pre>
 * << Modification Information >>
 *    Date	         Name          	       Desc
 * ----------      --------    ---------------------------
 *  2016. 6. 7.   chosg78
 *
 * </pre>
 */

@Controller
@RequestMapping("/sms/")
public class AdminSmsAction {
	
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	private Charset defaultCharset = StandardCharsets.UTF_8 ;
	 @Autowired
	    private View json;

	 @RequestMapping(value = "view")
	 public ModelAndView view(ModelMap map, @RequestParam Map<String, String> param) throws Exception {
	        logger.debug("등록");
	        
	        String result = null;
	        
//	        String msg = (String) req.getParameter("msg");
	        String msg = param.get("msg");
//	        String charsets = (String) req.getParameter("charset");
	        String charsets = param.get("charset");
	        
	        if (null != msg) {
	        	charsets = StringUtils.isNotEmpty(charsets) ? charsets : defaultCharset.toString();
	        	logger.debug("msg[{}]" , msg);
	        	
	        	if (StringUtils.isNotBlank(msg)) {
	        		result = SmsUtil.hexStr2Str(msg, charsets);
	        		logger.debug("result[{}]" , result);
	        	}
	        }
	        map.addAttribute("result", result);
	        map.addAttribute("charset", charsets);
	        return new ModelAndView("view");
	    }
	 
	   /* @RequestMapping(value = "convert", method = RequestMethod.GET)
	    public View convert(ModelMap map, @RequestBody Map<String, Object> params) throws Exception {
	        logger.debug("등록");
	        
	        String result = null;
	        
	        if (null != params) {
	        	String hexString = (String) params.get("msg");
	        	charset = StringUtils.isNotEmpty((String)params.get("charset")) ? String.valueOf(params.get("charset")) : charset;
	        	logger.debug("msg[{}]" , hexString);
	        	
	        	if (StringUtils.isNotBlank(hexString)) {
	        		result = SmsUtil.hexStr2Str(hexString, charset);
	        		logger.debug("result[{}]" , result);
	        	}
	        }
	        map.addAttribute("result", result);
	        return json;
	    }*/
}
