<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="img" value='<%=request.getContextPath()+"/image"%>'/>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<jsp:useBean id="lst" class="java.util.ArrayList" scope="request"/>

<chart>
	<chart_type>Line</chart_type>
	
	<axis_category alpha='0' />
	<axis_ticks value_ticks='true' category_ticks='false' major_thickness='2' minor_thickness='1' minor_count='1' minor_color='222222' position='outside' />
	<axis_value shadow='low' min='0' max='15' size='10' color='000000' alpha='50' steps='5' />

	<chart_border top_thickness='1' bottom_thickness='1' left_thickness='1' right_thickness='1' />
	<chart_data>
		<row>
			<null/>
			<string></string>
			<string></string>
			<string></string>
			<string></string>
			<string></string>
			<string></string>
			<string></string>
			<string></string>
			<string></string>
			<string></string>
		</row>
		<row>
			<string>Region A</string>
			<c:forEach begin="1" end="10" step="1" varStatus="vt">
				<c:if test="${10-lst.size()>=vt.count}"><number>0</number></c:if>
				<c:if test="${10-lst.size()<vt.count}"><number tooltip='${lst.get(vt.count+lst.size()-1-10)}'>${lst.get(vt.count+lst.size()-1-10)}</number></c:if>
			</c:forEach>
		</row>
	</chart_data>
	<chart_grid_h alpha='10' thickness='1' type='solid' />
	<chart_grid_v alpha='10' thickness='1' type='solid' />
	
	<chart_guide horizontal='true' vertical='true' thickness='1' alpha='25' type='dashed' text_h_alpha='0' text_v_alpha='0' />
	
	<!-- 라인 스타일 -->
	<chart_pref line_thickness='2' point_shape='none' fill_shape='false' />
	
	<!-- 차트 위치 및 크기 및 색 등 -->
	<chart_rect x='30' y='3' width='124' height='50' positive_color='FFFFFF' positive_alpha='30' negative_alpha='0' bevel='bg' />
	<draw>
                    
    </draw>
	<chart_note size='10' color='AAAAFF' alpha='90' x='0' y='5' offset_y='5' background_color_1='8888FF' background_alpha='65' shadow='low' />
	<context_menu full_screen='false' />
	<legend layout='hide' />
		
	<series_color>
		<color>77bb11</color>
		<color>0000FF</color>
	</series_color>
	
	<update url='${contextPath}/server_detail.realtime_process.neonex?N_MON_ID=${param.N_MON_ID}&S_MAP_KEY=${param.S_MAP_KEY}' delay='${ConfigurationSetting.getParam("chart_refresh_sec")}' />
	<license>ITAR9KF7P2O.H4X5CWK-2XOI1X0-7L</license> 
</chart>

