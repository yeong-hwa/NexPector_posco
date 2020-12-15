<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/history.js" />"></script>
<script type="text/javascript">

	var listTableTempHtml = '';

	// Document Ready
	$(function() {
		initialize();

		// Event 등록
		// 검색 버튼
		$('#search').on('click', function(event) {
			event.preventDefault();
			fn_retrieve();
		});

		// 엑셀 저장 버튼
		$('#excel_download_button').on('click', function(event) {
			event.preventDefault();
			fn_excel_download();
		});
		//-- Event 등록
	});

	// 초기화
	function initialize() {
		var start = createStartKendoDatepicker('start_date');
		var end = createEndKendoDatepicker('end_date');
		start.max(end.value());
		end.min(start.value());

		fn_retrieve();
	}

	// 검색
	function fn_retrieve() {
		$('#contents_server_tr').empty();
		$('#contents_error_tr').empty();
		$('#contents_call_tr').empty();
		$('input[name="CHK_REPORT_RES"]:checked').each(function(idx){
			if($(this).val() == 0){
				fn_server_list();
			}else if($(this).val() == 1){
				fn_error_list();
			}else if($(this).val() == 2){
				fn_call_list();
			}

		});
	}

	// 서버정보 목록 조회
	function fn_server_list() {
		var $contentsServerTr = $('#contents_server_tr');
		var param = {
				'S_ST_DT'		: $('#start_date').val().replace(/-/gi, ''),
				'S_ED_DT'		: $('#end_date').val().replace(/-/gi, ''),
			};

		$contentsServerTr
			.empty()
			.append( $('<td/>').addClass('bgml1') )
			.append( $('<td/>').addClass('bgmc1')
						.append( $('<div/>')
									.addClass('avaya_stitle1')
									.css('float', 'none')
									.append( $('<div/>')
												.addClass('st_under')
												.append( $('<h4/>').text('서버정보'))))
						.append( $('<div/>').attr('id', 'serverGrid') ))
			.append( $('<td/>').addClass('bgmr1') );

		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_DayReportServerRetrieveListQry.htm",
					data 		: function(data) {
						return fn_get_search_param();
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

		var columns = kendoGridColumns();

		$("#serverGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				columns		: columns.dayReportServer()
			}));
	}

	// 장애이력 목록 조회
	function fn_error_list() {
		var $contentsErrorTr = $('#contents_error_tr');
		var param = {
				'S_ST_DT' 		: $("#start_date").val().replace(/-/gi, ""),
				'S_ED_DT' 		: $("#end_date").val().replace(/-/gi, "")
			};

		$contentsErrorTr
			.empty()
			.append( $('<td/>').addClass('bgml1') )
			.append( $('<td/>').addClass('bgmc1')
						.append( $('<div/>')
									.addClass('avaya_stitle1')
									.css('float', 'none')
									.append( $('<div/>')
												.addClass('st_under')
												.append( $('<h4/>').text('장애이력'))))
						.append( $('<div/>').attr('id', 'errorGrid') ))
			.append( $('<td/>').addClass('bgmr1') );

		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_DayReportErrorRetrieveListQry.htm",
					data 		: param
				},
				parameterMap: function (data, opperation) {
					return JSON.stringify(data);
				}
			},
			schema			: {
				data	: function(data) {
					console.log(data);
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

		var columns = kendoGridColumns();

		$("#errorGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				columns		: columns.error()
			}));
	}
	
	// 콜통계 목록 조회
	function fn_call_list() {
		var $contentsCallTr = $('#contents_call_tr');
		var param = {
				'S_ST_DT' 	: $('#start_date').val().replace(/-/gi, ''),
				'S_ED_DT' 	: $('#end_date').val().replace(/-/gi, ''),
			};

		$contentsCallTr
			.empty()
			.append( $('<td/>').addClass('bgml1') )
			.append( $('<td/>').addClass('bgmc1')
						.append( $('<div/>')
									.addClass('avaya_stitle1')
									.css('float', 'none')
									.append( $('<div/>')
												.addClass('st_under')
												.append( $('<h4/>').text('콜통계'))))
						.append( $('<div/>').attr('id', 'callGrid') ))
			.append( $('<td/>').addClass('bgmr1') );

		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_DayReportCallRetrieveListQry.htm",
					data 		: function(data) {
						return fn_get_search_param();
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

		var columns = kendoGridColumns();

		$("#callGrid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				columns		: columns.dayReportCall()
			}));
	}
	
	function fn_dynamic_html_pagination(flag) {
		if (flag === 'append') {
			$('#contents_td').append(
					' <div class="tap_pageing4" id="pagenation"> ' +
					' 	<a class="direction prev" href="#"> ' +
					'		<span> </span> <span> </span>' +
					'	</a> ' +
					'	<a class="direction prev" href="#"> ' +
					'		<span> </span>' +
					'	</a> ' +
					'	<span style="line-height:21px;">Page 1 of 2</span> ' +
					'	<a class="direction next" href="#">' +
					'		<span> </span> ' +
					'	</a> ' +
					'	<a class="direction next" href="#">' +
					'		<span> </span> <span> </span> ' +
					'	</a> ' +
					' </div> ')
		} else if (flag === 'remove') {
			$('#pagination').remove();
		} else {
			return;
		}
	}

	// 엑셀 Download
	function fn_excel_download() {

		var tempReportRes = "";
		$('input[name="CHK_REPORT_RES"]:checked').each(function() {
			tempReportRes += $(this).val()+";";
		});
		
		var param = "?req_data=";

		$('input[name="CHK_REPORT_RES"]:checked').each(function(idx){
			if($(this).val() == 0){
				param += "serverInfo;DayReportHistoryServerQry|";
			}else if($(this).val() == 1){
				param += "errorInfo;DayReportHistoryErrorQry|";
			}else if($(this).val() == 2){
				param += "callInfo;DayReportHistoryCallQry|";
			}
		});
		param = param.substring(0,param.lastIndexOf("|"));

		var url = cst.contextPath() + '/watcher/go_history_stats.day_report.excel.day_report_excel.htm'+param;

		$('#excel_start_date').val($("#start_date").val().replace(/-/gi, ""));
		$('#excel_end_date').val($("#end_date").val().replace(/-/gi, ""));
		$('#excel_chk_report_res').val(tempReportRes);

		$('#excel_down_form').attr({ method : 'post', 'action' : url }).submit();
	}

	// 검색 시 필요한 Parameter Data Plain Object 형식으로 반환
	function fn_get_search_param() {
		return {
			'S_ST_DT' 	: $('#start_date').val().replace(/-/gi, ''),
			'S_ED_DT' 	: $('#end_date').val().replace(/-/gi, ''),
		};
	}

	function fn_change_alm_rating_background_color(code, name, obj) {
		var c = code == undefined ? 0 : parseInt(code);
		if (c === 1) {
			return '<b style="color: #FF2222">' + name + '</b>';
		}
		else if (c === 2) {
			return '<b style="color: #FF8833">' + name + '</b>';
		}
		else if (c === 3) {
			return '<b style="color: #FF88AA">' + name + '</b>';
		}
		else {
			return '<b>' + name + '</b>';
		}
	}
