<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="locationBox"><div class="st_under"><h2>운영 현황</h2><span>Home &gt; 운영 현황</span></div></div>

<!-- 내용 -->
<div class="table_div" style="height:505px;">
<!-- 센터별 현황 차트 -->
	<!-- 장비현황 Map -->
	<div id="apDiv_map" name="compo">
		<div class="stitleBox" style="float: none; height: 5px">
			<div class="st_under">
				<!-- <h3 id="map_title">센터 전체 현황</h3> -->
				<span id="memo" style="margin-top: 10px;display: block;">(장비수량/장애수량)</span>
			</div>
		</div>
		<div class="contens_wd100">
			<div id="apDiv2" class="wd101_1">
				<h3>최근 6개월간 등급별 차트</h3>
				<span id="six_month_chart" class="chart-wrapper" style="height: 200px;"></span>
			</div>
			<div id="apDiv7" class="wd101_2">
				<h3>최근 한달간 장애 Top10</h3>
				<span id="month_top5_chart" class="chart-wrapper" style="height: 200px;"></span>
			</div>
			<div id="apDiv3" class="wd101_3">
				<h3>최근 일주일간 장애 Top10</h3>
				<span id="week_top5_chart" class="chart-wrapper" style="height: 200px;"></span>
			</div>
		</div>
		<div class="contens_wd100">
			<div id="apDiv4" class="wd101_1">
				<h3>실시간 사용률 Top10 (CPU)</h3>
				<span id="real_time_cpu_chart" class="chart-wrapper" style="height: 200px;"></span>
			</div>
			<div class="wd101_2">
				<h3>실시간 사용률 Top10 (MEMORY)</h3>
				<span id="real_time_memory_chart" class="chart-wrapper" style="height: 200px;"></span>
			</div>
			<div class="wd101_3">
				<h3>실시간 사용률 Top10 (DISK)</h3>
				<span id="real_time_disk_chart" class="chart-wrapper" style="height: 200px;"></span>
			</div>
		</div>
	</div>
