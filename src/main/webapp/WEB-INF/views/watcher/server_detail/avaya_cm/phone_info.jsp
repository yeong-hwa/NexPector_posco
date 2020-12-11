<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/include/include_js.jsp" %>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		$("#grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: getGridDataSource(),
				dataBound	: gridDataBound,
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				columns		: [
					{field:'STATION_EXT', title:'교환기 내선', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_IP_ADDRESS', title:'IP', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'DEPT_NAME', title:'부서', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'EMP_NM', title:'이름', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'TITLE_NAME', title:'직급', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
				    {field:'S_TYPE', title:'TYPE', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}}
				]
			}));

	});

	function fn_retrieve(event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
		$("#grid").data('kendoGrid').setDataSource(getGridDataSource());
	}

	function getGridDataSource() {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_avaya_cm.phoneInfoListQry.htm",
					data 		: function(data) {
						return {
							'N_MON_ID' 		: pMonId,
							'STATION_EXT' 	: $('#STATION_EXT').val(),
							'S_IP_ADDRESS' 	: $('#S_IP_ADDRESS').val(),
							'EMP_NM'		: $('#EMP_NM').val()
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
	<div class="st_under"><h4>내선 정보(교환기 등록)</h4></div>
</div>
<!-- stitle // -->

<!-- stitle // -->
<div class="ip-phone">
	<form id="searchFrm" name="searchFrm">
		<div class="ip_listB" style="float: none; width: 100%">
			<ul>
				<li class="_left">
					<strong>교환기 내선번호</strong>
					<input type="text" id="STATION_EXT" name="STATION_EXT" size="" style="height:18px;"/>
					<strong>IP</strong>
					<input type="text" id="S_IP_ADDRESS" name="S_IP_ADDRESS" size="" style="height:18px;"/>
					<strong>이름</strong>
					<input type="text" id="EMP_NM" name="EMP_NM" size="" style="height:18px;"/>
					<a href="#" onclick="fn_retrieve(event);"><img src="<c:url value="/images/botton/search.jpg"/>" alt="검색" /></a>
				</li>
				<li class="_right"></li>
			</ul>
		</div>
	</form>
</div>

<!-- table_typ2-3 -->
<div id="grid" class="table_typ2-3"></div>
<!-- table_typ2-3 // -->