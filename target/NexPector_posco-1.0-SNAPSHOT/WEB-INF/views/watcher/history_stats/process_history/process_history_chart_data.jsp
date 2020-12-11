<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:useBean id="data" class="java.util.ArrayList" scope="request"/>

<chart>
	<chart_type>Line</chart_type>
	
	<axis_category size='12' font="굴림" alpha='85' shadow='none' bold='false' />
	<axis_ticks value_ticks='true' category_ticks='false' major_thickness='2' minor_thickness='1' minor_count='1' minor_color='222222' position='outside' />
	<axis_value shadow='low' min='0' max='10' size='10' color='000000' alpha='50' steps='5' />

	<chart_border top_thickness='1' bottom_thickness='1' left_thickness='1' right_thickness='1' />
	<chart_data>
		<row>
			<null/>
			<c:forEach begin="0" end="23" step="1" varStatus="vt">
				<c:if test="${vt.index < 10}">
					<string>0${vt.index}</string>
				</c:if>
				<c:if test="${vt.index >= 10}">
					<string>${vt.index}</string>
				</c:if>
			</c:forEach>
		</row>
		
			<c:forEach items="${data}" var="m">
		<row>
				<string>${m.S_BASE_NAME}</string>
				<c:forEach begin="0" end="23" step="1" varStatus="vt">
					<c:if test="${vt.index < 10}">
						<c:set var="getNm" value="TIME_0${vt.index}"/>
					</c:if>
					<c:if test="${vt.index >= 10}">
						<c:set var="getNm" value="TIME_${vt.index}"/>
					</c:if>
					<number tooltip='${m.get(getNm)}'>${m.get(getNm)}</number>
				</c:forEach>
		</row>
			</c:forEach>
		
		<c:if test="${data.size() == 0}">
			<row>
				<string></string>
				<c:forEach begin="0" end="23" step="1" varStatus="vt">
						<number>0</number>
				</c:forEach>
			</row>
		</c:if>
		
	</chart_data>
	<chart_grid_h alpha='10' thickness='1' type='solid' />
	<chart_grid_v alpha='10' thickness='1' type='solid' />
	
	<chart_guide horizontal='true' vertical='true' thickness='1' alpha='25' type='dashed' text_h_alpha='0' text_v_alpha='0' />
	
	<!-- 라인 스타일 -->
	<chart_pref line_thickness='2' point_shape='none' fill_shape='false' />
	
	<!-- 차트 위치 및 크기 및 색 등 -->
	<chart_rect x='50' y='170' width='865' height='325' positive_color='FFFFFF' positive_alpha='30' negative_alpha='0' bevel='bg' />
	<draw>
	    <rect x='830' y='0' width='90' height='35' fill_color='EAEAEA' />
	    <text x='840' y='10' font="굴림" size="13">차트 저장</text>
    </draw>
	<chart_note size='10' color='AAAAFF' alpha='90' x='0' y='5' offset_y='5' background_color_1='8888FF' background_alpha='65' shadow='low' />
	<context_menu full_screen='false' />
	
	<legend font="굴림" shadow='low' transition='dissolve' delay='0' duration='0.5' x='50' y='50' width='865' height='5' layout='horizontal' margin='5' bullet='line' size='13' color='000000' alpha='75' fill_color='000000' fill_alpha='10' line_color='000000' line_alpha='0' line_thickness='0' />
	
	<link>
      <area x='830' 
            y='0' 
            width='90'  
            height='35' 
            target='save_as_jpeg'
            />
	</link>
	
	<series_color>
		<color>77bb11</color>
		<color>0000FF</color>
	</series_color>
	<license>ITAR9KF7P2O.H4X5CWK-2XOI1X0-7L</license>
</chart>

