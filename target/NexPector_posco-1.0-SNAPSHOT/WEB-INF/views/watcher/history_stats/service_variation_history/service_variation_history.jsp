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
		  { field : 'CALL_TOTAL', name : '대표번호 인입'} // 0
		, { field : 'IN_TOTAL', name : '상담 요청'} // 1
		, { field : 'EST_TOTAL', name : '상담 처리'} // 2
		, { field : 'CALL_ABANDON', name : '상담 포기'} // 3
		, { field : 'MAX_INQUEUE', name : '상담 최대호 대기수'} // 4
		, { field : 'ANS_RATE', name : '상담 응대율'} // 5
		, { field : 'CENTER_TRANS', name : '상담 그룹 호 전환'} // 6
		
		, { field : 'JIJUM_CALLS', name : '지점 대표번호 인입'} // 7
		, { field : 'JIJUM_TRANS', name : '지점 대표번호 지점연결'} // 8
		
		, { field : 'CHAT_TOTAL', name : '채팅 요청'} // 9
		, { field : 'CHAT_CONSULT', name : '채팅 상담'} // 10
		, { field : 'VARS_TOTAL', name : '보이는 ARS'} // 11
		, { field : 'IP_INQUIRY_TOTAL', name : 'Info Push 조회'} //12
		, { field : 'AP_INVOKE_TOTAL', name : 'Agent Push 발송'} //13
		, { field : 'AP_INQUIRY_TOTAL', name : 'Agent Push 조회'} //14
		
		, { field : 'CALL_IDLE', name : '고객 대기 피크'} // 15
		, { field : 'IVR_SESSION', name : 'ARS 실시간 처리 피크'} // 16
		, { field : 'IPCC_TRUNK', name : '국선사용량(IPCC)피크'} // 17
		, { field : 'COMPLAINT', name : 'VOC 불만'} // 18
		, { field : 'CUST_OFFER', name : 'VOC 제안'} // 19
		, { field : 'QNA', name : 'VOC QNA'} // 20
		
		, { field : 'IPT_TRUNK', name : '국선사용량(IPT)피크'} // 21
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
		, {field:seriesArr[9].field, title:seriesArr[9].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[9].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[10].field, title:seriesArr[10].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[10].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[11].field, title:seriesArr[11].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[11].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[12].field, title:seriesArr[12].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[12].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[13].field, title:seriesArr[13].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[13].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[14].field, title:seriesArr[14].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[14].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[15].field, title:seriesArr[15].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[15].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[16].field, title:seriesArr[16].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[16].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[17].field, title:seriesArr[17].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[17].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[18].field, title:seriesArr[18].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[18].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[19].field, title:seriesArr[19].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[19].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[20].field, title:seriesArr[20].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[20].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[21].field, title:seriesArr[21].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[21].name + '</div>', headerAttributes: {style:'text-align:center'}}
	];
	
	// 전체 조회 시만 사용
	var totalColumsArr = [
		{title: 'IPCC', headerAttributes: {style:'text-align:center'}, columns: [
			{field:seriesArr[0].field, title:seriesArr[0].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[0].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[1].field, title:seriesArr[1].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[1].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[2].field, title:seriesArr[2].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[2].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[3].field, title:seriesArr[3].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[3].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[4].field, title:seriesArr[4].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[4].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[5].field, title:seriesArr[5].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[5].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[6].field, title:seriesArr[6].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[6].name + '</div>', headerAttributes: {style:'text-align:center'}}
		]}
		, {title: 'IPT', headerAttributes: {style:'text-align:center'}, columns: [
			{field:seriesArr[7].field, title:seriesArr[7].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[7].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[8].field, title:seriesArr[8].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[8].name + '</div>', headerAttributes: {style:'text-align:center'}}
		]}
		, {title: '부가서비스', headerAttributes: {style:'text-align:center'}, columns: [
			{field:seriesArr[9].field, title:seriesArr[9].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[9].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[10].field, title:seriesArr[10].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[10].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[11].field, title:seriesArr[11].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[11].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[12].field, title:seriesArr[12].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[12].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[13].field, title:seriesArr[13].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[13].name + '</div>', headerAttributes: {style:'text-align:center'}}
			, {field:seriesArr[14].field, title:seriesArr[14].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[14].name + '</div>', headerAttributes: {style:'text-align:center'}}
		]}
		, {title: '서비스현황', headerAttributes: {style:'text-align:center'}, columns: [
		{field:seriesArr[15].field, title:seriesArr[15].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[15].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[16].field, title:seriesArr[16].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[16].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[17].field, title:seriesArr[17].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[17].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[18].field, title:seriesArr[18].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[18].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[19].field, title:seriesArr[19].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[19].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[20].field, title:seriesArr[20].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[20].name + '</div>', headerAttributes: {style:'text-align:center'}}
		, {field:seriesArr[21].field, title:seriesArr[21].name, width:'80px;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + seriesArr[21].name + '</div>', headerAttributes: {style:'text-align:center'}}
		]}
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
		var serviceTypeArr = new Array();
		serviceTypeArr.push({VAL : '전체', CODE : 999});
		for (var i=0; i<seriesArr.length; i++) {
			serviceTypeArr.push({VAL : seriesArr[i].name, CODE : i});
		};
		var dataSource = new kendo.data.DataSource({ 
			data : serviceTypeArr
		});

		createDropDownList('service_type', dataSource);
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
		var serviceType = $('#service_type').data('kendoDropDownList').value();
		var url = "<c:url value='/watcher/lst_history_stats.serviceVariationHistoryQry.htm'/>";
		
		if (serviceType == 16 ||  serviceType == 17 || serviceType == 21) { // IVR_SESSION, IPCC_TRUNK, IPT_TRUNK
			 url = "<c:url value='/watcher/lst_history_stats.serviceVariationHistoryQry2.htm'/>"; 
		}
		if (serviceType == 18 || serviceType == 19 || serviceType == 20) { // COMPLAINT, CUST_OFFER, QNA  
			 url = "<c:url value='/watcher/lst_history_stats.serviceVariationHistoryQry3.htm'/>";
		}
		if (serviceType == 4 || serviceType == 6 || serviceType == 7 || serviceType == 8) { // MAX_INQUEUE, JIJUM_TRANS, CENTER_TRANS
			 url = "<c:url value='/watcher/lst_history_stats.serviceVariationHistoryQry4.htm'/>";
		}
		if (serviceType == 999) {
			url = "<c:url value='/watcher/lst_history_stats.serviceVariationAllHistoryQry.htm'/>";
		}
		
		var param = { 'S_ST_DT' : $("#start_date").val().replace(/-/gi, "")}; 
		
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
			if(serviceType == 999) { // 전체일 경우
				createchart(ds, []);
				createGrid(ds, totalColumsArr);
			}
			else {
				var series = new Array();
				series.push(seriesArr[serviceType]);
				
				createchart(ds, series);
				
				var columns = new Array();
				columns.push(columsArr[serviceType]);
				
				createGrid(ds, columns);
			}
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
				field : 'S_COLLECT_DATE',
				labels: {
					// format: "{0}",
					step : 2
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
			{field:'S_COLLECT_DATE', title:'날짜', width:'80px;;', attributes: {style:'text-align:center'}, headerTemplate: "<div class='wrap-header'>" + "날짜" + '</div>', headerAttributes: {style:'text-align:center'}}
		];
		
		var gridColumns = dateColumns.concat(col);
		console.log(gridColumns);
		$("#grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				toolbar : ["excel"]
				, excel: {
					fileName: "servisce_usage.xlsx"
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
					var serviceType = $('#service_type').data('kendoDropDownList').value();
					if (serviceType == 999) {
						var row = sheet.rows[0];
						row.cells[1].background = "#9fc2f9";
						row.cells[1].hAlign = "center";
						row.cells[2].background = "#4c91ff";
						row.cells[2].hAlign = "center";
						row.cells[3].background = "#0062ff";
						row.cells[3].hAlign = "center";
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
<div class="locationBox"><div class="st_under"><h2>사용자현황 이력</h2><span>Home &gt; 이력/통계 조회 &gt; 사용자현황 이력</span></div></div>
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
					<input type="text" name="S_ST_DT" id="start_date" class="input_search" value="" />
				</dd>
			</dl>
			<dl>
				<dd>
					<strong>서비스</strong>
					<input id="service_type" name="service_type" class="input_search" style="width: 300px" />
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