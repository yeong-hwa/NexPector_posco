<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>임계치 정보 관리</h2><span>Home &gt; 감시장비 관리 &gt; 임계치 정보 관리</span></div></div>
<!-- location // -->

<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>장비그룹</strong><cmb:combo qryname="cmb_svr_group" seltagname="N_GROUP_CODE" firstdata="전체" etc="id=\"N_GROUP_CODE\""/>
					<strong style="margin-left:30px;">장비타입</strong><cmb:combo qryname="cmb_svr_type" seltagname="N_TYPE_CODE" firstdata="전체" etc="id=\"N_TYPE_CODE\""/>
					<select style="margin-left:30px;" name="SEARCH_TYPE" value="${param.SEARCH_TYPE}" id="SEARCH_TYPE">
						<option value="ID">장비ID</option>
						<option value="NM">장비명</option>
						<option value="IP">장비IP</option>
					</select>
					<input type="text" name="SEARCH_KEYWORD" id="SEARCH_KEYWORD" value="${param.SEARCH_KEYWORD}" class="int_f input_search"/>
				</dd>
			</dl>
			<!-- 검색항목 // -->

			<!-- 버튼 -->
			<span class="his_search_bt"><a href="#" id="search"><img src="<c:url value="/images/botton/search_1.jpg"/>" alt="검색" /></a></span>
			<!-- 버튼 // -->
		</li>
		<li class="rightbg">&nbsp;</li>
	</ul>
</div>
<!-- 검색영역 //-->

<!-- manager_contBox1 -->
<div class="manager_contBox1">
	<!-- stitle -->
	<div class="stitle1" style="float: none;">
		<div class="st_under">
			<h4>건수 : &nbsp;<span id="total_count">0</span></h4>
			<span><a href="<c:url value="/admin/go_prgm.mon.critical_value.insert.htm"/>" id="btn_save" class="css_btn_class">등록</a></span>
			<span><a href="#" id="btn_remove" class="css_btn_class" style="margin-right: 10px;">선택삭제</a></span>
		</div>
	</div>
	<!-- stitle // -->
	<!-- table_typ2-4 -->
	<div id="critical_value_info_gird" class="table_typ2-4">
	</div>
</div>
<!-- manager_contBox1 // -->
<!-- 내용 // -->

<form id="frm"></form>

