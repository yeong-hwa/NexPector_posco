<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		var columns = kendoGridColumns();

		$("#vaInterfaceInfoGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: getGridDataSource(),
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				dataBound	: function () {
					var grid = $('#vaInterfaceInfoGrid').data('kendoGrid');
					$(grid.thead.find('th')).each(function () {
						$(this).prop('title', $(this).data('title'));
					});
				},
				scrollable	: true,
				columns		: columns.vaInterfaceInfo()
			}));
	});

	function fn_retrieve(event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
		$("#vaInterfaceInfoGrid").data('kendoGrid').setDataSource(getGridDataSource());
	}

	function getGridDataSource() {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M03VaifInfoLstQry.htm",
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

	function fn_change_text_color(n_admin_status, s_admin_status) {
		if (parseInt(n_admin_status) === 1) {
			return '<b style="color: #0000ff">' + s_admin_status + '</b>';
		}
		else {
			return '<b style="color: #FF0000">' + s_admin_status + '</b>';
		}
	}
</script>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>Interface 정보</h4></div>
</div>
<!-- stitle // -->

<!-- table_typ2-3 -->
<div id="vaInterfaceInfoGrid" class="table_typ2-3"></div>
<!-- table_typ2-3 // -->