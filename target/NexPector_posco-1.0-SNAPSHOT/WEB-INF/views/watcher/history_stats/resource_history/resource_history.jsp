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
		$(".input_search").keypress(function(event){
			if(event.keyCode == '13')
				$("#search").click();
		});

		// 검색 버튼
		$('#search').on('click', function(event) {
			event.preventDefault();
			fn_retrieve();
		});

		// 목록 and 차트 보기 버튼
		$('#list_button, #graph_button').on('click', function(event) {
			if (this.src.indexOf('_on') > -1) {
				return;
			} else {
				$('#list_button, #graph_button').each(function() {
					this.src = this.src.replace('_on', '_off');
				});

				this.src = this.src.replace('_off', '_on');
				fn_retrieve();
			}
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

		// 서버그룹 DropDownList
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: cst.contextPath() + '/watcher/lst_cmb_svr_group.htm',
					dataType: "json"
				}
			}
		});

		createDropDownList('group_code', dataSource, {optionLabel : '전체'});
		//-- 서버그룹 DropDownList

		// 장비타입 DropDownList
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: cst.contextPath() + '/watcher/lst_cmb_svr_type.htm',
					dataType: "json"
				}
			}
		});

		createDropDownList('server_type_code', dataSource, {optionLabel : '전체'});
		//-- 장비타입 DropDownList

		createDropDownList('SEARCH_TYPE', [{ VAL : '장비ID', CODE : 'ID' }, { VAL : '장비명', CODE : 'NM' }, { VAL : '장비IP', CODE : 'IP' }]);
		
		fn_retrieve();
	}

	// 검색
	function fn_retrieve() {
		var tmp_report_res = '';
		
		if ($('input[name="CHK_REPORT_RES"]:checked').length < 1) {
			alert ('자원종류를 하나 이상 선택해주세요.')
			return;
		};
		
		$('input[name="CHK_REPORT_RES"]:checked').each(function(idx){
			tmp_report_res += $(this).val();
			if( $('input[name="CHK_REPORT_RES"]:checked').length != idx + 1 ) {
				tmp_report_res += ',';
			}
		});

		$('#mon_type').val(tmp_report_res);

		if ( $('#list_button').attr('src').indexOf('_on') > -1 ) {
			fn_list();
		} else if ( $('#graph_button').attr('src').indexOf('_on') > -1 ) {
			fn_chart();
		} else {
			fn_chart();
		}
	}

	// 목록 조회
	function fn_list() {
		var reportGubun = $('input[name="opt_report_gubun"]:checked').val();
		var qry;
		if (reportGubun == 'DAY') {
			qry = "ResourceHistoryRetrieveListDayQry";
		} else if (reportGubun == 'MONTH') {
			qry = "ResourceHistoryRetrieveListMonthQry";
		} else {
			qry = "ResourceHistoryRetrieveListServerQry";
		}
		
		var $contentsTr = $('#contents_tr');

		$contentsTr
			.empty()
			.append( $('<td/>').addClass('bgml1') )
			.append( $('<td/>').addClass('bgmc1')
						.append( $('<div/>')
									.addClass('avaya_stitle1')
									.css('float', 'none')
									.append( $('<div/>')
												.addClass('st_under')
												.append( $('<h4/>').text('리소스 이력 조회(%)'))))
						.append( $('<div/>').attr('id', 'grid') ))
			.append( $('<td/>').addClass('bgmr1') );

		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_" + qry + ".htm",
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

		$("#grid")
			.kendoGrid($.extend({}, kendoGridDefaultOpt, {
				dataSource	: dataSource,
				columns		: columns.resource(),
				sortable : true
			}));
	}

	//
	// 차트관련 변수
	var	g_result_data	= [];
	var	g_sel_mon_id	= '';
	var	g_sel_mon_type	= '';
	
	// 차트 조회
	function fn_chart() {
		var reportGubun = $('input[name="opt_report_gubun"]:checked').val();
		var qry;
		
		if (reportGubun == 'DAY') {
			qry = "ResourceHistoryRetrieveChartDayQry";
		} else if (reportGubun == 'MONTH') {
			qry = "ResourceHistoryRetrieveChartMonthQry";
		} else {
			qry = "ResourceHistoryRetrieveChartServerQry";
		}

		var url = cst.contextPath() + '/watcher/lst_' + qry + '.htm';

//		$.blockUI(blockUIOption);
		$.getJSON(url, fn_get_search_param())
			.done(function(datas) {
					var $contents = $('#contents_tr'),
						$chartArea = $('<div id="chart" class="grap_area" style="overflow:scroll; height:1000px;"></div>'); // Chart 영역

					$contents
						.empty()
						.append( $('<td class="bgml1"></td>') )
						.append( $('<td class="bgmc1">')
							.append( $('<span style="position: absolute; top: 70px; left: 20px;"><input id="cbo_mon_sel" name="cbo_mon_sel" class="input_search" style="width: 120px" /></span>') )
							.append( $('<span style="position: absolute; top: 70px; left: 150px;"><input id="cbo_type_sel" name="cbo_type_sel" class="input_search" style="width: 80px" /></span>') )
							.append( $('<span class="chart_save_bt"><a href="#"><img id="save_chart" src="' + cst.contextPath() + '/images/botton/save_carht.jpg" alt="차트저장" /></a></span>') )
							.append( $chartArea ) )
						.append( $('</td>') )
						.append( $('<td class="bgmr1"/>') );

					// 차트저장 click 이벤트 등록
					$('#save_chart').on('click', function(evnet) {
						evnet.preventDefault();
						var chart = $("#chart").getKendoChart();
						chart.exportImage().done(function(data) {
							kendo.saveAs({
								dataURI: data,
								fileName: "resource_history_chart.png"
							});
						});
					});

					var series = [],
						length = $.isArray(datas) ? datas.length : 0;

					g_result_data = datas;
					makeComboList(datas);
					for (var i = 0; i < length; i++) {
						var data = datas[i];
						var seriesObject = {
							name : $.defaultStr(data.N_DAY + '[' + data.S_BASE_NAME + '('  + data.S_DATA_NAME + ')]'),
							data : [$.defaultStr(data.TIME_00, 0), $.defaultStr(data.TIME_01, 0), $.defaultStr(data.TIME_02, 0), $.defaultStr(data.TIME_03, 0), $.defaultStr(data.TIME_04, 0),
									$.defaultStr(data.TIME_05, 0), $.defaultStr(data.TIME_06, 0), $.defaultStr(data.TIME_07, 0), $.defaultStr(data.TIME_08, 0), $.defaultStr(data.TIME_09, 0),
									$.defaultStr(data.TIME_10, 0), $.defaultStr(data.TIME_11, 0), $.defaultStr(data.TIME_12, 0), $.defaultStr(data.TIME_13, 0), $.defaultStr(data.TIME_14, 0),
									$.defaultStr(data.TIME_15, 0), $.defaultStr(data.TIME_16, 0), $.defaultStr(data.TIME_17, 0), $.defaultStr(data.TIME_18, 0), $.defaultStr(data.TIME_19, 0),
									$.defaultStr(data.TIME_20, 0), $.defaultStr(data.TIME_21, 0), $.defaultStr(data.TIME_22, 0), $.defaultStr(data.TIME_23, 0)]
						};

						if (g_sel_mon_id == data.N_MON_ID) {
							series.push(seriesObject);
						}
					}

					createChart(series);
			})
			.fail(function(jqXHR) {
				console.log(jqXHR.status);
			})
			.always(function() {
//				$.unblockUI();
			});
	}

	function createChart(series) {
		$("#chart").kendoChart({
			legend: {
				position: "bottom"
			},
			seriesDefaults: {
				type: "line"
			},
			series: series,
			valueAxis: {
				min : 0,
				max : 100,
				majorUnit: 10,
				labels: {
					format: "{0}%"
				},
				line: {
					visible: true
				},
				axisCrossingValue: 0
			},
			categoryAxis: {
				categories: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
				majorGridLines: {
					visible: false
				},
				labels: {
					format: "{0}시"
				}
			},
			tooltip: {
				visible: true,
				format: "{0}%",
				template: "#= series.name #: #= value #",
				color: 'white'
			}
		});
	}
	function makeComboList(data) {
		var	cbo_list = [];
		var	map_data = {};

		for (var i = 0; i < data.length; i ++) {
			var	item = data[i];
			if (map_data[item.N_MON_ID] === undefined) {
				var	cbitem = { VAL: item.S_BASE_NAME, 	CODE: item.N_MON_ID};
				map_data[item.N_MON_ID] = item.S_BASE_NAME;
				cbo_list.push(cbitem);
			}
		}
		if (cbo_list.length > 0) {
			g_sel_mon_id = cbo_list[0].CODE;
		}
		else {
			var	cbitem = { VAL: '선택', 	CODE: ''};
			cbo_list.push(cbitem);
		}
		var dataSource = new kendo.data.DataSource({ 
			data : cbo_list
		});
		createDropDownList('cbo_mon_sel', dataSource, {
			change: function(e) {
				g_sel_mon_id = this.value();
				makeLineChart();
			}
		});

		var	cbo_list2 = [
			{ VAL: '전체', 	CODE: ''},
			{ VAL: 'CPU', 	CODE: '0'},
			{ VAL: '메모리',	CODE: '1'}, 
			{ VAL: 'Disk',	CODE: '2'}
		];
		var dataSource2 = new kendo.data.DataSource({ 
			data : cbo_list2
		});
		createDropDownList('cbo_type_sel', dataSource2, {
			change: function(e) {
				g_sel_mon_type = this.value();
				makeLineChart();
			}
		});
	}
	function makeLineChart() {
		var series = [];

		for (var i = 0; i < g_result_data.length; i++) {
			var data = g_result_data[i];
			var seriesObject = {
				name : $.defaultStr(data.N_DAY + '[' + data.S_BASE_NAME + '('  + data.S_DATA_NAME + ')]'),
				data : [$.defaultStr(data.TIME_00, 0), $.defaultStr(data.TIME_01, 0), $.defaultStr(data.TIME_02, 0), $.defaultStr(data.TIME_03, 0), $.defaultStr(data.TIME_04, 0),
						$.defaultStr(data.TIME_05, 0), $.defaultStr(data.TIME_06, 0), $.defaultStr(data.TIME_07, 0), $.defaultStr(data.TIME_08, 0), $.defaultStr(data.TIME_09, 0),
						$.defaultStr(data.TIME_10, 0), $.defaultStr(data.TIME_11, 0), $.defaultStr(data.TIME_12, 0), $.defaultStr(data.TIME_13, 0), $.defaultStr(data.TIME_14, 0),
						$.defaultStr(data.TIME_15, 0), $.defaultStr(data.TIME_16, 0), $.defaultStr(data.TIME_17, 0), $.defaultStr(data.TIME_18, 0), $.defaultStr(data.TIME_19, 0),
						$.defaultStr(data.TIME_20, 0), $.defaultStr(data.TIME_21, 0), $.defaultStr(data.TIME_22, 0), $.defaultStr(data.TIME_23, 0)]
			};
			if (g_sel_mon_id == data.N_MON_ID) {
				if (g_sel_mon_type == '' || g_sel_mon_type == data.N_MON_TYPE) {
					series.push(seriesObject);
				}
			}
		}
		createChart(series);
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
		var reportGubun = $('input[name="opt_report_gubun"]:checked').val();
		var reportGubunName = '';
		var qry;
		
		if (reportGubun == 'DAY') {
			qry = "ResourceHistoryRetrieveExcelDayQry";
			reportGubunName = '날짜별';
		} else if (reportGubun == 'MONTH') {
			qry = "ResourceHistoryRetrieveExcelMonthQry";
			reportGubunName = '월별';
		} else {
			qry = "ResourceHistoryRetrieveExcelServerQry";
			reportGubunName = '서버별';
		}

		var url = cst.contextPath() + '/watcher/go_history_stats.resource_history.excel.resource_history_excel.htm?req_data=data;' + qry;

		var tempReportRes = [];
		$('input[name="CHK_REPORT_RES"]:checked').each(function() {
			tempReportRes.push($(this).next().text());
		});

		$('#excel_start_date').val($("#start_date").val().replace(/-/gi, ''));
		$('#excel_end_date').val($("#end_date").val().replace(/-/gi, ''));
		$('#excel_report_gubun').val(reportGubun);
		$('#excel_group_code').val($("#group_code").data('kendoDropDownList').value());
		$('#excel_mon_type').val($('#mon_type').val());
		$('#excel_server_type_code').val($('#server_type_code').data('kendoDropDownList').value());
		
		$('#excel_server_group').val($("#group_code").data('kendoDropDownList').text());
		$('#excel_server_type_name').val($("#server_type_code").data('kendoDropDownList').text());
		$('#excel_resource_name').val(tempReportRes.join(','));
		$('#excel_report_gubun_name').val(reportGubunName);
		
		$('#excel_search_type').val($('#SEARCH_TYPE').data('kendoDropDownList').value());
		$('#excel_search_type_name').val($('#SEARCH_TYPE').data('kendoDropDownList').text());
		$('#excel_search_keyword').val($.trim($('#SEARCH_KEYWORD').val()));
		
		$('#excel_down_form').attr({ method : 'post', 'action' : url }).submit();
	}

	// 검색 시 필요한 Parameter Data Plain Object 형식으로 반환
	function fn_get_search_param() {
		return {
			'S_ST_DT' 			: $('#start_date').val().replace(/-/gi, ''),
			'S_ED_DT' 			: $('#end_date').val().replace(/-/gi, ''),
			'S_REPORT_GUBUN' 	: $('input[name="opt_report_gubun"]:checked').val(),
			'N_GROUP_CODE' 		: $("#group_code").data('kendoDropDownList').value(),
			'N_MON_TYPE' 		: $('#mon_type').val(),
			'N_TYPE_CODE'		: $('#server_type_code').data('kendoDropDownList').value(),
			'SEARCH_TYPE'   	: $.trim($('#SEARCH_TYPE').val()),
			'SEARCH_KEYWORD'	: $.trim($('#SEARCH_KEYWORD').val())
		};
	}
