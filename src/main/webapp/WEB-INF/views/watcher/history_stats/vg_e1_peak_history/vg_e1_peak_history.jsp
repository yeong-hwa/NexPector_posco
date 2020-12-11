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
</style>
<script type="text/javascript" src="<c:url value="/js/history.js" />"></script>
<script>
	
	var seriesArr = [
		{ field : 'N_TIME', name : '시간'}
		, { field : 'VG01_E1', name : '서울VG'}
		, { field : 'VG02_E1', name : '포항VG'}
		, { field : 'VGSUM_E1', name : '전체'}
	];
	
	
	var columsArr = [
		  {field:seriesArr[0].field, title:seriesArr[0].name, width:'160px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[0].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[1].field, title:seriesArr[1].name, width:'160px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[1].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[2].field, title:seriesArr[2].name, width:'160px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[2].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[3].field, title:seriesArr[3].name, width:'160px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[3].name + '</div>', headerAttributes: {style:'text-align:center'}}		
	];
	
	var grid;
	$(function() {
		$("#grid").kendoGrid();
		initialize();
		
		search();
	});

	function initialize() {
		var start = createKendoDatepicker('start_date');

		// 서비스 타입 DropDownList
/* 		var serviceTypeArr = new Array();
		serviceTypeArr.push({VAL : '전체', CODE : 999});
		for (var i=0; i<seriesArr.length; i++) {
			serviceTypeArr.push({VAL : seriesArr[i].name, CODE : i});
		};
		var dataSource = new kendo.data.DataSource({ 
			data : serviceTypeArr
		});

		createDropDownList('service_type', dataSource); */
		//-- 서비스 타입 DropDownList
		
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
		//var serviceType = $('#service_type').data('kendoDropDownList').value();
		var url = "<c:url value='/watcher/lst_history_stats.vgE1PeakHistoryQry.htm'/>";
		
		var param = { 'N_DAY' : $("#start_date").val().replace(/-/gi, "")}; 
		
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
			
			var series = new Array();
			series.push(seriesArr[1]);
			series.push(seriesArr[2]);
			series.push(seriesArr[3]);
			
			createchart(ds, series);
			createGrid(ds, columsArr);
			/*
			if(serviceType == 999) { // 전체일 경우
				createchart(ds, []);
				createGrid(ds, columsArr);
			}
 			else {
				var series = new Array();
				series.push(seriesArr[serviceType]);
				
				createchart(ds, series);
				
				var columns = new Array();
				columns.push(columsArr[serviceType]);
				
				createGrid(ds, columns);
			} */
		});
	}
	
	function createchart(dataSource, series) {
		$('#chart').kendoChart({
			legend : {
				position : 'top'
			},
 			dataSource : dataSource,
			seriesDefault : {
				type : 'column'
			},
			series : series,
			categoryAxis : {
				field : 'N_TIME',
				labels: {
					format: "{0}"
					//step : 2
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
			{field:'N_DAY', title:'날짜', width:'80px;;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + "날짜" + '</div>', headerAttributes: {style:'text-align:center'}}
		];
		
		var gridColumns = dateColumns.concat(col);
		console.log(gridColumns);
		$("#grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				toolbar : ["excel"]
				, excel: {
					fileName: "vg_e1_peak_history.xlsx"
					, filterable : false
				}
				, dataSource	: dataSource
				// , sortable	: true
				, columns	: gridColumns 
				, pageable : false

				, scrollable : true
				, excelExport : function (e) {
					var sheet = e.workbook.sheets[0];
					for (var i=0; i<sheet.columns.length; i++) {
						sheet.columns[i].width = 150;
					}
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

</script>



<!-- location -->
<div class="locationBox"><div class="st_under"><h2>VG E1 Peak 이력</h2><span>Home &gt; 이력/통계 조회 &gt; VG E1 Peak 이력</span></div></div>
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
					<input type="text" name="N_DAY" id="start_date" class="input_search" value="" />
				</dd>
			</dl>
			<dl>
<!-- 				<dd>
					<strong>서비스</strong>
					<input id="service_type" name="service_type" class="input_search" style="width: 300px" />
				</dd> -->
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
			<h4>VG E1 Peak 이력</h4>
		</div>
	</div>
	<div id="chart" class='' style="height:200px;"></div>
	<!-- 동적 생성 -->
	<div id="grid" class='' style="margin:50px;"></div>
</div>
<!-- his_contBox // -->