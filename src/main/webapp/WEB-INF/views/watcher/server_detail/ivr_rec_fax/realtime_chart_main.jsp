<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="<c:url value="/common/js"/>/jqplot/dist/excanvas.js"></script>
<script type="text/javascript" src="<c:url value="/common/js"/>/jqplot/dist/jquery.jqplot.min.js"></script>
<link href="<c:url value="/common/js"/>/jqplot/dist/jquery.jqplot.css" rel="stylesheet" type="text/css" />
<!-- @Deprecated -->
<script type="text/javascript">

var realArr = [0,0,0,0,0,0,0,0,0,0];
var jqplotData = [];
var timer, plot;
var readyFlag = false;

$(document).ready(function(){

	jqplotData.push(realArr);

	$.ajax({
		url:'<c:url value="/watcher/server_detail/ivr_rec_fax/realtime_chart_main_${param.VIEW_NAME}.htm"/>',
        type:"post",
        data:{N_MON_ID : $('#N_MON_ID').val(), VIEW_NAME : $('#VIEW_NAME').val()},
        dataType : "json",
        success: function(RES){

        	var result = RES.REALTIME.CHANNEL;

        	if(realArr.length == 10) {
				realArr.shift();
        	}

        	realArr.push(result);

        	plot = $.jqplot('chartdiv', jqplotData, {
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
	        		}
	        	}
    		});

        	readyFlag = true;
        },

        error: function(res,error){
            // alert("에러가 발생했습니다.");
        }
	});
});

$(function() {
	timer = setInterval(function(){

		if (readyFlag) {
			$.ajax({
				url:'<c:url value="/watcher/server_detail/ivr_rec_fax/realtime_chart_main_${param.VIEW_NAME}.htm"/>',
		        type:"post",
		        data:{N_MON_ID : $('#N_MON_ID').val(), VIEW_NAME : $('#VIEW_NAME').val()},
		        dataType : "json",
		        success: function(RES) {

		        	var result = RES.REALTIME.CHANNEL;

		        	if(realArr.length == 10) {
						realArr.shift();
		        	}

		        	realArr.push(result);

		        	plot.replot({
		        		data : jqplotData
		        	});
		        },
		        error: function(res, error) {
					// alert("에러가 발생했습니다.");
				}
			});
		}

	}, 10000);
});

</script>

</head>
<body>
	<form id="chartFrm" name="chartFrm" action="">
		<input type="hidden" id="N_MON_ID" name="N_MON_ID" value="${param.N_MON_ID}" />
		<input type="hidden" id="VIEW_NAME" name="VIEW_NAME" value="${param.VIEW_NAME}" />
		<div id="chartdiv" style="height:85px;width:200px;" ></div>
	</form>
</body>
</html>