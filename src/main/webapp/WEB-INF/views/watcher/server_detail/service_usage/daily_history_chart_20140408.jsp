<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">

var timer, strArr, plot, n_mon_id, s_map_key;

$(document).ready(function(){
	$.ajax({
		url:'<c:url value="/watcher/server_detail.accrue_service.neonex"/>',
        type:"post",
        data:{N_MON_ID : $('#N_MON_ID').val(), S_MAP_KEY : $('#S_MAP_KEY').val(), N_DAY : $('#N_DAY').val()},
        dataType : "text",
        success: function(res){
strArr = eval('('+res.replace(/\"/gi, "")+')');
			
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
	        		}
	        	}
    		});
        },
        error: function(res,error){
            alert("에러가 발생했습니다."+error);
        }
	});
});
</script>
</head>
<body>
<form id="chartFrm" name="chartFrm" action="">
<input type="hidden" id="N_MON_ID" name="N_MON_ID" value="${param.N_MON_ID}" />
<input type="hidden" id="S_MAP_KEY" name="S_MAP_KEY" value="${param.S_MAP_KEY}" />
<input type="hidden" id="N_DAY" name="N_DAY" value="${param.N_DAY}" />
<div id="chartdiv" style="width:900;height: 80px;" ></div>
</form>
</body>
</html>