<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.util.HashMap"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="img" value='<%=request.getContextPath()+"/image"%>'/>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="svr_style" class="java.util.ArrayList" scope="request"/>

<%
	int all_cnt = 0;
	int conn_cnt = 0;
	int disconn_cnt = 0;

	int alm_cnt = 0;
	
	for(int i=0;i<data.size();i++)
	{
		if(((HashMap)data.get(i)).get("CONN_INFO").equals("CONN"))
		{
			conn_cnt += Integer.parseInt(((HashMap)data.get(i)).get("CNT").toString());
		}
		else
		{
			disconn_cnt += Integer.parseInt(((HashMap)data.get(i)).get("CNT").toString());
		}
		alm_cnt += Integer.parseInt(((HashMap)data.get(i)).get("ALM_CNT").toString());
	}
	
	all_cnt = conn_cnt + disconn_cnt;
	
	int tmp_pos = 78 + (78 * Integer.parseInt((request.getParameter("NUM")==null||request.getParameter("NUM").equals(""))?"0":request.getParameter("NUM")));
%>

<chart>

	<chart_data>
		<row>
			<null/>
			<string></string>
			<string></string>
		</row>
		<row>
			<null/>
			<number shadow='high' line_color='FFFFFF' line_thickness='0'><%=conn_cnt%></number>
			<number shadow='high' line_color='FFFFFF' line_thickness='0'><%=(disconn_cnt==0&&conn_cnt==0)?1:disconn_cnt%></number>
		</row>		
	</chart_data>
	
	<chart_rect x='<%=tmp_pos%>' y='35' width='70' height='55' />
	
	<chart_type>donut</chart_type>
	
	<draw>
		<text x='<%=tmp_pos-2%>' y='31' bold='true' color='111111' size='12'><%=all_cnt%></text>
		<%
			int pos = 0;		
			if(conn_cnt >= 10)
			{
				if(conn_cnt >= 100)
				{
					pos = tmp_pos + 22;
				}
				else
				{
					pos = tmp_pos + 25;
				}
			}
			else
			{
				pos = tmp_pos + 29;
			}
			String S_STYLE_NAME = "";
			
			for(int i=0;i<svr_style.size();i++)
			{
				if(((HashMap)svr_style.get(i)).get("CODE").toString().equals(request.getParameter("N_STYLE_CODE")))
				{
					S_STYLE_NAME = ((HashMap)svr_style.get(i)).get("VAL").toString();
				}
			}
		%>
		
		<text x='<%=pos%>' y='53' bold='true' color='<% if(alm_cnt > 0) {%>D9D9D9<%}else{%>5577DD<%}%>' size='<%=(conn_cnt>=100?"13":"16")%>'><%=conn_cnt%></text>
		
		<text x='<%=pos-14%>' y='108' bold='true' color='000000' size='16' font='굴림'><%=S_STYLE_NAME%></text>
		
		<% if(alm_cnt > 0) {%><circle x='<%=pos+8%>' y='62' radius='16' layer='background' fill_color='FF3377' transition='none'></circle><%}%>
	</draw>
	<filter>
		<shadow id='low' distance='2' angle='45' color='0' alpha='40' blurX='5' blurY='5' />
		<shadow id='high' distance='5' angle='45' color='0' alpha='40' blurX='10' blurY='10' />
		<shadow id='soft' distance='2' angle='45' color='0' alpha='20' blurX='5' blurY='5' />
		<bevel id='data' angle='45' blurX='5' blurY='5' distance='3' highlightAlpha='15' shadowAlpha='25' type='inner' />
		<bevel id='bg' angle='45' blurX='50' blurY='50' distance='10' highlightAlpha='35' shadowColor='0000ff' shadowAlpha='25' type='full' />
		<blur id='blur1' blurX='75' blurY='75' quality='1' />
	</filter>
	
	<context_menu full_screen='false' />
	<legend transition='dissolve' x='90' width='50' bevel='low' fill_alpha='0' line_alpha='0' bullet='circle' size='12' color='ffffff' alpha='100' />
	<!--<chart_transition type='spin' delay='1' duration='1' order='series' />-->
	<series_color>
		<color>5577DD</color>
		<color>E4E4E4</color>
	</series_color>
	
	<series transfer='true' />
	<license>ITAR9KF7P2O.H4X5CWK-2XOI1X0-7L</license>
</chart>

 


