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
	var param = {
					N_MON_ID : $('#N_MON_ID').val()
					, CH_NO : $('#CH_NO').val()
					, N_DAY : $('#N_DAY').val()
				};
	
		$.post("<c:url value="/watcher/lst_CtiChannelDailyQry.htm"/>", param, function(str){
		
		var data = eval('('+str.replace(/\"/gi, "")+')');
		var ticks = new Array();
		var strArr = new Array();
		$(data).each(function(idx){
			strArr[idx] = new Array();
			
			strArr[idx] = [
		             	this.TIME_0, this.TIME_1, this.TIME_2, this.TIME_3
		             	, this.TIME_4, this.TIME_5, this.TIME_6, this.TIME_7
		             	, this.TIME_8, this.TIME_9, this.TIME_10, this.TIME_11
		             	, this.TIME_12, this.TIME_13, this.TIME_14, this.TIME_15
		             	, this.TIME_16, this.TIME_17, this.TIME_18, this.TIME_19
		             	, this.TIME_20, this.TIME_21, this.TIME_22, this.TIME_23
		             ];
		});
    	for(var i=0;i<24;i++)
    	{
    		var tmpArr = [i+1, i];
    		ticks[i] = tmpArr;
    	}
    	
    	
    	plot = $.jqplot('chartdiv', strArr,{
    	seriesColors : ["#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#00FFFF", "#FF00FF"]
			, seriesDefaults : {
				lineWidth: 3,
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
	});
});

function popChart(){
	window.open("<c:url value='/watcher/go_server_detail.ivr_channel.daily_history_chart.htm'/>?N_MON_ID=${param.N_MON_ID}&CH_NO=${param.CH_NO}&N_DAY=${param.N_DAY}","blow_chart","width=900, height=430, location=no", true);
}

</script>
</head>
<body>
<form id="chartFrm" name="chartFrm" action="">
<input type="hidden" id="N_MON_ID" name="N_MON_ID" value="${param.N_MON_ID}" />
<input type="hidden" id="CH_NO" name="CH_NO" value="${param.CH_NO}" />
<input type="hidden" id="N_DAY" name="N_DAY" value="${param.N_DAY}" />
<input type="hidden" id="OBJ_TOP" name="OBJ_TOP" value="${param.OBJ_TOP}" />
<input type="hidden" id="OBJ_LEFT" name="OBJ_LEFT" value="${param.OBJ_LEFT}" />
<div id="chartdiv" style="height: 100%;"></div>
</form>
</body>
</html>