<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/include/include_js.jsp" %>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		$("#gatewayInfoGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: getGridDataSource(),
				dataBound	: gridDataBound,
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'N_INDEX', title:'번호', width:'5%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_DESC', title:'장비명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_INET_ADDR', title:'IP주소', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, sortable: false},
				    {field:'S_STATUS', title:'등록상태', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, template:'#= fn_change_text_color(N_STATUS, S_STATUS, null, null) #'},
				    {field:'S_STATUS_REASON', title:'현재상태', width:'35%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, template:'#= fn_change_text_color(null, null, N_STATUS_REASON, S_STATUS_REASON) #'},
				    {field:'S_PRODUCT_NAME', title:'제품명', width:'15%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
				]
			}));

		// 등록상태 DropDownList
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url		: cst.contextPath() + '/watcher/lst_cmb_snmp_status.htm',
					data 	: { 'N_MON_ID' : pMonId },
					dataType: 'json'
				}
			}
		});

		createDropDownList('status', dataSource, {optionLabel : '전체', dataTextField : 'VAL', dataValueField : 'CODE', change : fn_retrieve});
	});

	function fn_retrieve(event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
		$("#gatewayInfoGrid").data('kendoGrid').setDataSource(getGridDataSource());
	}

	function getGridDataSource() {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M02GatewayInfoLstQry.htm",
					data 		: function(data) {
						return {
							'N_MON_ID' 		 : pMonId,
							'S_INET_ADDR' 	 : $('#ip_address').val(),
							'N_STATUS' 	 	 : $('#status').val()
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

	function fn_change_text_color(n_status, s_status, n_reason, s_reason) {
		if (n_status != null) {
			if (parseInt(n_status) === 2) {
				return '<b style="color:blue">' + s_status + '</b>';
			}
			else {
				return '<b style="color:red">' + s_status + '</b>';
			}
		}
		else if (n_reason != null) {
			if (parseInt(n_reason) === 0) {
				return '<b style="color:blue">' + s_reason + '</b>';
			}
			else {
				return '<b style="color:red">' + s_reason + '</b>';
			}
		}
	}
</script>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>GateWay 정보</h4></div>
</div>
<!-- stitle // -->

<!-- stitle // -->
<div class="ip-phone">
	<form id="searchFrm" name="searchFrm">
		<div class="ip_listB" style="float: none; width: 100%">
			<ul>
				<li class="_left">
					<strong>IP</strong>
					<input type="text" id="ip_address" name="S_IPADDRESS" size="" style="height:18px;"/>
					<strong>등록상태</strong>
					<input type="text" id="status" name="N_STATUS" size="" style="height:18px;"/>
					<a href="#" onclick="fn_retrieve(event);"><img src="<c:url value="/images/botton/search.jpg"/>" alt="검색" /></a>
				</li>
				<li class="_right"></li>
			</ul>
		</div>
	</form>
</div>

<!-- table_typ2-3 -->
<div id="gatewayInfoGrid" class="table_typ2-3"></div>
<!-- table_typ2-3 // -->