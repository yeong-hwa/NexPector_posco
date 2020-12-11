<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';

	$(function() {
		initialize();
	});

	function initialize() {
		// Calendar 초기화
/* 		$("#service_calendar").kendoCalendar({
			format: 'yyyy-MM-dd',
			change: printChart
		});
		var calendar = $("#service_calendar").data("kendoCalendar");
		calendar.value(new Date());
 */
		// 차트 그리기
		printChart();
	}

	function printChart() {
		// var calendar = $("#service_calendar").data("kendoCalendar");

		// 자원 Chart 영역 그리기기
		$.getJSON('/watcher/lst_ServiceLstQry.htm', { 'N_MON_ID' : pMonId })
			.done(function(data) {
				var length = data.length;
				var $grpArea = $('#service_grp_area');
				$grpArea.empty();

				var serviceRealTimeDsArr = [];
				var mapKeys = [];
				for (var i = 0; i < length; i++) {
					var obj = data[i];
					var grpRealtimeAreaId 	= 'grp_realtime_div_' + obj.S_MAP_KEY,
						grpDailyAreaId 		= 'grp_daily_div_' + obj.S_MAP_KEY,
						resourceTitle		= obj.S_MON_TYPE_NAME ? obj.S_MON_TYPE_NAME : (obj.S_MAP_KEY === '0000000' ? 'CPU' : 'Memory');

					$grpArea.append( $('<div/>').css({ 'margin-top' : (i === 0 ? '-30px' : '30px'), float : 'left', width : '100%' })
							.append( $('<div/>').addClass('avaya_stitle1')
									.append( $('<div/>').addClass('st_under')
											.append( $('<h4/>').text(resourceTitle) )
											.append( $('<label/>').addClass('cls_run_chk').attr('id', 'run_' + obj.S_MAP_KEY) )
//											.append( $('<span/>').text('(' + kendo.toString(calendar.value(), 'd') + ' 피크 현황)') ) ) )
											.append( $('<span/>').text('') ) ) )
							.append( $('<div/>').attr('id', grpRealtimeAreaId).addClass('grp1_div chart-wrapper') )
							.append( $('<div/>').attr('id', grpDailyAreaId).addClass('grp2_div chart-wrapper') ) );

					/* var dataSource1 = new kendo.data.ObservableArray([]);
					var categories1 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
					createChart($('#' + grpRealtimeAreaId), dataSource1, categories1, false, false, {transitions : false});
					serviceRealTimeDsArr.push(dataSource1);
					mapKeys.push(obj.S_MAP_KEY);

					var dataSource2 = getDailyChartData(pMonId, obj.S_MAP_KEY, kendo.toString(calendar.value(), 'd'));
					var categories2 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];
					createChart($('#' + grpDailyAreaId), dataSource2, categories2, true, true, {seriesDefaults: {type : "column"}, seriesColors : ['red']}); */
				}

/* 				setInterval(function() {
					for (var i = 0, length = mapKeys.length; i < length; i++) {
						getRealTimeChartData(pMonId, mapKeys[i], serviceRealTimeDsArr[i]);
					}
				}, 2000); */
				fn_run_check();
				setInterval(fn_run_check, 5000);
			});
	}

	function getRealTimeChartData(monId, mapKey, dataSource) {

		var xhr = $.getJSON(cst.contextPath() + "/watcher/map_RealProcessServiceUsageQry2.htm", {
			'N_MON_ID' 		 : monId,
			'S_MAP_KEY' 	 : mapKey
		});

		xhr.done(function(data) {
			if ( dataSource.length > 10 ) {
				dataSource.splice(0, 1);
			}

			var perUse = data.N_NOW_USE ? parseInt(data.N_NOW_USE) : 0;
			dataSource.push( {value:perUse} );
		});

		/*return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					url 		: cst.contextPath() + "/watcher/server_detail/realtime_resource_chart_RealProcessServiceUsageQry2.htm",
					data 		: function() {
						return {
							'N_MON_ID' 		 : monId,
							'S_MAP_KEY' 	 : mapKey
						};
					}
				}
			},
			schema			: {
				data	: function(data) {
					var jsonData = JSON.parse(data);
					var length = jsonData ? jsonData.length : 0;
					var arr = [];
					for (var i = 0; i < length; i++) {
						var obj = { value : jsonData[i] };
						arr.push(obj);
					}
					return arr;
				}
			}
		});*/
	}

	function getDailyChartData(monId, mapKey, day) {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					url 		: cst.contextPath() + "/watcher/map_AccrueServiceUsageQry.htm",
					data 		: function() {
						return {
							'N_MON_ID' 		 : monId,
							'S_MAP_KEY' 	 : mapKey,
							'N_DAY' 	 	 : day.replace(/-/gi, "")
						};
					}
				}
			},
			schema			: {
				data	: function(data) {
					var series = [ { value : $.defaultStr(data.TIME_00, 0) }, { value : $.defaultStr(data.TIME_01, 0) }, { value : $.defaultStr(data.TIME_02, 0) }, { value : $.defaultStr(data.TIME_03, 0) }, { value : $.defaultStr(data.TIME_04, 0) },
						{ value : $.defaultStr(data.TIME_05, 0) }, { value : $.defaultStr(data.TIME_06, 0) }, { value : $.defaultStr(data.TIME_07, 0) }, { value : $.defaultStr(data.TIME_08, 0) }, { value : $.defaultStr(data.TIME_09, 0) },
						{ value : $.defaultStr(data.TIME_10, 0) }, { value : $.defaultStr(data.TIME_11, 0) }, { value : $.defaultStr(data.TIME_12, 0) }, { value : $.defaultStr(data.TIME_13, 0) }, { value : $.defaultStr(data.TIME_14, 0) },
						{ value : $.defaultStr(data.TIME_15, 0) }, { value : $.defaultStr(data.TIME_16, 0) }, { value : $.defaultStr(data.TIME_17, 0) }, { value : $.defaultStr(data.TIME_18, 0) }, { value : $.defaultStr(data.TIME_19, 0) },
						{ value : $.defaultStr(data.TIME_20, 0) }, { value : $.defaultStr(data.TIME_21, 0) }, { value : $.defaultStr(data.TIME_22, 0) }, { value : $.defaultStr(data.TIME_23, 0) }];
					return series;
				}
			}
		});
	}

	function createChart($chartArea, dataSource, categories, categoryAxisVisible, line, opts) {

		var options = {
			dataSource: dataSource,
			autoBind: true,
			legend: {
				position: "bottom"
			},
			seriesColors : ['blue'],
			seriesDefaults: {
				type: "area"
			},
			series: [
				{ field: "value", markers: { visible: false } }
			],
			valueAxis: {
				min : 0,
//				max : 100,
				majorUnit: 1,
				labels: {
					format: "{0}"
				},
				line: {
					visible: true
				},
				axisCrossingValue: 0
			},
			categoryAxis: {
				categories: categories,
				majorGridLines: {
					visible: line
				},
				visible: categoryAxisVisible
			},
			chartArea: {
				height : 150
			},
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#= value #",
				color: "white"
			}
		}

		opts && $.extend(options, opts)

		return $chartArea.kendoChart(options).data('kendoChart');
	}

	function fn_run_check() {
		var param = "N_MON_ID=" + pMonId + "&N_MON_TYPE=4";
		$.getJSON(cst.contextPath() + '/watcher/lst_RealServiceUsageQry.htm', param, function (data) {
			$(".cls_run_chk").each(function () {
				var tmp_obj = this;
				$(data).each(function () {
					if (tmp_obj.id === "run_" + this.S_MAP_KEY) {
						if (Number(this.F_STATUS) === 1) {
							$(tmp_obj).css('color', 'green').html('&nbsp;&nbsp;-&nbsp;(실행중)');
						}
						else {
							$(tmp_obj).css('color', 'red').html('&nbsp;&nbsp;-&nbsp;(중지됨)');
						}
					}
				});
			});
		});
	}
