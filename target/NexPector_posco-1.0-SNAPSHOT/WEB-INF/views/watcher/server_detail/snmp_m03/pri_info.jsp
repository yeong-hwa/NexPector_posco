<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';
	
	var timer;

	$(function() {
		var columns = kendoGridColumns();

		$("#m03PriInfoGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: getGridDataSource(),
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				dataBound	: function () {
					var grid = $('#m03PriInfoGrid').data('kendoGrid');
					$(grid.thead.find('th')).each(function () {
						$(this).prop('title', $(this).data('title'));
					});
				},
				scrollable	: true,
				columns		: [
				    {field:'S_DESC', title:'설명', width:'150px', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_TOTAL', title:'전체', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_E1_CNT_IDLE', title:'대기', width:'50px', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_E1_CNT_ACTIVE', title:'통화중', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_ADMIN_STATUS', title:'ADMIN 상태', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_ADMIN_STATUS, S_ADMIN_STATUS, null, null) #'},
				    {field:'S_OPER_STATUS', title:'운영 상태', width:'100px', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(null, null, N_OPER_STATUS, S_OPER_STATUS) #'},
				    {field:'N_SPEED', title:'속도', width:'80px', attributes:_txtCenter, headerAttributes:_txtCenter}
				    ]
			}));
		
		timer = setTimeout("refreshGrid()", 3000);
	});

	function fn_retrieve(event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
		$("#m03PriInfoGrid").data('kendoGrid').setDataSource(getGridDataSource());
	}
	
	function refreshGrid() {
		clearTimeout(timer);
    	
		$("#m03PriInfoGrid").data('kendoGrid').setDataSource(getGridDataSource());
		
		timer = setTimeout("refreshGrid()", 3000);
	}

	function getGridDataSource() {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M03IfInfoPRILstQry.htm",
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

	function fn_change_text_color(n_admin_status, s_admin_status, n_oper_status, s_oper_status) {
		if (n_admin_status != null) {
			if (parseInt(n_admin_status) === 1) {
				return '<b style="color: #0000ff">' + s_admin_status + '</b>';
			}
			else {
				return '<b style="color: #FF0000">' + s_admin_status + '</b>';
			}
		}
		else if (n_oper_status != null) {
			if (parseInt(n_oper_status) === 1) {
				return '<b style="color: #0000ff">' + s_oper_status + '</b>';
			}
			else {
				return '<b style="color: #FF0000">' + s_oper_status + '</b>';
			}
		}
	}
</script>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>PRI Interface 정보</h4></div>
</div>
<!-- stitle // -->

<!-- table_typ2-3 -->
<div id="m03PriInfoGrid" class="table_typ2-3"></div>
<!-- table_typ2-3 // -->