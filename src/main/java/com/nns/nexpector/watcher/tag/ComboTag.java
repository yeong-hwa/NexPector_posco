package com.nns.nexpector.watcher.tag;

import com.nns.nexpector.common.dao.CommonDao;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.FrameworkServlet;

import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.StringTokenizer;


public class ComboTag extends TagSupport {
	private String strQryname;		//쿼리 이름 (mybatis에서 지정한 쿼리의 이름을 지정)
	private String strSeltagname;			//select 테그의 이름
	private String strFirstData;	//맨위에 빈값 추가시 넣을 String (선택, 전체 등)
	private String strParam;		//쿼리 실행시 넘길 파라메터  (예 : param1=xxx;param2=yyy)
	private String strEtc;		//기타 select 테그에 들어갈 이벤트나 class 지정 등 필요할때 사용
	private String strSelvalue;	//선택 될 값
	private String strFirstval;
	
	//private CommonDao dao;
	
	public String makeComboStr(String sQryName, String sSeltagname, String sFirstData, String sParam, String sEtc, String sSelvalue, String sFirstval) throws Exception
	{
		StringBuffer buf = new StringBuffer();
		HashMap param = new HashMap();
		
		if(sFirstval == null)
			sFirstval = "";
		
		//파라메터 값이 있으면
		if(sParam != null && !sParam.equals(""))
		{
			StringTokenizer token = new StringTokenizer(sParam, ";");
			while(token.hasMoreElements())
			{
				String[] tmp = token.nextToken().split("=");
				if(tmp.length > 1)
					param.put(tmp[0], tmp[1]);
				else if(tmp.length == 1)
					param.put(tmp[0], "");
			}
		}
		
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
		
		System.out.println(dao.getSelectList(sQryName, param));
		Iterator ir = dao.getSelectList(sQryName, param) .iterator();
		
		buf.append("<SELECT name=\"");
		buf.append(sSeltagname);
		buf.append("\"");
		if(sEtc != null && !sEtc.equals(""))
			buf.append(" "+sEtc);
		buf.append(">");
		
		if(sFirstData != null && !sFirstData.equals(""))
			buf.append("<option value=\"" + sFirstval + "\">" + sFirstData + "</option>");						
		while(ir.hasNext())
		{
			HashMap m = (HashMap)ir.next();
			buf.append("<option value=\"");				
			buf.append(m.get("CODE"));
			
			if(sSelvalue != null && !sSelvalue.equals(""))
			{
				if(sSelvalue.equals(m.get("CODE").toString()))
				{
					buf.append("\" selected>");					
				}
				else
				{
					buf.append("\">");
				}
			}
			else
			{
				buf.append("\">");
			}
			buf.append(m.get("VAL"));
			buf.append("</option>");
		}			
		buf.append("</select>");
		
		return buf.toString();
	}
	
	public int doStartTag()
	{
		try{
			//출력
			JspWriter out = pageContext.getOut();
			out.println(makeComboStr(strQryname, strSeltagname, strFirstData, strParam, strEtc, strSelvalue, strFirstval));
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return SKIP_BODY;
	}
	
	//정의한 콤보 이름
	public void setQryname(String cmb_name)
	{
		this.strQryname = cmb_name;
	}
	
	//콤보 테그의 이름 <select name=
	public void setSeltagname(String sel_name)
	{
		this.strSeltagname = sel_name;
	}
	
	//콤보테그 맨위에 넣을 데이터
	public void setFirstdata(String first_data)
	{
		this.strFirstData = first_data;
	}
	
	//쿼리 실행시 넘길 파라메터  (예 : param1=xxx;param2=yyy)
	public void setParam(String param)
	{
		this.strParam = param;
	}
	
	//기타 select 테그에 들어갈 이벤트나 class 지정 등 필요할때 사용
	public void setEtc(String etc)
	{
		this.strEtc = etc;
	}
	
	//선택 될 값
	public void setSelvalue(String sel_val)
	{
		this.strSelvalue = sel_val;
	}
	
	public void setFirstval(String val)
	{
		this.strFirstval = val;
	}
}