</script>

<form name="frm" method="post">
	<input type="hidden" name="N_MON_TYPE" value="1">
	<input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
	<input type="hidden" name="N_DAY" value="">
</form>

<!-- stitle -->
<div class="avaya_stitle1">
	<div class="st_under"><h4>서비스 정보</h4><span></span></div>
</div>

<!-- table_typ2-1 -->
<div class="cal_grpBox">
	<div class="cal_b">
		<!--달력
		<div id="service_calendar"/>
		-->
	</div>
	<div id="service_grp_area" class="grp_b">
		<%--<div style="margin-top:-30px; float:left; width:100%;">
			<!-- stitle -->
			<div class="avaya_stitle1">
				<div class="st_under"><h4>CPU</h4><span>(2015-05-06 피크 현황)</span></div>
			</div>
			<!-- stitle // -->
			<!--//grp1-->
			<div id="grp1_div" class="grp1_div" >
			</div>
			<!--grp1//-->
			<!--//grp2-->
			<div id="grp2_div" class="grp2_div">
			</div>
			<!--grp2//-->
		</div>

		<div style="margin-top:30px; float:left; width:100%;">
			<!-- stitle -->
			<div class="avaya_stitle1">
				<div class="st_under"><h4>Memory</h4><span>(2015-05-06 피크 현황)</span></div>
			</div>
			<!-- stitle // -->
			<!--//grp1-->
			<div class="grp1_div" >
			</div>
			<!--grp1//-->
			<!--//grp2-->
			<div class="grp2_div">
			</div>
			<!--grp2//-->
		</div>

		<div style="margin-top:30px; float:left; width:100%;">
			<!-- stitle -->
			<div class="avaya_stitle1">
				<div class="st_under"><h4>Disk</h4><span>(2015-05-06 피크 현황)</span></div>
			</div>
			<!-- stitle // -->
			<!--//grp1-->
			<div class="grp1_div" >
			</div>
			<!--grp1//-->
			<!--//grp2-->
			<div class="grp2_div">
			</div>
			<!--grp2//-->
		</div>--%>

	</div>
</div>