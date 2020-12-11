<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>SNMP Value 코드 관리</h2><span>Home &gt; 감시장비 관리 &gt; SNMP Value 코드 관리</span></div></div>
<!-- location // -->
<!-- 내용 -->
<!-- manager_contBox1 -->
<div class="manager_contBox1">
	<!-- 사용자리스트 -->
	<div class="mana_box2-2 mgt20">
		<div class="box_a">
			<table  cellpadding="0" cellspacing="0" class="table_left_s1">
				<tr>
				<td class="bgtl1"></td>
				<td class="bgtc1"><strong>SNMP 장비</strong> </td>
				<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<div class="table_typ2-7">
							<div id="snmp_man_list_grid" style="margin: 10px 0px 0px 0px;">
							</div>
						</div>
					</td>
					<td class="bgmr1"></td>
				</tr>
				
				<tr>
				<td class="bgbl1"></td>
				<td class="bgbc1"></td>
				<td class="bgbr1"></td>
				</tr>
			</table>
			<table class="table_left_s1-a">
				<tr><td></td></tr>
			</table>
			<table  cellpadding="0" cellspacing="0" class="table_left_s2">
				<tr>
				<td class="bgtl1"></td>
				<td class="bgtc1"><strong>SNMP 감시명</strong> </td>
				<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<div id="snmp_mon_list_grid" style="margin: 10px 0px 0px 0px;">
						</div>
					</td>
					<td class="bgmr1"></td>
				</tr>
				<tr>
				<td class="bgbl1"></td>
				<td class="bgbc1"></td>
				<td class="bgbr1"></td>
				</tr>
			</table>
			<table class="table_left_s1-b">
				<tr><td></td></tr>
			</table>
			<table  cellpadding="0" cellspacing="0" class="table_left_s3">
				<tr>
				<td class="bgtl1"></td>
				<td class="bgtc1"><strong>SNMP 감시명</strong> </td>
				<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<div id="snmp_value_list_grid" style="margin: 10px 0px 0px 0px;">
						</div>
					</td>
					<td class="bgmr1"></td>
				</tr>
				
				<tr>
				<td class="bgbl1"></td>
				<td class="bgbc1"></td>
				<td class="bgbr1"></td>
				</tr>
			</table>
			<table class="table_left_s1-c">
				<tr><td></td></tr>
			</table>
			<table  cellpadding="0" cellspacing="0" class="table_left_s4">
				<tr>
				<td class="bgtl1"></td>
				<td class="bgtc1"><strong>SNMP 감시명</strong> </td>
				<td class="bgtr1"></td>
				</tr>
				<tr>
					<td class="bgml1"></td>
					<td class="bgmc1">
						<div id="snmp_value_type_list_grid" style="margin: 10px 0px 0px 0px;">
						</div>
					</td>
					<td class="bgmr1"></td>
				</tr>
				
				<tr>
				<td class="bgbl1"></td>
				<td class="bgbc1"></td>
				<td class="bgbr1"></td>
				</tr>
			</table>
		</div>
	</div>
</div>

<form id="frm"></form>

