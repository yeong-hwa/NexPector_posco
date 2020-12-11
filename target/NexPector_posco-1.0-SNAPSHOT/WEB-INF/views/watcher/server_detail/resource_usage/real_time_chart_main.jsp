<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script language="javascript" type="text/javascript" src="<c:url value="/common/js"/>/jqplot/dist/excanvas.js"></script>
<script src="<c:url value="/common/js"/>/jqplot/dist/jquery.jqplot.min.js" type="text/JavaScript"></script>

<link href="<c:url value="/common/js"/>/jqplot/dist/jquery.jqplot.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">

var timer, strArr, plot, n_mon_id, s_map_key;

$(document).ready(function(){

	$.ajax({
		url:'<c:url value="/watcher/server_detail/realtime_resource_chart_RealResourceUsageQry2.htm"/>',
        type:"post",
        data:{N_MON_ID : $('#N_MON_ID').val(), S_MAP_KEY : $('#S_MAP_KEY').val()},
        dataType : "text",
        success: function(res){
        	//alert(res.replace(/\"/gi, ""));
        	strArr = eval('('+res.replace(/\"/gi, "")+')');
        	plot = $.jqplot('chartdiv', strArr,{
    			seriesDefaults : {
    				lineWidth: 1,
    				markerOptions : {
    					show : false
    				}
    			}
        	, axes: {
        		xaxis: {
        			pad:0
        			, min: 1
        			, max: 10
        			, tickOptions:{
        				show:true
        				, showLabel: false
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
            //alert("에러가 발생했습니다."+res.error);
        }
	});
});

$(function(){
	timer = setInterval(function(){
		$.ajax({
			url:'<c:url value="/watcher/server_detail/realtime_resource_chart_RealResourceUsageQry2.htm"/>',
	        type:"post",
	        data:{N_MON_ID : $('#N_MON_ID').val(), S_MAP_KEY : $('#S_MAP_KEY').val()},
	        dataType : "text",
	        success: function(res){
	        	strArr = eval('('+res.replace(/\"/gi, "")+')');
	        	plot.replot({
	        		data : strArr
	        	});
	        },
	        error: function(res,error){
	            //alert("에러가 발생했습니다."+error);
	        }
		});
	}, 2000);
});

</script>
</head>
<body>
<form id="chartFrm" name="chartFrm" action="">
<input type="hidden" id="N_MON_ID" name="N_MON_ID" value="${param.N_MON_ID}" />
<input type="hidden" id="S_MAP_KEY" name="S_MAP_KEY" value="${param.S_MAP_KEY}" />
<div id="chartdiv" style="height:85px;width:150px;" ></div>
</form>
</body>
</html>