</script>

<!-- excel download form -->
<form id="excel_down_form" name="excelDownFrm" style="display:none;">
	<input type="hidden" id="excel_start_date" name="S_ST_DT" value=""/>
	<input type="hidden" id="excel_end_date" name="S_ED_DT" value=""/>
	<input type="hidden" id="excel_report_gubun" name="S_REPORT_GUBUN" value=""/>
	<input type="hidden" id="excel_group_code" name="N_GROUP_CODE" value=""/>
	<input type="hidden" id="excel_mon_type" name="N_MON_TYPE" value=""/>
	<input type="hidden" id="excel_server_type_code" name="N_TYPE_CODE" value=""/>

	<input type="hidden" id="excel_server_group" name="SERVER_GROUP" value=""/>
	<input type="hidden" id="excel_server_type_name" name="SERVER_TYPE_NAME" value=""/>
	<input type="hidden" id="excel_resource_name" name="RESOURCE_NAME" value=""/>
	<input type="hidden" id="excel_report_gubun_name" name="REPORT_GUBUN" value=""/>
	
	<input type="hidden" id="excel_search_type" name="SEARCH_TYPE" value=""/>
	<input type="hidden" id="excel_search_type_name" name="SEARCH_TYPE_NAME" value=""/>
	<input type="hidden" id="excel_search_keyword" name="SEARCH_KEYWORD" value=""/>
