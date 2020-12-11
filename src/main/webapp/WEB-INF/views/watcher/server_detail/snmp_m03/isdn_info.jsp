<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		var columns = kendoGridColumns();

		$("#m03IsdnInfoGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: getGridDataSource(),
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				dataBound	: function () {
					var grid = $('#m03IsdnInfoGrid').data('kendoGrid');
					$(grid.thead.find('th')).each(function () {
						$(this).prop('title', $(this).data('title'));
					});
				},
				scrollable	: true,
				columns		: [
					{field:'N_PHYS_IF', title:'물리IF', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_ID', title:'ID', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_LOG_IF', title:'논리IF', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_NAME', title:'NAME', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_ADDR', title:'ADDR', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_PERMISSION', title:'PERMISSION', width:'15%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_MAX_DURATION', title:'MAX_DURATION', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_LAST_DURATION', title:'LAST_DURATION', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_CLEAR_REASON', title:'CLEAR_REASON', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_CLEAR_CODE', title:'CLEAR_CODE', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_SUC_CALLS', title:'성공 콜', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_FAIL_CALL', title:'실패 콜', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_ACCEP_CALL', title:'접속 콜', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_REFUSE_CALL', title:'거부 콜', width:'5%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'D_LAST_ATT_TIME', title:'마지막시도시간', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_STATUS', title:'상태', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_CALL_ORIGIN', title:'Call Origin', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}
				    ]
			}));
	});

	function fn_retrieve(event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
		$("#m03IsdnInfoGrid").data('kendoGrid').setDataSource(getGridDataSource());
	}

	function getGridDataSource() {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M03IsdnInfoLstQry.htm",
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
<div id="m03IsdnInfoGrid" class="table_typ2-3"></div>
<!-- table_typ2-3 // -->

