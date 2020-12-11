<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/include/include_js.jsp" %>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		$("#extInfoGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: getGridDataSource(),
				dataBound	: gridDataBound,
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'S_EXT_NUM', title:'내선번호', width:'20%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_STATUS', title:'등록상태', width:'20%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, template:'#= fn_change_text_color(N_STATUS, S_STATUS) #'},
				    {field:'S_MAC_ADDR', title:'전화기 MAC_ADDR', width:'30%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_ADDR', title:'전화기 IP', width:'30%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
				]
			}));

		// 그룹 DropDownList
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url		: cst.contextPath() + '/watcher/lst_cmb_cdr_branch2_ext.htm',
					data 	: { 'N_MON_ID' : pMonId },
					dataType: 'json'
				}
			}
		});

//		createDropDownList('branch_code', dataSource, {optionLabel : '전체', dataTextField : 'VAL', dataValueField : 'CODE', change : fn_retrieve});
	});

	function fn_retrieve(event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
		$("#extInfoGrid").data('kendoGrid').setDataSource(getGridDataSource());
	}

	function getGridDataSource() {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M02ExtInfoLstQry.htm",
					data 		: function(data) {
						return {
							'N_MON_ID' 		 : pMonId,
							'S_EXT_NO' 	 : $('#ext_num').val(),
							'S_INET_ADDR' 	 : $('#ip_address').val(),
							'S_MAC_ADDR' 	 : $('#mac_address').val(),
							'BRANCH_CODE' 	 : $('#branch_code').val()
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

	function fn_print_icon(status) {
		var img = status == 3 ? 'icon_waring_on.gif' : 'icon_waring_off.gif';
		return '<img src="' + cst.contextPath() + '/common/images/watcher' + '/' + img + '">'
	}

	function fn_change_text_color(n_status, s_status) {
		if (parseInt(n_status) === 2) {
			return '<b style="color:blue">' + s_status + '</b>';
		}
		else {
			return '<b style="color:red">' + s_status + '</b>';
		}
	}
</script>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>내선 정보</h4></div>
</div>
<!-- stitle // -->

<!-- stitle // -->
<div class="ip-phone">
	<form id="searchFrm" name="searchFrm">
		<div class="ip_listB" style="float: none; width: 100%">
			<ul>
				<li class="_left">
					<%--<strong>영업점</strong>
					<input type="text" id="branch_code" name="BRANCH_CODE" />--%>
					<strong>내선번호</strong>
					<input type="text" id="ext_num" name="S_EXT_NUM" size="" style="height:18px;"/>
					<strong>IP</strong>
					<input type="text" id="ip_address" name="S_IPADDRESS" size="" style="height:18px;"/>
					<strong>MAC_ADDR</strong>
					<input type="text" id="mac_address" name="S_MACADDRESS" size="" style="height:18px;"/>
					<a href="#" onclick="fn_retrieve(event);"><img src="<c:url value="/images/botton/search.jpg"/>" alt="검색" /></a>
				</li>
				<li class="_right"></li>
			</ul>
		</div>
	</form>
</div>

<!-- table_typ2-3 -->
<div id="extInfoGrid" class="table_typ2-3"></div>
<!-- table_typ2-3 // -->