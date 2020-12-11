<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">

var timer, strArr, plot, n_mon_id, s_map_key;

$(document).ready(function(){
	$.ajax({
		url:'<c:url value="/watcher/server_detail/accrue_chart_AccrueServiceUsageQry.htm"/>',
        type:"post",
        data:{N_MON_ID : $('#N_MON_ID').val(), S_MAP_KEY : $('#S_MAP_KEY').val(), N_DAY : $('#N_DAY').val()},
        dataType : "text",
        success: function(res){
        	strArr = eval('('+res+')');
        	plot = $.jqplot('chartdiv', strArr,{
    			seriesDefaults : {
    				lineWidth: 1,
    				markerOptions : {
    					show : false
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
<div id="chartdiv" style="height: 80px;" ></div>
</form>
</body>
</html>