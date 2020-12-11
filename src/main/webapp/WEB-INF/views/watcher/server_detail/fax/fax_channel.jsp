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
					url 		: cst.contextPath() + "/watcher/kendoPagination_fax.faxChannelListQry.htm",
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

		$("#grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				columns		: [
				    {field:'CHANNEL_NO', title:'CHANNEL_NO', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'STATUS', title:'STATUS', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'SPEED', title:'SPEED', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'SEND_FG', title:'SEND_FG', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'PAGE_NO', title:'PAGE_NO', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}
				]
			}));
	});

	function fn_change_text_color(status, value) {
		var className = '';

		var nStatus = parseInt(status);
		
		if (nStatus === 1) {
			className = 'tcolor_blue';
		} else if (nStatus === 2) { // 연결안됨
			return '';
		} else if (nStatus === 3) { // 테스트
		} else if (nStatus === 4) { // 알수없음
		}
 
		return '<span class="' + className + '">' + value + '</span>';
	}
</script>

<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>Fax 채널</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-2 -->
<div id="grid" class="table_typ2-2" style="width: 800px;">
</div>
<!-- table_typ2-2 // -->