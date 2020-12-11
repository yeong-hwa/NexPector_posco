<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/jszip.min.js" />"></script>
<style>
	.wrap-header {
		height : 23px;
		overflow: visible;
		white-space: normal;
	}
	.k-grid-content {
    	overflow-x: scroll;
	}
</style>
<script type="text/javascript" src="<c:url value="/js/history.js" />"></script>
<script>
	var seriesArr = [
		  { field : 'BONSA_IN_COUNT', name : 'inbound'} // 0
		, { field : 'BONSA_OUT_COUNT', name : 'outbound'} // 1
		, { field : 'BONSA_TOTAL', name : 'Total'} // 2

		, { field : 'CCENTER_IN_COUNT', name : 'inbound'} // 3
		, { field : 'CCENTER_OUT_COUNT', name : 'outbound'} // 4
		, { field : 'CCENTER_TOTAL', name : 'Total'} // 5

		, { field : 'JIJUM_IN_COUNT', name : 'inbound'} // 6
		, { field : 'JIJUM_OUT_COUNT', name : 'outbound'} // 7
		, { field : 'JIJUM_TOTAL', name : 'Total'} // 8
	];
	var columsArr = [
		  {field:seriesArr[0].field, title:seriesArr[0].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[0].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[1].field, title:seriesArr[1].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[1].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[2].field, title:seriesArr[2].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[2].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[3].field, title:seriesArr[3].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[3].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[4].field, title:seriesArr[4].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[4].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[5].field, title:seriesArr[5].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[5].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[6].field, title:seriesArr[6].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[6].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[7].field, title:seriesArr[7].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[7].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[8].field, title:seriesArr[8].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[8].name + '</div>', headerAttributes: {style:'text-align:center'}}
	];
	
	// 전체 조회 시만 사용
	var totalColumsArr = [
		{title: '본사', headerAttributes: {style:'text-align:center'}, columns: [
			  {field:seriesArr[0].field, title:seriesArr[0].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[0].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[1].field, title:seriesArr[1].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[1].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[2].field, title:seriesArr[2].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[2].name + '</div>', headerAttributes: {style:'text-align:center'}}
		]}
		, {title: '콜센터', headerAttributes: {style:'text-align:center'}, columns: [
			  {field:seriesArr[3].field, title:seriesArr[3].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[3].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[4].field, title:seriesArr[4].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[4].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[5].field, title:seriesArr[5].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[5].name + '</div>', headerAttributes: {style:'text-align:center'}}
		]}
		, {title: '지점', headerAttributes: {style:'text-align:center'}, columns: [
			  {field:seriesArr[6].field, title:seriesArr[6].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[6].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[7].field, title:seriesArr[7].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[7].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[8].field, title:seriesArr[8].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[8].name + '</div>', headerAttributes: {style:'text-align:center'}}
		]}
	];

	//
	// 콤보박스 데이터 정의
	//
	// 기간구분
	var g_aryPeriodType = [
		{ VAL: '일별', CODE: 'D'},
		{ VAL: '월간', CODE: 'M'}
	];
	// 기간구분
	var g_aryClusterType = [
		{ VAL: '전체', 	CODE: ''},
		{ VAL: '본사', 	CODE: '0'},
		{ VAL: '콜센터', 	CODE: '1'},
		{ VAL: '지점', 	CODE: '2'}
	];

	var grid;
	$(function() {
		$("#grid").kendoGrid();
		initialize();
		
		search();
	});

	function initialize() {
		var start = createStartKendoDatepicker('start_date');
		var end = createEndKendoDatepicker('end_date');
		start.max(end.value());
		end.min(start.value());

		// 기간 구분 DropDownList
		var dataSource1 = new kendo.data.DataSource({ 
			data : g_aryPeriodType
		});
		createDropDownList('period_type', dataSource1);
		//-- 기간 타입 DropDownList
		
		// 검색 구분 DropDownList
		var dataSource2 = new kendo.data.DataSource({ 
			data : g_aryClusterType
		});
		createDropDownList('cluster_type', dataSource2);
		//-- 검색 타입 DropDownList
		
		// Event 등록
		$(".input_search").keypress(function(event){
			if(event.keyCode == '13')
				$("#search").click();
		});

		// 검색 버튼
		$('#search').on('click', function(event) {
			event.preventDefault();
			search();
		});

		// 엑셀 저장 버튼
		$('#excel_download_button').on('click', function(event) {
			event.preventDefault();
			fn_excel_download();
		});
		//-- Event 등록
	}

	function search() {
		getDataSource();
	}
	
	function getDataSource() {
		var serviceType = 999;
		var periodType  = $('#period_type').data('kendoDropDownList').value();
		var clusterType = $('#cluster_type').data('kendoDropDownList').value();
		var url			= '';
		
		if (periodType == 'M') {
			url = "<c:url value='/watcher/lst_history_stats.statsCallHistoryRetrieveMonthQry.htm'/>";
		}
		else {
			url = "<c:url value='/watcher/lst_history_stats.statsCallHistoryRetrieveDayQry.htm'/>";
		}
		
		var param = {
			'S_ST_DT' 		: $("#start_date").val().replace(/-/gi, ""),
			'S_ED_DT' 		: $("#end_date").val().replace(/-/gi, ""),
			'N_PERIOD'		: periodType, 
			'N_CLUSTER'		: clusterType
		}
		
		$.getJSON(url, param, function(data){
			var ds; 
			if (data.length > 0) {
				ds = new kendo.data.DataSource({
					data : data
				});
			}
			else {
				ds = new kendo.data.DataSource({
					data : []
				});
			}

			var chart_series;
			if (clusterType == '0') {
				chart_series = [
					  { field : 'BONSA_IN_COUNT', name : 'Inbound'} // 0
					, { field : 'BONSA_OUT_COUNT', name : 'Outbound'} // 1
					, { field : 'BONSA_TOTAL', name : 'Total'} // 2
				];
			}
			else if (clusterType == '1') {
				chart_series = [
					  { field : 'CCENTER_IN_COUNT', name : 'Inbound'} // 3
					, { field : 'CCENTER_OUT_COUNT', name : 'Outbound'} // 4
					, { field : 'CCENTER_TOTAL', name : 'Total'} // 5
				];
			}
			else if (clusterType == '2') {
				chart_series = [
					  { field : 'JIJUM_IN_COUNT', name : 'Inbound'} // 6
					, { field : 'JIJUM_OUT_COUNT', name : 'Outbound'} // 7
					, { field : 'JIJUM_TOTAL', name : 'Total'} // 8
				];
			}
			else {
				chart_series = [
					  { field : 'BONSA_TOTAL', name : '본사'}		// 0
					, { field : 'CCENTER_TOTAL', name : '콜센터'}		// 1
					, { field : 'JIJUM_TOTAL', name : '지점'}		// 2
				];
			}

			createchart(ds, chart_series);
			createGrid(ds, totalColumsArr);
		});
	}

	function createchart(dataSource, c_series) {
		$('#chart').kendoChart({
			legend : {
				position : 'top'
			},
 			dataSource : dataSource,
			seriesDefault : {
				type : 'column'
			},
			series : c_series,
			categoryAxis : {
				field : 'S_DATE',
				labels: {
					// format: "{0}",
					step : 1
					// template : "#= value.substr(0,2) #"
				}
			},
			// height: 500,
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#= category #: #= value #",
				color: "white"
			}
		});
	}
	
	function createGrid(dataSource, col) {
		$("#grid").data().kendoGrid.destroy();
		$("#grid").empty();
		var dateColumns = [
			{field:'S_DATE', title:'날짜', width:'80px;;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + "날짜" + '</div>', headerAttributes: {style:'text-align:center'}}
		];
		
		var gridColumns = dateColumns.concat(col);
		console.log(gridColumns);
		$("#grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				toolbar : ["excel"]
				, excel: {
					fileName: "call_history.xlsx"
					, filterable : false
				}
				, dataSource	: dataSource
				// , sortable	: true
				, columns	: gridColumns 
				, pageable : false
				, resizable	: false
				, scrollable : true
				, excelExport : function (e) {
					var sheet = e.workbook.sheets[0];
					for (var i=0; i<sheet.columns.length; i++) {
						sheet.columns[i].width = 120;
					}
					/*var serviceType = 0;
					if (serviceType == 999) {
						var row = sheet.rows[0];
						row.cells[1].background = "#9fc2f9";
						row.cells[1].hAlign = "center";
						row.cells[2].background = "#4c91ff";
						row.cells[2].hAlign = "center";
						row.cells[3].background = "#0062ff";
						row.cells[3].hAlign = "center";
					}*/
				}
			}));
		
		grid = $("#grid").data('kendoGrid');
		
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

	function fn_excel_download() {

		var url = cst.contextPath() + '/watcher/go_history_stats.error_history.excel.error_history_excel.htm?req_data=data;statsErrorHistoryRetrieveExcelQry';

		$('#excel_start_date').val($("#start_date").val().replace(/-/gi, ""));
		$('#excel_down_form').attr({ method : 'post', 'action' : url }).submit();

		/*frm.S_ST_DT.value = $("#datepicker1").val().replace(/-/gi, "");
		frm.S_ED_DT.value = $("#datepicker2").val().replace(/-/gi, "");

		frm.ALM_RATING_NAME.value = $("select[name='N_ALM_RATING'] option:selected").text();
		frm.USER_NAME.value = $("select[name='S_USER_ID'] option:selected").text();
		frm.SERVER_GROUP.value = $("select[name='N_GROUP_CODE'] option:selected").text();
		frm.SERVER_NAME.value = $("select[name='N_MON_ID'] option:selected").text();

		frm.target = "ifm_list";
		frm.action = "<c:url value='/watcher/go_history_stats.error_history.error_history_excel.htm?req_data=data;statsErrorHistoryRetrieveExcelQry'/>";
		frm.submit();*/
	}
