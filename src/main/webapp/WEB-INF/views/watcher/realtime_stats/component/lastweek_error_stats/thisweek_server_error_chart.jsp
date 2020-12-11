<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>
<%
System.out.println("어딨어!! - " + data);
%>
<chart>
	<axis_category font="굴림" shadow='low' />
	<axis_value shadow='low' min='0' size='10' alpha='50' steps='5' />
	
	<chart_border color='000000' top_thickness='1' bottom_thickness='2' left_thickness='0' right_thickness='0' />
	<chart_data>
		<row>
			<null/>
			<c:forEach items="${data}" var="m">
				<string>${m.WEEK}</string>
			</c:forEach>
		</row>
		<row>
			<string>Minor</string>
			<c:forEach items="${data}" var="m">
				<number bevel='gray' shadow='low'>${m.MINOR}</number>
			</c:forEach>
		</row>
		<row>
			<string>Major</string>
			<c:forEach items="${data}" var="m">
				<number bevel='blue' shadow='high'>${m.MAJOR}</number>
			</c:forEach>
		</row>
		<row>
			<string>Critical</string>
			<c:forEach items="${data}" var="m">
				<number bevel='blue' shadow='high'>${m.CRITICAL}</number>
			</c:forEach>
		</row>
	</chart_data>
	<chart_grid_h alpha='10' thickness='1' type='dashed' />
	
	<chart_label color='ddffff' alpha='90' size='10' position='middle' />	
	<chart_rect bevel='bg' shadow='' x='25' y='20' width='285' height='120' positive_color='eeeeff' negative_color='dddddd' positive_alpha='100' negative_alpha='100'  corner_tl='0' corner_tr='0' corner_br='0' corner_bl='0' />
	<!--<chart_transition type='scale' delay='.5' duration='1' order='series' />-->
	
	<filter>
		<shadow id='high' distance='5' angle='45' alpha='35' blurX='10' blurY='10' />
		<shadow id='low' distance='2' angle='45' alpha='35' blurX='5' blurY='5' />
		
		<bevel id='blue' angle='-80' blurX='0' blurY='30' distance='20' highlightColor='ffffff' highlightAlpha='50' shadowColor='000088' shadowAlpha='25' inner='true' />
		<bevel id='gray' angle='-80' blurX='0' blurY='30' distance='20' highlightColor='ffffff' highlightAlpha='25' shadowColor='000000' shadowAlpha='20' inner='true' />
	</filter>
	
	<legend shadow='low' x='25' y='0' width='285' height='20' margin='5' fill_color='000066' fill_alpha='8' line_alpha='0' line_thickness='0' size='12' color='333355' alpha='90' />

	<series_color>
		<color>666666</color>
		<color>768bb3</color>
	</series_color>
	<series set_gap='20' bar_gap='-25' />
	
	<update url='<c:url value="/watcher/go_realtime_stats.component.lastweek_error_stats.thisweek_server_error_chart.htm"/>?N_GROUP_CODE=${param.N_GROUP_CODE}&req_data=data;thisweekServerErrorQry' delay='15' />
	<license>ITAR9KF7P2O.H4X5CWK-2XOI1X0-7L</license>
</chart>




 


