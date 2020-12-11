<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript">

	var pMonId = '${param.N_MON_ID}';	
	var calendar;

	$(document).ready(function() {
		Initialize();
	});

	function Initialize() {
		// Calendar 초기화
		$("#resource_calendar").kendoCalendar({
			format: 'yyyy-MM-dd',
			change: printChart
		});
		
		calendar = $("#resource_calendar").data("kendoCalendar");
		calendar.value(new Date());

		// 차트 그리기
		printChart();
	}

	function printChart() {
		var calendar = $("#resource_calendar").data("kendoCalendar");

		// 자원 Chart 영역 그리기기
		$.getJSON('/watcher/lst_ResourceLstQry.htm', { 'N_MON_ID' : pMonId })
			.done(function(data) {
				var length = data.length;
				var $grpArea = $('#resource_grp_area');
				$grpArea.empty();

				var resourceRealTimeDsArr = [];
				var mapKeys = [];
				for (var i = 0; i < length; i++) {
					var obj = data[i];
					var grpRealTimeAreaId 	= 'grp_realtime_div_' + obj.S_MAP_KEY,
						grpDailyAreaId 		= 'grp_daily_div_' + obj.S_MAP_KEY,
						resourceTitle		= obj.S_MON_TYPE_NAME ? obj.S_MON_TYPE_NAME : (obj.S_MAP_KEY === '0000000' ? 'CPU' : obj.S_MAP_KEY === '0010000' ? 'Memory' : 'Disk'),
						resourceDiskInfo = "";
					
					if(obj.N_MON_TYPE === 2) {
						if (obj.N_FULL_SIZE < 1024 * 10) {
							resourceDiskInfo = "   (총용량: "+ (obj.N_FULL_SIZE / 1024).toFixed(2) + "GB, " + "사용량: "+ (obj.N_NOW_USE / 1024).toFixed(2) +"GB)";
						}
						else {
							resourceDiskInfo = "   (총용량: "+ Math.ceil(obj.N_FULL_SIZE / 1024) + "GB, " + "사용량: "+ Math.ceil(obj.N_NOW_USE / 1024) +"GB)";						
						}
					} else {
						resourceDiskInfo = "";
					}
					
					$grpArea.append( $('<div/>').css({ 'margin-top' : (i === 0 ? '-30px' : '30px'), float : 'left', width : '100%' })
										.append( $('<div/>').addClass('avaya_stitle1')
													.append( $('<div/>').addClass('st_under')
																.append( $('<h4/>').text(resourceTitle + resourceDiskInfo) )
																.append( $('<span/>').text('(' + kendo.toString(calendar.value(), 'd') + ' 피크 현황)') ) ) )
										.append( $('<div/>').attr('id', grpRealTimeAreaId).addClass('grp1_div chart-wrapper') )
										.append( $('<div/>').attr('id', grpDailyAreaId).addClass('grp2_div chart-wrapper') ) );

					var dataSource1 = new kendo.data.ObservableArray([]);
					var categories1 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
					createChart($('#' + grpRealTimeAreaId), dataSource1, categories1, false, false, {transitions : false});
					resourceRealTimeDsArr.push(dataSource1);
					mapKeys.push(obj.S_MAP_KEY);

					var dataSource2 = getDailyChartDataSource(pMonId, obj.S_MAP_KEY, kendo.toString(calendar.value(), 'd'));
					var categories2 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];
					createChart($('#' + grpDailyAreaId), dataSource2, categories2, true, true, {seriesDefaults: {type : "column"}, seriesColors : ['red'], seriesClick: onSeriesClick, title: {text: obj.S_MAP_KEY, visible: false}} );
				}

				interval.push(setInterval(function() {
					for (var i = 0, length = mapKeys.length; i < length; i++) {
						getRealTimeChartDataSource(pMonId, mapKeys[i], resourceRealTimeDsArr[i]);
					}
				}, 5000));
			});
	}

	function getRealTimeChartDataSource(monId, mapKey, dataSource) {

		var xhr = $.getJSON(cst.contextPath() + "/watcher/map_RealResourceUsageQry2.htm", {
			'N_MON_ID' 		 : monId,
			'S_MAP_KEY' 	 : mapKey
		});

		xhr.done(function(data) {
			if ( dataSource.length > 10 ) {
				dataSource.splice(0, 1);
			}

			var perUse = data.N_PER_USE ? parseInt(data.N_PER_USE) : 0;
			dataSource.push( {value:perUse} );
		}); 
	}

	function getDailyChartDataSource(monId, mapKey, day) {
		return new kendo.data.DataSource({
			transport		: {
				read		: {
					type		: 'post',
					dataType	: 'json',
					url 		: cst.contextPath() + "/watcher/map_AccrueResourceUsageQry.htm",
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
				max : 100,
				majorUnit: 20,
				labels: {
					format: "{0}%"
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
				visible: categoryAxisVisible,
				labels: {
					format: "{0}시"
				}
			},
			chartArea: {
				height : 150
			},
			tooltip: {
				visible: true,
				format: "{0}",
				template: "#= value #%",
				color: "white"
			}
		}

		opts && $.extend(options, opts)

		return $chartArea.kendoChart(options).data('kendoChart');
	}
	
	function pad(n, width, z) {
		z = z || '0';
		n = n + '';
		return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
	}
	
	function onSeriesClick(e) {
        var nDay = kendo.toString(calendar.value(), 'd').replace(/-/gi, "");
        
        var hour = pad(e.category, 2);
        var dateHour = "" + nDay + hour;
    	var sMapKey = e.sender.options.title.text
        
		var param = "N_MON_ID=" + pMonId + "&N_DATE_HOUR=" + dateHour + "&S_MAP_KEY=" + sMapKey;
		var dialogWidth = 900;
		// encodeURIComponent(param);
		$.post(cst.contextPath() + '/watcher/go_server_detail.resource_usage.graph_popup.htm', param)
		.done(function(html) {
			$('#popup')
			.html(html)
			.dialog({
				title			: '리소스 조회',
				resizable		: false,
				width			: dialogWidth,
				height			: 480,
				modal			: true,
				position		: [($(window).width() / 2) - (dialogWidth / 2), 150],
				autoReposition	: true,
				open			: function() {
					$(this).parent().css({top:50, left:($(window).width() / 2) - (dialogWidth / 2)});
				},
				close			: function() {
					$(this).dialog("destroy");
					$('#popup').html("");
				},
				buttons			: {
					"확인": function() {
						$(this).dialog("destroy");
						$('#popup').html("");
					}
				}
			});
		});
    	
    	
	/* 	$.getJSON('/watcher/server_detail/resourceUsingHistory.htm', { 'N_MON_ID' : pMonId, 'S_MAP_KEY' : e.sender.options.title.text, 'N_DATE_HOUR' : "" + dateHour})
		.done(function(data) {
			console.log(data);
			window.open("/watcher/server_detail/resourceUsingGraph.htm?" + param, "width=1250, height=800");
			// window.opener.stickingTargetSearch();
		}); */
        
    }
</script>

<!-- stitle -->
<div class="avaya_stitle1">
	<div class="st_under"><h4>자원 정보</h4></div>
</div>
<!-- stitle // -->
<!-- table_typ2-1 -->
<div class="cal_grpBox">
	<div class="cal_b">
		<!--달력-->
		<div id="resource_calendar"/>
	</div>
	<div id="resource_grp_area" class="grp_b">
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

<div id="popup" />
