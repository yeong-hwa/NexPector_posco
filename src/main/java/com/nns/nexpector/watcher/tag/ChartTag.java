package com.nns.nexpector.watcher.tag;

import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;


public class ChartTag extends TagSupport {
	private String width;		//쿼리 이름 (mybatis에서 지정한 쿼리의 이름을 지정)
	private String height;			//select 테그의 이름
	private String bgcolor;	//맨위에 빈값 추가시 넣을 String (선택, 전체 등)
	private String xmlpath;		//쿼리 실행시 넘길 파라메터  (예 : param1=xxx;param2=yyy)
	
	private String contextpath;
	
	public int doStartTag()
	{
		try{
			contextpath = pageContext.getSession().getServletContext().getContextPath();
			StringBuffer buf = new StringBuffer();
			
			/*buf.append("<script>																																																									 "); 	
			buf.append("if (AC_FL_RunContent == 0 || DetectFlashVer == 0) {                                                                        ");
			buf.append("	alert(\"This page requires AC_RunActiveContent.js.\");                                                                     ");
			buf.append("} else {                                                                                                                   ");
			buf.append("	var hasRightVersion = DetectFlashVer(requiredMajorVersion, requiredMinorVersion, requiredRevision);                      ");
			buf.append("	if(hasRightVersion) {                                                                                                    ");
			buf.append("		AC_FL_RunContent(                                                                                                      ");
			buf.append("			'codebase', '" + contextpath + "/include/cab/swflash.cab#version=10,0,45,2',                                                      ");
			buf.append("			'width', '"+width+"',                                                                                                      ");
			buf.append("			'height', '"+height+"',                                                                                                     ");
			buf.append("			'scale', 'noscale',                                                                                                  ");
			buf.append("			'salign', 'TL',                                                                                                      ");
			buf.append("			'bgcolor', '"+bgcolor+"',                                                                                                ");
			buf.append("			'wmode', 'transparent',                                                                                                   ");
			buf.append("			'movie', '" + contextpath + "/include/charts/charts',                                                                                                   ");
			buf.append("			'src', '" + contextpath + "/include/charts/charts',                                                                                                     ");
			buf.append("			'FlashVars', 'chart_id=my_chart&library_path=" + contextpath + "/include/charts/charts_library&xml_source=" + contextpath + xmlpath +"',"); 
			buf.append("			'id', 'my_chart',                                                                                                   ");
			buf.append("			'name', 'my_chart',                                                                                                 ");
			buf.append("			'menu', 'true',                                                                                                      ");
			buf.append("			'allowFullScreen', 'true',                                                                                           ");
			buf.append("			'allowScriptAccess','sameDomain',                                                                                    ");
			buf.append("			'quality', 'high',                                                                                                   ");
			buf.append("			'align', 'middle',                                                                                                   ");
			buf.append("			'pluginspage', 'http://www.macromedia.com/go/getflashplayer',                                                        ");
			buf.append("			'play', 'true',                                                                                                      ");
			buf.append("			'devicefont', 'false'                                                                                                ");
			buf.append("			);                                                                                                                   ");
			buf.append("	} else {                                                                                                                 ");
			buf.append("		var alternateContent = 'This content requires the Adobe Flash Player. '                                                ");
			buf.append("		+ '<u><a href=http://www.macromedia.com/go/getflash/>Get Flash</a></u>.';                                              ");
			buf.append("		document.write(alternateContent);                                                                                      ");
			buf.append("	}                                                                                                                        ");
			buf.append("}                                                                                                                          ");
			buf.append("</script>                                                                                                                  ");
			*/
			
			if(pageContext.getSession().getAttribute("BROWSER_TYPE").equals("msie"))
			{
				buf.append("<OBJECT id=my_chart name=my_chart codeBase=\""+contextpath+"/common/cab/swflash.cab#version=10,0,45,2\" classid=clsid:d27cdb6e-ae6d-11cf-96b8-444553540000 width="+width+" align=middle height="+height+">													");
				buf.append("	<PARAM NAME=\"_cx\" VALUE=\"24606\">                                                                                                                                                                                    ");
				buf.append("	<PARAM NAME=\"_cy\" VALUE=\"13626\">                                                                                                                                                                                    ");
				buf.append("	<PARAM NAME=\"FlashVars\" VALUE=\"chart_id=my_chart&amp;library_path="+contextpath+"/common/charts/charts_library&amp;xml_source=" + contextpath + xmlpath +"\">");
				buf.append("	<PARAM NAME=\"Movie\" VALUE=\""+contextpath+"/common/charts/charts.swf\">                                                                                                                                           ");
				buf.append("	<PARAM NAME=\"Src\" VALUE=\""+contextpath+"/common/charts/charts.swf\">                                                                                                                                             ");
				buf.append("	<PARAM NAME=\"WMode\" VALUE=\"Transparent\"><PARAM NAME=\"Play\" VALUE=\"-1\">                                                                                                                                          ");
				buf.append("	<PARAM NAME=\"Loop\" VALUE=\"-1\"><PARAM NAME=\"Quality\" VALUE=\"High\">                                                                                                                                               ");
				buf.append("	<PARAM NAME=\"SAlign\" VALUE=\"LT\"><PARAM NAME=\"Menu\" VALUE=\"-1\">                                                                                                                                                  ");
				buf.append("	<PARAM NAME=\"Base\" VALUE=\"\"><PARAM NAME=\"AllowScriptAccess\" VALUE=\"sameDomain\">                                                                                                                                 ");
				buf.append("	<PARAM NAME=\"Scale\" VALUE=\"NoScale\"><PARAM NAME=\"DeviceFont\" VALUE=\"0\">                                                                                                                                         ");
				buf.append("	<PARAM NAME=\"EmbedMovie\" VALUE=\"0\"><PARAM NAME=\"BGColor\" VALUE=\""+bgcolor+"\">                                                                                                                                        ");
				buf.append("	<PARAM NAME=\"SWRemote\" VALUE=\"\"><PARAM NAME=\"MovieData\" VALUE=\"\">                                                                                                                                               ");
				buf.append("	<PARAM NAME=\"SeamlessTabbing\" VALUE=\"1\"><PARAM NAME=\"Profile\" VALUE=\"0\">                                                                                                                                        ");
				buf.append("	<PARAM NAME=\"ProfileAddress\" VALUE=\"\"><PARAM NAME=\"ProfilePort\" VALUE=\"0\">                                                                                                                                      ");
				buf.append("	<PARAM NAME=\"AllowNetworking\" VALUE=\"all\"><PARAM NAME=\"AllowFullScreen\" VALUE=\"true\">                                                                                                                           ");
				buf.append("	<PARAM NAME=\"AllowFullScreenInteractive\" VALUE=\"\"><PARAM NAME=\"IsDependent\" VALUE=\"0\">                                                                                                                          ");
				buf.append("</OBJECT>                                                                                                                                                                                                                 ");
			}
			else
			{
				buf.append("<embed width=\""+width+"\" height=\""+height+"\" 																																							");
				buf.append("scale=\"noscale\"                                                                                                 ");
				buf.append("salign=\"TL\"                                                                                                     ");
				buf.append("bgcolor=\""+bgcolor+"\"                                                                                               ");
				buf.append("wmode=\"transparent\" src=\"" + contextpath + "/common/charts/charts.swf\"                                        ");
				buf.append("flashvars=\"chart_id=my_chart&amp;library_path="+contextpath+"/common/charts/charts_library&amp;xml_source=" + contextpath + xmlpath+"\" ");
				buf.append("name=\"my_chart\"                                                                                                 ");
				buf.append("menu=\"true\"                                                                                                     ");
				buf.append("allowfullscreen=\"true\"                                                                                          ");
				buf.append("allowscriptaccess=\"sameDomain\"                                                                                  ");
				buf.append("quality=\"high\" align=\"middle\"                                                                                 ");
				buf.append("pluginspage=\"http://www.macromedia.com/go/getflashplayer\"                                                       ");
				buf.append("play=\"true\"                                                                                                     ");
				buf.append("devicefont=\"false\"                                                                                              ");
				buf.append("type=\"application/x-shockwave-flash\">                                                                           ");
			}
		System.out.println(buf.toString());
			//출력
			JspWriter out = pageContext.getOut();
			out.print(buf.toString());
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return SKIP_BODY;
	}
	
	
	public String getWidth() {
		return width;
	}


	public void setWidth(String width) {
		this.width = width;
	}


	public String getHeight() {
		return height;
	}


	public void setHeight(String height) {
		this.height = height;
	}


	public String getBgcolor() {
		return bgcolor;
	}


	public void setBgcolor(String bgcolor) {
		this.bgcolor = bgcolor;
	}


	public String getXmlpath() {
		return xmlpath;
	}


	public void setXmlpath(String xmlpath) {
		this.xmlpath = xmlpath;
	}
}
