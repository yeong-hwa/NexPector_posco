<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>

<chart>
	<axis_category shadow='' size='12' color='000000' alpha='85' font="굴림"/>
	<axis_ticks value_ticks='true' category_ticks='true' major_thickness='0' minor_thickness='0' minor_count='1' major_color='222222' minor_color='222222' position='centered' />
	<axis_value shadow='' size='' color='' alpha='' steps='10' prefix='' suffix='' decimals='0' separator='' show_min='' max='110' />

	<chart_border color='000000' top_thickness='0' bottom_thickness='0' left_thickness='1' right_thickness='0' />
	<chart_label position='right' size='12' color='FFC8C8' alpha='100' />
	<chart_data>
		<row>
			<null/>
			<c:forEach items="${data}" var="m">
				<string>${m.S_MON_NAME}</string>
			</c:forEach>
			${data.size()==0?"<string></string>":""}
		</row>
		<row>
			<string>region A</string>
			<c:forEach items="${data}" var="m">
				<number shadow='low'>${m.CNT}</number>
			</c:forEach>
			${data.size()==0?"<number></number>":""}
		</row>
	</chart_data>
	
	<!-- 차트 안의 그리드 선 -->
	<chart_grid_h alpha='20' color='000000' thickness='0' type='dashed' />
	<chart_grid_v alpha='15' color='000000' thickness='1' type='' />
	
	<!-- 차트 영역 -->
	<chart_rect bevel='bg' x='100' y='0' width='205' height='150' positive_alpha='0' negative_alpha='20' corner_tl='0' corner_br='0' corner_bl='0' />
	<!-- 애니메이션? -->
	<!--<chart_transition type='scale' delay='1' duration='1' order='series' />-->
	<chart_type>bar</chart_type>

	<filter>
		<bevel id='bg' angle='45' blurX='50' blurY='50' distance='10' highlightAlpha='25' shadowAlpha='15' type='inner' /> 
		<shadow id='high' distance='5' angle='45' alpha='35' blurX='15' blurY='15' />
		<shadow id='high2' knockout='true' distance='5' angle='45' alpha='35' blurX='15' blurY='15' />
		<shadow id='low' distance='2' angle='45' alpha='50' blurX='5' blurY='5' />
	</filter>

	<legend layout='hide' />

	<series_color>
		<color>03646B</color>
		<color>DB752A</color>
		<color>E69965</color>
		<color>69C0AD</color>
		<color>E4A9E3</color>
	</series_color>
	<series set_gap='70' bar_gap='50' transfer='true' />
	<update url='<c:url value="/watcher/go_realtime_stats.component.lately_server_error.lately_week_server_error_chart.htm"/>?N_GROUP_CODE=${param.N_GROUP_CODE}&req_data=data;latelyWeekServerErrorQry' delay='15' />
	<license>ITAR9KF7P2O.H4X5CWK-2XOI1X0-7L</license>
</chart>



 


