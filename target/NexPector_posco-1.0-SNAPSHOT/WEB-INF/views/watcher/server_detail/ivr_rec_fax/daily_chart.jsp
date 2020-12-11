<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<c:url value="/common/js"/>/jqplot/dist/excanvas.js"></script>
<script type="text/javascript" src="<c:url value="/common/js"/>/jqplot/dist/jquery.jqplot.min.js"></script>
<link href="<c:url value="/common/js"/>/jqplot/dist/jquery.jqplot.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

var jqplotData = [];
var plot;
var readyFlag = false;
var timer;

$(document).ready(function(){
	$.ajax({
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

        	plot = $.jqplot('chartdiv', jqplotData,{
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
        },
        error: function(res,error){
            // alert("에러가 발생했습니다.");
        }
	});
});
</script>
</head>
<body>
<div id="chartdiv" style="width:950; height:400px;"></div>
</body>
</html>