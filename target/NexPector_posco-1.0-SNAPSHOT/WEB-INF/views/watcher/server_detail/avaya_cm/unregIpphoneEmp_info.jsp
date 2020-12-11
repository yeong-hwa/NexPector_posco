<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		$("#grid_unreg")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: getGridDataSource(),
				dataBound	: gridDataBound,
				sortable	: {
					mode : 'multiple',
					allowUnsort : true
				},
				columns	: [
				   /*  {field:'SCRIPT_ID', title:'SCRIPT_ID', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}, 
				    {field:'S_INSERT_TIME', title:'INSERT_TIME', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},*/
				    {field:'EXTENSION_NO', title:'직원정보 내선', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'CC_EXTENSION_NO', title:'직원정보 센터내선', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'EMP_NO', title:'직원번호', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
					{field:'DEPT_NAME', title:'부서', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'EMP_NM', title:'이름', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter},
				    {field:'TITLE_NAME', title:'직급', width:'10%', attributes:_txtCenter, headerAttributes:_txtCenter}				    
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
					url 		: cst.contextPath() + "/watcher/kendoPagination_avaya_cm.unregPhoneEmpInfoListQry.htm",
					data 		: function(data) {
						return {
							'N_MON_ID' 		: pMonId,
							'EXTENSION_NO' 	: $('#EXTENSION_NO').val(),
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
	
	function fn_change_text_color(status, value) {
		var className = 'tcolor_red';

		if (parseInt(status) === 1) {
			className = 'tcolor_blue';
		}

		return '<span class="' + className + '">' + value + '</span>';
	}
</script>

<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>직원정보 내선(IP-Phone 연결 끊김/등록정보 없음)</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-2 -->
<div class="ip-phone">
	<form id="searchFrm" name="searchFrm">
		<div class="ip_listB" style="float: none; width: 100%">
			<ul>
				<li class="_left">
					<strong>내선번호</strong>
					<input type="text" id="EXTENSION_NO" name="EXTENSION_NO" size="" style="height:18px;"/>
					<strong>이름</strong>
					<input type="text" id="EMP_NM" name="EMP_NM" size="" style="height:18px;"/>
					<a href="#" onclick="fn_retrieve(event);"><img src="<c:url value="/images/botton/search.jpg"/>" alt="검색" /></a>
				</li>
				<li class="_right"></li>
			</ul>
		</div>
	</form>
</div>
<div id="grid_unreg" class="table_typ2-2"  style="float: none; width: 100%">
</div>
<!-- table_typ2-2 // -->