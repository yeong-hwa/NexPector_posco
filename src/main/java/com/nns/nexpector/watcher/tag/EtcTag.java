package com.nns.nexpector.watcher.tag;

import com.nns.nexpector.common.dao.CommonDao;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.FrameworkServlet;

import javax.servlet.jsp.tagext.TagSupport;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;

public class EtcTag extends TagSupport {
	private String group_code;
	private String type_code;
	
	public int doStartTag()
	{
		try{			
			StringBuffer buf = new StringBuffer();
			//ComboDao dao = new ComboDao();
			String spring_servlet_name = "";
			Enumeration en = pageContext.getServletContext().getAttributeNames();
			while(en.hasMoreElements())
			{
				String str = en.nextElement().toString();
				if(str.indexOf(FrameworkServlet.SERVLET_CONTEXT_PREFIX) > -1)
				{
					spring_servlet_name = str;
				}
			}
			WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(pageContext.getServletContext(), spring_servlet_name);
			
			CommonDao dao = ctx.getBean(CommonDao.class);
			
			HashMap param = new HashMap();
			
			param.put("N_GROUP_CODE", group_code);
			
			boolean flag = false;
			
			List lst = dao.getSelectList("compo_svr_type", param);
			
			for(int i=0;i<lst.size();i++)
			{
				if(((HashMap)lst.get(i)).get("CODE").toString().equals(type_code))
				{
					flag = true;
					break;
				}
			}
			
			if(flag)
				return EVAL_BODY_INCLUDE;
			else
				return SKIP_BODY;
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return SKIP_BODY;
	}
	
	public String getGroup_code() {
		return group_code;
	}
	
	public String getType_code() {
		return type_code;
	}
	
	public void setGroup_code(String group_code) {
		this.group_code = group_code;
	}
	
	public void setType_code(String type_code) {
		this.type_code = type_code;
	}
}
