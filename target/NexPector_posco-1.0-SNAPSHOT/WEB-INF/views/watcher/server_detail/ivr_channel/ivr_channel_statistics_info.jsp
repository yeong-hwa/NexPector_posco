<%--
    Description : CIMS IVR 채널 통계 페이지
    Date : 2015/07/16
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cmb" uri="/WEB-INF/views/include/taglib/combo_tag.tld"%>


<!-- stitle -->
<div class="avaya_stitle1">
	<div class="st_under">
		<h4>IVR 채널 통계</h4>
		<div class="st_under">
			<span id="dayText" style="color:#666;">(2015-05-06 평균 현황 동시 사용 채널수)</span>
		</div>
	</div>
</div>

<!-- table_typ2-1 -->
<div class="cal_grpBox">
	<div class="cal_b">
		<!--달력-->
		<div id="calendar"/>
	</div>
	<div id="daily_app_chart" class="grp_b">
	</div>
</div>

<%@ include file="/WEB-INF/views/include/include_js.jsp" %>
<script type="text/javascript" src="<c:url value="/js/server-detail.js" />"></script>

<script type="text/javascript">

    var pMonId = '${param.N_MON_ID}';
    var series;
    var timer;
    var pageConfig = { chartRefreshTime : 7000 };
    
    $(document).ready(function() {
        initialize();
    });
    
    function initialize() {
		// Calendar 초기화
		$("#calendar").kendoCalendar({
			format: 'yyyy-MM-dd',
			change: function() {
				getDailyChartData();
			}
		});
		var calendar = $("#calendar").data("kendoCalendar");
		calendar.value(new Date());

       	getDailyChartData(kendo.toString(calendar.value(), 'd'));

        // readChartDataSource();
	}

	function getDailyChartData() {
		clearTimeout(timer);

		var calendar = $("#calendar").data("kendoCalendar");
		$('#dayText').text(kendo.toString(calendar.value(), 'd') + ' 피크 현황');
		
		series = [];
		var searchDay = kendo.toString(calendar.value(), 'd').replace(/-/gi, "");
		
		var colorArray = ["#ff6b2a", "#2f96d0", "#7dd94b", "#d25bb8"];
		
		$.getJSON('/watcher/lst_ivr_channel.ivrStatAppPeakTotal.htm', { 'N_MON_ID' : pMonId, 'S_DAY'  : searchDay})
		.done(function(data) {
			var arr = new Array(24); // 0으로 초기화
			for (var i = 0; i < 24; i ++) {
				arr[i] = 0;
			}
			
			for (var j = 0; j < data.length; j++) { // 값이 있는 것만 배열에 넣어줌
				arr[Number(data[j].S_TIME)] = data[j].N_COUNT;
			}
			
			var seriesObject = {
				name : '총 채널 피크',
				color : "red",
				data : arr
			};
			
			series.push(seriesObject);
			
			// createChart(series);
			
			$.getJSON('/watcher/lst_ivr_channel.ivrStatAppPeak.htm', { 'N_MON_ID' : pMonId, 'S_DAY': searchDay})
			.done(function(data) {
				var arr = new Array(24); // 0으로 초기화
				var monName = ""
				for (var i = 0; i < 24; i ++) {
					arr[i] = 0;
				}
				
				for (var j = 0; j < data.length; j++) { // 값이 있는 것만 배열에 넣어줌
					arr[Number(data[j].S_TIME)] = data[j].N_COUNT;
					monName = data[j].S_MON_NAME;
				}
				
				var seriesObject = {
					name : monName,
					color : "blue",
					data : arr
				};
				
				series.push(seriesObject);
				
				createChart(series);
			});
		});
		
		timer = setTimeout(getDailyChartData, pageConfig.chartRefreshTime);
	}

	function createChart(series) {
		return $('#daily_app_chart').kendoChart({
			autoBind: false,
			legend: {
				position: "bottom"
			},
			seriesColors : ['blue'],
			seriesDefaults: {
				type: "area"
			},
			series: series,
			valueAxis: {
				min : 0,
//				max : 100,
//				majorUnit: 1000,
                labels: {
                    template: "#= kendo.toString(value, 'n0') #채널"
                },
				line: {
					visible: true
				},
				axisCrossingValue: 0
			},
			categoryAxis: {
				categories: ['0시', '1시', '2시', '3시', '4시', '5시', '6시', '7시', '8시', '9시', '10시', '11시', '12시', '13시', '14시', '15시', '16시', '17시', '18시', '19시', '20시', '21시', '22시', '23시'],
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
				// format: "{0}",
				template: "#= series.name #: #= value #채널",
				color: "white"
			}
		}).data('kendoChart');
	}
</script>