</script>

<!-- excel download form -->
<form id="excel_down_form" name="excelDownFrm" style="display:none;">
	<input type="hidden" id="excel_start_date" name="S_ST_DT" value=""/>
	<input type="hidden" id="excel_alm_rating_name" name="ALM_RATING_NAME" value=""/>
	<input type="hidden" id="excel_server_group" name="SERVER_GROUP" value=""/>
	<input type="hidden" id="excel_server_type_name" name="SERVER_TYPE_NAME" value=""/>
	<input type="hidden" id="excel_user_name" name="USER_NAME" value=""/>
	<input type="hidden" id="excel_s_user_id" name="S_USER_ID" value=""/>
	<input type="hidden" id="excel_n_group_code" name="N_GROUP_CODE" value=""/>
	<input type="hidden" id="excel_n_type_code" name="N_TYPE_CODE" value=""/>
	<input type="hidden" id="excel_n_alm_rating" name="N_ALM_RATING" value=""/>
</form>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>콜 이력</h2><span>Home &gt; 이력/통계 조회 &gt; 콜 이력</span></div></div>
<!-- location // -->
<!-- 내용 -->
<!-- 검색영역 -->
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>검색기간</strong>
					<input type="text" name="S_ST_DT" id="start_date" class="input_search" value="" /> ~ <input type="text" name="S_ED_DT" id="end_date" class="input_search" value="" />
				</dd>
			</dl>
			<dl>
				<dd>
					<strong>기간구분</strong>
					<input id="period_type" name="period_type" class="input_search" style="width: 120px" />
				</dd>
			</dl>
			<dl>
				<dd>
					<strong>검색구분</strong>
					<input id="cluster_type" name="cluster_type" class="input_search" style="width: 120px" />
				</dd>
			</dl>
			<dl>
				<dd>
					&nbsp;
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
<!-- his_contBox -->
<div class="his_contBox">
<%-- 	<table cellpadding="0" cellspacing="0">
		<tr>
			<td class="bgtl1"></td>
			<td class="bgtc1">
				<span class="stop_btbox">
					<a href="#" id="excel_download_button"><img src="<c:url value="/images/botton/excel.jpg"/>" alt="엑셀저장" /></a>
				</span>
			</td>
			<td class="bgtr1"></td>
		</tr>
	</table> --%>
	<div class="avaya_stitle1" style="float:none;">
		<div class="st_under">
			<h4>사용자현황 이력</h4>
		</div>
	</div>
	<div id="chart" class='' style="height:200px;"></div>
	<!-- 동적 생성 -->
	<div id="grid" class='' style="margin:50px;"></div>
</div>
<!-- his_contBox // -->