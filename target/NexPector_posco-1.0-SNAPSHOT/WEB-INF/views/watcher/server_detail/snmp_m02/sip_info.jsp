<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/include/include_js.jsp" %>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		$("#sipInfoGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: getGridDataSource(),
				dataBound	: gridDataBound,
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'N_INDEX', title:'번호', width:'5%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_NAME', title:'장비명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_INET_ADDR', title:'IP주소', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_IN_PROTOCOL', title:'IN프로토콜', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'N_IN_PORT', title:'IN포트', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'N_OUT_PORT', title:'OUT포트', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_DESC', title:'설명', width:'20%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}}
				]
			}));
	});

	function fn_retrieve(event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
		$("#sipInfoGrid").data('kendoGrid').setDataSource(getGridDataSource());
	}

	function getGridDataSource() {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M02SipInfoLstQry.htm",
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
	<div class="st_under"><h4>SIP 정보</h4></div>
</div>
<!-- stitle // -->

<!-- table_typ2-3 -->
<div id="sipInfoGrid" class="table_typ2-3"></div>
<!-- table_typ2-3 // -->