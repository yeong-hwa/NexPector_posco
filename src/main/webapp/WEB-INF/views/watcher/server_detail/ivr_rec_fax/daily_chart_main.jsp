<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="<c:url value="/common/kendo-ui/styles/kendo.common.min.css" />" />
<link rel="stylesheet" href="<c:url value="/common/kendo-ui/styles/kendo.default.min.css" />" />
<link rel="stylesheet" href="<c:url value="/common/kendo-ui/styles/kendo.bootstrap.min.css" />" />
<link rel="stylesheet" href="<c:url value="/common/kendo-ui/styles/kendo.dataviz.bootstrap.min.css" />" />

<script type="text/javascript" src="<c:url value="/js/jquery-1.11.2.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/common/kendo-ui/js/kendo.all.min.js" />"></script>
<script type="text/javascript" src="<c:url value="/common/kendo-ui/js/kendo.culture.ko-KR.min.js" />"></script>

<script type="text/javascript">
var jqplotData = [];
var plot;
var readyFlag = false;
var timer;

$(document).ready(function(){

	kendo.culture("ko-KR");

	fn_chart();

	if ('${param.POPUP}' == '') {
		$('#chart').on('click', function() {
			popChart();
		});
	}

	/*$.ajax({
		url:'<c:url value="/watcher/server_detail/ivr_rec_fax/daily_chart_main.htm"/>',
        type:"post",
        data:{SERVICE : ${param.SERVICE}, DATATYPE : ${param.DATATYPE}, CALLTYPE : ${param.CALLTYPE}, SVCDAY : ${param.SVCDAY}, SYSTEMID : ${param.SYSTEMID}},
        dataType : "json",
        success: function(RES) {
        	jqplotData.push(RES.DAILY_STAT);

        	var ticks = new Array();

        	for(var i=0; i<24; i++) {
        		var tmpArr = [i+1, i];
        		ticks[i] = tmpArr;
        	}

        	plot = $.jqplot('chartdiv', jqplotData, {
    			seriesDefaults : {
    				lineWidth: 2,
    				markerOptions : {
    					show : false
    				}
    			}
	        	, axes: {
	        		xaxis: {
	        			pad:0
	        			, min: 1
	        			, max: 25
	        			, ticks : ticks
	        			, tickOptions:{
	        				show: true
	        			}
	        		}
	        		, yaxis: {
	        			min:0
	        		}
	        	}
    		});
        } ,
        error: function(res,error){
            // alert("에러가 발생했습니다.");
        }
	});*/
});

// 차트 조회
function fn_chart() {
	var url 	= '<c:url value="/watcher/server_detail/ivr_rec_fax/daily_chart_main.htm"/>',
		param 	= {SERVICE : ${param.SERVICE}, DATATYPE : ${param.DATATYPE}, CALLTYPE : ${param.CALLTYPE}, SVCDAY : ${param.SVCDAY}, SYSTEMID : ${param.SYSTEMID}};

//	$.blockUI(blockUIOption);
	$.getJSON(url, param)
			.done(function(datas) {
				console.log(datas);

				var series = [];
				var seriesObject = {
					data : datas.DAILY_STAT
				};

				series.push(seriesObject);

				createChart($('#chart'), series);
			})
			.fail(function(jqXHR) {
				console.log(jqXHR.status);
			})
			.always(function() {
//				$.unblockUI();
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
			labels: {
				format: "{0}"
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
			}
		},
		tooltip: {
			visible: true,
			format: "{0}",
			template: "#= value #",
			color: "white"
		}
	});
}

function popChart() {
	var url 	= cst.contextPath() + '/watcher/go_server_detail.ivr_rec_fax.daily_chart_main.htm',
		param 	= {SERVICE : ${param.SERVICE}, DATATYPE : ${param.DATATYPE}, CALLTYPE : ${param.CALLTYPE}, SVCDAY : ${param.SVCDAY}, SYSTEMID : ${param.SYSTEMID}, POPUP : 'Y'};
	window.open(url + '?' + $.param(param),"blow_chart","width=950, height=430, location=no", true);
}
</script>

<div id="chart" onclick="popChart();"></div>