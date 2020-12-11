<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>
<title>장애현황</title>
<script>
	var pMonId = '${param.N_MON_ID}';

	$(function() {
		initialize();
	});

	function initialize() {
		// 장애현황 그리드 초기화
		var columns = kendoGridColumns();

		$("#recChannelGrid")
				.kendoGrid($.extend({}, kendoGridDefaultOpt, {
					dataSource	: [],
					columns		: columns.recChannelInfo()
				}));

		fn_stats_retrieve();
	}

	function fn_stats_retrieve() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_DetailRecChannel.htm",
					data 		: function(data) {
						return { 'N_MON_ID' : pMonId };
					}
				},
				parameterMap: function (data, opperation) {
					return JSON.stringify(data);
				}
			},
			schema			: {
				data	: function(data) {
					return data;
				},
				total 	: function(response) {
					return response.length > 0 ? response[0].TOTAL_COUNT : 0;
				}
			},
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		$("#recChannelGrid").data('kendoGrid').setDataSource(dataSource);
		setInterval(function() {
			dataSource.read();
		}, 10000);
	}

	function fn_status_icon(icon, channelNumberName) {
		if (icon == 1) {
			return '<img src="' + cst.contextPath() + '/images/common/icon_o_gray.png" alt="gray" style="vertical-align:middle; margin-right:4px;">' + channelNumberName;
		} else if(icon == 0 || icon == 4) {
			return '<img src="' + cst.contextPath() + '/images/common/icon_o_red.png" alt="red" style="vertical-align:middle; margin-right:4px;">' + channelNumberName;
		} else {
			return '<img src="' + cst.contextPath() + '/images/common/icon_o_green.png" alt="green" style="vertical-align:middle; margin-right:4px;">' + channelNumberName;
		}
	}
</script>

<!-- stitle -->
<div id="contentsWrap" class="table_typ2-3">
	<div class="avaya_stitle1" style="float: none;">
		<div class="st_under"><h4>장애 현황</h4></div>
	</div>
	<!-- stitle // -->
	<!-- 장애현황 그리드 -->
	<div id="recChannelGrid"></div>
	<!-- 장애현황 그리드 // -->
</div>