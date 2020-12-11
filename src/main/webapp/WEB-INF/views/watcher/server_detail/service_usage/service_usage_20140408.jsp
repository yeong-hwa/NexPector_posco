<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/views/include/include.jsp" %>

<jsp:useBean id="lst" class="java.util.ArrayList" scope="request"/>

<script src="<c:url value="/common/js/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"/>"></script>
<script src="<c:url value="/common/js/jquery-ui-1.10.3.custom/js/jquery.ui.datepicker-ko.js"/>"></script>
<link rel="stylesheet" href="<c:url value="/common/js/jquery-ui-1.10.3.custom/css/ui-lightness/jquery-ui-1.10.3.custom.css"/>"/>

<script>
	$(function() {
		$( "#datepicker" ).datepicker({
			onSelect : function (dateText, inst){
							fn_dateChange(dateText.replace(/-/g,""));
						}
		});
		
		var date = $("#datepicker").datepicker("getDate");
		fn_dateChange(format_yyyymmdd(date.getFullYear(), date.getMonth() + 1, date.getDate()));
	});
	
	function format_yyyymmdd(year,month,day)
	{
		var str = "";
		
		str += year;
		str += (month<10)?"0"+month:month;
		str += (day<10)?"0"+day:day;
		
		return str;
	}
	
	function fn_dateChange(strDate)
	{		
		document.frm.N_DAY.value = strDate;
		
		$(".peek_stats").text("(" + $( "#datepicker" ).val() + " 피크 현황)");
		
	<c:forEach items="${lst}" var="m" varStatus="vt">
		document.frm.target = "ifm_daily_chart_${m.S_MAP_KEY}";
		document.frm.action = "<c:url value='/watcher/go_server_detail.service_usage.daily_history_chart_main.htm'/>?N_MON_ID=${param.N_MON_ID}&S_MAP_KEY=${m.S_MAP_KEY}&OBJ_TOP=${205+(85*(vt.index+1))}&OBJ_LEFT=200";
		document.frm.submit();
	</c:forEach>
	}
</script>

<style>
.ui-datepicker th { padding: .7em .3em; text-align: center; font-weight: normal; border: 0;  width: 25 }
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default { font-weight: normal; font-size:10px; width:15; padding-bottom: .1px; padding-top: .1px; }
.ui-datepicker { width: 12em; padding: .1em .1em 0; display: none; }
</style>
<body style="background-color: transparent;">
<form name="frm" method="post">
	<input type="hidden" name="S_MAP_KEY" value="1">
    <input type="hidden" name="N_MON_ID" value="${param.N_MON_ID}">
    <input type="hidden" name="N_DAY" value="">
</form>     

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td background="${img2}/tab_lc.jpg">&nbsp;</td>
                <td width="100%" class="pt15">
                	<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="180" align="left" valign="top" class="pt40" style="padding-top: 10px">
								<!-- 검색 달력 시작 -->
	                      		<div id="datepicker"></div>
								<!-- 검색 달력 끝 -->
							</td>
	                        <script>
	                      	var s_key_lst = "";
	                      	function fn_runchk()
                	    	{
                	    		var param = "S_KEY_LST="+s_key_lst;
                	    		
                	    		ajax_reqAction("server_detail.realtime_process_runchk.neonex", param, "callback_runchk");
                	    	}
	                      	
	                      	function callback_runchk(str)
                      		{
                      			var runArr = str.split("//")[0].split("|");
                      			var noRunArr = str.split("//")[1].split("|"); 
                      			
                      			for(i=0;i<runArr.length;i++)
                      			{
                   					var obj = eval("document.all.run_"+runArr[i]);
                   					if($(obj).html() == "")
                      					$(obj).html('<img align="absmiddle" src="${img2}/run_process.gif">');
                      			}
                      			
                      			for(i=0;i<noRunArr.length;i++)
                      			{
                   					var obj = eval("document.all.run_"+noRunArr[i]);
                      				$(obj).html("");
                      			}
                      		}
	                      </script>
	                      <td>
	                      	<c:forEach items="${lst}" var="m" varStatus="vt">
	                      		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		                          <tr>
		                          	<script>
		                          		$(function() {
		                          			s_key_lst += "${param.N_MON_ID};${m.S_MAP_KEY}|";
		                          		});
		                          	<c:if test="${vt.last}">
		                          		$(function() {
		                          			fn_runchk();
		                          			setInterval("fn_runchk()", 5000);
		                          		});
		                          	</c:if>
		                          	</script>
		                            <td height="20" class="b"><img src="${img2}/icon_result.jpg" align="absmiddle">프로세스명 : ${m.S_MON_TYPE_NAME}<span id="run_${m.S_MAP_KEY}"></span></td>
		                            <td align="right" class="text11 pr15 gray_sub peek_stats"></td>
		                          </tr>
		                          <tr>
		                            <td height="75" colspan="2" class="line_gray">
		                            	<iframe name="ifm_realtime_chart_${m.S_MAP_KEY}" src="<c:url value='/watcher/go_server_detail.service_usage.real_time_chart_main.htm'/>?N_MON_ID=${param.N_MON_ID}&S_MAP_KEY=${m.S_MAP_KEY}" width="150" height="80" frameborder="0" scrolling="no"></iframe>
		                            	&nbsp;&nbsp;
		                            	<iframe name="ifm_daily_chart_${m.S_MAP_KEY}" src="" width="620" height="80" frameborder="0" scrolling="no"></iframe>
		                            </td>
		                          </tr>
		                          <tr>
		                            <td height="1" colspan="2" bgcolor="eeeeee"><img src="${img2}/dot.png"></td>
		                          </tr>
		                        </table>
	                      	</c:forEach>
	                      </td>
	                    </tr>
                  </table></td>
                <td background="${img2}/tab_rc.jpg">&nbsp;</td>
              </tr>
              <tr>
                <td><img src="${img2}/tab_lb.jpg"></td>
                <td height="4" background="${img2}/tab_ceb.jpg"><img src="${img2}/dot.png"></td>
                <td><img src="${img2}/tab_rb.jpg"></td>
              </tr>
            </table>
</body>