</div>
<!-- 실시간 장애 현황 -->
<div id="apDiv8" name="compo">
	<div class="stitleBox" style="float: none;">
		<div class="st_under" style="height: 30px;">
			<h3>시스템 장애 현황</h3>
			<span style="right: 300px;">센터 :<cmb:combo qryname="cmb_svr_group" firstdata="전체" seltagname="ERR_STATS_N_GROUP_CODE" etc="style=\"width:80;\"" selvalue="${param.N_GROUP_CODE}"/></span>
			<span style="right: 110px;">장비타입 :<cmb:combo qryname="cmb_svr_type" firstdata="전체" seltagname="ERR_STATS_N_TYPE_CODE" etc="style=\"width:80;\"" selvalue="${param.N_TYPE_CODE}"/></span>
			<button type="button" id="btnMulti" style="margin-right: 15px;">다중복구</button>
		</div>
	</div>
	<div id="real_time_error" class="table_typv1"></div>
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript">

	var nGroupCode 		= '${N_GROUP_CODE}';
	var realTimeErrorGrid;
	var test;

	$(document).ready(function () {
		initialize();

		$('#all_check').on('click', function() {
			if (this.checked) {
				$('input[name=S_ALM_KEY]').prop('checked', true);
			} else {
				$('input[name=S_ALM_KEY]').prop('checked', false);
			}
		});

		$('#btnMulti').kendoButton();

		$('#btnMulti').on('click', function(event) {
			event.preventDefault();

			var monId;
			var almKeys = [];

			if ( $('input[name=S_ALM_KEY]:checked').length === 0 ) {
				alert("복구대상 장애항목을 선택해주세요.");
				return;
			}

			$('input[name=S_ALM_KEY]:checked').each(function() {
				almKeys.push(this.value);
			});

			var realTimeErrorDataItem = realTimeErrorGrid.dataSource.data();
			var tmp_realTimeError = "";
			$("input[name=S_ALM_KEY]").each(function(index) {
				if ($("input[name=S_ALM_KEY]")[index].checked == true) {
					monId = realTimeErrorDataItem[index].N_MON_ID;
					if (tmp_realTimeError != "") {
						tmp_realTimeError += ",";
					}
					tmp_realTimeError += realTimeErrorDataItem[index].N_MON_ID + ";" +
							realTimeErrorDataItem[index].S_ALM_KEY
				}
			});

			fn_alarm_history_popup(tmp_realTimeError, monId, almKeys.join(','));
		});

		$('#real_time_error div .k-grid-content table td').on('click', function() {
			var col = $(this).parent().children().index($(this));
		});
	});

	function initialize() {
		// -->
		$("#error_stat_data tr").hover(function () {
			$(this).css("background-color", "DDDDDD");
		}, function () {
			$(this).css("background-color", "");
		});

		// 실시간 장애현황 장비타입 Select Box Change Event
		$("select[name='ERR_STATS_N_TYPE_CODE'], select[name='ERR_STATS_N_GROUP_CODE']").on('change', function() {
			// 그룹 전체 일 경우 에만 Combo box 로 센터 선택가능하고 센터별로 들어갈 경우는 해당 센터 만 조회
			var groupCode = Number(nGroupCode);
			groupCode = $("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val() === '' ?
						-1 :
						$("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val();

			reloadRealTimeDataSource(groupCode, $("select[name='ERR_STATS_N_TYPE_CODE'] option:selected").val());
		});

		// data load
		fn_get_server_info();

		// TODO 일단 주석처리 차후 주석 제거할것!!!! 2016-07-21
		interval.push(window.setInterval(reloadRealTimeDataSource, 10000));
	}

	function fn_get_server_info() {
		$("#six_month_chart").kendoChart({
			legend: {
				position: "top"
			},
			dataSource: {
				transport		: {
					read		: {
						type		: 'post',
						dataType	: 'json',
						url 		: cst.contextPath() + "/watcher/lst_latelyHalfyearStatsQry.htm",
						data 		: function() {
							return {
								'N_GROUP_CODE' : nGroupCode
							};
						}
					}
				},
				sort : {
					field	: "MON",
					dir		: "desc"
				}
			},
			series: [{
				field: "MINOR",
				name: "주의",
				color: "black"
			}, {
				field: "MAJOR",
				name: "경고",
				color: "blue"
			}, {
				field: "CRITICAL",
				name: "위험",
				color: "red"
			}],
			categoryAxis: {
				field: "MON",
				majorGridLines: {
					visible: false
				}
			},
			valueAxis: {
				// majorUnit: 20, 
				line: {
					visible: false
				},
				labels: {
					format: "{0}건"
				}
			},
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#= value #건",
				color: 'white'
			}
		});
		
		
	 	$("#week_top5_chart").kendoChart({
			dataSource: {
				transport		: {
					read		: {
						type		: 'post',
						dataType	: 'json',
						url 		: cst.contextPath() + "/watcher/lst_latelyWeekServerErrorQry.htm",
						data 		: function() {
							return {
								'N_GROUP_CODE' : nGroupCode
							};
						}
					}
				},
			  	schema			: {
					model: {
					     fields: { N_MON_ID: {type: "number"}, S_MON_NAME: {type: "string"}, CNT: {type: "number"} }
					}
				}
			},
			legend: {
				visible: false
			},
			seriesDefaults: {
				type: "bar"
			},
			series: [{
				field : "CNT"
				, color: "#25F01D"
			}],
			valueAxis: {
				line: {
					visible: false
				},
				minorGridLines: {
					visible: true
				},
				labels: {
					format: "{0}건"
				}
			},
			categoryAxis: {
				field: "S_MON_NAME"
			},
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#= value #건",
				color: 'white'
			}
		});
	 	
		createRealTimeAmountUseChart();
	
		 $("#month_top5_chart").kendoChart({
			dataSource: {
				transport		: {
					read		: {
						type		: 'post',
						dataType	: 'json',
						url 		: cst.contextPath() + "/watcher/lst_latelyMonthServerErrorQry.htm",
						data 		: function() {
							return {
								'N_GROUP_CODE' : nGroupCode
							};
						}
					}
				},
			  	schema			: {
					model: {
					     fields: { N_MON_ID: {type: "number"}, S_MON_NAME: {type: "string"}, CNT: {type: "number"} }
					}
				}
			},
			legend: {
				visible: false
			},
			seriesDefaults: {
				type: "bar"
			},
			series: [{
				field : "CNT"
				, color: "#25F01D"
			}],
			valueAxis: {
				line: {
					visible: false
				},
				minorGridLines: {
					visible: true
				},
				labels: {
					format: "{0}건"
				}
			},
			categoryAxis: {
				field: "S_MON_NAME"
			},
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#= value #건",
				color:"white"
			}
		});
	
		printRealTimeErrorGrid();
	}

	// 센터별 상세 페이지 차트 생성
	function createRealTimeAmountUseChart() {
		$("#real_time_cpu_chart").kendoChart(getRealTimeAmountUseChartOption(0));

		$("#real_time_memory_chart").kendoChart(getRealTimeAmountUseChartOption(1));

		$("#real_time_disk_chart").kendoChart(getRealTimeAmountUseChartOption(2));
	}

	// 센터별 상세 페이지 차트 생성 Options
	function getRealTimeAmountUseChartOption(monType) {
		return {
			dataSource: {
				transport		: {
					read		: {
						type		: 'post',
						dataType	: 'json',
						url 		: cst.contextPath() + "/watcher/lst_realtimeResourceTop5.htm",
						data 		: function() {
							return {
								'N_GROUP_CODE' 	: nGroupCode,
								'N_MON_TYPE'	: monType
							};
						}
					}
				},
			  	schema			: {
					model: {
					     fields: { N_MON_ID: {type: "number"}, S_MON_NAME: {type: "string"}, N_PER_USE: {type: "number"} }
					}
				}
			},
			legend: {
				visible: false
			},
			seriesDefaults: {
				type: "bar"
			},
			series: [{
				field : "N_PER_USE"
				, colorField : "N_PER_USE_COLOR"
			}],
			valueAxis: {
				max: 100,
				line: {
					visible: false
				},
				minorGridLines: {
					visible: true
				},
				labels: {
					format: "{0}%"
				}
			},
			categoryAxis: {
				field: "S_MON_NAME"
			},
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#= value #%",
				color: "white"
			}
		}
	}

	// 실시간 장애 현황 그리드
	function printRealTimeErrorGrid() {
		var dataSource = new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					url 		: cst.contextPath() + "/watcher/lst_realtimeErrorStatsQry2.htm",
					data 		: function(data) {

						// 그룹 전체 일 경우 에만 Combo box 로 센터 선택가능하고 센터별로 들어갈 경우는 해당 센터 만 조회
						var groupCode = Number(nGroupCode);
						groupCode = $("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val() === '' ?
									-1 :
									$("select[name='ERR_STATS_N_GROUP_CODE'] option:selected").val();


						return {
							'N_GROUP_CODE' 			: groupCode,
							'ERR_STATS_N_TYPE_CODE' : $("select[name='ERR_STATS_N_TYPE_CODE'] option:selected").val()
						};
					}
				}
			},
			schema			: {
				data	: function(data) {
					return $.isArray(data) ? data : []; // data 가 존재하지 않으면 object('{}') 형식으로 와서 script 에러 발생
				}
			}
		});
		
		realTimeErrorGrid = $("#real_time_error")
				.kendoGrid($.extend({}, kendoGridDefaultOpt, {
					dataSource	: dataSource,
					dataBound	: girdRowdblclick,
					/*
					 dataBound	: function() {
					 // content checkbox 이벤트 등록
					 $('input[name=S_ALM_KEY]').on('change', releaseAllCheckbox);
					 goServerDetailPage("nMonId", "nGroupCode", "error");
					 },
					 change		: function() {
					 goServerDetailPage(this.dataItem(this.select()).N_MON_ID, this.dataItem(this.select()).N_GROUP_CODE, 'error');
					 },
					 */
					columns		: [
						{headerTemplate: '<input type="checkbox" id="all_check" name="ALL_CHECK" value="Y"/>', width:'5%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}, sortable : false, template:kendo.template($('#checkboxTemplate').html())},
						//{width:'5%', attributes:{style:'text-align:center;'}, template : '<img src="<c:url value="/images/botton/ico_aus.gif"/>" alt="">'},
						{field:'S_MON_NAME', title:'장비명', width:'10%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}},
						{field:'S_ALM_MSG', title:'장애내용', width:'60%', attributes:{style:'text-align:left;'}, headerAttributes:{style:'text-align:center;'}},
						{field:'S_ALM_RATING_NAME', title:'등급', width:'10%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}},
						{field:'D_UPDATE_TIME', title:'날짜', width:'15%', attributes:{style:'text-align:center;'}, headerAttributes:{style:'text-align:center;'}}
					],
					scrollable	: true,
					selectable	: 'row',
					height		: 200,
					pageable	: false
				})).data('kendoGrid');
	}

	//Grid dblclick Event
	function girdRowdblclick(e) {

		gridDataBound(e);

		$('input[name=S_ALM_KEY]').on('change', releaseAllCheckbox);

		$('#real_time_error table tr td').on('dblclick', function() {
			if($(this).parent().children().index($(this)) == 0) return;
			goServerDetailPage("nMonId", "nGroupCode", "error");
		});
	}

	function releaseAllCheckbox() {
		$('input[name=S_ALM_KEY]').length === $('input[name=S_ALM_KEY]:checked').length
				? $('#all_check').prop('checked', true)
				: $('#all_check').prop('checked', false);
	}

	// 그리드 Row Select 시에 해당 장애상세페이지로 이동
	function goServerDetailPage(nMonId, nGroupCode, tabStript) {

		if(nMonId === "nMonId" && nGroupCode === "nGroupCode") {
			nMonId = realTimeErrorGrid.dataItem(realTimeErrorGrid.select()).N_MON_ID;
			nGroupCode = realTimeErrorGrid.dataItem(realTimeErrorGrid.select()).N_GROUP_CODE;
		}

		var monId = nMonId;
		var groupCode = nGroupCode ? nGroupCode : '';
		var leftNaviCountPerPage = parseInt('<spring:eval expression="@serviceProps['watcher.detail.navi.countperpage']"/>');
		$.getJSON('<c:url value="/watcher/map_SvrLstByMonIdPageNum.htm"/>', {'MON_ID' : monId, 'N_GROUP_CODE' : groupCode}, function(data) {
			var pageNum = "";
			if(parseInt(data.NUM % leftNaviCountPerPage) > 0) {
				pageNum=parseInt(data.NUM / leftNaviCountPerPage) + 1;
			} else {
				pageNum=parseInt(data.NUM / leftNaviCountPerPage);
			}

			var param = {'N_GROUP_CODE' : groupCode, 'N_MON_ID' : monId, pageNum : pageNum, tabStrip : (tabStript ? tabStript : '')};
			goMenu(document.getElementById('mnavi01_02'), param, 'E'); // watcher_template.jsp 에 선언되어있음.
		});
	}

	function reloadRealTimeDataSource(groupCode, typeCode) {

		realTimeErrorGrid && realTimeErrorGrid.dataSource.read({
			'N_GROUP_CODE' 			: groupCode,
			'ERR_STATS_N_TYPE_CODE' : typeCode
		});
	}

	function createChart(selector, dataSource, extOpt) {

		var chartOpt = {
			dataSource: dataSource,
// 			dataSource:{
// 				data:[{
// 					inCall: 42,
// 					outCall: 31,
// 					companyCall: 53
// 				},{
// 					inCall: 20,
// 					outCall: 10,
// 					companyCall: 30
// 				}]
// 			},
			autoBind: true,
			legend: {
				position: "bottom"
			},
//			seriesColors : ['blue'],
			seriesDefaults: {
				type: "column"
				,style: "smooth"
				,stack:true
			},
			/*series: [
			 { name : "시간별추이", field: "value", markers: { visible: false } }
			 ],*/
			seriesColors : ['blue', 'green', 'red'],
			series		 : [
				{ name : '수신', field : "inCall" },
				{ name : '발신', field : "outCall"},
				{ name : '내선', field : "companyCall"}
			],
			/*valueAxis: {
				min : 0,
				max : 100,
				majorUnit: 1,
				labels: {
					format: "{0}"
				},
				line: {
					visible: true
				},
				axisCrossingValue: 0
			},*/
			categoryAxis: {
				categories: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
				majorGridLines: {
					visible: true
				},
				visible: true
			},
			chartArea: {
				height : 200
			},
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#= series.name #: #= value #",
				color: "white"
			}
		};

		extOpt && $.extend(chartOpt, extOpt);

		return $(selector).kendoChart(chartOpt).data('kendoChart');
	}
</script>

<script id="checkboxTemplate" type="text/x-kendo-template">
	<input type="checkbox" name="S_ALM_KEY" value="#= S_ALM_KEY #"/>
</script>
