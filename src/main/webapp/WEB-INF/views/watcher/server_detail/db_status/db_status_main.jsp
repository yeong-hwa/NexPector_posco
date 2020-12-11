<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>

<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.blockUI.js"/>"></script>
<title>DB 현황</title>
<script>
	var pMonId = '${param.N_MON_ID}';
	var columns = kendoGridColumns();
	
	$(function() {
		// DB현황 그리드 초기화
		$("#dbStatusGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: fn_db_status_retrieve(),
				dataBound	: gridDataBound,
				resizable	: true,
				columns		: columns.dbStatusInfo(),
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				change		: function(e) {
					e.preventDefault ? e.preventDefault() : e.returnValue = false;
					$("#dbStatusGrid").data('kendoGrid').setDataSource(fn_db_status_retrieve());
				}
			}));
		
		window.setInterval(fn_reloadDataSource, 6000);
	});

	function fn_reloadDataSource() {
		$('#dbStatusGrid').data('kendoGrid').dataSource.read();
	}
	
	// DB현황
	function fn_db_status_retrieve() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_DbStatusRetrieveQry.htm",
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

		return dataSource;
	}
	
</script>

<!-- stitle -->
<div id="contentsWrap" class="table_typ2-3">
	<div class="avaya_stitle1" style="float: none;">
		<div class="st_under">
			<h4>DB 현황</h4>
		</div>
	</div>
	<!-- stitle // -->
	<!-- DB현황 그리드 -->
	<div id="dbStatusGrid"></div>
	<!-- DB현황 그리드 // -->

</div>