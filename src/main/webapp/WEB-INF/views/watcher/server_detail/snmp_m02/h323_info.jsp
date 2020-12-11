<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/include/include_js.jsp" %>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		$("#h323InfoGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: getGridDataSource(),
				dataBound	: gridDataBound,
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'S_NAME', title:'명칭', width:'12%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_DESC', title:'설명', width:'12%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_STATUS', title:'상태', width:'5%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_REMOTE_CM_ADDR_01', title:'REMOTE_CM_IP1', width:'12%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_REMOTE_CM_ADDR_02', title:'REMOTE_CM_IP2', width:'12%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_REMOTE_CM_ADDR_03', title:'REMOTE_CM_IP3', width:'12%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_STATUS_REASON', title:'전화기상태', width:'11%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, template:'#= fn_change_text_color(N_STATUS_REASON, S_STATUS_REASON) #'},
				    {field:'D_REASON_TIME', title:'상태변경시각', width:'12%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_PRODUCT_NAME', title:'제품종류', width:'12%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
				]
			}));
	});

	function fn_retrieve(event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
		$("#h323InfoGrid").data('kendoGrid').setDataSource(getGridDataSource());
	}

	function getGridDataSource() {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M02H323InfoLstQry.htm",
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

	function fn_change_text_color(n_reason, s_reason) {
		if (parseInt(n_reason) === 0) {
			return '<b style="color:blue">' + s_reason + '</b>';
		}
		else {
			return '<b style="color:red">' + s_reason + '</b>';
		}
	}
</script>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>H323 정보</h4></div>
</div>
<!-- stitle // -->

<!-- table_typ2-3 -->
<div id="h323InfoGrid" class="table_typ2-3"></div>
<!-- table_typ2-3 // -->