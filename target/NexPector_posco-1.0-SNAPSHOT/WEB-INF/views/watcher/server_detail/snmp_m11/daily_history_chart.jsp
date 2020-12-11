<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="img" value='<%=request.getContextPath()+"/image"%>'/>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<jsp:useBean id="lst" class="java.util.HashMap" scope="request"/>

<chart>
	<chart_type>Line</chart_type>
	
	<axis_category size='12' alpha='85' shadow='none' bold='false' />
	<axis_ticks value_ticks='true' category_ticks='false' major_thickness='2' minor_thickness='1' minor_count='1' minor_color='222222' position='outside' />
	<axis_value shadow='low' min='0' max='15' size='10' color='000000' alpha='50' steps='5' />

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
		<row>
			<string>Region A</string>
			<c:if test="${lst.size() > 0}">
				<c:forEach begin="0" end="23" step="1" varStatus="vt">
					<c:if test="${vt.index < 10}">
						<c:set var="tmp" value="TIME_0${vt.index}"></c:set>
					</c:if>
					<c:if test="${vt.index >= 10}">
						<c:set var="tmp" value="TIME_${vt.index}"></c:set>
					</c:if>
					<c:if test="${lst.get(tmp) == null}">
						<null/>
					</c:if>
					<c:if test="${lst.get(tmp) != null}">
						<number tooltip='${lst.get(tmp)}'>${lst.get(tmp)}</number>
					</c:if>
				</c:forEach>
			</c:if>
			<c:if test="${lst.size() == 0}">
				<c:forEach begin="0" end="23" step="1" varStatus="vt">
					<c:if test="${vt.index == 0}">
						<number>0</number>
					</c:if>
					<c:if test="${vt.index != 0}">
						<null/>
					</c:if>
				</c:forEach>
			</c:if>
		</row>
	</chart_data>
	<chart_grid_h alpha='10' thickness='1' type='solid' />
	<chart_grid_v alpha='10' thickness='1' type='solid' />
	
	<chart_guide horizontal='true' vertical='true' thickness='1' alpha='25' type='dashed' text_h_alpha='0' text_v_alpha='0' />
	
	<!-- 라인 스타일 -->
	<chart_pref line_thickness='2' point_shape='none' fill_shape='false' />
	
	<!-- 차트 위치 및 크기 및 색 등 -->
	<chart_rect x='65' y='3' width='${700+param.ADD_WIDTH}' height='${50+param.ADD_HEIGHT}' positive_color='FFFFFF' positive_alpha='30' negative_alpha='0' bevel='bg' />
	<draw>
                    
    </draw>
	<chart_note size='10' color='AAAAFF' alpha='90' x='0' y='5' offset_y='5' background_color_1='8888FF' background_alpha='65' shadow='low' />
	<context_menu full_screen='false' />
	<legend layout='hide' />
	
	<link>
      <area x='0' y='0' width='${585+param.ADD_WIDTH}' height='${50+param.ADD_HEIGHT}' url="javascript:fn_chart_blowup()" />
	</link>
	
	
	<series_color>
		<color>77bb11</color>
		<color>0000FF</color>
	</series_color>
	<license>ITAR9KF7P2O.H4X5CWK-2XOI1X0-7L</license>
</chart>

