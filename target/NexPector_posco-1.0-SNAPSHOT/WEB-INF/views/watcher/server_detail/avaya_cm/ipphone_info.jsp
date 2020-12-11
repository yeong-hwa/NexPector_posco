<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		var columns = kendoGridColumns();

		$("#ipPhoneGrid")
				.kendoGrid($.extend({}, kendoGridDefaultOpt, {
					dataSource	: getGridDataSource(),
					sortable	: {
						mode : 'multiple',
						allowUnsort : true
					},
					columns		: columns.ipPhoneInfo()
				}));

		// 전화기 상태 DropDownList
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url		: cst.contextPath() + '/watcher/lst_cmb_avayaStatus.htm',
					dataType: 'json'
				}
			}
		});

		createDropDownList('phone_status', dataSource, {optionLabel : '전체'});

		// 그룹 DropDownList
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url		: cst.contextPath() + '/watcher/lst_M01GroupLstQry.htm',
					data 	: { 'N_MON_ID' : pMonId },
					dataType: 'json'
				}
			}
		});

		createDropDownList('group', dataSource, {optionLabel : '전체', dataTextField : 'G_NAME', dataValueField : 'CODE', change : fn_retrieve});
	});

	function fn_retrieve(event) {
		event.preventDefault ? event.preventDefault() : event.returnValue = false;
		$("#ipPhoneGrid").data('kendoGrid').setDataSource(getGridDataSource());
	}

	function getGridDataSource() {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_M01IPPhoneInfoLstQry.htm",
					data 		: function(data) {
						return {
							'N_MON_ID' 		 : pMonId,
							'S_EXT_NUM' 	 : $('#ext_num').val(),
							'S_IPADDRESS' 	 : $('#ip_address').val(),
							'S_MACADDRESS' 	 : $('#mac_address').val(),
							'S_PHONE_STATUS' : $('#phone_status').data('kendoDropDownList') ? $('#phone_status').data('kendoDropDownList').value() : '',
							'N_GROUP'		 : $('#group').data('kendoDropDownList') ? $('#group').data('kendoDropDownList').value() : ''
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

	function changeTextColor(state, value) {
		if (parseInt(state) === 4)
			return '<span style="color: #0000ff">' + value + '</span>';
		else
			return '<span style="color: #ff0000">' + value + '</span>';
	}
</script>

<!-- stitle -->
<div class="avaya_stitle1" style="float: none;">
	<div class="st_under"><h4>IPSI 정보</h4></div>
</div>
<!-- stitle // -->

<!-- stitle // -->
<div class="ip-phone">
	<form id="searchFrm" name="searchFrm">
		<div class="ip_listB" style="float: none; width: 100%">
			<ul>
				<li class="_left">
					<strong>그룹</strong>
					<input type="text" id="group" name="N_GROUP" />
					<strong>전화기 상태</strong>
					<input type="text" id="phone_status" name="S_PHONE_STATUS" />
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
<div id="ipPhoneGrid" class="table_typ2-3"></div>
<!-- table_typ2-3 // -->