<script type="text/javascript">
	var grid;
	$(document).ready(function() {
		initGrid();
		initEvent();

		var searchParam = '${param.searchParam}';
		if ('' !== searchParam) {
			initSearchData(searchParam);
		}
	});

	function initSearchData(searchParam) {
		var param = JSON.parse(decodeURIComponent(searchParam));
		$('#N_GROUP_CODE').val(param.N_GROUP_CODE);
		$('#N_TYPE_CODE').val(param.N_TYPE_CODE);
		$('#SEARCH_TYPE').val(param.SEARCH_TYPE);
		$('#SEARCH_KEYWORD').val(param.SEARCH_KEYWORD);
		
		// $('#critical_value_info_gird').data('kendoGrid').dataSource.page(param.currentPageNo);
	}
	
	// Event 등록
	function initEvent() {

		$(".input_search").keypress(function(event){
			if(kendo.keys.ENTER === event.keyCode)
				$("#search").click();
		});
		
		$('#search').on('click', function(event) {
			event.preventDefault();
			grid.dataSource.read();
		});

		$('#btn_remove').on('click', function(event) {
			event.preventDefault();

			if ($('input[name=DEL_KEY]:checked').length === 0) {
				alert('삭제하실 항목을 선택해주세요.');
				return;
			}

			if ( confirm('선택하신 임계치를 삭제하시겠습니까?') ) {
				var url = cst.contextPath() + '/admin/removeThreshold.htm',
					param = $('#critical_value_info_gird table [type=checkbox]:checked').serialize();

				var xhr = $.getJSON(url, param);
				xhr.done(function(data) {
					if (parseInt(data.RSLT) > 0) {
						alert('삭제 되었습니다.');
						grid.dataSource.read();
					}
					else {
						alert('삭제 실패하였습니다.');
					}
				});
			}
		});
	}

	// 사용자 목록 Grid
	function initGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/admin/kendoPagination_critical_value.select_list.htm",
					data 		: function(data) {
						return {
							'N_GROUP_CODE'  : $('#N_GROUP_CODE').val(),
							'N_TYPE_CODE'	: $('#N_TYPE_CODE').val(),
							'SEARCH_TYPE'	: $('#SEARCH_TYPE').val(),
							'SEARCH_KEYWORD': $('#SEARCH_KEYWORD').val()
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
			pageSize		: cst.countPerPage(),
			serverPaging	: true,
			serverSorting	: true
		});

		grid = $("#critical_value_info_gird")
			.kendoGrid($.extend(kendoGridDefaultOpt, {
				dataSource	: dataSource,
				dataBound	: function (e) {

					gridDataBound(e);

					$('#all_check').on('click', function() {
						if (this.checked) {
							$('input[name=DEL_KEY]').prop('checked', true);
						} else {
							$('input[name=DEL_KEY]').prop('checked', false);
						}
					});

					// content checkbox 이벤트 등록
					$('input[name=DEL_KEY]').on('change', releaseAllCheckbox);

					$('tr').on('dblclick', function(event) {
						selectedRow(event);
					});
				},
//				change		: selectedRow,
				sortable	: {
					mode 		: 'multiple',
					allowUnsort : true
				},
				columns		: [
					{headerTemplate: '<input type="checkbox" id="all_check" name="ALL_CHECK" value="Y"/>', template: kendo.template($('#checkboxTemplate').html()),
						attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, sortable : false},
					{field:'N_MON_ID', title:'장비ID', width:'5%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_MON_NAME', title:'장비명', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_GROUP_NAME', title:'그룹', width:'10%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_TYPE_NAME', title:'장비종류', width:'7%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_ALM_RATING_NAME', title:'알람등급', width:'7%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_ALM_MSG', title:'임계치', width:'15%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_START_TIME', title:'시작시간', width:'7%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'S_END_TIME', title:'종료시간', width:'7%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}},
					{field:'VALUE1', title:'설정값1', width:'7%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, sortable : false},
					{field:'VALUE2', title:'설정값2', width:'10%', attributes:{style:'text-align:left'}, headerAttributes:{style:'text-align:center'}, sortable : false},
					{field:'N_THRESHOLD', title:'반복횟수', width:'5%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, template:'#=N_THRESHOLD == -1 ? "-" : N_THRESHOLD#'},
					{field:'N_USE', title:'사용여부', width:'6%', attributes:{style:'text-align:center'}, headerAttributes:{style:'text-align:center'}, template:'#=N_USE == 0 ? "사용" : "사용안함"#'}
				]
			})).data('kendoGrid');
	}

	// Selected Grid Row
	function selectedRow(event) {
		// 검색 조건과 페이지 번호를 JSON 형태의 String 으로 넘겼다가 다시 받아오기 위함
		var str			= decodeURIComponent(grid.select().find(':first').find('input[type=checkbox]').val()),
			condition 	= JSON.parse(str),
			param 		= {
				'N_GROUP_CODE'  : $('#N_GROUP_CODE').val(),
				'N_TYPE_CODE'	: $('#N_TYPE_CODE').val(),
				'SEARCH_TYPE'	: $('#SEARCH_TYPE').val(),
				'SEARCH_KEYWORD': $('#SEARCH_KEYWORD').val(),
				'currentPageNo'	: grid.dataSource.page()
			},
			paramStr 	= JSON.stringify(param);
		
		var $frm = $('#frm')
				.append('<input type="hidden" name="searchParam" value="' + encodeURIComponent(paramStr) + '">')
				.append('<input type="hidden" name="N_MON_ID" value="' + condition.N_MON_ID + '">')
				.append('<input type="hidden" name="N_TYPE_CODE" value="' + grid.dataItem(grid.select()).N_TYPE_CODE + '">')
				.append('<input type="hidden" name="N_ALM_TYPE" value="' + condition.N_ALM_TYPE + '">')
				.append('<input type="hidden" name="N_ALM_CODE" value="' + condition.N_ALM_CODE + '">')
				.append('<input type="hidden" name="N_ALM_RATING" value="' + condition.N_ALM_RATING + '">')
				.append('<input type="hidden" name="S_START_TIME" value="' + condition.S_START_TIME + '">')
				.append('<input type="hidden" name="S_END_TIME" value="' + condition.S_END_TIME + '">')
				.append('<input type="hidden" name="updateFlag" value="U">');

		/*
		모든 임계치에는 기본적으로 N_MON_ID, N_ALM_TYPE, N_ALM_CODE, N_ALM_RATING, S_START_TIME, S_END_TIME 이 존재하고
		Traffic Trunk 임계치에는 N_GROUP_NUM,
		시나리오 임계치에는 S_COMPANY, N_GROUP_CODE, S_APP_ID,
		CTI 포기율 임계치에는 S_COMPANY, S_CENTER 을 가지고 있다.
		*/

		if (isTrafficTrunkThreshold(condition)) {
			$frm.append('<input type="hidden" name="N_GROUP_NUM" value="' + condition.N_GROUP_NUM + '">');
			$frm.append('<input type="hidden" name="req_data" value="data;critical_value.detailTrafficTrunkThreshold:map">');
		}
		else if (isIvrAppThreshold(condition)) {
			$frm.append('<input type="hidden" name="S_COMPANY" value="' + condition.S_COMPANY + '">');
			$frm.append('<input type="hidden" name="N_GROUP_CODE" value="' + condition.N_GROUP_CODE + '">');
			$frm.append('<input type="hidden" name="S_APP_ID" value="' + condition.S_APP_ID + '">');
			$frm.append('<input type="hidden" name="req_data" value="data;critical_value.detailIvrAppThreshold:map">');
		}
		else if (isAbandonedThreshold(condition)) {
			$frm.append('<input type="hidden" name="S_COMPANY" value="' + condition.S_COMPANY + '">');
			$frm.append('<input type="hidden" name="S_CENTER" value="' + condition.S_CENTER + '">');
			$frm.append('<input type="hidden" name="req_data" value="data;critical_value.detailAbandonedThreshold:map">');
		}
		else {
			$frm.append('<input type="hidden" name="req_data" value="data;critical_value.detailThreshold:map">');
		}

		$frm.attr({'action' : '<c:url value="/admin/go_prgm.mon.critical_value.update.htm"/>'}).submit();

		event.preventDefault();
	}

	function isTrafficTrunkThreshold(obj) {
		return obj.N_GROUP_NUM != undefined;
	}

	function isIvrAppThreshold(obj) {
		return obj.S_COMPANY != undefined && obj.N_GROUP_CODE != undefined && obj.S_APP_ID != undefined;
	}

	function isAbandonedThreshold(obj) {
		return obj.S_COMPANY != undefined && obj.S_CENTER != undefined;
	}
	
	function releaseAllCheckbox() {
		$('input[name=DEL_KEY]').length === $('input[name=DEL_KEY]:checked').length
				? $('#all_check').prop('checked', true)
				: $('#all_check').prop('checked', false);
	}
</script>

<script id="checkboxTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="DEL_KEY" value="#=encodeURI(CHECK_VAL)#" />
</script>