<script type="text/javascript">
	$(document).ready(function() {
		initSnmpManListGrid();
		initSnmpMonListGrid();
		initSnmpValueListGrid();
		initSnmpValueTypeListGrid();

		var searchParam = '${param.searchParam}';
		if ('' !== searchParam) {
			initSearchData(searchParam);
		}
	});
	
	function initSnmpManListGrid(){

		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_snmp_value_code.RetrieveSnmpManCodeQry.htm",
					data 		: function(data) {
						return data;
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
					var totalCount = response.length > 0 ? response[0].TOTAL_COUNT : 0;
					$('#total_count').text(totalCount);
					return totalCount;
				}
			},
			pageSize		: 10,
			serverPaging	: true,
			serverSorting	: true
		});

		$("#snmp_man_list_grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				change		: searchSnmpMonListGrid,
				pageable	: {
					messages : {
						empty	: "<strong>No data</strong>",
						display : "<span>총 <strong style='color: #f35800;'>{2}</strong> 개</span>"
					}
				},
				scrollable	: true,
				sortable	: true,
				columns		: [
					{field:'S_DESC', title:'장비명', width:'100%', attributes:alignCenter, headerAttributes:alignCenter}
				],
				height		: '320px'
			}));
		
	}

	function initSnmpMonListGrid(){
		$("#snmp_mon_list_grid")
		.kendoGrid($.extend({}, kendoGridDefaultOpt, {
			dataSource	: [],
			change		: searchSnmpValueListGrid,
			pageable	: {
				messages : {
					empty	: "<strong>No data</strong>",
					display : "<span>총 <strong style='color: #f35800;'>{2}</strong> 개</span>"
				}
			},
			scrollable	: true,
			sortable	: true,
			columns		: [
				{field:'S_DESC', title:'감시명', width:'100%', attributes:alignCenter, headerAttributes:alignCenter}
			],
			height		: '320px'
		}));
	}

	function initSnmpValueListGrid(){
		$("#snmp_value_list_grid")
		.kendoGrid($.extend({}, kendoGridDefaultOpt, {
			dataSource	: [],
			change		: searchSnmpValueTypeListGrid,
			pageable	: {
				messages : {
					empty	: "<strong>No data</strong>",
					display : "<span>총 <strong style='color: #f35800;'>{2}</strong> 개</span>"
				}
			},
			scrollable	: true,
			sortable	: true,
			columns		: [
				{field:'S_DESC', title:'감시 코드', width:'100%', attributes:alignCenter, headerAttributes:alignCenter}
			],
			height		: '320px'
		}));
	}

	function initSnmpValueTypeListGrid(){
		$("#snmp_value_type_list_grid")
		.kendoGrid($.extend({}, kendoGridDefaultOpt, {
			dataSource	: [],
			change		: selectRow,
			pageable	: {
				messages : {
					empty	: "<strong>No data</strong>",
					display : "<span>총 <strong style='color: #f35800;'>{2}</strong> 개</span>"
				}
			},
			scrollable	: true,
			sortable	: true,
			columns		: [
				{field:'S_OUT_VALUE', title:'감시 상세 코드', width:'100%', attributes:alignCenter, headerAttributes:alignCenter}
			],
			height		: '320px'
		}));
	}

	
	function selectRow(){
		
	}
	
	function searchSnmpValueTypeListGrid(){
		
		var snmpManCode = this.dataItem(this.select()).N_SNMP_MAN_CODE;
		var valueTypeCode = this.dataItem(this.select()).N_VALUE_TYPE_CODE;
		if(valueTypeCode === undefined) {
			valueTypeCode = "";
		}
		
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_snmp_value_code.RetrieveSnmpValueTypeCodeQry.htm",
					data 		: function(data) {
						return {
							'N_SNMP_MAN_CODE' 	: snmpManCode,
							'N_VALUE_TYPE_CODE' : valueTypeCode
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
					var totalCount = response.length > 0 ? response[0].TOTAL_COUNT : 0;
					$('#total_count').text(totalCount);
					return totalCount;
				}
			},
			pageSize		: 10,
			serverPaging	: true,
			serverSorting	: true
		});

		var serverGrid = $('#snmp_value_type_list_grid').data('kendoGrid');
		serverGrid.setDataSource(dataSource)
	}
	
	function searchSnmpValueListGrid(){
		var snmpManCode = this.dataItem(this.select()).N_SNMP_MAN_CODE;
		var snmpMonCode = this.dataItem(this.select()).N_SNMP_MON_CODE;
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_snmp_value_code.RetrieveSnmpValueCodeQry.htm",
					data 		: function(data) {
						return {
							'N_SNMP_MAN_CODE' 	: snmpManCode,
							'N_SNMP_MON_CODE' 	: snmpMonCode
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
					var totalCount = response.length > 0 ? response[0].TOTAL_COUNT : 0;
					$('#total_count').text(totalCount);
					return totalCount;
				}
			},
			pageSize		: 10,
			serverPaging	: true,
			serverSorting	: true
		});

		var serverGrid = $('#snmp_value_list_grid').data('kendoGrid');
		serverGrid.setDataSource(dataSource);
	}
	
	function searchSnmpMonListGrid(){
		
		var snmpManCode = this.dataItem(this.select()).N_SNMP_MAN_CODE;
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_snmp_value_code.RetrieveSnmpMonCodeQry.htm",
					data 		: function(data) {
						return {
							'N_SNMP_MAN_CODE' 	: snmpManCode
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
					var totalCount = response.length > 0 ? response[0].TOTAL_COUNT : 0;
					$('#total_count').text(totalCount);
					return totalCount;
				}
			},
			pageSize		: 10,
			serverPaging	: true,
			serverSorting	: true
		});

		var serverGrid = $('#snmp_mon_list_grid').data('kendoGrid');
		serverGrid.setDataSource(dataSource);
	}
</script>