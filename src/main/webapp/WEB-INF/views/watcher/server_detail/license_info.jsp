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
					url 		: cst.contextPath() + "/watcher/kendoPagination_server_detail.licenseInfoListQry.htm",
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
				    {field:'LICENSE_TYPE', title:'LICENSE TYPE', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'USE_COUNT', title:'TOTAL ', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'TOTAL_COUNT', title:'USE', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'DESC', title:'DESC', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}
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