<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M11IfInfoLstQry.htm",
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

		$("#ifInfoGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				columns	: [
				    {field:'N_INDEX', title:'INDEX', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_DESC', title:'DESC', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'D_INS_DATE', title:'INS_DATE', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_TYPE', title:'TYPE', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_MTU', title:'MTU', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'N_SPEED', title:'SPEED', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_PHYS_ADDR', title:'PHYTS_ADDR', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'S_ADMIN_STATUS', title:'ADMIN_STATUS', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_ADMIN_STATUS, S_ADMIN_STATUS) #'},
				    {field:'S_OPER_STATUS', title:'OPER_STATUS', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter, template:'#= fn_change_text_color(N_OPER_STATUS, S_OPER_STATUS) #'}
				]
			}));
	});

	function fn_change_text_color(status, value) {
		var className = 'tcolor_red';

		if (parseInt(status) === 1) {
			className = 'tcolor_blue';
		}

		return '<span class="' + className + '">' + value + '</span>';
	}
</script>

<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>Interface 정보</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-2 -->
<div id="ifInfoGrid" class="table_typ2-2">
</div>
<!-- table_typ2-2 // -->