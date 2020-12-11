<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/history.js" />"></script>
<script>
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
		
		// Event 등록
		// 목록 and 차트 보기 버튼
		$('#list_button, #graph_button').on('click', function(event) {
			if (this.src.indexOf('_on') > -1) {
				return;
			}
			else {
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

		// 자원종류 DropDownList
		createDropDownList('mon_type', [{ VAL : 'Process', CODE : 3 }, { VAL : 'Service', CODE : 4 }]);

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

		fn_retrieve();
	}

	function fn_retrieve() {
		if ( $('#list_button').attr('src').indexOf('_on') > -1 ) {
			fn_list();
		}
		else if ( $('#graph_button').attr('src').indexOf('_on') > -1 ) {
			fn_chart();
		}
		else {
			fn_chart();
		}
	}
	
	function fn_list(){
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
												.append( $('<h4/>').text('리소스 이력 조회'))))
						.append( $('<div/>').attr('id', 'grid') ))
			.append( $('<td/>').addClass('bgmr1') );

		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					contentType	: 'application/json;charset=UTF-8',
					url 		: cst.contextPath() + "/watcher/kendoPagination_ProcessHistoryRetrieveListQry.htm",
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
				columns		: columns.process()
			}));
	}
	
	function fn_chart() {
		var url = cst.contextPath() + '/watcher/lst_ProcessHistoryRetrieveChartQry.htm';

		$.blockUI(blockUIOption);
		$.get(url, fn_get_search_param())
			.done(function(datas) {
				var $contents = $('#contents_tr'),
					$chartArea = $('<div id="chart" class="grap_area"></div>'); // Chart 영역

				$contents
					.empty()
					.append( $('<td class="bgml1"/>') )
					.append( $('<td class="bgmc1"/>')
							.append( $('<span class="chart_save_bt"><a href="#"><img id="save_chart" src="' + cst.contextPath() + '/images/botton/save_carht.jpg" alt="차트저장" /></a></span>') )
							.append( $chartArea ) )
					.append( $('<td class="bgmr1"/>') );

				// 차트저장 click 이벤트 등록
				$('#save_chart').on('click', function(evnet) {
					evnet.preventDefault();
					var chart = $("#chart").getKendoChart();
					chart.exportImage().done(function(data) {
						kendo.saveAs({
							dataURI: data,
							fileName: "chart.png"
						});
					});

				});

				var jsonDatas = JSON.parse(datas),
					series = [],
					length = $.isArray(jsonDatas) ? jsonDatas.length : 0;

				for (var i = 0; i < length; i++) {
					var data = jsonDatas[i];
					var seriesObject = {
						name : $.defaultStr(data.S_BASE_NAME),
						data : [$.defaultStr(data.TIME_00, 0), $.defaultStr(data.TIME_01, 0), $.defaultStr(data.TIME_02, 0), $.defaultStr(data.TIME_03, 0), $.defaultStr(data.TIME_04, 0),
								$.defaultStr(data.TIME_05, 0), $.defaultStr(data.TIME_06, 0), $.defaultStr(data.TIME_07, 0), $.defaultStr(data.TIME_08, 0), $.defaultStr(data.TIME_09, 0),
								$.defaultStr(data.TIME_10, 0), $.defaultStr(data.TIME_11, 0), $.defaultStr(data.TIME_12, 0), $.defaultStr(data.TIME_13, 0), $.defaultStr(data.TIME_14, 0),
								$.defaultStr(data.TIME_15, 0), $.defaultStr(data.TIME_16, 0), $.defaultStr(data.TIME_17, 0), $.defaultStr(data.TIME_18, 0), $.defaultStr(data.TIME_19, 0),
								$.defaultStr(data.TIME_20, 0), $.defaultStr(data.TIME_21, 0), $.defaultStr(data.TIME_22, 0), $.defaultStr(data.TIME_23, 0)]
					};

					series.push(seriesObject);
				}

				createChart($chartArea, series);
			})
			.fail(function(jqXHR) {
				console.log(jqXHR.status);
			})
			.always(function() {
				$.unblockUI();
			});
	}

	function createChart($chartArea, series) {
		$chartArea.kendoChart({
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
						visible: false
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

	// 검색 시 필요한 Parameter Data Plain Object 형식으로 반환
	function fn_get_search_param() {
		return {
			'S_ST_DT' 			: $('#start_date').val().replace(/-/gi, ''),
			'S_ED_DT' 			: $('#end_date').val().replace(/-/gi, ''),
			'S_REPORT_GUBUN' 	: $('input[name="opt_report_gubun"]:checked').val(),
			'N_GROUP_CODE' 		: $("#group_code").data('kendoDropDownList').value(),
			'N_MON_TYPE' 		: $("#mon_type").data('kendoDropDownList').value(),
			'N_TYPE_CODE'		: $('#server_type_code').data('kendoDropDownList').value()
		};
	}

	// 엑셀 Download
	function fn_excel_download() {
		var url = cst.contextPath() + '/watcher/go_history_stats.process_history.excel.process_history_excel.htm?req_data=data;ProcessHistoryRetrieveChartQry';

		var reportGubun = $("input[name='opt_report_gubun']:checked").val(),
			reportGubunName = '';

		if(reportGubun === 'DAY') {
			reportGubunName = '날짜별';
		}
		else if (reportGubun === 'MONTH') {
			reportGubunName = '월별';
		}
		else if (reportGubun === 'SERVER') {
			reportGubunName = '서버별';
		}

		$('#excel_start_date').val($("#start_date").val().replace(/-/gi, ""));
		$('#excel_end_date').val($("#end_date").val().replace(/-/gi, ""));
		$('#excel_server_group').val($("#group_code").data('kendoDropDownList').text());
		$('#excel_server_type_name').val($("#server_type_code").data('kendoDropDownList').text());
		$('#excel_resource_name').val($("#mon_type").data('kendoDropDownList').text());
		$('#excel_report_gubun').val(reportGubun);
		$('#excel_report_gubun_name').val(reportGubunName);
		$('#excel_mon_type').val($("#mon_type").data('kendoDropDownList').value());
		$('#excel_down_form').attr({ method : 'post', 'action' : url }).submit();
	}
</script>

<!-- excel download form -->
<form id="excel_down_form" name="excelDownFrm" style="display:none;">
	<input type="hidden" id="excel_start_date" name="S_ST_DT" value=""/>
	<input type="hidden" id="excel_end_date" name="S_ED_DT" value=""/>
	<input type="hidden" id="excel_server_group" name="SERVER_GROUP" value=""/>
	<input type="hidden" id="excel_server_type_name" name="SERVER_TYPE_NAME" value=""/>
	<input type="hidden" id="excel_resource_name" name="RESOURCE_NAME" value=""/>
	<input type="hidden" id="excel_report_gubun" name="S_REPORT_GUBUN" value=""/>
	<input type="hidden" id="excel_report_gubun_name" name="REPORT_GUBUN" value=""/>
	<input type="hidden" id="excel_mon_type" name="N_MON_TYPE" value=""/>
</form>

<!-- location -->
<div class="locationBox"><div class="st_under"><h2>프로세스/서비스 이력</h2><span>Home &gt; 이력/통계 조회 &gt; 프로세스/서비스 이력</span></div></div>
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
					<input type="date" name="S_ST_DT" id="start_date" class="input_search" value="2015-04-04" disabled="disabled" /> ~ <input type="date" name="S_ED_DT" id="end_date" class="input_search" value="2015-04-04" disabled="disabled" />
				</dd>
				<dd>
					<strong>서버그룹 / 장비타입</strong>
					<input id="group_code" name="N_GROUP_CODE" class="input_search" style="width: 140px" />
					&nbsp;
					<input id="server_type_code" name="N_TYPE_CODE" class="input_search" style="width: 145px;" />
				</dd>
			</dl>
			<dl>
				<dd>
					<strong>표시방법</strong>
					<input type="radio" name="opt_report_gubun" id="opt_report_gubun_day" class="input_search" value="DAY" checked/><label for="opt_report_gubun_day">날짜별</label>
					<input type="radio" name="opt_report_gubun" id="opt_report_gubun_month" class="input_search" value="MONTH" /><label for="opt_report_gubun_month">월별</label>
					<input type="radio" name="opt_report_gubun" id="opt_report_gubun_equipment" class="input_search" value="SERVER" /><label for="opt_report_gubun_equipment">장비별</label>
				</dd>
				<dd>
					<strong>자원종류</strong>
					<input id="mon_type" name="N_MON_TYPE" class="input_search" style="width: 140px" />
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
<!-- his_contBox // -->
<!-- 내용 // -->