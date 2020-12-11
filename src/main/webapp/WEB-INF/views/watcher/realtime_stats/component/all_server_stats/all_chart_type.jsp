<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.util.HashMap"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="svr_type" class="java.util.ArrayList" scope="request"/>

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
	
	<chart_rect x='-1' y='35' width='70' height='55' />
	
	<chart_type>donut</chart_type>

	<draw>
		<text x='-1' y='31' bold='true' color='111111' size='12'><%=all_cnt%></text>
		<text x='<%=conn_cnt>=10?(conn_cnt>=100?"20":"24"):"28"%>' y='53' bold='true' color='<% if(alm_cnt > 0) {%>D9D9D9<%}else{%>5577DD<%}%>' size='<%=(conn_cnt>=100?"13":"16")%>'><%=conn_cnt%></text>
		<text x='15' y='108' bold='true' color='000000' size='16' font='굴림'>전체</text>
		<% if(alm_cnt > 0) {%><circle x='35' y='62' radius='16' layer='background' fill_color='FF3377' transition='none'></circle><%}%>
	<c:forEach items="${svr_type}" var="m2" varStatus="vt">
<%-- 		<image url='/NexPector_Watcher/include/charts/charts.swf?library_path=/NexPector_Watcher/include/charts/charts_library&xml_source=%2FNexPector_Watcher%2Fcomponent.etc_chart_type.neonex%3FN_GROUP_CODE%3D${param.N_GROUP_CODE}%26N_TYPE_CODE=${m2.CODE}%26S_TYPE_NAME=${m2.VAL}%26NUM=${vt.index}' /> --%>
		<image url='<c:url value="/common/charts/charts.swf"/>?library_path=<c:url value="/common/charts/charts_library"/>&xml_source=<c:url value="/watcher/go_realtime_stats.component.all_server_stats.etc_chart_type.htm"/>?N_GROUP_CODE%3D${param.N_GROUP_CODE}%26N_TYPE_CODE=${m2.CODE}%26S_TYPE_NAME=${m2.VAL}%26NUM=${vt.index}%26req_data=data;serverStatusQry|svr_style;compo_svr_style|svr_type;compo_svr_type' />
	</c:forEach>
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
	
	<update url='<c:url value="/watcher/go_realtime_stats.component.all_server_stats.all_chart_type.htm"/>?N_GROUP_CODE=${param.N_GROUP_CODE}&req_data=data;serverStatusQry|svr_style;compo_svr_style|svr_type;compo_svr_type' delay='15' />
	
	<license>ITAR9KF7P2O.H4X5CWK-2XOI1X0-7L</license>
</chart>

 


