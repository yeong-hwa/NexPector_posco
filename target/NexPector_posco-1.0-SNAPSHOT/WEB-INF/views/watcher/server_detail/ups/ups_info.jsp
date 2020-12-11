<%--
    Description : CIMS Avaya CM 장비 UPS 정보 페이지
    Date : 2015/07/16
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>UPS 정보</h4></div>
</div>
<!-- Sub Title E -->

<!-- Grid S -->
<div id="ups_info_grid" class="table_typ2-2">
</div>
<!-- Grid E -->

<!-- Sub Title S -->
<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>배터리 정보</h4></div>
</div>
<!-- Sub Title E -->

<!-- Grid S -->
<div id="battery_info_grid" class="table_typ2-2">
</div>
<!-- Grid E -->

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(document).ready(function() {
		var upsColumn = [
			{field:'S_MANUFACTURER', title:'제조사', width:'20%', attributes:_txtCenter, headerAttributes:_txtCenter},
			{field:'S_MODEL', title:'모델명', width:'16%', attributes:_txtCenter, headerAttributes:_txtCenter},
			{field:'S_SOFTWARE_VER', title:'소프트웨어 버전', width:'16%', attributes:_txtCenter, headerAttributes:_txtCenter},
			{field:'S_ATT_DEVICES', title:'Output 연결 장비수', width:'16%', attributes:_txtCenter, headerAttributes:_txtCenter},
			{field:'S_SERIAL_NUM', title:'시러얼넘버', width:'16%', attributes:_txtCenter, headerAttributes:_txtCenter},
			{field:'S_COM_PROT_VER', title:'Protocol Version', width:'16%', attributes:_txtCenter, headerAttributes:_txtCenter}
		];

		var batteryColumn = [
			{field:'S_BATTERY_STATUS', title:'배터리 상태', width:'30%', attributes:_txtCenter, headerAttributes:_txtCenter},
			{field:'N_SEC_ON_BATTERY', title:'배터리 사용시간(초)', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
			{field:'N_MINUTES_REMAINING', title:'남은 사용시간(분)', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
			{field:'N_CHARGE_REMAINING', title:'충전율(%)', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
			{field:'N_BATTERY_VOLTAGE', title:'배터리 전압', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
			{field:'N_BATTERY_CURRENT', title:'배터리 전류', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter}
		];

		createGrid($('#ups_info_grid'), getDataSource(cst.contextPath() + '/watcher/lst_getUpsInfo.htm'), upsColumn);
		createGrid($('#battery_info_grid'), getDataSource(cst.contextPath() + '/watcher/lst_getBatteryInfo.htm'), batteryColumn);
	});

	function getDataSource(url) {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					url 		: url,
					data 		: function(data) {
						return { 'N_MON_ID' : pMonId };
					}
				}
			},
			schema			: {
				data	: function(data) {
					return $.isArray(data) ? data : [];
				}
			}
		});
	}

	function createGrid(selector, dataSource, columns) {
		$(selector).kendoGrid($.extend({}, kendoGridDefaultOpt, {
			dataSource	: dataSource,
			dataBound	: gridDataBound,
			autoBind    : true,
//            scrollable  : true,
			pageable	: false,
//            height      : 400,
			columns		: columns
		}));
	}
</script>