</form>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>리소스 이력</h2><span>Home &gt; 이력/통계 조회 &gt; 리소스이력</span></div></div>

<!-- 내용 -->
<!-- 검색영역 -->
<form id="frm" name="frm" method="get">
<div class="history_search">
	<ul>
		<li class="leftbg">
			<!-- 검색항목 -->
			<dl>
				<dd>
					<strong>검색기간</strong>
					<input type="text" name="S_ST_DT" id="start_date" class="input_search" value="" /> ~ <input type="text" name="S_ED_DT" id="end_date" class="input_search" value=""/>
					<input id="SEARCH_TYPE" name="SEARCH_TYPE" class="input_search" value="${param.SEARCH_TYPE}" style="margin-left:30px;width: 80px" />
                	<input type="text" name="SEARCH_KEYWORD" id="SEARCH_KEYWORD" value="${param.SEARCH_KEYWORD}" class="int_f input_search"/>
				</dd>
				<dd>
					<strong>서버그룹 :</strong>
					<input id="group_code" name="N_GROUP_CODE" class="input_search" style="width: 140px" />
					&nbsp;
					<strong>장비타입: </strong>
					<input id="server_type_code" name="N_TYPE_CODE" class="input_search" style="width: 145px;" />
				</dd>
			</dl>
			<dl>
				<dd>
					<strong>표시방법</strong>
					<input type="radio" name="opt_report_gubun" id="opt_report_gubun_equipment" class="input_search" value="SERVER" checked/><label for="opt_report_gubun_equipment">장비별</label>
					<!-- <input type="radio" name="opt_report_gubun" id="opt_report_gubun_day" class="input_search" value="DAY"/><label for="opt_report_gubun_day">날짜별</label>  -->
					<input type="radio" name="opt_report_gubun" id="opt_report_gubun_month" class="input_search" value="MONTH" /><label for="opt_report_gubun_month">월별</label>
				</dd>
				<dd>
					<strong>자원종류</strong>
					<input type="hidden" name="N_MON_TYPE" id="mon_type" value="">
					<input type="checkbox" name="CHK_REPORT_RES" id="chk_report_res_cpu" class="input_search" value="0" checked/><label for="chk_report_res_cpu">CPU</label>
					<input type="checkbox" name="CHK_REPORT_RES" id="chk_report_res_memory" class="input_search" value="1" checked/><label for="chk_report_res_memory">메모리</label>
					<input type="checkbox" name="CHK_REPORT_RES" id="chk_report_res_disk" class="input_search" value="2" checked/><label for="chk_report_res_disk">Disk</label>
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
					<a href="#"><img id="list_button" src="<c:url value="/images/botton/grp_list_on.jpg"/>" alt="목록" /></a>
					<a href="#"><img id="graph_button" src="<c:url value="/images/botton/grp_grp_off.jpg"/>" alt="그래프" /></a>
					<a href="#"><img id="excel_download_button" src="<c:url value="/images/botton/excel.jpg"/>" alt="엑셀저장" /></a>
				</span>
			</td>
			<td class="bgtr1"></td>
		</tr>
		<tr id="contents_tr">
			<!-- 동적생성 -->
		</tr>
		<tr>
			<td class="bgbl1"></td>
			<td class="bgbc1"></td>
			<td class="bgbr1"></td>
		</tr>
	</table>
</div>