</script>

<!-- excel download form -->
<form id="excel_down_form" name="excelDownFrm" style="display:none;">
	<input type="hidden" id="excel_start_date" name="S_ST_DT" value=""/>
	<input type="hidden" id="excel_end_date" name="S_ED_DT" value=""/>
	<input type="hidden" id="excel_chk_report_res" name="EXCEL_CHK_REPORT_RES" value=""/>
</form>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>일일보고서</h2><span>Home &gt; 이력/통계 조회 &gt; 일일보고서</span></div></div>

<!-- 내용 -->
<!-- 검색영역 -->
<form id="frm" name="frm" method="get">
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>검색날짜</strong>
					<input type="text" name="S_ST_DT" id="start_date" class="input_search" value="" /> ~ <input type="text" name="S_ED_DT" id="end_date" class="input_search" value=""/>
				</dd>
			</dl>
			<dl>
				<dd>
					<input type="hidden" name="N_MON_TYPE" id="mon_type" value="">
					<input type="checkbox" name="CHK_REPORT_RES" id="chk_report_res_server" value="0" checked/><label for="chk_report_res_server">서버정보</label>
					<input type="checkbox" name="CHK_REPORT_RES" id="chk_report_res_error" value="1" checked/><label for="chk_report_res_error">장애이력</label>
					<input type="checkbox" name="CHK_REPORT_RES" id="chk_report_res_call" value="2" checked/><label for="chk_report_res_call">콜통계</label>
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
</form>
<!-- his_contBox -->
<div class="his_contBox">
	<table cellpadding="0" cellspacing="0">
		<tr>
			<td class="bgtl1"></td>
			<td class="bgtc1">
				<span class="stop_btbox">
					<a href="#"><img id="excel_download_button" src="<c:url value="/images/botton/excel.jpg"/>" alt="엑셀저장" /></a>
				</span>
			</td>
			<td class="bgtr1"></td>
		</tr>
		<tr id="contents_server_tr">
			<!-- 서버정보 동적생성 -->
		</tr>
		
		<tr id="contents_error_tr">
			<!-- 장애이력 동적생성 -->
		</tr>
		
		<tr id="contents_call_tr">
			<!-- 콜통계 동적생성 -->
		</tr>
		<tr>
			<td class="bgbl1"></td>
			<td class="bgbc1"></td>
			<td class="bgbr1"></td>
		</tr>
	</table>
</div>