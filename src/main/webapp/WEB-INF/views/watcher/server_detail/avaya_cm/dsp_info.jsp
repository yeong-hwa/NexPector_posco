<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		var columns = kendoGridColumns();

		$("#m03DspInfoGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: getGridDataSource(),
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				dataBound	: function () {
					var grid = $('#m03DspInfoGrid').data('kendoGrid');
					$(grid.thead.find('th')).each(function () {
						$(this).prop('title', $(this).data('title'));
					});
				},
				scrollable	: false,
				columns		: columns.m03DspInfo()
			}));
	});

	function fn_retrieve(event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
		$("#m03DspInfoGrid").data('kendoGrid').setDataSource(getGridDataSource());
	}

	function getGridDataSource() {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M03DspInfoLstQry.htm",
					data 		: function(data) {
						return {
							'N_MON_ID' 		 : pMonId
						};
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
	}
</script>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>DSP 정보</h4></div>
</div>
<!-- stitle // -->

<!-- table_typ2-3 -->
<div id="m03DspInfoGrid" class="table_typ2-3"></div>
<!-- table_typ2-3 // -->