<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="javascript" type="text/javascript" src="<c:url value="/common/js"/>/jqplot/dist/excanvas.js"></script>
<script src="<c:url value="/common/js"/>/jqplot/dist/jquery.jqplot.min.js" type="text/JavaScript"></script>

<link href="<c:url value="/common/js"/>/jqplot/dist/jquery.jqplot.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

var timer, strArr, plot, n_mon_id, s_map_key;

$(document).ready(function(){
	$.ajax({
		url:'<c:url value="/watcher/server_detail/accrue_chart_AccrueResourceUsageQry.htm"/>',
        type:"post",
        data:{N_MON_ID : $('#N_MON_ID').val(), S_MAP_KEY : $('#S_MAP_KEY').val(), N_DAY : $('#N_DAY').val()},
        dataType : "text",
        success: function(res){
        	//alert(res);
        	strArr = eval('('+res.replace(/\"/gi, "")+')');
        	//strArr = [[5,1,2,3,4,5,6,7,8,9,0]];

        	var ticks = new Array();

        	for(var i=0;i<24;i++)
        	{
        		var tmpArr = [i+1, i];
        		ticks[i] = tmpArr;
        	}

        	plot = $.jqplot('chartdiv', strArr,{
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
	        			, max:100
	        		}
	        	}
    		});
        },
        error: function(res,error){
            alert("에러가 발생했습니다."+error);
        }
	});
});

function popChart(){
	window.open("<c:url value='/watcher/go_server_detail.resource_usage.daily_history_chart.htm'/>?N_MON_ID=${param.N_MON_ID}&S_MAP_KEY=${param.S_MAP_KEY}&N_DAY=${param.N_DAY}","blow_chart","width=900, height=430, location=no", true);
}
</script>
</head>
<body>
<form id="chartFrm" name="chartFrm" action="">
<input type="hidden" id="N_MON_ID" name="N_MON_ID" value="${param.N_MON_ID}" />
<input type="hidden" id="S_MAP_KEY" name="S_MAP_KEY" value="${param.S_MAP_KEY}" />
<input type="hidden" id="N_DAY" name="N_DAY" value="${param.N_DAY}" />
<div id="chartdiv" style="height: 85px; cursor: pointer;" onclick="javascript:popChart()"></div>
</form>
</body>
</html>